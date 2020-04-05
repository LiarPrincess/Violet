import Core

public struct ParserWarning: CustomStringConvertible {

  /// Type of the warning.
  public let kind: ParserWarningKind

  /// Location of the warning in the code.
  public let location: SourceLocation

  public var description: String {
    return "\(self.location): \(self.kind)"
  }

  public init(_ kind: ParserWarningKind, location: SourceLocation) {
    self.kind = kind
    self.location = location
  }
}

public enum ParserWarningKind: CustomStringConvertible {

  /// Something like `f(a for b in [])`.
  /// Basic support is implemented, but it may not work correctly.
  /// - Note:
  /// If there are other arguments present we should require parens!
  case callWithGeneratorArgument

  public var description: String {
    switch self {
    case .callWithGeneratorArgument:
      return "Call with generator argument."
    }
  }
}
