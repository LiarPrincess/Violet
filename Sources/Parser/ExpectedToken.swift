public enum ExpectedToken {

  // TODO: remove
  case noIdea

  case identifier
  case string

  case int
  case float
  case imaginary

  case bytes

  case indent
  case dedent
  case newLine

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
  /** -= */ case minusEqual
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

  // https://docs.python.org/3/reference/lexical_analysis.html#keywords

  /** `None` keyword */  case none
  /** `False` keyword */ case `false`
  /** `True` keyword */  case `true`

  /** `and` keyword */      case and
  /** `as` keyword */       case `as`
  /** `assert` keyword */   case assert
  /** `async` keyword */    case async
  /** `await` keyword */    case await
  /** `break` keyword */    case `break`
  /** `class` keyword */    case `class`
  /** `continue` keyword */ case `continue`
  /** `def` keyword */      case def
  /** `del` keyword */      case del
  /** `elif` keyword */     case elif
  /** `else` keyword */     case `else`
  /** `except` keyword */   case except
  /** `finally` keyword */  case finally
  /** `for` keyword */      case `for`
  /** `from` keyword */     case from
  /** `global` keyword */   case global
  /** `if` keyword */       case `if`
  /** `import` keyword */   case `import`
  /** `in` keyword */       case `in`
  /** `is` keyword */       case `is`
  /** `lambda` keyword */   case lambda
  /** `nonlocal` keyword */ case nonlocal
  /** `not` keyword */      case not
  /** `or` keyword */       case or
  /** `pass` keyword */     case pass
  /** `raise` keyword */    case raise
  /** `return` keyword */   case `return`
  /** `try` keyword */      case `try`
  /** `while` keyword */    case `while`
  /** `with` keyword */     case with
  /** `yield` keyword */    case yield
}
