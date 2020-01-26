import XCTest
import Core
import Lexer
@testable import Parser

class ParseSubscript: XCTestCase, Common {

  // MARK: - Subscript index

  /// a[]
  func test_empty_throws() {
    let parser = self.createExprParser(
      self.token(.identifier("a"), start: loc0, end: loc1),
      self.token(.leftSqb,         start: loc2, end: loc3),
      self.token(.rightSqb,        start: loc4, end: loc5)
    )

    if let error = self.error(parser) {
      let kind = ParserErrorKind.unexpectedToken(.rightSqb, expected: [.expression])
      XCTAssertEqual(error.kind, kind)
      XCTAssertEqual(error.location, loc4)
    }
  }

  /// a[1]
  func test_index() {
    let parser = self.createExprParser(
      self.token(.identifier("a"), start: loc0, end: loc1),
      self.token(.leftSqb,         start: loc2, end: loc3),
      self.token(.int(BigInt(1)),  start: loc4, end: loc5),
      self.token(.rightSqb,        start: loc6, end: loc7)
    )

    guard let ast = self.parse(parser) else { return }

    XCTAssertAST(ast, """
    ExpressionAST(start: 0:0, end: 7:12)
      SubscriptExpr(start: 0:0, end: 7:12)
        Object
          IdentifierExpr(start: 0:0, end: 1:6)
            Value: a
        Slice(start: 2:2, end: 7:12)
          Index
            IntExpr(start: 4:4, end: 5:10)
              Value: 1
    """)
  }

  /// a[1,2]
  func test_index_tuple() {
    let parser = self.createExprParser(
      self.token(.identifier("a"), start: loc0, end: loc1),
      self.token(.leftSqb,         start: loc2, end: loc3),
      self.token(.int(BigInt(1)),  start: loc4, end: loc5),
      self.token(.comma,           start: loc6, end: loc7),
      self.token(.int(BigInt(2)),  start: loc8, end: loc9),
      self.token(.rightSqb,        start: loc10, end: loc11)
    )

    guard let ast = self.parse(parser) else { return }

    XCTAssertAST(ast, """
    ExpressionAST(start: 0:0, end: 11:16)
      SubscriptExpr(start: 0:0, end: 11:16)
        Object
          IdentifierExpr(start: 0:0, end: 1:6)
            Value: a
        Slice(start: 2:2, end: 11:16)
          Index
            TupleExpr(start: 4:4, end: 9:14)
              Elements
                IntExpr(start: 4:4, end: 5:10)
                  Value: 1
                IntExpr(start: 8:8, end: 9:14)
                  Value: 2
    """)
  }

  /// a[1,]
  func test_index_withCommaAfter_isTuple() {
    let parser = self.createExprParser(
      self.token(.identifier("a"), start: loc0, end: loc1),
      self.token(.leftSqb,         start: loc2, end: loc3),
      self.token(.int(BigInt(1)),  start: loc4, end: loc5),
      self.token(.comma,           start: loc6, end: loc7),
      self.token(.rightSqb,        start: loc8, end: loc9)
    )

    guard let ast = self.parse(parser) else { return }

    XCTAssertAST(ast, """
    ExpressionAST(start: 0:0, end: 9:14)
      SubscriptExpr(start: 0:0, end: 9:14)
        Object
          IdentifierExpr(start: 0:0, end: 1:6)
            Value: a
        Slice(start: 2:2, end: 9:14)
          Index
            TupleExpr(start: 4:4, end: 5:10)
              Elements
                IntExpr(start: 4:4, end: 5:10)
                  Value: 1
    """)
  }

  // MARK: - Subscript slices

  /// a[::]
  func test_slice_none() {
    let parser = self.createExprParser(
      self.token(.identifier("a"), start: loc0, end: loc1),
      self.token(.leftSqb,         start: loc2, end: loc3),
      self.token(.colon,           start: loc4, end: loc5),
      self.token(.colon,           start: loc6, end: loc7),
      self.token(.rightSqb,        start: loc8, end: loc9)
    )

    guard let ast = self.parse(parser) else { return }

    XCTAssertAST(ast, """
    ExpressionAST(start: 0:0, end: 9:14)
      SubscriptExpr(start: 0:0, end: 9:14)
        Object
          IdentifierExpr(start: 0:0, end: 1:6)
            Value: a
        Slice(start: 2:2, end: 9:14)
          Slice
            Lower: none
            Upper: none
            Step: none
    """)
  }

  /// a[1:]
  func test_slice_lower() {
    let parser = self.createExprParser(
      self.token(.identifier("a"), start: loc0, end: loc1),
      self.token(.leftSqb,         start: loc2, end: loc3),
      self.token(.int(BigInt(1)),  start: loc4, end: loc5),
      self.token(.colon,           start: loc6, end: loc7),
      self.token(.rightSqb,        start: loc8, end: loc9)
    )

    guard let ast = self.parse(parser) else { return }

    XCTAssertAST(ast, """
    ExpressionAST(start: 0:0, end: 9:14)
      SubscriptExpr(start: 0:0, end: 9:14)
        Object
          IdentifierExpr(start: 0:0, end: 1:6)
            Value: a
        Slice(start: 2:2, end: 9:14)
          Slice
            Lower
              IntExpr(start: 4:4, end: 5:10)
                Value: 1
            Upper: none
            Step: none
    """)
  }

  /// a[:2]
  func test_slice_upper() {
    let parser = self.createExprParser(
      self.token(.identifier("a"), start: loc0, end: loc1),
      self.token(.leftSqb,         start: loc2, end: loc3),
      self.token(.colon,           start: loc4, end: loc5),
      self.token(.int(BigInt(2)),  start: loc6, end: loc7),
      self.token(.colon,           start: loc8, end: loc9),
      self.token(.rightSqb,        start: loc10, end: loc11)
    )

    guard let ast = self.parse(parser) else { return }

    XCTAssertAST(ast, """
    ExpressionAST(start: 0:0, end: 11:16)
      SubscriptExpr(start: 0:0, end: 11:16)
        Object
          IdentifierExpr(start: 0:0, end: 1:6)
            Value: a
        Slice(start: 2:2, end: 11:16)
          Slice
            Lower: none
            Upper
              IntExpr(start: 6:6, end: 7:12)
                Value: 2
            Step: none
    """)
  }

  /// a[::3]
  func test_slice_step() {
    let parser = self.createExprParser(
      self.token(.identifier("a"), start: loc0, end: loc1),
      self.token(.leftSqb,         start: loc2, end: loc3),
      self.token(.colon,           start: loc4, end: loc5),
      self.token(.colon,           start: loc6, end: loc7),
      self.token(.int(BigInt(3)),  start: loc8, end: loc9),
      self.token(.rightSqb,        start: loc10, end: loc11)
    )

    guard let ast = self.parse(parser) else { return }

    XCTAssertAST(ast, """
    ExpressionAST(start: 0:0, end: 11:16)
      SubscriptExpr(start: 0:0, end: 11:16)
        Object
          IdentifierExpr(start: 0:0, end: 1:6)
            Value: a
        Slice(start: 2:2, end: 11:16)
          Slice
            Lower: none
            Upper: none
            Step
              IntExpr(start: 8:8, end: 9:14)
                Value: 3
    """)
  }

  /// a[1:2:3]
  func test_slice_all() {
    let parser = self.createExprParser(
      self.token(.identifier("a"), start: loc0, end: loc1),
      self.token(.leftSqb,         start: loc2, end: loc3),
      self.token(.int(BigInt(1)),  start: loc4, end: loc5),
      self.token(.colon,           start: loc6, end: loc7),
      self.token(.int(BigInt(2)),  start: loc8, end: loc9),
      self.token(.colon,           start: loc10, end: loc11),
      self.token(.int(BigInt(3)),  start: loc12, end: loc13),
      self.token(.rightSqb,        start: loc14, end: loc15)
    )

    guard let ast = self.parse(parser) else { return }

    XCTAssertAST(ast, """
    ExpressionAST(start: 0:0, end: 15:20)
      SubscriptExpr(start: 0:0, end: 15:20)
        Object
          IdentifierExpr(start: 0:0, end: 1:6)
            Value: a
        Slice(start: 2:2, end: 15:20)
          Slice
            Lower
              IntExpr(start: 4:4, end: 5:10)
                Value: 1
            Upper
              IntExpr(start: 8:8, end: 9:14)
                Value: 2
            Step
              IntExpr(start: 12:12, end: 13:18)
                Value: 3
    """)
  }

  // MARK: - Subscript extended

  /// a[1:,2]
  func test_extSlice() {
    let parser = self.createExprParser(
      self.token(.identifier("a"), start: loc0, end: loc1),
      self.token(.leftSqb,         start: loc2, end: loc3),
      self.token(.int(BigInt(1)),  start: loc4, end: loc5),
      self.token(.colon,           start: loc6, end: loc7),
      self.token(.comma,           start: loc8, end: loc9),
      self.token(.int(BigInt(2)),  start: loc10, end: loc11),
      self.token(.rightSqb,        start: loc12, end: loc13)
    )

    guard let ast = self.parse(parser) else { return }

    XCTAssertAST(ast, """
    ExpressionAST(start: 0:0, end: 13:18)
      SubscriptExpr(start: 0:0, end: 13:18)
        Object
          IdentifierExpr(start: 0:0, end: 1:6)
            Value: a
        Slice(start: 2:2, end: 13:18)
          ExtSlice
            Slice(start: 4:4, end: 7:12)
              Slice
                Lower
                  IntExpr(start: 4:4, end: 5:10)
                    Value: 1
                Upper: none
                Step: none
            Slice(start: 10:10, end: 11:16)
              Index
                IntExpr(start: 10:10, end: 11:16)
                  Value: 2
    """)
  }
}
