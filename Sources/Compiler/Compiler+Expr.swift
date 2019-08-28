import Foundation
import Core
import Parser
import Bytecode

// In CPython:
// Python -> compile.c

// swiftlint:disable function_body_length
// swiftlint:disable cyclomatic_complexity
// swiftlint:disable file_length
// swiftlint:disable switch_case_alignment

extension Compiler {

  /// compiler_visit_expr(struct compiler *c, expr_ty e)
  internal func visitExpression<S: Sequence>(_ exprs: S) throws
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
    let location = expr.start

    switch expr.kind {
    case .true:
      try self.emitConstant(.true, location: location)
    case .false:
      try self.emitConstant(.false, location: location)
    case .none:
      try self.emitConstant(.none, location: location)
    case .ellipsis:
      try self.emitConstant(.ellipsis, location: location)

case let .identifier(value):
  try self.visitIdentifier(value: value)

    case let .bytes(value):
      try self.emitConstant(.bytes(value), location: location)
    case let .string(group):
      try self.visitString(group: group, location: location)

    case let .int(value):
      try self.emitConstant(.integer(value), location: location)
    case let .float(value):
      try self.emitConstant(.float(value), location: location)
    case let .complex(real, imag):
      try self.emitConstant(.complex(real: real, imag: imag), location: location)

    case let .unaryOp(op, right):
      try self.visitExpression(right)
      try self.emitUnaryOperator(op, location: location)
    case let .binaryOp(op, left, right):
      try self.visitExpression(left)
      try self.visitExpression(right)
      try emitBinaryOperator(op, location: location)
    case let .boolOp(op, left, right):
      try self.visitBoolOp(op: op, left: left, right: right, location: location)
    case let .compare(left, elements):
      try self.visitCompare(left: left, elements: elements, location: location)

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

  /// compiler_formatted_value(struct compiler *c, expr_ty e)
  /// compiler_joined_str(struct compiler *c, expr_ty e)
  private func visitString(group: StringGroup,
                           location: SourceLocation) throws {
    switch group {
    case let .string(s):
      try self.emitConstant(.string(s), location: location)

    case let .formattedValue(expr, conversion: conv, spec: spec):
      try self.visitExpression(expr)

      var flags: UInt8 = 0
      switch conv {
      case .some(.str):   flags |= FormattedValueMasks.conversionStr
      case .some(.repr):  flags |= FormattedValueMasks.conversionRepr
      case .some(.ascii): flags |= FormattedValueMasks.conversionASCII
      default:            flags |= FormattedValueMasks.conversionNone
      }

      if let s = spec {
        flags |= FormattedValueMasks.hasFormat
        try self.emitConstant(.string(s), location: location)
      }

      try self.emit(.formatValue(flags: flags), location: location)

    case let .joinedString(groups):
      for g in groups {
        try self.visitString(group: g, location: location)
      }

      if groups.count == 1 {
        // do nothing, string is already on TOS
      } else if let count = UInt8(exactly: groups.count) {
        try self.emit(.buildString(count), location: location)
      } else {
        // UInt8 can't represent this value
        fatalError()
      }
    }
  }

  // MARK: - Operations

  /// compiler_boolop(struct compiler *c, expr_ty e)
  ///
  /// `dis.dis('a and b')` gives us:
  /// ```c
  /// 0 LOAD_NAME                0 (a)
  /// 2 JUMP_IF_FALSE_OR_POP     6
  /// 4 LOAD_NAME                1 (b)
  /// 6 RETURN_VALUE
  /// ```
  private func visitBoolOp(op: BooleanOperator,
                           left:  Expression,
                           right: Expression,
                           location: SourceLocation) throws {

    let end = try self.newLabel()
    try self.visitExpression(left)

    switch op {
    case .and: try self.emitJumpIfFalseOrPop(to: end, location: location)
    case .or:  try self.emitJumpIfTrueOrPop(to: end, location: location)
    }

    try self.visitExpression(right)
    self.setLabel(end)
  }

  /// compiler_compare(struct compiler *c, expr_ty e)
  ///
  /// `dis.dis('a < b <= c')` gives us:
  /// ```c
  ///   0 LOAD_NAME                0 (a)
  ///   2 LOAD_NAME                1 (b)
  ///   4 DUP_TOP
  ///   6 ROT_THREE
  ///   8 COMPARE_OP               0 (<)
  ///  10 JUMP_IF_FALSE_OR_POP    18
  ///  12 LOAD_NAME                2 (c)
  ///  14 COMPARE_OP               1 (<=)
  ///  16 RETURN_VALUE
  ///  18 ROT_TWO
  ///  20 POP_TOP
  ///  22 RETURN_VALUE
  /// ```
  private func visitCompare(left: Expression,
                            elements: NonEmptyArray<ComparisonElement>,
                            location: SourceLocation) throws {

    try self.visitExpression(left)

    if elements.count == 1 {
      let e = elements.first
      try self.visitExpression(e.right)
      try self.emitComparisonOperator(e.op, location: location)
    } else {
      let end = try self.newLabel()

      for e in elements.lazy.dropLast() {
        try self.visitExpression(e.right)
        try self.emit(.dupTop, location: location)
        try self.emit(.rotThree, location: location)
        try self.emitComparisonOperator(e.op, location: location)
        try self.emitJumpIfFalseOrPop(to: end, location: location)
      }

      let l = elements.last
      try self.visitExpression(l.right)
      try self.emitComparisonOperator(l.op, location: location)

      self.setLabel(end)
    }
  }

  // MARK: - Collections

  /// compiler_tuple(struct compiler *c, expr_ty e)
  private func visitTuple(value: [Expression]) throws {
  }

  private func visitList(value: [Expression]) throws {
  }

  private func visitDictionary(value: [DictionaryElement]) throws {
  }

  private func visitSet(value: [Expression]) throws {
  }

  // MARK: - Comprehension

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

  // MARK: - Coroutines/Generators

  private func visitAwait(expr: Expression) throws {
  }

  private func visitYield(value: Expression?) throws {
  }

  private func visitYieldFrom(expr: Expression) throws {
  }

  // MARK: - Function call

  private func visitLambda(args: Arguments,
                           body: Expression) throws {
  }

  private func visitCall(f: Expression,
                         args: [Expression],
                         keywords: [Keyword]) throws {
  }

  }

  // MARK: - Trailer

  private func visitAttribute(expr: Expression,
                              name: String) throws {
  }

  private func visitSubscript(expr: Expression,
                              slice: Slice) throws {
  }

  private func visitSlice(_ slice: Slice) throws {
  }

  // MARK: - Starred

  private func visitStarred(expr: Expression) throws {
  }

  // MARK: - ?

  private func visitComprehension(_ comprehension: Comprehension) throws {
  }

  private func visitArguments(_ args: Arguments) throws {
  }

  private func visitArg(_ arg: Arg) throws {
  }

  private func visitKeyword(_ keyword: Keyword) throws {
  }
}
