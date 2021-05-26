import VioletCore

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

  /// In the past we had parser warnings, but since then we fixed all of them.
  ///
  /// We will leave this code, so that in the future we don't have to reimplement
  /// this.
  case weDoNotHaveWarningsAnymore

  public var description: String {
    trap("Wo do not have parser warnings anymore...")
  }
}
