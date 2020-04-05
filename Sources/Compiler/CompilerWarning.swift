import Core

// MARK: - Warning

public struct CompilerWarning: CustomStringConvertible {

  /// Type of the warning.
  public let kind: CompilerWarningKind

  /// Location of the warning in the code.
  public let location: SourceLocation

  public var description: String {
    return "\(self.location): \(self.kind)"
  }

  public init(_ kind: CompilerWarningKind, location: SourceLocation) {
    self.kind = kind
    self.location = location
  }
}

// MARK: - Warning kind

public enum CompilerWarningKind: CustomStringConvertible {

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

public enum ComprehensionKind: Equatable, CustomStringConvertible {
  case list
  case set
  case dictionary
  case generator

  public var description: String {
    switch self {
    case .list: return "list"
    case .set: return "set"
    case .dictionary: return "dictionary"
    case .generator: return "generator"
    }
  }
}
