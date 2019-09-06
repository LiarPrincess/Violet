import Foundation
import Core
import Parser
import Bytecode

// In CPython:
// Python -> compile.c

// swiftlint:disable function_parameter_count
// swiftlint:disable function_body_length

extension Compiler {

  /// compiler_function(struct compiler *c, stmt_ty s, int is_async)
  internal func visitFunctionDef(name: String,
                                 args: Arguments,
                                 body: NonEmptyArray<Statement>,
                                 decorators: [Expression],
                                 returns:    Expression?,
                                 statement:  Statement) throws {

    let location = statement.start
    try self.visitDecorators(decorators: decorators, location: location)

    var flags: FunctionFlags = []
    try self.visitDefaultArguments(args: args,
                                   updating: &flags,
                                   location: location)
    try self.visitAnnotations(args: args,
                              returns: returns,
                              updating: &flags,
                              location: location)

    // Body
    // If we ever get recoverable errors, then remember to exit scope on error!
    // (every 'try' is possible error)

    self.enterScope(node: statement, type: .function)

    let optimizationLevel = self.options.optimizationLevel
    if let docString = self.getDocString(body.first), optimizationLevel < 2 {
      try self.codeObject.emitString(docString, location: location)
    }

    try self.visitStatements(body)
    let qualifiedName = self.codeObject.qualifiedName
    let codeObject = self.leaveScope()

    try self.makeClosure(codeObject: codeObject,
                         qualifiedName: qualifiedName,
                         flags: flags,
                         location: location)

    for _ in decorators {
      try self.codeObject.emitCallFunction(argumentCount: 1, location: location)
    }

    try self.codeObject.emitStoreName(name: name, location: location)
  }

  // MARK: - Decorators

  private func visitDecorators(decorators: [Expression],
                               location: SourceLocation) throws {
    try self.visitExpressions(decorators)
  }

  // MARK: - Defaults

  /// compiler_default_arguments(struct compiler *c, arguments_ty args)
  private func visitDefaultArguments(args: Arguments,
                                     updating flags: inout FunctionFlags,
                                     location: SourceLocation) throws {
    if args.defaults.any {
      flags.formUnion(.hasPositionalArgDefaults)
      try self.visitExpressions(args.defaults)
      try self.codeObject.emitBuildTuple(elementCount: args.defaults.count,
                                         location: location)
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
  private func visitKwOnlyDefaults(kwOnlyArgs:     [Arg],
                                   kwOnlyDefaults: [Expression],
                                   updating flags: inout FunctionFlags,
                                   location: SourceLocation) throws {
    assert(kwOnlyArgs.count == kwOnlyDefaults.count)

    var names = [MangledName]()
    for (arg, def) in zip(kwOnlyArgs, kwOnlyDefaults) {
      if def.kind == .none {
        continue
      }

      names.append(self.mangleName(arg.name))
      try self.visitExpression(def)
    }

    if names.any {
      flags.formUnion(.hasKwOnlyArgDefaults)
      let elements = names.map { Constant.string($0.value) }
      try self.codeObject.emitTuple(elements, location: location)
      try self.codeObject.emitBuildConstKeyMap(elementCount: names.count,
                                               location: location)
    }
  }

  // MARK: - Annotation

  /// compiler_visit_annotations(struct compiler *c, arguments_ty args, ...)
  private func visitAnnotations(args: Arguments,

                                returns: Expression?,
                                updating flags: inout FunctionFlags,
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

    try self.visitArgAnnotation(name: SpecialIdentifiers.return,
                                annotation: returns,
                                appendingNameTo: &names,
                                location: location)

    if names.any {
      flags.formUnion(.hasAnnotations)
      let elements = names.map { Constant.string($0.value) }
      try self.codeObject.emitTuple(elements, location: location)
      try self.codeObject.emitBuildConstKeyMap(elementCount: names.count,
                                               location: location)
    }
  }

  /// compiler_visit_argannotations(struct compiler *c, asdl_seq* args, ...)
  private func visitArgAnnotations(args: [Arg],
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
      try self.visitAnnExpr(ann, location: location)
    } else {
      try self.visitExpression(ann)
    }

    names.append(self.mangleName(name))
  }

  // MARK: - Closure

  /// compiler_make_closure(struct compiler *c, PyCodeObject *co,
  /// Py_ssize_t flags, PyObject *qualname)
  private func makeClosure(codeObject: CodeObject,
                           qualifiedName: String,
                           flags:    FunctionFlags,
                           location: SourceLocation) throws {
    var makeFunctionFlags = flags

    if codeObject.freeVars.any {
      for (freeIndex, name) in codeObject.freeVars.enumerated() {
        // If a class contains a method with a *free variable* that has the same
        // name as a *method*, the name will be considered free and local.

        var index = ClosureIndex.free(freeIndex)

        let flags = self.getRefType(name: name, qualifiedName: qualifiedName)
        if flags.contains(.cell) {
          if let i = codeObject.cellVars.firstIndex(of: name) {
            index = .cell(i)
          } else {
            assert(false)
          }
        }

        try self.codeObject.emitLoadClosure(index: index, location: location)
      }

      let count = codeObject.freeVars.count
      try self.codeObject.emitBuildTuple(elementCount: count, location: location)
      makeFunctionFlags.formUnion(.hasFreeVariables)
    }

    try self.codeObject.emitCode(codeObject, location: location)
    try self.codeObject.emitString(qualifiedName, location: location)
    try self.codeObject.emitMakeFunction(flags: makeFunctionFlags,
                                         location: location)
  }

  private func getRefType(name: MangledName,
                          qualifiedName: String) -> SymbolFlags {
    let classId = SpecialIdentifiers.__class__
    if self.codeObject.type == .class && name.value == classId {
      return .cell
    }

    if let scope = self.currentScope.symbols[name] {
      return scope.flags
    }

    fatalError(
      "[BUG] Compiler: Unknown scope for '\(name)' inside '\(qualifiedName)'.")
  }
}
