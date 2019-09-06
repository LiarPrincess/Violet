import Core
import Parser
import Bytecode

// In CPython:
// Python -> compile.c

// swiftlint:disable file_length

public struct CompilerOptions {

  /// True if in interactive mode (REPL)
  public var isInteractive: Bool

  /// Controls various sorts of optimizations
  ///
  /// Possible values:
  /// - 0 - no optimizations (default)
  /// - 1 or more - optimize. Tries to reduce code size and execution time.
  public let optimizationLevel: UInt8

  public init(isInteractive:     Bool = false,
              optimizationLevel: UInt8 = 0) {
    self.isInteractive = isInteractive
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
    fatalError("[BUG] Compiler: Using nil current code object.")
  }

  /// Scope that we are currently filling (top of the `self.scopeStack`).
  internal var currentScope: SymbolScope {
    if let last = self.unitStack.last { return last.scope }
    fatalError("[BUG] Compiler: Using nil current scope.")
  }

  /// How far are we inside module/class/function scopes.
  internal var nestLevel: Int {
    return self.unitStack.count
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
    case let .single(stmts),
         let .fileInput(stmts):
      try self.visitStatements(stmts)
    case let .expression(expr):
      try self.visitExpression(expr)
    }

    // Emit epilog (because we may be a jump target).
    try self.codeObject.emitNop(location: self.ast.end)

    assert(self.unitStack.count == 1)
    return self.codeObject
  }

  // MARK: - Scope/Code object

  /// Push new scope (and generate a new code object to emit to).
  ///
  /// compiler_enter_scope(struct compiler *c, identifier name, ...)
  internal func enterScope<N: ASTNode>(node: N, type: CodeObjectType) {
    guard let scope = self.symbolTable.scopeByNode[node] else {
      fatalError("[BUG] Compiler: Entering scope that is not present in symbol table.")
    }

    assert(self.isMatchingScopeType(scope.type, to: type))

    let name = scope.name
    let qualifiedName = self.createQualifiedName(for: name, type: type)
    let object = CodeObject(name: name,
                            qualifiedName: qualifiedName,
                            type: type,
                            line: node.start.line)

    let className = type == .class ? name : nil
    let unit = CompilerUnit(codeObject: object,
                            scope: scope,
                            className: className)

    self.unitStack.append(unit)
  }

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

  /// Pop scope (along with correcsponding code object).
  ///
  /// compiler_exit_scope(struct compiler *c)
  internal func leaveScope() -> CodeObject {
    guard let unit = self.unitStack.popLast() else {
      fatalError("[BUG] Compiler: Attempting to pop non-existing unit.")
    }

    assert(self.unitStack.any, "Popped top scope.")
    assert(
      unit.codeObject.labels.allSatisfy { $0 != Label.notAssigned },
      "One of the labels does not have assigned address."
    )

    return unit.codeObject
  }

  // MARK: - Block

  /// compiler_push_fblock(struct compiler *c, enum fblocktype t, basicblock *b)
  internal func pushBlock(_ type: BlockType) {
    self.blockStack.push(type)
  }

  /// compiler_pop_fblock(struct compiler *c, enum fblocktype t, basicblock *b)
  internal func popBlock() {
    assert(self.blockStack.any)
    _ = self.blockStack.popLast()
  }

  // MARK: - Mangled/qualified name

  internal func mangleName(_ name: String) -> MangledName {
    let unit = self.unitStack.last { $0.className != nil }
    return MangledName(className: unit?.className, name: name)
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
  internal func createQualifiedName(for name: String,
                                    type: CodeObjectType) -> String {

    // Top scope has "" as qualified name.
    guard let parent = self.unitStack.last else {
      return ""
    }

    /// Is this a special case? (see docstring)
    let isGlobal: Bool = {
      guard type == .function || type == .asyncFunction || type == .class else {
        return false
      }

      let mangled = MangledName(className: parent.className, name: name)
      let info = parent.scope.symbols[mangled]
      return info?.flags.contains(.srcGlobalExplicit) ?? false
    }()

    if isGlobal {
      return name
    }

    let pt = parent.codeObject.type
    let isFunction = pt == .function || pt == .asyncFunction || pt == .lambda
    let locals = isFunction ? ".<locals>" : ""

    return parent.codeObject.qualifiedName + locals + "." + name
  }

  // MARK: - Error/warning

  /// Create parser warning
  internal func warn(_ warning: CompilerWarning,
                     location:  SourceLocation) {
    // uh... oh... well that's embarrassing...
  }

  /// Create compiler error
  internal func error(_ kind: CompilerErrorKind,
                      location: SourceLocation) -> CompilerError {
    return CompilerError(kind, location: location)
  }

  // MARK: - Docstring

  /// compiler_isdocstring(stmt_ty s)
  internal func isDocString(_ stmt: Statement) -> Bool {
    return self.getDocString(stmt) != nil
  }

  internal func getDocString(_ stmt: Statement) -> String? {
    // TODO: we have similiar code in future as 'isStringLiteral'
    guard case let StatementKind.expr(expr) = stmt.kind else {
      return nil
    }

    guard case let ExpressionKind.string(group) = expr.kind else {
      return nil
    }

    switch group {
    case let .literal(s): return s
    case .formattedValue, .joined: return nil
    }
  }

  // MARK: - Not implemented

  internal func notImplemented() -> Error {
    // TODO: remove this
    return NotImplemented.pep401
  }
}
