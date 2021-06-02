import XCTest
import VioletCore
import VioletLexer
@testable import VioletParser

// swiftformat:disable consecutiveSpaces

class ParseSet: XCTestCase {

  // MARK: - Set

  /// {rapunzel}
  func test_singleElement() {
    let parser = createExprParser(
      createToken(.leftBrace,              start: loc0, end: loc1),
      createToken(.identifier("rapunzel"), start: loc2, end: loc3),
      createToken(.rightBrace,             start: loc4, end: loc5)
    )

    guard let ast = parse(parser) else { return }

    XCTAssertAST(ast, """
    ExpressionAST(start: 0:0, end: 5:10)
      SetExpr(context: Load, start: 0:0, end: 5:10)
        Elements
          IdentifierExpr(context: Load, start: 2:2, end: 3:8)
            Value: rapunzel
    """)
  }

  /// {rapunzel,}
  func test_withComaAfter() {
    let parser = createExprParser(
      createToken(.leftBrace,              start: loc0, end: loc1),
      createToken(.identifier("rapunzel"), start: loc2, end: loc3),
      createToken(.comma,                  start: loc4, end: loc5),
      createToken(.rightBrace,             start: loc6, end: loc7)
    )

    guard let ast = parse(parser) else { return }

    XCTAssertAST(ast, """
    ExpressionAST(start: 0:0, end: 7:12)
      SetExpr(context: Load, start: 0:0, end: 7:12)
        Elements
          IdentifierExpr(context: Load, start: 2:2, end: 3:8)
            Value: rapunzel
    """)
  }

  /// {*1}
  func test_star() {
    let parser = createExprParser(
      createToken(.leftBrace,              start: loc0, end: loc1),
      createToken(.star,                   start: loc2, end: loc3),
      createToken(.identifier("rapunzel"), start: loc4, end: loc5),
      createToken(.rightBrace,             start: loc6, end: loc7)
    )

    guard let ast = parse(parser) else { return }

    XCTAssertAST(ast, """
  ExpressionAST(start: 0:0, end: 7:12)
    SetExpr(context: Load, start: 0:0, end: 7:12)
      Elements
        StarredExpr(context: Load, start: 2:2, end: 5:10)
          Expression
            IdentifierExpr(context: Load, start: 4:4, end: 5:10)
              Value: rapunzel
  """)
  }

  /// {rapunzel, *eugene, cassandra}
  func test_multipleElements() {
    let parser = createExprParser(
      createToken(.leftBrace,               start: loc0, end: loc1),
      createToken(.identifier("rapunzel"),  start: loc2, end: loc3),
      createToken(.comma,                   start: loc4, end: loc5),
      createToken(.star,                    start: loc6, end: loc7),
      createToken(.identifier("eugene"),    start: loc8, end: loc9),
      createToken(.comma,                   start: loc10, end: loc11),
      createToken(.identifier("cassandra"), start: loc12, end: loc13),
      createToken(.rightBrace,              start: loc14, end: loc15)
    )

    guard let ast = parse(parser) else { return }

    XCTAssertAST(ast, """
    ExpressionAST(start: 0:0, end: 15:20)
      SetExpr(context: Load, start: 0:0, end: 15:20)
        Elements
          IdentifierExpr(context: Load, start: 2:2, end: 3:8)
            Value: rapunzel
          StarredExpr(context: Load, start: 6:6, end: 9:14)
            Expression
              IdentifierExpr(context: Load, start: 8:8, end: 9:14)
                Value: eugene
          IdentifierExpr(context: Load, start: 12:12, end: 13:18)
            Value: cassandra
    """)
  }

  // MARK: - Set comprehension

  /// {rapunzel for eugene in []}
  func test_comprehension() {
    let parser = createExprParser(
      createToken(.leftBrace,              start: loc0, end: loc1),
      createToken(.identifier("rapunzel"), start: loc2, end: loc3),
      createToken(.for,                    start: loc4, end: loc5),
      createToken(.identifier("eugene"),   start: loc6, end: loc7),
      createToken(.in,                     start: loc8, end: loc9),
      createToken(.leftSqb,                start: loc10, end: loc11),
      createToken(.rightSqb,               start: loc12, end: loc13),
      createToken(.rightBrace,             start: loc14, end: loc15)
    )

    guard let ast = parse(parser) else { return }

    XCTAssertAST(ast, """
    ExpressionAST(start: 0:0, end: 15:20)
      SetComprehensionExpr(context: Load, start: 0:0, end: 15:20)
        Element
          IdentifierExpr(context: Load, start: 2:2, end: 3:8)
            Value: rapunzel
        Generators
          Comprehension(start: 4:4, end: 13:18)
            isAsync: false
            Target
              IdentifierExpr(context: Store, start: 6:6, end: 7:12)
                Value: eugene
            Iterable
              ListExpr(context: Load, start: 10:10, end: 13:18)
                Elements: none
            Ifs: none
    """)
  }
}
