import XCTest
import VioletCore
import VioletLexer
@testable import VioletParser

// swiftformat:disable consecutiveSpaces

class ParseComparisonExpr: XCTestCase, Common {

  func test_operators() {
    let variants: [(TokenKind, CompareExpr.Operator)] = [
      (.equalEqual, .equal),
      (.notEqual,   .notEqual),
      // <> - pep401 is not implmented
      (.less,      .less),
      (.lessEqual, .lessEqual),
      (.greater,      .greater),
      (.greaterEqual, .greaterEqual),
      (.in,  .in),
      (.is,  .is)
      // not in - separate test
      // is not - separate test
    ]

    for (token, op) in variants {
      let parser = self.createExprParser(
        self.token(.identifier("aladdin"), start: loc0, end: loc1),
        self.token(token,                  start: loc2, end: loc3),
        self.token(.identifier("jasmine"), start: loc4, end: loc5)
      )

      guard let ast = self.parse(parser) else { continue }

      XCTAssertAST(ast, """
      ExpressionAST(start: 0:0, end: 5:10)
        CompareExpr(context: Load, start: 0:0, end: 5:10)
          Left
            IdentifierExpr(context: Load, start: 0:0, end: 1:6)
              Value: aladdin
          Elements
            ComparisonElement
              Operator: \(op)
              Right
                IdentifierExpr(context: Load, start: 4:4, end: 5:10)
                  Value: jasmine
      """)
    }
  }

  func test_notIn() {
    let parser = self.createExprParser(
      self.token(.identifier("rapunzel"), start: loc0, end: loc1),
      self.token(.not,                    start: loc2, end: loc3),
      self.token(.in,                     start: loc4, end: loc5),
      self.token(.identifier("aladdin"),  start: loc6, end: loc7)
    )

    guard let ast = self.parse(parser) else { return }

    XCTAssertAST(ast, """
    ExpressionAST(start: 0:0, end: 7:12)
      CompareExpr(context: Load, start: 0:0, end: 7:12)
        Left
          IdentifierExpr(context: Load, start: 0:0, end: 1:6)
            Value: rapunzel
        Elements
          ComparisonElement
            Operator: not in
            Right
              IdentifierExpr(context: Load, start: 6:6, end: 7:12)
                Value: aladdin
    """)
  }

  func test_isNot() {
    let parser = self.createExprParser(
      self.token(.identifier("aladdin"), start: loc0, end: loc1),
      self.token(.is,                    start: loc2, end: loc3),
      self.token(.not,                   start: loc4, end: loc5),
      self.token(.identifier("jasmine"), start: loc6, end: loc7)
    )

    guard let ast = self.parse(parser) else { return }

    XCTAssertAST(ast, """
    ExpressionAST(start: 0:0, end: 7:12)
      CompareExpr(context: Load, start: 0:0, end: 7:12)
        Left
          IdentifierExpr(context: Load, start: 0:0, end: 1:6)
            Value: aladdin
        Elements
          ComparisonElement
            Operator: is not
            Right
              IdentifierExpr(context: Load, start: 6:6, end: 7:12)
                Value: jasmine
    """)
  }

  /// aladdin < jasmine <= genie
  func test_compare_withMultipleElements() {
    let parser = self.createExprParser(
      self.token(.identifier("aladdin"), start: loc0, end: loc1),
      self.token(.less,                  start: loc2, end: loc3),
      self.token(.identifier("jasmine"), start: loc4, end: loc5),
      self.token(.lessEqual,             start: loc6, end: loc7),
      self.token(.identifier("genie"),   start: loc8, end: loc9)
    )

    guard let ast = self.parse(parser) else { return }

    XCTAssertAST(ast, """
    ExpressionAST(start: 0:0, end: 9:14)
      CompareExpr(context: Load, start: 0:0, end: 9:14)
        Left
          IdentifierExpr(context: Load, start: 0:0, end: 1:6)
            Value: aladdin
        Elements
          ComparisonElement
            Operator: <
            Right
              IdentifierExpr(context: Load, start: 4:4, end: 5:10)
                Value: jasmine
          ComparisonElement
            Operator: <=
            Right
              IdentifierExpr(context: Load, start: 8:8, end: 9:14)
                Value: genie
    """)
  }
}
