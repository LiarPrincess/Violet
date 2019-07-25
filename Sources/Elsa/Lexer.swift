// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation

internal struct Token: Equatable {
  internal let kind: TokenKind
  internal let location: SourceLocation
}

internal struct SourceLocation: Equatable, CustomStringConvertible {

  public static var start: SourceLocation {
    return SourceLocation(line: 1, column: 0)
  }

  internal private(set) var line: Int
  internal private(set) var column: Int

  fileprivate mutating func advanceLine() {
    self.line += 1
    self.column = 0
  }

  fileprivate mutating func advanceColumn() {
    self.column += 1
  }

  internal var description: String {
    return "\(self.line):\(self.column)"
  }
}

internal enum TokenKind: Equatable {
  case eof
  case name(String)

  case typedef
  case `enum`
  case `struct`
  case equal
  case or

  case star
  case option
  case leftParen
  case rightParen
}

private let keywords: [String:TokenKind] = [
  "typedef": .typedef,
  "enum":    .enum,
  "struct":  .struct,
  "=": .equal,
  "|": .or,
  "*": .star,
  "?": .option,
  "(": .leftParen,
  ")": .rightParen
]

// so we know when to finish lexing name
private let singleCharKeywords = Set<Character>([
  "=", "|", "*", "?", "(", ")"
])

internal struct Lexer {

  private var source: String
  private var sourceIndex: String.Index
  private var location = SourceLocation.start

  internal init(source: String) {
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

  // MARK: - Token creation

  internal mutating func token(_ kind:   TokenKind,
                               location: SourceLocation? = nil) -> Token {
    return Token(kind: kind, location: location ?? self.location)
  }

  // MARK: - Get token

  internal mutating func getToken() -> Token {
    while true {
      guard let peek = self.peek else {
        return self.token(.eof)
      }

      let start = self.location

      switch peek {
      case "*":
        self.advance()
        return self.token(.star, location: start)
      case "?":
        self.advance()
        return self.token(.option, location: start)
      case "(":
        self.advance()
        return self.token(.leftParen, location: start)
      case ")":
        self.advance()
        return self.token(.rightParen, location: start)
      case "-":
        if self.peekNext == "-" {
          self.comment() // consume, but do not produce token
        } else {
          self.unexpectedCharacter(peek)
        }
      case ",":
        self.advance() // skip
      case let c where singleCharKeywords.contains(c):
        self.advance()
        guard let kind = keywords[String(c)] else {
          self.unexpectedCharacter(c) // not possible?
        }
        return self.token(kind, location: start)
      case let c where c.isWhitespace:
        while let p = self.peek, p.isWhitespace {
          self.advance()
        }
      default:
        return self.keywordOrName()
      }
    }
  }

  private mutating func comment() {
    assert(self.peek == "-")
    while let peek = self.peek, !peek.isNewline {
      self.advance()
    }
  }

  private mutating func keywordOrName() -> Token {
    let startIndex = self.sourceIndex
    let startLocation = self.location

    while let peek = self.peek, self.isKeywordChar(peek) {
      self.advance()
    }

    let value = String(self.source[startIndex..<self.sourceIndex])
    let kind = keywords[value] ?? .name(value)
    return self.token(kind, location: startLocation)
  }

  private func isKeywordChar(_ c: Character) -> Bool {
    let isInvalid = c.isWhitespace || singleCharKeywords.contains(c) || c == ","
    return !isInvalid
  }

  private func unexpectedCharacter(_ c: Character) -> Never {
    print("Unexpedted character '\(c)' at \(self.location).")
    exit(1)
  }
}
