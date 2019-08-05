import XCTest
import Core
import Lexer
@testable import Parser

class AtomExprTest: XCTestCase, Common, DestructExpressionKind {

  func test_none() {
    var parser = self.parser(
      self.token(.none, start: loc0, end: loc1)
    )

    if let expr = self.parse(&parser) {
      XCTAssertExpression(expr, "None")
      XCTAssertEqual(expr.kind,  .none)
      XCTAssertEqual(expr.start, loc0)
      XCTAssertEqual(expr.end,   loc1)
    }
  }

  func test_true() {
    var parser = self.parser(
      self.token(.true, start: loc0, end: loc1)
    )

    if let expr = self.parse(&parser) {
      XCTAssertExpression(expr, "True")
      XCTAssertEqual(expr.kind,  .true)
      XCTAssertEqual(expr.start, loc0)
      XCTAssertEqual(expr.end,   loc1)
    }
  }

  func test_false() {
    var parser = self.parser(
      self.token(.false, start: loc0, end: loc1)
    )

    if let expr = self.parse(&parser) {
      XCTAssertExpression(expr, "False")
      XCTAssertEqual(expr.kind,  .false)
      XCTAssertEqual(expr.start, loc0)
      XCTAssertEqual(expr.end,   loc1)
    }
  }

  func test_int() {
    let value = PyInt(42)

    var parser = self.parser(
      self.token(.int(value), start: loc0, end: loc1)
    )

    if let expr = self.parse(&parser) {
      XCTAssertExpression(expr, "42")
      XCTAssertEqual(expr.kind,  .int(value))
      XCTAssertEqual(expr.start, loc0)
      XCTAssertEqual(expr.end,   loc1)
    }
  }

  func test_float() {
    var parser = self.parser(
      self.token(.float(4.2), start: loc0, end: loc1)
    )

    if let expr = self.parse(&parser) {
      XCTAssertExpression(expr, "4.2")
      XCTAssertEqual(expr.kind,  .float(4.2))
      XCTAssertEqual(expr.start, loc0)
      XCTAssertEqual(expr.end,   loc1)
    }
  }

  func test_imaginary() {
    var parser = self.parser(
      self.token(.imaginary(4.2), start: loc0, end: loc1)
    )

    if let expr = self.parse(&parser) {
      XCTAssertExpression(expr, "(complex 0.0 4.2)")
      XCTAssertEqual(expr.kind,  .complex(real: 0.0, imag: 4.2))
      XCTAssertEqual(expr.start, loc0)
      XCTAssertEqual(expr.end,   loc1)
    }
  }

  func test_ellipsis() {
    var parser = self.parser(
      self.token(.ellipsis, start: loc0, end: loc1)
    )

    if let expr = self.parse(&parser) {
      XCTAssertExpression(expr, "...")
      XCTAssertEqual(expr.kind,  .ellipsis)
      XCTAssertEqual(expr.start, loc0)
      XCTAssertEqual(expr.end,   loc1)
    }
  }

  func test_bytes() {
    let data = Data(repeating: 1, count: 5)

    var parser = self.parser(
      self.token(.bytes(data), start: loc0, end: loc1)
    )

    if let expr = self.parse(&parser) {
      XCTAssertExpression(expr, "(bytes count:5)")
      XCTAssertEqual(expr.kind,  .bytes(data))
      XCTAssertEqual(expr.start, loc0)
      XCTAssertEqual(expr.end,   loc1)
    }
  }

  func test_await() {
    let value = PyInt(42)

    var parser = self.parser(
      self.token(.await,      start: loc0, end: loc1),
      self.token(.int(value), start: loc2, end: loc3)
    )

    if let expr = self.parse(&parser) {
      let inner = Expression(.int(value), start: loc2, end: loc3)

      XCTAssertExpression(expr, "(await 42)")
      XCTAssertEqual(expr.kind,  .await(inner))
      XCTAssertEqual(expr.start, loc0)
      XCTAssertEqual(expr.end,   loc3)
    }
  }
}
