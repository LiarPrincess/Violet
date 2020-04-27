import VioletCore

/// Single 'word' in a source code.
public struct Token: Equatable {

  /// Type of the token.
  public let kind: TokenKind

  /// Location of the first character in the source code.
  /// Should be roughly equal to the one you would get from CPython.
  public let start: SourceLocation

  /// Location just after the last character in the source code.
  /// Should be roughly equal to the one you would get from CPython.
  public let end: SourceLocation

  public init(_ kind: TokenKind, start: SourceLocation, end: SourceLocation) {
    self.kind = kind
    self.start = start
    self.end = end
  }
}

extension Token: CustomStringConvertible {
  public var description: String {
    return "\(self.start)-\(self.end): \(self.kind)"
  }
}
