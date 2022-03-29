import VioletCore
import VioletParser
import VioletBytecode

// cSpell:ignore ssize fblock fblocktype basicblock

// In CPython:
// Python -> compile.c

/// Compiler implementation.
/// See module documentation for details.
internal final class CompilerImpl: ASTVisitor, StatementVisitor, ExpressionVisitor {

  internal typealias ASTResult = Void
  internal typealias StatementResult = Void
  internal typealias ExpressionResult = Void

  /// Program that we are compiling.
  private let ast: AST
  /// Name of the file that this code object was loaded from.
  internal let filename: String
  /// Compilation options.
  internal let options: Compiler.Options

  internal weak var delegate: CompilerDelegate?

  /// We have to scan `__future__` (as weird as it sounds), to block any
  /// potential `__future__` imports that occur later in file.
  internal private(set) var future: FutureFeatures!
  // swiftlint:disable:previous implicitly_unwrapped_optional

  /// Symbol table associated with `self.ast`.
  internal private(set) var symbolTable: SymbolTable!
  // swiftlint:disable:previous implicitly_unwrapped_optional

  /// Compiler unit stack.
  /// Current unit (the one that we are emitting to) is at the top,
  /// module unit is at the bottom.
  ///
  /// For example:
  /// ```c
  /// class Frozen:
  ///   def elsa():
  ///     pass <- we are emitting here
  /// ```
  /// Generates following stack:
  /// module -> class -> elsa
  internal var unitStack = [CompilerUnit]()

  /// Code object builder for `self.codeObject`.
  internal var builder: CodeObjectBuilder {
    if let last = self.unitStack.last { return last.builder }
    trap("[BUG] Compiler: Using `builder` with empty `unitStack`.")
  }

  /// Scope that we are currently filling.
  internal var currentScope: SymbolScope {
    if let last = self.unitStack.last { return last.scope }
    trap("[BUG] Compiler: Using `currentScope` with empty `unitStack`.")
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

  /// Is the current statement inside a loop?
  internal var isInLoop: Bool {
    return self.blockStack.contains { $0.isLoop }
  }

  internal init(filename: String,
                ast: AST,
                options: Compiler.Options,
                delegate: CompilerDelegate?) {
    self.ast = ast
    self.filename = filename
    self.options = options
    self.delegate = delegate
  }

  // MARK: - Run

  /// PyAST_CompileObject(mod_ty mod, PyObject *filename, PyCompilerFlags ...)
  /// compiler_mod(struct compiler *c, mod_ty mod)
  internal func run() throws -> CodeObject {
    // Collect all symbols from AST
    let symbolTableBuilder = SymbolTableBuilder(delegate: self.delegate)
    self.symbolTable = try symbolTableBuilder.visit(ast: self.ast)

    // Get all of the future flags that can affect compilation
    self.future = try FutureFeatures.parse(ast: self.ast)

    // Compile (duh…)
    let codeObject = try self.inNewCodeObject(node: self.ast) {
      assert(self.builder.kind == .module)
      try self.visit(self.ast)

      // Epilog (because we may be a jump target).
      let isExpression = self.ast is ExpressionAST
      try self.appendReturn(addNone: !isExpression)
    }

    assert(codeObject.kind == .module)
    assert(self.unitStack.isEmpty)
    return codeObject
  }

  // MARK: - Visit

  internal func visit(_ node: AST) throws {
    self.setAppendLocation(node)
    try node.accept(self)
  }

  internal func visit(_ node: InteractiveAST) throws {
    try self.visitBody(body: node.statements, onDoc: .treatAsStatement)
  }

  internal func visit(_ node: ModuleAST) throws {
    try self.visitBody(body: node.statements, onDoc: .storeAs__doc__)
  }

  internal func visit(_ node: ExpressionAST) throws {
    try self.visit(node.expression)
  }

  // MARK: - Visit body

  /// What to do when we have doc?
  internal enum DocHandling {
    /// Basically `appendString` and then `appendStoreName(__doc__)`.
    case storeAs__doc__
    /// Simply add new constant, without emitting any instruction.
    case appendToConstants
    /// Nothing extraordinary, just visit and compile.
    case treatAsStatement
  }

  /// Compile a sequence of statements, checking for a docstring
  /// and for annotations.
  ///
  /// compiler_body(struct compiler *c, asdl_seq *stmts)
  internal func visitBody<C: Collection>(
    body: C,
    onDoc: DocHandling
  ) throws where C.Element == Statement {
    guard let first = body.first else {
      return
    }

    self.setupAnnotationsIfNeeded(statements: body)

    if let doc = first.getDocString(), self.options.optimizationLevel < .OO {
      switch onDoc {
      case .storeAs__doc__:
        self.builder.appendString(doc)
        self.builder.appendStoreName(SpecialIdentifiers.__doc__)
        try self.visit(body.dropFirst())
        return
      case .appendToConstants:
        self.builder.addConstant(string: doc)
        try self.visit(body.dropFirst())
        return
      case .treatAsStatement:
        // No special treatment.
        break
      }
    }

    try self.visit(body)
  }

  // MARK: - Annotations

  private func setupAnnotationsIfNeeded<S: Sequence>(
    statements: S
  ) where S.Element == Statement {
    if self.hasAnnotations(statements: statements) {
      self.builder.appendSetupAnnotations()
    }
  }

  /// Check if variable annotations are present statically in a block.
  ///
  /// find_ann(asdl_seq *stmts)
  private func hasAnnotations<S: Sequence>(
    statements: S
  ) -> Bool where S.Element == Statement {
    return statements.contains(where: self.hasAnnotations(statement:))
  }

  /// Check if variable annotations are present statically in a block.
  ///
  /// find_ann(asdl_seq *stmts)
  private func hasAnnotations(statement: Statement) -> Bool {
    if statement is AnnAssignStmt {
      return true
    }

    if let loop = statement as? ForStmt {
      return self.hasAnnotations(statements: loop.body)
          || self.hasAnnotations(statements: loop.orElse)
    }

    if let loop = statement as? AsyncForStmt {
      return self.hasAnnotations(statements: loop.body)
          || self.hasAnnotations(statements: loop.orElse)
    }

    if let loop = statement as? WhileStmt {
      return self.hasAnnotations(statements: loop.body)
          || self.hasAnnotations(statements: loop.orElse)
    }

    if let if_ = statement as? IfStmt {
      return self.hasAnnotations(statements: if_.body)
          || self.hasAnnotations(statements: if_.orElse)
    }

    if let with = statement as? WithStmt {
      return self.hasAnnotations(statements: with.body)
    }

    if let with = statement as? AsyncWithStmt {
      return self.hasAnnotations(statements: with.body)
    }

    if let try_ = statement as? TryStmt {
      return self.hasAnnotations(statements: try_.body)
          || self.hasAnnotations(statements: try_.finally)
          || self.hasAnnotations(statements: try_.orElse)
          || try_.handlers.contains { self.hasAnnotations(statements: $0.body) }
    }

    return false
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

  // MARK: - Return

  /// Append return at the end of the scope.
  internal func appendReturn(addNone: Bool) throws {
    // If we already have 'return' and no jumps then we do not need
    // to add another 'return'.
    // We will not check all of the instructions for 'return' (because that
    // would be slow), we will just take 30 last.
    let hasReturn = self.builder.instructions
      .takeLast(30)
      .contains(where: self.isReturn(instruction:))
    let hasNoJumps = self.builder.labels.isEmpty

    if hasReturn && hasNoJumps {
      return
    }

    if addNone {
      self.builder.appendNone()
    }

    self.builder.appendReturn()
  }

  private func isReturn(instruction: Instruction) -> Bool {
    switch instruction {
    case .return:
      return true
    default:
      return false
    }
  }

  // MARK: - Mangle

  internal func mangle(name: String) -> MangledName {
    let unit = self.unitStack.last { $0.className != nil }
    return MangledName(className: unit?.className, name: name)
  }

  // MARK: - Append location

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

  /// Report compiler warning
  internal func warn(_ kind: CompilerWarning.Kind) {
    let warning = CompilerWarning(kind, location: self.appendLocation)
    self.delegate?.warn(warning: warning)
  }

  /// Create compiler error
  internal func error(_ kind: CompilerError.Kind) -> CompilerError {
    return CompilerError(kind, location: self.appendLocation)
  }
}
