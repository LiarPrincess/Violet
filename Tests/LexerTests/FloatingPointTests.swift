import XCTest
import VioletCore
@testable import VioletLexer

// swiftformat:disable consecutiveSpaces

/// Use 'python3 -m tokenize -e file.py' for python reference.
class FloatingPointTests: XCTestCase {

  /// Test case from:
  /// https://docs.python.org/3/reference/lexical_analysis.html#floating-point-literals
  func test_zero() {
    let s = "0.0"
    let lexer = createLexer(for: s)

    if let token = getToken(lexer) {
      XCTAssertEqual(token.kind, .float(0.0))
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 3))
    }
  }

  /// Test case from:
  /// https://docs.python.org/3/reference/lexical_analysis.html#floating-point-literals
  func test_zero_asExponent() {
    let s = "0e0"
    let lexer = createLexer(for: s)

    if let token = getToken(lexer) {
      XCTAssertEqual(token.kind, .float(0.0))
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 3))
    }
  }

  /// Test case from:
  /// https://docs.python.org/3/reference/lexical_analysis.html#floating-point-literals
  func test_number() {
    let s = "3.14"
    let lexer = createLexer(for: s)

    if let token = getToken(lexer) {
      XCTAssertEqual(token.kind, .float(3.14))
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 4))
    }
  }

  /// Test case from:
  /// https://docs.python.org/3/reference/lexical_analysis.html#floating-point-literals
  func test_number_withUnderscores() {
    let s = "3.14_15_93"
    let lexer = createLexer(for: s)

    if let token = getToken(lexer) {
      XCTAssertEqual(token.kind, .float(3.141_593))
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 10))
    }
  }

  /// Test case from:
  /// https://docs.python.org/3/reference/lexical_analysis.html#floating-point-literals
  func test_number_withoutFractions() {
    // trivia: glibc calls this 'american style' number

    let s = "10."
    let lexer = createLexer(for: s)

    if let token = getToken(lexer) {
      XCTAssertEqual(token.kind, .float(10))
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 3))
    }
  }

  /// Test case from:
  /// https://docs.python.org/3/reference/lexical_analysis.html#floating-point-literals
  func test_number_withoutWhole() {
    let s = ".001"
    let lexer = createLexer(for: s)

    if let token = getToken(lexer) {
      XCTAssertEqual(token.kind, .float(0.001))
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 4))
    }
  }

  /// Test case from:
  /// https://docs.python.org/3/reference/lexical_analysis.html#floating-point-literals
  func test_number_withExponent() {
    let s = "1e100"
    let lexer = createLexer(for: s)

    if let token = getToken(lexer) {
      XCTAssertEqual(token.kind, .float(1e100))
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 5))
    }
  }

  /// Test case from:
  /// https://docs.python.org/3/reference/lexical_analysis.html#floating-point-literals
  /// 'For example, 077e010 is legal, and denotes the same number as 77e10.'
  func test_number_withExponent2() {
    let s = "077e010"
    let lexer = createLexer(for: s)

    if let token = getToken(lexer) {
      XCTAssertEqual(token.kind, .float(77e010))
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 7))
    }
  }

  /// Test case from:
  /// https://docs.python.org/3/reference/lexical_analysis.html#floating-point-literals
  func test_number_withFraction_andExponent() {
    let s = "3.14e-10"
    let lexer = createLexer(for: s)

    if let token = getToken(lexer) {
      XCTAssertEqual(token.kind, .float(3.14e-10))
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 8))
    }
  }
}
