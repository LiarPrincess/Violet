import XCTest
import BigInt
import VioletCore
@testable import VioletLexer

// MARK: - Create lexer

func createLexer(for string: String) -> Lexer {
  return Lexer(for: string, delegate: nil)
}

// MARK: - Quotes

func singleQuote(_ s: String, quote q: String = "\"") -> String {
  return "\(q)\(s)\(q)"
}

func tripleQuote(_ s: String, quote q: String = "\"") -> String {
  return "\(q)\(q)\(q)\(s)\(q)\(q)\(q)"
}

// MARK: - Assert specific token kind

func XCTAssertInt(_ kind: Token.Kind,
                  _ value: BigInt,
                  file: StaticString = #file,
                  line: UInt = #line) {
  XCTAssertEqual(kind, .int(value), file: file, line: line)
}

// MARK: - Get token

/// Get the next token from lexer.
func getToken(_ lexer: Lexer,
              file: StaticString = #file,
              line: UInt = #line) -> Token? {
  do {
    return try lexer.getToken()
  } catch {
    XCTAssert(false, "\(error)", file: file, line: line)
    return nil
  }
}

/// Get the next token from lexer while asserting its `kind`.
func getToken(_ lexer: Lexer,
              withKind kind: Token.Kind,
              file: StaticString = #file,
              line: UInt = #line) -> Token? {
  if let token = getToken(lexer, file: file, line: line) {
    XCTAssertEqual(token.kind, kind, file: file, line: line)
    return token
  }

  return nil
}

/// Use this if you want to test that next token is an identifier.
@discardableResult
func getIdentifier(_ lexer: Lexer,
                   value: String,
                   file: StaticString = #file,
                   line: UInt = #line) -> Token? {
  return getToken(lexer, withKind: .identifier(value), file: file, line: line)
}

/// Use this if you want to test that next token is a comment with specified value.
@discardableResult
func getComment(_ lexer: Lexer,
                value: String,
                file: StaticString = #file,
                line: UInt = #line) -> Token? {
  return getToken(lexer, withKind: .comment(value), file: file, line: line)
}

/// Use this if you want to test that next token is a new line.
@discardableResult
func getNewLine(_ lexer: Lexer,
                file: StaticString = #file,
                line: UInt = #line) -> Token? {
  return getToken(lexer, withKind: .newLine, file: file, line: line)
}

/// Use this if you want to test that next token is EOF.
@discardableResult
func getEOF(_ lexer: Lexer,
            file: StaticString = #file,
            line: UInt = #line) -> Token? {
  return getToken(lexer, withKind: .eof, file: file, line: line)
}

// MARK: - Errors

/// Use this if you want to test that getting next token should error.
func getError(_ lexer: Lexer,
              file: StaticString = #file,
              line: UInt = #line) -> LexerError? {
  do {
    let result = try lexer.getToken()
    XCTAssert(false, "Unexpected token: \(result)", file: file, line: line)
    return nil
  } catch let error as LexerError {
    return error
  } catch {
    XCTAssert(false, "Unexpected error: \(error)", file: file, line: line)
    return nil
  }
}

/// Use this if you want to test that getting next token should produce
/// `LexerUnimplemented`. error
func getUnimplemented(_ lexer: Lexer,
                      file: StaticString = #file,
                      line: UInt = #line) -> LexerUnimplemented? {
  do {
    let result = try lexer.getToken()
    XCTAssert(false, "Unexpected token: \(result)", file: file, line: line)
    return nil
  } catch let error as LexerError {

    switch error.kind {
    case .unimplemented(let u):
      return u
    default:
      XCTAssert(false, "Unexpected lexer error: \(error)", file: file, line: line)
      return nil
    }
  } catch {
    XCTAssert(false, "Unexpected error: \(error)", file: file, line: line)
    return nil
  }
}

// MARK: - Encoding

func XCTAssertEncoding(_ error: LexerUnimplemented,
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
