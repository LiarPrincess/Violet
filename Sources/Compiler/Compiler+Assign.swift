import Foundation
import Core
import Parser
import Bytecode

// In CPython:
// Python -> compile.c

// swiftlint:disable function_body_length

extension Compiler {

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
  internal func visitAssign(targets: NonEmptyArray<Expression>,
                            value: Expression) throws {
    try self.visitExpression(value)
    for (index, t) in targets.enumerated() {
      let isLast = index == targets.count - 1
      if !isLast {
        try self.builder.appendDupTop()
      }

      try self.visitExpression(t, context: .store)
    }
  }

  // MARK: - Aug assign

  /// compiler_augassign(struct compiler *c, stmt_ty s)
  ///
  /// `dis.dis('a += b')` gives us:
  /// ```c
  ///  0 LOAD_NAME                0 (a)
  ///  2 LOAD_NAME                1 (b)
  ///  4 INPLACE_ADD
  ///  6 STORE_NAME               0 (a)
  ///  8 LOAD_CONST               0 (None)
  /// 10 RETURN_VALUE
  /// ```
  internal func visitAugAssign(target: Expression,
                               op:     BinaryOperator,
                               value:  Expression) throws {
    switch target.kind {
    case let .identifier(name):
      let mangled = self.mangleName(name)
      try self.builder.appendLoadName(mangled)
      try self.visitExpression(value)
      try self.builder.appendInplaceOperator(op)
      try self.builder.appendStoreName(mangled)

    case let .attribute(object, name: name):
      func visitAttribute(context: ExpressionContext) throws {
        try self.visitAttribute(object: object,
                                name: name,
                                context: context,
                                isAugumented: true)
      }

      try visitAttribute(context: .load)
      try self.visitExpression(value)
      try self.builder.appendInplaceOperator(op)
      try visitAttribute(context: .store)

    case let .subscript(object, slice: slice):
      func visitSubscript(context: ExpressionContext) throws {
        try self.visitSubscript(object: object,
                                slice: slice,
                                context: context,
                                isAugumented: true)
      }

      try visitSubscript(context: .load)
      try self.visitExpression(value)
      try self.builder.appendInplaceOperator(op)
      try visitSubscript(context: .store)

    default:
      throw self.error(.invalidTargetForAugmentedAssignment)
    }
  }

  // MARK: - Ann assign

  /// compiler_annassign(struct compiler *c, stmt_ty s)
  /// check_annotation(struct compiler *c, stmt_ty s)
  ///
  /// `dis.dis('a: b = c')` gives us:
  /// ```c
  ///  0 SETUP_ANNOTATIONS
  ///  2 LOAD_NAME                0 (c)
  ///  4 STORE_NAME               1 (a)
  ///  6 LOAD_NAME                2 (b)
  ///  8 LOAD_NAME                3 (__annotations__)
  /// 10 LOAD_CONST               0 ('a')
  /// 12 STORE_SUBSCR
  /// 14 LOAD_CONST               1 (None)
  /// 16 RETURN_VALUE
  /// ```
  internal func visitAnnAssign(target:     Expression,
                               annotation: Expression,
                               value:    Expression?,
                               isSimple: Bool) throws {
    // Assignment first
    if let v = value {
      try self.visitExpression(v)
      try self.visitExpression(target, context: .store)
    }

    let scopeType = self.currentScope.type
    let isModuleOrClass = scopeType == .module || scopeType == .class

    switch target.kind {
    case let .identifier(name):
      guard isSimple && isModuleOrClass else {
        break
      }

      if self.future.flags.contains(.annotations) {
        try self.visitAnnExpr(annotation)
      } else {
        try self.visitExpression(annotation)
      }

      let __annotations__ = SpecialIdentifiers.__annotations__
      let mangled = self.mangleName(name)

      try self.builder.appendLoadName(__annotations__)
      try self.builder.appendString(mangled)
      try self.builder.appendStoreSubscr()

    case let .attribute(obj, name: _):
      if value == nil {
        try self.checkAnnExpr(obj)
      }

    case let .subscript(obj, slice: slice):
      if value == nil {
        try self.checkAnnExpr(obj)
        try self.checktAnnSlice(slice)
      }

    default:
      throw self.error(.invalidTargetForAnnotatedAssignment)
    }

    if !isSimple && isModuleOrClass {
      try self.checkAnnExpr(annotation)
    }
  }

  /// check_ann_expr(struct compiler *c, expr_ty e)
  private func checkAnnExpr(_ expr: Expression) throws {
    try self.visitExpression(expr)
    try self.builder.appendPopTop()
  }

  /// check_ann_subscr(struct compiler *c, slice_ty sl)
  private func checktAnnSlice(_ slice: Slice) throws {
    // We check that everything in a subscript is defined at runtime.
    switch slice.kind {
    case let .index(i):
      try self.checkAnnSliceIndex(i)

    case let .slice(lower: l, upper: u, step: s):
      try self.visitAnnSlice(lower: l, upper: u, step: s)

    case let .extSlice(slices):
      for s in slices {
        switch s.kind {
        case let .index(i):
          try self.checkAnnSliceIndex(i)

        case let .slice(lower: l, upper: u, step: s):
          try self.visitAnnSlice(lower: l, upper: u, step: s)

        case .extSlice:
          let kind = CompilerErrorKind.extendedSliceNestedInsideExtendedSlice
          throw self.error(kind)
        }
      }
    }
  }

  /// check_ann_slice(struct compiler *c, slice_ty sl)
  private func checkAnnSliceIndex(_ index: Expression) throws {
    try self.checkAnnExpr(index)
  }

  /// check_ann_slice(struct compiler *c, slice_ty sl)
  private func visitAnnSlice(lower: Expression?,
                             upper: Expression?,
                             step:  Expression?) throws {
    if let l = lower { try self.checkAnnExpr(l) }
    if let u = upper { try self.checkAnnExpr(u) }
    if let s = step  { try self.checkAnnExpr(s) }
  }

  /// compiler_visit_annexpr(struct compiler *c, expr_ty annotation)
  internal func visitAnnExpr(_ annotation: Expression) throws {
    // TODO: We should use proper 'ast_unparse' implementation
    let string = String(describing: annotation)
    try self.builder.appendString(string)
  }
}
