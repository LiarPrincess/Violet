// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation

public struct Lexer {

  /// Name of the input source.
  public let filename: String

  /// Text input to lex.
  internal var source: String

  /// Current position in `self.source`
  internal var sourceIndex: String.Index

  /// Is at begin of new line?
  internal var isAtBeginOfLine = true

  /// Stack of parentheses: () [] {}.
  internal var parenStack = [TokenKind]()

  /// Stack of indents.
  internal var indents = IndentState()

  /// Where are we in the source file?
  internal var location = SourceLocation.start

  /// Used for REPL.
  public init(stdin: String) {
    self.init(filename: "<stdin>", source: stdin)
  }

  /// Used for 'eval/exec'.
  public init(string: String) {
    self.init(filename: "<string>", source: string)
  }

  /// Used when we have an actual file.
  public init(filename: String, source: String) {
    self.filename = filename
    self.source = source
    self.sourceIndex = source.startIndex
  }

  // MARK: - Traversal

  /// Current character. Use `self.advance` to consume.
  internal var peek: Character? {
    let atEnd = self.sourceIndex == self.source.endIndex
    return atEnd ? nil : self.source[self.sourceIndex]
  }

  /// Character after `self.peek`.
  internal var peekNext: Character? {
    let end = self.source.endIndex
    let index = self.source.index(self.sourceIndex, offsetBy: 1, limitedBy: end)

    let atEnd = index == nil || index == end
    return atEnd ? nil : self.source[index!]
  }

  /// Consumes current character.
  @discardableResult
  internal mutating func advance() -> Character? {
    guard self.sourceIndex < self.source.endIndex else {
      return nil
    }

    let consumed = self.peek
    self.source.formIndex(after: &self.sourceIndex)

    if consumed == "\n" || consumed == "\r" {
      self.location.advanceLine()

      // if we have "\r\n" then consume '\n' as well
      if self.peek == "\n" {
        self.source.formIndex(after: &self.sourceIndex)
      }
    } else {
      self.location.advanceColumn()
    }

    return self.peek
  }

  // MARK: - Token creation

  /// Warnings to be attached to the next token
  private var warnings: LexerWarning = []

  /// Create token
  internal mutating func token(_ kind: TokenKind,
                               start:  SourceLocation? = nil,
                               end:    SourceLocation? = nil) -> Token {
    let s = start ?? self.location
    let e = end ?? self.location
    let token = Token(kind, warnings: self.warnings, start: s, end: e)
    self.warnings = []
    return token
  }

  /// Attach warning to next token
  internal mutating func warning(_ warning: LexerWarning) {
    self.warnings.insert(warning)
  }

  /// Create lexer error
  internal func error(_ kind: LexerErrorKind,
                      start:  SourceLocation? = nil,
                      end:    SourceLocation? = nil) -> LexerError {
    let s = start ?? self.location
    let e = end ?? self.location
    return LexerError(kind, start: s, end: e)
  }

  // MARK: - Lexing

  public mutating func getToken() -> Token? {
//    if self.isAtBeginOfLine {
//      self.calculateIndent()
//      self.isAtBeginOfLine = false
//    }

//    if let indentToken = self.indents.pendingTokens.popLast() {
//      return indentToken
//    }

    return nil
  }
}
