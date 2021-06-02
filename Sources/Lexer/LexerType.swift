public protocol LexerType: AnyObject {
  /// Get the next token to parse.
  /// If EOF is reached, it will return EOF forever.
  func getToken() throws -> Token
}
