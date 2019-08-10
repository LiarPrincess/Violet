public enum TokenKind: Equatable, CustomStringConvertible {
  case alias
  case `enum`
  case indirect
  case `struct`
  case name(String)
  case doc(String)

  case equal
  case or
  case star
  case option
  case comma

  case leftParen
  case rightParen

  case eof

  public var description: String {
    switch self {
    case .alias: return "@alias"
    case .enum: return "@enum"
    case .indirect: return "@indirect"
    case .struct: return "@struct"
    case .name(let value): return value
    case .doc: return "documentation"
    case .equal: return "="
    case .or: return "|"
    case .star: return "*"
    case .option: return "?"
    case .comma: return ","
    case .leftParen: return "("
    case .rightParen: return ")"
    case .eof: return "eof"
    }
  }
}

public struct Token: Equatable, CustomStringConvertible {

  public let kind: TokenKind
  public let location: SourceLocation

  public init(_ kind: TokenKind, location: SourceLocation) {
    self.kind = kind
    self.location = location
  }

  public var description: String {
    return "\(self.location): \(self.kind)"
  }
}

public struct SourceLocation: Equatable, CustomStringConvertible {

  public static var start: SourceLocation {
    return SourceLocation(line: 1, column: 0)
  }

  public var line: Int
  public var column: Int

  public mutating func advanceLine() {
    self.line += 1
    self.column = 0
  }

  public mutating func advanceColumn() {
    self.column += 1
  }

  public var description: String {
    let columnPrefix = self.column < 10 ? "0" : ""
    return "\(self.line):\(columnPrefix)\(self.column)"
  }
}
