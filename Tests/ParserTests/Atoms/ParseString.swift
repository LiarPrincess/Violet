import XCTest
import Foundation
import VioletCore
import VioletLexer
@testable import VioletParser

// swiftformat:disable consecutiveSpaces

private let e: UInt8 = 0x45 // it is 'E'
private let l: UInt8 = 0x6c
private let s: UInt8 = 0x73
private let a: UInt8 = 0x61

class ParseString: XCTestCase {

  // MARK: - Bytes

  func test_bytes() {
    let data = Data([e, l, s, a])

    let parser = createExprParser(
      createToken(.bytes(data), start: loc0, end: loc1)
    )

    guard let ast = parse(parser) else { return }

    XCTAssertAST(ast, """
    ExpressionAST(start: 0:0, end: 1:6)
      BytesExpr(context: Load, start: 0:0, end: 1:6)
        Count: 4
    """)
  }

  func test_bytes_concat() {
    let el = Data([e, l])
    let sa = Data([s, a])

    let parser = createExprParser(
      createToken(.bytes(el), start: loc0, end: loc1),
      createToken(.bytes(sa), start: loc2, end: loc3)
    )

    guard let ast = parse(parser) else { return }

    XCTAssertAST(ast, """
    ExpressionAST(start: 0:0, end: 3:8)
      BytesExpr(context: Load, start: 0:0, end: 3:8)
        Count: 4
    """)
  }

  func test_bytes_concatWithString_throws() {
    let data = Data(repeating: 1, count: 2)

    let parser = createExprParser(
      createToken(.bytes(data), start: loc0, end: loc1),
      createToken(.string("Let It Go"), start: loc2, end: loc3)
    )

    if let error = parseError(parser) {
      XCTAssertEqual(error.kind, .mixBytesAndNonBytesLiterals)
      XCTAssertEqual(error.location, loc2)
    }
  }

  func test_bytes_concatWithFormatString_throws() {
    let data = Data(repeating: 1, count: 2)

    let parser = createExprParser(
      createToken(.bytes(data), start: loc0, end: loc1),
      createToken(.formatString("Let It Go"), start: loc2, end: loc3)
    )

    if let error = parseError(parser) {
      XCTAssertEqual(error.kind, .mixBytesAndNonBytesLiterals)
      XCTAssertEqual(error.location, loc2)
    }
  }

  // MARK: - String

  func test_string() {
    let parser = createExprParser(
      createToken(.string("Let it go"), start: loc0, end: loc1)
    )

    guard let ast = parse(parser) else { return }

    XCTAssertAST(ast, """
    ExpressionAST(start: 0:0, end: 1:6)
      StringExpr(context: Load, start: 0:0, end: 1:6)
        String: 'Let it go'
    """)
  }

  func test_string_concat() {
    let parser = createExprParser(
      createToken(.string("Let "), start: loc0, end: loc1),
      createToken(.string("it "),  start: loc2, end: loc3),
      createToken(.string("go"),   start: loc4, end: loc5)
    )

    guard let ast = parse(parser) else { return }

    XCTAssertAST(ast, """
    ExpressionAST(start: 0:0, end: 5:10)
      StringExpr(context: Load, start: 0:0, end: 5:10)
        String: 'Let it go'
    """)
  }

  func test_fstring() throws {
    let parser = createExprParser(
      createToken(.formatString("Let {'it'} go"), start: loc0, end: loc1)
    )

    guard let ast = parse(parser) else { return }

    XCTAssertAST(ast, """
    ExpressionAST(start: 0:0, end: 1:6)
      StringExpr(context: Load, start: 0:0, end: 1:6)
        Joined string
          String: 'Let '
          Formatted string
            StringExpr(context: Load, start: 1:0, end: 1:4)
              String: 'it'
            Conversion: none
            Spec: none
          String: ' go'
    """)
  }

  func test_fstring_concat() throws {
    let parser = createExprParser(
      createToken(.string("Let "),          start: loc0, end: loc1),
      createToken(.formatString("{'it'}"),  start: loc2, end: loc3),
      createToken(.formatString(" {'go'}"), start: loc4, end: loc5)
    )

    guard let ast = parse(parser) else { return }

    XCTAssertAST(ast, """
    ExpressionAST(start: 0:0, end: 5:10)
      StringExpr(context: Load, start: 0:0, end: 5:10)
        Joined string
          String: 'Let '
          Formatted string
            StringExpr(context: Load, start: 1:0, end: 1:4)
              String: 'it'
            Conversion: none
            Spec: none
          String: ' '
          Formatted string
            StringExpr(context: Load, start: 1:0, end: 1:4)
              String: 'go'
            Conversion: none
            Spec: none
    """)
  }

  func test_fstring_error() throws {
    // Unclosed f-string
    let parser = createExprParser(
      createToken(.formatString("Let it go {"), start: loc0, end: loc1)
    )

    if let error = parseError(parser) {
      XCTAssertEqual(error.kind, .fStringError(.unexpectedEnd))
      XCTAssertEqual(error.location, loc0)
    }
  }

  func test_string_concatWithBytes_throws() {
    let parser = createExprParser(
      createToken(.string("Let it go"), start: loc0, end: loc1),
      createToken(.bytes(Data()),       start: loc2, end: loc3)
    )

    if let error = parseError(parser) {
      XCTAssertEqual(error.kind, .mixBytesAndNonBytesLiterals)
      XCTAssertEqual(error.location, loc2)
    }
  }
}
