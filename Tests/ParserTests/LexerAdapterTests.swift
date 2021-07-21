import XCTest
import VioletCore
import VioletLexer
@testable import VioletParser

// cSpell:ignore Cojones

// MARK: - Assert

private func XCTAssertTokens(_ adapter: inout LexerAdapter,
                             _ expected: [Token.Kind],
                             file: StaticString = #file,
                             line: UInt = #line) {
  do {
    let tokens = try consume(adapter: &adapter)
    XCTAssertEqual(tokens.count, expected.count, "Count", file: file, line: line)

    for (index, (t, e)) in zip(tokens, expected).enumerated() {
      XCTAssertEqual(t.kind, e, "Index: \(index)", file: file, line: line)
    }
  } catch {
    XCTAssert(false, "\(error)", file: file, line: line)
  }
}

private func consume(adapter: inout LexerAdapter,
                     file: StaticString = #file,
                     line: UInt = #line) throws -> [Token] {
  try adapter.populatePeeks()

  var result = [Token]()
  while true {
    let token = adapter.peek

    switch token.kind {
    case .eof:
      return result // do not include 'eof'.
    default:
      result.append(token)
      try adapter.advance()
    }
  }
}

// MARK: - Tests

// Lyrics taken from:
// https://www.youtube.com/watch?v=QWnDwM0RSX4
class LexerAdapterTests: XCTestCase {

  // MARK: - Init

  func test_populatePeeks_withEOF_as1stToken() {
    var adapter = self.createAdapter(tokens: [])
    XCTAssertTokens(&adapter, [])
  }

  func test_populatePeeks_withEOF_as2ndToken() {
    var adapter = self.createAdapter(tokens: [
      self.token(.string("Galavant"))
    ])

    XCTAssertTokens(&adapter, [
      .string("Galavant")
    ])
  }

  func test_populatePeeks_ignoresComments() {
    var adapter = self.createAdapter(tokens: [
      self.token(.newLine),
      self.token(.comment("Way back in days of old")),
      self.token(.newLine),
      self.token(.string("There was a legend told"))
    ])

    XCTAssertTokens(&adapter, [
      .newLine,
      .newLine,
      .string("There was a legend told")
    ])
  }

  // MARK: - Advance

  /// code [new line]
  /// [new line]
  /// code
  ///
  /// Should give us:
  /// code [new line]
  /// code
  func test_advance_ignoresSubsequentNewLines() {
    var adapter = self.createAdapter(tokens: [
      self.token(.string("About a hero known as Galavant")),
      self.token(.newLine),
      self.token(.newLine),
      self.token(.string("Square jaw and perfect hair..."))
    ])

    XCTAssertTokens(&adapter, [
      .string("About a hero known as Galavant"),
      .newLine,
      .string("Square jaw and perfect hair...")
    ])
  }

  /// code [new line]
  /// [comment][new line]
  /// code
  ///
  /// Should give us:
  /// code [new line]
  /// code
  func test_advance_ignoresSubsequentLines_withComment() {
    var adapter = self.createAdapter(tokens: [
      self.token(.string("Cojones out to there...")),
      self.token(.newLine),
      self.token(.comment("There was no hero quite like Galavant")),
      self.token(.newLine),
      self.token(.string("Tough, plus every other manly value..."))
    ])

    XCTAssertTokens(&adapter, [
      .string("Cojones out to there..."),
      .newLine,
      .string("Tough, plus every other manly value...")
    ])
  }

  /// code [new line]
  /// [new line]
  /// [comment][new line]
  /// [new line]
  /// code
  ///
  /// Should give us:
  /// code [new line]
  /// code
  func test_advance_ignoresSubsequentLines_withComment_orNewLine() {
    var adapter = self.createAdapter(tokens: [
      self.token(.string("Mess with him, he'll disembowel you.")),
      self.token(.newLine),
      self.token(.newLine),
      self.token(.comment("Yay! He ruled in every way!")),
      self.token(.newLine),
      self.token(.newLine),
      self.token(.string("A fairy tale cliché!"))
    ])

    XCTAssertTokens(&adapter, [
      .string("Mess with him, he'll disembowel you."),
      .newLine,
      .string("A fairy tale cliché!")
    ])
  }

  // MARK: - Helper

  private func createAdapter(tokens: [Token]) -> LexerAdapter {
    let lexer = FakeLexer(tokens: tokens)
    return LexerAdapter(lexer: lexer)
  }

  private func token(_ kind: Token.Kind) -> Token {
    return Token(kind, start: loc0, end: loc0)
  }
}
