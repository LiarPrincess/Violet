import VioletParser

// cSpell:ignore isdocstring

extension Statement {

  /// compiler_isdocstring(stmt_ty s)
  internal var isDocString: Bool {
    return self.getDocString() != nil
  }

  /// compiler_isdocstring(stmt_ty s)
  internal func getDocString() -> String? {
    guard let exprStmt = self as? ExprStmt else {
      return nil
    }

    guard let stringExpr = exprStmt.expression as? StringExpr else {
      return nil
    }

    switch stringExpr.value {
    case .literal(let s):
      return s
    case .formattedValue,
         .joined:
      return nil
    }
  }
}
