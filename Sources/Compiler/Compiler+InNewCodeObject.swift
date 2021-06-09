import VioletCore
import VioletParser
import VioletBytecode

// cSpell:ignore dictbytype

// In CPython:
// Python -> compile.c

// This is a very important helper function!
extension CompilerImpl {

  /// Helper for creation of new code objects.
  /// It surrounds given `block` with `enterScope` and `leaveScope`
  /// (1 scope = 1 code object).
  /// Use `self.codeObject` to emit instructions.
  internal func inNewCodeObject<N: ASTNode>(
    node: N,
    kind: CodeObject.Kind,
    emitInstructions block: () throws -> Void
  ) rethrows -> CodeObject {
    return try self.inNewCodeObject(
      node: node,
      kind: kind,
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
    kind: CodeObject.Kind,
    argCount: Int,
    kwOnlyArgCount: Int,
    emitInstructions block: () throws -> Void
  ) rethrows -> CodeObject {
    self.enterScope(node: node,
                    kind: kind,
                    argCount: argCount,
                    kwOnlyArgCount: kwOnlyArgCount)

    try block()
    let code = self.builder.finalize()
    self.leaveScope()

    return code
  }

  // MARK: - Enter scope

  /// Push a new scope (and generate a new code object builder to emit to).
  ///
  /// compiler_enter_scope(struct compiler *c, identifier name, ...)
  private func enterScope<N: ASTNode>(node: N,
                                      kind: CodeObject.Kind,
                                      argCount: Int,
                                      kwOnlyArgCount: Int) {

    guard let scope = self.symbolTable.scopeByNode[node] else {
      trap("[BUG] Compiler: Entering scope that is not present in symbol table.")
    }

    assert(self.hasKind(scope: scope, kind: kind))

    let name = self.createName(scope: scope, kind: kind)
    let qualifiedName = self.createQualifiedName(name: name, kind: kind)
    let flags = self.createFlags(scope: scope, kind: kind)
    let symbolNames = self.gatherSymbolNames(scope: scope)

    let builder = CodeObjectBuilder(name: name,
                                    qualifiedName: qualifiedName,
                                    filename: self.filename,
                                    kind: kind,
                                    flags: flags,
                                    variableNames: symbolNames.variable,
                                    freeVariableNames: symbolNames.free,
                                    cellVariableNames: symbolNames.cell,
                                    argCount: argCount,
                                    kwOnlyArgCount: kwOnlyArgCount,
                                    firstLine: node.start.line)

    let className = kind == .class ? name : nil
    let unit = CompilerUnit(className: className, scope: scope, builder: builder)
    self.unitStack.append(unit)
  }

  // MARK: - Leave scope

  /// Pop a scope (along with corresponding code object builder).
  ///
  /// compiler_exit_scope(struct compiler *c)
  private func leaveScope() {
    let unit = self.unitStack.popLast()
    if unit == nil {
      trap("[BUG] Compiler: Attempting to pop non-existing unit.")
    }
  }

  // MARK: - Has kind

  private func hasKind(scope: SymbolScope, kind: CodeObject.Kind) -> Bool {
    let scopeKind = scope.kind

    switch kind {
    case .module:
      return scopeKind == .module
    case .class:
      return scopeKind == .class
    case .function,
         .asyncFunction,
         .lambda,
     .comprehension:
      return scopeKind == .function
    }
  }

  // MARK: - Create name

  private func createName(scope: SymbolScope, kind: CodeObject.Kind) -> String {
    switch kind {
    case .module:
      return CodeObject.Names.module
    case .lambda:
      return CodeObject.Names.lambda
    case .comprehension:
      return scope.name
    case .class,
         .function,
         .asyncFunction:
      return scope.name
    }
  }

  // MARK: - Create qualified name

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
  private func createQualifiedName(name: String, kind: CodeObject.Kind) -> String {
    // Top scope has "" as qualified name.
    guard let parentUnit = self.unitStack.last else {
      return ""
    }

    let isTopLevel = self.unitStack.count == 1
    if isTopLevel {
      return name
    }

    /// Is this a special case? (see docstring)
    let isGlobalNestedInOtherScope: Bool = {
      guard kind == .function || kind == .asyncFunction || kind == .class else {
        return false
      }

      let mangled = MangledName(className: parentUnit.className, name: name)
      let info = parentUnit.scope.symbols[mangled]
      return info?.flags.contains(.srcGlobalExplicit) ?? false
    }()

    if isGlobalNestedInOtherScope {
      return name
    }

    /// Otherwise just concat to parent
    let parentKind = parentUnit.builder.kind
    let isParentFunction = parentKind == .function
                        || parentKind == .asyncFunction
                        || parentKind == .lambda

    let locals = isParentFunction ? ".<locals>" : ""
    let parentQualifiedName = parentUnit.builder.qualifiedName
    return parentQualifiedName + locals + "." + name
  }

  // MARK: - Create flags

  /// static int
  /// compute_code_flags(struct compiler *c)
  private func createFlags(scope: SymbolScope,
                           kind: CodeObject.Kind) -> CodeObject.Flags {
    var result = CodeObject.Flags()

    if scope.kind == .function {
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

  // MARK: - Variable names

  private struct SymbolNames {
    fileprivate let variable: [MangledName]
    fileprivate let free: [MangledName]
    fileprivate let cell: [MangledName]
  }

  /// In CPython they do this inside:
  /// compiler_enter_scope(struct compiler *c, identifier name, ...)
  /// which internally uses:
  /// dictbytype(PyObject *src, int scope_type, int flag, Py_ssize_t offset)
  private func gatherSymbolNames(scope: SymbolScope) -> SymbolNames {
    var parameterNames = [MangledName]()
    var localNames = [MangledName]()
    var cellNames = [MangledName]()
    var freeNames = [MangledName]()

    for (name, symbol) in scope.symbols {
      let flags = symbol.flags

      if flags.contains(.defParam) {
        parameterNames.append(name)
      } else if flags.contains(.srcLocal) { // local but not param!
        localNames.append(name)
      }

      if flags.contains(.srcFree) || flags.contains(.defFreeClass) {
        freeNames.append(name)
      }

      if flags.contains(.cell) {
        cellNames.append(name)
      }
    }

    // Sort, so that we have a deterministic index order.
    func sort(names: inout [MangledName]) {
      names.sort { lhs, rhs in lhs.value < rhs.value }
    }

    sort(names: &localNames)
    sort(names: &freeNames)
    sort(names: &cellNames)

    // In 'variableNames' we have to put parameters before locals.
    let variableNames = parameterNames + localNames
    assert(parameterNames == scope.parameterNames)

    // Append implicit '__class__' cell.
    if scope.needsClassClosure {
      assert(scope.kind == .class) // needsClassClosure can only be set on class
      cellNames.append(MangledName(withoutClass: SpecialIdentifiers.__class__))
    }

    return SymbolNames(variable: variableNames, free: freeNames, cell: cellNames)
  }
}
