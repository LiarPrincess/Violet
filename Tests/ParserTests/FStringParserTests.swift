import Foundation
import XCTest
import Core
import Lexer
@testable import Parser

// Use this for reference:
// https://www.youtube.com/watch?v=BTBaUHSi-xk
// The beginning it rather discouraging, but it gets easier later.

// swiftlint:disable file_length

class FStringParserTest: XCTestCase, DestructStringGroup {

  // MARK: - Empty

  func test_empty() throws {
    var string = self.createFString()

    let group = try string.compile()
    if let result = self.destructStringSimple(group) {
      XCTAssertEqual(result, "")
    }
  }

  // MARK: - String

  func test_string() throws {
    let s = "The snow glows white on the mountain tonight"

    var string = self.createFString()
    try string.append(s)

    let group = try string.compile()
    if let result = self.destructStringSimple(group) {
      XCTAssertEqual(result, s)
    }
  }

  func test_string_concatentation() throws {
    var string = self.createFString()
    try string.append("Not a footprint to be seen\n")
    try string.append("A kingdom of isolation\n")
    try string.append("And it looks like I'm the queen")

    let expected = """
      Not a footprint to be seen
      A kingdom of isolation
      And it looks like I'm the queen
      """

    let group = try string.compile()
    if let result = self.destructStringSimple(group) {
      XCTAssertEqual(result, expected)
    }
  }

  // MARK: - FString - literals

  func test_literal() throws {
    let s = "The wind is howling like this swirling storm inside"

    var string = self.createFString()
    try string.appendFormatString(s)

    let group = try string.compile()
    if let result = self.destructStringSimple(group) {
      XCTAssertEqual(result, s)
    }
  }

  func test_literal_withEscapes() throws {
    let s = "Couldn't keep {{it}} in, heaven knows I tried!"
    let expected = "Couldn't keep {it} in, heaven knows I tried!"

    var string = self.createFString()
    try string.appendFormatString(s)

    let group = try string.compile()
    if let result = self.destructStringSimple(group) {
      XCTAssertEqual(result, expected)
    }
  }

  func test_literal_withUnclosedEscapeAtEnd_throws() throws {
    let s = "Don't let them in, don't let them see{"

    do {
      var string = self.createFString()
      try string.appendFormatString(s)
      XCTAssert(false)
    } catch let error as FStringError {
      XCTAssertEqual(error, FStringError.unexpectedEnd)
    } catch {
      XCTAssert(false, "\(error)")
    }
  }

  func test_literal_withSingleRightBrace_throws() throws {
    let s = "Be the good girl }you always have to be"

    do {
      var string = self.createFString()
      try string.appendFormatString(s)
      XCTAssert(false)
    } catch let error as FStringError {
      XCTAssertEqual(error, FStringError.singleRightBrace)
    } catch {
      XCTAssert(false, "\(error)")
    }
  }

  func test_literal_concat() throws {
    var string = self.createFString()
    try string.appendFormatString("Conceal, don't feel, don't let them know\n")
    try string.appendFormatString("Well, now they know!")

    let expected = """
      Conceal, don't feel, don't let them know
      Well, now they know!
      """

    let group = try string.compile()
    if let result = self.destructStringSimple(group) {
      XCTAssertEqual(result, expected)
    }
  }

  // MARK: - Fstring - formatted value

  func test_formattedValue() throws {
    var string = self.createFString()
    try string.appendFormatString("{2013}")

    let group = try string.compile()
    if let d = self.destructStringFormattedValue(group) {
      XCTAssertEqual(d.0, "2013")
      XCTAssertEqual(d.conversion, nil)
      XCTAssertEqual(d.spec, nil)
    }
  }

  func test_formattedValue_string() throws {
    var string = self.createFString()
    try string.appendFormatString("{'Let it go, let it go'}")

    let group = try string.compile()
    if let d = self.destructStringFormattedValue(group) {
      XCTAssertEqual(d.0, "'Let it go, let it go'")
      XCTAssertEqual(d.conversion, nil)
      XCTAssertEqual(d.spec, nil)
    }
  }

  func test_formattedValue_inParens() throws {
    var string = self.createFString()
    try string.appendFormatString("{('Cant hold it back anymore')}")

    let group = try string.compile()
    if let d = self.destructStringFormattedValue(group) {
      XCTAssertEqual(d.0, "('Cant hold it back anymore')")
      XCTAssertEqual(d.conversion, nil)
      XCTAssertEqual(d.spec, nil)
    }
  }

  func test_formattedValue_conversion() throws {
    var string = self.createFString()
    try string.appendFormatString("{'Let it go, let it go'!r}")

    let group = try string.compile()
    if let d = self.destructStringFormattedValue(group) {
      XCTAssertEqual(d.0, "'Let it go, let it go'")
      XCTAssertEqual(d.conversion, .repr)
      XCTAssertEqual(d.spec, nil)
    }
  }

  func test_formattedValue_formatSpec() throws {
    var string = self.createFString()
    try string.appendFormatString("{'Let it go, let it go':^30}")

    let group = try string.compile()
    if let d = self.destructStringFormattedValue(group) {
      XCTAssertEqual(d.0, "'Let it go, let it go'")
      XCTAssertEqual(d.conversion, nil)
      XCTAssertEqual(d.spec, "^30")
    }
  }

  func test_formattedValue_conversion_formatSpec() throws {
    var string = self.createFString()
    try string.appendFormatString("{'Turn away and slam the door!'!a:^30}")

    let group = try string.compile()
    if let d = self.destructStringFormattedValue(group) {
      XCTAssertEqual(d.0, "'Turn away and slam the door!'")
      XCTAssertEqual(d.conversion, .ascii)
      XCTAssertEqual(d.spec, "^30")
    }
  }

  // MARK: - FString - joined

  func test_joined_expression_start() throws {
    var string = self.createFString()
    try string.appendFormatString("{I} don't care\nWhat they're going to say")

    let group = try string.compile()
    if let d = self.destructStringJoinedString(group) {
      XCTAssertEqual(d.count, 2)
      guard d.count == 2 else { return }

      guard let g0 = self.destructStringFormattedValue(d[0]) else { return }
      XCTAssertEqual(g0.0, "I")
      XCTAssertEqual(g0.conversion, nil)
      XCTAssertEqual(g0.spec, nil)

      guard let g1 = self.destructStringSimple(d[1]) else { return }
      XCTAssertEqual(g1, " don't care\nWhat they're going to say")
    }
  }

  func test_joined_expression_end() throws {
    var string = self.createFString()
    try string.appendFormatString("Let the storm rage {on}")

    let group = try string.compile()
    if let d = self.destructStringJoinedString(group) {
      XCTAssertEqual(d.count, 2)
      guard d.count == 2 else { return }

      guard let g0 = self.destructStringSimple(d[0]) else { return }
      XCTAssertEqual(g0, "Let the storm rage ")

      guard let g1 = self.destructStringFormattedValue(d[1]) else { return }
      XCTAssertEqual(g1.0, "on")
      XCTAssertEqual(g1.conversion, nil)
      XCTAssertEqual(g1.spec, nil)
    }
  }

  func test_joined_expression_middle() throws {
    var string = self.createFString()
    try string.appendFormatString("The cold never {bothered} me anyway!")

    let group = try string.compile()
    if let d = self.destructStringJoinedString(group) {
      XCTAssertEqual(d.count, 3)
      guard d.count == 3 else { return }

      guard let g0 = self.destructStringSimple(d[0]) else { return }
      XCTAssertEqual(g0, "The cold never ")

      guard let g1 = self.destructStringFormattedValue(d[1]) else { return }
      XCTAssertEqual(g1.0, "bothered")
      XCTAssertEqual(g1.conversion, nil)
      XCTAssertEqual(g1.spec, nil)

      guard let g2 = self.destructStringSimple(d[2]) else { return }
      XCTAssertEqual(g2, " me anyway!")
    }
  }

  func test_joined_expression_middle_conversion_formatSpec() throws {
    var string = self.createFString()
    try string.appendFormatString("Its funny {how!s:-10} some distance")

    let group = try string.compile()
    if let d = self.destructStringJoinedString(group) {
      XCTAssertEqual(d.count, 3)
      guard d.count == 3 else { return }

      guard let g0 = self.destructStringSimple(d[0]) else { return }
      XCTAssertEqual(g0, "Its funny ")

      guard let g1 = self.destructStringFormattedValue(d[1]) else { return }
      XCTAssertEqual(g1.0, "how")
      XCTAssertEqual(g1.conversion, .str)
      XCTAssertEqual(g1.spec, "-10")

      guard let g2 = self.destructStringSimple(d[2]) else { return }
      XCTAssertEqual(g2, " some distance")
    }
  }

  func test_joined_expressions_multiple() throws {
    var string = self.createFString()
    try string.appendFormatString("Makes {everything:+6} seem {small!a}")

    let group = try string.compile()
    if let d = self.destructStringJoinedString(group) {
      XCTAssertEqual(d.count, 4)
      guard d.count == 4 else { return }

      guard let g0 = self.destructStringSimple(d[0]) else { return }
      XCTAssertEqual(g0, "Makes ")

      guard let g1 = self.destructStringFormattedValue(d[1]) else { return }
      XCTAssertEqual(g1.0, "everything")
      XCTAssertEqual(g1.conversion, nil)
      XCTAssertEqual(g1.spec, "+6")

      guard let g2 = self.destructStringSimple(d[2]) else { return }
      XCTAssertEqual(g2, " seem ")

      guard let g3 = self.destructStringFormattedValue(d[3]) else { return }
      XCTAssertEqual(g3.0, "small")
      XCTAssertEqual(g3.conversion, .ascii)
      XCTAssertEqual(g3.spec, nil)
    }
  }

  func test_joined_expressions_sideBySide() throws {
    var string = self.createFString()
    try string.appendFormatString("And the {fears}{that} once controlled me")

    let group = try string.compile()
    if let d = self.destructStringJoinedString(group) {
      XCTAssertEqual(d.count, 4)
      guard d.count == 4 else { return }

      guard let g0 = self.destructStringSimple(d[0]) else { return }
      XCTAssertEqual(g0, "And the ")

      guard let g1 = self.destructStringFormattedValue(d[1]) else { return }
      XCTAssertEqual(g1.0, "fears")
      XCTAssertEqual(g1.conversion, nil)
      XCTAssertEqual(g1.spec, nil)

      guard let g2 = self.destructStringFormattedValue(d[2]) else { return }
      XCTAssertEqual(g2.0, "that")
      XCTAssertEqual(g2.conversion, nil)
      XCTAssertEqual(g2.spec, nil)

      guard let g3 = self.destructStringSimple(d[3]) else { return }
      XCTAssertEqual(g3, " once controlled me")
    }
  }

  func test_joined_expression_unclosedString_throws() throws {
    let s = "{Can't get to me at all!}"

    do {
      var string = self.createFString()
      try string.appendFormatString(s)
      XCTAssert(false)
    } catch let error as FStringError {
      XCTAssertEqual(error, FStringError.unterminatedString)
    } catch {
      XCTAssert(false, "\(error)")
    }
  }

  func test_joined_expression_backslash_throws() throws {
    let s = "{Its time\\to see what I can do}"

    do {
      var string = self.createFString()
      try string.appendFormatString(s)
      XCTAssert(false)
    } catch let error as FStringError {
      XCTAssertEqual(error, FStringError.backslashInExpression)
    } catch {
      XCTAssert(false, "\(error)")
    }
  }

  func test_joined_expression_comment_throws() throws {
    let s = "{To test the limits #and break through}"

    do {
      var string = self.createFString()
      try string.appendFormatString(s)
      XCTAssert(false)
    } catch let error as FStringError {
      XCTAssertEqual(error, FStringError.commentInExpression)
    } catch {
      XCTAssert(false, "\(error)")
    }
  }

  func test_joined_expression_longString() throws {
    let s = "No right, no wrong, {'''no rules for me'''} Im free!"
    var string = self.createFString()
    try string.appendFormatString(s)

    let group = try string.compile()
    if let d = self.destructStringJoinedString(group) {
      XCTAssertEqual(d.count, 3)
      guard d.count == 3 else { return }

      guard let g0 = self.destructStringSimple(d[0]) else { return }
      XCTAssertEqual(g0, "No right, no wrong, ")

      guard let g1 = self.destructStringFormattedValue(d[1]) else { return }
      XCTAssertEqual(g1.0, "'''no rules for me'''")
      XCTAssertEqual(g1.conversion, nil)
      XCTAssertEqual(g1.spec, nil)

      guard let g2 = self.destructStringSimple(d[2]) else { return }
      XCTAssertEqual(g2, " Im free!")
    }
  }

  func test_joined_expression_unclosedParen_throws() throws {
    let s = "Let it go, {(let} it go"

    do {
      var string = self.createFString()
      try string.appendFormatString(s)
      XCTAssert(false)
    } catch let error as FStringError {
      XCTAssertEqual(error, FStringError.unexpectedEnd)
    } catch {
      XCTAssert(false, "\(error)")
    }
  }

  // TODO: != in expression
  // TODO: parens
  // TODO: spaces before after expression

  // MARK: - Helpers

  private func createFString() -> FString {
    return FStringImpl()
  }
}
