import Foundation
import Core
import Parser
import Bytecode

// In CPython:
// Python -> compile.c

// swiftlint:disable file_length

extension Compiler {

  /// compiler_visit_expr(struct compiler *c, expr_ty e)
  internal func visitExpressions<S: Sequence>(
    _ exprs: S,
    context: ExpressionContext = .load) throws where S.Element == Expression {

    for e in exprs {
      try self.visitExpression(e, context: context)
    }
  }

// swiftlint:disable function_body_length

  /// compiler_visit_expr(struct compiler *c, expr_ty e)
  internal func visitExpression(_ expr: Expression,
                                context: ExpressionContext = .load) throws {
// swiftlint:enable function_body_length
    self.setAppendLocation(expr)

    switch expr.kind {
    case .true:
      self.builder.appendTrue()
    case .false:
      self.builder.appendFalse()
    case .none:
      self.builder.appendNone()
    case .ellipsis:
      self.builder.appendEllipsis()

    case let .identifier(value):
      try self.visitIdentifier(value, context: context)

    case let .bytes(value):
      self.builder.appendBytes(value)
    case let .string(string):
      try self.visitString(string)

    case let .int(value):
      self.builder.appendInteger(value)
    case let .float(value):
      self.builder.appendFloat(value)
    case let .complex(real, imag):
      self.builder.appendComplex(real: real, imag: imag)

    case let .unaryOp(op, right):
      try self.visitExpression(right)
      self.builder.appendUnaryOperator(op)
    case let .binaryOp(op, left, right):
      try self.visitExpression(left)
      try self.visitExpression(right)
      self.builder.appendBinaryOperator(op)
    case let .boolOp(op, left, right):
      try self.visitBoolOp(op, left: left, right: right)
    case let .compare(left, elements):
      try self.visitCompare(left: left, elements: elements)

    case let .tuple(elements):
      try self.visitTuple(elements: elements, context: context)
    case let .list(elements):
      try self.visitList(elements: elements, context: context)
    case let .dictionary(elements):
      try self.visitDictionary(elements: elements, context: context)
    case let .set(elements):
      try self.visitSet(elements: elements, context: context)

    case let .generatorExp(elt, generators):
      try self.visitGeneratorExpression(elt: elt, generators: generators)
    case let .listComprehension(elt, generators):
      try self.visitListComprehension(elt: elt, generators: generators)
    case let  .setComprehension(elt, generators):
      try self.visitSetComprehension(elt: elt, generators: generators)
    case let .dictionaryComprehension(key, value, generators):
      try self.visitDictionaryComprehension(key: key, value: value, generators: generators)

    case let .await(expr):
      try self.visitAwait(expr: expr)
    case let .yield(expr):
      try self.visitYield(value: expr)
    case let .yieldFrom(expr):
      try self.visitYieldFrom(expr: expr)

    case let .lambda(args, body):
      try self.visitLambda(args: args, body: body, expression: expr)

    case let .call(function, args, keywords):
      try self.visitCall(function: function,
                         args: args,
                         keywords: keywords,
                         context: context)

    case let .ifExpression(test, body, orElse):
      try self.visitIfExpression(test: test, body: body, orElse: orElse)

    case let .attribute(object, name):
      try self.visitAttribute(object: object, name: name, context: context)
    case let .subscript(object, slice):
      try self.visitSubscript(object: object, slice: slice, context: context)

    case .starred:
      // In all legitimate cases, the starred node was already replaced
      // inside assign, call etc.
      switch context {
      case .store:
        throw self.error(.starredAssignmentNotListOrTuple)
      default:
        throw self.error(.invalidStarredExpression)
      }
    }
  }

// swiftlint:disable function_body_length

  /// compiler_jump_if(struct compiler *c, expr_ty e, basicblock *next, int cond)
  internal func visitExpression(_ expr:  Expression,
                                andJumpTo next: Label,
                                ifBooleanValueIs cond: Bool) throws {
// swiftlint:enable function_body_length
    self.setAppendLocation(expr)

    switch expr.kind {
    case let .unaryOp(op, right: right):
      switch op {
      case .not:
        try self.visitExpression(right, andJumpTo: next, ifBooleanValueIs: !cond)
        return
      case .plus, .minus, .invert:
        break // fallback to general implementation
      }

    case let .boolOp(op, left, right):
      let isOr = op == .or
      let hasLabel = cond != isOr
      let next2 = hasLabel ? self.builder.createLabel() : next

      try self.visitExpression(left,  andJumpTo: next2, ifBooleanValueIs: isOr)
      try self.visitExpression(right, andJumpTo: next,  ifBooleanValueIs: cond)

      if hasLabel {
        self.builder.setLabel(next2)
      }
      return

    case let .ifExpression(test, body, orElse):
      let end   = self.builder.createLabel()
      let next2 = self.builder.createLabel()

      try self.visitExpression(test, andJumpTo: next2, ifBooleanValueIs: false)
      try self.visitExpression(body, andJumpTo: next,  ifBooleanValueIs: cond)
      self.builder.appendJumpAbsolute(to: end)
      self.builder.setLabel(next2)
      try self.visitExpression(orElse, andJumpTo: next, ifBooleanValueIs: cond)
      self.builder.setLabel(end)

    case let .compare(left, elements):
      guard elements.count > 1 else {
        break // fallback to general implementation
      }

      try self.visitExpression(left)

      let end     = self.builder.createLabel()
      let cleanup = self.builder.createLabel()

      for element in elements.dropLast() {
        try self.visitExpression(element.right)
        self.builder.appendDupTop()
        self.builder.appendRotThree()
        self.builder.appendCompareOp(element.op)
        self.builder.appendJumpIfFalseOrPop(to: cleanup)
      }

      let last = elements.last
      try self.visitExpression(last.right)
      self.builder.appendCompareOp(last.op)

      switch cond {
      case true:  self.builder.appendPopJumpIfTrue(to: next)
      case false: self.builder.appendPopJumpIfFalse(to: next)
      }

      self.builder.appendJumpAbsolute(to: end)
      self.builder.setLabel(cleanup)
      self.builder.appendPopTop()

      if !cond {
        self.builder.appendJumpAbsolute(to: next)
      }
      self.builder.setLabel(end)
      return

    default:
      break // fallback to general implementation
    }

    try self.visitExpression(expr)
    switch cond {
    case true:  self.builder.appendPopJumpIfTrue(to: next)
    case false: self.builder.appendPopJumpIfFalse(to: next)
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
  private func visitIdentifier(_ value: String, context: ExpressionContext) throws {
    let mangled = self.mangleName(value)
    let info = self.currentScope.symbols[mangled]

    // TODO: Leave assert here, but handle __doc__ and the like better
    assert(info != nil || value.starts(with: "_"))

    let flags = info?.flags ?? []
    var operation = IdentifierOperation.name

    if flags.containsAny([.srcFree, .cell]) {
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
        self.builder.appendStoreDeref(mangled)
      case .load where self.currentScope.type == .class:
        self.builder.appendLoadClassDeref(mangled)
      case .load:
        self.builder.appendLoadDeref(mangled)
      case .del:
        self.builder.appendDeleteDeref(mangled)
      }
    case .fast:
      self.builder.appendFast(name: mangled, context: context)
    case .global:
      self.builder.appendGlobal(name: mangled, context: context)
    case .name:
      self.builder.appendName(name: mangled, context: context)
    }
  }

  // MARK: - String

  /// compiler_formatted_value(struct compiler *c, expr_ty e)
  /// compiler_joined_str(struct compiler *c, expr_ty e)
  private func visitString(_ group: StringGroup) throws {
    switch group {
    case let .literal(s):
      self.builder.appendString(s)

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
        self.builder.appendString(s)
      }

      self.builder.appendFormatValue(conversion: conversion, hasFormat: hasFormat)

    case let .joined(groups):
      for g in groups {
        try self.visitString(g)
      }

      if groups.count > 1 {
        self.builder.appendBuildString(count: groups.count)
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
                           right: Expression) throws {
    let end = self.builder.createLabel()

    try self.visitExpression(left)

    switch op {
    case .and: self.builder.appendJumpIfFalseOrPop(to: end)
    case .or:  self.builder.appendJumpIfTrueOrPop(to: end)
    }

    try self.visitExpression(right)
    self.builder.setLabel(end)
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
                            elements: NonEmptyArray<ComparisonElement>) throws {

    try self.visitExpression(left)

    if elements.count == 1 {
      let first = elements.first
      try self.visitExpression(first.right)
      self.builder.appendCompareOp(first.op)
    } else {
      let end = self.builder.createLabel()
      let cleanup = self.builder.createLabel()

      for element in elements.dropLast() {
        try self.visitExpression(element.right)
        self.builder.appendDupTop()
        self.builder.appendRotThree()
        self.builder.appendCompareOp(element.op)
        self.builder.appendJumpIfFalseOrPop(to: cleanup)
      }

      let last = elements.last
      try self.visitExpression(last.right)
      self.builder.appendCompareOp(last.op)

      self.builder.appendJumpAbsolute(to: end)
      self.builder.setLabel(cleanup)
      self.builder.appendRotTwo()
      self.builder.appendPopTop()
      self.builder.setLabel(end)
    }
  }

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
  private func visitIfExpression(test: Expression,
                                 body: Expression,
                                 orElse: Expression) throws {
    let end = self.builder.createLabel()
    let orElseStart = self.builder.createLabel()

    try self.visitExpression(test, andJumpTo: orElseStart, ifBooleanValueIs: false)
    try self.visitExpression(body)
    self.builder.appendJumpAbsolute(to: end)
    self.builder.setLabel(orElseStart)
    try self.visitExpression(orElse)
    self.builder.setLabel(end)
  }

  // MARK: - Attribute

  /// compiler_visit_expr(struct compiler *c, expr_ty e)
  internal func visitAttribute(object: Expression,
                               name:   String,
                               context: ExpressionContext,
                               isAugumented: Bool = false) throws {
    let mangled = self.mangleName(name)

    let isAugumentedStore = isAugumented && context == .store
    if !isAugumentedStore {
      try self.visitExpression(object)
    }

    switch context {
    case .store:
      if isAugumented {
        self.builder.appendRotTwo()
      }
      self.builder.appendStoreAttribute(mangled)
    case .load:
      if isAugumented {
        self.builder.appendDupTop()
      }
      self.builder.appendLoadAttribute(mangled)
    case .del:
      assert(!isAugumented)
      self.builder.appendDeleteAttribute(mangled)
    }
  }

  // MARK: - Slice

  /// compiler_visit_expr(struct compiler *c, expr_ty e)
  internal func visitSubscript(object: Expression,
                               slice:  Slice,
                               context:  ExpressionContext,
                               isAugumented: Bool = false) throws {
    let isAugumentedStore = isAugumented && context == .store
    if !isAugumentedStore {
      try self.visitExpression(object)
    }

    try self.visitSlice(slice: slice, context: context, isAugumented: isAugumented)
  }

  /// compiler_visit_slice(struct compiler *c, slice_ty s, expr_context_ty ctx)
  /// compiler_handle_subscr(struct compiler *c, const char *kind, ...)
  private func visitSlice(slice:  Slice,
                          context:  ExpressionContext,
                          isAugumented: Bool) throws {

    let isAugumentedStore = isAugumented && context == .store
    if !isAugumentedStore {
      switch slice.kind {
      case let .index(index):
        try self.visitExpression(index)
      case let .slice(lower, upper, step):
        try self.compileSlice(lower: lower, upper: upper, step: step)
      case let .extSlice(slices):
        for s in slices {
          try self.visitNestedSlice(slice: s, context: context)
        }
        self.builder.appendBuildTuple(elementCount: slices.count)
      }
    }

    switch context {
    case .store:
      if isAugumented {
        self.builder.appendRotThree()
      }
      self.builder.appendStoreSubscr()
    case .load:
      if isAugumented {
        self.builder.appendDupTopTwo()
      }
      self.builder.appendBinarySubscr()
    case .del:
      assert(!isAugumented)
      self.builder.appendDeleteSubscr()
    }
  }

  /// compiler_visit_nested_slice(struct compiler *c, slice_ty s,
  /// expr_context_ty ctx)
  private func visitNestedSlice(slice: Slice, context: ExpressionContext) throws {
    switch slice.kind {
    case let .index(index):
      try self.visitExpression(index)
    case let .slice(lower, upper, step):
      try self.compileSlice(lower: lower, upper: upper, step: step)
    case .extSlice:
      throw self.error(.extendedSliceNestedInsideExtendedSlice)
    }
  }

  /// compiler_slice(struct compiler *c, slice_ty s, expr_context_ty ctx)
  private func compileSlice(lower: Expression?,
                            upper: Expression?,
                            step:  Expression?) throws {

    if let l = lower {
      try self.visitExpression(l)
    } else {
      self.builder.appendNone()
    }

    if let u = upper {
      try self.visitExpression(u)
    } else {
      self.builder.appendNone()
    }

    var type = SliceArg.lowerUpper
    if let s = step {
      type = .lowerUpperStep
      try self.visitExpression(s)
    }

    self.builder.appendBuildSlice(type)
  }
}
