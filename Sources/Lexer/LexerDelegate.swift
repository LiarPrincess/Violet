public protocol LexerDelegate: AnyObject {

  /// Handle `LexerWarning`.
  func warn(warning: LexerWarning)
}
