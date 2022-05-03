import Foundation
import VioletCore
import VioletParser
import VioletBytecode

// In CPython:
// Python -> compile.c

// cSpell:ignore decos ssize argannotation argannotations kwonlyargs kwonlydefaults

extension CompilerImpl {

  // MARK: - Lambda

  internal func visit(_ node: LambdaExpr) throws {
    let location = node.start

    var flags: Instruction.FunctionFlags = []
    try self.visitDefaultArguments(args: node.args,
                                   updating: &flags,
                                   location: location)

    let argCount = node.args.args.count
    let posOnlyArgCount = node.args.posOnlyArgCount
    let kwOnlyArgCount = node.args.kwOnlyArgs.count

    let codeObject = try self.inNewCodeObject(node: node,
                                              argCount: argCount,
                                              posOnlyArgCount: posOnlyArgCount,
                                              kwOnlyArgCount: kwOnlyArgCount) {
      assert(self.builder.kind == .lambda)

      // Make 'None' the first constant, so the lambda can't have a docstring.
      self.builder.addNoneConstant()

      try self.visit(node.body)
      if !self.currentScope.isGenerator {
        self.builder.appendReturn()
      }
    }

    try self.makeClosure(codeObject: codeObject, flags: flags, location: location)
  }

  // MARK: - Function

  /// compiler_function(struct compiler *c, stmt_ty s, int is_async)
  internal func visit(_ node: FunctionDefStmt) throws {
    let location = node.start
    try self.visitDecorators(decorators: node.decorators, location: location)

    var flags: Instruction.FunctionFlags = []
    try self.visitDefaultArguments(args: node.args,
                                   updating: &flags,
                                   location: location)
    try self.visitAnnotations(args: node.args,
                              returns: node.returns,
                              updating: &flags,
                              location: location)

    let argCount = node.args.args.count
    let posOnlyArgCount = node.args.posOnlyArgCount
    let kwOnlyArgCount = node.args.kwOnlyArgs.count

    let codeObject = try self.inNewCodeObject(node: node,
                                              argCount: argCount,
                                              posOnlyArgCount: posOnlyArgCount,
                                              kwOnlyArgCount: kwOnlyArgCount) {
      assert(self.builder.kind == .function)
      try self.visitBody(body: node.body, onDoc: .appendToConstants)
      try self.appendReturn(addNone: true)
    }

    try self.makeClosure(codeObject: codeObject, flags: flags, location: location)

    for _ in node.decorators {
      self.builder.appendCallFunction(argumentCount: 1)
    }

    self.visitName(name: node.name, context: .store)
  }

  // MARK: - Decorators

  /// compiler_decorators(struct compiler *c, asdl_seq* decos)
  internal func visitDecorators(decorators: [Expression],
                                location: SourceLocation) throws {
    try self.visit(decorators)
  }

  // MARK: - Defaults

  /// compiler_default_arguments(struct compiler *c, arguments_ty args)
  private func visitDefaultArguments(args: Arguments,
                                     updating flags: inout Instruction.FunctionFlags,
                                     location: SourceLocation) throws {
    if args.defaults.any {
      flags.formUnion(.hasPositionalArgDefaults)
      try self.visit(args.defaults)
      self.builder.appendBuildTuple(elementCount: args.defaults.count)
    }

    if args.kwOnlyArgs.any {
      try self.visitKwOnlyDefaults(kwOnlyArgs: args.kwOnlyArgs,
                                   kwOnlyDefaults: args.kwOnlyDefaults,
                                   updating: &flags,
                                   location: location)
    }
  }

  /// compiler_visit_kwonlydefaults(struct compiler *c, asdl_seq *kwonlyargs,
  /// asdl_seq *kw_defaults)
  private func visitKwOnlyDefaults(kwOnlyArgs: [Argument],
                                   kwOnlyDefaults: [Expression],
                                   updating flags: inout Instruction.FunctionFlags,
                                   location: SourceLocation) throws {
    assert(kwOnlyArgs.count == kwOnlyDefaults.count)

    var names = [MangledName]()
    for (arg, def) in zip(kwOnlyArgs, kwOnlyDefaults) {
      if def is NoneExpr {
        continue
      }

      names.append(self.mangle(name: arg.name))
      try self.visit(def)
    }

    if names.any {
      flags.formUnion(.hasKwOnlyArgDefaults)
      let elements = names.map { CodeObject.Constant.string($0.value) }
      self.builder.appendTuple(elements)
      self.builder.appendBuildConstKeyMap(elementCount: names.count)
    }
  }

  // MARK: - Annotation

  /// compiler_visit_annotations(struct compiler *c, arguments_ty args, ...)
  private func visitAnnotations(args: Arguments,
                                returns: Expression?,
                                updating flags: inout Instruction.FunctionFlags,
                                location: SourceLocation) throws {
    var names = [MangledName]()
    try self.visitArgAnnotations(args: args.args,
                                 appendingNamesTo: &names,
                                 location: location)

    if case let .named(a) = args.vararg {
      try self.visitArgAnnotation(name: a.name,
                                  annotation: a.annotation,
                                  appendingNameTo: &names,
                                  location: location)
    }

    try self.visitArgAnnotations(args: args.kwOnlyArgs,
                                 appendingNamesTo: &names,
                                 location: location)

    if let a = args.kwarg {
      try self.visitArgAnnotation(name: a.name,
                                  annotation: a.annotation,
                                  appendingNameTo: &names,
                                  location: location)
    }

    try self.visitArgAnnotation(name: SpecialIdentifiers.returnAnnotationKey,
                                annotation: returns,
                                appendingNameTo: &names,
                                location: location)

    if names.any {
      flags.formUnion(.hasAnnotations)
      let elements = names.map { CodeObject.Constant.string($0.value) }
      self.builder.appendTuple(elements)
      self.builder.appendBuildConstKeyMap(elementCount: names.count)
    }
  }

  /// compiler_visit_argannotations(struct compiler *c, asdl_seq* args, ...)
  private func visitArgAnnotations(args: [Argument],
                                   appendingNamesTo names: inout [MangledName],
                                   location: SourceLocation) throws {
    for a in args {
      try self.visitArgAnnotation(name: a.name,
                                  annotation: a.annotation,
                                  appendingNameTo: &names,
                                  location: location)
    }
  }

  /// compiler_visit_argannotation(struct compiler *c, identifier id, ...)
  private func visitArgAnnotation(name: String,
                                  annotation: Expression?,
                                  appendingNameTo names: inout [MangledName],
                                  location: SourceLocation) throws {
    guard let ann = annotation else {
      return
    }

    if self.future.flags.contains(.annotations) {
      try self.visitAnnExpr(ann)
    } else {
      try self.visit(ann)
    }

    names.append(self.mangle(name: name))
  }

  // MARK: - Closure

  /// compiler_make_closure(struct compiler *c, PyCodeObject *co,
  /// Py_ssize_t flags, PyObject *qualname)
  internal func makeClosure(codeObject: CodeObject,
                            flags: Instruction.FunctionFlags,
                            location: SourceLocation) throws {
    let qualifiedName = codeObject.qualifiedName
    var makeFunctionFlags = flags

    if codeObject.freeVariableNames.any {
      for name in codeObject.freeVariableNames {
        // If a class contains a method with a *free variable* that has the same
        // name as a *method*, the name will be considered free and local.
        //
        // The local var is a method and the free var is a free var referenced
        // within a method.

        let refType = self.getRefType(name: name, qualifiedName: qualifiedName)
        switch refType.contains(.cell) {
        case true:
          self.builder.appendLoadClosureCell(name: name)
        case false:
          self.builder.appendLoadClosureFree(name: name)
        }
      }

      let freeVariableCount = codeObject.freeVariableNames.count
      self.builder.appendBuildTuple(elementCount: freeVariableCount)
      makeFunctionFlags.formUnion(.hasFreeVariables)
    }

    self.builder.appendCode(codeObject)
    self.builder.appendString(qualifiedName)
    self.builder.appendMakeFunction(flags: makeFunctionFlags)
  }

  private func getRefType(name: MangledName,
                          qualifiedName: String) -> SymbolInfo.Flags {
    // class Princess:
    //     def sing():
    //         __class__
    let is__class__ = name.value == SpecialIdentifiers.__class__
    let isInsideClass = self.builder.kind == .class
    if is__class__ && isInsideClass {
      return .cell
    }

    if let scope = self.currentScope.symbols[name] {
      return scope.flags
    }

    trap("[BUG] Compiler: Unknown scope for '\(name)' inside '\(qualifiedName)'.")
  }
}
