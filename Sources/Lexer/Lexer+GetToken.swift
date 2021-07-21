extension Lexer {

  // swiftlint:disable:next cyclomatic_complexity function_body_length
  public func getToken() throws -> Token {
    while true {
      if self.isAtBeginOfLine {
        self.isAtBeginOfLine = false

        // Multi-line tuple/array/dict/set declaration does not change indent
        let isTupleArrayDictEtc = self.nesting > 0
        if !isTupleArrayDictEtc {
          try self.calculateIndent()
        }
      }

      // Do we need to produce some indent/dedent tokens?
      if let indentToken = self.getPendingIndentTokens() {
        return indentToken
      }

      let start = self.location

      guard let peek = self.peek else {
        return self.getEOFDedentToken() ??
          self.token(.eof, start: start, end: start.nextColumn)
      }

      switch peek {

      // MARK: Whitespace

      case let c where self.isNewLine(c):
        self.advance() // CR, LF, CRLF

        if self.nesting == 0 {
          self.isAtBeginOfLine = true

          // 'self.advance' moved us to new line, so we can't use current location
          return self.token(.newLine, start: start, end: start.nextColumn)
        }
        // just consume it, nothing else

      case " ",
           "\t":
        // just consume it, nothing else
        // we don't collect trivia
        repeat {
          self.advance()
        } while self.isWhitespace(self.peek)

      // MARK: Main

      case let c where self.isIdentifierStart(c):
        return try self.identifierOrString()
      case let c where self.isDecimalDigit(c):
        return try self.number()
      case "#":
        return try self.comment()
      case "'",
           "\"":
        return try self.string()

      case "\\":
        // Special symbol to escape (ignore) end of the line
        // (at least this is the most common usage).
        self.advance() // '\'

        // If this the last character in file, then input is still valid
        guard let next = self.peek else {
          return self.token(.eof)
        }

        guard self.isNewLine(next) else {
          throw self.error(.missingNewLineAfterBackslashEscape)
        }

        self.advance() // new line

        while let c = self.peek, self.isWhitespace(c) {
          self.advance()
        }

        return try self.getToken()

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
    throw self.error(.unexpectedCharacter(c))
  }
}
