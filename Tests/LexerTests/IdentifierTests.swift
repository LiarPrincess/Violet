import XCTest
import VioletCore
@testable import VioletLexer

// swiftformat:disable consecutiveSpaces

/// Use 'python3 -m tokenize -e file.py' for python reference
/// and https://www.youtube.com/watch?v=LCCxnuLlS18 for song reference.
class IdentifierTests: XCTestCase {

  // MARK: - String

  /// py: f"I know you I walked with you once upon a dream"
  func test_prefixedString_isString() {
    let s = "I know you I walked with you once upon a dream"
    let lexer = createLexer(for: "f" + singleQuote(s))

    if let token = getToken(lexer) {
      XCTAssertEqual(token.kind, .formatString(s))
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 49))
    }
  }

  // MARK: - Keywords

  func test_keywords() {
    for (keyword, value) in keywords {
      let lexer = createLexer(for: keyword)

      if let token = getToken(lexer) {
        let endColumn = SourceColumn(keyword.count)
        XCTAssertEqual(token.kind,  value, keyword)
        XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0), keyword)
        XCTAssertEqual(token.end,   SourceLocation(line: 1, column: endColumn), keyword)
      }
    }
  }

  // MARK: - Identifiers

  /// py: iKnowYouTheGleamInYourEyesIsSoFamiliarAGleam
  func test_identifier_simple() {
    let s = "iKnowYouTheGleamInYourEyesIsSoFamiliarAGleam"
    let lexer = createLexer(for: s)

    if let token = getToken(lexer) {
      XCTAssertEqual(token.kind, .identifier(s))
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 44))
    }
  }

  /// py: _yetIKnowItsTrueThatVisionsAreSeldomAllTheySeem
  func test_identifier_startingWithUnderscore() {
    // use 'and' instead of 'yet' for prince version
    let s = "_yetIKnowItsTrueThatVisionsAreSeldomAllTheySeem"
    let lexer = createLexer(for: s)

    if let token = getToken(lexer) {
      XCTAssertEqual(token.kind, .identifier(s))
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 47))
    }
  }

  // cSpell:ignore Youll

  /// py: 齀butIfIKnowYouIKnowWhatYoullDo
  func test_identifier_startingWithCJK() {
    let s = "齀butIfIKnowYouIKnowWhatYoullDo"
    let lexer = createLexer(for: s)

    if let token = getToken(lexer) {
      XCTAssertEqual(token.kind, .identifier(s))
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 30))
    }
  }

  // py: youllLoveMeAtOnce齀TheWayYouDidOnceUponADream
  func test_identifier_containingCJK() {
    let s = "youllLoveMeAtOnce齀TheWayYouDidOnceUponADream"
    let lexer = createLexer(for: s)

    if let token = getToken(lexer) {
      XCTAssertEqual(token.kind, .identifier(s))
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 44))
    }
  }

  /// py: 👸butIfIKnowYouIKnowWhatYoullDo
  func test_identifier_startingWithEmoji_throws() {
    let lexer = createLexer(for: "👸butIfIKnowYouIKnowWhatYoullDo")

    if let error = getError(lexer) {
      XCTAssertEqual(error.kind, .invalidCharacterInIdentifier("👸"))
      XCTAssertEqual(error.location, SourceLocation(line: 1, column: 0))
    }
  }

  // py: youll❤️MeAtOnceTheWayYouDidOnceUponADream
  func test_identifier_containingEmoji_throws() {
    let lexer = createLexer(for: "youll❤️MeAtOnceTheWayYouDidOnceUponADream")

    if let error = getError(lexer) {
      XCTAssertEqual(error.kind, .invalidCharacterInIdentifier("❤")) // not the same!
      XCTAssertEqual(error.location, SourceLocation(line: 1, column: 5))
    }
  }

  func test_identifier_singleCombiningCharacter_throws() {
    let lexer = createLexer(for: "\u{301}")

    if let error = getError(lexer) {
      XCTAssertEqual(error.kind, .invalidCharacterInIdentifier("\u{301}"))
      XCTAssertEqual(error.location, SourceLocation(line: 1, column: 0))
    }
  }

  /// https://docs.python.org/3/reference/lexical_analysis.html#reserved-classes-of-identifiers
  func test_identifiers_fromReservedClass() {
    let reserved = ["_", "__x__", "__x"]

    for identifier in reserved {
      let lexer = createLexer(for: identifier)

      if let token = getToken(lexer) {
        let endColumn = SourceColumn(identifier.count)
        XCTAssertEqual(token.kind, .identifier(identifier), identifier)
        XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0), identifier)
        XCTAssertEqual(token.end,   SourceLocation(line: 1, column: endColumn), identifier)
      }
    }
  }
}
