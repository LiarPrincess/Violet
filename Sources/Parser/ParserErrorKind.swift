public enum ParserErrorKind: Equatable {

  // MARK: - Function/lambda definition

  /// Non-default argument follows default argument.
  case defaultAfterNonDefaultArgument
  /// Duplicate non-keyworded variable length argument (the one with '*').
  case duplicateVarargs
  /// Duplicate keyworded variable length argument (the one with '**').
  case duplicateKwargs
  /// Argument after keyworded variable length argument (the one with '**').
  case argsAfterKwargs
  /// Non-keyworded variable length argument (the one with '*') after
  /// keyworded variable length argument (the one with '**').
  case varargsAfterKwargs
  /// Named arguments must follow bare *.
  case starWithoutFollowingArguments

  // MARK: - Call

  /// Positional argument follows keyword argument.
  case callWithPositionalArgumentAfterKeywordArgument
  /// Positional argument follows keyword argument unpacking.
  case callWithPositionalArgumentAfterKeywordUnpacking
  /// Iterable argument unpacking (the one with '*') after
  /// keyword argument unpacking (the one with '**').
  case callWithIterableArgumentAfterKeywordUnpacking
  /// Lambda argument cannot contain assignment
  /// (for example: `f(lambda x: x[0] = 3)`).
  case callWithLambdaAssignment
  /// Keyword can't be an expression.
  case callWithKeywordExpression
  /// Keyword argument repeated.
  case callWithDuplicateKeywordArgument(String)

  case unimplemented(String)
}

extension ParserErrorKind: CustomStringConvertible {
  public var description: String {
    switch self {

    case .defaultAfterNonDefaultArgument:
      return "Non-default argument follows default argument."
    case .duplicateVarargs:
      return "Duplicate non-keyworded variable length argument (the one with '*')."
    case .duplicateKwargs:
      return "Duplicate keyworded variable length argument (the one with '**')."
    case .argsAfterKwargs:
      return "Argument after keyworded variable length argument (the one with '**')."
    case .varargsAfterKwargs:
      return "Non-keyworded variable length argument (the one with '*') after " +
             "keyworded variable length argument (the one with '**')."
    case .starWithoutFollowingArguments:
      return "Named arguments must follow bare *."

    case .callWithPositionalArgumentAfterKeywordArgument:
      return "Positional argument follows keyword argument."
    case .callWithPositionalArgumentAfterKeywordUnpacking:
      return "Positional argument follows keyword argument unpacking."
    case .callWithIterableArgumentAfterKeywordUnpacking:
      return "Iterable argument unpacking (the one with '*') after " +
             "keyword argument unpacking (the one with '**')."
    case .callWithLambdaAssignment:
      return "Lambda argument cannot contain assignment."
    case .callWithKeywordExpression:
      return "Keyword can't be an expression."
    case .callWithDuplicateKeywordArgument(let name):
      return "Duplicate keyword argument '\(name)'."

    case .unimplemented(let msg):
      return "Unimplemented: '\(msg)'"
    }
  }
}
