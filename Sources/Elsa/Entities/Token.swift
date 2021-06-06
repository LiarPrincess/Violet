struct Token: Equatable, CustomStringConvertible {

  let kind: Kind
  let location: SourceLocation

  init(_ kind: Kind, location: SourceLocation) {
    self.kind = kind
    self.location = location
  }

  var description: String {
    return "\(self.location): \(self.kind)"
  }

  enum Kind: Equatable, CustomStringConvertible {
    case alias
    case `enum`
    case indirect
    case `struct`
    case `class`
    case final
    case underscoreInit
    case name(String)
    case doc(String)

    case equal
    case or
    case star
    case plus
    case option
    case comma
    case colon

    case leftParen
    case rightParen

    case eof

    var description: String {
      switch self {
      case .alias: return "@alias"
      case .enum: return "@enum"
      case .indirect: return "@indirectEnum"
      case .struct: return "@struct"
      case .class: return "@class"
      case .final: return "@final"
      case .underscoreInit: return "@underscoreInit"
      case .name(let value): return value
      case .doc: return "documentation"
      case .equal: return "="
      case .or: return "|"
      case .star: return "*"
      case .plus: return "+"
      case .option: return "?"
      case .comma: return ","
      case .colon: return ":"
      case .leftParen: return "("
      case .rightParen: return ")"
      case .eof: return "eof"
      }
    }
  }
}
