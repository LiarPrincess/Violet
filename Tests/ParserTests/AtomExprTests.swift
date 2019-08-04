import XCTest
import Core
import Lexer
@testable import Parser

// swiftlint:disable file_length

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

  // MARK: - Parens

  /// ()
  func test_parens_empty() {
    var parser = self.parser(
      self.token(.leftParen,  start: loc0, end: loc1),
      self.token(.rightParen, start: loc2, end: loc3)
    )

    if let expr = self.parse(&parser) {
      XCTAssertExpression(expr, "()")
      XCTAssertEqual(expr.kind,  .tuple([]))
      XCTAssertEqual(expr.start, loc0)
      XCTAssertEqual(expr.end,   loc3)
    }
  }

  /// (1)
  func test_parens_value() {
    var parser = self.parser(
      self.token(.leftParen,  start: loc0, end: loc1),
      self.token(.float(1.0), start: loc2, end: loc3),
      self.token(.rightParen, start: loc4, end: loc5)
    )

    if let expr = self.parse(&parser) {
      XCTAssertExpression(expr, "1.0")
      XCTAssertEqual(expr.kind,  .float(1.0))
      XCTAssertEqual(expr.start, loc2)
      XCTAssertEqual(expr.end,   loc3)
    }
  }

  // MARK: - Parens - tuple

  /// (1,)
  func test_parens_value_withComaAfter_givesTuple() {
    var parser = self.parser(
      self.token(.leftParen,  start: loc0, end: loc1),
      self.token(.float(1.0), start: loc2, end: loc3),
      self.token(.comma,      start: loc4, end: loc5),
      self.token(.rightParen, start: loc6, end: loc7)
    )

    if let expr = self.parse(&parser) {
      let one = Expression(.float(1.0), start: loc2, end: loc3)

      XCTAssertExpression(expr, "(1.0)")
      XCTAssertEqual(expr.kind,  .tuple([one]))
      XCTAssertEqual(expr.start, loc0)
      XCTAssertEqual(expr.end,   loc7)
    }
  }

  /// (1, 2)
  func test_parens_tuple() {
    var parser = self.parser(
      self.token(.leftParen,  start: loc0, end: loc1),
      self.token(.float(1.0), start: loc2, end: loc3),
      self.token(.comma,      start: loc4, end: loc5),
      self.token(.float(2.0), start: loc6, end: loc7),
      self.token(.rightParen, start: loc8, end: loc9)
    )

    if let expr = self.parse(&parser) {
      let one = Expression(.float(1.0), start: loc2, end: loc3)
      let two = Expression(.float(2.0), start: loc6, end: loc7)

      XCTAssertExpression(expr, "(1.0 2.0)")
      XCTAssertEqual(expr.kind,  .tuple([one, two]))
      XCTAssertEqual(expr.start, loc0)
      XCTAssertEqual(expr.end,   loc9)
    }
  }

  // MARK: - Parens - yield

  /// (yield)
  func test_parens_yield_nil() {
    var parser = self.parser(
      self.token(.leftParen,  start: loc0, end: loc1),
      self.token(.yield,      start: loc2, end: loc3),
      self.token(.rightParen, start: loc4, end: loc5)
    )

    if let expr = self.parse(&parser) {
      XCTAssertExpression(expr, "(yield)")
      XCTAssertEqual(expr.kind,  .yield(nil))
      XCTAssertEqual(expr.start, loc2)
      XCTAssertEqual(expr.end,   loc3)
    }
  }

  /// (yield 1.0)
  func test_parens_yield_expr() {
    var parser = self.parser(
      self.token(.leftParen,  start: loc0, end: loc1),
      self.token(.yield,      start: loc2, end: loc3),
      self.token(.float(1.0), start: loc4, end: loc5),
      self.token(.rightParen, start: loc6, end: loc7)
    )

    if let expr = self.parse(&parser) {
      let one = Expression(.float(1.0), start: loc4, end: loc5)

      XCTAssertExpression(expr, "(yield 1.0)")
      XCTAssertEqual(expr.kind,  .yield(one))
      XCTAssertEqual(expr.start, loc2)
      XCTAssertEqual(expr.end,   loc5)
    }
  }

  /// (yield 1.0, )
  func test_parens_yield_tuple() {
    var parser = self.parser(
      self.token(.leftParen,  start: loc0, end: loc1),
      self.token(.yield,      start: loc2, end: loc3),
      self.token(.float(1.0), start: loc4, end: loc5),
      self.token(.comma,      start: loc6, end: loc7),
      self.token(.rightParen, start: loc8, end: loc9)
    )

    if let expr = self.parse(&parser) {
      let one = Expression(.float(1.0), start: loc4, end: loc5)
      let tuple = Expression(.tuple([one]), start: loc4, end: loc5)

      XCTAssertExpression(expr, "(yield (1.0))")
      XCTAssertEqual(expr.kind,  .yield(tuple))
      XCTAssertEqual(expr.start, loc2)
      XCTAssertEqual(expr.end,   loc5)
    }
  }

  // MARK: - Parens - generator expr

  /// (a for b in [])
  func test_parens_generator() {
    var parser = self.parser(
      self.token(.leftParen,       start: loc0, end: loc1),
      self.token(.identifier("a"), start: loc2, end: loc3),
      self.token(.for,             start: loc4, end: loc5),
      self.token(.identifier("b"), start: loc6, end: loc7),
      self.token(.in,              start: loc8, end: loc9),
      self.token(.leftSqb,         start: loc10, end: loc11),
      self.token(.rightSqb,        start: loc12, end: loc13),
      self.token(.rightParen,      start: loc14, end: loc15)
    )

    if let expr = self.parse(&parser) {
      guard let d = self.destructGeneratorExp(expr) else { return }

      XCTAssertEqual(d.elt, Expression(.identifier("a"), start: loc2, end: loc3))

      XCTAssertEqual(d.generators.count, 1)
      guard d.generators.count == 1 else { return }

      let g = d.generators[0]
      XCTAssertEqual(g.isAsync, false)
      XCTAssertEqual(g.target, Expression(.identifier("b"), start: loc6, end: loc7))
      XCTAssertEqual(g.iter, Expression(.list([]), start: loc10, end: loc13))
      XCTAssertEqual(g.ifs.count, 0)
      XCTAssertEqual(g.start, loc4)
      XCTAssertEqual(g.end, loc13)

      XCTAssertExpression(expr, "(generatorCompr a (for b in []))")
      XCTAssertEqual(expr.start, loc0)
      XCTAssertEqual(expr.end,   loc15)
    }
  }
}
