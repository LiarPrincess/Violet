import Core
import Parser
import Bytecode

// In CPython:
// Python -> compile.c

public final class Compiler {

  private var codeObjectStack = [CodeObject]()

  /// Code object that we are currently filling (top of the `self.codeObjectStack`).
  internal var currentCodeObject: CodeObject {
    if let last = self.codeObjectStack.last { return last }
    fatalError("[BUG] Compiler: Using nil current code object.")
  }

  internal var builder: CodeObjectBuilder {
    fatalError()
  }

  private var symbolTable: SymbolTable!

  /// Scope stack.
  /// Current scope is at the top, top scope is at the bottom.
  private var scopeStack = [SymbolScope]()

  /// We have to scan '__future__' (as weird as it sounds), to block any
  /// potential '__future__' imports that occur later in file.
  internal var future: FutureFeatures = FutureFeatures(flags: [], lastLine: 0)

  // TODO: u_nfblocks
  internal var blockTypeStack = [BlockType]()

  /// Scope that we are currently filling (top of the `self.scopeStack`).
  internal var currentScope: SymbolScope {
    if let last = self.scopeStack.last { return last }
    fatalError("[BUG] Compiler: Using nil current scope.")
  }

  internal var isInLoop: Bool {
    return false
  }

  internal var nestLevel: Int {
    return 0
  }

  /// Name of the class that we are currently filling (if any).
  /// Mostly used for mangling.
  internal var className: String?


  internal var isInteractive: Bool {
    return false
  }

  internal let optimizationLevel: UInt = 0

  // MARK: - Visit

  /// PyAST_CompileObject(mod_ty mod, PyObject *filename, PyCompilerFlags ...)
  /// compiler_mod(struct compiler *c, mod_ty mod)
  public func visit(ast: AST) throws -> CodeObject {
    let symbolTableBuilder = SymbolTableBuilder()
    self.symbolTable = try symbolTableBuilder.visit(ast)

    self.enterScope(name: SpecialIdentifiers.top, node: ast, type: .module)

    switch ast.kind {
    case let .single(stmts),
         let .fileInput(stmts):
      try self.visitStatements(stmts)
    case let .expression(expr):
      try self.visitExpression(expr)
    }

    // TODO: Emit nop. because it may be an jump target!
    // TODO: Check if all blocks have valid labels

    assert(self.codeObjectStack.count == 1)
    return self.currentCodeObject
  }

  // MARK: - Code object

  internal func pushCodeObject(name: String) {
  }

  internal func popCodeObject() {
  }

  // MARK: - Block type

  // TODO: compiler_push_fblock
  internal func pushBlockType(_ type: BlockType) {
  }

  internal func popBlockType() {
  }

  // MARK: - Scope

  /// Push new scope.
  ///
  /// compiler_enter_scope(struct compiler *c, identifier name, ...)
  internal func enterScope<N: ASTNode>(name: String, node: N, type: CompilerScope) {
    // TODO: name may be unused, if so then delete it
    guard let scope = self.symbolTable.scopeByNode[node] else {
      fatalError("[BUG] Compiler: Entering scope that is not present in symbol table.")
    }

    self.scopeStack.push(scope)
  }

  /// Pop scope.
  ///
  /// compiler_exit_scope(struct compiler *c)
  internal func leaveScope() {
    assert(self.scopeStack.any)
    _ = self.scopeStack.popLast()
  }

  // MARK: - Qualified name

  /// compiler_set_qualname(struct compiler *c)
  internal func createQualifiedName() throws -> String {
    // TODO: fill this
    return ""
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
    fatalError()
  }
}
