import Core

// MARK: - Warning

public struct LexerWarning: Equatable, CustomStringConvertible {

  /// Type of the warning.
  public let kind: LexerWarningKind

  /// Location of the warning in the code.
  public let location: SourceLocation

  public var description: String {
    return "\(self.location): \(self.kind)"
  }

  public init(_ kind: LexerWarningKind, location: SourceLocation) {
    self.kind = kind
    self.location = location
  }
}

// MARK: - Kind

public enum LexerWarningKind: Equatable, CustomStringConvertible {

  /// Changed in version 3.6:
  /// Unrecognized escape sequences produce a DeprecationWarning.
  /// In some future version of Python they will be a SyntaxError.
  case unrecognizedEscapeSequence

  public var description: String {
    switch self {
    case .unrecognizedEscapeSequence:
      return "Unrecognized escape sequence."
    }
  }
}
