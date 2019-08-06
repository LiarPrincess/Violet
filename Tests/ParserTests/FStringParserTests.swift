import Foundation
import XCTest
import Core
import Lexer
@testable import Parser

// Use this for reference:
// https://www.youtube.com/watch?v=BTBaUHSi-xk
// The beginning it rather discouraging, but it gets easier later.

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
    try string.appendFString(s)

    let group = try string.compile()
    if let result = self.destructStringSimple(group) {
      XCTAssertEqual(result, s)
    }
  }

  func test_literal_withEscapes() throws {
    let s = "Couldn't keep {{it}} in, heaven knows I tried!"
    let expected = "Couldn't keep {it} in, heaven knows I tried!"

    var string = self.createFString()
    try string.appendFString(s)

    let group = try string.compile()
    if let result = self.destructStringSimple(group) {
      XCTAssertEqual(result, expected)
    }
  }

  func test_literal_withUnclosedEscapeAtEnd_throws() throws {
    let s = "Don't let them in, don't let them see{"

    do {
      var string = self.createFString()
      try string.appendFString(s)
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
      try string.appendFString(s)
      XCTAssert(false)
    } catch let error as FStringError {
      XCTAssertEqual(error, FStringError.singleRightBrace)
    } catch {
      XCTAssert(false, "\(error)")
    }
  }

  func test_literal_conat() throws {
    var string = self.createFString()
    try string.appendFString("Conceal, don't feel, don't let them know\n")
    try string.appendFString("Well, now they know!")

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

//  func test_formattedValue() throws {
//    var string = self.createFString()
//    try string.appendFString("{2013}")

//    let expected = """
//      Conceal, don't feel, don't let them know
//      Well, now they know!
//      """
//
//    let group = try string.compile()
//    if let result = self.destructStringSimple(group) {
//      XCTAssertEqual(result, expected)
//    }
//  }

  // test_formattedValue_string
  // spaces before after
  // parens

  // start
  // middle
  // end

  // MARK: - Helpers

  private func createFString() -> FString {
    return FStringImpl()
  }
}
