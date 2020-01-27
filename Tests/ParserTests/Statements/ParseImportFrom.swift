import XCTest
import Core
import Lexer
@testable import Parser

class ParseImportFrom: XCTestCase, Common {

  /// from Tangled import Rapunzel
  func test_module() {
    let parser = self.createStmtParser(
      self.token(.from,                   start: loc0, end: loc1),
      self.token(.identifier("Tangled"),  start: loc2, end: loc3),
      self.token(.import,                 start: loc4, end: loc5),
      self.token(.identifier("Rapunzel"), start: loc6, end: loc7)
    )

    guard let ast = self.parse(parser) else { return }

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
    let parser = self.createStmtParser(
      self.token(.from,                   start: loc0, end: loc1),
      self.token(.identifier("Tangled"),  start: loc2, end: loc3),
      self.token(.import,                 start: loc4, end: loc5),
      self.token(.identifier("Rapunzel"), start: loc6, end: loc7),
      self.token(.as,                     start: loc8, end: loc9),
      self.token(.identifier("Daughter"), start: loc10, end: loc11)
    )

    guard let ast = self.parse(parser) else { return }

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
    let parser = self.createStmtParser(
      self.token(.from,                   start: loc0, end: loc1),
      self.token(.identifier("Tangled"),  start: loc2, end: loc3),
      self.token(.import,                 start: loc4, end: loc5),
      self.token(.identifier("Rapunzel"), start: loc6, end: loc7),
      self.token(.as,                     start: loc8, end: loc9),
      self.token(.identifier("Daughter"), start: loc10, end: loc11),
      self.token(.comma,                  start: loc12, end: loc13),
      self.token(.identifier("Pascal"),   start: loc14, end: loc15)
    )

    guard let ast = self.parse(parser) else { return }

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
    let parser = self.createStmtParser(
      self.token(.from,                   start: loc0, end: loc1),
      self.token(.identifier("Tangled"),  start: loc2, end: loc3),
      self.token(.import,                 start: loc4, end: loc5),
      self.token(.leftParen,              start: loc6, end: loc7),
      self.token(.identifier("Rapunzel"), start: loc8, end: loc9),
      self.token(.comma,                  start: loc10, end: loc11),
      self.token(.identifier("Pascal"),   start: loc12, end: loc13),
      self.token(.rightParen,             start: loc14, end: loc15)
    )

    guard let ast = self.parse(parser) else { return }

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
    let parser = self.createStmtParser(
      self.token(.from,                   start: loc0, end: loc1),
      self.token(.identifier("Disnep"),   start: loc2, end: loc3),
      self.token(.dot,                    start: loc4, end: loc5),
      self.token(.identifier("Tangled"),  start: loc6, end: loc7),
      self.token(.import,                 start: loc8, end: loc9),
      self.token(.identifier("Rapunzel"), start: loc10, end: loc11)
    )

    guard let ast = self.parse(parser) else { return }

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
    let parser = self.createStmtParser(
      self.token(.from,                  start: loc0, end: loc1),
      self.token(.identifier("Tangled"), start: loc2, end: loc3),
      self.token(.import,                start: loc4, end: loc5),
      self.token(.star,                  start: loc6, end: loc7)
    )

    guard let ast = self.parse(parser) else { return }

    XCTAssertAST(ast, """
    ModuleAST(start: 0:0, end: 7:12)
      ImportFromStarStmt(start: 0:0, end: 7:12)
        Module: Tangled
        Level: 0
    """)
  }

  /// from . import Rapunzel
  func test_dir() {
    let parser = self.createStmtParser(
      self.token(.from,                   start: loc0, end: loc1),
      self.token(.dot,                    start: loc2, end: loc3),
      self.token(.import,                 start: loc4, end: loc5),
      self.token(.identifier("Rapunzel"), start: loc6, end: loc7)
    )

    guard let ast = self.parse(parser) else { return }

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
  func test_elipsis() {
    let parser = self.createStmtParser(
      self.token(.from,                   start: loc0, end: loc1),
      self.token(.ellipsis,               start: loc2, end: loc3),
      self.token(.import,                 start: loc4, end: loc5),
      self.token(.identifier("Rapunzel"), start: loc6, end: loc7)
    )

    guard let ast = self.parse(parser) else { return }

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
    let parser = self.createStmtParser(
      self.token(.from,                   start: loc0, end: loc1),
      self.token(.dot,                    start: loc2, end: loc3),
      self.token(.identifier("Tangled"),  start: loc4, end: loc5),
      self.token(.import,                 start: loc6, end: loc7),
      self.token(.identifier("Rapunzel"), start: loc8, end: loc9)
    )

    guard let ast = self.parse(parser) else { return }

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
  func test_elipsisModule() {
    let parser = self.createStmtParser(
      self.token(.from,                   start: loc0, end: loc1),
      self.token(.ellipsis,               start: loc2, end: loc3),
      self.token(.identifier("Tangled"),  start: loc4, end: loc5),
      self.token(.import,                 start: loc6, end: loc7),
      self.token(.identifier("Rapunzel"), start: loc8, end: loc9)
    )

    guard let ast = self.parse(parser) else { return }

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
