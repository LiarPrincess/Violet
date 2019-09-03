import Foundation
import Core
import Parser
import Bytecode

// In CPython:
// Python -> compile.c

// swiftlint:disable function_body_length
// swiftlint:disable cyclomatic_complexity
// swiftlint:disable file_length

extension Compiler {

  /// compiler_visit_expr(struct compiler *c, expr_ty e)
  internal func visitExpressions<S: Sequence>(
    _ exprs: S,
    context: ExpressionContext = .load) throws where S.Element == Expression {

    for e in exprs {
      try self.visitExpression(e)
    }
  }

  /// compiler_visit_expr(struct compiler *c, expr_ty e)
  internal func visitExpression(_ expr: Expression?,
                                context: ExpressionContext = .load) throws {
    if let e = expr {
      try self.visitExpression(e)
    }
  }

  /// compiler_visit_expr(struct compiler *c, expr_ty e)
  internal func visitExpression(_ expr: Expression,
                                context: ExpressionContext = .load) throws {
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
      try self.visitIdentifier(value, context: context, location: location)

    case let .bytes(value):
      try self.emitConstant(.bytes(value), location: location)
    case let .string(string):
      try self.visitString(string, location: location)

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

    case let .tuple(elements):
      try self.visitTuple     (elements: elements, context: context, location: location)
    case let .list(elements):
      try self.visitList      (elements: elements, context: context, location: location)
    case let .dictionary(elements):
      try self.visitDictionary(elements: elements, context: context, location: location)
    case let .set(elements):
      try self.visitSet       (elements: elements, context: context, location: location)

    case .listComprehension,
         .setComprehension,
         .dictionaryComprehension:
      throw self.notImplemented()

    case .generatorExp,
         .await,
         .yield,
         .yieldFrom:
      throw self.notImplemented()

    case .lambda:
      throw self.notImplemented()

    case let .call(function, args, keywords):
      try self.visitCall(function: function,
                         args: args,
                         keywords: keywords,
                         context: context,
                         location: location)

    case let .ifExpression(test, body, orElse):
      try self.visitIfExpression(test: test,
                                 body: body,
                                 orElse: orElse,
                                 location: location)

    case let .attribute(expr, name):
      let mangled = MangledName(className: self.className, name: name)
      try self.visitExpression(expr)
      try self.emitAttribute(name: mangled, context: context, location: location)

    case let .subscript(expr, slice):
      try self.visitExpression(expr)
      try self.visitSlice(slice: slice, context: context, location: location)

    case .starred:
      // In all legitimate cases, the starred node was already replaced
      // inside assign, call etc.
      switch context {
      case .store:
        throw self.error(.starredAssignmentNotListOrTuple, location: location)
      default:
        throw self.error(.invalidStarredExpression, location: location)
      }
    }
  }

  // MARK: - Identifier

  private enum IdentifierOperation {
    case fast
    case global
    case deref
    case name
  }

  /// compiler_nameop(struct compiler *c, identifier name, expr_context_ty ctx)
  private func visitIdentifier(_ value: String,
                               context: ExpressionContext,
                               location: SourceLocation) throws {

    let mangled = MangledName(className: self.className, name: value)
    let info = self.currentScope.symbols[mangled]

    // TODO: Leave assert here, but handle __doc__ and the like better
    assert(info != nil || value.starts(with: "_"))

    let flags = info?.flags ?? []
    var operation = IdentifierOperation.name

    if flags.contains(.srcFree) {
      operation = .deref
    } else if flags.contains(.cell) {
      operation = .deref
    } else if flags.contains(.defLocal) {
      if self.currentScope.type == .function {
        operation = .fast
      }
    } else if flags.contains(.srcGlobalImplicit) {
      if self.currentScope.type == .function {
        operation = .global
      }
    } else if flags.contains(.srcGlobalExplicit) {
      operation = .global
    }

    switch operation {
    case .deref:
      let c = self.getDerefContext(context: context)
      try self.emitDeref(name: mangled, context: c, location: location)
    case .fast:
      try self.emitFast(name: mangled, context: context, location: location)
    case .global:
      try self.emitGlobal(name: mangled, context: context, location: location)
    case .name:
      try self.emitName(name: mangled, context: context, location: location)
    }
  }

  private func getDerefContext(context: ExpressionContext) -> DerefContext {
    switch context {
    case .store:
      return .store
    case .load where self.currentScope.type == .class:
      return .loadClass
    case .load:
      return .load
    case .del:
      return .del
    }
  }

  // MARK: - String

  /// compiler_formatted_value(struct compiler *c, expr_ty e)
  /// compiler_joined_str(struct compiler *c, expr_ty e)
  private func visitString(_ group: StringGroup,
                           location: SourceLocation) throws {
    switch group {
    case let .literal(s):
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

    case let .joined(groups):
      for g in groups {
        try self.visitString(g, location: location)
      }

      if groups.count == 1 {
        // do nothing, string is already on TOS
      } else if let count = UInt8(exactly: groups.count) {
        try self.emit(.buildString(count), location: location)
      } else {
        // UInt8 can't represent this value
        throw self.error(.fStringWithMoreThan255Elements, location: location)
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

      for e in elements.dropLast() {
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

  // MARK: - Comprehension

/*
  private func visitListComprehension(
    elt: Expression,
    generators: NonEmptyArray<Comprehension>) throws {
  }

  private func visitSetComprehension(
    elt: Expression,
    generators: NonEmptyArray<Comprehension>) throws {
  }

  private func visitDictionaryComprehension(
    key: Expression,
    value: Expression,
    generators: NonEmptyArray<Comprehension>) throws {
  }

  private func visitGeneratorExp(
    elt: Expression,
    generators: NonEmptyArray<Comprehension>) throws {
  }
*/

  // MARK: - Coroutines/Generators

/*
  private func visitAwait(expr: Expression) throws {
  }

  private func visitYield(value: Expression?) throws {
  }

  private func visitYieldFrom(expr: Expression) throws {
  }
*/

  // MARK: - Lambda

/*
  private func visitLambda(args: Arguments,
                           body: Expression) throws {
  }
*/

  // MARK: - If

  /// compiler_ifexp(struct compiler *c, expr_ty e)
  ///
  /// `dis.dis('1 if a else 3')` gives us:
  /// ```c
  ///  0 LOAD_NAME                0 (a)
  ///  2 POP_JUMP_IF_FALSE        8
  ///  4 LOAD_CONST               0 (1)
  ///  6 RETURN_VALUE
  ///  8 LOAD_CONST               1 (3)
  /// 10 RETURN_VALUE
  /// ```
  private func visitIfExpression(test:   Expression,
                                 body:   Expression,
                                 orElse: Expression,
                                 location: SourceLocation) throws {
    let end = try self.newLabel()
    let next = try self.newLabel()

    try self.visitExpression(test, andJumpTo: next, if: false, location: location)
    try self.visitExpression(body)
    self.setLabel(next)
    try self.visitExpression(orElse)
    self.setLabel(end)
  }

  // TODO: Do we even need this method? Cant we just compile `expr` and then fancy test?
  /// compiler_jump_if(struct compiler *c, expr_ty e, basicblock *next, int cond)
  private func visitExpression(_ expr:  Expression,
                               andJumpTo next: Label,
                               if cond: Bool,
                               location loc: SourceLocation) throws {
    switch expr.kind {
    case let .unaryOp(op, right: right):
      switch op {
      case .not:
        try self.visitExpression(right, andJumpTo: next, if: !cond, location: loc)
        return
      case .plus, .minus, .invert:
        break // fallback to general implementation
      }

    case let .boolOp(op, left, right):
      let isOr = op == .or
      let hasLabel = cond != isOr
      let next2 = hasLabel ? try self.newLabel() : next

      try self.visitExpression(left,  andJumpTo: next2, if: isOr, location: loc)
      try self.visitExpression(right, andJumpTo: next,  if: cond, location: loc)

      if hasLabel {
        self.setLabel(next2)
      }
      return

    case let .ifExpression(test, body, orElse):
      let end = try self.newLabel()
      let next2 = try self.newLabel()

      try self.visitExpression(test, andJumpTo: next2, if: false, location: loc)
      try self.visitExpression(body, andJumpTo: next,  if: cond,  location: loc)
      try self.emitJumpAbsolute(to: end, location: loc)
      self.setLabel(next2)
      try self.visitExpression(orElse, andJumpTo: next, if: cond, location: loc)
      self.setLabel(end)

    case let .compare(left, elements):
      guard elements.count > 1 else {
        break // fallback to general implementation
      }

      try self.visitExpression(left)

      let end = try self.newLabel()
      let cleanup = try self.newLabel()

      for e in elements.dropLast() {
        try self.visitExpression(e.right)
        try self.emit(.dupTop, location: loc)
        try self.emit(.rotThree, location: loc)
        try self.emitComparisonOperator(e.op, location: loc)
        try self.emitJumpIfFalseOrPop(to: cleanup, location: loc)
      }

      let l = elements.last
      try self.visitExpression(l.right)
      try self.emitComparisonOperator(l.op, location: loc)

      switch cond {
      case true:  try self.emitPopJumpIfTrue (to: next, location: loc)
      case false: try self.emitPopJumpIfFalse(to: next, location: loc)
      }

      try self.emitJumpAbsolute(to: end, location: loc)
      self.setLabel(cleanup)
      try self.emit(.popTop, location: loc)

      if !cond {
        try self.emitJumpAbsolute(to: next, location: loc)
      }
      self.setLabel(end)
      return

    default:
      break // fallback to general implementation
    }

    try self.visitExpression(expr)
    switch cond {
    case true:  try self.emitPopJumpIfTrue (to: next, location: loc)
    case false: try self.emitPopJumpIfFalse(to: next, location: loc)
    }
  }

  // MARK: - Slice

  /// compiler_visit_slice(struct compiler *c, slice_ty s, expr_context_ty ctx)
  private func visitSlice(slice:  Slice,
                          context:  ExpressionContext,
                          location: SourceLocation) throws {
    switch slice.kind {
    case let .index(index):
      try self.visitExpression(index)
    case let .slice(lower, upper, step):
      try self.compileSlice(lower: lower,
                            upper: upper,
                            step:  step,
                            location: location)
    case let .extSlice(slices):
      for s in slices {
        try self.visitNestedSlice(slice: s, context: context)
      }
    }

    try self.emitSubscript(context: context, location: location)
  }

  /// compiler_visit_nested_slice(struct compiler *c, slice_ty s,
  /// expr_context_ty ctx)
  private func visitNestedSlice(slice: Slice,
                                context: ExpressionContext) throws {
    let location = slice.start

    switch slice.kind {
    case let .index(index):
      try self.visitExpression(index)
    case let .slice(lower, upper, step):
      try self.compileSlice(lower: lower,
                            upper: upper,
                            step:  step,
                            location: location)
    case .extSlice:
      let kind = CompilerErrorKind.extendedSliceNestedInsideExtendedSlice
      throw self.error(kind, location: location)
    }
  }

  /// compiler_slice(struct compiler *c, slice_ty s, expr_context_ty ctx)
  private func compileSlice(lower: Expression?,
                            upper: Expression?,
                            step:  Expression?,
                            location: SourceLocation) throws {

    if let l = lower {
      try self.visitExpression(l)
    } else {
      try self.emitConstant(.none, location: location)
    }

    if let u = upper {
      try self.visitExpression(u)
    } else {
      try self.emitConstant(.none, location: location)
    }

    var n: UInt8 = 2
    if let s = step {
      n += 1
      try self.visitExpression(s)
    }

    try self.emitBuildSlice(n: n, location: location)
  }
}
