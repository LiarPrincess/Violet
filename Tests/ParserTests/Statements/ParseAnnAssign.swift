import XCTest
import VioletCore
import VioletLexer
@testable import VioletParser

class ParseAnnAssign: XCTestCase, Common {

  /// Flounder:Animal = "Friend"
  func test_simple() {
    let parser = self.createStmtParser(
      self.token(.identifier("Flounder"), start: loc0, end: loc1),
      self.token(.colon,                  start: loc2, end: loc3),
      self.token(.identifier("Animal"),   start: loc4, end: loc5),
      self.token(.equal,                  start: loc6, end: loc7),
      self.token(.string("Friend"),       start: loc8, end: loc9)
    )

    guard let ast = self.parse(parser) else { return }

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
    let parser = self.createStmtParser(
      self.token(.identifier("Ariel"),   start: loc0, end: loc1),
      self.token(.colon,                 start: loc2, end: loc3),
      self.token(.identifier("Mermaid"), start: loc4, end: loc5)
    )

    guard let ast = self.parse(parser) else { return }

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

    let parser = self.createStmtParser(
      self.token(.identifier("Sea"),      start: loc0, end: loc1),
      self.token(.dot,                    start: loc2, end: loc3),
      self.token(.identifier("Flounder"), start: loc4, end: loc5),
      self.token(.colon,                  start: loc6, end: loc7),
      self.token(.identifier("Animal"),   start: loc8, end: loc9),
      self.token(.equal,                  start: loc10, end: loc11),
      self.token(.string("Friend"),       start: loc12, end: loc13)
    )

    guard let ast = self.parse(parser) else { return }

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
    let parser = self.createStmtParser(
      self.token(.identifier("Sea"),      start: loc0, end: loc1),
      self.token(.leftSqb,                start: loc2, end: loc3),
      self.token(.identifier("Flounder"), start: loc4, end: loc5),
      self.token(.rightSqb,               start: loc6, end: loc7),
      self.token(.colon,                  start: loc8, end: loc9),
      self.token(.identifier("Animal"),   start: loc10, end: loc11),
      self.token(.equal,                  start: loc12, end: loc13),
      self.token(.string("Friend"),       start: loc14, end: loc15)
    )

    guard let ast = self.parse(parser) else { return }

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
    let parser = self.createStmtParser(
      self.token(.leftParen,             start: loc0, end: loc1),
      self.token(.identifier("Ariel"),   start: loc2, end: loc3),
      self.token(.rightParen,            start: loc4, end: loc5),
      self.token(.colon,                 start: loc6, end: loc7),
      self.token(.identifier("Mermaid"), start: loc8, end: loc9),
      self.token(.equal,                 start: loc10, end: loc11),
      self.token(.string("Princess"),    start: loc12, end: loc13)
    )

    guard let ast = self.parse(parser) else { return }

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
    let parser = self.createStmtParser(
      self.token(.int(BigInt(3)),       start: loc0, end: loc1),
      self.token(.colon,                start: loc2, end: loc3),
      self.token(.identifier("Witch"),  start: loc4, end: loc5),
      self.token(.equal,                start: loc6, end: loc7),
      self.token(.string("Ursula"),     start: loc8, end: loc9)
    )

    if let error = self.error(parser) {
      XCTAssertEqual(error.kind, .illegalAnnAssignmentTarget)
      XCTAssertEqual(error.location, loc0)
    }
  }
}
