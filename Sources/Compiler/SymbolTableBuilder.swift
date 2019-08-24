import Core
import Parser

// In CPython:
// Python -> symtable.c

internal enum SpecialIdentifiers {
  internal static let top = "top"
  internal static let lambda = "lambda"
  internal static let genexpr = "genexpr"
  internal static let listcomp = "listcomp"
  internal static let setcomp = "setcomp"
  internal static let dictcomp = "dictcomp"
  internal static let __class__ = "__class__"
}

public struct SymbolTableBuilder {

  /// Scope stack.
  private var scopeStack = [SymbolScope]()

  /// Scope that we are currently filling.
   internal var currentScope: SymbolScope {
    get {
      assert(self.scopeStack.any)
      return self.scopeStack[self.scopeStack.count - 1]
    }
    set { assert(false, "Use `self.scopeStack` instead.") }
    _modify {
      assert(self.scopeStack.any)
      yield &self.scopeStack[self.scopeStack.count - 1]
    }
   }

  /// Name of the class that we are currently filling (if any).
  /// Mostly used for mangling.
  internal var className: String?

  // MARK: - Pass

  /// PySymtable_BuildObject(mod_ty mod, ...)
  public mutating func visit(_ ast: AST) throws -> SymbolScope {
    self.scopeStack.removeAll()

    self.enterScope(name: SpecialIdentifiers.top, type: .module)

    switch ast {
    case let .single(stmts):
      try self.visit(stmts)
    case let .fileInput(stmts):
      try self.visit(stmts)
    case let .expression(expr):
      try self.visit(expr)
    }

    assert(self.scopeStack.count == 1)

    var topScope = self.scopeStack[0]
    try self.analyze(top: &topScope)

    return topScope
  }

  // MARK: - Scope

  /// Push new scope.
  ///
  /// symtable_enter_block(struct symtable *st, identifier name, ...)
  internal mutating func enterScope(name: String, type: ScopeType) {
    let isNested = self.scopeStack.any &&
      (self.scopeStack.last?.isNested ?? false || type == .function)

    let scope = SymbolScope(name: name, type: type, isNested: isNested)
    self.scopeStack.push(scope)
  }

  /// Pop scope and add to child of parent scope.
  ///
  /// symtable_exit_block(struct symtable *st, void *ast)
  internal mutating func leaveScope() {
    let scope = self.scopeStack.popLast()
    assert(scope != nil)

    // swiftlint:disable:next force_unwrapping
    self.currentScope.children.append(scope!)
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
  internal mutating func addSymbol(_ name: String,
                                   flags:  SymbolFlags,
                                   location: SourceLocation) throws {
    let mangled = MangledName(className: self.className, name: name)

    var flagsToSet = flags
    if let current = self.currentScope.symbols[mangled] {
      if flags.contains(.defParam) && current.flags.contains(.defParam) {
        throw self.error(.duplicateArgument(name), location: location)
      }

      flagsToSet.formUnion(current.flags)
    }

    self.currentScope.symbols[mangled] = SymbolInfo(flags: flagsToSet,
                                                    location: location)

    if flags.contains(.defParam) {
      self.currentScope.varnames.append(mangled)
    } else if flags.contains(.defGlobal) {
      // TODO: gather global scope symbols? (CPython)
    }
  }

  /// Directive means global and nonlocal statement.
  ///
  /// symtable_record_directive(struct symtable *st, identifier name, stmt_ty s)
  internal mutating func addDirective(_ name: String) {
    let mangled = MangledName(className: self.className, name: name)
    self.currentScope.directives.append(mangled)
  }

  /// Lookup mangled name in current scope.
  ///
  /// symtable_lookup(struct symtable *st, PyObject *name)
  internal func lookupMangled(_ name: String) -> SymbolInfo? {
    let mangled = MangledName(className: self.className, name: name)
    return self.currentScope.symbols[mangled]
  }

  // MARK: - Visit arguments

  internal mutating func visitDefaults(_ args: Arguments) throws {
    try self.visit(args.defaults)
    try self.visit(args.kwOnlyDefaults)
  }

  /// symtable_visit_params(struct symtable *st, asdl_seq *args)
  /// symtable_visit_arguments(struct symtable *st, arguments_ty a)
  internal mutating func visitArguments(_ args: Arguments) throws {
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
  internal mutating func visitAnnotations(_ args: Arguments) throws {
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
  internal mutating func visit(_ keywords: [Keyword]) throws {
    for k in keywords {
      try self.visit(k.value)
    }
  }

  // MARK: - Errors/warnings

  /// Create parser warning
  internal mutating func warn(_ warning: CompilerWarning,
                              location:  SourceLocation) {
    // uh... oh... well that's embarrassing...
  }

  /// Create compiler error
  internal func error(_ kind: CompilerErrorKind,
                      location: SourceLocation) -> CompilerError {
    return CompilerError(kind, location: location)
  }
}
