public protocol CompilerDelegate: AnyObject {

  /// Handle `CompilerWarning`.
  func warn(warning: CompilerWarning)
}
