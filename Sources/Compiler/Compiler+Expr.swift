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
      try self.visitExpression(e, context: context)
    }
  }

  /// compiler_visit_expr(struct compiler *c, expr_ty e)
  internal func visitExpression(_ expr: Expression,
                                context: ExpressionContext = .load) throws {
    let location = expr.start

    switch expr.kind {
    case .true:
      try self.builder.appendTrue(at: location)
    case .false:
      try self.builder.appendFalse(at: location)
    case .none:
      try self.builder.appendNone(at: location)
    case .ellipsis:
      try self.builder.appendEllipsis(at: location)

    case let .identifier(value):
      try self.visitIdentifier(value, context: context, location: location)

    case let .bytes(value):
      try self.builder.appendBytes(value, at: location)
    case let .string(string):
      try self.visitString(string, location: location)

    case let .int(value):
      try self.builder.appendInteger(value, at: location)
    case let .float(value):
      try self.builder.appendFloat(value, at: location)
    case let .complex(real, imag):
      try self.builder.appendComplex(real: real, imag: imag, at: location)

    case let .unaryOp(op, right):
      try self.visitExpression(right)
      try self.builder.appendUnaryOperator(op, at: location)
    case let .binaryOp(op, left, right):
      try self.visitExpression(left)
      try self.visitExpression(right)
      try self.builder.appendBinaryOperator(op, at: location)
    case let .boolOp(op, left, right):
      try self.visitBoolOp(op, left: left, right: right, location: location)
    case let .compare(left, elements):
      try self.visitCompare(left: left, elements: elements, location: location)

    case let .tuple(elements):
      try self.visitTuple(elements: elements,
                          context: context,
                          location: location)
    case let .list(elements):
      try self.visitList(elements: elements,
                         context: context,
                         location: location)
    case let .dictionary(elements):
      try self.visitDictionary(elements: elements,
                               context: context,
                               location: location)
    case let .set(elements):
      try self.visitSet(elements: elements,
                        context: context,
                        location: location)

    case let .generatorExp(elt, generators):
      try self.visitGeneratorExpression(elt: elt,
                                        generators: generators,
                                        location: location)
    case let .listComprehension(elt, generators):
      try self.visitListComprehension(elt: elt,
                                      generators: generators,
                                      location: location)
    case let  .setComprehension(elt, generators):
      try self.visitSetComprehension(elt: elt,
                                     generators: generators,
                                     location: location)
    case let .dictionaryComprehension(key, value, generators):
      try self.visitDictionaryComprehension(key: key,
                                            value: value,
                                            generators: generators,
                                            location: location)

    case let .await(expr):
      try self.visitAwait(expr: expr, location: location)
    case let .yield(expr):
      try self.visitYield(value: expr, location: location)
    case let .yieldFrom(expr):
      try self.visitYieldFrom(expr: expr, location: location)

    case let .lambda(args, body):
      try self.visitLambda(args: args, body: body, expression: expr)

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

    case let .attribute(object, name):
      try self.visitAttribute(object: object,
                              name:   name,
                              context: context,
                              location: location)
    case let .subscript(object, slice):
      try self.visitSubscript(object: object,
                              slice:  slice,
                              context: context,
                              location: location)

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

  /// compiler_jump_if(struct compiler *c, expr_ty e, basicblock *next, int cond)
  internal func visitExpression(_ expr:  Expression,
                                andJumpTo next: Label,
                                ifBooleanValueIs cond: Bool,
                                location: SourceLocation) throws {
    switch expr.kind {
    case let .unaryOp(op, right: right):
      switch op {
      case .not:
        try self.visitExpression(right,
                                 andJumpTo: next,
                                 ifBooleanValueIs: !cond,
                                 location: location)
        return
      case .plus, .minus, .invert:
        break // fallback to general implementation
      }

    case let .boolOp(op, left, right):
      let isOr = op == .or
      let hasLabel = cond != isOr
      let next2 = hasLabel ? self.builder.createLabel() : next

      try self.visitExpression(left,
                               andJumpTo: next2,
                               ifBooleanValueIs: isOr,
                               location: location)
      try self.visitExpression(right,
                               andJumpTo: next,
                               ifBooleanValueIs: cond,
                               location: location)

      if hasLabel {
        self.builder.setLabel(next2)
      }
      return

    case let .ifExpression(test, body, orElse):
      let end   = self.builder.createLabel()
      let next2 = self.builder.createLabel()

      try self.visitExpression(test,
                               andJumpTo: next2,
                               ifBooleanValueIs: false,
                               location: location)
      try self.visitExpression(body,
                               andJumpTo: next,
                               ifBooleanValueIs: cond,
                               location: location)
      try self.builder.appendJumpAbsolute(to: end, at: location)
      self.builder.setLabel(next2)
      try self.visitExpression(orElse,
                               andJumpTo: next,
                               ifBooleanValueIs: cond,
                               location: location)
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
        try self.builder.appendDupTop(at: location)
        try self.builder.appendRotThree(at: location)
        try self.builder.appendCompareOp(element.op, at: location)
        try self.builder.appendJumpIfFalseOrPop(to: cleanup, at: location)
      }

      let last = elements.last
      try self.visitExpression(last.right)
      try self.builder.appendCompareOp(last.op, at: location)

      switch cond {
      case true:  try self.builder.appendPopJumpIfTrue (to: next, at: location)
      case false: try self.builder.appendPopJumpIfFalse(to: next, at: location)
      }

      try self.builder.appendJumpAbsolute(to: end, at: location)
      self.builder.setLabel(cleanup)
      try self.builder.appendPopTop(at: location)

      if !cond {
        try self.builder.appendJumpAbsolute(to: next, at: location)
      }
      self.builder.setLabel(end)
      return

    default:
      break // fallback to general implementation
    }

    try self.visitExpression(expr)
    switch cond {
    case true:  try self.builder.appendPopJumpIfTrue (to: next, at: location)
    case false: try self.builder.appendPopJumpIfFalse(to: next, at: location)
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
        try self.builder.appendStoreDeref(mangled, at: location)
      case .load where self.currentScope.type == .class:
        try self.builder.appendLoadClassDeref(mangled, at: location)
      case .load:
        try self.builder.appendLoadDeref(mangled, at: location)
      case .del:
        try self.builder.appendDeleteDeref(mangled, at: location)
      }
    case .fast:
      try self.builder.appendFast(name: mangled, context: context, at: location)
    case .global:
      try self.builder.appendGlobal(name: mangled, context: context, at: location)
    case .name:
      try self.builder.appendName(name: mangled, context: context, at: location)
    }
  }

  // MARK: - String

  /// compiler_formatted_value(struct compiler *c, expr_ty e)
  /// compiler_joined_str(struct compiler *c, expr_ty e)
  private func visitString(_ group: StringGroup, location: SourceLocation) throws {
    switch group {
    case let .literal(s):
      try self.builder.appendString(s, at: location)

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
        try self.builder.appendString(s, at: location)
      }

      try self.builder.appendFormatValue(conversion: conversion,
                                         hasFormat: hasFormat,
                                         at: location)

    case let .joined(groups):
      for g in groups {
        try self.visitString(g, location: location)
      }

      if groups.count > 1 {
        try self.builder.appendBuildString(count: groups.count, at: location)
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
    let end = self.builder.createLabel()

    try self.visitExpression(left)

    switch op {
    case .and: try self.builder.appendJumpIfFalseOrPop(to: end, at: location)
    case .or:  try self.builder.appendJumpIfTrueOrPop (to: end, at: location)
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
                            elements: NonEmptyArray<ComparisonElement>,
                            location: SourceLocation) throws {

    try self.visitExpression(left)

    if elements.count == 1 {
      let first = elements.first
      try self.visitExpression(first.right)
      try self.builder.appendCompareOp(first.op, at: location)
    } else {
      let end = self.builder.createLabel()
      let cleanup = self.builder.createLabel()

      for element in elements.dropLast() {
        try self.visitExpression(element.right)
        try self.builder.appendDupTop(at: location)
        try self.builder.appendRotThree(at: location)
        try self.builder.appendCompareOp(element.op, at: location)
        try self.builder.appendJumpIfFalseOrPop(to: cleanup, at: location)
      }

      let last = elements.last
      try self.visitExpression(last.right)
      try self.builder.appendCompareOp(last.op, at: location)

      try self.builder.appendJumpAbsolute(to: end, at: location)
      self.builder.setLabel(cleanup)
      try self.builder.appendRotTwo(at: location)
      try self.builder.appendPopTop(at: location)
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
  private func visitIfExpression(test:   Expression,
                                 body:   Expression,
                                 orElse: Expression,
                                 location: SourceLocation) throws {
    let end = self.builder.createLabel()
    let orElseStart = self.builder.createLabel()

    try self.visitExpression(test,
                             andJumpTo: orElseStart,
                             ifBooleanValueIs: false,
                             location: location)

    try self.visitExpression(body)
    try self.builder.appendJumpAbsolute(to: end, at: location)
    self.builder.setLabel(orElseStart)
    try self.visitExpression(orElse)
    self.builder.setLabel(end)
  }

  // MARK: - Attribute

  /// compiler_visit_expr(struct compiler *c, expr_ty e)
  internal func visitAttribute(object: Expression,
                               name:   String,
                               context: ExpressionContext,
                               location: SourceLocation,
                               isAugumented: Bool = false) throws {
    let mangled = self.mangleName(name)

    let isAugumentedStore = isAugumented && context == .store
    if !isAugumentedStore {
      try self.visitExpression(object)
    }

    switch context {
    case .store:
      if isAugumented {
        try self.builder.appendRotTwo(at: location)
      }
      try self.builder.appendStoreAttribute(mangled, at: location)
    case .load:
      if isAugumented {
        try self.builder.appendDupTop(at: location)
      }
      try self.builder.appendLoadAttribute(mangled, at: location)
    case .del:
      assert(!isAugumented)
      try self.builder.appendDeleteAttribute(mangled, at: location)
    }
  }

  // MARK: - Slice

  /// compiler_visit_expr(struct compiler *c, expr_ty e)
  internal func visitSubscript(object: Expression,
                               slice:  Slice,
                               context:  ExpressionContext,
                               location: SourceLocation,
                               isAugumented: Bool = false) throws {
    let isAugumentedStore = isAugumented && context == .store
    if !isAugumentedStore {
      try self.visitExpression(object)
    }

    try self.visitSlice(slice: slice,
                        context: context,
                        location: location,
                        isAugumented: isAugumented)
  }

  /// compiler_visit_slice(struct compiler *c, slice_ty s, expr_context_ty ctx)
  /// compiler_handle_subscr(struct compiler *c, const char *kind, ...)
  private func visitSlice(slice:  Slice,
                          context:  ExpressionContext,
                          location: SourceLocation,
                          isAugumented: Bool) throws {

    let isAugumentedStore = isAugumented && context == .store
    if !isAugumentedStore {
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
        try self.builder.appendBuildTuple(elementCount: slices.count, at: location)
      }
    }

    switch context {
    case .store:
      if isAugumented {
        try self.builder.appendRotThree(at: location)
      }
      try self.builder.appendStoreSubscr(at: location)
    case .load:
      if isAugumented {
        try self.builder.appendDupTopTwo(at: location)
      }
      try self.builder.appendBinarySubscr(at: location)
    case .del:
      assert(!isAugumented)
      try self.builder.appendDeleteSubscr(at: location)
    }
  }

  /// compiler_visit_nested_slice(struct compiler *c, slice_ty s,
  /// expr_context_ty ctx)
  private func visitNestedSlice(slice: Slice, context: ExpressionContext) throws {
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
      try self.builder.appendNone(at: location)
    }

    if let u = upper {
      try self.visitExpression(u)
    } else {
      try self.builder.appendNone(at: location)
    }

    var type = SliceArg.lowerUpper
    if let s = step {
      type = .lowerUpperStep
      try self.visitExpression(s)
    }

    try self.builder.appendBuildSlice(type, at: location)
  }
}
