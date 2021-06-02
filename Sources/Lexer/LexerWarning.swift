import VioletCore

public struct LexerWarning: Equatable, CustomStringConvertible {

  /// Type of the warning.
  public let kind: Kind

  /// Location of the warning in the code.
  public let location: SourceLocation

  public var description: String {
    return "\(self.location): \(self.kind)"
  }

  public init(_ kind: Kind, location: SourceLocation) {
    self.kind = kind
    self.location = location
  }

  // MARK: - Kind

  public enum Kind: Equatable, CustomStringConvertible {

    /// Changed in version 3.6:
    /// Unrecognized escape sequences produce a DeprecationWarning.
    /// In some future version of Python they will be a SyntaxError.
    case unrecognizedEscapeSequence(String)

    public var description: String {
      switch self {
      case let .unrecognizedEscapeSequence(s):
        return "Unrecognized escape sequence '\(s)'."
      }
    }
  }
}
