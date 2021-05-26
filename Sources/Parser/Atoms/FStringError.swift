public indirect enum FStringError: Error, Equatable, CustomStringConvertible {
  /// f-string: expecting '}'.
  /// For example: "abc{" or "abc}"
  case unexpectedEnd
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

  /// Given feature was not yet implemented.
  case unimplemented(FStringUnimplemented)

  public var description: String {
    switch self {
    case .unexpectedEnd:
      return "Expecting '}'"
    case .singleRightBrace:
      return "Single '}' is not allowed"
    case .backslashInExpression:
      return "Expression part cannot include a backslash"
    case .commentInExpression:
      return "Expression part cannot include '#'"
    case .unterminatedString:
      return "Unterminated string"
    case .mismatchedParen:
      return "Mismatched '(', '{', or '['"
    case .emptyExpression:
      return "Empty expression not allowed"
    case let .invalidConversion(scalar):
      let codePoint = scalar.codePointNotation
      return "Invalid conversion character '\(scalar)' (unicode: \(codePoint)), " +
             "expected 's', 'r', or 'a'"
    case let .parsingError(kind):
      return String(describing: kind)
    case let .unimplemented(u):
      return "UNIMPLEMENTED IN VIOLET: " + String(describing: u)
    }
  }
}
