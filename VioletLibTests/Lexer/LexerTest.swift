// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import XCTest
@testable import VioletLib

/// Lexer test helpers.
internal protocol LexerTest { }

extension LexerTest {

  // MARK: - Quotes

  internal func singleQuote(_ s: String) -> String {
    return "'\(s)'"
  }

  internal func doubleQuote(_ s: String) -> String {
    return "\"\(s)\""
  }

  internal func tripleQuote(_ s: String) -> String {
    return "\"\"\"\(s)\"\"\""
  }

  // MARK: - Lex

  internal func identifierOrString(_ lexer: inout Lexer,
                                   file:    StaticString = #file,
                                   line:    UInt         = #line) -> Token? {
    return self.lex(try lexer.identifierOrString(), file: file, line: line)
  }

  internal func string(_ lexer: inout Lexer,
                       file:    StaticString = #file,
                       line:    UInt         = #line) -> Token? {
    return self.lex(try lexer.string(), file: file, line: line)
  }

  internal func number(_ lexer: inout Lexer,
                       file:    StaticString = #file,
                       line:    UInt         = #line) -> Token? {
    return self.lex(try lexer.number(), file: file, line: line)
  }

  private func lex(_ f:  @autoclosure () throws -> Token,
                   file: StaticString = #file,
                   line: UInt         = #line) -> Token? {
    do {
      return try f()
    } catch {
      XCTAssert(false, "\(error)", file: file, line: line)
      return nil
    }
  }

  // MARK: - Lex errors

  internal func identifierOrStringError(_ lexer: inout Lexer,
                                        file:    StaticString = #file,
                                        line:    UInt = #line) -> LexerError? {
    return self.error(try lexer.identifierOrString(), file: file, line: line)
  }

  internal func stringError(_ lexer: inout Lexer,
                            file:    StaticString = #file,
                            line:    UInt = #line) -> LexerError? {
    return self.error(try lexer.string(), file: file, line: line)
  }

  internal func numberError(_ lexer: inout Lexer,
                            file:    StaticString = #file,
                            line:    UInt = #line) -> LexerError? {
    return self.error(try lexer.number(), file: file, line: line)
  }

  private func error(_ f:  @autoclosure () throws -> Token,
                     file: StaticString = #file,
                     line: UInt         = #line) -> LexerError? {
    do {
      let result = try f()
      XCTAssert(false, "Got token: \(result)", file: file, line: line)
      return nil
    } catch let error as LexerError {
      return error
    } catch {
      XCTAssert(false, "Invalid error: \(error)", file: file, line: line)
      return nil
    }
  }
}
