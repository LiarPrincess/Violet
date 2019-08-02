public protocol LexerType {

  /// Get nex token to parse.
  /// If we reached EOF then it should return EOF token.
  mutating func getToken() throws -> Token
}
