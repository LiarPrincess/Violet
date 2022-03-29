import XCTest
import VioletCore
import VioletLexer
@testable import VioletParser

// swiftlint:disable function_body_length
// swiftformat:disable consecutiveSpaces

class ParseList: XCTestCase {

  // MARK: - List

  /// []
  func test_empty() {
    let parser = createExprParser(
      createToken(.leftSqb,  start: loc0, end: loc1),
      createToken(.rightSqb, start: loc2, end: loc3)
    )

    guard let ast = parse(parser) else { return }

    XCTAssertAST(ast, """
    ExpressionAST(start: 0:0, end: 3:8)
      ListExpr(context: Load, start: 0:0, end: 3:8)
        Elements: none
    """)
  }

  /// [ariel]
  func test_value() {
    let parser = createExprParser(
      createToken(.leftSqb,             start: loc0, end: loc1),
      createToken(.identifier("ariel"), start: loc2, end: loc3),
      createToken(.rightSqb,            start: loc4, end: loc5)
    )

    guard let ast = parse(parser) else { return }

    XCTAssertAST(ast, """
    ExpressionAST(start: 0:0, end: 5:10)
      ListExpr(context: Load, start: 0:0, end: 5:10)
        Elements
          IdentifierExpr(context: Load, start: 2:2, end: 3:8)
            Value: ariel
    """)
  }

  /// [ariel,]
  func test_value_withComaAfter() {
    let parser = createExprParser(
      createToken(.leftSqb,             start: loc0, end: loc1),
      createToken(.identifier("ariel"), start: loc2, end: loc3),
      createToken(.comma,               start: loc4, end: loc5),
      createToken(.rightSqb,            start: loc6, end: loc7)
    )

    guard let ast = parse(parser) else { return }

    XCTAssertAST(ast, """
    ExpressionAST(start: 0:0, end: 7:12)
      ListExpr(context: Load, start: 0:0, end: 7:12)
        Elements
          IdentifierExpr(context: Load, start: 2:2, end: 3:8)
            Value: ariel
    """)
  }

  /// [ariel, eric]
  func test_value_multiple() {
    let parser = createExprParser(
      createToken(.leftSqb,             start: loc0, end: loc1),
      createToken(.identifier("ariel"), start: loc2, end: loc3),
      createToken(.comma,               start: loc4, end: loc5),
      createToken(.identifier("eric"),  start: loc6, end: loc7),
      createToken(.rightSqb,            start: loc8, end: loc9)
    )

    guard let ast = parse(parser) else { return }

    XCTAssertAST(ast, """
    ExpressionAST(start: 0:0, end: 9:14)
      ListExpr(context: Load, start: 0:0, end: 9:14)
        Elements
          IdentifierExpr(context: Load, start: 2:2, end: 3:8)
            Value: ariel
          IdentifierExpr(context: Load, start: 6:6, end: 7:12)
            Value: eric
    """)
  }

  // MARK: - Comprehension

  /// [ariel for eric in []]
  func test_comprehension_list() {
    let parser = createExprParser(
      createToken(.leftSqb,         start: loc0, end: loc1),
      createToken(.identifier("ariel"), start: loc2, end: loc3),
      createToken(.for,             start: loc4, end: loc5),
      createToken(.identifier("eric"), start: loc6, end: loc7),
      createToken(.in,              start: loc8, end: loc9),
      createToken(.leftSqb,         start: loc10, end: loc11),
      createToken(.rightSqb,        start: loc12, end: loc13),
      createToken(.rightSqb,        start: loc14, end: loc15)
    )

    guard let ast = parse(parser) else { return }

    XCTAssertAST(ast, """
    ExpressionAST(start: 0:0, end: 15:20)
      ListComprehensionExpr(context: Load, start: 0:0, end: 15:20)
        Element
          IdentifierExpr(context: Load, start: 2:2, end: 3:8)
            Value: ariel
        Generators
          Comprehension(start: 4:4, end: 13:18)
            isAsync: false
            Target
              IdentifierExpr(context: Store, start: 6:6, end: 7:12)
                Value: eric
            Iterable
              ListExpr(context: Load, start: 10:10, end: 13:18)
                Elements: none
            Ifs: none
    """)
  }

  /// [ariel async for eric in []]
  func test_comprehension_async() {
    let parser = createExprParser(
      createToken(.leftSqb,             start: loc0, end: loc1),
      createToken(.identifier("ariel"), start: loc2, end: loc3),
      createToken(.async,               start: loc4, end: loc5),
      createToken(.for,                 start: loc6, end: loc7),
      createToken(.identifier("eric"),  start: loc8, end: loc9),
      createToken(.in,                  start: loc10, end: loc11),
      createToken(.leftSqb,             start: loc12, end: loc13),
      createToken(.rightSqb,            start: loc14, end: loc15),
      createToken(.rightSqb,            start: loc16, end: loc17)
    )

    guard let ast = parse(parser) else { return }

    XCTAssertAST(ast, """
  ExpressionAST(start: 0:0, end: 17:22)
    ListComprehensionExpr(context: Load, start: 0:0, end: 17:22)
      Element
        IdentifierExpr(context: Load, start: 2:2, end: 3:8)
          Value: ariel
      Generators
        Comprehension(start: 4:4, end: 15:20)
          isAsync: true
          Target
            IdentifierExpr(context: Store, start: 8:8, end: 9:14)
              Value: eric
          Iterable
            ListExpr(context: Load, start: 12:12, end: 15:20)
              Elements: none
          Ifs: none
  """)
  }

  /// [ariel for eric, sebastian in []]
  func test_comprehension_target_multiple() {
    let parser = createExprParser(
      createToken(.leftSqb,                 start: loc0, end: loc1),
      createToken(.identifier("ariel"),     start: loc2, end: loc3),
      createToken(.for,                     start: loc4, end: loc5),
      createToken(.identifier("eric"),      start: loc6, end: loc7),
      createToken(.comma,                   start: loc8, end: loc9),
      createToken(.identifier("sebastian"), start: loc10, end: loc11),
      createToken(.in,                      start: loc12, end: loc13),
      createToken(.leftSqb,                 start: loc14, end: loc15),
      createToken(.rightSqb,                start: loc16, end: loc17),
      createToken(.rightSqb,                start: loc18, end: loc19)
    )

    guard let ast = parse(parser) else { return }

    XCTAssertAST(ast, """
    ExpressionAST(start: 0:0, end: 19:24)
      ListComprehensionExpr(context: Load, start: 0:0, end: 19:24)
        Element
          IdentifierExpr(context: Load, start: 2:2, end: 3:8)
            Value: ariel
        Generators
          Comprehension(start: 4:4, end: 17:22)
            isAsync: false
            Target
              TupleExpr(context: Store, start: 6:6, end: 11:16)
                Elements
                  IdentifierExpr(context: Store, start: 6:6, end: 7:12)
                    Value: eric
                  IdentifierExpr(context: Store, start: 10:10, end: 11:16)
                    Value: sebastian
            Iterable
              ListExpr(context: Load, start: 14:14, end: 17:22)
                Elements: none
            Ifs: none
    """)
  }

  /// [ariel for eric, in []]
  func test_comprehension_target_withCommaAfter_isTuple() {
    let parser = createExprParser(
      createToken(.leftSqb,             start: loc0, end: loc1),
      createToken(.identifier("ariel"), start: loc2, end: loc3),
      createToken(.for,                 start: loc4, end: loc5),
      createToken(.identifier("eric"),  start: loc6, end: loc7),
      createToken(.comma,               start: loc8, end: loc9),
      createToken(.in,                  start: loc10, end: loc11),
      createToken(.leftSqb,             start: loc12, end: loc13),
      createToken(.rightSqb,            start: loc14, end: loc15),
      createToken(.rightSqb,            start: loc16, end: loc17)
    )

    guard let ast = parse(parser) else { return }

    XCTAssertAST(ast, """
    ExpressionAST(start: 0:0, end: 17:22)
      ListComprehensionExpr(context: Load, start: 0:0, end: 17:22)
        Element
          IdentifierExpr(context: Load, start: 2:2, end: 3:8)
            Value: ariel
        Generators
          Comprehension(start: 4:4, end: 15:20)
            isAsync: false
            Target
              TupleExpr(context: Store, start: 6:6, end: 9:14)
                Elements
                  IdentifierExpr(context: Store, start: 6:6, end: 7:12)
                    Value: eric
            Iterable
              ListExpr(context: Load, start: 12:12, end: 15:20)
                Elements: none
            Ifs: none
    """)
  }

  /// [ariel for eric in [] for sebastian in []]
  func test_comprehension_for_multiple() {
    let parser = createExprParser(
      createToken(.leftSqb,                 start: loc0, end: loc1),
      createToken(.identifier("ariel"),     start: loc2, end: loc3),
      createToken(.for,                     start: loc4, end: loc5),
      createToken(.identifier("eric"),      start: loc6, end: loc7),
      createToken(.in,                      start: loc8, end: loc9),
      createToken(.leftSqb,                 start: loc10, end: loc11),
      createToken(.rightSqb,                start: loc12, end: loc13),
      createToken(.for,                     start: loc14, end: loc15),
      createToken(.identifier("sebastian"), start: loc16, end: loc17),
      createToken(.in,                      start: loc18, end: loc19),
      createToken(.leftSqb,                 start: loc20, end: loc21),
      createToken(.rightSqb,                start: loc22, end: loc23),
      createToken(.rightSqb,                start: loc24, end: loc25)
    )

    guard let ast = parse(parser) else { return }

    XCTAssertAST(ast, """
    ExpressionAST(start: 0:0, end: 25:30)
      ListComprehensionExpr(context: Load, start: 0:0, end: 25:30)
        Element
          IdentifierExpr(context: Load, start: 2:2, end: 3:8)
            Value: ariel
        Generators
          Comprehension(start: 4:4, end: 13:18)
            isAsync: false
            Target
              IdentifierExpr(context: Store, start: 6:6, end: 7:12)
                Value: eric
            Iterable
              ListExpr(context: Load, start: 10:10, end: 13:18)
                Elements: none
            Ifs: none
          Comprehension(start: 14:14, end: 23:28)
            isAsync: false
            Target
              IdentifierExpr(context: Store, start: 16:16, end: 17:22)
                Value: sebastian
            Iterable
              ListExpr(context: Load, start: 20:20, end: 23:28)
                Elements: none
            Ifs: none
    """)
  }

  /// [ariel for eric in [] if sebastian if flounder]
  func test_comprehension_ifs_multiple() {
    let parser = createExprParser(
      createToken(.leftSqb,                 start: loc0, end: loc1),
      createToken(.identifier("ariel"),     start: loc2, end: loc3),
      createToken(.for,                     start: loc4, end: loc5),
      createToken(.identifier("eric"),      start: loc6, end: loc7),
      createToken(.in,                      start: loc8, end: loc9),
      createToken(.leftSqb,                 start: loc10, end: loc11),
      createToken(.rightSqb,                start: loc12, end: loc13),
      createToken(.if,                      start: loc14, end: loc15),
      createToken(.identifier("sebastian"), start: loc16, end: loc17),
      createToken(.if,                      start: loc18, end: loc19),
      createToken(.identifier("flounder"),  start: loc20, end: loc21),
      createToken(.rightSqb,                start: loc22, end: loc23)
    )

    guard let ast = parse(parser) else { return }

    XCTAssertAST(ast, """
    ExpressionAST(start: 0:0, end: 23:28)
      ListComprehensionExpr(context: Load, start: 0:0, end: 23:28)
        Element
          IdentifierExpr(context: Load, start: 2:2, end: 3:8)
            Value: ariel
        Generators
          Comprehension(start: 4:4, end: 21:26)
            isAsync: false
            Target
              IdentifierExpr(context: Store, start: 6:6, end: 7:12)
                Value: eric
            Iterable
              ListExpr(context: Load, start: 10:10, end: 13:18)
                Elements: none
            Ifs
              IdentifierExpr(context: Load, start: 16:16, end: 17:22)
                Value: sebastian
              IdentifierExpr(context: Load, start: 20:20, end: 21:26)
                Value: flounder
    """)
  }
}
