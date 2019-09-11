import Foundation
import XCTest
import Core
import Lexer
@testable import Parser

private let e: UInt8 = 0x45 // it is 'E', but camelCase happened
private let l: UInt8 = 0x6c
private let s: UInt8 = 0x73
private let a: UInt8 = 0x61

class ParseString: XCTestCase, Common, ExpressionMatcher, StringMatcher {

  // MARK: - Bytes

  func test_bytes() {
    let data = Data([e, l, s, a])

    var parser = self.createExprParser(
      self.token(.bytes(data), start: loc0, end: loc1)
    )

    if let expr = self.parseExpr(&parser) {
      XCTAssertExpression(expr, "(bytes count:4)")
      XCTAssertEqual(expr.kind,  .bytes(data))
      XCTAssertEqual(expr.start, loc0)
      XCTAssertEqual(expr.end,   loc1)
    }
  }

  func test_bytes_concat() {
    let el = Data([e, l])
    let sa = Data([s, a])

    var parser = self.createExprParser(
      self.token(.bytes(el), start: loc0, end: loc1),
      self.token(.bytes(sa), start: loc2, end: loc3)
    )

    if let expr = self.parseExpr(&parser) {
      XCTAssertExpression(expr, "(bytes count:4)")
      XCTAssertEqual(expr.kind,  .bytes(el + sa))
      XCTAssertEqual(expr.start, loc0)
      XCTAssertEqual(expr.end,   loc3)
    }
  }

  func test_bytes_concatWithString_throws() {
    let data = Data(repeating: 1, count: 2)

    var parser = self.createExprParser(
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

    var parser = self.createExprParser(
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
    var parser = self.createExprParser(
      self.token(.string("Let it go"), start: loc0, end: loc1)
    )

    if let expr = self.parseExpr(&parser) {
      guard let group = self.matchString(expr) else { return }
      guard let groupStr = self.matchStringLiteral(group) else { return }
      XCTAssertEqual(groupStr, "Let it go")

      XCTAssertExpression(expr, "'Let it go'")
      XCTAssertEqual(expr.start, loc0)
      XCTAssertEqual(expr.end,   loc1)
    }
  }

  func test_string_concat() {
    var parser = self.createExprParser(
      self.token(.string("Let "), start: loc0, end: loc1),
      self.token(.string("it "),  start: loc2, end: loc3),
      self.token(.string("go"),   start: loc4, end: loc5)
    )

    if let expr = self.parseExpr(&parser) {
      guard let group = self.matchString(expr) else { return }
      guard let groupStr = self.matchStringLiteral(group) else { return }
      XCTAssertEqual(groupStr, "Let it go")

      XCTAssertExpression(expr, "'Let it go'")
      XCTAssertEqual(expr.start, loc0)
      XCTAssertEqual(expr.end,   loc5)
    }
  }

  func test_fstring() throws {
    var parser = self.createExprParser(
      self.token(.formatString("Let {'it'} go"), start: loc0, end: loc1)
    )

    if let expr = self.parseExpr(&parser) {
      guard let group = self.matchString(expr) else { return }
      guard let joined = self.matchStringJoined(group) else { return }

      XCTAssertEqual(joined.count, 3)
      guard joined.count == 3 else { return }

      guard let str0 = self.matchStringLiteral(joined[0]) else { return }
      XCTAssertEqual(str0, "Let ")

      guard let value1 = self.matchStringFormattedValue(joined[1]) else { return }
      guard let value1Group = self.matchString(value1.0) else { return }
      guard let value1Str = self.matchStringLiteral(value1Group) else { return }
      XCTAssertEqual(value1Str, "it")
      XCTAssertEqual(value1.conversion, nil)
      XCTAssertEqual(value1.spec, nil)

      guard let str2 = self.matchStringLiteral(joined[2]) else { return }
      XCTAssertEqual(str2, " go")

      XCTAssertExpression(expr, "('Let ' f''it'' ' go')")
      XCTAssertEqual(expr.start, loc0)
      XCTAssertEqual(expr.end,   loc1)
    }
  }

  // swiftlint:disable:next function_body_length cyclomatic_complexity
  func test_fstring_concat() throws {
    var parser = self.createExprParser(
      self.token(.string("Let "),          start: loc0, end: loc1),
      self.token(.formatString("{'it'}"),  start: loc2, end: loc3),
      self.token(.formatString(" {'go'}"), start: loc4, end: loc5)
    )

    if let expr = self.parseExpr(&parser) {
      guard let group = self.matchString(expr) else { return }
      guard let joined = self.matchStringJoined(group) else { return }

      XCTAssertEqual(joined.count, 4)
      guard joined.count == 4 else { return }

      guard let str0 = self.matchStringLiteral(joined[0]) else { return }
      XCTAssertEqual(str0, "Let ")

      guard let value1 = self.matchStringFormattedValue(joined[1]) else { return }
      guard let value1Group = self.matchString(value1.0) else { return }
      guard let value1Str = self.matchStringLiteral(value1Group) else { return }
      XCTAssertEqual(value1Str, "it")
      XCTAssertEqual(value1.conversion, nil)
      XCTAssertEqual(value1.spec, nil)

      guard let str2 = self.matchStringLiteral(joined[2]) else { return }
      XCTAssertEqual(str2, " ")

      guard let value3 = self.matchStringFormattedValue(joined[3]) else { return }
      guard let value3Group = self.matchString(value3.0) else { return }
      guard let value3str = self.matchStringLiteral(value3Group) else { return }
      XCTAssertEqual(value3str, "go")
      XCTAssertEqual(value3.conversion, nil)
      XCTAssertEqual(value3.spec, nil)

      XCTAssertExpression(expr, "('Let ' f''it'' ' ' f''go'')")
      XCTAssertEqual(expr.start, loc0)
      XCTAssertEqual(expr.end,   loc5)
    }
  }

  func test_fstring_error() throws {
    // Unclosed f-string
    var parser = self.createExprParser(
      self.token(.formatString("Let it go {"), start: loc0, end: loc1)
    )

    if let error = self.error(&parser) {
      XCTAssertEqual(error.kind, .fStringError(.unexpectedEnd))
      XCTAssertEqual(error.location, loc0)
    }
  }

  func test_string_concatWithBytes_throws() {
    var parser = self.createExprParser(
      self.token(.string("Let it go"), start: loc0, end: loc1),
      self.token(.bytes(Data()),       start: loc2, end: loc3)
    )

    if let error = self.error(&parser) {
      XCTAssertEqual(error.kind, .mixBytesAndNonBytesLiterals)
      XCTAssertEqual(error.location, loc2)
    }
  }
}
