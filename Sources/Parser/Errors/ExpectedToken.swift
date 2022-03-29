import VioletLexer

// Really regretting that we don't have proper union types in Swift
// (but not really sure how would that work).
// We can also use `case token(Token.Kind)`, but in most common use case
// we know which token we expected and now we have to wrap it in .token(X)
// which is not very ergonomic.
public enum ExpectedToken {

  case expression
  case slice

  case eof

  case identifier
  case string

  case int
  case float
  case imaginary

  case bytes

  case indent
  case dedent
  case newLine
  case comment

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
}

extension ExpectedToken: CustomStringConvertible {
  public var description: String {
    switch self {

    case .expression: return "expression"
    case .slice: return "slice"

    case .eof: return "eof"

    case .identifier: return "identifier"
    case .string: return "string"

    case .int: return "int"
    case .float: return "float"
    case .imaginary: return "imaginary"

    case .bytes: return "bytes"

    case .indent: return "indent"
    case .dedent: return "dedent"
    case .newLine: return "new line"
    case .comment: return "comment"

    case .leftParen: return "'('"
    case .leftSqb: return "'['"
    case .leftBrace: return "'{'"
    case .rightParen: return "')'"
    case .rightSqb: return "']'"
    case .rightBrace: return "'}'"

    case .colon: return "':'"
    case .comma: return "','"
    case .semicolon: return "';'"
    case .ellipsis: return "'...'"

    case .plus: return "'+'"
    case .minus: return "'-'"
    case .star: return "'*'"
    case .slash: return "'/'"
    case .vbar: return "'|'"
    case .amper: return "'&'"
    case .circumflex: return "'^'"
    case .at: return "'@'"

    case .plusEqual: return "'+='"
    case .minusEqual: return "'-='"
    case .starEqual: return "'*='"
    case .slashEqual: return "'/='"
    case .percentEqual: return "'%='"
    case .vbarEqual: return "'|='"
    case .amperEqual: return "'&='"
    case .circumflexEqual: return "'^='"
    case .atEqual: return "'@='"

    case .less: return "'<'"
    case .greater: return "'>'"
    case .equal: return "'='"

    case .equalEqual: return "'=='"
    case .notEqual: return "'!='"
    case .lessEqual: return "'<='"
    case .greaterEqual: return "'>='"

    case .leftShift: return "'<<'"
    case .rightShift: return "'>>'"
    case .starStar: return "'**'"
    case .slashSlash: return "'//'"
    case .leftShiftEqual: return "'<<='"
    case .rightShiftEqual: return "'>>='"
    case .starStarEqual: return "'**='"
    case .slashSlashEqual: return "'//='"

    case .dot: return "'.'"
    case .percent: return "'%'"
    case .tilde: return "'~'"
    case .rightArrow: return "'->'"
    case .colonEqual: return "':='"

    case .none: return "'None'"
    case .false: return "'False'"
    case .true: return "'True'"

    case .and: return "'and'"
    case .as: return "'as'"
    case .assert: return "'assert'"
    case .async: return "'async'"
    case .await: return "'await'"
    case .break: return "'break'"
    case .class: return "'class'"
    case .continue: return "'continue'"
    case .def: return "'def'"
    case .del: return "'del'"
    case .elif: return "'elif'"
    case .else: return "'else'"
    case .except: return "'except'"
    case .finally: return "'finally'"
    case .for: return "'for'"
    case .from: return "'from'"
    case .global: return "'global'"
    case .if: return "'if'"
    case .import: return "'import'"
    case .in: return "'in'"
    case .is: return "'is'"
    case .lambda: return "'lambda'"
    case .nonlocal: return "'nonlocal'"
    case .not: return "'not'"
    case .or: return "'or'"
    case .pass: return "'pass'"
    case .raise: return "'raise'"
    case .return: return "'return'"
    case .try: return "'try'"
    case .while: return "'while'"
    case .with: return "'with'"
    case .yield: return "'yield'"
    }
  }
}

extension Token.Kind {
  public var expected: ExpectedToken {
    switch self {
    case .eof: return .eof

    case .identifier: return .identifier
    case .string: return .string
    case .formatString: return .string
    case .int: return .int
    case .float: return .float
    case .imaginary: return .imaginary
    case .bytes: return .bytes

    case .indent: return .indent
    case .dedent: return .dedent
    case .newLine: return .newLine
    case .comment: return .comment

    case .leftParen: return .leftParen
    case .leftSqb: return .leftSqb
    case .leftBrace: return .leftBrace
    case .rightParen: return .rightParen
    case .rightSqb: return .rightSqb
    case .rightBrace: return .rightBrace

    case .colon: return .colon
    case .comma: return .comma
    case .semicolon: return .semicolon
    case .ellipsis: return .ellipsis

    case .plus: return .plus
    case .minus: return .minus
    case .star: return .star
    case .slash: return .slash
    case .vbar: return .vbar
    case .amper: return .amper
    case .circumflex: return .circumflex
    case .at: return .at

    case .plusEqual: return .plusEqual
    case .minusEqual: return .minusEqual
    case .starEqual: return .starEqual
    case .slashEqual: return .slashEqual
    case .percentEqual: return .percentEqual
    case .vbarEqual: return .vbarEqual
    case .amperEqual: return .amperEqual
    case .circumflexEqual: return .circumflexEqual
    case .atEqual: return .atEqual

    case .less: return .less
    case .greater: return .greater
    case .equal: return .equal

    case .equalEqual: return .equalEqual
    case .notEqual: return .notEqual
    case .lessEqual: return .lessEqual
    case .greaterEqual: return .greaterEqual

    case .leftShift: return .leftShift
    case .rightShift: return .rightShift
    case .starStar: return .starStar
    case .slashSlash: return .slashSlash

    case .leftShiftEqual: return .leftShiftEqual
    case .rightShiftEqual: return .rightShiftEqual
    case .starStarEqual: return .starStarEqual
    case .slashSlashEqual: return .slashSlashEqual

    case .dot: return .dot
    case .percent: return .percent
    case .tilde: return .tilde
    case .rightArrow: return .rightArrow
    case .colonEqual: return .colonEqual

    case .none: return .none
    case .false: return .false
    case .true: return .true

    case .and: return .and
    case .as: return .as
    case .assert: return .assert
    case .async: return .async
    case .await: return .await
    case .break: return .break
    case .class: return .class
    case .continue: return .continue
    case .def: return .def
    case .del: return .del
    case .elif: return .elif
    case .else: return .else
    case .except: return .except
    case .finally: return .finally
    case .for: return .for
    case .from: return .from
    case .global: return .global
    case .if: return .if
    case .import: return .import
    case .in: return .in
    case .is: return .is
    case .lambda: return .lambda
    case .nonlocal: return .nonlocal
    case .not: return .not
    case .or: return .or
    case .pass: return .pass
    case .raise: return .raise
    case .return: return .return
    case .try: return .try
    case .while: return .while
    case .with: return .with
    case .yield: return .yield
    }
  }
}
