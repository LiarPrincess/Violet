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
    if let scope = self.scopeStack.last {
      return scope
    }
    assert(false)
    fatalError()
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
    let topScope = self.scopeStack[0]

    try self.analyze(topScope: topScope)
    return topScope
  }

  // MARK: - Scope

  /// symtable_enter_block(struct symtable *st, identifier name, ...)
  internal mutating func enterScope(name: String, type: ScopeType) {
    let isNested = self.scopeStack.any &&
      (self.scopeStack.last?.isNested ?? false || type == .function)

    let scope = SymbolScope(name: name, type: type, isNested: isNested)

    // parent is null if we are adding top (module) scope
    if let parent = self.scopeStack.last {
      parent.children.append(scope)
    }

    self.scopeStack.push(scope)
  }

  /// symtable_exit_block(struct symtable *st, void *ast)
  internal mutating func leaveScope() {
    let scope = self.scopeStack.popLast()
    assert(scope != nil)
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
  internal mutating func addSymbol(_ name: String, flags: SymbolFlags) throws {
    let mangled = MangledName(className: self.className, name: name)

    var flagsToSet = flags
    if let existing = self.currentScope.symbols[mangled] {
      if flags.contains(.param) && existing.contains(.param) {
        // TODO: location
        throw self.error(.duplicateArgument(name), location: .start)
      }

      flagsToSet.formUnion(existing)
    }

    self.currentScope.symbols[mangled] = flagsToSet

    if flags.contains(.param) {
      self.currentScope.varnames.append(mangled)
    } else if flags.contains(.global) {
      // TODO: gather global scope symbols? (CPython)
    }
  }

  /// symtable_record_directive(struct symtable *st, identifier name, stmt_ty s)
  internal func addDirective(_ name: String) {
    let mangled = MangledName(className: self.className, name: name)
    self.currentScope.directives.append(mangled)
  }

  /// Lookup mangled name in current scope.
  ///
  /// symtable_lookup(struct symtable *st, PyObject *name)
  internal func lookupMangled(_ name: String) -> SymbolFlags? {
    let mangled = MangledName(className: self.className, name: name)
    return self.currentScope.symbols[mangled]
  }

  // MARK: - Arguments

  internal mutating func visitDefaults(_ args: Arguments) throws {
    try self.visit(args.defaults)
    try self.visit(args.kwOnlyDefaults)
  }

  /// symtable_visit_params(struct symtable *st, asdl_seq *args)
  /// symtable_visit_arguments(struct symtable *st, arguments_ty a)
  internal mutating func visitArguments(_ args: Arguments) throws {
    for a in args.args {
      try self.addSymbol(a.name, flags: .param)
    }

    switch args.vararg {
    case let .named(a):
      try self.addSymbol(a.name, flags: .param)
      self.currentScope.hasVarargs = true
    case .none, .unnamed:
      break
    }

    for a in args.kwOnlyArgs {
      try self.addSymbol(a.name, flags: .param)
    }

    if let a = args.kwarg {
      try self.addSymbol(a.name, flags: .param)
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

  // MARK: - Keyword

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

  @available(*, deprecated, message: "TO REMOVE!")
  private func unimplemented() -> Error {
    return NotImplemented.pep401
  }
}
