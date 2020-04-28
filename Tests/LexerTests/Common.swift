import XCTest
import VioletCore
@testable import VioletLexer

/// Shared test helpers.
internal protocol Common {}

extension Common {

  // MARK: - Create lexer

  internal func createLexer(for string: String) -> Lexer {
    return Lexer(for: string, delegate: nil)
  }

  // MARK: - Int

  internal func XCTAssertInt(_ kind: TokenKind,
                             _ expected: Int64,
                             file: StaticString = #file,
                             line: UInt = #line) {
    let pyExpected = BigInt(expected)
    XCTAssertEqual(kind, .int(pyExpected), file: file, line: line)
  }

  // MARK: - Quotes

  internal func shortQuote(_ s: String, _ q: String = "\"") -> String {
    return "\(q)\(s)\(q)"
  }

  internal func longQuote(_ s: String, _ q: String = "\"") -> String {
    return "\(q)\(q)\(q)\(s)\(q)\(q)\(q)"
  }

  // MARK: - Get token

  /// Use this if you just want to perform detailed tests on token.
  internal func getToken(_ lexer: Lexer,
                         file: StaticString = #file,
                         line: UInt = #line) -> Token? {
    do {
      return try lexer.getToken()
    } catch {
      XCTAssert(false, "\(error)", file: file, line: line)
      return nil
    }
  }

  /// Use this if you just want to test that next token is identifier.
  @discardableResult
  internal func getIdentifier(_ lexer: Lexer,
                              value: String,
                              file: StaticString = #file,
                              line: UInt = #line) -> Token? {
    return self.getSpecificToken(lexer, kind: .identifier(value), file: file, line: line)
  }

  /// Use this if you just want to test that next token is EOL.
  @discardableResult
  internal func getComment(_ lexer: Lexer,
                           value: String,
                           file: StaticString = #file,
                           line: UInt = #line) -> Token? {
    return self.getSpecificToken(lexer, kind: .comment(value), file: file, line: line)
  }

  /// Use this if you just want to test that next token is EOL.
  @discardableResult
  internal func getNewLine(_ lexer: Lexer,
                           file: StaticString = #file,
                           line: UInt = #line) -> Token? {
    return self.getSpecificToken(lexer, kind: .newLine, file: file, line: line)
  }

  /// Use this if you just want to test that next token is EOF.
  @discardableResult
  internal func getEOF(_ lexer: Lexer,
                       file: StaticString = #file,
                       line: UInt = #line) -> Token? {
    return self.getSpecificToken(lexer, kind: .eof, file: file, line: line)
  }

  @discardableResult
  private func getSpecificToken(_ lexer: Lexer,
                                kind: TokenKind,
                                file: StaticString = #file,
                                line: UInt = #line) -> Token? {
    if let token = self.getToken(lexer, file: file, line: line) {
      XCTAssertEqual(token.kind, kind, file: file, line: line)
      return token
    }
    return nil
  }

  // MARK: - Errors

  internal func error(_ lexer: Lexer,
                      file: StaticString = #file,
                      line: UInt = #line) -> LexerError? {
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

  internal func unimplemented(_ lexer: Lexer,
                              file: StaticString = #file,
                              line: UInt = #line) -> LexerUnimplemented? {
    do {
      let result = try lexer.getToken()
      XCTAssert(false, "Token: \(result)", file: file, line: line)
      return nil
    } catch {
      if let e = error as? LexerError {
        if case let LexerErrorKind.unimplemented(u) = e.kind {
          return u
        }
      }

      XCTAssert(false, "\(error)", file: file, line: line)
      return nil
    }
  }

  // MARK: - Encoding

  internal func XCTAssertEncoding(_ error: LexerUnimplemented,
                                  _ expectedEncoding: String,
                                  file: StaticString = #file,
                                  line: UInt = #line) {
    switch error {
    case .nonUTF8Encoding(let encoding):
      XCTAssertEqual(encoding, expectedEncoding, file: file, line: line)
    default:
      XCTAssertTrue(false, "\(error)", file: file, line: line)
    }
  }
}
