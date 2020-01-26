import XCTest
import Core
import Lexer
@testable import Parser

// swiftlint:disable file_length
// swiftlint:disable function_body_length

class ParseList: XCTestCase, Common {

  // MARK: - List

  /// []
  func test_empty() {
    let parser = self.createExprParser(
      self.token(.leftSqb,  start: loc0, end: loc1),
      self.token(.rightSqb, start: loc2, end: loc3)
    )

    guard let ast = self.parse(parser) else { return }

    XCTAssertAST(ast, """
    ExpressionAST(start: 0:0, end: 3:8)
      ListExpr(start: 0:0, end: 3:8)
        Elements: none
    """)
  }

  /// [ariel]
  func test_value() {
    let parser = self.createExprParser(
      self.token(.leftSqb,             start: loc0, end: loc1),
      self.token(.identifier("ariel"), start: loc2, end: loc3),
      self.token(.rightSqb,            start: loc4, end: loc5)
    )

    guard let ast = self.parse(parser) else { return }

    XCTAssertAST(ast, """
    ExpressionAST(start: 0:0, end: 5:10)
      ListExpr(start: 0:0, end: 5:10)
        Elements
          IdentifierExpr(start: 2:2, end: 3:8)
            Value: ariel
    """)
  }

  /// [ariel,]
  func test_value_withComaAfter() {
    let parser = self.createExprParser(
      self.token(.leftSqb,             start: loc0, end: loc1),
      self.token(.identifier("ariel"), start: loc2, end: loc3),
      self.token(.comma,               start: loc4, end: loc5),
      self.token(.rightSqb,            start: loc6, end: loc7)
    )

    guard let ast = self.parse(parser) else { return }

    XCTAssertAST(ast, """
    ExpressionAST(start: 0:0, end: 7:12)
      ListExpr(start: 0:0, end: 7:12)
        Elements
          IdentifierExpr(start: 2:2, end: 3:8)
            Value: ariel
    """)
  }

  /// [ariel, eric]
  func test_value_multiple() {
    let parser = self.createExprParser(
      self.token(.leftSqb,             start: loc0, end: loc1),
      self.token(.identifier("ariel"), start: loc2, end: loc3),
      self.token(.comma,               start: loc4, end: loc5),
      self.token(.identifier("eric"),  start: loc6, end: loc7),
      self.token(.rightSqb,            start: loc8, end: loc9)
    )

    guard let ast = self.parse(parser) else { return }

    XCTAssertAST(ast, """
    ExpressionAST(start: 0:0, end: 9:14)
      ListExpr(start: 0:0, end: 9:14)
        Elements
          IdentifierExpr(start: 2:2, end: 3:8)
            Value: ariel
          IdentifierExpr(start: 6:6, end: 7:12)
            Value: eric
    """)
  }

  // MARK: - Comprehension

  /// [ariel for eric in []]
  func test_comprehension_list() {
    let parser = self.createExprParser(
      self.token(.leftSqb,         start: loc0, end: loc1),
      self.token(.identifier("ariel"), start: loc2, end: loc3),
      self.token(.for,             start: loc4, end: loc5),
      self.token(.identifier("eric"), start: loc6, end: loc7),
      self.token(.in,              start: loc8, end: loc9),
      self.token(.leftSqb,         start: loc10, end: loc11),
      self.token(.rightSqb,        start: loc12, end: loc13),
      self.token(.rightSqb,        start: loc14, end: loc15)
    )

    guard let ast = self.parse(parser) else { return }

    XCTAssertAST(ast, """
    ExpressionAST(start: 0:0, end: 15:20)
      ListComprehensionExpr(start: 0:0, end: 15:20)
        Element
          IdentifierExpr(start: 2:2, end: 3:8)
            Value: ariel
        Generators
          Comprehension(start: 4:4, end: 13:18)
            isAsync: false
            Target
              IdentifierExpr(start: 6:6, end: 7:12)
                Value: eric
            Iterable
              ListExpr(start: 10:10, end: 13:18)
                Elements: none
            Ifs: none
    """)
  }

  /// [ariel async for eric in []]
  func test_comprehension_async() {
    let parser = self.createExprParser(
      self.token(.leftSqb,             start: loc0, end: loc1),
      self.token(.identifier("ariel"), start: loc2, end: loc3),
      self.token(.async,               start: loc4, end: loc5),
      self.token(.for,                 start: loc6, end: loc7),
      self.token(.identifier("eric"),  start: loc8, end: loc9),
      self.token(.in,                  start: loc10, end: loc11),
      self.token(.leftSqb,             start: loc12, end: loc13),
      self.token(.rightSqb,            start: loc14, end: loc15),
      self.token(.rightSqb,            start: loc16, end: loc17)
    )

    guard let ast = self.parse(parser) else { return }

    XCTAssertAST(ast, """
  ExpressionAST(start: 0:0, end: 17:22)
    ListComprehensionExpr(start: 0:0, end: 17:22)
      Element
        IdentifierExpr(start: 2:2, end: 3:8)
          Value: ariel
      Generators
        Comprehension(start: 4:4, end: 15:20)
          isAsync: true
          Target
            IdentifierExpr(start: 8:8, end: 9:14)
              Value: eric
          Iterable
            ListExpr(start: 12:12, end: 15:20)
              Elements: none
          Ifs: none
  """)
  }

  /// [ariel for eric, sebastian in []]
  func test_comprehension_target_multiple() {
    let parser = self.createExprParser(
      self.token(.leftSqb,                 start: loc0, end: loc1),
      self.token(.identifier("ariel"),     start: loc2, end: loc3),
      self.token(.for,                     start: loc4, end: loc5),
      self.token(.identifier("eric"),      start: loc6, end: loc7),
      self.token(.comma,                   start: loc8, end: loc9),
      self.token(.identifier("sebastian"), start: loc10, end: loc11),
      self.token(.in,                      start: loc12, end: loc13),
      self.token(.leftSqb,                 start: loc14, end: loc15),
      self.token(.rightSqb,                start: loc16, end: loc17),
      self.token(.rightSqb,                start: loc18, end: loc19)
    )

    guard let ast = self.parse(parser) else { return }

    XCTAssertAST(ast, """
    ExpressionAST(start: 0:0, end: 19:24)
      ListComprehensionExpr(start: 0:0, end: 19:24)
        Element
          IdentifierExpr(start: 2:2, end: 3:8)
            Value: ariel
        Generators
          Comprehension(start: 4:4, end: 17:22)
            isAsync: false
            Target
              TupleExpr(start: 6:6, end: 11:16)
                Elements
                  IdentifierExpr(start: 6:6, end: 7:12)
                    Value: eric
                  IdentifierExpr(start: 10:10, end: 11:16)
                    Value: sebastian
            Iterable
              ListExpr(start: 14:14, end: 17:22)
                Elements: none
            Ifs: none
    """)
  }

  /// [ariel for eric, in []]
  func test_comprehension_target_withCommaAfter_isTuple() {
    let parser = self.createExprParser(
      self.token(.leftSqb,             start: loc0, end: loc1),
      self.token(.identifier("ariel"), start: loc2, end: loc3),
      self.token(.for,                 start: loc4, end: loc5),
      self.token(.identifier("eric"),  start: loc6, end: loc7),
      self.token(.comma,               start: loc8, end: loc9),
      self.token(.in,                  start: loc10, end: loc11),
      self.token(.leftSqb,             start: loc12, end: loc13),
      self.token(.rightSqb,            start: loc14, end: loc15),
      self.token(.rightSqb,            start: loc16, end: loc17)
    )

    guard let ast = self.parse(parser) else { return }

    XCTAssertAST(ast, """
    ExpressionAST(start: 0:0, end: 17:22)
      ListComprehensionExpr(start: 0:0, end: 17:22)
        Element
          IdentifierExpr(start: 2:2, end: 3:8)
            Value: ariel
        Generators
          Comprehension(start: 4:4, end: 15:20)
            isAsync: false
            Target
              TupleExpr(start: 6:6, end: 9:14)
                Elements
                  IdentifierExpr(start: 6:6, end: 7:12)
                    Value: eric
            Iterable
              ListExpr(start: 12:12, end: 15:20)
                Elements: none
            Ifs: none
    """)
  }

  /// [ariel for eric in [] for sebastian in []]
  func test_comprehension_for_multiple() {
    let parser = self.createExprParser(
      self.token(.leftSqb,                 start: loc0, end: loc1),
      self.token(.identifier("ariel"),     start: loc2, end: loc3),
      self.token(.for,                     start: loc4, end: loc5),
      self.token(.identifier("eric"),      start: loc6, end: loc7),
      self.token(.in,                      start: loc8, end: loc9),
      self.token(.leftSqb,                 start: loc10, end: loc11),
      self.token(.rightSqb,                start: loc12, end: loc13),
      self.token(.for,                     start: loc14, end: loc15),
      self.token(.identifier("sebastian"), start: loc16, end: loc17),
      self.token(.in,                      start: loc18, end: loc19),
      self.token(.leftSqb,                 start: loc20, end: loc21),
      self.token(.rightSqb,                start: loc22, end: loc23),
      self.token(.rightSqb,                start: loc24, end: loc25)
    )

    guard let ast = self.parse(parser) else { return }

    XCTAssertAST(ast, """
    ExpressionAST(start: 0:0, end: 25:30)
      ListComprehensionExpr(start: 0:0, end: 25:30)
        Element
          IdentifierExpr(start: 2:2, end: 3:8)
            Value: ariel
        Generators
          Comprehension(start: 4:4, end: 13:18)
            isAsync: false
            Target
              IdentifierExpr(start: 6:6, end: 7:12)
                Value: eric
            Iterable
              ListExpr(start: 10:10, end: 13:18)
                Elements: none
            Ifs: none
          Comprehension(start: 14:14, end: 23:28)
            isAsync: false
            Target
              IdentifierExpr(start: 16:16, end: 17:22)
                Value: sebastian
            Iterable
              ListExpr(start: 20:20, end: 23:28)
                Elements: none
            Ifs: none
    """)
  }

  /// [ariel for eric in [] if sebastian if flounder]
  func test_comprehension_ifs_multiple() {
    let parser = self.createExprParser(
      self.token(.leftSqb,                 start: loc0, end: loc1),
      self.token(.identifier("ariel"),     start: loc2, end: loc3),
      self.token(.for,                     start: loc4, end: loc5),
      self.token(.identifier("eric"),      start: loc6, end: loc7),
      self.token(.in,                      start: loc8, end: loc9),
      self.token(.leftSqb,                 start: loc10, end: loc11),
      self.token(.rightSqb,                start: loc12, end: loc13),
      self.token(.if,                      start: loc14, end: loc15),
      self.token(.identifier("sebastian"), start: loc16, end: loc17),
      self.token(.if,                      start: loc18, end: loc19),
      self.token(.identifier("flounder"),  start: loc20, end: loc21),
      self.token(.rightSqb,                start: loc22, end: loc23)
    )

    guard let ast = self.parse(parser) else { return }

    XCTAssertAST(ast, """
    ExpressionAST(start: 0:0, end: 23:28)
      ListComprehensionExpr(start: 0:0, end: 23:28)
        Element
          IdentifierExpr(start: 2:2, end: 3:8)
            Value: ariel
        Generators
          Comprehension(start: 4:4, end: 21:26)
            isAsync: false
            Target
              IdentifierExpr(start: 6:6, end: 7:12)
                Value: eric
            Iterable
              ListExpr(start: 10:10, end: 13:18)
                Elements: none
            Ifs
              IdentifierExpr(start: 16:16, end: 17:22)
                Value: sebastian
              IdentifierExpr(start: 20:20, end: 21:26)
                Value: flounder
    """)
  }
}
