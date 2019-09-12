import Parser

extension Statement {

  /// compiler_isdocstring(stmt_ty s)
  internal var isDocString: Bool {
    return self.getDocString() != nil
  }

  /// compiler_isdocstring(stmt_ty s)
  internal func getDocString() -> String? {
    guard case let StatementKind.expr(expr) = self.kind else {
      return nil
    }

    guard case let ExpressionKind.string(group) = expr.kind else {
      return nil
    }

    switch group {
    case let .literal(s): return s
    case .formattedValue, .joined: return nil
    }
  }
}
