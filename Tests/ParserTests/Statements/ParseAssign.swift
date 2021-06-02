import XCTest
import VioletCore
import VioletLexer
@testable import VioletParser

// swiftformat:disable consecutiveSpaces

class ParseAssign: XCTestCase {

  // MARK: - Normal assignment

  /// Ariel = "Princess"
  func test_simple() {
    let parser = createStmtParser(
      createToken(.identifier("Ariel"), start: loc0, end: loc1),
      createToken(.equal,               start: loc2, end: loc3),
      createToken(.string("Princess"),  start: loc4, end: loc5)
    )

    guard let ast = parse(parser) else { return }

    XCTAssertAST(ast, """
    ModuleAST(start: 0:0, end: 5:10)
      AssignStmt(start: 0:0, end: 5:10)
        Targets
          IdentifierExpr(context: Store, start: 0:0, end: 1:6)
            Value: Ariel
        Value
          StringExpr(context: Load, start: 4:4, end: 5:10)
            String: 'Princess'
    """)
  }

  /// Ariel, Eric = "couple"
  func test_toTuple() {
    let parser = createStmtParser(
      createToken(.identifier("Ariel"), start: loc0, end: loc1),
      createToken(.comma,               start: loc2, end: loc3),
      createToken(.identifier("Eric"),  start: loc4, end: loc5),
      createToken(.equal,               start: loc6, end: loc7),
      createToken(.string("couple"),    start: loc8, end: loc9)
    )

    guard let ast = parse(parser) else { return }

    XCTAssertAST(ast, """
    ModuleAST(start: 0:0, end: 9:14)
      AssignStmt(start: 0:0, end: 9:14)
        Targets
          TupleExpr(context: Store, start: 0:0, end: 5:10)
            Elements
              IdentifierExpr(context: Store, start: 0:0, end: 1:6)
                Value: Ariel
              IdentifierExpr(context: Store, start: 4:4, end: 5:10)
                Value: Eric
        Value
          StringExpr(context: Load, start: 8:8, end: 9:14)
            String: 'couple'
    """)
  }

  /// Ariel, = "Princess"
  func test_target_withComma_isTuple() {
    let parser = createStmtParser(
      createToken(.identifier("Ariel"), start: loc0, end: loc1),
      createToken(.comma,               start: loc2, end: loc3),
      createToken(.equal,               start: loc4, end: loc5),
      createToken(.string("Princess"),  start: loc6, end: loc7)
    )

    guard let ast = parse(parser) else { return }

    XCTAssertAST(ast, """
    ModuleAST(start: 0:0, end: 7:12)
      AssignStmt(start: 0:0, end: 7:12)
        Targets
          TupleExpr(context: Store, start: 0:0, end: 3:8)
            Elements
              IdentifierExpr(context: Store, start: 0:0, end: 1:6)
                Value: Ariel
        Value
          StringExpr(context: Load, start: 6:6, end: 7:12)
            String: 'Princess'
    """)
  }

  /// Sebastian = Flounder = "Friend"
  func test_target_multiple() {
    let parser = createStmtParser(
      createToken(.identifier("Sebastian"), start: loc0, end: loc1),
      createToken(.equal,                   start: loc2, end: loc3),
      createToken(.identifier("Flounder"),  start: loc4, end: loc5),
      createToken(.equal,                   start: loc6, end: loc7),
      createToken(.string("Friend"),        start: loc8, end: loc9)
    )

    guard let ast = parse(parser) else { return }

    XCTAssertAST(ast, """
    ModuleAST(start: 0:0, end: 9:14)
      AssignStmt(start: 0:0, end: 9:14)
        Targets
          IdentifierExpr(context: Store, start: 0:0, end: 1:6)
            Value: Sebastian
          IdentifierExpr(context: Store, start: 4:4, end: 5:10)
            Value: Flounder
        Value
          StringExpr(context: Load, start: 8:8, end: 9:14)
            String: 'Friend'
    """)
  }

  // MARK: - Yield

  /// Ariel = yield "Princess"
  func test_yieldValue() {
    let parser = createStmtParser(
      createToken(.identifier("Ariel"), start: loc0, end: loc1),
      createToken(.equal,               start: loc2, end: loc3),
      createToken(.yield,               start: loc4, end: loc5),
      createToken(.string("Princess"),  start: loc6, end: loc7)
    )

    guard let ast = parse(parser) else { return }

    XCTAssertAST(ast, """
    ModuleAST(start: 0:0, end: 7:12)
      AssignStmt(start: 0:0, end: 7:12)
        Targets
          IdentifierExpr(context: Store, start: 0:0, end: 1:6)
            Value: Ariel
        Value
          YieldExpr(context: Load, start: 4:4, end: 7:12)
            Value
              StringExpr(context: Load, start: 6:6, end: 7:12)
                String: 'Princess'
    """)
  }

  /// Ariel = yield Eric = "couple"
  /// If we used 'yield a = xxx' then it is 'yield stmt' by grammar
  func test_yieldTarget() {
    let parser = createStmtParser(
      createToken(.identifier("Ariel"), start: loc0, end: loc1),
      createToken(.equal,               start: loc2, end: loc3),
      createToken(.yield,               start: loc4, end: loc5),
      createToken(.identifier("Eric"),  start: loc6, end: loc7),
      createToken(.equal,               start: loc8, end: loc9),
      createToken(.string("couple"),    start: loc10, end: loc11)
    )

    if let error = parseError(parser) {
      XCTAssertEqual(error.kind, .assignmentToYield)
      XCTAssertEqual(error.location, loc4)
    }
  }
}
