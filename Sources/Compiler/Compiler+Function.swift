import Foundation
import Core
import Parser
import Bytecode

// In CPython:
// Python -> compile.c

// swiftlint:disable file_length
// swiftlint:disable function_parameter_count
// swiftlint:disable function_body_length

extension Compiler {

  // MARK: - Lambda

  internal func visitLambda(args: Arguments,
                            body: Expression,
                            expression: Expression) throws {
    let location = expression.start

    var flags: FunctionFlags = []
    try self.visitDefaultArguments(args: args,
                                   updating: &flags,
                                   location: location)

    let codeObject = try self.inNewCodeObject(node: expression, type: .lambda) {
      // Make None the first constant, so the lambda can't have a docstring.
      try self.builder.appendNone(at: location)

      try self.visitExpression(body)
      if !self.currentScope.isGenerator {
        try self.builder.appendReturn(at: location)
      }
    }

    try self.makeClosure(codeObject: codeObject, flags: flags, location: location)
  }

  // MARK: - Function

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

    let codeObject = try self.inNewCodeObject(node: statement, type: .function) {
      let optimizationLevel = self.options.optimizationLevel
      if let docString = body.first.getDocString(), optimizationLevel < 2 {
        try self.builder.appendString(docString, at: location)
      }

      try self.visitStatements(body)

      if !self.currentScope.hasReturnValue {
        try self.builder.appendNone(at: location)
        try self.builder.appendReturn(at: location)
      }
    }

    try self.makeClosure(codeObject: codeObject, flags: flags, location: location)

    for _ in decorators {
      try self.builder.appendCallFunction(argumentCount: 1, at: location)
    }

    try self.builder.appendStoreName(name, at: location)
  }

  // MARK: - Decorators

  /// compiler_decorators(struct compiler *c, asdl_seq* decos)
  internal func visitDecorators(decorators: [Expression],
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
      try self.builder.appendBuildTuple(elementCount: args.defaults.count, at: location)
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
      try self.builder.appendTuple(elements, at: location)
      try self.builder.appendBuildConstKeyMap(elementCount: names.count, at: location)
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
      try self.builder.appendTuple(elements, at: location)
      try self.builder.appendBuildConstKeyMap(elementCount: names.count, at: location)
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
  internal func makeClosure(codeObject: CodeObject,
                            flags:    FunctionFlags,
                            location: SourceLocation) throws {

    let qualifiedName = codeObject.qualifiedName
    var makeFunctionFlags = flags

    if codeObject.freeVars.any {
      for name in codeObject.freeVars {
        // If a class contains a method with a *free variable* that has the same
        // name as a *method*, the name will be considered free and local.

        // The local var is a method
        // and the free var is a free var referenced within a method.

        let flags = self.getRefType(name: name, qualifiedName: qualifiedName)
        let variable: ClosureVariable =
          flags.contains(.cell) ? .cell(name) : .free(name)

        try self.builder.appendLoadClosure(variable, at: location)
      }

      let count = codeObject.freeVars.count
      try self.builder.appendBuildTuple(elementCount: count, at: location)
      makeFunctionFlags.formUnion(.hasFreeVariables)
    }

    try self.builder.appendCode(codeObject, at: location)
    try self.builder.appendString(qualifiedName, at: location)
    try self.builder.appendMakeFunction(flags: makeFunctionFlags, at: location)
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
