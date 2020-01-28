import XCTest
import Core
import Lexer
@testable import Parser

class ParseDictionary: XCTestCase, Common {

  // MARK: - Empty

  /// {}
  func test_empty() {
    let parser = self.createExprParser(
      self.token(.leftBrace,  start: loc0, end: loc1),
      self.token(.rightBrace, start: loc2, end: loc3)
    )

    guard let ast = self.parse(parser) else { return }

    XCTAssertAST(ast, """
    ExpressionAST(start: 0:0, end: 3:8)
      DictionaryExpr(context: Load, start: 0:0, end: 3:8)
        Elements: none
    """)
  }

  // MARK: - Dictionary

  /// {rapunzel:eugene}
  func test_singleElement() {
    let parser = self.createExprParser(
      self.token(.leftBrace,              start: loc0, end: loc1),
      self.token(.identifier("rapunzel"), start: loc2, end: loc3),
      self.token(.colon,                  start: loc4, end: loc5),
      self.token(.identifier("eugene"),   start: loc6, end: loc7),
      self.token(.rightBrace,             start: loc8, end: loc9)
    )

    guard let ast = self.parse(parser) else { return }

    XCTAssertAST(ast, """
    ExpressionAST(start: 0:0, end: 9:14)
      DictionaryExpr(context: Load, start: 0:0, end: 9:14)
        Elements
          Key/value
            Key
              IdentifierExpr(context: Load, start: 2:2, end: 3:8)
                Value: rapunzel
            Value
              IdentifierExpr(context: Load, start: 6:6, end: 7:12)
                Value: eugene
    """)
  }

  /// {rapunzel:eugene,}
  func test_withComaAfter() {
    let parser = self.createExprParser(
      self.token(.leftBrace,              start: loc0, end: loc1),
      self.token(.identifier("rapunzel"), start: loc2, end: loc3),
      self.token(.colon,                  start: loc4, end: loc5),
      self.token(.identifier("eugene"),   start: loc6, end: loc7),
      self.token(.comma,                  start: loc8, end: loc9),
      self.token(.rightBrace,             start: loc10, end: loc11)
    )

    guard let ast = self.parse(parser) else { return }

    XCTAssertAST(ast, """
    ExpressionAST(start: 0:0, end: 11:16)
      DictionaryExpr(context: Load, start: 0:0, end: 11:16)
        Elements
          Key/value
            Key
              IdentifierExpr(context: Load, start: 2:2, end: 3:8)
                Value: rapunzel
            Value
              IdentifierExpr(context: Load, start: 6:6, end: 7:12)
                Value: eugene
    """)
  }

  /// {**rapunzel}
  func test_starStar() {
    let parser = self.createExprParser(
      self.token(.leftBrace,                   start: loc0, end: loc1),
      self.token(.starStar,                    start: loc2, end: loc3),
      self.token(.identifier("rapunzel"),      start: loc4, end: loc5),
      self.token(.rightBrace,                  start: loc6, end: loc7)
    )

    guard let ast = self.parse(parser) else { return }

    XCTAssertAST(ast, """
    ExpressionAST(start: 0:0, end: 7:12)
      DictionaryExpr(context: Load, start: 0:0, end: 7:12)
        Elements
          Unpack
            IdentifierExpr(context: Load, start: 4:4, end: 5:10)
              Value: rapunzel
    """)
  }

  /// {rapunzel:eugene, **cassandra, pascal:maximus}
  func test_multipleElements() {
    let parser = self.createExprParser(
      self.token(.leftBrace,                   start: loc0, end: loc1),
      self.token(.identifier("rapunzel"),      start: loc2, end: loc3),
      self.token(.colon,                       start: loc4, end: loc5),
      self.token(.identifier("eugene"),        start: loc6, end: loc7),
      self.token(.comma,                       start: loc8, end: loc9),
      self.token(.starStar,                    start: loc10, end: loc11),
      self.token(.identifier("cassandra"),     start: loc12, end: loc13),
      self.token(.comma,                       start: loc14, end: loc15),
      self.token(.identifier("pascal"),        start: loc16, end: loc17),
      self.token(.colon,                       start: loc18, end: loc19),
      self.token(.identifier("maximus"),       start: loc20, end: loc21),
      self.token(.rightBrace,                  start: loc22, end: loc23)
    )

    guard let ast = self.parse(parser) else { return }

    XCTAssertAST(ast, """
    ExpressionAST(start: 0:0, end: 23:28)
      DictionaryExpr(context: Load, start: 0:0, end: 23:28)
        Elements
          Key/value
            Key
              IdentifierExpr(context: Load, start: 2:2, end: 3:8)
                Value: rapunzel
            Value
              IdentifierExpr(context: Load, start: 6:6, end: 7:12)
                Value: eugene
          Unpack
            IdentifierExpr(context: Load, start: 12:12, end: 13:18)
              Value: cassandra
          Key/value
            Key
              IdentifierExpr(context: Load, start: 16:16, end: 17:22)
                Value: pascal
            Value
              IdentifierExpr(context: Load, start: 20:20, end: 21:26)
                Value: maximus
    """)
  }

  // MARK: - Dictionary comprehension

  /// { rapunzel:eugene for cassandra in [] }
  func test_comprehension() {
    let parser = self.createExprParser(
      self.token(.leftBrace,                   start: loc0, end: loc1),
      self.token(.identifier("rapunzel"),      start: loc2, end: loc3),
      self.token(.colon,                       start: loc4, end: loc5),
      self.token(.identifier("eugene"),        start: loc6, end: loc7),
      self.token(.for,                         start: loc8, end: loc9),
      self.token(.identifier("cassandra"),     start: loc10, end: loc11),
      self.token(.in,                          start: loc12, end: loc13),
      self.token(.leftSqb,                     start: loc14, end: loc15),
      self.token(.rightSqb,                    start: loc16, end: loc17),
      self.token(.rightBrace,                  start: loc18, end: loc19)
    )

    guard let ast = self.parse(parser) else { return }

    XCTAssertAST(ast, """
    ExpressionAST(start: 0:0, end: 19:24)
      DictionaryComprehensionExpr(context: Load, start: 0:0, end: 19:24)
        Key
          IdentifierExpr(context: Load, start: 2:2, end: 3:8)
            Value: rapunzel
        Value
          IdentifierExpr(context: Load, start: 6:6, end: 7:12)
            Value: eugene
        Generators
          Comprehension(start: 8:8, end: 17:22)
            isAsync: false
            Target
              IdentifierExpr(context: Store, start: 10:10, end: 11:16)
                Value: cassandra
            Iterable
              ListExpr(context: Load, start: 14:14, end: 17:22)
                Elements: none
            Ifs: none
    """)
  }

  /// { **rapunzel for eugene in [] }
  func test_unpacking_insideComprehension_throws() {
    let parser = self.createExprParser(
      self.token(.leftBrace,                   start: loc0, end: loc1),
      self.token(.starStar,                    start: loc2, end: loc3),
      self.token(.identifier("rapunzel"),      start: loc4, end: loc5),
      self.token(.for,                         start: loc6, end: loc7),
      self.token(.identifier("eugene"),        start: loc8, end: loc9),
      self.token(.in,                          start: loc10, end: loc11),
      self.token(.leftSqb,                     start: loc12, end: loc13),
      self.token(.rightSqb,                    start: loc14, end: loc15),
      self.token(.rightBrace,                  start: loc16, end: loc17)
    )

    if let error = self.error(parser) {
      XCTAssertEqual(error.kind, .dictUnpackingInsideComprehension)
      XCTAssertEqual(error.location, loc2)
    }
  }
}
