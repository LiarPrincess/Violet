import Foundation
import Core
import Parser
import Bytecode

// In CPython:
// Python -> compile.c

extension Compiler {

  /// compiler_function(struct compiler *c, stmt_ty s, int is_async)
  internal func visitFunctionDef(name: String,
 // swiftlint:disable:previous function_parameter_count
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

    if let docString = self.getDocString(body.first),
        self.options.optimizationLevel < 2 {

      try self.builder.emitString(docString, location: location)
    }

    try self.visitStatements(body)
    // TODO: qualname = c->u->u_qualname;
    self.leaveScope()

    // TODO: compiler_make_closure(c, co, funcflags, qualname);
    for _ in decorators {
      try self.builder.emitCallFunction(argumentCount: 1, location: location)
    }

    try self.builder.emitStoreName(name: name, location: location)
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
      try self.builder.emitBuildTuple(elementCount: args.defaults.count,
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

      let name = MangledName(className: self.className, name: arg.name)
      names.append(name)

      try self.visitExpression(def)
    }

    if names.any {
      flags.formUnion(.hasKwOnlyArgDefaults)
      let elements = names.map { Constant.string($0.value) }
      try self.builder.emitTuple(elements, location: location)
      try self.builder.emitBuildConstKeyMap(elementCount: names.count,
                                            location: location)
    }
  }

  // MARK: - Annotation

  /// compiler_visit_annotations(struct compiler *c, arguments_ty args, ...)
  private func visitAnnotations(args: Arguments,
  // swiftlint:disable:previous function_body_length
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
      try self.builder.emitTuple(elements, location: location)
      try self.builder.emitBuildConstKeyMap(elementCount: names.count,
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

    let mangled = MangledName(className: self.className, name: name)
    names.append(mangled)
  }
}
