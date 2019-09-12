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

  /// Assertion is always true, perhaps remove parentheses?
  case assertionWithTuple
}

extension CompilerWarning: CustomStringConvertible {
  public var description: String {
    switch self {
    case let .yieldInsideComprehension(kind):
      return "'yield' inside '\(kind)' comprehension"
    case .assertionWithTuple:
      return "Assertion is always true, perhaps remove parentheses?"
    }
  }
}

// MARK: - ComprehensionKind

public enum ComprehensionKind: Equatable {
  case list
  case set
  case dictionary
  case generator
}

extension ComprehensionKind: CustomStringConvertible {
  public var description: String {
    switch self {
    case .list: return "list"
    case .set: return "set"
    case .dictionary: return "dictionary"
    case .generator: return "generator"
    }
  }
}
