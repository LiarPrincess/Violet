public protocol LexerType: AnyObject {

  /// Get nex token to parse.
  /// If we reached EOF then it should return EOF token.
  func getToken() throws -> Token
}
