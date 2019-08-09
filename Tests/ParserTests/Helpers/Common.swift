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
  internal func createExprParser(_ tokens: Token...) -> Parser {
    let eofLocation = tokens.last?.end ?? .start
    let eof = Token(.eof, start: eofLocation, end: eofLocation)

    var lexerTokens = tokens
    lexerTokens.append(eof)

    let lexer = FakeLexer(tokens: lexerTokens)
    return Parser(mode: .eval, tokenSource: lexer)
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

  internal func XCTAssertExpression(_ expr:     Expression,
                                    _ expected: String,
                                    _ message:  String = "",
                                    file: StaticString = #file,
                                    line: UInt         = #line) {
    let desc = String(describing: expr.kind)
    XCTAssertEqual(desc, expected, message, file: file, line: line)
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
