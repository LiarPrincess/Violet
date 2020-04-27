import VioletCore
import VioletLexer

public struct ParserError: Error, Equatable, CustomStringConvertible {

  /// Type of the error.
  public let kind: ParserErrorKind

  /// Location of the error in the code.
  public let location: SourceLocation

  public var description: String {
    return "\(self.location): \(self.kind)"
  }

  public init(_ kind: ParserErrorKind, location: SourceLocation) {
    self.kind = kind
    self.location = location
  }
}
