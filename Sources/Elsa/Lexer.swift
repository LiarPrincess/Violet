import Foundation

private let keywords: [String:TokenKind] = [
  "alias":    .alias,
  "enum":     .enum,
  "indirect": .indirect,
  "struct":   .struct,
  "underscoreInit": .underscoreInit
]

private let operators: [Character: TokenKind] = [
  "=": .equal,
  "|": .or,
  "*": .star,
  "+": .plus,
  "?": .option,
  ",": .comma,
  "(": .leftParen,
  ")": .rightParen
]

// It should not contain any of the operators!
private func isValidNameCharacter(_ c: Character) -> Bool {
  return ("0" <= c && c <= "9")
      || ("a" <= c && c <= "z")
      || ("A" <= c && c <= "Z")
      || c == "_"
}

// MARK: - Lexer

public struct Lexer {

  private var source: String
  private var sourceIndex: String.Index
  private var location = SourceLocation.start

  public init(source: String) {
    self.source = source
    self.sourceIndex = source.startIndex
  }

  // MARK: - Traversal

  private var peek: Character? {
    let atEnd = self.sourceIndex == self.source.endIndex
    return atEnd ? nil : self.source[self.sourceIndex]
  }

  private var peekNext: Character? {
    let end = self.source.endIndex
    let index = self.source.index(self.sourceIndex, offsetBy: 1, limitedBy: end)
    return index.flatMap { $0 == end ? nil : self.source[$0] }
  }

  private mutating func advance() {
    guard self.sourceIndex < self.source.endIndex else {
      return
    }

    let consumed = self.peek
    self.source.formIndex(after: &self.sourceIndex)

    if consumed?.isNewline ?? false {
      self.location.advanceLine()
    } else {
      self.location.advanceColumn()
    }
  }

  // MARK: - Get token

  // swiftlint:disable:next function_body_length cyclomatic_complexity
  public mutating func getToken() -> Token {
    while true {
      guard let peek = self.peek else {
        return Token(.eof, location: self.location)
      }

      let start = self.location

      switch peek {
      case let c where c.isWhitespace:
        while let p = self.peek, p.isWhitespace {
          self.advance() // consume all whitespaces
        }

      case "@":
        self.advance() // @
        let name = self.getName()
        guard let keyword = keywords[name] else {
          self.fail("Invalid keyword '@\(name)'.", location: start)
        }
        return Token(keyword, location: start)

      case "{":
        if self.peekNext == "-" {
          self.advance() // {
          self.advance() // -
          self.consumeComment() // consume, but do not produce token
        } else {
          self.fail("Character '{' is only permitted as part of the comment '{-'.")
        }

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

  private mutating func consumeComment() {
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

  private mutating func getDoc() -> String {
    while let peek = self.peek, peek.isWhitespace {
      self.advance()
    }

    let start = self.sourceIndex
    while let peek = self.peek, !peek.isNewline {
      self.advance()
    }

    return String(self.source[start..<self.sourceIndex])
  }

  private mutating func getName() -> String {
    let startIndex = self.sourceIndex

    while let peek = self.peek, isValidNameCharacter(peek) {
      self.advance()
    }

    return String(self.source[startIndex..<self.sourceIndex])
  }

  private func fail(_ message: String, location: SourceLocation? = nil) -> Never {
    print("\(location ?? self.location):\(message)")
    exit(EXIT_FAILURE)
  }

  /// Print all tokens up to eof.
  public mutating func dumpTokens() {
    while true {
      let token = self.getToken()
      print(token)

      if token.kind == .eof {
        return
      }
    }
  }
}
