import Foundation
import Core
import Parser
import Bytecode

// In CPython:
// Python -> compile.c

// swiftlint:disable cyclomatic_complexity
// swiftlint:disable function_body_length
// swiftlint:disable switch_case_alignment
// swiftlint:disable file_length

extension Compiler {

  internal func visitStatements<S: Sequence>(_ stmts: S) throws
    where S.Element == Statement {

    for s in stmts {
      try self.visitStatement(s)
    }
  }

  internal func visitStatement(_ stmt: Statement) throws {
    let location = stmt.start

    switch stmt.kind {
case let .functionDef(name, args, body, decoratorList, returns):
  try self.visitFunctionDef(name: name,
                            args: args,
                            body: body,
                            decoratorList: decoratorList,
                            returns: returns)
case let .asyncFunctionDef(name, args, body, decoratorList, returns):
  try self.visitAsyncFunctionDef(name: name,
                                 args: args,
                                 body: body,
                                 decoratorList: decoratorList,
                                 returns: returns)

case let .classDef(name, bases, keywords, body, decoratorList):
  try self.visitClassDef(name: name,
                         bases: bases,
                         keywords: keywords,
                         body: body,
                         decoratorList: decoratorList)

    case let .return(exprs):
      try self.visitReturn(value: exprs, location: location)
    case let .delete(exprs):
      try self.visitExpressions(exprs, context: .del)

    case let .assign(targets, value):
      try self.visitAssign(targets: targets, value: value, location: location)
case let .augAssign(target, op, value):
  try self.visitAugAssign(target: target, op: op, value: value)
case let .annAssign(target, annotation, value, isSimple):
  try self.visitAnnAssign(target: target,
                          annotation: annotation,
                          value: value,
                          isSimple: isSimple)

case let .for(target, iter, body, orElse):
  try self.visitFor(target: target, iter: iter, body: body, orElse: orElse)
case let .asyncFor(target, iter, body, orElse):
  try self.visitAsyncFor(target: target, iter: iter, body: body, orElse: orElse)

case let .while(test, body, orElse):
  try self.visitWhile(test: test, body: body, orElse: orElse)

case let .if(test, body, orElse):
  try self.visitIf(test: test, body: body, orElse: orElse)

case let .with(items, body):
  try self.visitWith(items: items, body: body)
case let .asyncWith(items, body):
  try self.visitAsyncWith(items: items, body: body)

    case let .raise(exception, cause):
      try self.visitRaise(exception: exception, cause: cause, location: location)
case let .try(body, handlers, orElse, finalBody):
  try self.visitTry(body: body, handlers: handlers, orElse: orElse, finalBody: finalBody)

    case let .assert(test, msg):
      try self.visitAssert(test: test, msg: msg, location: location)

case let .import(value):
  try self.visitImport(value: value)
case let .importFrom(moduleName, names, level):
  try self.visitImportFrom(moduleName: moduleName, names: names, level: level)

case let .expr(expr):
  try self.visitExpressionStatement(expr: expr)

    case .break:
      try self.visitBreak(location: location)
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

  // MARK: - Function

  private func visitFunctionDef(name: String,
                                args: Arguments,
                                body: NonEmptyArray<Statement>,
                                decoratorList: [Expression],
                                returns: Expression?) throws {
  }

  private func visitAsyncFunctionDef(name: String,
                                     args: Arguments,
                                     body: NonEmptyArray<Statement>,
                                     decoratorList: [Expression],
                                     returns: Expression?) throws {
  }

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
                             decoratorList: [Expression]) throws {
  }

  // MARK: - Assign

  /// compiler_visit_stmt(struct compiler *c, stmt_ty s)
  ///
  /// `dis.dis('a = b = c = 5')` gives us:
  /// ```c
  ///  0 LOAD_CONST               0 (5)
  ///  2 DUP_TOP
  ///  4 STORE_NAME               0 (a)
  ///  6 DUP_TOP
  ///  8 STORE_NAME               1 (b)
  /// 10 STORE_NAME               2 (c)
  /// 12 LOAD_CONST               1 (None)
  /// 14 RETURN_VALUE
  /// ```
  private func visitAssign(targets:  NonEmptyArray<Expression>,
                           value:    Expression,
                           location: SourceLocation) throws {

    try self.visitExpression(value)
    for (index, t) in targets.enumerated() {
      if index < targets.count {
        try self.builder.emitDupTop(location: location)
      }

      try self.visitExpression(t, context: .store)
    }
  }

  private func visitAugAssign(target: Expression,
                              op: BinaryOperator,
                              value: Expression) throws {
  }

  private func visitAnnAssign(target: Expression,
                              annotation: Expression,
                              value: Expression?,
                              isSimple: Bool) throws {
  }

  // MARK: - Loops

  private func visitFor(target: Expression,
                        iter: Expression,
                        body: NonEmptyArray<Statement>,
                        orElse: [Statement]) throws {
  }

  private func visitAsyncFor(target: Expression,
                             iter: Expression,
                             body: NonEmptyArray<Statement>,
                             orElse: [Statement]) throws {
  }

  private func visitBreak(location: SourceLocation) throws {
    if !self.isInLoop {
      throw self.error(.breakOutsideLoop, location: location)
    }

    try self.builder.emitBreak(location: location)
  }

  private var isInLoop: Bool {
    return false
  }

  private func visitContinue() throws {
  }

  private func visitWhile(test: Expression,
                          body: NonEmptyArray<Statement>,
                          orElse: [Statement]) throws {
  }

  // MARK: - If

  private func visitIf(test: Expression,
                       body: NonEmptyArray<Statement>,
                       orElse: [Statement]) throws {
  }

  // MARK: - With

  private func visitWith(items: NonEmptyArray<WithItem>,
                         body: NonEmptyArray<Statement>) throws {
  }

  private func visitAsyncWith(items: NonEmptyArray<WithItem>,
                              body: NonEmptyArray<Statement>) throws {
  }

  // MARK: - Import

  private func visitImport(value: NonEmptyArray<Alias>) throws {
  }

  private func visitImportFrom(moduleName: String?,
                               names: NonEmptyArray<Alias>,
                               level: UInt8) throws {
  }

  // MARK: - Try/catch

  /// compiler_visit_stmt(struct compiler *c, stmt_ty s)
  private func visitRaise(exception: Expression?,
                          cause:     Expression?,
                          location:  SourceLocation) throws {
    var arg = RaiseArg.none
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
    if self.optimize {
      return
    }

    if case let .tuple(elements) = test.kind, elements.any {
      self.warn(.assertionWithTuple, location: location)
    }

    let end = try self.builder.addLabel()
    try self.visitExpression(test,
                             andJumpTo: end,
                             ifBooleanValueIs: true,
                             location: location)

    // TODO: Do we really want to do it this way?
    try self.builder.emitString("AssertionError", location: location)

    if let message = msg {
      // Call 'AssertionError' with single argument
      try self.visitExpression(message)
      try self.builder.emitCallFunction(argumentCount: 1, location: location)
    }

    try self.builder.emitRaiseVarargs(arg: .exceptionOnly, location: location)
    self.builder.setLabel(end)
  }

  // MARK: - Expression statement

  private func visitExpressionStatement(expr: Expression) throws {
  }
}
