// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

// swiftlint:disable function_body_length
// swiftlint:disable cyclomatic_complexity

extension Lexer {

  public mutating func getToken() throws -> Token {
    while true {

      if self.isAtBeginOfLine {
        self.isAtBeginOfLine = false

        if self.nesting == 0 {
          try self.calculateIndent()
        }
      }

      if let indentToken = self.indents.pendingTokens.popLast() {
        return indentToken
      }

      guard let peek = self.peek else {
        return self.token(.eof)
      }

      let start = self.location
      switch peek {
      case let c where self.isIdentifierStart(c):
        return try self.identifierOrString()
      case let c where self.isDecimalDigit(c):
        return try self.number()
      case "#":
        fatalError()
      case "'", "\"":
        return try self.string()

      // MARK: Basic operators

      case "=":
        self.advance() // =
        return self.advanceIf("=") ?
          self.token(.equalEqual, start: start) :
          self.token(.equal, start: start)
      case "+":
        self.advance() // +
        return self.advanceIf("=") ?
          self.token(.plusEqual, start: start) :
          self.token(.plus, start: start)
      case "-":
        self.advance() // -
        if self.advanceIf("=") {
          return self.token(.minusEqual, start: start)
        }
        if self.advanceIf(">") {
          return self.token(.rightArrow, start: start)
        }
        return self.token(.minus, start: start)
      case "*":
        self.advance() // *
        if self.advanceIf("=") {
          return self.token(.starEqual, start: start)
        }
        if self.advanceIf("*") {
          return self.advanceIf("=") ?
            self.token(.starStarEqual, start: start) :
            self.token(.starStar, start: start)
        }
        return self.token(.star, start: start)
      case "/":
        self.advance() // '/'
        if self.advanceIf("=") {
          return self.token(.slashEqual, start: start)
        }
        if self.advanceIf("/") {
          return self.advanceIf("=") ?
            self.token(.slashSlashEqual, start: start) :
            self.token(.slashSlash, start: start)
        }
        return self.token(.slash, start: start)
      case "%":
        self.advance() // %
        return self.advanceIf("=") ?
          self.token(.percentEqual, start: start) :
          self.token(.percent, start: start)

      // MARK: Other operators

      case "|":
        self.advance() // |
        return self.advanceIf("=") ?
          self.token(.vbarEqual, start: start) :
          self.token(.vbar, start: start)
      case "^":
        self.advance() // ^
        return self.advanceIf("=") ?
          self.token(.circumflexEqual, start: start) :
          self.token(.circumflex, start: start)
      case "&":
        self.advance() // &
        return self.advanceIf("=") ?
          self.token(.amperEqual, start: start) :
          self.token(.amper, start: start)
      case "@":
        self.advance() // @
        return self.advanceIf("=") ?
          self.token(.atEqual, start: start) :
          self.token(.at, start: start)
      case "!":
        self.advance() // !
        if self.advanceIf("=") {
          return self.token(.notEqual, start: start)
        }
        fatalError() // there is no standalone '!'
      case "~":
        self.advance() // ~
        return self.token(.tilde, start: start)

        // MARK: Parens

      case "(":
        self.advance() // (
        self.nesting += 1
        return self.token(.leftParen, start: start)
      case "[":
        self.advance() // [
        self.nesting += 1
        return self.token(.leftSqb, start: start)
      case "{":
        self.advance() // {
        self.nesting += 1
        return self.token(.leftBrace, start: start)
      case ")":
        self.advance() // )
        self.nesting = max(self.nesting - 1, 0) // <0 incorrect, but by grammar
        return self.token(.rightParen, start: start)
      case "]":
        self.advance() // ]
        self.nesting = max(self.nesting - 1, 0) // <0 incorrect, but by grammar
        return self.token(.rightSqb, start: start)
      case "}":
        self.advance() // }
        self.nesting = max(self.nesting - 1, 0) // <0 incorrect, but by grammar
        return self.token(.rightBrace, start: start)

      // MARK: Other

      case ".":
        if let next = self.peekNext, self.isDecimalDigit(next) {
          return try self.number()
        }

        self.advance() // .
        if self.peek == "." && self.peekNext == "." {
          self.advance() // .
          self.advance() // .
          return self.token(.ellipsis, start: start)
        }
        return self.token(.dot, start: start)

      case ":":
        self.advance() // :
        return self.advanceIf("=") ?
          self.token(.colonEqual, start: start) :
          self.token(.colon, start: start)
      case ";":
        self.advance() // ;
        return self.token(.semicolon, start: start)
      case ",":
        self.advance() // ,
        return self.token(.comma, start: start)

      // MARK: Greater, less

      case ">":
        self.advance() // >
        if self.advanceIf("=") {
          return self.token(.greaterEqual, start: start)
        }
        if self.advanceIf(">") {
          return self.advanceIf("=") ?
            self.token(.rightShiftEqual, start: start) :
            self.token(.rightShift, start: start)
        }
        return self.token(.greater, start: start)
      case "<":
        self.advance() // <
        if self.advanceIf("=") {
          return self.token(.lessEqual, start: start)
        }
        if self.advanceIf("<") {
          return self.advanceIf("=") ?
            self.token(.leftShiftEqual, start: start) :
            self.token(.leftShift, start: start)
        }
        return self.token(.less, start: start)

      // MARK: Whitespace

      case "\n", "\r":
        // self.advance() takes care of '\r' and '\r\n' mess
        self.advance() // \n

        if self.nesting == 0 {
          self.isAtBeginOfLine = true

          // 'self.advance' moved us to new line
          let endColumn = start.column + 1
          let end = SourceLocation(line: start.line, column: endColumn)
          return self.token(.newline, start: start, end: end)
        }
        // just consume it, nothing else

      case " ", "\t":
        self.advance() // just consume it, nothing else

      default:
        fatalError()
      }
    }
  }
}
