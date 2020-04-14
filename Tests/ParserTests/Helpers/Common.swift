import XCTest
import Core
import Lexer
@testable import Parser

/// Shared test helpers.
internal protocol Common { }

extension Common {

  // MARK: - Creation

  /// Create parser for given tokens..
  internal func createExprParser(_ tokens: Token...) -> Parser {
    return self.createParser(mode: .eval, tokens: tokens)
  }

  /// Create parser for given tokens.
  internal func createStmtParser(_ tokens: Token...) -> Parser {
    return self.createParser(mode: .fileInput, tokens: tokens)
  }

  private func createParser(mode: ParserMode, tokens: [Token]) -> Parser {
    let lexer = FakeLexer(tokens: tokens)
    return Parser(mode: mode,
                  tokenSource: lexer,
                  delegate: nil,
                  lexerDelegate: nil)
  }

  internal func token(_ kind: TokenKind,
                      start: SourceLocation,
                      end: SourceLocation) -> Token {
    return Token(kind, start: start, end: end)
  }

  // MARK: - Parse

  internal func parse(_ parser: Parser,
                      file: StaticString = #file,
                      line: UInt         = #line) -> AST? {
    do {
      return try parser.parse()
    } catch {
      XCTAssert(false, "\(error)", file: file, line: line)
      return nil
    }
  }

  internal func error(_ parser: Parser,
                      file: StaticString = #file,
                      line: UInt = #line) -> ParserError? {
    do {
      let result = try parser.parse()
      XCTAssert(false, "Successful parse: \(result)", file: file, line: line)
      return nil
    } catch let error as ParserError {
      return error
    } catch {
      XCTAssert(false, "\(error)", file: file, line: line)
      return nil
    }
  }

  // MARK: - Dump

  @available(*, deprecated, message: "Use only when writing tests!")
  internal func dump<C: CustomStringConvertible>(_ value: C) {
    print("=========")
    print(value)
    print("=========")
  }
}
