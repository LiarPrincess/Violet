import Foundation
import XCTest
import Core
import Lexer
@testable import Parser

// Use this for song reference:
// https://www.youtube.com/watch?v=BTBaUHSi-xk

private let e: UInt8 = 0x45 // it is 'E', but camelCase happened
private let l: UInt8 = 0x6c
private let s: UInt8 = 0x73
private let a: UInt8 = 0x61

class AtomStringTest: XCTestCase, Common,
  DestructExpressionKind, DestructStringGroup {

  // MARK: - Bytes

  func test_bytes() {
    let data = Data([e, l, s, a])

    var parser = self.parser(
      self.token(.bytes(data), start: loc0, end: loc1)
    )

    if let expr = self.parse(&parser) {
      XCTAssertExpression(expr, "(bytes count:4)")
      XCTAssertEqual(expr.kind,  .bytes(data))
      XCTAssertEqual(expr.start, loc0)
      XCTAssertEqual(expr.end,   loc1)
    }
  }

  func test_bytes_concat() {
    let el = Data([e, l])
    let sa = Data([s, a])

    var parser = self.parser(
      self.token(.bytes(el), start: loc0, end: loc1),
      self.token(.bytes(sa), start: loc2, end: loc3)
    )

    if let expr = self.parse(&parser) {
      XCTAssertExpression(expr, "(bytes count:4)")
      XCTAssertEqual(expr.kind,  .bytes(el + sa))
      XCTAssertEqual(expr.start, loc0)
      XCTAssertEqual(expr.end,   loc3)
    }
  }

  func test_bytes_concatWithString_throws() {
    let data = Data(repeating: 1, count: 2)

    var parser = self.parser(
      self.token(.bytes(data), start: loc0, end: loc1),
      self.token(.string("Let It Go"), start: loc2, end: loc3)
    )

    if let error = self.error(&parser) {
      XCTAssertEqual(error.kind, .mixBytesAndNonBytesLiterals)
      XCTAssertEqual(error.location, loc2)
    }
  }

  func test_bytes_concatWithFormatString_throws() {
    let data = Data(repeating: 1, count: 2)

    var parser = self.parser(
      self.token(.bytes(data), start: loc0, end: loc1),
      self.token(.formatString("Let It Go"), start: loc2, end: loc3)
    )

    if let error = self.error(&parser) {
      XCTAssertEqual(error.kind, .mixBytesAndNonBytesLiterals)
      XCTAssertEqual(error.location, loc2)
    }
  }

  // MARK: - String

  func test_string() {
    let s = "The snow glows white on the mountain tonight"

    var parser = self.parser(
      self.token(.string(s), start: loc0, end: loc1)
    )

    if let expr = self.parse(&parser) {
      guard let value = self.destructStringSimple(expr) else { return }
      XCTAssertEqual(value, s)

      XCTAssertExpression(expr, "\"The snow g...\"")
      XCTAssertEqual(expr.start, loc0)
      XCTAssertEqual(expr.end,   loc1)
    }
  }

  func test_string_concat() {
    let s0 = "Not a footprint to be seen\n"
    let s1 = "A kingdom of isolation\n"
    let s2 = "And it looks like I'm the queen"

    var parser = self.parser(
      self.token(.string(s0), start: loc0, end: loc1),
      self.token(.string(s1), start: loc2, end: loc3),
      self.token(.string(s2), start: loc4, end: loc5)
    )

    if let expr = self.parse(&parser) {
      let expected = """
      Not a footprint to be seen
      A kingdom of isolation
      And it looks like I'm the queen
      """

      guard let value = self.destructStringSimple(expr) else { return }
      XCTAssertEqual(value, expected)

      XCTAssertExpression(expr, "\"Not a foot...\"")
      XCTAssertEqual(expr.start, loc0)
      XCTAssertEqual(expr.end,   loc5)
    }
  }

  func test_string_concatWithBytes_throws() {
    let s = "The wind is howling like this swirling storm inside"

    var parser = self.parser(
      self.token(.string(s),     start: loc0, end: loc1),
      self.token(.bytes(Data()), start: loc2, end: loc3)
    )

    if let error = self.error(&parser) {
      XCTAssertEqual(error.kind, .mixBytesAndNonBytesLiterals)
      XCTAssertEqual(error.location, loc2)
    }
  }
}
