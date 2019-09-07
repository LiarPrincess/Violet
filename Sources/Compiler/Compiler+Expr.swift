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
      try self.codeObject.emitTrue(location: location)
    case .false:
      try self.codeObject.emitFalse(location: location)
    case .none:
      try self.codeObject.emitNone(location: location)
    case .ellipsis:
      try self.codeObject.emitEllipsis(location: location)

    case let .identifier(value):
      try self.visitIdentifier(value, context: context, location: location)

    case let .bytes(value):
      try self.codeObject.emitBytes(value, location: location)
    case let .string(string):
      try self.visitString(string, location: location)

    case let .int(value):
      try self.codeObject.emitInteger(value, location: location)
    case let .float(value):
      try self.codeObject.emitFloat(value, location: location)
    case let .complex(real, imag):
      try self.codeObject.emitComplex(real: real, imag: imag, location: location)

    case let .unaryOp(op, right):
      try self.visitExpression(right)
      try self.codeObject.emitUnaryOperator(op, location: location)
    case let .binaryOp(op, left, right):
      try self.visitExpression(left)
      try self.visitExpression(right)
      try self.codeObject.emitBinaryOperator(op, location: location)
    case let .boolOp(op, left, right):
      try self.visitBoolOp(op, left: left, right: right, location: location)
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
      let mangled = self.mangleName(name)
      try self.visitExpression(expr)
      try self.codeObject.emitAttribute(name: mangled, context: context, location: location)

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

    let mangled = self.mangleName(value)
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
      switch context {
      case .store:
        try self.codeObject.emitStoreDeref(mangled, location: location)
      case .load where self.currentScope.type == .class:
        try self.codeObject.emitLoadClassDeref(mangled, location: location)
      case .load:
        try self.codeObject.emitLoadDeref(mangled, location: location)
      case .del:
        try self.codeObject.emitDeleteDeref(mangled, location: location)
      }
    case .fast:
      try self.codeObject.emitFast(name: mangled, context: context, location: location)
    case .global:
      try self.codeObject.emitGlobal(name: mangled, context: context, location: location)
    case .name:
      try self.codeObject.emitName(name: mangled, context: context, location: location)
    }
  }

  // MARK: - String

  /// compiler_formatted_value(struct compiler *c, expr_ty e)
  /// compiler_joined_str(struct compiler *c, expr_ty e)
  private func visitString(_ group: StringGroup,
                           location: SourceLocation) throws {
    switch group {
    case let .literal(s):
      try self.codeObject.emitString(s, location: location)

    case let .formattedValue(expr, conversion: conv, spec: spec):
      try self.visitExpression(expr)

      var conversion = StringConversion.none
      switch conv {
      case .some(.str):   conversion = .str
      case .some(.repr):  conversion = .repr
      case .some(.ascii): conversion = .ascii
      default: break
      }

      var hasFormat = false
      if let s = spec {
        hasFormat = true
        try self.codeObject.emitString(s, location: location)
      }

      try self.codeObject.emitFormatValue(conversion: conversion,
                                          hasFormat: hasFormat,
                                          location: location)

    case let .joined(groups):
      for g in groups {
        try self.visitString(g, location: location)
      }

      if groups.count == 1 {
        // do nothing, string is already on TOS
      } else if let count = UInt8(exactly: groups.count) {
        try self.codeObject.emitBuildString(count: count, location: location)
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
  private func visitBoolOp(_ op:  BooleanOperator,
                           left:  Expression,
                           right: Expression,
                           location: SourceLocation) throws {
    let end = self.codeObject.addLabel()
    try self.visitExpression(left)

    switch op {
    case .and: try self.codeObject.emitJumpIfFalseOrPop(to: end, location: location)
    case .or:  try self.codeObject.emitJumpIfTrueOrPop (to: end, location: location)
    }

    try self.visitExpression(right)
    self.codeObject.setLabel(end)
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
      let first = elements.first
      try self.visitExpression(first.right)
      try self.codeObject.emitCompareOp(first.op, location: location)
    } else {
      let end = self.codeObject.addLabel()

      for element in elements.dropLast() {
        try self.visitExpression(element.right)
        try self.codeObject.emitDupTop(location: location)
        try self.codeObject.emitRotThree(location: location)
        try self.codeObject.emitCompareOp(element.op, location: location)
        try self.codeObject.emitJumpIfFalseOrPop(to: end, location: location)
      }

      let last = elements.last
      try self.visitExpression(last.right)
      try self.codeObject.emitCompareOp(last.op, location: location)

      self.codeObject.setLabel(end)
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

  // MARK: - Coroutines/Generators

  private func visitAwait(expr: Expression) throws {
  }

  private func visitYield(value: Expression?) throws {
  }

  private func visitYieldFrom(expr: Expression) throws {
  }

  // MARK: - Lambda

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
    let end = self.codeObject.addLabel()
    let orElseStart = self.codeObject.addLabel()

    try self.visitExpression(test,
                             andJumpTo: orElseStart,
                             ifBooleanValueIs: false,
                             location: location)

    try self.visitExpression(body)
    self.codeObject.setLabel(orElseStart)
    try self.visitExpression(orElse)
    self.codeObject.setLabel(end)
  }

  /// compiler_jump_if(struct compiler *c, expr_ty e, basicblock *next, int cond)
  internal func visitExpression(_ expr:  Expression,
                                andJumpTo next: Label,
                                ifBooleanValueIs cond: Bool,
                                location loc: SourceLocation) throws {
    switch expr.kind {
    case let .unaryOp(op, right: right):
      switch op {
      case .not:
        try self.visitExpression(right,
                                 andJumpTo: next,
                                 ifBooleanValueIs: !cond,
                                 location: loc)
        return
      case .plus, .minus, .invert:
        break // fallback to general implementation
      }

    case let .boolOp(op, left, right):
      let isOr = op == .or
      let hasLabel = cond != isOr
      let next2 = hasLabel ? self.codeObject.addLabel() : next

      try self.visitExpression(left,
                               andJumpTo: next2,
                               ifBooleanValueIs: isOr,
                               location: loc)
      try self.visitExpression(right,
                               andJumpTo: next,
                               ifBooleanValueIs: cond,
                               location: loc)

      if hasLabel {
        self.codeObject.setLabel(next2)
      }
      return

    case let .ifExpression(test, body, orElse):
      let end   = self.codeObject.addLabel()
      let next2 = self.codeObject.addLabel()

      try self.visitExpression(test,
                               andJumpTo: next2,
                               ifBooleanValueIs: false,
                               location: loc)
      try self.visitExpression(body,
                               andJumpTo: next,
                               ifBooleanValueIs: cond,
                               location: loc)
      try self.codeObject.emitJumpAbsolute(to: end, location: loc)
      self.codeObject.setLabel(next2)
      try self.visitExpression(orElse,
                               andJumpTo: next,
                               ifBooleanValueIs: cond,
                               location: loc)
      self.codeObject.setLabel(end)

    case let .compare(left, elements):
      guard elements.count > 1 else {
        break // fallback to general implementation
      }

      try self.visitExpression(left)

      let end     = self.codeObject.addLabel()
      let cleanup = self.codeObject.addLabel()

      for element in elements.dropLast() {
        try self.visitExpression(element.right)
        try self.codeObject.emitDupTop(location: loc)
        try self.codeObject.emitRotThree(location: loc)
        try self.codeObject.emitCompareOp(element.op, location: loc)
        try self.codeObject.emitJumpIfFalseOrPop(to: cleanup, location: loc)
      }

      let last = elements.last
      try self.visitExpression(last.right)
      try self.codeObject.emitCompareOp(last.op, location: loc)

      switch cond {
      case true:  try self.codeObject.emitPopJumpIfTrue (to: next, location: loc)
      case false: try self.codeObject.emitPopJumpIfFalse(to: next, location: loc)
      }

      try self.codeObject.emitJumpAbsolute(to: end, location: loc)
      self.codeObject.setLabel(cleanup)
      try self.codeObject.emitPopTop(location: loc)

      if !cond {
        try self.codeObject.emitJumpAbsolute(to: next, location: loc)
      }
      self.codeObject.setLabel(end)
      return

    default:
      break // fallback to general implementation
    }

    try self.visitExpression(expr)
    switch cond {
    case true:  try self.codeObject.emitPopJumpIfTrue (to: next, location: loc)
    case false: try self.codeObject.emitPopJumpIfFalse(to: next, location: loc)
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

    try self.codeObject.emitSubscript(context: context, location: location)
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
      try self.codeObject.emitNone(location: location)
    }

    if let u = upper {
      try self.visitExpression(u)
    } else {
      try self.codeObject.emitNone(location: location)
    }

    var type = SliceArg.lowerUpper
    if let s = step {
      type = .lowerUpperStep
      try self.visitExpression(s)
    }

    try self.codeObject.emitBuildSlice(type, location: location)
  }
}
