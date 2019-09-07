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
  internal func visitAssign(targets:  NonEmptyArray<Expression>,
                            value:    Expression,
                            location: SourceLocation) throws {

    try self.visitExpression(value)
    for (index, t) in targets.enumerated() {
      if index < targets.count {
        try self.codeObject.appendDupTop(at: location)
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
                               value:  Expression,
                               location: SourceLocation) throws {
    switch target.kind {
    case let .identifier(name):
      let mangled = self.mangleName(name)
      try self.codeObject.appendLoadName(mangled, at: location)
      try self.visitExpression(value)
      try self.codeObject.appendInplaceOperator(op, at: location)
      try self.codeObject.appendStoreName(mangled, at: location)

    case .attribute,
         .subscript:
      try self.visitExpression(target, context: .load)
      try self.visitExpression(value)
      try self.codeObject.appendInplaceOperator(op, at: location)
      try self.visitExpression(target, context: .store)

    default:
      throw self.error(.invalidTargetForAugmentedAssignment, location: location)
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
                               isSimple: Bool,
                               location: SourceLocation) throws {
    // Assignment first
    if let v = value {
      try self.visitExpression(v)
      try self.visitExpression(target)
    }

    let scopeType = self.currentScope.type
    let isModuleOrClass = scopeType == .module || scopeType == .class

    switch target.kind {
    case let .identifier(name):
      guard isSimple && isModuleOrClass else {
        break
      }

      if self.future.flags.contains(.annotations) {
        try self.visitAnnExpr(annotation, location: location)
      } else {
        try self.visitExpression(annotation)
      }

      let __annotations__ = SpecialIdentifiers.__annotations__
      let mangled = self.mangleName(name)

      try self.codeObject.appendLoadName(__annotations__, at: location)
      try self.codeObject.appendString(mangled, at: location)
      try self.codeObject.appendStoreSubscr(at: location)

    case let .attribute(obj, name: _):
      if value == nil {
        try self.checkAnnExpr(obj, location: location)
      }

    case let .subscript(obj, slice: slice):
      if value == nil {
        try self.checkAnnExpr(obj, location: location)
        try self.checktAnnSlice(slice, location: location)
      }

    default:
      throw self.error(.invalidTargetForAnnotatedAssignment, location: location)
    }

    if !isSimple && isModuleOrClass {
      try self.checkAnnExpr(annotation, location: location)
    }
  }

  /// check_ann_expr(struct compiler *c, expr_ty e)
  private func checkAnnExpr(_ expr: Expression, location: SourceLocation) throws {
    try self.visitExpression(expr)
    try self.codeObject.appendPopTop(at: location)
  }

  /// check_ann_subscr(struct compiler *c, slice_ty sl)
  private func checktAnnSlice(_ slice: Slice, location: SourceLocation) throws {
    // We check that everything in a subscript is defined at runtime.
    switch slice.kind {
    case let .index(i):
      try self.checkAnnSliceIndex(i, location: location)

    case let .slice(lower: l, upper: u, step: s):
      try self.visitAnnSlice(lower: l, upper: u, step: s, location: location)

    case let .extSlice(slices):
      for s in slices {
        switch s.kind {
        case let .index(i):
          try self.checkAnnSliceIndex(i, location: location)

        case let .slice(lower: l, upper: u, step: s):
          try self.visitAnnSlice(lower: l, upper: u, step: s, location: location)

        case .extSlice:
          let kind = CompilerErrorKind.extendedSliceNestedInsideExtendedSlice
          throw self.error(kind, location: location)
        }
      }
    }
  }

  /// check_ann_slice(struct compiler *c, slice_ty sl)
  private func checkAnnSliceIndex(_ index: Expression,
                                  location: SourceLocation) throws {
    try self.checkAnnExpr(index, location: location)
  }

  /// check_ann_slice(struct compiler *c, slice_ty sl)
  private func visitAnnSlice(lower: Expression?,
                             upper: Expression?,
                             step:  Expression?,
                             location: SourceLocation) throws {
    if let l = lower { try self.checkAnnExpr(l, location: location) }
    if let u = upper { try self.checkAnnExpr(u, location: location) }
    if let s = step  { try self.checkAnnExpr(s, location: location) }
  }

  /// compiler_visit_annexpr(struct compiler *c, expr_ty annotation)
  internal func visitAnnExpr(_ annotation: Expression,
                             location: SourceLocation) throws {
    // TODO: We should use proper 'ast_unparse' implementation
    let string = String(describing: annotation)
    try self.codeObject.appendString(string, at: location)
  }
}
