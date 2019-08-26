import Foundation
import Core
import Parser
import Bytecode

// In CPython:
// Python -> compile.c

// swiftlint:disable function_body_length
// swiftlint:disable cyclomatic_complexity

extension Compiler {

  /// compiler_visit_expr(struct compiler *c, expr_ty e)
  internal func visitExpression<S: Sequence>(_ exprs: S,
                                   isAssignmentTarget: Bool = false) throws
    where S.Element == Expression {

      for e in exprs {
        try self.visitExpression(e)
      }
  }

  /// compiler_visit_expr(struct compiler *c, expr_ty e)
  internal func visitExpression(_ expr: Expression?) throws {
    if let e = expr {
      try self.visitExpression(e)
    }
  }

  /// compiler_visit_expr(struct compiler *c, expr_ty e)
  internal func visitExpression(_ expr: Expression) throws {
    switch expr.kind {
    case .true:
      try self.emitConstant(.true)
    case .false:
      try self.emitConstant(.false)
    case .none:
      try self.emitConstant(.none)
    case .ellipsis:
      try self.emitConstant(.ellipsis)

    case let .identifier(value):
      try self.visitIdentifier(value: value)

    case let .bytes(value):
      try self.visitBytes(value: value)
    case let .string(group):
      try self.visitString(group: group)

    case let .int(value):
      try self.emitConstant(.integer(value))
    case let .float(value):
      try self.emitConstant(.float(value))
    case let .complex(real, imag):
      try self.emitConstant(.complex(real: real, imag: imag))

    case let .unaryOp(op, right):
      try self.visitExpression(right)
      try self.emitUnaryOperator(op)
    case let .binaryOp(op, left, right):
      try self.visitExpression(left)
      try self.visitExpression(right)
      try emitBinaryOperator(op)
    case let .boolOp(op, left, right):
      try self.visitBoolOp(op: op, left: left, right: right)
    case let .compare(left, elements):
      try self.visitCompare(left: left, elements: elements)

    case let .tuple(value):
      try self.visitTuple(value: value)
    case let .list(value):
      try self.visitList(value: value)
    case let .dictionary(value):
      try self.visitDictionary(value: value)
    case let .set(value):
      try self.visitSet(value: value)

    case let .listComprehension(elt, generators):
      try self.visitListComprehension(elt: elt, generators: generators)
    case let .setComprehension(elt, generators):
      try self.visitSetComprehension(elt: elt, generators: generators)
    case let .dictionaryComprehension(key, value, generators):
      try self.visitDictionaryComprehension(key: key, value: value, generators: generators)
    case let .generatorExp(elt, generators):
      try self.visitGeneratorExp(elt: elt, generators: generators)

    case let .await(expr):
      try self.visitAwait(expr: expr)
    case let .yield(value):
      try self.visitYield(value: value)
    case let .yieldFrom(expr):
      try self.visitYieldFrom(expr: expr)

    case let .lambda(args, body):
      try self.visitLambda(args: args, body: body)
    case let .call(f, args, keywords):
      try self.visitCall(f: f, args: args, keywords: keywords)
    case let .ifExpression(test, body, orElse):
      try self.visitIfExpression(test: test, body: body, orElse: orElse)
    case let .attribute(expr, name):
      try self.visitAttribute(expr: expr, name: name)
    case let .subscript(expr, slice):
      try self.visitSubscript(expr: expr, slice: slice)
    case let .starred(expr):
      try self.visitStarred(expr: expr)
    }
  }

  private func visitIdentifier(value: String) throws {
  }

  private func visitString(group: StringGroup) throws {
  }

  private func visitBytes(value: Data) throws {
  }

  /// compiler_boolop(struct compiler *c, expr_ty e)
  private func visitBoolOp(op: BooleanOperator,
                           left:  Expression,
                           right: Expression) throws {

    let end = self.newLabel()
    try self.visitExpression(left)

    switch op {
    case .and: try self.emit(.jumpIfFalseOrPop(end))
    case .or:  try self.emit(.jumpIfTrueOrPop(end))
    }

    try self.visitExpression(right)
    self.setLabel(end)
  }

  private func visitCompare(left: Expression,
                            elements: NonEmptyArray<ComparisonElement>) throws {
  }

  private func visitTuple(value: [Expression]) throws {
  }

  private func visitList(value: [Expression]) throws {
  }

  private func visitDictionary(value: [DictionaryElement]) throws {
  }

  private func visitSet(value: [Expression]) throws {
  }

  private func visitListComprehension(elt: Expression,
                                      generators: NonEmptyArray<Comprehension>) throws {
  }

  private func visitSetComprehension(elt: Expression,
                                     generators: NonEmptyArray<Comprehension>) throws {
  }

  private func visitDictionaryComprehension(key: Expression,
                                            value: Expression,
                                            generators: NonEmptyArray<Comprehension>) throws {
  }

  private func visitGeneratorExp(elt: Expression,
                                 generators: NonEmptyArray<Comprehension>) throws {
  }

  private func visitAwait(expr: Expression) throws {
  }

  private func visitYield(value: Expression?) throws {
  }

  private func visitYieldFrom(expr: Expression) throws {
  }

  private func visitLambda(args: Arguments,
                           body: Expression) throws {
  }

  private func visitCall(f: Expression,
                         args: [Expression],
                         keywords: [Keyword]) throws {
  }

  private func visitIfExpression(test: Expression,
                                 body: Expression,
                                 orElse: Expression) throws {
  }

  private func visitAttribute(expr: Expression,
                              name: String) throws {
  }

  private func visitSubscript(expr: Expression,
                              slice: Slice) throws {
  }

  private func visitStarred(expr: Expression) throws {
  }

  private func visitComparisonElement(_ stmt: ComparisonElement) throws {
  }

  private func visitSlice(_ slice: Slice) throws {
  }

  private func visitComprehension(_ comprehension: Comprehension) throws {
  }

  private func visitArguments(_ args: Arguments) throws {
  }

  private func visitArg(_ arg: Arg) throws {
  }

  private func visitKeyword(_ keyword: Keyword) throws {
  }
}
