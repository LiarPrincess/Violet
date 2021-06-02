import XCTest
import VioletCore
import VioletLexer
@testable import VioletParser

// MARK: - Creation

/// Create parser for given tokens.
func createExprParser(_ tokens: Token...) -> Parser {
  return createParser(mode: .eval, tokens: tokens)
}

/// Create parser for given tokens.
func createStmtParser(_ tokens: Token...) -> Parser {
  return createParser(mode: .fileInput, tokens: tokens)
}

private func createParser(mode: Parser.Mode, tokens: [Token]) -> Parser {
  let lexer = FakeLexer(tokens: tokens)
  return Parser(mode: mode,
                tokenSource: lexer,
                delegate: nil,
                lexerDelegate: nil)
}

func createToken(_ kind: Token.Kind,
                 start: SourceLocation,
                 end: SourceLocation) -> Token {
  return Token(kind, start: start, end: end)
}

// MARK: - Parse

/// Run parser returning AST
func parse(_ parser: Parser,
           file: StaticString = #file,
           line: UInt = #line) -> AST? {
  do {
    return try parser.parse()
  } catch {
    XCTAssert(false, "\(error)", file: file, line: line)
    return nil
  }
}

/// Run parser expecting error.
func parseError(_ parser: Parser,
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

// MARK: - Assertions

func XCTAssertAST(_ ast: AST,
                  _ expected: String,
                  file: StaticString = #file,
                  line: UInt = #line) {
  let string = String(describing: ast)
  XCTAssertEqual(string, expected, file: file, line: line)
}

func XCTAssertString(_ group: StringExpr.Group,
                     _ expected: String,
                     file: StaticString = #file,
                     line: UInt = #line) {
  let string = String(describing: group)
  XCTAssertEqual(string, expected, file: file, line: line)
}

// MARK: - Dump

/// Dump AST (or other value)
@available(*, deprecated, message: "Use only when writing tests!")
internal func dump<C: CustomStringConvertible>(_ value: C) {
  print("=========")
  print(value)
  print("=========")
}
