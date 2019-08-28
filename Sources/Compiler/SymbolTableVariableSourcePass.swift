import Core

// In CPython:
// Python -> symtable.c

// Implements a 2nd pass when creating symbol table.
// This is basically 1:1 translation from CPython.
// It is quite complicated (but it does make sense if you spend some time with it).

// swiftlint:disable function_body_length
// swiftlint:disable file_length

/// Structure that represents outer scope
/// (basically everything OUTSIDE of the currently analyzed function).
private final class OuterContext {

  /// Set of free variables in outer scopes
  ///
  /// Usage:
  /// - child - add new free variables
  /// - parent - bind free vaiables from childs with locals (creating `cells`)
  fileprivate var free: [MangledName: SymbolInfo]

  /// Set of declared global variables in outer scopes (used for globals)
  fileprivate var global: Set<MangledName>

  /// Set of variables bound in outer scopes (used for nonlocals)
  fileprivate var bound: Set<MangledName>

  fileprivate init(free:   [MangledName: SymbolInfo],
                   bound:  Set<MangledName>,
                   global: Set<MangledName>) {
    self.free = free
    self.bound = bound
    self.global = global
  }
}

/// Structure that represents current scope
/// (basically everything INSIDE of the function).
private final class ScopeContext {

  /// Names bound in block
  fileprivate var local = Set<MangledName>()

  /// Sources for each symbol (basically the main thing in this pass).
  /// CPython: `scopes`
  fileprivate var symbolSources = [MangledName:SymbolFlags]()

  /// Variable names visible in nested blocks.
  /// Basically: outer bound + our local bound
  fileprivate var newBound = Set<MangledName>()

  /// Global names visible in nested blocks.
  /// Basically: outer global + our local global
  fileprivate var newGlobal = Set<MangledName>()

  /// Free vaiabled that should be resolved by parent scope.
  fileprivate var newFree = [MangledName: SymbolInfo]()
}

/// For each variable adds variable source (local, global, free) flag.
/// It will also mark sources for free variables (called 'cells').
internal final class SymbolTableVariableSourcePass {

  /// symtable_analyze(struct symtable *st)
  internal func analyze(table: SymbolTable) throws {
    try self.analyzeBlock(scope: table.top, outerContext: nil)
  }

  /// analyze_block(PySTEntryObject *ste, PyObject *bound, PyObject *free, ...)
  private func analyzeBlock(scope: SymbolScope,
                            outerContext: OuterContext?) throws {

    let context = ScopeContext()

    // Classes are 'transparent' for variable definitions
    if let outer = outerContext, scope.type == .class {
      context.newBound.formUnion(outer.bound)
      context.newGlobal.formUnion(outer.global)
    }

    // Analyze current scope symbols
    for (name, info) in scope.symbols {
      try self.analyzeName(name,
                           info:  info,
                           scope: scope,
                           scopeContext: context,
                           outerContext: outerContext)
    }

    // Populate global and bound sets to be passed to children
    if scope.type != .class {
      if scope.type == .function {
        context.newBound.formUnion(context.local)
      }

      if let outer = outerContext {
        context.newBound.formUnion(outer.bound)
        context.newGlobal.formUnion(outer.global)
      }
    } else {
      // If we are class then our children will also have access to __class__
      let mangled = MangledName(from: SpecialIdentifiers.__class__)
      context.newBound.insert(mangled)
    }

    // Recursively call analyzeChildBlock() on each child block
    var allFree = [MangledName: SymbolInfo]()
    for child in scope.children {
      try self.analyzeChildBlock(scope: child,
                                 scopeContext: context,
                                 addingFreeVariablesTo: &allFree)

      if child.hasFreeVariables || child.hasChildFreeVariables {
        scope.hasChildFreeVariables = true
      }
    }

    // If the free variables from child scope have the same names
    // then it is the same variable
    self.mergeFree(target: &context.newFree, src: allFree)

    // Check if any local variables must be converted to cells
    if scope.type == .function {
      self.bindChildFreeVariablesToLocalCells(scopeContext: context)
    } else if scope.type == .class {
      self.remove__class__(scope: scope, scopeContext: context)
    }

    // Record the results of the analysis in the symbol table
    try self.updateSymbols(scope: scope,
                           scopeContext: context,
                           outerContext: outerContext)

    // Update free variables that we were passed
    if let outer = outerContext {
      self.mergeFree(target: &outer.free, src: context.newFree)
    }
  }

  private func mergeFree(target: inout [MangledName: SymbolInfo],
                         src:          [MangledName: SymbolInfo]) {
    // swiftlint:disable:next trailing_closure
    target.merge(src, uniquingKeysWith: { lhs, _ in lhs })
  }

  /// Decide on scope of name, given flags.
  /// For example, a new global will add an entry to global.
  /// A name that was global can be changed to local.
  ///
  /// analyze_name(PySTEntryObject *ste, PyObject *scopes, PyObject *name, ...)
  private func analyzeName(_ name: MangledName,
                           info:   SymbolInfo,
                           scope:  SymbolScope,
                           scopeContext: ScopeContext,
                           outerContext: OuterContext?) throws {
    // CPython translation:
    // local, scopes       are from scopeContext
    // bound, free, global are from outerContext
    let flags = info.flags

    if flags.contains(.defGlobal) {
      if flags.contains(.defNonlocal) {
        // PyErr_Format(PyExc_SyntaxError, "name '%U' is nonlocal and global", name);
        // return error_at_directive(ste, name);
        fatalError()
      }

      scopeContext.symbolSources[name] = .srcGlobalExplicit
      outerContext?.global.insert(name)
      outerContext?.bound.remove(name)
      return
    }

    if flags.contains(.defNonlocal) {
      guard let bound = outerContext?.bound else {
        // PyErr_Format(PyExc_SyntaxError, "nonlocal declaration not allowed at module level");
        // return error_at_directive(ste, name);
        fatalError()
      }

      if !bound.contains(name) {
        // PyErr_Format(PyExc_SyntaxError, "no binding for nonlocal '%U' found", name);
        // return error_at_directive(ste, name);
        fatalError()
      }

      scope.hasFreeVariables = true
      scopeContext.symbolSources[name] = .srcFree
      outerContext?.free.updateValue(info, forKey: name)
      return
    }

    if flags.containsAny(.defBound) {
      scopeContext.symbolSources[name] = .srcLocal
      scopeContext.local.insert(name)
      outerContext?.global.remove(name)
      return
    }

    if let bound = outerContext?.bound, bound.contains(name) {
      scope.hasFreeVariables = true
      scopeContext.symbolSources[name] = .srcFree
      outerContext?.free.updateValue(info, forKey: name)
      return
    }

    if let global = outerContext?.global, global.contains(name) {
      scopeContext.symbolSources[name] = .srcGlobalImplicit
      return
    }

    if scope.isNested {
      scope.hasFreeVariables = true
    }

    scopeContext.symbolSources[name] = .srcGlobalImplicit
  }

  /// analyze_child_block(PySTEntryObject *entry, PyObject *bound, ...)
  private func analyzeChildBlock(
    scope: SymbolScope,
    scopeContext: ScopeContext,
    addingFreeVariablesTo free: inout [MangledName: SymbolInfo]) throws {

    // Set is an value type in Swift, so we can simply:
    let childContext = OuterContext(free:   scopeContext.newFree,
                                    bound:  scopeContext.newBound,
                                    global: scopeContext.newGlobal)

    try self.analyzeBlock(scope: scope, outerContext: childContext)
    self.mergeFree(target: &free, src: childContext.free)
  }

  /// analyze_cells(PyObject *scopes, PyObject *free)
  ///
  /// If a name is defined in free and also in locals, then this block
  /// provides the binding for the free variable.  The name should be
  /// marked CELL in this block and removed from the free list.
  ///
  /// Note that the current block's free variables are included in free.
  /// That's safe because no name can be free and local in the same scope.
  private func bindChildFreeVariablesToLocalCells(scopeContext: ScopeContext) {
    for (name, flags) in scopeContext.symbolSources {
      // is local
      guard flags.contains(.srcLocal) else { continue }
      // is free
      guard scopeContext.newFree.contains(name) else { continue }

      // we found a declaration of this free vaiable -> cell
      scopeContext.symbolSources[name] = .cell
      scopeContext.newFree.removeValue(forKey: name)
    }
  }

  /// drop_class_free(PySTEntryObject *ste, PyObject *free)
  private func remove__class__(scope: SymbolScope,
                               scopeContext: ScopeContext) {
    let name = SpecialIdentifiers.__class__
    let mangled = MangledName(from: name)

    let usedClass = scopeContext.newFree.removeValue(forKey: mangled) != nil
    if usedClass {
      scope.needsClassClosure = true
    }
  }

  /// update_symbols(PyObject *symbols, PyObject *scopes, PyObject *bound, ...)
  private func updateSymbols(scope: SymbolScope,
                             scopeContext: ScopeContext,
                             outerContext: OuterContext?) throws {

    // Update source information for all symbols in this scope
    for (name, info) in scope.symbols {
      guard let srcFlags = scopeContext.symbolSources[name] else {
        assert(false)
        fatalError()
      }

      var flags = info.flags
      flags.formUnion(srcFlags)
      self.updateSymbol(name, flags: flags, in: scope)
    }

    // Record not yet resolved free variables from children (if any)
    for (name, info) in scopeContext.newFree {
      // Handle symbol that already exists in this scope
      if let info = scope.symbols[name] {
        if scope.type == .class && info.flags.containsAny(.defBound) {
          var flags = info.flags
          flags.formUnion(.defFreeClass)
          self.updateSymbol(name, flags: flags, in: scope)
        }

        // It's a cell, or already free in this scope
        continue
      }

      // Handle global symbol
      if let outer = outerContext, outer.bound.contains(name) {
        continue
      }

      // Propagate new free symbol up the lexical stack
      scope.symbols[name] = info
    }
  }

  /// Update existing symbol.
  private func updateSymbol(_ name: MangledName,
                            flags:  SymbolFlags,
                            in scope: SymbolScope) {
    guard let current = scope.symbols[name] else {
      assert(false)
      fatalError()
    }

    let new = SymbolInfo(flags: flags, location: current.location)
    scope.symbols[name] = new
  }
}
