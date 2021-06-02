import Foundation
import BigInt
import VioletCore

// Based on 'Grammar/Tokens' from CPython.

/// Single 'word' in a source code.
public struct Token: Equatable, CustomStringConvertible {

  /// Type of the token.
  public let kind: Kind

  /// Location of the first character in the source code.
  /// Should be roughly equal to the one you would get from CPython.
  public let start: SourceLocation

  /// Location just after the last character in the source code.
  /// Should be roughly equal to the one you would get from CPython.
  public let end: SourceLocation

  public var description: String {
    return "\(self.start)-\(self.end): \(self.kind)"
  }

  public init(_ kind: Kind, start: SourceLocation, end: SourceLocation) {
    self.kind = kind
    self.start = start
    self.end = end
  }

  // MARK: - Kind

  public enum Kind: Equatable, Hashable, CustomStringConvertible {

    case eof

    case identifier(String)
    case string(String)
    case formatString(String)

    case int(BigInt)
    case float(Double)
    case imaginary(Double)

    case bytes(Data)

    case indent
    case dedent
    case newLine
    case comment(String)

    /** ( */ case leftParen
    /** [ */ case leftSqb
    /** { */ case leftBrace
    /** ) */ case rightParen
    /** ] */ case rightSqb
    /** } */ case rightBrace

    /** : */ case colon
    /** , */ case comma
    /** ; */ case semicolon
    /** ... */ case ellipsis

    /** \+ */ case plus
    /** \- */ case minus
    /** \* */ case star
    /** / */ case slash
    /** | */ case vbar
    /** & */ case amper
    /** ^ */ case circumflex
    /** @ */ case at

    /** += */ case plusEqual
    /** -= */ case minusEqual
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

    /** . */ case dot
    /** % */ case percent
    /** ~ */ case tilde
    /** -> */ case rightArrow
    /** := */ case colonEqual

    // https://docs.python.org/3/reference/lexical_analysis.html#keywords

    /** `None` keyword */ case none
    /** `False` keyword */ case `false`
    /** `True` keyword */ case `true`

    /** `and` keyword */ case and
    /** `as` keyword */ case `as`
    /** `assert` keyword */ case assert
    /** `async` keyword */ case async
    /** `await` keyword */ case await
    /** `break` keyword */ case `break`
    /** `class` keyword */ case `class`
    /** `continue` keyword */ case `continue`
    /** `def` keyword */ case def
    /** `del` keyword */ case del
    /** `elif` keyword */ case elif
    /** `else` keyword */ case `else`
    /** `except` keyword */ case except
    /** `finally` keyword */ case finally
    /** `for` keyword */ case `for`
    /** `from` keyword */ case from
    /** `global` keyword */ case global
    /** `if` keyword */ case `if`
    /** `import` keyword */ case `import`
    /** `in` keyword */ case `in`
    /** `is` keyword */ case `is`
    /** `lambda` keyword */ case lambda
    /** `nonlocal` keyword */ case nonlocal
    /** `not` keyword */ case not
    /** `or` keyword */ case or
    /** `pass` keyword */ case pass
    /** `raise` keyword */ case raise
    /** `return` keyword */ case `return`
    /** `try` keyword */ case `try`
    /** `while` keyword */ case `while`
    /** `with` keyword */ case with
    /** `yield` keyword */ case yield

    public var description: String {
      switch self {
      case .eof: return "eof"

      case let .identifier(val): return "identifier (value: '\(val)')"
      case let .string(val): return "string (value: '\(val)')"
      case let .formatString(val): return "format string (value: '\(val)'):"

      case let .int(val): return "int (value: \(val))"
      case let .float(val): return "float (value: \(val))"
      case let .imaginary(val): return "imaginary (value: \(val))"

      case let .bytes(val): return "bytes (value: \(val))"

      case .indent: return "indent"
      case .dedent: return "dedent"
      case .newLine: return "new line"
      case .comment(let s): return "comment (value: '\(s)')"

      case .leftParen: return "("
      case .leftSqb: return "["
      case .leftBrace: return "{"
      case .rightParen: return ")"
      case .rightSqb: return "]"
      case .rightBrace: return "}"

      case .colon: return ":"
      case .comma: return ","
      case .semicolon: return ";"
      case .ellipsis: return "..."

      case .plus: return "+"
      case .minus: return "-"
      case .star: return "*"
      case .slash: return "/"
      case .vbar: return "|"
      case .amper: return "&"
      case .circumflex: return "^"
      case .at: return "@"

      case .plusEqual: return "+="
      case .minusEqual: return "-="
      case .starEqual: return "*="
      case .slashEqual: return "/="
      case .percentEqual: return "%="
      case .vbarEqual: return "|="
      case .amperEqual: return "&="
      case .circumflexEqual: return "^="
      case .atEqual: return "@="

      case .less: return "<"
      case .greater: return ">"
      case .equal: return "="

      case .equalEqual: return "=="
      case .notEqual: return "!="
      case .lessEqual: return "<="
      case .greaterEqual: return ">="

      case .leftShift: return "<<"
      case .rightShift: return ">>"
      case .starStar: return "**"
      case .slashSlash: return "//"
      case .leftShiftEqual: return "<<="
      case .rightShiftEqual: return ">>="
      case .starStarEqual: return "**="
      case .slashSlashEqual: return "//="

      case .dot: return "."
      case .percent: return "%"
      case .tilde: return "~"
      case .rightArrow: return "->"
      case .colonEqual: return ":="

      case .none: return "None"
      case .false: return "False"
      case .true: return "True"

      case .and: return "and"
      case .as: return "as"
      case .assert: return "assert"
      case .async: return "async"
      case .await: return "await"
      case .break: return "break"
      case .class: return "class"
      case .continue: return "continue"
      case .def: return "def"
      case .del: return "del"
      case .elif: return "elif"
      case .else: return "else"
      case .except: return "except"
      case .finally: return "finally"
      case .for: return "for"
      case .from: return "from"
      case .global: return "global"
      case .if: return "if"
      case .import: return "import"
      case .in: return "in"
      case .is: return "is"
      case .lambda: return "lambda"
      case .nonlocal: return "nonlocal"
      case .not: return "not"
      case .or: return "or"
      case .pass: return "pass"
      case .raise: return "raise"
      case .return: return "return"
      case .try: return "try"
      case .while: return "while"
      case .with: return "with"
      case .yield: return "yield"
      }
    }
  }
}
