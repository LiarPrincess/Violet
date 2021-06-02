import XCTest
import VioletCore
@testable import VioletLexer

// swiftformat:disable consecutiveSpaces

/// Use 'python3 -m tokenize -e file.py' for python reference.
class IntegerTests: XCTestCase {

  // MARK: - Decimal integer

  func test_decimal_zero() {
    let s = "0"
    let lexer = createLexer(for: s)

    if let token = getToken(lexer) {
      XCTAssertInt(token.kind, 0)
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 1))
    }
  }

  func test_decimal_zero_withUnderscores() {
    let s = "0_000_000"
    let lexer = createLexer(for: s)

    if let token = getToken(lexer) {
      XCTAssertInt(token.kind, 0)
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 9))
    }
  }

  /// Test case from:
  /// https://docs.python.org/3/reference/lexical_analysis.html#integer-literals
  func test_decimal() {
    let s = "2147483647"
    let lexer = createLexer(for: s)

    if let token = getToken(lexer) {
      XCTAssertInt(token.kind, 2_147_483_647)
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 10))
    }
  }

  /// Test case from:
  /// https://docs.python.org/3/reference/lexical_analysis.html#integer-literals
  func test_decimal_withUnderscores() {
    let s = "100_000_000_000"
    let lexer = createLexer(for: s)

    if let token = getToken(lexer) {
      XCTAssertInt(token.kind, 100_000_000_000)
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 15))
    }
  }

  func test_decimal_maxInt64() {
    let s = "9223372036854775807"
    let lexer = createLexer(for: s)

    if let token = getToken(lexer) {
      XCTAssertInt(token.kind, 9_223_372_036_854_775_807)
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 19))
    }
  }

  // MARK: - Binary integer

  /// Test case from:
  /// https://docs.python.org/3/reference/lexical_analysis.html#integer-literals
  func test_binary() {
    let s = "0b100110111"
    let lexer = createLexer(for: s)

    if let token = getToken(lexer) {
      XCTAssertInt(token.kind, 0b1_0011_0111)
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 11))
    }
  }

  /// Test case from:
  /// https://docs.python.org/3/reference/lexical_analysis.html#integer-literals
  func test_binary_withUnderscores() {
    let s = "0b_1110_0101"
    let lexer = createLexer(for: s)

    if let token = getToken(lexer) {
      XCTAssertInt(token.kind, 0b1110_0101)
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 12))
    }
  }

  // MARK: - Octal integer

  /// Test case from:
  /// https://docs.python.org/3/reference/lexical_analysis.html#integer-literals
  func test_octal() {
    let s = "0o177"
    let lexer = createLexer(for: s)

    if let token = getToken(lexer) {
      XCTAssertInt(token.kind, 0o177)
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 5))
    }
  }

  /// Test case from (I added underscores):
  /// https://docs.python.org/3/reference/lexical_analysis.html#integer-literals
  func test_octal_withUnderscores() {
    let s = "0o_37_7"
    let lexer = createLexer(for: s)

    if let token = getToken(lexer) {
      XCTAssertInt(token.kind, 0o377)
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 7))
    }
  }

  // MARK: - Hex integer

  /// Test case from:
  /// https://docs.python.org/3/reference/lexical_analysis.html#integer-literals
  func test_hex() {
    let s = "0xdeadBEEF"
    let lexer = createLexer(for: s)

    if let token = getToken(lexer) {
      XCTAssertInt(token.kind, 0xdead_beef)
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 10))
    }
  }

  func test_hex_withUnderscores() {
    let s = "0x_01_23_45_67_89_ac"
    let lexer = createLexer(for: s)

    if let token = getToken(lexer) {
      XCTAssertInt(token.kind, 0x0123_4567_89ac)
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 20))
    }
  }

  func test_hex_zero() {
    let s = "0x0"
    let lexer = createLexer(for: s)

    if let token = getToken(lexer) {
      XCTAssertInt(token.kind, 0x0)
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 3))
    }
  }

  func test_hex_lastUnderscore_isNotAPartOfTheNumber() {
    let input = "0x123_"
    let lexer = createLexer(for: input)

    if let error = getError(lexer) {
      switch error.kind {
      case let .unableToParseInt(s, type, parsingError):
        XCTAssertEqual(s, input)
        XCTAssertEqual(type, .hexadecimal)

        switch parsingError {
        case .underscoreSuffix:
          break
        default:
          XCTFail("\(parsingError)")
        }

      default:
        XCTFail("\(error.kind)")
      }

      XCTAssertEqual(error.location, SourceLocation(line: 1, column: 0))
    }
  }
}
