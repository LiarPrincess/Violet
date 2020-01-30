import Core
import Parser
import Bytecode

// In CPython:
// Python -> compile.c

// swiftlint:disable file_length

public final class Compiler: ASTVisitor, StatementVisitor, ExpressionVisitor {

  public typealias ASTResult = Void
  public typealias ASTPayload = Void
  public typealias StatementResult = Void
  public typealias StatementPayload = Void
  public typealias ExpressionResult = Void
  public typealias ExpressionPayload = Void

  /// Program that we are compiling.
  private let ast: AST
  /// Name of the file that this code object was loaded from.
  public let filename: String
  /// Compilation options.
  internal let options: CompilerOptions

  /// We have to scan `__future__` (as weird as it sounds), to block any
  /// potential `__future__` imports that occur later in file.
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

  /// Code object that we are currently filling.
  internal var codeObject: CodeObject {
    if let last = self.unitStack.last { return last.codeObject }
    fatalError("[BUG] Compiler: Using `codeObject` with empty `unitStack`.")
  }

  /// Code object builder for `self.codeObject`.
  internal var builder: CodeObjectBuilder {
    if let last = self.unitStack.last { return last.builder }
    fatalError("[BUG] Compiler: Using `builder` with empty `unitStack`.")
  }

  /// Scope that we are currently filling.
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
    return self.ast is InteractiveAST
  }

  /// Stack of blocks (loop, except, finallyTry, finallyEnd)
  /// that current statement is surrounded with.
  internal var blockStack = [BlockType]()
  /// Does the current statement is inside of the loop?
  internal var isInLoop: Bool {
    return self.blockStack.contains { $0.isLoop }
  }

  public init(ast: AST, filename: String, options: CompilerOptions) throws {
    self.ast = ast
    self.filename = filename
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
    self.setAppendLocation(ast)

    try self.visit(ast)

    // Emit epilog (because we may be a jump target).
    if !self.currentScope.hasReturnValue {
      let isExpression = ast is ExpressionAST
      if !isExpression {
        self.builder.appendNone()
      }
      self.builder.appendReturn()
    }

    assert(self.unitStack.count == 1)
    return self.codeObject
  }

  internal func visit(_ node: AST) throws {
    self.setAppendLocation(node)
    try node.accept(self, payload: ())
  }

  public func visit(_ node: InteractiveAST) throws {
    if self.hasAnnotations(node.statements) {
      self.builder.appendSetupAnnotations()
    }
    try self.visit(node.statements)
  }

  /// Compile a sequence of statements, checking for a docstring
  /// and for annotations.
  ///
  /// compiler_body(struct compiler *c, asdl_seq *stmts)
  public func visit(_ node: ModuleAST) throws {
    if self.hasAnnotations(node.statements) {
      self.builder.appendSetupAnnotations()
    }

    guard let first = node.statements.first else {
      return
    }

    if let doc = first.getDocString(), self.options.optimizationLevel < .OO {
      self.builder.appendString(doc)
      self.builder.appendStoreName(SpecialIdentifiers.__doc__)
      try self.visit(node.statements.dropFirst())
    } else {
      try self.visit(node.statements)
    }
  }

  public func visit(_ node: ExpressionAST) throws {
    try self.visit(node.expression)
  }

  /// Search if variable annotations are present statically in a block.
  ///
  /// find_ann(asdl_seq *stmts)
  private func hasAnnotations<S: Sequence>(_ stmts: S) -> Bool
    where S.Element == Statement {
    return stmts.contains { [unowned self] in self.hasAnnotations($0) }
  }

  /// Search if variable annotations are present statically in a block.
  ///
  /// find_ann(asdl_seq *stmts)
  private func hasAnnotations(_ statement: Statement) -> Bool {
    if statement is AnnAssignStmt {
      return true
    }

    if let loop = statement as? ForStmt {
      return self.hasAnnotations(loop.body) || self.hasAnnotations(loop.orElse)
    }

    if let loop = statement as? AsyncForStmt {
      return self.hasAnnotations(loop.body) || self.hasAnnotations(loop.orElse)
    }

    if let loop = statement as? WhileStmt {
      return self.hasAnnotations(loop.body) || self.hasAnnotations(loop.orElse)
    }

    if let iff = statement as? IfStmt {
      return self.hasAnnotations(iff.body) || self.hasAnnotations(iff.orElse)
    }

    if let with = statement as? WithStmt {
      return self.hasAnnotations(with.body)
    }

    if let with = statement as? AsyncWithStmt {
      return self.hasAnnotations(with.body)
    }

    if let tryy = statement as? TryStmt {
      return self.hasAnnotations(tryy.body)
        || self.hasAnnotations(tryy.finally)
        || self.hasAnnotations(tryy.orElse)
        || tryy.handlers.contains { self.hasAnnotations($0.body) }
    }

    return false
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
      trap("[BUG] Compiler: Entering scope that is not present in symbol table.")
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
                            filename: self.filename,
                            type: type,
                            varNames: varNames,
                            freeVars: freeVars,
                            cellVars: cellVars,
                            firstLine: node.start.line)

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

  private var appendLocation = SourceLocation.start

  /// Set location on which next `append` occurs.
  ///
  /// Called before entering:
  /// - AST
  /// - Expression
  /// - Statement
  /// - Alias
  /// - ExceptHandler
  internal func setAppendLocation<N: ASTNode>(_ node: N) {
    self.appendLocation = node.start
    for unit in self.unitStack {
      unit.builder.setAppendLocation(self.appendLocation)
    }
  }

  // MARK: - Error/warning

  /// Create parser warning
  internal func warn(_ warning: CompilerWarning) {
    // uh... oh... well that's embarrassing...
  }

  /// Create compiler error
  internal func error(_ kind: CompilerErrorKind) -> CompilerError {
    return CompilerError(kind, location: self.appendLocation)
  }
}
