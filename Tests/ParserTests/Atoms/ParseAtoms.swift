import XCTest
import BigInt
import VioletCore
import VioletLexer
@testable import VioletParser

// swiftformat:disable consecutiveSpaces

class ParseAtoms: XCTestCase {

  // MARK: - None

  func test_none() {
    let parser = createExprParser(
      createToken(.none, start: loc0, end: loc1)
    )

    guard let ast = parse(parser) else { return }

    XCTAssertAST(ast, """
    ExpressionAST(start: 0:0, end: 1:6)
      NoneExpr(context: Load, start: 0:0, end: 1:6)
    """)
  }

  // MARK: - Bool

  func test_true() {
    let parser = createExprParser(
      createToken(.true, start: loc0, end: loc1)
    )

    guard let ast = parse(parser) else { return }

    XCTAssertAST(ast, """
    ExpressionAST(start: 0:0, end: 1:6)
      TrueExpr(context: Load, start: 0:0, end: 1:6)
    """)
  }

  func test_false() {
    let parser = createExprParser(
      createToken(.false, start: loc0, end: loc1)
    )

    guard let ast = parse(parser) else { return }

    XCTAssertAST(ast, """
    ExpressionAST(start: 0:0, end: 1:6)
      FalseExpr(context: Load, start: 0:0, end: 1:6)
    """)
  }

  // MARK: - Numbers

  func test_int() {
    let value = BigInt(42)

    let parser = createExprParser(
      createToken(.int(value), start: loc0, end: loc1)
    )

    guard let ast = parse(parser) else { return }

    XCTAssertAST(ast, """
    ExpressionAST(start: 0:0, end: 1:6)
      IntExpr(context: Load, start: 0:0, end: 1:6)
        Value: 42
    """)
  }

  func test_float() {
    let parser = createExprParser(
      createToken(.float(4.2), start: loc0, end: loc1)
    )

    guard let ast = parse(parser) else { return }

    XCTAssertAST(ast, """
    ExpressionAST(start: 0:0, end: 1:6)
      FloatExpr(context: Load, start: 0:0, end: 1:6)
        Value: 4.2
    """)
  }

  func test_imaginary() {
    let parser = createExprParser(
      createToken(.imaginary(4.2), start: loc0, end: loc1)
    )

    guard let ast = parse(parser) else { return }

    XCTAssertAST(ast, """
    ExpressionAST(start: 0:0, end: 1:6)
      ComplexExpr(context: Load, start: 0:0, end: 1:6)
        Real: 0.0
        Imag: 4.2
    """)
  }

  // MARK: - Ellipsis

  func test_ellipsis() {
    let parser = createExprParser(
      createToken(.ellipsis, start: loc0, end: loc1)
    )

    guard let ast = parse(parser) else { return }

    XCTAssertAST(ast, """
    ExpressionAST(start: 0:0, end: 1:6)
      EllipsisExpr(context: Load, start: 0:0, end: 1:6)
    """)
  }

  // MARK: - Await

  func test_await() {
    let parser = createExprParser(
      createToken(.await,          start: loc0, end: loc1),
      createToken(.string("Elsa"), start: loc2, end: loc3)
    )

    guard let ast = parse(parser) else { return }

    XCTAssertAST(ast, """
    ExpressionAST(start: 0:0, end: 3:8)
      AwaitExpr(context: Load, start: 0:0, end: 3:8)
        Value
          StringExpr(context: Load, start: 2:2, end: 3:8)
            String: 'Elsa'
    """)
  }
}
