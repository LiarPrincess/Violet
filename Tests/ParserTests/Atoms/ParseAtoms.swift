import XCTest
import Core
import Lexer
@testable import Parser

class ParseAtoms: XCTestCase, Common {

  // MARK: - None

  func test_none() {
    let parser = self.createExprParser(
      self.token(.none, start: loc0, end: loc1)
    )

    if let ast = self.parse(parser) {
      XCTAssertAST(ast, """
ExpressionAST(start: 0:0, end: 1:6)
  NoneExpr(start: 0:0, end: 1:6)
""")
    }
  }

  // MARK: - Bool

  func test_true() {
    let parser = self.createExprParser(
      self.token(.true, start: loc0, end: loc1)
    )

    if let ast = self.parse(parser) {
      XCTAssertAST(ast, """
ExpressionAST(start: 0:0, end: 1:6)
  TrueExpr(start: 0:0, end: 1:6)
""")
    }
  }

  func test_false() {
    let parser = self.createExprParser(
      self.token(.false, start: loc0, end: loc1)
    )

    if let ast = self.parse(parser) {
      XCTAssertAST(ast, """
ExpressionAST(start: 0:0, end: 1:6)
  FalseExpr(start: 0:0, end: 1:6)
""")
    }
  }

  // MARK: - Numbers

  func test_int() {
    let value = BigInt(42)

    let parser = self.createExprParser(
      self.token(.int(value), start: loc0, end: loc1)
    )

    if let ast = self.parse(parser) {
      XCTAssertAST(ast, """
ExpressionAST(start: 0:0, end: 1:6)
  IntExpr(start: 0:0, end: 1:6)
    Value: 42
""")
    }
  }

  func test_float() {
    let parser = self.createExprParser(
      self.token(.float(4.2), start: loc0, end: loc1)
    )

    if let ast = self.parse(parser) {
      XCTAssertAST(ast, """
ExpressionAST(start: 0:0, end: 1:6)
  FloatExpr(start: 0:0, end: 1:6)
    Value: 4.2
""")
    }
  }

  func test_imaginary() {
    let parser = self.createExprParser(
      self.token(.imaginary(4.2), start: loc0, end: loc1)
    )

    if let ast = self.parse(parser) {
      XCTAssertAST(ast, """
ExpressionAST(start: 0:0, end: 1:6)
  ComplexExpr(start: 0:0, end: 1:6)
    Real: 0.0
    Imag: 4.2
""")
    }
  }

  // MARK: - Ellipsis

  func test_ellipsis() {
    let parser = self.createExprParser(
      self.token(.ellipsis, start: loc0, end: loc1)
    )

    if let ast = self.parse(parser) {
      XCTAssertAST(ast, """
ExpressionAST(start: 0:0, end: 1:6)
  EllipsisExpr(start: 0:0, end: 1:6)
""")
    }
  }

  // MARK: - Await

  func test_await() {
    let parser = self.createExprParser(
      self.token(.await,          start: loc0, end: loc1),
      self.token(.string("Elsa"), start: loc2, end: loc3)
    )

    if let ast = self.parse(parser) {
      XCTAssertAST(ast, """
ExpressionAST(start: 0:0, end: 3:8)
  AwaitExpr(start: 0:0, end: 3:8)
    Value
      StringExpr(start: 2:2, end: 3:8)
        String: 'Elsa'
""")
    }
  }
}
