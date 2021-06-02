import XCTest
import VioletCore
import VioletLexer
@testable import VioletParser

// swiftformat:disable consecutiveSpaces

class ParseImportFrom: XCTestCase {

  /// from Tangled import Rapunzel
  func test_module() {
    let parser = createStmtParser(
      createToken(.from,                   start: loc0, end: loc1),
      createToken(.identifier("Tangled"),  start: loc2, end: loc3),
      createToken(.import,                 start: loc4, end: loc5),
      createToken(.identifier("Rapunzel"), start: loc6, end: loc7)
    )

    guard let ast = parse(parser) else { return }

    XCTAssertAST(ast, """
    ModuleAST(start: 0:0, end: 7:12)
      ImportFromStmt(start: 0:0, end: 7:12)
        Module: Tangled
        Names
          Alias(start: 6:6, end: 7:12)
            Name: Rapunzel
            AsName: none
        Level: 0
    """)
   }

  /// from Tangled import Rapunzel as Daughter
  func test_module_withAlias() {
    let parser = createStmtParser(
      createToken(.from,                   start: loc0, end: loc1),
      createToken(.identifier("Tangled"),  start: loc2, end: loc3),
      createToken(.import,                 start: loc4, end: loc5),
      createToken(.identifier("Rapunzel"), start: loc6, end: loc7),
      createToken(.as,                     start: loc8, end: loc9),
      createToken(.identifier("Daughter"), start: loc10, end: loc11)
    )

    guard let ast = parse(parser) else { return }

    XCTAssertAST(ast, """
    ModuleAST(start: 0:0, end: 11:16)
      ImportFromStmt(start: 0:0, end: 11:16)
        Module: Tangled
        Names
          Alias(start: 6:6, end: 11:16)
            Name: Rapunzel
            AsName: Daughter
        Level: 0
    """)
  }

  /// from Tangled import Rapunzel as Daughter, Pascal
  func test_module_multiple() {
    let parser = createStmtParser(
      createToken(.from,                   start: loc0, end: loc1),
      createToken(.identifier("Tangled"),  start: loc2, end: loc3),
      createToken(.import,                 start: loc4, end: loc5),
      createToken(.identifier("Rapunzel"), start: loc6, end: loc7),
      createToken(.as,                     start: loc8, end: loc9),
      createToken(.identifier("Daughter"), start: loc10, end: loc11),
      createToken(.comma,                  start: loc12, end: loc13),
      createToken(.identifier("Pascal"),   start: loc14, end: loc15)
    )

    guard let ast = parse(parser) else { return }

    XCTAssertAST(ast, """
    ModuleAST(start: 0:0, end: 15:20)
      ImportFromStmt(start: 0:0, end: 15:20)
        Module: Tangled
        Names
          Alias(start: 6:6, end: 11:16)
            Name: Rapunzel
            AsName: Daughter
          Alias(start: 14:14, end: 15:20)
            Name: Pascal
            AsName: none
        Level: 0
    """)
  }

  /// from Tangled import (Rapunzel, Pascal)
  func test_module_multiple_inParens() {
    let parser = createStmtParser(
      createToken(.from,                   start: loc0, end: loc1),
      createToken(.identifier("Tangled"),  start: loc2, end: loc3),
      createToken(.import,                 start: loc4, end: loc5),
      createToken(.leftParen,              start: loc6, end: loc7),
      createToken(.identifier("Rapunzel"), start: loc8, end: loc9),
      createToken(.comma,                  start: loc10, end: loc11),
      createToken(.identifier("Pascal"),   start: loc12, end: loc13),
      createToken(.rightParen,             start: loc14, end: loc15)
    )

    guard let ast = parse(parser) else { return }

    XCTAssertAST(ast, """
    ModuleAST(start: 0:0, end: 15:20)
      ImportFromStmt(start: 0:0, end: 15:20)
        Module: Tangled
        Names
          Alias(start: 8:8, end: 9:14)
            Name: Rapunzel
            AsName: none
          Alias(start: 12:12, end: 13:18)
            Name: Pascal
            AsName: none
        Level: 0
    """)
  }

  /// from Disnep.Tangled import Rapunzel
  func test_nestedModule() {
    let parser = createStmtParser(
      createToken(.from,                   start: loc0, end: loc1),
      createToken(.identifier("Disnep"),   start: loc2, end: loc3),
      createToken(.dot,                    start: loc4, end: loc5),
      createToken(.identifier("Tangled"),  start: loc6, end: loc7),
      createToken(.import,                 start: loc8, end: loc9),
      createToken(.identifier("Rapunzel"), start: loc10, end: loc11)
    )

    guard let ast = parse(parser) else { return }

    XCTAssertAST(ast, """
    ModuleAST(start: 0:0, end: 11:16)
      ImportFromStmt(start: 0:0, end: 11:16)
        Module: Disnep.Tangled
        Names
          Alias(start: 10:10, end: 11:16)
            Name: Rapunzel
            AsName: none
        Level: 0
    """)
  }

  /// from Tangled import *
  func test_module_importAll() {
    let parser = createStmtParser(
      createToken(.from,                  start: loc0, end: loc1),
      createToken(.identifier("Tangled"), start: loc2, end: loc3),
      createToken(.import,                start: loc4, end: loc5),
      createToken(.star,                  start: loc6, end: loc7)
    )

    guard let ast = parse(parser) else { return }

    XCTAssertAST(ast, """
    ModuleAST(start: 0:0, end: 7:12)
      ImportFromStarStmt(start: 0:0, end: 7:12)
        Module: Tangled
        Level: 0
    """)
  }

  /// from . import Rapunzel
  func test_dir() {
    let parser = createStmtParser(
      createToken(.from,                   start: loc0, end: loc1),
      createToken(.dot,                    start: loc2, end: loc3),
      createToken(.import,                 start: loc4, end: loc5),
      createToken(.identifier("Rapunzel"), start: loc6, end: loc7)
    )

    guard let ast = parse(parser) else { return }

    XCTAssertAST(ast, """
    ModuleAST(start: 0:0, end: 7:12)
      ImportFromStmt(start: 0:0, end: 7:12)
        Module: none
        Names
          Alias(start: 6:6, end: 7:12)
            Name: Rapunzel
            AsName: none
        Level: 1
    """)
  }

  /// from ... import Rapunzel
  func test_ellipsis() {
    let parser = createStmtParser(
      createToken(.from,                   start: loc0, end: loc1),
      createToken(.ellipsis,               start: loc2, end: loc3),
      createToken(.import,                 start: loc4, end: loc5),
      createToken(.identifier("Rapunzel"), start: loc6, end: loc7)
    )

    guard let ast = parse(parser) else { return }

    XCTAssertAST(ast, """
    ModuleAST(start: 0:0, end: 7:12)
      ImportFromStmt(start: 0:0, end: 7:12)
        Module: none
        Names
          Alias(start: 6:6, end: 7:12)
            Name: Rapunzel
            AsName: none
        Level: 3
    """)
  }

  /// from .Tangled import Rapunzel
  func test_dotModule() {
    let parser = createStmtParser(
      createToken(.from,                   start: loc0, end: loc1),
      createToken(.dot,                    start: loc2, end: loc3),
      createToken(.identifier("Tangled"),  start: loc4, end: loc5),
      createToken(.import,                 start: loc6, end: loc7),
      createToken(.identifier("Rapunzel"), start: loc8, end: loc9)
    )

    guard let ast = parse(parser) else { return }

    XCTAssertAST(ast, """
    ModuleAST(start: 0:0, end: 9:14)
      ImportFromStmt(start: 0:0, end: 9:14)
        Module: Tangled
        Names
          Alias(start: 8:8, end: 9:14)
            Name: Rapunzel
            AsName: none
        Level: 1
    """)
  }

  /// from ...Tangled import Rapunzel
  func test_ellipsisModule() {
    let parser = createStmtParser(
      createToken(.from,                   start: loc0, end: loc1),
      createToken(.ellipsis,               start: loc2, end: loc3),
      createToken(.identifier("Tangled"),  start: loc4, end: loc5),
      createToken(.import,                 start: loc6, end: loc7),
      createToken(.identifier("Rapunzel"), start: loc8, end: loc9)
    )

    guard let ast = parse(parser) else { return }

    XCTAssertAST(ast, """
    ModuleAST(start: 0:0, end: 9:14)
      ImportFromStmt(start: 0:0, end: 9:14)
        Module: Tangled
        Names
          Alias(start: 8:8, end: 9:14)
            Name: Rapunzel
            AsName: none
        Level: 3
    """)
  }
}
