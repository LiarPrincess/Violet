import XCTest
import VioletCore
import VioletLexer
@testable import VioletParser

// swiftformat:disable consecutiveSpaces

class ParseComparisonExpr: XCTestCase {

  func test_operators() {
    let variants: [(Token.Kind, CompareExpr.Operator)] = [
      (.equalEqual, .equal),
      (.notEqual,   .notEqual),
      // <> - pep401 is not implemented
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
      let parser = createExprParser(
        createToken(.identifier("aladdin"), start: loc0, end: loc1),
        createToken(token,                  start: loc2, end: loc3),
        createToken(.identifier("jasmine"), start: loc4, end: loc5)
      )

      guard let ast = parse(parser) else { continue }

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
    let parser = createExprParser(
      createToken(.identifier("rapunzel"), start: loc0, end: loc1),
      createToken(.not,                    start: loc2, end: loc3),
      createToken(.in,                     start: loc4, end: loc5),
      createToken(.identifier("aladdin"),  start: loc6, end: loc7)
    )

    guard let ast = parse(parser) else { return }

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
    let parser = createExprParser(
      createToken(.identifier("aladdin"), start: loc0, end: loc1),
      createToken(.is,                    start: loc2, end: loc3),
      createToken(.not,                   start: loc4, end: loc5),
      createToken(.identifier("jasmine"), start: loc6, end: loc7)
    )

    guard let ast = parse(parser) else { return }

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
    let parser = createExprParser(
      createToken(.identifier("aladdin"), start: loc0, end: loc1),
      createToken(.less,                  start: loc2, end: loc3),
      createToken(.identifier("jasmine"), start: loc4, end: loc5),
      createToken(.lessEqual,             start: loc6, end: loc7),
      createToken(.identifier("genie"),   start: loc8, end: loc9)
    )

    guard let ast = parse(parser) else { return }

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
