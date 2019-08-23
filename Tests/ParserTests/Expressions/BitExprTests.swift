import XCTest
import Core
import Lexer
@testable import Parser

class BitExprTests: XCTestCase, Common, DestructExpressionKind {

  func test_operators() {
    let variants: [(TokenKind, BinaryOperator)] = [
      (.vbar, .bitOr), // grammar: expr
      (.circumflex, .bitXor), // grammar: xor_expr
      (.amper, .bitAnd), // grammar: and_expr
      (.leftShift, .leftShift), // grammar: shift_expr
      (.rightShift, .rightShift)
    ]

    for (token, op) in variants {
      var parser = self.createExprParser(
        self.token(.int(BigInt(5)), start: loc0, end: loc1),
        self.token(token,           start: loc2, end: loc3),
        self.token(.int(BigInt(3)), start: loc4, end: loc5)
      )

      if let expr = self.parseExpr(&parser) {
        let msg = "for token '\(token)'"

        guard let b = self.destructBinaryOp(expr) else { return }

        XCTAssertEqual(b.0, op, msg)
        XCTAssertEqual(b.left,  Expression(.int(BigInt(5)), start: loc0, end: loc1), msg)
        XCTAssertEqual(b.right, Expression(.int(BigInt(3)), start: loc4, end: loc5), msg)

        XCTAssertExpression(expr, "(\(op) 5 3)", msg)
        XCTAssertEqual(expr.start, loc0, msg)
        XCTAssertEqual(expr.end,   loc5, msg)
      }
    }
  }

  // MARK: - Associativity

  /// 1 << 2 << 4 = (1 << 2) << 4
  func test_shiftGroup_isLeftAssociative() {
    var parser = self.createExprParser(
      self.token(.int(BigInt(1)), start: loc0, end: loc1),
      self.token(.leftShift,      start: loc2, end: loc3),
      self.token(.int(BigInt(2)), start: loc4, end: loc5),
      self.token(.leftShift,      start: loc6, end: loc7),
      self.token(.int(BigInt(4)), start: loc8, end: loc9)
    )

    if let expr = self.parseExpr(&parser) {
      XCTAssertExpression(expr, "(<< (<< 1 2) 4)")
      XCTAssertEqual(expr.start, loc0)
      XCTAssertEqual(expr.end,   loc9)
    }
  }

  /// 1 & 2 & 4 = (1 & 2) & 4
  func test_andGroup_isLeftAssociative() {
    var parser = self.createExprParser(
      self.token(.int(BigInt(1)), start: loc0, end: loc1),
      self.token(.amper,          start: loc2, end: loc3),
      self.token(.int(BigInt(2)), start: loc4, end: loc5),
      self.token(.amper,          start: loc6, end: loc7),
      self.token(.int(BigInt(4)), start: loc8, end: loc9)
    )

    if let expr = self.parseExpr(&parser) {
      XCTAssertExpression(expr, "(& (& 1 2) 4)")
      XCTAssertEqual(expr.start, loc0)
      XCTAssertEqual(expr.end,   loc9)
    }
  }

  /// 1 ^ 2 ^ 4 = (1 ^ 2) ^ 4
  func test_xorGroup_isLeftAssociative() {
    var parser = self.createExprParser(
      self.token(.int(BigInt(1)), start: loc0, end: loc1),
      self.token(.circumflex,     start: loc2, end: loc3),
      self.token(.int(BigInt(2)), start: loc4, end: loc5),
      self.token(.circumflex,     start: loc6, end: loc7),
      self.token(.int(BigInt(4)), start: loc8, end: loc9)
    )

    if let expr = self.parseExpr(&parser) {
      XCTAssertExpression(expr, "(^ (^ 1 2) 4)")
      XCTAssertEqual(expr.start, loc0)
      XCTAssertEqual(expr.end,   loc9)
    }
  }

  /// 1 | 2 | 4 = (1 | 2) | 4
  func test_orGroup_isLeftAssociative() {
    var parser = self.createExprParser(
      self.token(.int(BigInt(1)), start: loc0, end: loc1),
      self.token(.vbar,           start: loc2, end: loc3),
      self.token(.int(BigInt(2)), start: loc4, end: loc5),
      self.token(.vbar,           start: loc6, end: loc7),
      self.token(.int(BigInt(4)), start: loc8, end: loc9)
    )

    if let expr = self.parseExpr(&parser) {
      XCTAssertExpression(expr, "(| (| 1 2) 4)")
      XCTAssertEqual(expr.start, loc0)
      XCTAssertEqual(expr.end,   loc9)
    }
  }

  // MARK: - Precedence (skipped)
}
