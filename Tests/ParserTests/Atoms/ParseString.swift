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

class ParseString: XCTestCase, Common {

  // MARK: - Bytes

  func test_bytes() {
    let data = Data([e, l, s, a])

    let parser = self.createExprParser(
      self.token(.bytes(data), start: loc0, end: loc1)
    )

    guard let ast = self.parse(parser) else { return }

    XCTAssertAST(ast, """
    ExpressionAST(start: 0:0, end: 1:6)
      BytesExpr(context: Load, start: 0:0, end: 1:6)
        Count: 4
    """)
  }

  func test_bytes_concat() {
    let el = Data([e, l])
    let sa = Data([s, a])

    let parser = self.createExprParser(
      self.token(.bytes(el), start: loc0, end: loc1),
      self.token(.bytes(sa), start: loc2, end: loc3)
    )

    guard let ast = self.parse(parser) else { return }

    XCTAssertAST(ast, """
    ExpressionAST(start: 0:0, end: 3:8)
      BytesExpr(context: Load, start: 0:0, end: 3:8)
        Count: 4
    """)
  }

  func test_bytes_concatWithString_throws() {
    let data = Data(repeating: 1, count: 2)

    let parser = self.createExprParser(
      self.token(.bytes(data), start: loc0, end: loc1),
      self.token(.string("Let It Go"), start: loc2, end: loc3)
    )

    if let error = self.error(parser) {
      XCTAssertEqual(error.kind, .mixBytesAndNonBytesLiterals)
      XCTAssertEqual(error.location, loc2)
    }
  }

  func test_bytes_concatWithFormatString_throws() {
    let data = Data(repeating: 1, count: 2)

    let parser = self.createExprParser(
      self.token(.bytes(data), start: loc0, end: loc1),
      self.token(.formatString("Let It Go"), start: loc2, end: loc3)
    )

    if let error = self.error(parser) {
      XCTAssertEqual(error.kind, .mixBytesAndNonBytesLiterals)
      XCTAssertEqual(error.location, loc2)
    }
  }

  // MARK: - String

  func test_string() {
    let parser = self.createExprParser(
      self.token(.string("Let it go"), start: loc0, end: loc1)
    )

    guard let ast = self.parse(parser) else { return }

    XCTAssertAST(ast, """
    ExpressionAST(start: 0:0, end: 1:6)
      StringExpr(context: Load, start: 0:0, end: 1:6)
        String: 'Let it go'
    """)
  }

  func test_string_concat() {
    let parser = self.createExprParser(
      self.token(.string("Let "), start: loc0, end: loc1),
      self.token(.string("it "),  start: loc2, end: loc3),
      self.token(.string("go"),   start: loc4, end: loc5)
    )

    guard let ast = self.parse(parser) else { return }

    XCTAssertAST(ast, """
    ExpressionAST(start: 0:0, end: 5:10)
      StringExpr(context: Load, start: 0:0, end: 5:10)
        String: 'Let it go'
    """)
  }

  func test_fstring() throws {
    let parser = self.createExprParser(
      self.token(.formatString("Let {'it'} go"), start: loc0, end: loc1)
    )

    guard let ast = self.parse(parser) else { return }

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
    let parser = self.createExprParser(
      self.token(.string("Let "),          start: loc0, end: loc1),
      self.token(.formatString("{'it'}"),  start: loc2, end: loc3),
      self.token(.formatString(" {'go'}"), start: loc4, end: loc5)
    )

    guard let ast = self.parse(parser) else { return }

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
    let parser = self.createExprParser(
      self.token(.formatString("Let it go {"), start: loc0, end: loc1)
    )

    if let error = self.error(parser) {
      XCTAssertEqual(error.kind, .fStringError(.unexpectedEnd))
      XCTAssertEqual(error.location, loc0)
    }
  }

  func test_string_concatWithBytes_throws() {
    let parser = self.createExprParser(
      self.token(.string("Let it go"), start: loc0, end: loc1),
      self.token(.bytes(Data()),       start: loc2, end: loc3)
    )

    if let error = self.error(parser) {
      XCTAssertEqual(error.kind, .mixBytesAndNonBytesLiterals)
      XCTAssertEqual(error.location, loc2)
    }
  }
}
