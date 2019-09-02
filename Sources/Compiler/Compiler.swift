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

  private var symbolTable: SymbolTable!

  /// Scope stack.
  /// Current scope is at the top, top scope is at the bottom.
  private var scopeStack = [SymbolScope]()

  /// Scope that we are currently filling (top of the `self.scopeStack`).
  internal var currentScope: SymbolScope {
    if let last = self.scopeStack.last { return last }
    fatalError("[BUG] Compiler: Using nil current scope.")
  }

  /// Name of the class that we are currently filling (if any).
  /// Mostly used for mangling.
  internal var className: String?

  /// Optimization level
  internal let optimize: Bool

  public init(optimize: Bool) {
    self.optimize = optimize
  }

  // MARK: - Visit

  /// PyAST_CompileObject(mod_ty mod, PyObject *filename, PyCompilerFlags ...)
  /// compiler_mod(struct compiler *c, mod_ty mod)
  public func visit(ast: AST) throws -> CodeObject {
    let symbolTableBuilder = SymbolTableBuilder()
    self.symbolTable = try symbolTableBuilder.visit(ast)

    self.enterScope(node: ast)

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

  internal func visitStatements<S: Sequence>(_ stmts: S) throws
    where S.Element == Statement {

    fatalError()
  }

  // MARK: - Code object

  internal func pushCodeObject(name: String) {
  }

  internal func popCodeObject() {
  }

  // MARK: - Scope

  /// Push new scope.
  ///
  /// compiler_enter_scope(struct compiler *c, identifier name, ...)
  internal func enterScope<N: ASTNode>(node: N) {
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

  // MARK: - Labels

  internal func newLabel() throws -> Label {
    let index = self.currentCodeObject.labels.endIndex
    self.currentCodeObject.labels.append(Label.invalid)
    return Label(index: index)
  }

  internal func setLabel(_ label: Label) {
    assert(label.index < self.currentCodeObject.labels.count)
    let jumpTarget = self.currentCodeObject.instructions.endIndex
    self.currentCodeObject.labels[label.index] = jumpTarget
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

  // MARK: - Not implemented

  internal func notImplemented() -> Error {
    fatalError()
  }
}
