import XCTest
import Core
import Lexer
@testable import Parser

class AtomTests: XCTestCase, Common, ExpressionMatcher, StringMatcher {

  func test_none() {
    var parser = self.createExprParser(
      self.token(.none, start: loc0, end: loc1)
    )

    if let expr = self.parseExpr(&parser) {
      XCTAssertExpression(expr, "None")
      XCTAssertEqual(expr.kind,  .none)
      XCTAssertEqual(expr.start, loc0)
      XCTAssertEqual(expr.end,   loc1)
    }
  }

  func test_true() {
    var parser = self.createExprParser(
      self.token(.true, start: loc0, end: loc1)
    )

    if let expr = self.parseExpr(&parser) {
      XCTAssertExpression(expr, "True")
      XCTAssertEqual(expr.kind,  .true)
      XCTAssertEqual(expr.start, loc0)
      XCTAssertEqual(expr.end,   loc1)
    }
  }

  func test_false() {
    var parser = self.createExprParser(
      self.token(.false, start: loc0, end: loc1)
    )

    if let expr = self.parseExpr(&parser) {
      XCTAssertExpression(expr, "False")
      XCTAssertEqual(expr.kind,  .false)
      XCTAssertEqual(expr.start, loc0)
      XCTAssertEqual(expr.end,   loc1)
    }
  }

  func test_int() {
    let value = BigInt(42)

    var parser = self.createExprParser(
      self.token(.int(value), start: loc0, end: loc1)
    )

    if let expr = self.parseExpr(&parser) {
      XCTAssertExpression(expr, "42")
      XCTAssertEqual(expr.kind,  .int(value))
      XCTAssertEqual(expr.start, loc0)
      XCTAssertEqual(expr.end,   loc1)
    }
  }

  func test_float() {
    var parser = self.createExprParser(
      self.token(.float(4.2), start: loc0, end: loc1)
    )

    if let expr = self.parseExpr(&parser) {
      XCTAssertExpression(expr, "4.2")
      XCTAssertEqual(expr.kind,  .float(4.2))
      XCTAssertEqual(expr.start, loc0)
      XCTAssertEqual(expr.end,   loc1)
    }
  }

  func test_imaginary() {
    var parser = self.createExprParser(
      self.token(.imaginary(4.2), start: loc0, end: loc1)
    )

    if let expr = self.parseExpr(&parser) {
      XCTAssertExpression(expr, "(0.0+4.2j)")
      XCTAssertEqual(expr.kind,  .complex(real: 0.0, imag: 4.2))
      XCTAssertEqual(expr.start, loc0)
      XCTAssertEqual(expr.end,   loc1)
    }
  }

  func test_ellipsis() {
    var parser = self.createExprParser(
      self.token(.ellipsis, start: loc0, end: loc1)
    )

    if let expr = self.parseExpr(&parser) {
      XCTAssertExpression(expr, "...")
      XCTAssertEqual(expr.kind,  .ellipsis)
      XCTAssertEqual(expr.start, loc0)
      XCTAssertEqual(expr.end,   loc1)
    }
  }

  func test_await() {
    var parser = self.createExprParser(
      self.token(.await,          start: loc0, end: loc1),
      self.token(.string("Elsa"), start: loc2, end: loc3)
    )

    if let expr = self.parseExpr(&parser) {
      guard let awaitExpr = self.matchAwait(expr) else { return }
      XCTAssertExpression(awaitExpr, "'Elsa'")

      XCTAssertExpression(expr, "(await 'Elsa')")
      XCTAssertEqual(expr.start, loc0)
      XCTAssertEqual(expr.end,   loc3)
    }
  }
}
