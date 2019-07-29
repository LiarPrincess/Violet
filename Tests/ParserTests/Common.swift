// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import XCTest
import Core
import Lexer
@testable import Parser

/// Shared test helpers.
internal protocol Common { }

extension Common {

  // MARK: - Creation

  /// Create parser for given tokens.
  /// Will automatically add EOF at the end.
  internal func parser(_ tokens: Token...) -> Parser {
    let eofLocation = tokens.last?.end ?? .start
    let eof = Token(.eof, start: eofLocation, end: eofLocation)

    var lexerTokens = tokens
    lexerTokens.append(eof)

    let lexer = FakeLexer(tokens: lexerTokens)
    return Parser(lexer: lexer)
  }

  internal func loc(l: Int, c: Int) -> SourceLocation {
    return SourceLocation(line: l, column: c)
  }

  internal func token(_ kind: TokenKind,
                      start: SourceLocation,
                      end: SourceLocation) -> Token {
    return Token(kind, start: start, end: end)
  }

  // MARK: - Parse

  /// Use this if you just want to perform detailed tests on token.
  internal func parse(_ parser: inout Parser,
                      file:    StaticString = #file,
                      line:    UInt         = #line) -> Expression? {
    do {
      return try parser.parse()
    } catch {
      XCTAssert(false, "\(error)", file: file, line: line)
      return nil
    }
  }
}
