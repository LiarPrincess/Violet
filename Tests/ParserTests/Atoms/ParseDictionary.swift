import XCTest
import VioletCore
import VioletLexer
@testable import VioletParser

// swiftlint:disable function_body_length
// swiftformat:disable consecutiveSpaces

class ParseDictionary: XCTestCase {

  // MARK: - Empty

  /// {}
  func test_empty() {
    let parser = createExprParser(
      createToken(.leftBrace,  start: loc0, end: loc1),
      createToken(.rightBrace, start: loc2, end: loc3)
    )

    guard let ast = parse(parser) else { return }

    XCTAssertAST(ast, """
    ExpressionAST(start: 0:0, end: 3:8)
      DictionaryExpr(context: Load, start: 0:0, end: 3:8)
        Elements: none
    """)
  }

  // MARK: - Dictionary

  /// {rapunzel:eugene}
  func test_singleElement() {
    let parser = createExprParser(
      createToken(.leftBrace,              start: loc0, end: loc1),
      createToken(.identifier("rapunzel"), start: loc2, end: loc3),
      createToken(.colon,                  start: loc4, end: loc5),
      createToken(.identifier("eugene"),   start: loc6, end: loc7),
      createToken(.rightBrace,             start: loc8, end: loc9)
    )

    guard let ast = parse(parser) else { return }

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
    let parser = createExprParser(
      createToken(.leftBrace,              start: loc0, end: loc1),
      createToken(.identifier("rapunzel"), start: loc2, end: loc3),
      createToken(.colon,                  start: loc4, end: loc5),
      createToken(.identifier("eugene"),   start: loc6, end: loc7),
      createToken(.comma,                  start: loc8, end: loc9),
      createToken(.rightBrace,             start: loc10, end: loc11)
    )

    guard let ast = parse(parser) else { return }

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
    let parser = createExprParser(
      createToken(.leftBrace,                   start: loc0, end: loc1),
      createToken(.starStar,                    start: loc2, end: loc3),
      createToken(.identifier("rapunzel"),      start: loc4, end: loc5),
      createToken(.rightBrace,                  start: loc6, end: loc7)
    )

    guard let ast = parse(parser) else { return }

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
    let parser = createExprParser(
      createToken(.leftBrace,                   start: loc0, end: loc1),
      createToken(.identifier("rapunzel"),      start: loc2, end: loc3),
      createToken(.colon,                       start: loc4, end: loc5),
      createToken(.identifier("eugene"),        start: loc6, end: loc7),
      createToken(.comma,                       start: loc8, end: loc9),
      createToken(.starStar,                    start: loc10, end: loc11),
      createToken(.identifier("cassandra"),     start: loc12, end: loc13),
      createToken(.comma,                       start: loc14, end: loc15),
      createToken(.identifier("pascal"),        start: loc16, end: loc17),
      createToken(.colon,                       start: loc18, end: loc19),
      createToken(.identifier("maximus"),       start: loc20, end: loc21),
      createToken(.rightBrace,                  start: loc22, end: loc23)
    )

    guard let ast = parse(parser) else { return }

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
    let parser = createExprParser(
      createToken(.leftBrace,                   start: loc0, end: loc1),
      createToken(.identifier("rapunzel"),      start: loc2, end: loc3),
      createToken(.colon,                       start: loc4, end: loc5),
      createToken(.identifier("eugene"),        start: loc6, end: loc7),
      createToken(.for,                         start: loc8, end: loc9),
      createToken(.identifier("cassandra"),     start: loc10, end: loc11),
      createToken(.in,                          start: loc12, end: loc13),
      createToken(.leftSqb,                     start: loc14, end: loc15),
      createToken(.rightSqb,                    start: loc16, end: loc17),
      createToken(.rightBrace,                  start: loc18, end: loc19)
    )

    guard let ast = parse(parser) else { return }

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
    let parser = createExprParser(
      createToken(.leftBrace,                   start: loc0, end: loc1),
      createToken(.starStar,                    start: loc2, end: loc3),
      createToken(.identifier("rapunzel"),      start: loc4, end: loc5),
      createToken(.for,                         start: loc6, end: loc7),
      createToken(.identifier("eugene"),        start: loc8, end: loc9),
      createToken(.in,                          start: loc10, end: loc11),
      createToken(.leftSqb,                     start: loc12, end: loc13),
      createToken(.rightSqb,                    start: loc14, end: loc15),
      createToken(.rightBrace,                  start: loc16, end: loc17)
    )

    if let error = parseError(parser) {
      XCTAssertEqual(error.kind, .dictUnpackingInsideComprehension)
      XCTAssertEqual(error.location, loc2)
    }
  }
}
