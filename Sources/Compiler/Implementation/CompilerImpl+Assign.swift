import Foundation
import VioletCore
import VioletParser
import VioletBytecode

// In CPython:
// Python -> compile.c

// cSpell:ignore inplace subscr annexpr

extension CompilerImpl {

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
  internal func visit(_ node: AssignStmt) throws {
    try self.visit(node.value)

    for (index, target) in node.targets.enumerated() {
      let isLast = index == node.targets.count - 1
      if !isLast {
        self.builder.appendDupTop()
      }

      try self.visit(target)
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
  internal func visit(_ node: AugAssignStmt) throws {
    if let identifier = node.target as? IdentifierExpr {
      self.visitName(name: identifier.value, context: .load)
      try self.visit(node.value)
      self.builder.appendInPlaceOperator(node.op)
      self.visitName(name: identifier.value, context: .store)
      return
    }

    if let attribute = node.target as? AttributeExpr {
      func visitAttribute(context: ExpressionContext) throws {
        try self.visitAttribute(object: attribute.object,
                                name: attribute.name,
                                context: context,
                                isAugmented: true)
      }

      try visitAttribute(context: .load)
      try self.visit(node.value)
      self.builder.appendInPlaceOperator(node.op)
      try visitAttribute(context: .store)
      return
    }

    if let subscr = node.target as? SubscriptExpr {
      func visitSubscript(context: ExpressionContext) throws {
        try self.visitSubscript(object: subscr.object,
                                slice: subscr.slice,
                                context: context,
                                isAugmented: true)
      }

      try visitSubscript(context: .load)
      try self.visit(node.value)
      self.builder.appendInPlaceOperator(node.op)
      try visitSubscript(context: .store)
      return
    }

    throw self.error(.invalidTargetForAugmentedAssignment)
  }

  // MARK: - Ann assign

  // swiftlint:disable function_body_length

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
  internal func visit(_ node: AnnAssignStmt) throws {
    // swiftlint:enable function_body_length

    // Assignment first
    if let v = node.value {
      try self.visit(v)
      try self.visit(node.target)
    }

    let scopeKind = self.currentScope.kind
    let isModuleOrClass = scopeKind.isModule || scopeKind.isClass

    func check() throws {
      if !node.isSimple && isModuleOrClass {
        try self.checkAnnExpr(node.annotation)
      }
    }

    if let identifier = node.target as? IdentifierExpr {
      guard node.isSimple && isModuleOrClass else {
        try check()
        return
      }

      if self.future.flags.contains(.annotations) {
        try self.visitAnnExpr(node.annotation)
      } else {
        try self.visit(node.annotation)
      }

      let mangled = self.mangle(name: identifier.value)
      self.builder.appendLoadName(SpecialIdentifiers.__annotations__)
      self.builder.appendString(mangled)
      self.builder.appendStoreSubscript()
      return
    }

    if let attribute = node.target as? AttributeExpr {
      if node.value == nil {
        try self.checkAnnExpr(attribute.object)
      }

      try check()
      return
    }

    if let subscr = node.target as? SubscriptExpr {
      if node.value == nil {
        try self.checkAnnExpr(subscr.object)
        try self.checkAnnSlice(subscr.slice)
      }

      try check()
      return
    }

    throw self.error(.invalidTargetForAnnotatedAssignment)
  }

  /// check_ann_expr(struct compiler *c, expr_ty e)
  private func checkAnnExpr(_ expr: Expression) throws {
    try self.visit(expr)
    self.builder.appendPopTop()
  }

  /// check_ann_subscr(struct compiler *c, slice_ty sl)
  private func checkAnnSlice(_ slice: Slice) throws {
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
          throw self.error(.extendedSliceNestedInsideExtendedSlice)
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
                             step: Expression?) throws {
    if let l = lower { try self.checkAnnExpr(l) }
    if let u = upper { try self.checkAnnExpr(u) }
    if let s = step { try self.checkAnnExpr(s) }
  }

  /// compiler_visit_annexpr(struct compiler *c, expr_ty annotation)
  internal func visitAnnExpr(_ annotation: Expression) throws {
    throw self.error(.unimplemented(.postponedAnnotationsEvaluation_PEP563))
  }
}
