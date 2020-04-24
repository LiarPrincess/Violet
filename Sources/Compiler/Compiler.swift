import Core
import Parser
import Bytecode

// In CPython:
// Python -> compile.c

// swiftlint:disable file_length

public final class Compiler {

  private let impl: CompilerImpl

  public init(filename: String,
              ast: AST,
              options: CompilerOptions,
              delegate: CompilerDelegate?) {
    self.impl = CompilerImpl(filename: filename,
                             ast: ast,
                             options: options,
                             delegate: delegate)
  }

  public func run() throws -> CodeObject {
    return try self.impl.run()
  }
}

/// Compiler implementation.
///
/// Why do we have separate class? Why not just use `Compiler`?
///
/// `Compiler` is public and it needs to implement `ASTVisitor`
/// which would require us to mark all of those methods as `public`.
/// This would expose a lot of unnecessary details.
///
/// Why can't we specify that `Compiler` implements `ASTVisitor` on `internal`
/// level (syntax would be `class Compiler: internal ASTVisitor`)?
/// Think about this: what if someone from outside of the module decides
/// to add conformance to `ASTVisitor` again?
/// Both `Compiler` and `ASTVisitor` are public, so technically they should
/// be able to do so.
/// In such case we can't just say 'You can't do this because internally (yada-yada)'.
///
/// It also has some problems on a conceptual level:
/// http://scg.unibe.ch/archive/papers/Scha03aTraits.pdf
///
/// In theory it should be possible to create 'access modified' INHERITANCE
/// (hello `C++`).
///
/// I think that idiomatic Swift prefers to create wrapper types
/// (for this and other use-cases).
/// For example:
///   dictionaries/sets do not allow you to provide `Comparer`
///   (`C#` does this) which means that you have to create 'wrapper type'
///   if you want to use different notion of 'equality'.
///
/// Anyway: we have `Compiler` wrapper for `CompilerImpl`.
internal final class CompilerImpl: ASTVisitor, StatementVisitor, ExpressionVisitor {

  internal typealias ASTResult = Void
  internal typealias StatementResult = Void
  internal typealias ExpressionResult = Void

  /// Program that we are compiling.
  private let ast: AST
  /// Name of the file that this code object was loaded from.
  internal let filename: String
  /// Compilation options.
  internal let options: CompilerOptions

  internal weak var delegate: CompilerDelegate?

  /// We have to scan `__future__` (as weird as it sounds), to block any
  /// potential `__future__` imports that occur later in file.
  internal private(set) var future: FutureFeatures!
  // swiftlint:disable:previous implicitly_unwrapped_optional

  /// Symbol table assiciated with `self.ast`.
  internal private(set) var symbolTable: SymbolTable!
  // swiftlint:disable:previous implicitly_unwrapped_optional

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
    trap("[BUG] Compiler: Using `codeObject` with empty `unitStack`.")
  }

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
  /// Does the current statement is inside of the loop?
  internal var isInLoop: Bool {
    return self.blockStack.contains { $0.isLoop }
  }

  fileprivate init(filename: String,
                   ast: AST,
                   options: CompilerOptions,
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
    // Have we already compiled?
    if self.unitStack.count == 1 {
      return self.codeObject
    }

    let symbolTableBuilder = SymbolTableBuilder(delegate: self.delegate)
    self.symbolTable = try symbolTableBuilder.visit(self.ast)

    self.future = try FutureFeatures.parse(ast: self.ast)

    self.enterScope(node: self.ast, type: .module, argCount: 0, kwOnlyArgCount: 0)
    self.setAppendLocation(self.ast)

    try self.visit(self.ast)

    // Emit epilog (because we may be a jump target).
    if !self.currentScope.hasReturnValue {
      let isExpression = self.ast is ExpressionAST
      if !isExpression {
        self.builder.appendNone()
      }
      self.builder.appendReturn()
    }

    assert(self.unitStack.count == 1)
    return self.codeObject
  }

  // MARK: - Visit

  internal func visit(_ node: AST) throws {
    self.setAppendLocation(node)
    try node.accept(self)
  }

  internal func visit(_ node: InteractiveAST) throws {
    // We cannot use 'visitBody' because we do not want '__doc__'.
    self.setupAnnotationsIfNeeded(statements: node.statements)
    try self.visit(node.statements)
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
    /// Emit `appendString` and then `appendStoreName(__doc__)`.
    case storeAs__doc__
    /// Simply add new constant, without emitting any instruction.
    case appendToConstants
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
      case .appendToConstants:
        self.builder.addConstant(string: doc)
      }

      try self.visit(body.dropFirst())
    } else {
      try self.visit(body)
    }
  }

  // MARK: - Annotations

  private func setupAnnotationsIfNeeded<C: Collection>(
    statements: C
  ) where C.Element == Statement {
    if self.hasAnnotations(statements: statements) {
      self.builder.appendSetupAnnotations()
    }
  }

  /// Search if variable annotations are present statically in a block.
  ///
  /// find_ann(asdl_seq *stmts)
  private func hasAnnotations<S: Sequence>(statements: S) -> Bool
    where S.Element == Statement {

    return statements.contains(where: self.hasAnnotations(statement:))
  }

  /// Search if variable annotations are present statically in a block.
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

    if let iff = statement as? IfStmt {
      return self.hasAnnotations(statements: iff.body)
          || self.hasAnnotations(statements: iff.orElse)
    }

    if let with = statement as? WithStmt {
      return self.hasAnnotations(statements: with.body)
    }

    if let with = statement as? AsyncWithStmt {
      return self.hasAnnotations(statements: with.body)
    }

    if let tryy = statement as? TryStmt {
      return self.hasAnnotations(statements: tryy.body)
          || self.hasAnnotations(statements: tryy.finally)
          || self.hasAnnotations(statements: tryy.orElse)
          || tryy.handlers.contains { self.hasAnnotations(statements: $0.body) }
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
    emitInstructions block: () throws -> Void
  ) throws -> CodeObject {
    return try self.inNewCodeObject(
      node: node,
      type: type,
      argCount: 0,
      kwOnlyArgCount: 0,
      emitInstructions: block
    )
  }

  /// Helper for creation of new code objects.
  /// It surrounds given `block` with `enterScope` and `leaveScope`
  /// (1 scope = 1 code object).
  /// Use `self.codeObject` to emit instructions.
  internal func inNewCodeObject<N: ASTNode>(
    node: N,
    type: CodeObjectType,
    argCount: Int,
    kwOnlyArgCount: Int,
    emitInstructions block: () throws -> Void
  ) throws -> CodeObject {

    self.enterScope(node: node,
                    type: type,
                    argCount: argCount,
                    kwOnlyArgCount: kwOnlyArgCount)
    try block()
    let code = self.codeObject
    try self.leaveScope()

    return code
  }

  // swiftlint:disable function_body_length

  /// Push new scope (and generate a new code object to emit to).
  ///
  /// compiler_enter_scope(struct compiler *c, identifier name, ...)
  private func enterScope<N: ASTNode>(node: N,
                                      type: CodeObjectType,
                                      argCount: Int,
                                      kwOnlyArgCount: Int) {
    // swiftlint:enable function_body_length

    guard let scope = self.symbolTable.scopeByNode[node] else {
      trap("[BUG] Compiler: Entering scope that is not present in symbol table.")
    }

    assert(self.isMatchingScopeType(scope.type, to: type))

    let name = self.createName(type: type, scope: scope)
    let qualifiedName = self.createQualifiedName(for: name, type: type)
    let flags = self.createFlags(type: type, scope: scope)

    // In 'variableNames' we have to put parameters before locals.
    let paramNames = self.filterSymbols(scope, accepting: .defParam)
    let localNames = self.filterSymbols(scope,
                                        accepting: .srcLocal,
                                        skipping: .defParam,
                                        sorted: true)
    let variableNames = paramNames + localNames
    assert(paramNames == scope.parameterNames)

    let freeFlags: SymbolFlags = [.srcFree, .defFreeClass]
    let freeVars = self.filterSymbols(scope, accepting: freeFlags, sorted: true)

    var cellVars = self.filterSymbols(scope, accepting: .cell, sorted: true)

    // append implicit __class__ cell.
    if scope.needsClassClosure {
      assert(scope.type == .class) // needsClassClosure can only be set on class
      cellVars.append(MangledName(from: SpecialIdentifiers.__class__))
    }

    let object = CodeObject(name: name,
                            qualifiedName: qualifiedName,
                            filename: self.filename,
                            type: type,
                            flags: flags,
                            variableNames: variableNames,
                            freeVariableNames: freeVars,
                            cellVariableNames: cellVars,
                            argCount: argCount,
                            kwOnlyArgCount: kwOnlyArgCount,
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
      trap("[BUG] Compiler: Attempting to pop non-existing unit.")
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
  /// If the symbol contains any of the given flags add it to result.
  ///
  /// Sort the keys so that we have a deterministic order on the indexes
  /// saved in the returned dictionary.
  private func filterSymbols(
    _ scope: SymbolScope,
    accepting: SymbolFlags,
    skipping: SymbolFlags = [],
    sorted: Bool = false
  ) -> [MangledName] {
    let symbols: [SymbolByNameDictionary.Element] = {
      guard sorted else {
        return Array(scope.symbols)
      }

      return scope.symbols.sorted { lhs, rhs in
        let lhsName = lhs.key
        let rhsName = rhs.key
        return lhsName.value < rhsName.value
      }
    }()

    var result = [MangledName]()
    for (name, info) in symbols {
      let isAccepted = info.flags.contains(anyOf: accepting)
      let isSkipped = info.flags.contains(anyOf: skipping)

      if isAccepted && !isSkipped {
        result.append(name)
      }
    }

    return result
  }

  /// static int
  /// compute_code_flags(struct compiler *c)
  private func createFlags(type: CodeObjectType,
                           scope: SymbolScope) -> CodeObjectFlags {
    var result = CodeObjectFlags()

    if scope.type == .function {
      result.formUnion(.newLocals)
      result.formUnion(.optimized)

      if scope.isNested {
        result.formUnion(.nested)
      }

      switch (scope.isGenerator, scope.isCoroutine) {
      case (true, true): result.formUnion(.asyncGenerator)
      case (true, false): result.formUnion(.generator)
      case (false, true): result.formUnion(.coroutine)
      case (false, false): break
      }

      if scope.hasVarargs {
        result.formUnion(.varArgs)
      }

      if scope.hasVarKeywords {
        result.formUnion(.varKeywords)
      }
    }

    // CPython will also copy 'self.future' flags, we don't need them (for now).
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
  internal func warn(_ kind: CompilerWarningKind) {
    let warning = CompilerWarning(kind, location: self.appendLocation)
    self.delegate?.warn(warning: warning)
  }

  /// Create compiler error
  internal func error(_ kind: CompilerErrorKind) -> CompilerError {
    return CompilerError(kind, location: self.appendLocation)
  }
}
