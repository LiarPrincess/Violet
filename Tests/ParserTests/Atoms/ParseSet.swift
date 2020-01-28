import XCTest
import Core
import Lexer
@testable import Parser

class ParseSet: XCTestCase, Common {

  // MARK: - Set

  /// {rapunzel}
  func test_singleElement() {
    let parser = self.createExprParser(
      self.token(.leftBrace,              start: loc0, end: loc1),
      self.token(.identifier("rapunzel"), start: loc2, end: loc3),
      self.token(.rightBrace,             start: loc4, end: loc5)
    )

    guard let ast = self.parse(parser) else { return }

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
    let parser = self.createExprParser(
      self.token(.leftBrace,              start: loc0, end: loc1),
      self.token(.identifier("rapunzel"), start: loc2, end: loc3),
      self.token(.comma,                  start: loc4, end: loc5),
      self.token(.rightBrace,             start: loc6, end: loc7)
    )

    guard let ast = self.parse(parser) else { return }

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
    let parser = self.createExprParser(
      self.token(.leftBrace,              start: loc0, end: loc1),
      self.token(.star,                   start: loc2, end: loc3),
      self.token(.identifier("rapunzel"), start: loc4, end: loc5),
      self.token(.rightBrace,             start: loc6, end: loc7)
    )

    guard let ast = self.parse(parser) else { return }

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
    let parser = self.createExprParser(
      self.token(.leftBrace,               start: loc0, end: loc1),
      self.token(.identifier("rapunzel"),  start: loc2, end: loc3),
      self.token(.comma,                   start: loc4, end: loc5),
      self.token(.star,                    start: loc6, end: loc7),
      self.token(.identifier("eugene"),    start: loc8, end: loc9),
      self.token(.comma,                   start: loc10, end: loc11),
      self.token(.identifier("cassandra"), start: loc12, end: loc13),
      self.token(.rightBrace,              start: loc14, end: loc15)
    )

    guard let ast = self.parse(parser) else { return }

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
    let parser = self.createExprParser(
      self.token(.leftBrace,              start: loc0, end: loc1),
      self.token(.identifier("rapunzel"), start: loc2, end: loc3),
      self.token(.for,                    start: loc4, end: loc5),
      self.token(.identifier("eugene"),   start: loc6, end: loc7),
      self.token(.in,                     start: loc8, end: loc9),
      self.token(.leftSqb,                start: loc10, end: loc11),
      self.token(.rightSqb,               start: loc12, end: loc13),
      self.token(.rightBrace,             start: loc14, end: loc15)
    )

    guard let ast = self.parse(parser) else { return }

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
