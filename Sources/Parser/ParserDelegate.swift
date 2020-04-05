public protocol ParserDelegate: AnyObject {

  /// Handle `ParserWarning`.
  func warn(warning: ParserWarning)
}
