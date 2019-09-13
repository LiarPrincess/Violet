import Core
import Parser
import Bytecode

// In CPython:
// Python -> compile.c

// swiftlint:disable file_length

public struct CompilerOptions {

  /// Controls various sorts of optimizations
  ///
  /// Possible values:
  /// - 0 - no optimizations (default)
  /// - 1 or more - optimize. Tries to reduce code size and execution time.
  public let optimizationLevel: UInt8

  public init(optimizationLevel: UInt8 = 0) {
    self.optimizationLevel = optimizationLevel
  }
}

public final class Compiler {

  /// Program that we are compiling.
  private let ast: AST
  /// Compilation options.
  internal let options: CompilerOptions

  /// We have to scan '\_\_future\_\_' (as weird as it sounds), to block any
  /// potential '\_\_future\_\_' imports that occur later in file.
  internal let future: FutureFeatures

  /// Symbol table assiciated with `self.ast`.
  private let symbolTable: SymbolTable

  /// Compiler unit stack.
  /// Current unit (the one that we are emmiting to) is at the top,
  /// top (module) unit is at the bottom.
  ///
  /// For example:
  /// ```c
  /// class Frozen:
  ///   def elsa():
  ///     pass <- we are emitting here
  /// ```
  /// Generates following stack:
  /// top -> class -> elsa
  private var unitStack = [CompilerUnit]()

  /// Code object that we are currently filling (top of the `self.codeObjectStack`).
  internal var codeObject: CodeObject {
    if let last = self.unitStack.last { return last.codeObject }
    fatalError("[BUG] Compiler: Using `codeObject` with empty `unitStack`.")
  }

  /// Code object builder for `self.codeObject`.
  internal var builder: CodeObjectBuilder {
    if let last = self.unitStack.last { return last.builder }
    fatalError("[BUG] Compiler: Using `builder` with empty `unitStack`.")
  }

  /// Scope that we are currently filling (top of the `self.scopeStack`).
  internal var currentScope: SymbolScope {
    if let last = self.unitStack.last { return last.scope }
    fatalError("[BUG] Compiler: Using `currentScope` with empty `unitStack`.")
  }

  /// How far are we inside module/class/function scopes.
  internal var nestLevel: Int {
    return self.unitStack.count
  }

  /// True if in interactive mode (REPL)
  internal var isInteractive: Bool {
    return self.ast.kind.isInteractive
  }

  /// Stack of blocks (loop, except, finallyTry, finallyEnd)
  /// that current statement is surrounded with.
  internal var blockStack = [BlockType]()
  /// Does the current statement is inside of the loop?
  internal var isInLoop: Bool {
    return self.blockStack.contains { $0.isLoop }
  }

  public init(ast: AST, options: CompilerOptions) throws {
    self.ast = ast
    self.options = options

    let symbolTableBuilder = SymbolTableBuilder()
    self.symbolTable = try symbolTableBuilder.visit(ast)

    let futureBuilder = FutureBuilder()
    self.future = try futureBuilder.parse(ast: ast)
  }

  // MARK: - Run

  /// PyAST_CompileObject(mod_ty mod, PyObject *filename, PyCompilerFlags ...)
  /// compiler_mod(struct compiler *c, mod_ty mod)
  public func run() throws -> CodeObject {
    // Have we already compiled?
    if self.unitStack.count == 1 {
      return self.codeObject
    }

    self.enterScope(node: ast, type: .module)

    switch self.ast.kind {
    case let .interactive(stmts):
      if self.hasAnnotations(stmts) {
        try self.builder.appendSetupAnnotations(at: self.ast.start)
      }
      try self.visitStatements(stmts)
    case let .module(stmts):
      try self.visitBody(stmts)
    case let .expression(expr):
      try self.visitExpression(expr)
    }

    // Emit epilog (because we may be a jump target).
    if !self.currentScope.hasReturnValue {
      if !self.ast.kind.isExpression {
        try self.builder.appendNone(at: self.ast.end)
      }
      try self.builder.appendReturn(at: self.ast.end)
    }

    assert(self.unitStack.count == 1)
    return self.codeObject
  }

  /// Compile a sequence of statements, checking for a docstring
  /// and for annotations.
  ///
  /// compiler_body(struct compiler *c, asdl_seq *stmts)
  private func visitBody(_ stmts: [Statement]) throws {
    if self.hasAnnotations(stmts) {
      try self.builder.appendSetupAnnotations(at: self.ast.start)
    }

    guard let first = stmts.first else {
      return
    }

    if let doc = first.getDocString(), self.options.optimizationLevel < 2 {
      let __doc__ = SpecialIdentifiers.__doc__
      try self.builder.appendString(doc, at: first.start)
      try self.builder.appendStoreName(__doc__, at: first.start)

      try self.visitStatements(stmts.dropFirst())
    } else {
      try self.visitStatements(stmts)
    }
  }

  /// Search if variable annotations are present statically in a block.
  ///
  /// find_ann(asdl_seq *stmts)
  private func hasAnnotations<S: Sequence>(_ stmts: S) -> Bool
    where S.Element == Statement {
    return stmts.contains{ [unowned self] in self.hasAnnotations($0) }
  }

  /// Search if variable annotations are present statically in a block.
  ///
  /// find_ann(asdl_seq *stmts)
  private func hasAnnotations(_ stmt: Statement) -> Bool {
    switch stmt.kind {
    case .annAssign:
      return true
    case let .for(_, _, body, orElse),
         let .asyncFor(_, _, body, orElse),
         let .while(_, body, orElse),
         let .if(_, body, orElse):
      return self.hasAnnotations(body) || self.hasAnnotations(orElse)
    case let .with(_, body),
         let .asyncWith(_, body):
      return self.hasAnnotations(body)
    case let .try(body, handlers, orElse, finally):
      return self.hasAnnotations(body)
          || self.hasAnnotations(finally)
          || self.hasAnnotations(orElse)
          || handlers.contains { [unowned self] in self.hasAnnotations($0.body) }
    default:
      return false
    }
  }

  // MARK: - Scope/code object

  /// Helper for creation of new code objects.
  /// It surrounds given `block` with `enterScope` and `leaveScope`
  /// (1 scope = 1 code object).
  /// Use `self.codeObject` to emit instructions.
  internal func inNewCodeObject<N: ASTNode>(
    node: N,
    type: CodeObjectType,
    emitInstructions block: () throws -> Void) throws -> CodeObject {

    self.enterScope(node: node, type: type)
    try block()
    let code = self.codeObject
    try self.leaveScope()

    return code
  }

  /// Push new scope (and generate a new code object to emit to).
  ///
  /// compiler_enter_scope(struct compiler *c, identifier name, ...)
  private func enterScope<N: ASTNode>(node: N, type: CodeObjectType) {
    guard let scope = self.symbolTable.scopeByNode[node] else {
      fatalError(
        "[BUG] Compiler: Entering scope that is not present in symbol table.")
    }

    assert(self.isMatchingScopeType(scope.type, to: type))

    let name = self.createName(type: type, scope: scope)
    let qualifiedName = self.createQualifiedName(for: name, type: type)

    let varNames = scope.varNames
    let freeVars = self.getSymbols(scope, withAnyOf: [.defFree, .defFreeClass])
    var cellVars = self.getSymbols(scope, withAnyOf: .cell)

    // append implicit __class__ cell.
    if scope.needsClassClosure {
      assert(scope.type == .class) // needsClassClosure can only be set on class
      cellVars.append(MangledName(from: SpecialIdentifiers.__class__))
    }

    let object = CodeObject(name: name,
                            qualifiedName: qualifiedName,
                            type: type,
                            varNames: varNames,
                            freeVars: freeVars,
                            cellVars: cellVars,
                            line: node.start.line)

    let className = type == .class ? name : nil
    let unit = CompilerUnit(scope: scope, codeObject: object, className: className)
    self.unitStack.append(unit)
  }

  /// Pop scope (along with correcsponding code object).
  ///
  /// compiler_exit_scope(struct compiler *c)
  private func leaveScope() throws {
    guard let unit = self.unitStack.popLast() else {
      fatalError("[BUG] Compiler: Attempting to pop non-existing unit.")
    }

    assert(self.unitStack.any, "Popped top scope.")
    assert(
      unit.codeObject.labels.allSatisfy { $0 != Label.notAssigned },
      "One of the labels does not have assigned address."
    )
  }

  // MARK: - Scope/code object helpers

  private func isMatchingScopeType(_ scopeType: ScopeType,
                                   to codeObjectType: CodeObjectType) -> Bool {
    switch scopeType {
    case .module:
      return codeObjectType == .module
    case .class:
      return codeObjectType == .class
    case .function:
      return codeObjectType == .function
        || codeObjectType == .asyncFunction
        || codeObjectType == .lambda
        || codeObjectType == .comprehension
    }
  }

  /// Crate CodeObject name
  private func createName(type: CodeObjectType, scope: SymbolScope) -> String {
    switch type {
    case .module: return CodeObject.moduleName
    case .lambda: return CodeObject.lambdaName
    case .comprehension: return scope.name
    case .class,
         .function,
         .asyncFunction:
      return scope.name
    }
  }

  /// compiler_set_qualname(struct compiler *c)
  ///
  /// Special case:
  /// ```
  /// def elsa(): print('elsa')
  ///
  /// def redefine_elsa():
  ///   global elsa
  ///   def elsa(): print('anna') <- qualified name: elsa
  ///
  /// elsa() # prints 'elsa'
  /// redefine_elsa()
  /// elsa() # prints 'anna'
  /// ```
  /// - Note:
  /// It has to be called BEFORE code object is pushed on stack!
  /// (which is different than CPython)
  private func createQualifiedName(for name: String, type: CodeObjectType) -> String {
    // Top scope has "" as qualified name.
    guard let parent = self.unitStack.last else {
      return ""
    }

    let isTopLevel = self.unitStack.count == 1
    if isTopLevel {
      return name
    }

    /// Is this a special case? (see docstring)
    let isGlobalNestedInOtherScope: Bool = {
      guard type == .function || type == .asyncFunction || type == .class else {
        return false
      }

      let mangled = MangledName(className: parent.className, name: name)
      let info = parent.scope.symbols[mangled]
      return info?.flags.contains(.srcGlobalExplicit) ?? false
    }()

    if isGlobalNestedInOtherScope {
      return name
    }

    /// Otherwise just concat to parent
    let parentType = parent.codeObject.type
    let isParentFunction = parentType == .function
                        || parentType == .asyncFunction
                        || parentType == .lambda

    let locals = isParentFunction ? ".<locals>" : ""
    return parent.codeObject.qualifiedName + locals + "." + name
  }

  /// dictbytype(PyObject *src, int scope_type, int flag, Py_ssize_t offset)
  ///
  /// If the scope of a name matches either scope_type or flag is set,
  /// insert it into the new dict.
  private func getSymbols(_ scope: SymbolScope,
                          withAnyOf flags: SymbolFlags) -> [MangledName] {
    // Sort the keys so that we have a deterministic order on the indexes
    // saved in the returned dictionary.
    // These indexes are used as indexes into the free and cell var storage.

    var result = [MangledName]()
    let sortedNames = scope.symbols.keys.sorted { $0.value < $1.value }

    for name in sortedNames {
      // swiftlint:disable:next force_unwrapping
      let symbol = scope.symbols[name]!
      if symbol.flags.containsAny(flags) {
        result.append(name)
      }
    }

    return result
  }

  // MARK: - Block

  /// Push block, execute `body` and then pop block.
  internal func inBlock(_ type: BlockType, body: () throws -> Void) rethrows {
    self.pushBlock(type)
    defer { popBlock() }

    try body()
  }

  /// compiler_push_fblock(struct compiler *c, enum fblocktype t, basicblock *b)
  private func pushBlock(_ type: BlockType) {
    self.blockStack.push(type)
  }

  /// compiler_pop_fblock(struct compiler *c, enum fblocktype t, basicblock *b)
  private func popBlock() {
    assert(self.blockStack.any)
    _ = self.blockStack.popLast()
  }

  // MARK: - Helpers

  internal func mangleName(_ name: String) -> MangledName {
    let unit = self.unitStack.last { $0.className != nil }
    return MangledName(className: unit?.className, name: name)
  }

  // MARK: - Error/warning

  /// Create parser warning
  internal func warn(_ warning: CompilerWarning, location:  SourceLocation) {
    // uh... oh... well that's embarrassing...
  }

  /// Create compiler error
  internal func error(_ kind: CompilerErrorKind,
                      location: SourceLocation) -> CompilerError {
    return CompilerError(kind, location: location)
  }

  // MARK: - Not implemented
  // TODO: Implement this

  internal func notImplementedAsync() -> Error {
    return NotImplemented.pep401
  }

  internal func notImplementedComprehension() -> Error {
    return NotImplemented.pep401
  }
}
