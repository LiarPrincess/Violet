// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import XCTest
import Core
@testable import Lexer

/// Lexer test helpers.
internal protocol Common { }

extension Common {

  // MARK: - Int

  internal func XCTAssertInt(_ kind: TokenKind,
                             _ expected: Int64,
                             file: StaticString = #file,
                             line: UInt         = #line) {

    let pyExpected = PyInt(expected)
    XCTAssertEqual(kind, .int(pyExpected), file: file, line: line)
  }

  // MARK: - Quotes

  internal func shortQuote(_ s: String, _ q: String = "\"") -> String {
    return "\(q)\(s)\(q)"
  }

  internal func longQuote(_ s: String, _ q: String = "\"") -> String {
    return "\(q)\(q)\(q)\(s)\(q)\(q)\(q)"
  }

  // MARK: - Lex

  @discardableResult
  internal func getIdentifier(_ lexer: inout Lexer,
                              value:   String,
                              file:    StaticString = #file,
                              line:    UInt         = #line) -> Token? {
    if let token = self.getToken(&lexer, file: file, line: line) {
      XCTAssertEqual(token.kind, .identifier(value), file: file, line: line)
      return token
    }
    return nil
  }

  @discardableResult
  internal func getNewLine(_ lexer: inout Lexer,
                           file:    StaticString = #file,
                           line:    UInt         = #line) -> Token? {
    if let token = self.getToken(&lexer, file: file, line: line) {
      XCTAssertEqual(token.kind, .newLine, file: file, line: line)
      return token
    }
    return nil
  }

  @discardableResult
  internal func getEOF(_ lexer: inout Lexer,
                       file:    StaticString = #file,
                       line:    UInt         = #line) -> Token? {
    if let token = self.getToken(&lexer, file: file, line: line) {
      XCTAssertEqual(token.kind, .eof, file: file, line: line)
      return token
    }
    return nil
  }

  internal func getToken(_ lexer: inout Lexer,
                         file:    StaticString = #file,
                         line:    UInt         = #line) -> Token? {
    do {
      return try lexer.getToken()
    } catch {
      XCTAssert(false, "\(error)", file: file, line: line)
      return nil
    }
  }

  internal func error(_ lexer: inout Lexer,
                      file:    StaticString = #file,
                      line:    UInt = #line) -> LexerError? {
    do {
      let result = try lexer.getToken()
      XCTAssert(false, "Token: \(result)", file: file, line: line)
      return nil
    } catch let error as LexerError {
      return error
    } catch {
      XCTAssert(false, "\(error)", file: file, line: line)
      return nil
    }
  }

  internal func notImplemented(_ lexer: inout Lexer,
                               file:    StaticString = #file,
                               line:    UInt = #line) -> NotImplemented? {
    do {
      let result = try lexer.getToken()
      XCTAssert(false, "Token: \(result)", file: file, line: line)
      return nil
    } catch let error as NotImplemented {
      return error
    } catch {
      XCTAssert(false, "\(error)", file: file, line: line)
      return nil
    }
  }

  internal func XCTAssertEncoding(_ error: NotImplemented,
                                  _ expectedEncoding: String,
                                  file:    StaticString = #file,
                                  line:    UInt = #line) {
    switch error {
    case .encodingOtherThanUTF8(let encoding):
      XCTAssertEqual(encoding, expectedEncoding, file: file, line: line)
    default:
      XCTAssertTrue(false, "\(error)", file: file, line: line)
    }
  }

  // MARK: - Encoding

  internal func emacsEncoding(_ value: String) -> String {
    return "# -*- coding: \(value) -*-"
  }

  internal func vimEncoding(_ value: String) -> String{
    return "# vim:fileencoding=\(value)"
  }
}
