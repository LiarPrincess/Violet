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

// swiftlint:disable function_body_length

  /// compiler_visit_stmt(struct compiler *c, stmt_ty s)
  internal func visitStatement(_ stmt: Statement) throws {
// swiftlint:enable function_body_length
    self.setAppendLocation(stmt)

    switch stmt.kind {
    case let .functionDef(name, args, body, decorators, returns):
      try self.visitFunctionDef(name: name,
                                args: args,
                                body: body,
                                decorators: decorators,
                                returns: returns,
                                statement: stmt)
    case .asyncFunctionDef:
      throw self.notImplementedAsync()

    case let .classDef(name, bases, keywords, body, decorators):
      try self.visitClassDef(name:  name,
                             bases: bases,
                             keywords: keywords,
                             body: body,
                             decorators: decorators,
                             statement: stmt)

    case let .assign(targets, value):
      try self.visitAssign(targets: targets, value: value)
    case let .augAssign(target, op, value):
      try self.visitAugAssign(target: target, op: op, value: value)
    case let .annAssign(target, annotation, value, isSimple):
      try self.visitAnnAssign(target:     target,
                              annotation: annotation,
                              value:    value,
                              isSimple: isSimple)

    case let .for(target, iter, body, orElse):
      try self.visitFor(target: target,
                        iter:   iter,
                        body:   body,
                        orElse: orElse)
    case .asyncFor:
      throw self.notImplementedAsync()

    case let .while(test, body, orElse):
      try self.visitWhile(test: test, body: body, orElse: orElse)

    case let .if(test, body, orElse):
      try self.visitIf(test: test, body: body, orElse: orElse)

    case let .with(items, body):
      try self.visitWith(items: items, body: body)
    case .asyncWith:
      throw self.notImplementedAsync()

    case let .raise(exception, cause):
      try self.visitRaise(exception: exception, cause: cause)
    case let .try(body, handlers, orElse, finally):
      try self.visitTry(body: body,
                        handlers: handlers,
                        orElse:   orElse,
                        finally:  finally)

    case let .import(aliases):
      try self.visitImport(aliases: aliases)
    case let .importFrom(module, aliases, level):
      try self.visitImportFrom(module:  module,
                               aliases: aliases,
                               level:   level,
                               location: stmt.start)
    case let .importFromStar(module, level):
      try self.visitImportFromStar(module: module,
                                   level: level,
                                   location: stmt.start)

    case let .expr(expr):
      try self.visitExpressionStatement(expr)

    case let .assert(test, msg):
      try self.visitAssert(test: test, msg: msg)

    case let .delete(exprs):
      try self.visitExpressions(exprs, context: .del)

    case let .return(exprs):
      try self.visitReturn(value: exprs)

    case .break:
      try self.visitBreak()
    case .continue:
      try self.visitContinue()

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
  private func visitReturn(value: Expression?) throws {
    guard self.currentScope.type == .function else {
      throw self.error(.returnOutsideFunction)
    }

    if let v = value {
      if self.currentScope.isCoroutine || self.currentScope.isGenerator {
        throw self.error(.returnWithValueInAsyncGenerator)
      }

      try self.visitExpression(v)
    } else {
      self.builder.appendNone()
    }

    self.builder.appendReturn()
  }

  // MARK: - Assert

  /// compiler_assert(struct compiler *c, stmt_ty s)
  private func visitAssert(test: Expression, msg:  Expression?) throws {
    guard self.options.optimizationLevel == .none else {
      return
    }

    if case let .tuple(elements) = test.kind, elements.any {
      self.warn(.assertionWithTuple)
    }

    let end = self.builder.createLabel()
    try self.visitExpression(test, andJumpTo: end, ifBooleanValueIs: true)
    self.builder.appendLoadGlobal(SpecialIdentifiers.assertionError)

    if let message = msg {
      // Call 'AssertionError' with single argument
      try self.visitExpression(message)
      self.builder.appendCallFunction(argumentCount: 1)
    }

    self.builder.appendRaiseVarargs(arg: .exceptionOnly)
    self.builder.setLabel(end)
  }

  // MARK: - Expression statement

  /// compiler_visit_stmt_expr(struct compiler *c, expr_ty value)
  private func visitExpressionStatement(_ expr: Expression) throws {
    if self.isInteractive && self.nestLevel <= 1 {
      try self.visitExpression(expr)
      self.builder.appendPrintExpr()
      return
    }

    try self.visitExpression(expr)
    self.builder.appendPopTop()
  }
}
