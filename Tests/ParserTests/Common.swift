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

  // MARK: - Locations

  internal var loc0:  SourceLocation { return self.location(n:  0) }
  internal var loc1:  SourceLocation { return self.location(n:  1) }
  internal var loc2:  SourceLocation { return self.location(n:  2) }
  internal var loc3:  SourceLocation { return self.location(n:  3) }
  internal var loc4:  SourceLocation { return self.location(n:  4) }
  internal var loc5:  SourceLocation { return self.location(n:  5) }
  internal var loc6:  SourceLocation { return self.location(n:  6) }
  internal var loc7:  SourceLocation { return self.location(n:  7) }
  internal var loc8:  SourceLocation { return self.location(n:  8) }
  internal var loc9:  SourceLocation { return self.location(n:  9) }
  internal var loc10: SourceLocation { return self.location(n: 10) }
  internal var loc11: SourceLocation { return self.location(n: 11) }
  internal var loc12: SourceLocation { return self.location(n: 12) }
  internal var loc13: SourceLocation { return self.location(n: 13) }
  internal var loc14: SourceLocation { return self.location(n: 14) }
  internal var loc15: SourceLocation { return self.location(n: 15) }
  internal var loc16: SourceLocation { return self.location(n: 16) }
  internal var loc17: SourceLocation { return self.location(n: 17) }
  internal var loc18: SourceLocation { return self.location(n: 18) }
  internal var loc19: SourceLocation { return self.location(n: 19) }
  internal var loc20: SourceLocation { return self.location(n: 20) }
  internal var loc21: SourceLocation { return self.location(n: 21) }
  internal var loc22: SourceLocation { return self.location(n: 22) }
  internal var loc23: SourceLocation { return self.location(n: 23) }

  private func location(n: Int) -> SourceLocation {
    let line = n / 2 + 1
    let column = (n % 2) * 5 + line
    return SourceLocation(line: line, column: column)
  }

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

  // MARK: - Errors

  internal func error(_ parser: inout Parser,
                      file:    StaticString = #file,
                      line:    UInt = #line) -> ParserError? {
    do {
      let result = try parser.parse()
      XCTAssert(false, "Result: \(result)", file: file, line: line)
      return nil
    } catch let error as ParserError {
      return error
    } catch {
      XCTAssert(false, "\(error)", file: file, line: line)
      return nil
    }
  }
}
