import Core
import Parser
import Bytecode

// In CPython:
// Python -> compile.c

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
  /// Scope stack.
  /// Current scope is at the top, top scope is at the bottom.
  private var scopeStack = [SymbolScope]()
  /// Scope that we are currently filling (top of the `self.scopeStack`).
  internal var currentScope: SymbolScope {
    if let last = self.scopeStack.last { return last }
    fatalError("[BUG] Compiler: Using nil current scope.")
  }
  /// How far are we inside module/class/function scopes.
  internal var nestLevel: Int {
    return self.scopeStack.count
  }

  /// Stack of the code objects.
  /// Current code object (the one that we are emmiting to) is at the top,
  /// module code object is at the bottom.
  ///
  /// For example:
  /// ```c
  /// class Frozen:
  ///   def elsa():
  ///     pass <- we are emitting here
  /// ```
  /// Generates following stack:
  /// top -> class -> elsa
  private var codeObjectStack = [CodeObject]()
  /// Code object that we are currently filling (top of the `self.codeObjectStack`).
  internal var codeObject: CodeObject {
    if let last = self.codeObjectStack.last { return last }
    fatalError("[BUG] Compiler: Using nil current code object.")
  }

  /// Stack of blocks (loop, except, finallyTry, finallyEnd)
  /// that current statement is surrounded with.
  internal var blockStack = [BlockType]()
  /// Does the current statement is inside of the loop?
  internal var isInLoop: Bool {
    return self.blockStack.contains { $0.isLoop }
  }

  /// Name of the class that we are currently filling (if any).
  /// Mostly used for mangling.
  internal var className: String?

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
    if self.codeObjectStack.count == 1 {
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

    // TODO: Emit nop. because it may be an jump target!
    // TODO: Check if all blocks have valid labels

    assert(self.codeObjectStack.count == 1)
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
    self.scopeStack.push(scope)

    let line = node.start.line
    let object = CodeObject(name: scope.name, type: type, line: line)

    self.codeObjectStack.append(object)
    // TODO: qual name
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

  /// Pop scope.
  ///
  /// compiler_exit_scope(struct compiler *c)
  internal func leaveScope() {
    // Pop scope
    assert(self.scopeStack.any)
    _ = self.scopeStack.popLast()

    // Pop code object
    let object = self.codeObjectStack.popLast()

    assert(object != nil)
    assert(object!.labels.allSatisfy { $0 != Label.notAssigned })
    // swiftlint:disable:previous force_unwrapping
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
    // TODO: remove this
    return NotImplemented.pep401
  }
}
