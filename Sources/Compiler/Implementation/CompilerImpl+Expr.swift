import Foundation
import VioletCore
import VioletParser
import VioletBytecode

// In CPython:
// Python -> compile.c

// swiftlint:disable file_length
// cSpell:ignore nameop boolop ifexp cond subscr basicblock

extension CompilerImpl {

  internal func visit(_ node: Expression) throws {
    self.setAppendLocation(node)
    try node.accept(self)
  }

  /// compiler_visit_expr(struct compiler *c, expr_ty e)
  internal func visit<S: Sequence>(_ nodes: S) throws where S.Element: Expression {
    for node in nodes {
      try self.visit(node)
    }
  }

  // MARK: - General

  internal func visit(_ node: NoneExpr) throws {
    self.builder.appendNone()
  }

  internal func visit(_ node: EllipsisExpr) throws {
    self.builder.appendEllipsis()
  }

  // MARK: - Bool

  internal func visit(_ node: TrueExpr) throws {
    self.builder.appendTrue()
  }

  internal func visit(_ node: FalseExpr) throws {
    self.builder.appendFalse()
  }

  // MARK: - Identifier

  private enum IdentifierOperation {
    case fast
    case global
    case cell
    case free
    case name
  }

  internal func visit(_ node: IdentifierExpr) throws {
    self.visitName(name: node.value, context: node.context)
  }

  /// compiler_nameop(struct compiler *c, identifier name, expr_context_ty ctx)
  internal func visitName(name: String, context: ExpressionContext) {
    let mangled = self.mangle(name: name)
    let scope = self.currentScope
    let info = scope.symbols[mangled]

    // 'name.starts(with: "_")' for '__doc__' etc.
    assert(info != nil || name.starts(with: "_"))

    let flags = info?.flags ?? []
    var operation = IdentifierOperation.name

    if flags.contains(.srcFree) {
      operation = .free
    } else if flags.contains(.cell) {
      operation = .cell
    } else if flags.contains(.srcLocal) {
      if scope.kind.isFunctionLambdaComprehension {
        operation = .fast
      }
    } else if flags.contains(.srcGlobalImplicit) {
      if scope.kind.isFunctionLambdaComprehension {
        operation = .global
      }
    } else if flags.contains(.srcGlobalExplicit) {
      operation = .global
    }

    switch operation {
    case .free:
      let isLoadInClass = context == .load && scope.kind.isClass
      if isLoadInClass {
        self.builder.appendLoadClassFree(mangled)
      } else {
        self.builder.appendFree(name: mangled, context: context)
      }
    case .cell: self.builder.appendCell(name: mangled, context: context)
    case .fast: self.builder.appendFast(name: mangled, context: context)
    case .global: self.builder.appendGlobal(name: mangled, context: context)
    case .name: self.builder.appendName(name: mangled, context: context)
    }
  }

  // MARK: - Numbers

  internal func visit(_ node: IntExpr) throws {
    self.builder.appendInteger(node.value)
  }

  internal func visit(_ node: FloatExpr) throws {
    self.builder.appendFloat(node.value)
  }

  internal func visit(_ node: ComplexExpr) throws {
    self.builder.appendComplex(real: node.real, imag: node.imag)
  }

  // MARK: - String

  /// compiler_formatted_value(struct compiler *c, expr_ty e)
  /// compiler_joined_str(struct compiler *c, expr_ty e)
  internal func visit(_ node: StringExpr) throws {
    try self.visit(node.value)
  }

  internal func visit(_ group: StringExpr.Group) throws {
    switch group {
    case let .literal(s):
      self.builder.appendString(s)

    case let .formattedValue(expr, conversion: conversionArg, spec: spec):
      try self.visit(expr)

      var conversion = Instruction.StringConversion.none
      switch conversionArg {
      case .some(.str): conversion = .str
      case .some(.repr): conversion = .repr
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
        try self.visit(g)
      }

      if groups.count > 1 {
        self.builder.appendBuildString(count: groups.count)
      }
    }
  }

  internal func visit(_ node: BytesExpr) throws {
    self.builder.appendBytes(node.value)
  }

  // MARK: - Operators

  internal func visit(_ node: UnaryOpExpr) throws {
    try self.visit(node.right)
    self.builder.appendUnaryOperator(node.op)
  }

  internal func visit(_ node: BinaryOpExpr) throws {
    try self.visit(node.left)
    try self.visit(node.right)
    self.builder.appendBinaryOperator(node.op)
  }

  /// compiler_boolop(struct compiler *c, expr_ty e)
  ///
  /// `dis.dis('a and b')` gives us:
  /// ```c
  /// 0 LOAD_NAME                0 (a)
  /// 2 JUMP_IF_FALSE_OR_POP     6
  /// 4 LOAD_NAME                1 (b)
  /// 6 RETURN_VALUE
  /// ```
  internal func visit(_ node: BoolOpExpr) throws {
    let end = self.builder.createLabel()

    try self.visit(node.left)

    switch node.op {
    case .and: self.builder.appendJumpIfFalseOrPop(to: end)
    case .or: self.builder.appendJumpIfTrueOrPop(to: end)
    }

    try self.visit(node.right)
    self.builder.setLabel(end)
  }

  // MARK: - Compare

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
  internal func visit(_ node: CompareExpr) throws {
    try self.visit(node.left)

    if node.elements.count == 1 {
      let first = node.elements.first
      try self.visit(first.right)
      self.builder.appendCompareOp(operator: first.op)
    } else {
      let end = self.builder.createLabel()
      let cleanup = self.builder.createLabel()

      for element in node.elements.dropLast() {
        try self.visit(element.right)
        self.builder.appendDupTop()
        self.builder.appendRotThree()
        self.builder.appendCompareOp(operator: element.op)
        self.builder.appendJumpIfFalseOrPop(to: cleanup)
      }

      let last = node.elements.last
      try self.visit(last.right)
      self.builder.appendCompareOp(operator: last.op)

      self.builder.appendJumpAbsolute(to: end)
      self.builder.setLabel(cleanup)
      self.builder.appendRotTwo()
      self.builder.appendPopTop()
      self.builder.setLabel(end)
    }
  }

  // MARK: - Await

  /// compiler_visit_expr(struct compiler *c, expr_ty e)
  internal func visit(_ node: AwaitExpr) throws {
    guard self.currentScope.kind.isFunctionLambdaComprehension else {
      throw self.error(.awaitOutsideFunction)
    }

    // We only allow 'await' inside async functions
    // (and comprehensions inside those async functions).
    switch self.builder.kind {
    case .asyncFunction,
         .comprehension:
      break
    case .module,
         .class,
         .function,
         .lambda:
      throw self.error(.awaitOutsideAsyncFunction)
    }

    try self.visit(node.value)
    self.builder.appendGetAwaitable()
    self.builder.appendNone()
    self.builder.appendYieldFrom()
  }

  // MARK: - Yield

  /// compiler_visit_expr(struct compiler *c, expr_ty e)
  internal func visit(_ node: YieldExpr) throws {
    guard self.currentScope.kind.isFunctionLambdaComprehension else {
      throw self.error(.yieldOutsideFunction)
    }

    if let v = node.value {
      try self.visit(v)
    } else {
      self.builder.appendNone()
    }

    self.builder.appendYieldValue()
  }

  /// compiler_visit_expr(struct compiler *c, expr_ty e)
  internal func visit(_ node: YieldFromExpr) throws {
    guard self.currentScope.kind.isFunctionLambdaComprehension else {
      throw self.error(.yieldOutsideFunction)
    }

    if self.builder.kind == .asyncFunction {
      throw self.error(.yieldFromInsideAsyncFunction)
    }

    try self.visit(node.value)
    self.builder.appendGetYieldFromIter()
    self.builder.appendNone()
    self.builder.appendYieldFrom()
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
  internal func visit(_ node: IfExpr) throws {
    let end = self.builder.createLabel()
    let orElseStart = self.builder.createLabel()

    try self.visit(node.test, andJumpTo: orElseStart, ifBooleanValueIs: false)
    try self.visit(node.body)
    self.builder.appendJumpAbsolute(to: end)
    self.builder.setLabel(orElseStart)
    try self.visit(node.orElse)
    self.builder.setLabel(end)
  }

  // MARK: - Attribute

  internal func visit(_ node: AttributeExpr) throws {
    try self.visitAttribute(object: node.object,
                            name: node.name,
                            context: node.context)
  }

  /// compiler_visit_expr(struct compiler *c, expr_ty e)
  internal func visitAttribute(object: Expression,
                               name: String,
                               context: ExpressionContext,
                               isAugmented: Bool = false) throws {
    let mangled = self.mangle(name: name)

    let isAugmentedStore = isAugmented && context == .store
    if !isAugmentedStore {
      try self.visit(object)
    }

    switch context {
    case .store:
      if isAugmented {
        self.builder.appendRotTwo()
      }
      self.builder.appendStoreAttribute(mangled)
    case .load:
      if isAugmented {
        self.builder.appendDupTop()
      }
      self.builder.appendLoadAttribute(mangled)
    case .del:
      assert(!isAugmented)
      self.builder.appendDeleteAttribute(mangled)
    }
  }

  // MARK: - Slice

  internal func visit(_ node: SubscriptExpr) throws {
    try self.visitSubscript(object: node.object,
                            slice: node.slice,
                            context: node.context)
  }

  /// compiler_visit_expr(struct compiler *c, expr_ty e)
  internal func visitSubscript(object: Expression,
                               slice: Slice,
                               context: ExpressionContext,
                               isAugmented: Bool = false) throws {
    let isAugmentedStore = isAugmented && context == .store
    if !isAugmentedStore {
      try self.visit(object)
    }

    try self.visitSlice(slice: slice, context: context, isAugmented: isAugmented)
  }

  /// compiler_visit_slice(struct compiler *c, slice_ty s, expr_context_ty ctx)
  /// compiler_handle_subscr(struct compiler *c, const char *kind, ...)
  private func visitSlice(slice: Slice,
                          context: ExpressionContext,
                          isAugmented: Bool) throws {

    let isAugmentedStore = isAugmented && context == .store
    if !isAugmentedStore {
      switch slice.kind {
      case let .index(index):
        try self.visit(index)
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
      if isAugmented {
        self.builder.appendRotThree()
      }
      self.builder.appendStoreSubscript()
    case .load:
      if isAugmented {
        self.builder.appendDupTopTwo()
      }
      self.builder.appendBinarySubscript()
    case .del:
      assert(!isAugmented)
      self.builder.appendDeleteSubscript()
    }
  }

  /// compiler_visit_nested_slice(struct compiler *c, slice_ty s,
  /// expr_context_ty ctx)
  private func visitNestedSlice(slice: Slice, context: ExpressionContext) throws {
    switch slice.kind {
    case let .index(index):
      try self.visit(index)
    case let .slice(lower, upper, step):
      try self.compileSlice(lower: lower, upper: upper, step: step)
    case .extSlice:
      throw self.error(.extendedSliceNestedInsideExtendedSlice)
    }
  }

  /// compiler_slice(struct compiler *c, slice_ty s, expr_context_ty ctx)
  private func compileSlice(lower: Expression?,
                            upper: Expression?,
                            step: Expression?) throws {

    if let l = lower {
      try self.visit(l)
    } else {
      self.builder.appendNone()
    }

    if let u = upper {
      try self.visit(u)
    } else {
      self.builder.appendNone()
    }

    var type = Instruction.SliceArg.lowerUpper
    if let s = step {
      type = .lowerUpperStep
      try self.visit(s)
    }

    self.builder.appendBuildSlice(arg: type)
  }

  // MARK: - Starred

  internal func visit(_ node: StarredExpr) throws {
    // In all legitimate cases, the starred node was already replaced
    // inside assign, call etc.
    switch node.context {
    case .store:
      throw self.error(.starredAssignmentNotListOrTuple)
    case .load,
         .del:
      throw self.error(.invalidStarredExpression)
    }
  }

  // MARK: - Helper

  // swiftlint:disable function_body_length

  /// compiler_jump_if(struct compiler *c, expr_ty e, basicblock *next, int cond)
  internal func visit(_ expression: Expression,
                      andJumpTo next: CodeObjectBuilder.NotAssignedLabel,
                      ifBooleanValueIs cond: Bool) throws {
    // swiftlint:enable function_body_length
    self.setAppendLocation(expression)

    if let unaryOp = expression as? UnaryOpExpr {
      switch unaryOp.op {
      case .not:
        try self.visit(unaryOp.right, andJumpTo: next, ifBooleanValueIs: !cond)
        return
      case .plus,
           .minus,
           .invert:
        break // fallback to general implementation
      }
    } else if let boolOp = expression as? BoolOpExpr {
      let isOr = boolOp.op == .or
      let hasLabel = cond != isOr
      let next2 = hasLabel ? self.builder.createLabel() : next

      try self.visit(boolOp.left, andJumpTo: next2, ifBooleanValueIs: isOr)
      try self.visit(boolOp.right, andJumpTo: next, ifBooleanValueIs: cond)

      if hasLabel {
        self.builder.setLabel(next2)
      }

      return
    } else if let ifExpr = expression as? IfExpr {
      let end = self.builder.createLabel()
      let next2 = self.builder.createLabel()

      try self.visit(ifExpr.test, andJumpTo: next2, ifBooleanValueIs: false)
      try self.visit(ifExpr.body, andJumpTo: next, ifBooleanValueIs: cond)

      self.builder.appendJumpAbsolute(to: end)
      self.builder.setLabel(next2)

      try self.visit(ifExpr.orElse, andJumpTo: next, ifBooleanValueIs: cond)
      self.builder.setLabel(end)

      return
    } else if let compare = expression as? CompareExpr, compare.elements.count > 1 {
      // If the count is 1 then fallback to general implementation!
      try self.visit(compare, andJumpTo: next, ifBooleanValueIs: cond)
      return
    }

    // general implementation:
    try self.visit(expression)
    switch cond {
    case true: self.builder.appendPopJumpIfTrue(to: next)
    case false: self.builder.appendPopJumpIfFalse(to: next)
    }
  }

  private func visit(_ compare: CompareExpr,
                     andJumpTo next: CodeObjectBuilder.NotAssignedLabel,
                     ifBooleanValueIs cond: Bool) throws {
    assert(compare.elements.count > 1)

    try self.visit(compare.left)

    let end = self.builder.createLabel()
    let cleanup = self.builder.createLabel()

    for element in compare.elements.dropLast() {
      try self.visit(element.right)
      self.builder.appendDupTop()
      self.builder.appendRotThree()
      self.builder.appendCompareOp(operator: element.op)
      self.builder.appendPopJumpIfFalse(to: cleanup)
    }

    let last = compare.elements.last
    try self.visit(last.right)
    self.builder.appendCompareOp(operator: last.op)

    switch cond {
    case true: self.builder.appendPopJumpIfTrue(to: next)
    case false: self.builder.appendPopJumpIfFalse(to: next)
    }

    self.builder.appendJumpAbsolute(to: end)
    self.builder.setLabel(cleanup)
    self.builder.appendPopTop()

    if !cond {
      self.builder.appendJumpAbsolute(to: next)
    }
    self.builder.setLabel(end)
  }
}
