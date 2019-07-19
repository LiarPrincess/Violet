// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation

public struct Lexer {

  /// Data to lex.
  private var stream: InputStream

  /// Is at begin of new line?
  private var atBeginOfLine = true

  /// Stack of parentheses: () [] {}.
  private var parenStack = [TokenKind]()

  /// Stack of indents
  ///  indentation_stack: Vec<IndentationLevel>,
  //  private var indentationStack

  // indentManager
  // at bol: calculate indent
  // next: get pending indent? -> not null -> return

  private var chr0: UnicodeScalar? = nil
  private var chr1: UnicodeScalar? = nil

  private var location = SourceLocation.start

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

    // populate 'chr0' and 'chr1'
    _ = self.nextChar()
    _ = self.nextChar()
  }

  // MARK: - Traversal

  private mutating func nextChar() -> UnicodeScalar? {
    let c = self.chr0
    self.chr0 = self.chr1
    self.chr1 = self.stream.advance()
    self.location.advance()
    return c
  }

  // MARK: - Lexing

  public func getToken() -> Token? {


    return nil
  }
}

private let keywords: [String:TokenKind] = [
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
  "ellipsis": .ellipsis,
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
