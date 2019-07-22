// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation
import Core

// Based on 'Grammar/Tokens' from CPython.

public enum TokenKind: Equatable {

  case eof

  case identifier(String)
  case keyword(Keyword)

  case string(String)
  case formatString(String)

  case int(PyInt)
  case float(Double)
  case imaginary(Double)

  case bytes(Data)

  case indent
  case dedent
  case newline

  /** ( */ case leftParen
  /** [ */ case leftSqb
  /** { */ case leftBrace
  /** ) */ case rightParen
  /** ] */ case rightSqb
  /** } */ case rightBrace

  /** : */   case colon
  /** , */   case comma
  /** ; */   case semicolon
  /** ... */ case ellipsis

  /** \+ */ case plus
  /** \- */ case minus
  /** \* */ case star
  /** / */  case slash
  /** | */  case vbar
  /** & */  case amper
  /** ^ */  case circumflex
  /** @ */  case at

  /** += */ case plusEqual
  /** -= */ case minEqual
  /** *= */ case starEqual
  /** /= */ case slashEqual
  /** %= */ case percentEqual
  /** |= */ case vbarEqual
  /** &= */ case amperEqual
  /** ^= */ case circumflexEqual
  /** @= */ case atEqual

  /** < */  case less
  /** \> */ case greater
  /** = */  case equal

  /** == */ case equalEqual
  /** != */ case notEqual
  /** <= */ case lessEqual
  /** >= */ case greaterEqual

  /** << */ case leftShift
  /** >> */ case rightShift
  /** ** */ case starStar
  /** // */ case slashSlash

  /** <<= */ case leftShiftEqual
  /** >>= */ case rightShiftEqual
  /** **= */ case starStarEqual
  /** //= */ case slashSlashEqual

  /** . */   case dot
  /** % */   case percent
  /** ~ */   case tilde
  /** -> */  case rightArrow
  /** := */  case colonEqual
}

extension TokenKind: CustomStringConvertible {
  public var description: String {
    switch self {
    case .eof: return "eof"

    case let .identifier(val): return "identifier(\(val))"
    case let .keyword(val):    return "keyword(\(val))"

    case let .string(val):       return "string(\(val))"
    case let .formatString(val): return "formatString(\(val)):"

    case let .int(val):       return "int(\(val))"
    case let .float(val):     return "float(\(val))"
    case let .imaginary(val): return "imaginary(\(val))"

    case let .bytes(val): return "data(\(val))"

    case .indent:  return "indent"
    case .dedent:  return "dedent"
    case .newline: return "newline"

    case .leftParen:  return "("
    case .leftSqb:    return "["
    case .leftBrace:  return "{"
    case .rightParen: return ")"
    case .rightSqb:   return "]"
    case .rightBrace: return "}"

    case .colon:     return ":"
    case .comma:     return ","
    case .semicolon: return ";"
    case .ellipsis:  return "..."

    case .plus:       return "+"
    case .minus:      return "-"
    case .star:       return "*"
    case .slash:      return "/"
    case .vbar:       return "|"
    case .amper:      return "&"
    case .circumflex: return "^"
    case .at:         return "@"

    case .plusEqual:       return "+="
    case .minEqual:        return "-="
    case .starEqual:       return "*="
    case .slashEqual:      return "/="
    case .percentEqual:    return "%="
    case .vbarEqual:       return "|="
    case .amperEqual:      return "&="
    case .circumflexEqual: return "^="
    case .atEqual:         return "@="

    case .less:    return "<"
    case .greater: return ">"
    case .equal:   return "="

    case .equalEqual:   return "=="
    case .notEqual:     return "!="
    case .lessEqual:    return "<="
    case .greaterEqual: return ">="

    case .leftShift:       return "<<"
    case .rightShift:      return ">>"
    case .starStar:        return "**"
    case .slashSlash:      return "//"
    case .leftShiftEqual:  return "<<="
    case .rightShiftEqual: return ">>="
    case .starStarEqual:   return "**="
    case .slashSlashEqual: return "//="

    case .dot:        return "."
    case .percent:    return "%"
    case .tilde:      return "~"
    case .rightArrow: return "->"
    case .colonEqual: return ":="
    }
  }
}
