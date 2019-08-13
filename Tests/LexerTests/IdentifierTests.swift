import XCTest
import Core
@testable import Lexer

/// Use 'python3 -m tokenize -e file.py' for python reference
/// and https://www.youtube.com/watch?v=LCCxnuLlS18 for song reference.
class IdentifierTests: XCTestCase, Common {

  // MARK: - String

  /// py: f"I know you I walked with you once upon a dream"
  func test_prefixedString_isString() {
    let s = "I know you I walked with you once upon a dream"
    var lexer = Lexer(for: "f" + self.shortQuote(s))

    if let token = self.getToken(&lexer) {
      XCTAssertEqual(token.kind, .formatString(s))
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 49))
    }
  }

  // MARK: - Keywords

  func test_keywords() {
    for (keyword, value) in keywords {
      var lexer = Lexer(for: keyword)

      if let token = self.getToken(&lexer) {
        XCTAssertEqual(token.kind,  value, keyword)
        XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0), keyword)
        XCTAssertEqual(token.end,   SourceLocation(line: 1, column: keyword.count), keyword)
      }
    }
  }

  // MARK: - Identifiers

  /// py: iKnowYouTheGleamInYourEyesIsSoFamiliarAGleam
  func test_identifier_simple() {
    let s = "iKnowYouTheGleamInYourEyesIsSoFamiliarAGleam"
    var lexer = Lexer(for: s)

    if let token = self.getToken(&lexer) {
      XCTAssertEqual(token.kind, .identifier(s))
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 44))
    }
  }

  /// py: _yetIKnowItsTrueThatVisionsAreSeldomAllTheySeem
  func test_identifier_startingWithUnderscore() {
    // use 'and' instead of 'yet' for prince version
    let s = "_yetIKnowItsTrueThatVisionsAreSeldomAllTheySeem"
    var lexer = Lexer(for: s)

    if let token = self.getToken(&lexer) {
      XCTAssertEqual(token.kind, .identifier(s))
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 47))
    }
  }

  /// py: 齀butIfIKnowYouIKnowWhatYoullDo
  func test_identifier_startingWithCJK() {
    let s = "齀butIfIKnowYouIKnowWhatYoullDo"
    var lexer = Lexer(for: s)

    if let token = self.getToken(&lexer) {
      XCTAssertEqual(token.kind, .identifier(s))
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 30))
    }
  }

  // py: youllLoveMeAtOnce齀TheWayYouDidOnceUponADream
  func test_identifier_containingCJK() {
    let s = "youllLoveMeAtOnce齀TheWayYouDidOnceUponADream"
    var lexer = Lexer(for: s)

    if let token = self.getToken(&lexer) {
      XCTAssertEqual(token.kind, .identifier(s))
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 44))
    }
  }

  /// py: 👸butIfIKnowYouIKnowWhatYoullDo
  func test_identifier_startingWithEmoji_throws() {
    var lexer = Lexer(for: "👸butIfIKnowYouIKnowWhatYoullDo")

    if let error = self.error(&lexer) {
      XCTAssertEqual(error.kind, LexerErrorKind.identifier("👸"))
      XCTAssertEqual(error.location, SourceLocation(line: 1, column: 0))
    }
  }

  // py: youll❤️MeAtOnceTheWayYouDidOnceUponADream
  func test_identifier_containingEmoji_throws() {
    var lexer = Lexer(for: "youll❤️MeAtOnceTheWayYouDidOnceUponADream")

    if let error = self.error(&lexer) {
      XCTAssertEqual(error.kind, LexerErrorKind.identifier("❤")) // not the same!
      XCTAssertEqual(error.location, SourceLocation(line: 1, column: 5))
    }
  }

  func test_identifier_singleCombiningCharacter_throws() {
    var lexer = Lexer(for: "\u{301}")

    if let error = self.error(&lexer) {
      XCTAssertEqual(error.kind, LexerErrorKind.identifier("\u{301}"))
      XCTAssertEqual(error.location, SourceLocation(line: 1, column: 0))
    }
  }

  /// https://docs.python.org/3/reference/lexical_analysis.html#reserved-classes-of-identifiers
  func test_identifiers_fromReservedClass() {
    let reserved = ["_", "__x__", "__x"]

    for identifier in reserved {
      var lexer = Lexer(for: identifier)

      if let token = self.getToken(&lexer) {
        XCTAssertEqual(token.kind, .identifier(identifier), identifier)
        XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0), identifier)
        XCTAssertEqual(token.end,   SourceLocation(line: 1, column: identifier.count), identifier)
      }
    }
  }
}
