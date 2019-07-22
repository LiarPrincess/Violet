// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation

public struct Lexer {

  /// Data to lex.
  internal var stream: InputStream

  /// Is at begin of new line?
  internal var isAtBeginOfLine = true

  /// Stack of parentheses: () [] {}.
  internal var parenStack = [TokenKind]()

  /// Stack of indents.
  internal var indents = IndentState()

  /// Next character that will be read.
  /// Use `self.advance` to consume.
  internal var peek: UnicodeScalar?

  /// Character after `self.peek`.
  internal var peekNext: UnicodeScalar?

  /// Where are we in the source file?
  internal var location = SourceLocation.start

  public init(url: URL) {
    // TODO: Handle file open error
    let stream = try! FileStream(url: url) // swiftlint:disable:this force_try
    self.init(stream: stream)
  }

  public init(string: String) {
    self.init(stream: StringStream(string))
  }

  internal init(stream: InputStream) {
    self.stream = NewLineConverter(base: stream)

    self.peek     = self.stream.advance()
    self.peekNext = self.stream.advance()
  }

  // MARK: - Traversal

  /// Consumes current character. Returns next `peek`.
  @discardableResult
  internal mutating func advance() -> UnicodeScalar? {
    let consumed = self.peek
    self.peek = self.peekNext
    self.peekNext = self.stream.advance()

    if consumed == "\n" {
      self.location.advanceLine()
    } else {
      self.location.advanceColumn()
    }

    return self.peek
  }

  internal mutating func advanceIf(_ expected: UnicodeScalar) -> Bool {
    guard let next = self.peek else {
      return false
    }

    if next == expected {
      self.advance()
      return true
    }

    return false
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
