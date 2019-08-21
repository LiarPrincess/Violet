import Core

public enum CompilerWarning: Warning {

  /// 'yield' inside 'kind' comprehension
  ///
  /// Due to their side effects on the containing scope, yield expressions
  /// are not permitted as part of the implicitly defined scopes used
  /// to implement comprehensions and generator expressions.
  ///
  /// See:
  /// - [docs](https://docs.python.org/3/reference/expressions.html#yield-expressions)
  /// - [bug report](https://bugs.python.org/issue10544)
  case yieldInsideComprehension(ComprehensionKind)
}

public enum ComprehensionKind: Equatable {
  case list
  case set
  case dictionary
  case generator

  internal var identifier: String {
    switch self {
    case .list: return SpecialIdentifiers.listcomp
    case .set: return SpecialIdentifiers.setcomp
    case .dictionary: return SpecialIdentifiers.dictcomp
    case .generator: return SpecialIdentifiers.genexpr
    }
  }
}
