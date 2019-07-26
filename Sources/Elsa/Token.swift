// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

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

public enum TokenKind: Equatable, CustomStringConvertible {
  case alias
  case `enum`
  case indirect
  case `struct`
  case doc
  case str
  case name(String)
  case string(String)

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
    case .alias: return "alias"
    case .enum: return "enum"
    case .indirect: return "indirect enum"
    case .struct: return "struct"
    case .doc: return "doc"
    case .str: return "str"
    case .name(let value): return "name(\(value))"
    case .string: return "string(...)"
    case .equal: return "equal"
    case .or: return "or"
    case .star: return "star"
    case .option: return "option"
    case .comma: return "comma"
    case .leftParen: return "left paren"
    case .rightParen: return "right paren"
    case .eof: return "eof"
    }
  }
}
