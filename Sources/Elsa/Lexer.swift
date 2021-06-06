import Foundation

private let keywords: [String: Token.Kind] = [
  "alias": .alias,
  "enum": .enum,
  "indirectEnum": .indirect,
  "struct": .struct,
  "class": .class,
  "final": .final,
  "underscoreInit": .underscoreInit
]

private let operators: [Character: Token.Kind] = [
  "=": .equal,
  "|": .or,
  "*": .star,
  "+": .plus,
  "?": .option,
  ",": .comma,
  ":": .colon,
  "(": .leftParen,
  ")": .rightParen
]

// It should not contain any of the operators!
// (see operators above)
private func isValidNameCharacter(_ c: Character) -> Bool {
  return ("0" <= c && c <= "9")
      || ("a" <= c && c <= "z")
      || ("A" <= c && c <= "Z")
      || c == "_"
      // Format: 'type to nest it inside [.] type name'.
      // For example:
      // 'Instruction.StringConversion' will generate:
      // extension Instruction { enum StringConversion { … } }
      || c == "."
}

// MARK: - Lexer

/// String -> stream of `Tokens`
class Lexer {

  private var source: String
  private var sourceIndex: String.Index
  private var location = SourceLocation.start

  init(source: String) {
    self.source = source
    self.sourceIndex = source.startIndex
  }

  // MARK: - Traversal

  /// Next character.
  private var peek: Character? {
    return self.isAtEnd ? nil : self.source[self.sourceIndex]
  }

  /// Character after `self.peek`.
  private var peekNext: Character? {
    if self.isAtEnd {
      return nil
    }

    var index = self.sourceIndex
    self.source.formIndex(after: &index)
    return index == self.source.endIndex ? nil : self.source[index]
  }

  /// Did we read the whole `self.source`?
  private var isAtEnd: Bool {
    return self.sourceIndex == self.source.endIndex
  }

  /// Go to the next character.
  private func advance() {
    guard !self.isAtEnd else {
      return
    }

    let consumed = self.peek
    self.source.formIndex(after: &self.sourceIndex)

    let isNewline = consumed?.isNewline ?? false
    if isNewline {
      self.location.advanceLine()
    } else {
      self.location.advanceColumn()
    }
  }

  // MARK: - Get token

  /// Get next token.
  func getToken() -> Token {
    // swiftlint:disable:previous function_body_length

    while true {
      guard let peek = self.peek else {
        return Token(.eof, location: self.location)
      }

      let start = self.location

      switch peek {
      // Consume all whitespaces
      case let c where c.isWhitespace:
        while let p = self.peek, p.isWhitespace {
          self.advance()
        }

      // Elsa keyword
      case "@":
        self.advance() // @
        let name = self.getName()
        guard let keyword = keywords[name] else {
          self.fail("Invalid keyword '@\(name)'.", location: start)
        }
        return Token(keyword, location: start)

      // Elsa comment
      case "{":
        if self.peekNext == "-" {
          self.advance() // {
          self.advance() // -
          self.consumeComment() // consume, but do not produce token
        } else {
          self.fail("Character '{' is only permitted as part of the comment '{-'.")
        }

      // Swift doc
      case "-":
        if self.peekNext == "-" {
          self.advance() // -
          self.advance() // -
          let value = self.getDoc()
          return Token(.doc(value), location: start)
        } else {
          self.fail("Character '-' is only permitted as part of the documentation '--'.")
        }

      case let c where isValidNameCharacter(c):
        let name = self.getName()
        return Token(.name(name), location: start)

      default:
        if let op = operators[peek] {
          self.advance() // op
          return Token(op, location: start)
        }

        self.fail("Unexpected character '\(peek)'.")
      }
    }
  }

  private func consumeComment() {
    func isCommentEnd() -> Bool {
      return self.peek == "-" && self.peekNext == "}"
    }

    let start = self.location
    while !isCommentEnd() {
      self.advance()

      if self.peek == nil {
        self.fail("Unclosed comment starting at: \(start).")
      }
    }

    self.advance() // -
    self.advance() // }
  }

  private func getDoc() -> String {
    // consume space after '--' (but only 1)
    if let peek = self.peek, peek == " " {
      self.advance()
    }

    let start = self.sourceIndex
    while let peek = self.peek, !peek.isNewline {
      self.advance()
    }

    return String(self.source[start..<self.sourceIndex])
  }

  private func getName() -> String {
    let startIndex = self.sourceIndex

    while let peek = self.peek, isValidNameCharacter(peek) {
      self.advance()
    }

    return String(self.source[startIndex..<self.sourceIndex])
  }

  /// Unrecoverable error.
  private func fail(_ message: String, location: SourceLocation? = nil) -> Never {
    trap("\(location ?? self.location):\(message)")
  }

  /// Print all tokens up to eof (useful for debugging).
  func dumpTokens() {
    while true {
      let token = self.getToken()
      print(token)

      if token.kind == .eof {
        return
      }
    }
  }
}
