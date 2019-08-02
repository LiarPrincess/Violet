import Lexer

public struct ParserError: Error, Equatable {

  /// Type of the error.
  public let kind: ParserErrorKind

  /// Location of the error in the code.
  public let location: SourceLocation

  public init(_ kind:   ParserErrorKind,
              location: SourceLocation) {

    self.kind = kind
    self.location = location
  }
}

extension ParserError: CustomStringConvertible {
  public var description: String {
    return "\(self.location): SyntaxError: \(self.kind)"
  }
}
