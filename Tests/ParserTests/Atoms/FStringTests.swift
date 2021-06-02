import XCTest
import Foundation
import VioletCore
import VioletLexer
@testable import VioletParser

// Use this for reference:
// https://www.youtube.com/watch?v=BTBaUHSi-xk
// The beginning it rather discouraging, but it gets easier later.

// swiftlint:disable file_length

class FStringTests: XCTestCase {

  // MARK: - Empty

  func test_empty() throws {
    var string = self.createFString()

    let group = try string.compile()

    XCTAssertString(group, """
    String: ''
    """)
  }

  // MARK: - String

  func test_string() throws {
    let s = "The snow glows white on the mountain tonight"

    var string = self.createFString()
    string.append(s)

    let group = try string.compile()

    XCTAssertString(group, """
    String: 'The snow glows white on the mountain tonight'
    """)
  }

  func test_string_multiline() throws {
    var string = self.createFString()
    string.append("Not a footprint to be seen\n")
    string.append("A kingdom of isolation\n")
    string.append("And it looks like I'm the queen")

    let group = try string.compile()

    XCTAssertString(group, """
    String: 'Not a footprint to be seen\\nA kingdom of isolation\\nAnd it lo...'
    """)
  }

  // MARK: - FString - without expr

  func test_fString_withoutExpr() throws {
    let s = "The wind is howling like this swirling storm inside"

    var string = self.createFString()
    try string.appendFormatString(s)

    let group = try string.compile()

    XCTAssertString(group, """
    String: 'The wind is howling like this swirling storm inside'
    """)
  }

  func test_fString_withoutExpr_withEscapes() throws {
    let s = "Couldn't keep {{it}} in, heaven knows I tried!"

    var string = self.createFString()
    try string.appendFormatString(s)

    let group = try string.compile()

    XCTAssertString(group, """
    String: 'Couldn't keep {it} in, heaven knows I tried!'
    """)
  }

  func test_fString_withoutExpr_withUnclosedEscape_throws() throws {
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

  func test_fString_withoutExpr_withSingleRightBrace_throws() throws {
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

  func test_fString_withoutExpr_multiple() throws {
    var string = self.createFString()
    try string.appendFormatString("Conceal, don't feel, don't let them know\n")
    try string.appendFormatString("Well, now they know!")

    let group = try string.compile()

    XCTAssertString(group, """
    String: 'Conceal, don't feel, don't let them know\\nWell, now they know...'
    """)
  }

  // MARK: - Formatted value

  func test_formattedValue() throws {
    var string = self.createFString()
    try string.appendFormatString("{2013}")

    let group = try string.compile()

    XCTAssertString(group, """
    Formatted string
      IntExpr(context: Load, start: 1:0, end: 1:4)
        Value: 2013
      Conversion: none
      Spec: none
    """)
  }

  func test_formattedValue_addition() throws {
    var string = self.createFString()
    try string.appendFormatString("{20 + 13}")

    let group = try string.compile()

    XCTAssertString(group, """
    Formatted string
      BinaryOpExpr(context: Load, start: 1:0, end: 1:7)
        Operator: +
        Left
          IntExpr(context: Load, start: 1:0, end: 1:2)
            Value: 20
        Right
          IntExpr(context: Load, start: 1:5, end: 1:7)
            Value: 13
      Conversion: none
      Spec: none
    """)
  }

  func test_formattedValue_string() throws {
    var string = self.createFString()
    try string.appendFormatString("{'Let it go, let it go'}")

    let group = try string.compile()

    XCTAssertString(group, """
    Formatted string
      StringExpr(context: Load, start: 1:0, end: 1:22)
        String: 'Let it go, let it go'
      Conversion: none
      Spec: none
    """)
  }

  func test_formattedValue_inParens() throws {
    var string = self.createFString()
    try string.appendFormatString("{('Cant hold it back anymore')}")

    let group = try string.compile()

    XCTAssertString(group, """
    Formatted string
      StringExpr(context: Load, start: 1:0, end: 1:29)
        String: 'Cant hold it back anymore'
      Conversion: none
      Spec: none
    """)
  }

  func test_formattedValue_conversion() throws {
    var string = self.createFString()
    try string.appendFormatString("{'Let it go, let it go'!r}")

    let group = try string.compile()

    XCTAssertString(group, """
    Formatted string
      StringExpr(context: Load, start: 1:0, end: 1:22)
        String: 'Let it go, let it go'
      Conversion: repr
      Spec: none
    """)
  }

  func test_formattedValue_formatSpec() throws {
    var string = self.createFString()
    try string.appendFormatString("{'Let it go, let it go':^30}")

    let group = try string.compile()

    XCTAssertString(group, """
    Formatted string
      StringExpr(context: Load, start: 1:0, end: 1:22)
        String: 'Let it go, let it go'
      Conversion: none
      Spec: ^30
    """)
  }

  func test_formattedValue_conversion_formatSpec() throws {
    var string = self.createFString()
    try string.appendFormatString("{'Turn away and slam the door!'!a:^30}")

    let group = try string.compile()

    XCTAssertString(group, """
    Formatted string
      StringExpr(context: Load, start: 1:0, end: 1:30)
        String: 'Turn away and slam the door!'
      Conversion: ascii
      Spec: ^30
    """)
  }

  // MARK: - FString - joined

  func test_joined_expression_atStart() throws {
    var string = self.createFString()
    try string.appendFormatString("{I} don't care\nWhat they're going to say")

    let group = try string.compile()

    XCTAssertString(group, """
    Joined string
      Formatted string
        IdentifierExpr(context: Load, start: 1:0, end: 1:1)
          Value: I
        Conversion: none
        Spec: none
      String: ' don't care\nWhat they're going to say'
    """)
  }

  func test_joined_expression_asEnd() throws {
    var string = self.createFString()
    try string.appendFormatString("Let the storm rage {on}")

    let group = try string.compile()

    XCTAssertString(group, """
    Joined string
      String: 'Let the storm rage '
      Formatted string
        IdentifierExpr(context: Load, start: 1:0, end: 1:2)
          Value: on
        Conversion: none
        Spec: none
    """)
  }

  func test_joined_expression_inTheMiddle() throws {
    var string = self.createFString()
    try string.appendFormatString("The cold never {bothered} me anyway!")

    let group = try string.compile()

    XCTAssertString(group, """
    Joined string
      String: 'The cold never '
      Formatted string
        IdentifierExpr(context: Load, start: 1:0, end: 1:8)
          Value: bothered
        Conversion: none
        Spec: none
      String: ' me anyway!'
    """)
  }

  func test_joined_expression_inTheMiddle_withConversion_andFormatSpec() throws {
    var string = self.createFString()
    try string.appendFormatString("Its funny {how!s:-10} some distance")

    let group = try string.compile()

    XCTAssertString(group, """
    Joined string
      String: 'Its funny '
      Formatted string
        IdentifierExpr(context: Load, start: 1:0, end: 1:3)
          Value: how
        Conversion: str
        Spec: -10
      String: ' some distance'
    """)
  }

  func test_joined_expressions_multiple() throws {
    var string = self.createFString()
    try string.appendFormatString("Makes {everything:+6} seem {small!a}")

    let group = try string.compile()

    XCTAssertString(group, """
    Joined string
      String: 'Makes '
      Formatted string
        IdentifierExpr(context: Load, start: 1:0, end: 1:10)
          Value: everything
        Conversion: none
        Spec: +6
      String: ' seem '
      Formatted string
        IdentifierExpr(context: Load, start: 1:0, end: 1:5)
          Value: small
        Conversion: ascii
        Spec: none
    """)
  }

  func test_joined_expressions_sideBySide() throws {
    var string = self.createFString()
    try string.appendFormatString("And the {fears}{that} once controlled me")

    let group = try string.compile()

    XCTAssertString(group, """
    Joined string
      String: 'And the '
      Formatted string
        IdentifierExpr(context: Load, start: 1:0, end: 1:5)
          Value: fears
        Conversion: none
        Spec: none
      Formatted string
        IdentifierExpr(context: Load, start: 1:0, end: 1:4)
          Value: that
        Conversion: none
        Spec: none
      String: ' once controlled me'
    """)
  }

  func test_joined_unclosedString_throws() throws {
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

  func test_joined_expression_withBackslash_throws() throws {
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

  func test_joined_expression_withComment_throws() throws {
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

  func test_joined_longString() throws {
    let s = "No right, no wrong, {'''no rules for me'''} Im free!"
    var string = self.createFString()
    try string.appendFormatString(s)

    let group = try string.compile()

    XCTAssertString(group, """
    Joined string
      String: 'No right, no wrong, '
      Formatted string
        StringExpr(context: Load, start: 1:0, end: 1:21)
          String: 'no rules for me'
        Conversion: none
        Spec: none
      String: ' Im free!'
    """)
  }

  func test_joined_single_unclosedParen_throws_unexpectedEnd() throws {
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

  func test_joined_double_unclosedParen_throws_mismatchedParen() throws {
    let s = "I am one with the {((wind} and sky"

    do {
      var string = self.createFString()
      try string.appendFormatString(s)
      XCTAssert(false)
    } catch let error as FStringError {
      XCTAssertEqual(error, FStringError.mismatchedParen)
    } catch {
      XCTAssert(false, "\(error)")
    }
  }

  func test_joined_expression_empty_throws() throws {
    let s = "Let it go,{}let it go"

    do {
      var string = self.createFString()
      try string.appendFormatString(s)
      XCTAssert(false)
    } catch let error as FStringError {
      XCTAssertEqual(error, FStringError.emptyExpression)
    } catch {
      XCTAssert(false, "\(error)")
    }
  }

  func test_joined_unclosedLongString_throws() throws {
    let s = "You'll never {'''see me cry!'"

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

  func test_joined_invalidConversion_throws() throws {
    let s = "Here {I!e} stand"

    do {
      var string = self.createFString()
      try string.appendFormatString(s)
      XCTAssert(false)
    } catch let error as FStringError {
      XCTAssertEqual(error, FStringError.invalidConversion("e"))
    } catch {
      XCTAssert(false, "\(error)")
    }
  }

  func test_joined_formatString_withNestedExpression_throws() throws {
    let s = "And here I'll {stay:>{width}}"

    do {
      var string = self.createFString()
      try string.appendFormatString(s)
      XCTAssert(false)
    } catch let e where self.is_expressionInFStringFormatSpecifier(error: e) {
      // Nothing, everything is ok.
    } catch {
      XCTAssert(false, "\(error)")
    }
  }

  private func is_expressionInFStringFormatSpecifier(error: Error) -> Bool {
    if case let FStringError.unimplemented(u) = error {
      return u == .expressionInFStringFormatSpecifier
    }

    return false
  }

  // MARK: - Create fstring

  private func createFString() -> FString {
    return FString(parserDelegate: nil, lexerDelegate: nil)
  }
}
