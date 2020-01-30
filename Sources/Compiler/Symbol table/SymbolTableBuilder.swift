import Core
import Bytecode
import Parser

// In CPython:
// Python -> symtable.c

public final class SymbolTableBuilder: ASTVisitor, StatementVisitor, ExpressionVisitor {

  public typealias ASTResult = Void
  public typealias StatementResult = Void
  public typealias ExpressionResult = Void

  /// Scope stack.
  /// Current scope is at the top, top scope is at the bottom.
  private var scopeStack = [SymbolScope]()

  private var scopeByNode = ScopeByNodeDictionary()

  /// Scope that we are currently filling (top of the `self.scopeStack`).
  internal var currentScope: SymbolScope {
    if let last = self.scopeStack.last { return last }
    fatalError("[BUG] SymbolTableBuilder: Using nil current scope.")
  }

  internal var topScope: SymbolScope {
    if let first = self.scopeStack.first { return first }
    fatalError("[BUG] SymbolTableBuilder: Using nil top scope.")
  }

  /// Name of the class that we are currently filling (if any).
  /// Mostly used for mangling.
  internal var className: String?

  // MARK: - Pass

  /// PySymtable_BuildObject(mod_ty mod, ...)
  public func visit(_ ast: AST) throws -> SymbolTable {
    self.enterScope(name: SymbolScopeNames.top, type: .module, node: ast)

    try ast.accept(self)

    assert(self.scopeStack.count == 1)
    let top = self.scopeStack[0]
    let table = SymbolTable(top: top, scopeByNode: self.scopeByNode)

    let sourcePass = SymbolTableVariableSourcePass()
    try sourcePass.analyze(table: table)

    return table
  }

  public func visit(_ node: InteractiveAST) throws {
    try self.visit(node.statements)
  }

  public func visit(_ node: ModuleAST) throws {
    try self.visit(node.statements)
  }

  public func visit(_ node: ExpressionAST) throws {
    try self.visit(node.expression)
  }

  // MARK: - Scope

  /// Push new scope and add as child to current scope.
  ///
  /// symtable_enter_block(struct symtable *st, identifier name, ...)
  internal func enterScope<N: ASTNode>(name: String, type: ScopeType, node: N) {
    let isNested = self.scopeStack.any &&
      (self.scopeStack.last?.isNested ?? false || type == .function)

    let previous = self.scopeStack.last

    let scope = SymbolScope(name: name, type: type, isNested: isNested)
    self.scopeStack.push(scope)
    self.scopeByNode.insert(node, value: scope)
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
  internal func addSymbol(_ name: String,
                          flags:  SymbolFlags,
                          location: SourceLocation) throws {
    let mangled = MangledName(className: self.className, name: name)

    var firstLocation = location
    var flagsToSet = flags

    if let current = self.currentScope.symbols[mangled] {
      if flags.contains(.defParam) && current.flags.contains(.defParam) {
        throw self.error(.duplicateArgument(name), location: location)
      }

      firstLocation = current.location
      flagsToSet.formUnion(current.flags)
    }

    let info = SymbolInfo(flags: flagsToSet, location: firstLocation)
    self.currentScope.symbols[mangled] = info

    if flags.contains(.defParam) {
      self.currentScope.varNames.append(mangled)
    } else if flags.contains(.defGlobal) {
      var globalsToSet = flagsToSet
      if let currentGlobal = self.topScope.symbols[mangled] {
        globalsToSet.formUnion(currentGlobal.flags)
      }

      let globalInfo = SymbolInfo(flags: globalsToSet, location: firstLocation)
      self.topScope.symbols[mangled] = globalInfo
    }
  }

  /// Lookup mangled name in current scope.
  ///
  /// symtable_lookup(struct symtable *st, PyObject *name)
  internal func lookupMangled(_ name: String) -> SymbolInfo? {
    let mangled = MangledName(className: self.className, name: name)
    return self.currentScope.symbols[mangled]
  }

  // MARK: - Visit arguments

  internal func visitDefaults(_ args: Arguments) throws {
    try self.visit(args.defaults)
    try self.visit(args.kwOnlyDefaults)
  }

  /// symtable_visit_params(struct symtable *st, asdl_seq *args)
  /// symtable_visit_arguments(struct symtable *st, arguments_ty a)
  internal func visitArguments(_ args: Arguments) throws {
    for a in args.args {
      try self.addSymbol(a.name, flags: .defParam, location: a.start)
    }

    switch args.vararg {
    case let .named(a):
      try self.addSymbol(a.name, flags: .defParam, location: a.start)
      self.currentScope.hasVarargs = true
    case .none, .unnamed:
      break
    }

    for a in args.kwOnlyArgs {
      try self.addSymbol(a.name, flags: .defParam, location: a.start)
    }

    if let a = args.kwarg {
      try self.addSymbol(a.name, flags: .defParam, location: a.start)
      self.currentScope.hasVarKeywords = true
    }
  }

  /// symtable_visit_argannotations(struct symtable *st, asdl_seq *args)
  /// symtable_visit_annotations(struct symtable *st, stmt_ty s, ...)
  internal func visitAnnotations(_ args: Arguments) throws {
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
  internal func visitKeywords(_ keywords: [Keyword]) throws {
    for k in keywords {
      try self.visit(k.value)
    }
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
}
