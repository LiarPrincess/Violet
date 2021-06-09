import VioletCore
import VioletParser
import VioletBytecode

// In CPython:
// Python -> symtable.c

// cSpell:ignore argannotations

public final class SymbolTableBuilder {

  private let impl: SymbolTableBuilderImpl

  public init(delegate: CompilerDelegate?) {
    self.impl = SymbolTableBuilderImpl(delegate: delegate)
  }

  public func visit(ast: AST) throws -> SymbolTable {
    return try self.impl.visit(ast: ast)
  }
}

/// Just like `Compiler` is a wrapper for `CompilerImpl`,
/// we have `SymbolTableBuilder` as a wrapper for `SymbolTableBuilderImpl`.
internal final class SymbolTableBuilderImpl:
  ASTVisitor, StatementVisitor, ExpressionVisitor {

  internal typealias ASTResult = Void
  internal typealias StatementResult = Void
  internal typealias ExpressionResult = Void

  /// Scope stack.
  /// Current scope is at the top, top scope is at the bottom.
  private var scopeStack = [SymbolScope]()

  private var scopeByNode = SymbolTable.ScopeByNode()

  internal weak var delegate: CompilerDelegate?

  /// Scope that we are currently filling (top of the `self.scopeStack`).
  internal var currentScope: SymbolScope {
    if let last = self.scopeStack.last { return last }
    trap("[BUG] SymbolTableBuilder: Using nil current scope.")
  }

  internal var topScope: SymbolScope {
    if let first = self.scopeStack.first { return first }
    trap("[BUG] SymbolTableBuilder: Using nil top scope.")
  }

  /// Name of the class that we are currently filling (if any).
  /// Mostly used for mangling.
  internal var className: String?

  // MARK: - Init

  fileprivate init(delegate: CompilerDelegate?) {
    self.delegate = delegate
  }

  // MARK: - Pass

  /// PySymtable_BuildObject(mod_ty mod, ...)
  internal func visit(ast: AST) throws -> SymbolTable {
    self.enterScope(kind: .module, node: ast)

    try ast.accept(self)

    assert(self.scopeStack.count == 1)
    let top = self.scopeStack[0]
    let table = SymbolTable(top: top, scopeByNode: self.scopeByNode)

    let sourcePass = SymbolTableVariableSourcePass()
    try sourcePass.analyze(table: table)

    return table
  }

  internal func visit(_ node: InteractiveAST) throws {
    try self.visit(node.statements)
  }

  internal func visit(_ node: ModuleAST) throws {
    try self.visit(node.statements)
  }

  internal func visit(_ node: ExpressionAST) throws {
    try self.visit(node.expression)
  }

  // MARK: - Scope

  /// Push new scope and add as child to current scope.
  ///
  /// symtable_enter_block(struct symtable *st, identifier name, ...)
  internal func enterScope<N: ASTNode>(kind: SymbolScope.InitArg, node: N) {
    let isParentNested = self.scopeStack.last?.isNested ?? false
    let isNestedFunction = self.scopeStack.any && kind.isFunctionLambdaComprehension
    let isNested = isParentNested || isNestedFunction

    let previous = self.scopeStack.last

    let scope = SymbolScope(kind: kind, isNested: isNested)
    self.scopeStack.push(scope)
    self.scopeByNode[node] = scope
    previous?.children.append(scope)
  }

  /// Pop scope.
  ///
  /// symtable_exit_block(struct symtable *st, void *ast)
  internal func leaveScope() {
    assert(self.scopeStack.any)
    _ = self.scopeStack.popLast()
  }

  // MARK: - Names

  /// symtable_add_def(struct symtable *st, PyObject *name, int flag)
  ///
  /// Always mangle! So something like this is also mangled:
  /// ```c
  /// class Frozen:
  ///   def let_it_go(self):
  ///     __elsa    <- mangled local variable `_Frozen__elsa`
  /// ```
  /// In general variables with '__' prefix should only be used if we
  /// really need mangling to avoid potential name clash.
  internal func addSymbol(name: String,
                          flags: Symbol.Flags,
                          location: SourceLocation) throws {
    let mangled = MangledName(className: self.className, name: name)

    var firstLocation = location
    var flagsToSet = flags

    if let current = self.currentScope.symbols[mangled] {
      if flags.contains(.defParam) && current.flags.contains(.defParam) {
        let loc = Swift.max(current.location, location)
        throw self.error(.duplicateArgument(name), location: loc)
      }

      firstLocation = current.location
      flagsToSet.formUnion(current.flags)
    }

    let info = Symbol(flags: flagsToSet, location: firstLocation)
    self.currentScope.symbols[mangled] = info

    if flags.contains(.defParam) {
      self.currentScope.parameterNames.append(mangled)
    } else if flags.contains(.defGlobal) {
      var globalFlagsToSet = flagsToSet
      if let currentGlobal = self.topScope.symbols[mangled] {
        globalFlagsToSet.formUnion(currentGlobal.flags)
      }

      let globalInfo = Symbol(flags: globalFlagsToSet, location: firstLocation)
      self.topScope.symbols[mangled] = globalInfo
    }
  }

  /// Lookup mangled name in current scope.
  ///
  /// symtable_lookup(struct symtable *st, PyObject *name)
  internal func lookupMangled(name: String) -> Symbol? {
    let mangled = MangledName(className: self.className, name: name)
    return self.currentScope.symbols[mangled]
  }

  // MARK: - Visit arguments

  internal func visitDefaults(args: Arguments) throws {
    try self.visit(args.defaults)
    try self.visit(args.kwOnlyDefaults)
  }

  /// symtable_visit_params(struct symtable *st, asdl_seq *args)
  /// symtable_visit_arguments(struct symtable *st, arguments_ty a)
  internal func visitArguments(_ args: Arguments) throws {
    // Do not reorder this!
    // Args -> KwOnlyArgs -> Vararg -> Kwarg

    for a in args.args {
      try self.addSymbol(name: a.name, flags: .defParam, location: a.start)
    }

    for a in args.kwOnlyArgs {
      try self.addSymbol(name: a.name, flags: .defParam, location: a.start)
    }

    switch args.vararg {
    case let .named(a):
      try self.addSymbol(name: a.name, flags: .defParam, location: a.start)
      self.currentScope.hasVarargs = true
    case .none, .unnamed:
      break
    }

    if let a = args.kwarg {
      try self.addSymbol(name: a.name, flags: .defParam, location: a.start)
      self.currentScope.hasVarKeywords = true
    }
  }

  /// symtable_visit_argannotations(struct symtable *st, asdl_seq *args)
  /// symtable_visit_annotations(struct symtable *st, stmt_ty s, ...)
  internal func visitAnnotations(args: Arguments) throws {
    for a in args.args {
      try self.visit(a.annotation)
    }

    switch args.vararg {
    case let .named(a):
      try self.visit(a.annotation)
    case .none, .unnamed:
      break
    }

    for a in args.kwOnlyArgs {
      try self.visit(a.annotation)
    }

    try self.visit(args.kwarg?.annotation)
  }

  // MARK: - Visit keyword

  /// symtable_visit_keyword(struct symtable *st, keyword_ty k)
  internal func visitKeywords(keywords: [KeywordArgument]) throws {
    for k in keywords {
      try self.visit(k.value)
    }
  }

  // MARK: - Error/warning

  /// Report compiler warning
  internal func warn(_ kind: CompilerWarning.Kind, location: SourceLocation) {
    let warning = CompilerWarning(kind, location: location)
    self.delegate?.warn(warning: warning)
  }

  /// Create compiler error
  internal func error(_ kind: CompilerError.Kind,
                      location: SourceLocation) -> CompilerError {
    return CompilerError(kind, location: location)
  }
}
