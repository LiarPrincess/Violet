// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

// https://docs.python.org/3/reference/lexical_analysis.html#keywords

internal let keywords: [String:Keyword] = [
  "and":      .and,
  "as":       .as,
  "assert":   .assert,
  "async":    .async,
  "await":    .await,
  "break":    .break,
  "class":    .class,
  "continue": .continue,
  "def":      .def,
  "del":      .del,
  "elif":     .elif,
  "else":     .else,
  "except":   .except,
  "false":    .false,
  "finally":  .finally,
  "for":      .for,
  "from":     .from,
  "global":   .global,
  "if":       .if,
  "import":   .import,
  "in":       .in,
  "is":       .is,
  "lambda":   .lambda,
  "none":     .none,
  "nonlocal": .nonlocal,
  "not":      .not,
  "or":       .or,
  "pass":     .pass,
  "raise":    .raise,
  "return":   .return,
  "true":     .true,
  "try":      .try,
  "while":    .while,
  "with":     .with,
  "yield":    .yield
]

public enum Keyword {

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

extension Keyword: CustomStringConvertible {
  public var description: String {
    switch self {
    case .none:  return "None"
    case .false: return "False"
    case .true:  return "True"

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
    case .else:     return "else"
    case .except:   return "except"
    case .finally:  return "finally"
    case .for:      return "for"
    case .from:     return "from"
    case .global:   return "global"
    case .if:       return "if"
    case .import:   return "import"
    case .in:       return "in"
    case .is:       return "is"
    case .lambda:   return "lambda"
    case .nonlocal: return "nonlocal"
    case .not:      return "not"
    case .or:       return "or"
    case .pass:     return "pass"
    case .raise:    return "raise"
    case .return:   return "return"
    case .try:      return "try"
    case .while:    return "while"
    case .with:     return "with"
    case .yield:    return "yield"
    }
  }
}
