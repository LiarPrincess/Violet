// swiftlint:disable function_body_length
// swiftlint:disable cyclomatic_complexity

extension Lexer {

  public mutating func getToken() throws -> Token {
    while true {
      if self.isAtBeginOfLine {
        self.isAtBeginOfLine = false

        let isTupleArrayDict = self.nesting > 0
        if !isTupleArrayDict {
          try self.calculateIndent()
        }
      }

      if let indentToken = self.indents.pendingTokens.popLast() {
        return indentToken
      }

      let start = self.location

      guard let peek = self.peek else {
        return self.token(.eof, start: start, end: start.next)
      }

      switch peek {

      // MARK: Whitespace

      case let c where self.isNewLine(c):
        self.advance() // CR, LF, CRLF

        if self.nesting == 0 {
          self.isAtBeginOfLine = true

          // 'self.advance' moved us to new line, so we can't use current location
          return self.token(.newLine, start: start, end: start.next)
        }
        // just consume it, nothing else

      case " ", "\t":
        // just consume it, nothing else
        // we don't collect trivia

        repeat {
          self.advance()
        } while self.peek == " " || self.peek == "\t"

      // MARK: Main

      case let c where self.isIdentifierStart(c):
        return try self.identifierOrString()
      case let c where self.isDecimalDigit(c):
        return try self.number()
      case "#":
        return try self.comment()
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
        // there is no standalone '!'
        try self.throwUnexpectedCharacter(peek)
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

      default:
        try self.throwUnexpectedCharacter(peek)
      }
    }
  }

  private func throwUnexpectedCharacter(_ c: UnicodeScalar) throws {
    let kind = LexerErrorKind.unexpectedCharacter(c)
    throw self.error(kind)
  }
}
