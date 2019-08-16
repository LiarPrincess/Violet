public enum FStringError: Error, Equatable {
  // TODO: better messages for 'unexpectedEnd'?
  /// We are starting expr but end of string happened: "abc{" or "abc}"
  case unexpectedEnd // TODO: f-string: expecting '}'
  /// f-string: single '}' is not allowed
  case singleRightBrace
  /// f-string expression part cannot include a backslash
  case backslashInExpression
  /// f-string expression part cannot include '#'
  case commentInExpression
  /// f-string: unterminated string
  case unterminatedString
  /// f-string: mismatched '(', '{', or '['
  case mismatchedParen
  /// f-string: empty expression not allowed
  case emptyExpression
  /// f-string: invalid conversion character: expected 's', 'r', or 'a'
  case invalidConversion(UnicodeScalar)
  /// Error when parsing expression.
  case parsingError(ParserErrorKind)
  /// Error when parsing expression.
  case unknownParsingError(Error)

  public static func == (lhs: FStringError, rhs: FStringError) -> Bool {
    switch (lhs, rhs) {
    case (.unexpectedEnd, .unexpectedEnd):
      return true
    case (.singleRightBrace, .singleRightBrace):
      return true
    case (.backslashInExpression, .backslashInExpression):
      return true
    case (.commentInExpression, .commentInExpression):
      return true
    case (.unterminatedString, .unterminatedString):
      return true
    case (.mismatchedParen, .mismatchedParen):
      return true
    case (.emptyExpression, .emptyExpression):
      return true
    case let (.invalidConversion(s0), .invalidConversion(s1)):
      return s0 == s1
    case let (.parsingError(e0), .parsingError(e1)):
      return e0 == e1
    case (.unknownParsingError, .unknownParsingError):
      return true
    default:
      return false
    }
  }
}
