import XCTest
import VioletCore
import VioletLexer
@testable import VioletParser

// swiftformat:disable consecutiveSpaces

class ParseImport: XCTestCase, Common {

  /// import Rapunzel
  func test_simple() {
    let parser = self.createStmtParser(
      self.token(.import,                 start: loc0, end: loc1),
      self.token(.identifier("Rapunzel"), start: loc2, end: loc3)
    )

    guard let ast = self.parse(parser) else { return }

    XCTAssertAST(ast, """
    ModuleAST(start: 0:0, end: 3:8)
      ImportStmt(start: 0:0, end: 3:8)
        Aliases
          Alias(start: 2:2, end: 3:8)
            Name: Rapunzel
            AsName: none
    """)
  }

  /// import Tangled.Rapunzel
  func test_nested() {
    let parser = self.createStmtParser(
      self.token(.import,                 start: loc0, end: loc1),
      self.token(.identifier("Tangled"),  start: loc2, end: loc3),
      self.token(.dot,                    start: loc4, end: loc5),
      self.token(.identifier("Rapunzel"), start: loc6, end: loc7)
    )

    guard let ast = self.parse(parser) else { return }

    XCTAssertAST(ast, """
    ModuleAST(start: 0:0, end: 7:12)
      ImportStmt(start: 0:0, end: 7:12)
        Aliases
          Alias(start: 2:2, end: 7:12)
            Name: Tangled.Rapunzel
            AsName: none
    """)
  }

  /// import Rapunzel as Daughter
  func test_withAlias() {
    let parser = self.createStmtParser(
      self.token(.import,                 start: loc0, end: loc1),
      self.token(.identifier("Rapunzel"), start: loc2, end: loc3),
      self.token(.as,                     start: loc4, end: loc5),
      self.token(.identifier("Daughter"), start: loc6, end: loc7)
    )

    guard let ast = self.parse(parser) else { return }

    XCTAssertAST(ast, """
    ModuleAST(start: 0:0, end: 7:12)
      ImportStmt(start: 0:0, end: 7:12)
        Aliases
          Alias(start: 2:2, end: 7:12)
            Name: Rapunzel
            AsName: Daughter
    """)
  }

  /// import Rapunzel as Daughter, Pascal
  func test_multiple() {
    let parser = self.createStmtParser(
      self.token(.import,                 start: loc0, end: loc1),
      self.token(.identifier("Rapunzel"), start: loc2, end: loc3),
      self.token(.as,                     start: loc4, end: loc5),
      self.token(.identifier("Daughter"), start: loc6, end: loc7),
      self.token(.comma,                  start: loc8, end: loc9),
      self.token(.identifier("Pascal"),   start: loc10, end: loc11)
    )

    guard let ast = self.parse(parser) else { return }

    XCTAssertAST(ast, """
    ModuleAST(start: 0:0, end: 11:16)
      ImportStmt(start: 0:0, end: 11:16)
        Aliases
          Alias(start: 2:2, end: 7:12)
            Name: Rapunzel
            AsName: Daughter
          Alias(start: 10:10, end: 11:16)
            Name: Pascal
            AsName: none
    """)
  }
}
