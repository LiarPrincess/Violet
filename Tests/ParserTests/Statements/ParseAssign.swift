import XCTest
import Core
import Lexer
@testable import Parser

class ParseAssign: XCTestCase, Common {

  // MARK: - Normal assignment

  /// Ariel = "Princess"
  func test_simple() {
    let parser = self.createStmtParser(
      self.token(.identifier("Ariel"), start: loc0, end: loc1),
      self.token(.equal,               start: loc2, end: loc3),
      self.token(.string("Princess"),  start: loc4, end: loc5)
    )

    guard let ast = self.parse(parser) else { return }

    XCTAssertAST(ast, """
    ModuleAST(start: 0:0, end: 5:10)
      AssignStmt(start: 0:0, end: 5:10)
        Targets
          IdentifierExpr(start: 0:0, end: 1:6)
            Value: Ariel
        Value
          StringExpr(start: 4:4, end: 5:10)
            String: 'Princess'
    """)
  }

  /// Ariel, Eric = "couple"
  func test_toTuple() {
    let parser = self.createStmtParser(
      self.token(.identifier("Ariel"), start: loc0, end: loc1),
      self.token(.comma,               start: loc2, end: loc3),
      self.token(.identifier("Eric"),  start: loc4, end: loc5),
      self.token(.equal,               start: loc6, end: loc7),
      self.token(.string("couple"),    start: loc8, end: loc9)
    )

    guard let ast = self.parse(parser) else { return }

    XCTAssertAST(ast, """
    ModuleAST(start: 0:0, end: 9:14)
      AssignStmt(start: 0:0, end: 9:14)
        Targets
          TupleExpr(start: 0:0, end: 5:10)
            Elements
              IdentifierExpr(start: 0:0, end: 1:6)
                Value: Ariel
              IdentifierExpr(start: 4:4, end: 5:10)
                Value: Eric
        Value
          StringExpr(start: 8:8, end: 9:14)
            String: 'couple'
    """)
  }

  /// Ariel, = "Princess"
  func test_target_withComma_isTuple() {
    let parser = self.createStmtParser(
      self.token(.identifier("Ariel"), start: loc0, end: loc1),
      self.token(.comma,               start: loc2, end: loc3),
      self.token(.equal,               start: loc4, end: loc5),
      self.token(.string("Princess"),  start: loc6, end: loc7)
    )

    guard let ast = self.parse(parser) else { return }

    XCTAssertAST(ast, """
    ModuleAST(start: 0:0, end: 7:12)
      AssignStmt(start: 0:0, end: 7:12)
        Targets
          TupleExpr(start: 0:0, end: 3:8)
            Elements
              IdentifierExpr(start: 0:0, end: 1:6)
                Value: Ariel
        Value
          StringExpr(start: 6:6, end: 7:12)
            String: 'Princess'
    """)
  }

  /// Sebastian = Flounder = "Friend"
  func test_target_multiple() {
    let parser = self.createStmtParser(
      self.token(.identifier("Sebastian"), start: loc0, end: loc1),
      self.token(.equal,                   start: loc2, end: loc3),
      self.token(.identifier("Flounder"),  start: loc4, end: loc5),
      self.token(.equal,                   start: loc6, end: loc7),
      self.token(.string("Friend"),        start: loc8, end: loc9)
    )

    guard let ast = self.parse(parser) else { return }

    XCTAssertAST(ast, """
    ModuleAST(start: 0:0, end: 9:14)
      AssignStmt(start: 0:0, end: 9:14)
        Targets
          IdentifierExpr(start: 0:0, end: 1:6)
            Value: Sebastian
          IdentifierExpr(start: 4:4, end: 5:10)
            Value: Flounder
        Value
          StringExpr(start: 8:8, end: 9:14)
            String: 'Friend'
    """)
  }

  // MARK: - Yield

  /// Ariel = yield "Princess"
  func test_yieldValue() {
    let parser = self.createStmtParser(
      self.token(.identifier("Ariel"), start: loc0, end: loc1),
      self.token(.equal,               start: loc2, end: loc3),
      self.token(.yield,               start: loc4, end: loc5),
      self.token(.string("Princess"),  start: loc6, end: loc7)
    )

    guard let ast = self.parse(parser) else { return }

    XCTAssertAST(ast, """
    ModuleAST(start: 0:0, end: 7:12)
      AssignStmt(start: 0:0, end: 7:12)
        Targets
          IdentifierExpr(start: 0:0, end: 1:6)
            Value: Ariel
        Value
          YieldExpr(start: 4:4, end: 7:12)
            Value
              StringExpr(start: 6:6, end: 7:12)
                String: 'Princess'
    """)
  }

  /// Ariel = yield Eric = "couple"
  /// If we used 'yield a = xxx' then it is 'yield stmt' by grammar
  func test_yieldTarget() {
    let parser = self.createStmtParser(
      self.token(.identifier("Ariel"), start: loc0, end: loc1),
      self.token(.equal,               start: loc2, end: loc3),
      self.token(.yield,               start: loc4, end: loc5),
      self.token(.identifier("Eric"),  start: loc6, end: loc7),
      self.token(.equal,               start: loc8, end: loc9),
      self.token(.string("couple"),    start: loc10, end: loc11)
    )

    if let error = self.error(parser) {
      XCTAssertEqual(error.kind, .assignmentToYield)
      XCTAssertEqual(error.location, loc4)
    }
  }
}
