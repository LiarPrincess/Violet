import Foundation
import Core
import Parser
import Bytecode

// In CPython:
// Python -> compile.c

extension Compiler {

  /// compiler_visit_stmt(struct compiler *c, stmt_ty s)
  internal func visitStatements<S: Sequence>(_ stmts: S) throws
    where S.Element == Statement {

    for s in stmts {
      try self.visitStatement(s)
    }
  }

  /// compiler_visit_stmt(struct compiler *c, stmt_ty s)
  internal func visitStatement(_ stmt: Statement) throws {
    // swiftlint:disable:previous function_body_length cyclomatic_complexity
    let location = stmt.start

    switch stmt.kind {
    case let .functionDef(name, args, body, decorators, returns):
      try self.visitFunctionDef(name: name,
                                args: args,
                                body: body,
                                decorators: decorators,
                                returns: returns,
                                statement: stmt)
    case .asyncFunctionDef:
      throw self.notImplemented()

case let .classDef(name, bases, keywords, body, decorators):
  try self.visitClassDef(name:  name,
                         bases: bases,
                         keywords: keywords,
                         body: body,
                         decorators: decorators)

    case let .assign(targets, value):
      try self.visitAssign(targets:  targets, value:    value, location: location)
    case let .augAssign(target, op, value):
      try self.visitAugAssign(target:   target,
                              op:       op,
                              value:    value,
                              location: location)
    case let .annAssign(target, annotation, value, isSimple):
      try self.visitAnnAssign(target:     target,
                              annotation: annotation,
                              value:    value,
                              isSimple: isSimple,
                              location: location)

    case let .for(target, iter, body, orElse):
      try self.visitFor(target: target,
                        iter:   iter,
                        body:   body,
                        orElse: orElse,
                        location: location)
    case .asyncFor:
      throw self.notImplemented()

    case let .while(test, body, orElse):
      try self.visitWhile(test: test, body: body, orElse: orElse, location: location)

    case let .if(test, body, orElse):
      try self.visitIf(test: test, body: body, orElse: orElse, location: location)

    case let .with(items, body):
      try self.visitWith(items: items, body: body, location: location)
    case .asyncWith:
      throw self.notImplemented()

    case let .raise(exception, cause):
      try self.visitRaise(exception: exception, cause: cause, location: location)
case let .try(body, handlers, orElse, finalBody):
  try self.visitTry(body: body,
                    handlers: handlers,
                    orElse: orElse,
                    finalBody: finalBody)

    case let .import(aliases):
      try self.visitImport(aliases:  aliases, location: location)
    case let .importFrom(module, aliases, level):
      try self.visitImportFrom(module:   module,
                               aliases:  aliases,
                               level:    level,
                               location: location)

    case let .expr(expr):
      try self.visitExpressionStatement(expr, location: location)

    case let .assert(test, msg):
      try self.visitAssert(test: test, msg: msg, location: location)
    case let .delete(exprs):
      try self.visitExpressions(exprs, context: .del)
    case let .return(exprs):
      try self.visitReturn(value: exprs, location: location)
    case .break:
      try self.visitBreak(location: location)
    case .continue:
      try self.visitContinue(location: location)
      // TODO: Add missing cases in 'continue' implementation

    case .pass:
      break
    case .global,
         .nonlocal:
      // This will be taken from symbol table when emitting expressions.
      break
    }
  }

  // MARK: - Return

  /// compiler_visit_stmt(struct compiler *c, stmt_ty s)
  private func visitReturn(value: Expression?, location: SourceLocation) throws {
    guard self.currentScope.type == .function else {
      throw self.error(.returnOutsideFunction, location: location)
    }

    if let v = value {
      if self.currentScope.isCoroutine || self.currentScope.isGenerator {
        throw self.error(.returnWithValueInAsyncGenerator, location: location)
      }

      try self.visitExpression(v)
    } else {
      try self.builder.emitNone(location: location)
    }

    try self.builder.emitReturn(location: location)
  }

  // MARK: - Class

  private func visitClassDef(name: String,
                             bases: [Expression],
                             keywords: [Keyword],
                             body: NonEmptyArray<Statement>,
                             decorators: [Expression]) throws {
  }

  // MARK: - Try/catch

  /// compiler_visit_stmt(struct compiler *c, stmt_ty s)
  private func visitRaise(exception: Expression?,
                          cause:     Expression?,
                          location:  SourceLocation) throws {
    var arg = RaiseArg.reRaise
    if let e = exception {
      try self.visitExpression(e)
      arg = .exceptionOnly

      if let c = cause {
        try self.visitExpression(c)
        arg = .exceptionAndCause
      }
    }

    try self.builder.emitRaiseVarargs(arg: arg, location: location)
  }

  private func visitTry(body: NonEmptyArray<Statement>,
                        handlers: [ExceptHandler],
                        orElse: [Statement],
                        finalBody: [Statement]) throws {
  }

  // MARK: - Assert

  /// compiler_assert(struct compiler *c, stmt_ty s)
  private func visitAssert(test: Expression,
                           msg:  Expression?,
                           location: SourceLocation) throws {
    if self.optimizationLevel > 0 {
      return
    }

    if case let .tuple(elements) = test.kind, elements.any {
      self.warn(.assertionWithTuple, location: location)
    }

    let end = self.builder.addLabel()
    try self.visitExpression(test,
                             andJumpTo: end,
                             ifBooleanValueIs: true,
                             location: location)

    let id = SpecialIdentifiers.assertionError
    try self.builder.emitString(id, location: location)

    if let message = msg {
      // Call 'AssertionError' with single argument
      try self.visitExpression(message)
      try self.builder.emitCallFunction(argumentCount: 1, location: location)
    }

    try self.builder.emitRaiseVarargs(arg: .exceptionOnly, location: location)
    self.builder.setLabel(end)
  }

  // MARK: - Expression statement

  /// compiler_visit_stmt_expr(struct compiler *c, expr_ty value)
  private func visitExpressionStatement(_ expr: Expression,
                                        location: SourceLocation) throws {
    if self.isInteractive && self.nestLevel <= 1 {
      try self.visitExpression(expr)
      try self.builder.emitPrintExpr(location: location)
      return
    }

    // TODO: if (is_const(value)) {

    try self.visitExpression(expr)
    try self.builder.emitPopTop(location: location)
  }
}
