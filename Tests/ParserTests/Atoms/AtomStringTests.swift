import Foundation
import XCTest
import Core
import Lexer
@testable import Parser

private let e: UInt8 = 0x45 // it is 'E', but camelCase happened
private let l: UInt8 = 0x6c
private let s: UInt8 = 0x73
private let a: UInt8 = 0x61

class AtomStringTest: XCTestCase,
  Common, DestructExpressionKind, DestructStringGroup {

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
      guard let group = self.destructString(expr) else { return }
      guard let value = self.destructStringSimple(group) else { return }
      XCTAssertEqual(value, "Let it go")

      XCTAssertExpression(expr, "\"Let it go\"")
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
      guard let group = self.destructString(expr) else { return }
      guard let value = self.destructStringSimple(group) else { return }
      XCTAssertEqual(value, "Let it go")

      XCTAssertExpression(expr, "\"Let it go\"")
      XCTAssertEqual(expr.start, loc0)
      XCTAssertEqual(expr.end,   loc5)
    }
  }

  func test_fstring() throws {
    var parser = self.createExprParser(
      self.token(.formatString("Let {'it'} go"), start: loc0, end: loc1)
    )

    if let expr = self.parseExpr(&parser) {
      guard let group = self.destructString(expr) else { return }
      guard let d = self.destructStringJoinedString(group) else { return }

      XCTAssertEqual(d.count, 3)
      guard d.count == 3 else { return }

      guard let g0 = self.destructStringSimple(d[0]) else { return }
      XCTAssertEqual(g0, "Let ")

      guard let g1 = self.destructStringFormattedValue(d[1]) else { return }
      guard let g1s = self.destructString(g1.0) else { return }
      guard let g1value = self.destructStringSimple(g1s) else { return }
      XCTAssertEqual(g1value, "it")
      XCTAssertEqual(g1.conversion, nil)
      XCTAssertEqual(g1.spec, nil)

      guard let g2 = self.destructStringSimple(d[2]) else { return }
      XCTAssertEqual(g2, " go")

      // ("Let " f""it"" " go")
      XCTAssertExpression(expr, "(\"Let \" f\"\"it\"\" \" go\")")
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
      guard let group = self.destructString(expr) else { return }
      guard let d = self.destructStringJoinedString(group) else { return }

      XCTAssertEqual(d.count, 4)
      guard d.count == 4 else { return }

      guard let g0 = self.destructStringSimple(d[0]) else { return }
      XCTAssertEqual(g0, "Let ")

      guard let g1 = self.destructStringFormattedValue(d[1]) else { return }
      guard let g1s = self.destructString(g1.0) else { return }
      guard let g1value = self.destructStringSimple(g1s) else { return }
      XCTAssertEqual(g1value, "it")
      XCTAssertEqual(g1.conversion, nil)
      XCTAssertEqual(g1.spec, nil)

      guard let g2 = self.destructStringSimple(d[2]) else { return }
      XCTAssertEqual(g2, " ")

      guard let g3 = self.destructStringFormattedValue(d[3]) else { return }
      guard let g3s = self.destructString(g3.0) else { return }
      guard let g3value = self.destructStringSimple(g3s) else { return }
      XCTAssertEqual(g3value, "go")
      XCTAssertEqual(g3.conversion, nil)
      XCTAssertEqual(g3.spec, nil)

      // ("Let " f""it"" " " f""go"")
      XCTAssertExpression(expr, "(\"Let \" f\"\"it\"\" \" \" f\"\"go\"\")")
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
