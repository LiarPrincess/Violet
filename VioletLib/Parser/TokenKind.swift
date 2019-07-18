// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

// TODO: Move PyInt to AST
public typealias PyInt = Int64

// Based on 'Grammar/Tokens' from CPython. Changes:
// 1. Associated values instead of pointers inside buf.
// 2. Lifted keywords to token level (as in slit, lox and many others).

public enum TokenKind {

  case eof

  case name(String)
  case int(PyInt)
  case float(Double)
  case complex(real: Double, imag: Double)
  case string(String)
  case formatString(String)
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

  /** : */ case colon
  /** , */ case comma
  /** ; */ case semicolon

  /** \+ */ case plus
  /** \- */ case minus
  /** \* */ case star
  /** / */ case slash
  /** | */ case vbar
  /** & */ case amper
  /** ^ */ case circumflex
  /** @ */ case at

  /** += */ case plusEqual
  /** -= */ case minEqual
  /** *= */ case starEqual
  /** /= */ case slashEqual
  /** %= */ case percentEqual
  /** |= */ case vbarEqual
  /** &= */ case amperEqual
  /** ^= */ case circumflexEqual
  /** @= */ case atEqual

  /** < */ case less
  /** \> */ case greater
  /** = */ case equal

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

  /** 'and' keyword */      case and
  /** 'as' keyword */       case `as`
  /** 'assert' keyword */   case assert
  /** 'async' keyword */    case async
  /** 'await' keyword */    case await
  /** 'break' keyword */    case `break`
  /** 'class' keyword */    case `class`
  /** 'continue' keyword */ case `continue`
  /** 'def' keyword */      case def
  /** 'del' keyword */      case del
  /** 'elif' keyword */     case elif
  /** ... keyword */        case ellipsis
  /** 'else' keyword */     case `else`
  /** 'except' keyword */   case except
  /** 'false' keyword */    case `false`
  /** 'finally' keyword */  case finally
  /** 'for' keyword */      case `for`
  /** 'from' keyword */     case from
  /** 'global' keyword */   case global
  /** 'if' keyword */       case `if`
  /** 'import' keyword */   case `import`
  /** 'in' keyword */       case `in`
  /** 'is' keyword */       case `is`
  /** 'lambda' keyword */   case lambda
  /** 'none' keyword */     case none
  /** 'nonlocal' keyword */ case nonlocal
  /** 'not' keyword */      case not
  /** 'or' keyword */       case or
  /** 'pass' keyword */     case pass
  /** 'raise' keyword */    case raise
  /** 'return' keyword */   case `return`
  /** 'true' keyword */     case `true`
  /** 'try' keyword */      case `try`
  /** 'while' keyword */    case `while`
  /** 'with' keyword */     case with
  /** 'yield' keyword */    case yield
}

extension TokenKind: CustomStringConvertible {
  public var description: String {
    switch self {
    case .eof: return "eof"

    case let .name(val):  return "name(\(val))"
    case let .int(val):   return "int(\(val))"
    case let .float(val): return "float(\(val))"
    case let .complex(real, imag): return "complex(\(real) + \(imag)j)"
    case let .string(val):         return "string(\(val))"
    case let .formatString(val):   return "formatString(\(val)):"
    case let .bytes(val):  return "data(\(val))"

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

    case .and:      return "and"
    case .as:       return "as"
    case .assert:   return "assert"
    case .async:    return "async"
    case .await:    return "await"
    case .break:    return "break"
    case .class:    return "class"
    case .continue: return "continue"
    case .def:      return "def"
    case .del:      return "del"
    case .elif:     return "elif"
    case .ellipsis: return "..."
    case .else:     return "else"
    case .except:   return "except"
    case .false:    return "false"
    case .finally:  return "finally"
    case .for:      return "for"
    case .from:     return "from"
    case .global:   return "global"
    case .if:       return "if"
    case .import:   return "import"
    case .in:       return "in"
    case .is:       return "is"
    case .lambda:   return "lambda"
    case .none:     return "none"
    case .nonlocal: return "nonlocal"
    case .not:      return "not"
    case .or:       return "or"
    case .pass:     return "pass"
    case .raise:    return "raise"
    case .return:   return "return"
    case .true:     return "true"
    case .try:      return "try"
    case .while:    return "while"
    case .with:     return "with"
    case .yield:    return "yield"
    }
  }
}
