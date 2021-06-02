import XCTest
import BigInt
import VioletCore
import VioletLexer
@testable import VioletParser

// swiftformat:disable consecutiveSpaces

class ParseAnnAssign: XCTestCase {

  /// Flounder:Animal = "Friend"
  func test_simple() {
    let parser = createStmtParser(
      createToken(.identifier("Flounder"), start: loc0, end: loc1),
      createToken(.colon,                  start: loc2, end: loc3),
      createToken(.identifier("Animal"),   start: loc4, end: loc5),
      createToken(.equal,                  start: loc6, end: loc7),
      createToken(.string("Friend"),       start: loc8, end: loc9)
    )

    guard let ast = parse(parser) else { return }

    XCTAssertAST(ast, """
    ModuleAST(start: 0:0, end: 9:14)
      AnnAssignStmt(start: 0:0, end: 9:14)
        Target
          IdentifierExpr(context: Store, start: 0:0, end: 1:6)
            Value: Flounder
        Annotation
          IdentifierExpr(context: Load, start: 4:4, end: 5:10)
            Value: Animal
        Value
          StringExpr(context: Load, start: 8:8, end: 9:14)
            String: 'Friend'
        IsSimple: true
    """)
  }

  /// Ariel:Mermaid
  func test_withoutValue() {
    let parser = createStmtParser(
      createToken(.identifier("Ariel"),   start: loc0, end: loc1),
      createToken(.colon,                 start: loc2, end: loc3),
      createToken(.identifier("Mermaid"), start: loc4, end: loc5)
    )

    guard let ast = parse(parser) else { return }

    XCTAssertAST(ast, """
    ModuleAST(start: 0:0, end: 5:10)
      AnnAssignStmt(start: 0:0, end: 5:10)
        Target
          IdentifierExpr(context: Store, start: 0:0, end: 1:6)
            Value: Ariel
        Annotation
          IdentifierExpr(context: Load, start: 4:4, end: 5:10)
            Value: Mermaid
        Value: none
        IsSimple: true
    """)
  }

  /// Sea.Flounder:Animal = "Friend"
  func test_toAttribute() {

    let parser = createStmtParser(
      createToken(.identifier("Sea"),      start: loc0, end: loc1),
      createToken(.dot,                    start: loc2, end: loc3),
      createToken(.identifier("Flounder"), start: loc4, end: loc5),
      createToken(.colon,                  start: loc6, end: loc7),
      createToken(.identifier("Animal"),   start: loc8, end: loc9),
      createToken(.equal,                  start: loc10, end: loc11),
      createToken(.string("Friend"),       start: loc12, end: loc13)
    )

    guard let ast = parse(parser) else { return }

    // Note that in this test 'IsSimple: false'!
    XCTAssertAST(ast, """
    ModuleAST(start: 0:0, end: 13:18)
      AnnAssignStmt(start: 0:0, end: 13:18)
        Target
          AttributeExpr(context: Store, start: 0:0, end: 5:10)
            Object
              IdentifierExpr(context: Load, start: 0:0, end: 1:6)
                Value: Sea
            Name: Flounder
        Annotation
          IdentifierExpr(context: Load, start: 8:8, end: 9:14)
            Value: Animal
        Value
          StringExpr(context: Load, start: 12:12, end: 13:18)
            String: 'Friend'
        IsSimple: false
    """)
  }

  /// Sea[Flounder]:Animal = "Friend"
  func test_toSubscript() {
    let parser = createStmtParser(
      createToken(.identifier("Sea"),      start: loc0, end: loc1),
      createToken(.leftSqb,                start: loc2, end: loc3),
      createToken(.identifier("Flounder"), start: loc4, end: loc5),
      createToken(.rightSqb,               start: loc6, end: loc7),
      createToken(.colon,                  start: loc8, end: loc9),
      createToken(.identifier("Animal"),   start: loc10, end: loc11),
      createToken(.equal,                  start: loc12, end: loc13),
      createToken(.string("Friend"),       start: loc14, end: loc15)
    )

    guard let ast = parse(parser) else { return }

    XCTAssertAST(ast, """
    ModuleAST(start: 0:0, end: 15:20)
      AnnAssignStmt(start: 0:0, end: 15:20)
        Target
          SubscriptExpr(context: Store, start: 0:0, end: 7:12)
            Object
              IdentifierExpr(context: Load, start: 0:0, end: 1:6)
                Value: Sea
            Slice(start: 2:2, end: 7:12)
              Index
                IdentifierExpr(context: Load, start: 4:4, end: 5:10)
                  Value: Flounder
        Annotation
          IdentifierExpr(context: Load, start: 10:10, end: 11:16)
            Value: Animal
        Value
          StringExpr(context: Load, start: 14:14, end: 15:20)
            String: 'Friend'
        IsSimple: false
    """)
  }

  /// (Ariel):Mermaid = "Princess"
  func test_inParen_isNotSimple() {
    let parser = createStmtParser(
      createToken(.leftParen,             start: loc0, end: loc1),
      createToken(.identifier("Ariel"),   start: loc2, end: loc3),
      createToken(.rightParen,            start: loc4, end: loc5),
      createToken(.colon,                 start: loc6, end: loc7),
      createToken(.identifier("Mermaid"), start: loc8, end: loc9),
      createToken(.equal,                 start: loc10, end: loc11),
      createToken(.string("Princess"),    start: loc12, end: loc13)
    )

    guard let ast = parse(parser) else { return }

    XCTAssertAST(ast, """
    ModuleAST(start: 0:0, end: 13:18)
      AnnAssignStmt(start: 0:0, end: 13:18)
        Target
          IdentifierExpr(context: Store, start: 0:0, end: 5:10)
            Value: Ariel
        Annotation
          IdentifierExpr(context: Load, start: 8:8, end: 9:14)
            Value: Mermaid
        Value
          StringExpr(context: Load, start: 12:12, end: 13:18)
            String: 'Princess'
        IsSimple: false
    """)
  }

  /// 3:Witch = "Ursula"
  func test_toConstants_throws() {
    let parser = createStmtParser(
      createToken(.int(BigInt(3)),       start: loc0, end: loc1),
      createToken(.colon,                start: loc2, end: loc3),
      createToken(.identifier("Witch"),  start: loc4, end: loc5),
      createToken(.equal,                start: loc6, end: loc7),
      createToken(.string("Ursula"),     start: loc8, end: loc9)
    )

    if let error = parseError(parser) {
      XCTAssertEqual(error.kind, .illegalAnnAssignmentTarget)
      XCTAssertEqual(error.location, loc0)
    }
  }
}
