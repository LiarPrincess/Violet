import XCTest
import Core
import Lexer
@testable import Parser

// swiftlint:disable file_length

class ImportStatementTests: XCTestCase, Common, StatementMatcher {

  // MARK: - Import

  /// import Rapunzel
  func test_import() {
    var parser = self.createStmtParser(
      self.token(.import,                 start: loc0, end: loc1),
      self.token(.identifier("Rapunzel"), start: loc2, end: loc3)
    )

    if let stmt = self.parseStmt(&parser) {
      guard let d = self.matchImport(stmt) else { return }

      XCTAssertEqual(d.count, 1)
      guard d.count == 1 else { return }

      XCTAssertEqual(d[0].name, "Rapunzel")
      XCTAssertNil(d[0].asName)

      XCTAssertStatement(stmt, "(import Rapunzel)")
      XCTAssertEqual(stmt.start, loc0)
      XCTAssertEqual(stmt.end,   loc3)
    }
  }

  /// import Tangled.Rapunzel
  func test_import_nested() {
    var parser = self.createStmtParser(
      self.token(.import,                 start: loc0, end: loc1),
      self.token(.identifier("Tangled"),  start: loc2, end: loc3),
      self.token(.dot,                    start: loc4, end: loc5),
      self.token(.identifier("Rapunzel"), start: loc6, end: loc7)
    )

    if let stmt = self.parseStmt(&parser) {
      guard let d = self.matchImport(stmt) else { return }

      XCTAssertEqual(d.count, 1)
      guard d.count == 1 else { return }

      XCTAssertEqual(d[0].name, "Tangled.Rapunzel")
      XCTAssertNil(d[0].asName)

      XCTAssertStatement(stmt, "(import Tangled.Rapunzel)")
      XCTAssertEqual(stmt.start, loc0)
      XCTAssertEqual(stmt.end,   loc7)
    }
  }

  /// import Rapunzel as Daughter
  func test_import_withAlias() {
    var parser = self.createStmtParser(
      self.token(.import,                 start: loc0, end: loc1),
      self.token(.identifier("Rapunzel"), start: loc2, end: loc3),
      self.token(.as,                     start: loc4, end: loc5),
      self.token(.identifier("Daughter"), start: loc6, end: loc7)
    )

    if let stmt = self.parseStmt(&parser) {
      guard let d = self.matchImport(stmt) else { return }

      XCTAssertEqual(d.count, 1)
      guard d.count == 1 else { return }

      XCTAssertEqual(d[0].name, "Rapunzel")
      XCTAssertEqual(d[0].asName, "Daughter")

      XCTAssertStatement(stmt, "(import (Rapunzel as: Daughter))")
      XCTAssertEqual(stmt.start, loc0)
      XCTAssertEqual(stmt.end,   loc7)
    }
  }

  /// import Rapunzel as Daughter, Pascal
  func test_import_multiple() {
    var parser = self.createStmtParser(
      self.token(.import,                 start: loc0, end: loc1),
      self.token(.identifier("Rapunzel"), start: loc2, end: loc3),
      self.token(.as,                     start: loc4, end: loc5),
      self.token(.identifier("Daughter"), start: loc6, end: loc7),
      self.token(.comma,                  start: loc8, end: loc9),
      self.token(.identifier("Pascal"),   start: loc10, end: loc11)
    )

    if let stmt = self.parseStmt(&parser) {
      guard let d = self.matchImport(stmt) else { return }

      XCTAssertEqual(d.count, 2)
      guard d.count == 2 else { return }

      XCTAssertEqual(d[0].name, "Rapunzel")
      XCTAssertEqual(d[0].asName, "Daughter")

      XCTAssertEqual(d[1].name, "Pascal")
      XCTAssertNil(d[1].asName)

      XCTAssertStatement(stmt, "(import (Rapunzel as: Daughter) Pascal)")
      XCTAssertEqual(stmt.start, loc0)
      XCTAssertEqual(stmt.end,   loc11)
    }
  }

  // MARK: - From import

  /// from Tangled import Rapunzel
  func test_from_module() {
    var parser = self.createStmtParser(
      self.token(.from,                   start: loc0, end: loc1),
      self.token(.identifier("Tangled"),  start: loc2, end: loc3),
      self.token(.import,                 start: loc4, end: loc5),
      self.token(.identifier("Rapunzel"), start: loc6, end: loc7)
    )

    if let stmt = self.parseStmt(&parser) {
      guard let d = self.matchImportFrom(stmt) else { return }

      XCTAssertEqual(d.moduleName, "Tangled")
      XCTAssertEqual(d.level, 0)

      XCTAssertEqual(d.names.count, 1)
      guard d.names.count == 1 else { return }

      XCTAssertEqual(d.names[0].name, "Rapunzel")
      XCTAssertEqual(d.names[0].asName, nil)

      XCTAssertStatement(stmt, "(from Tangled import: Rapunzel)")
      XCTAssertEqual(stmt.start, loc0)
      XCTAssertEqual(stmt.end,   loc7)
    }
  }

  /// from Tangled import Rapunzel as Daughter
  func test_from_module_withAlias() {
    var parser = self.createStmtParser(
      self.token(.from,                   start: loc0, end: loc1),
      self.token(.identifier("Tangled"),  start: loc2, end: loc3),
      self.token(.import,                 start: loc4, end: loc5),
      self.token(.identifier("Rapunzel"), start: loc6, end: loc7),
      self.token(.as,                     start: loc8, end: loc9),
      self.token(.identifier("Daughter"), start: loc10, end: loc11)
    )

    if let stmt = self.parseStmt(&parser) {
      guard let d = self.matchImportFrom(stmt) else { return }

      XCTAssertEqual(d.moduleName, "Tangled")
      XCTAssertEqual(d.level, 0)

      XCTAssertEqual(d.names.count, 1)
      guard d.names.count == 1 else { return }

      XCTAssertEqual(d.names[0].name, "Rapunzel")
      XCTAssertEqual(d.names[0].asName, "Daughter")

      XCTAssertStatement(stmt, "(from Tangled import: (Rapunzel as: Daughter))")
      XCTAssertEqual(stmt.start, loc0)
      XCTAssertEqual(stmt.end,   loc11)
    }
  }

  /// from Tangled import Rapunzel as Daughter, Pascal
  func test_from_module_multiple() {
    var parser = self.createStmtParser(
      self.token(.from,                   start: loc0, end: loc1),
      self.token(.identifier("Tangled"),  start: loc2, end: loc3),
      self.token(.import,                 start: loc4, end: loc5),
      self.token(.identifier("Rapunzel"), start: loc6, end: loc7),
      self.token(.as,                     start: loc8, end: loc9),
      self.token(.identifier("Daughter"), start: loc10, end: loc11),
      self.token(.comma,                  start: loc12, end: loc13),
      self.token(.identifier("Pascal"),   start: loc14, end: loc15)
    )

    if let stmt = self.parseStmt(&parser) {
      guard let d = self.matchImportFrom(stmt) else { return }

      XCTAssertEqual(d.moduleName, "Tangled")
      XCTAssertEqual(d.level, 0)

      XCTAssertEqual(d.names.count, 2)
      guard d.names.count == 2 else { return }

      XCTAssertEqual(d.names[0].name, "Rapunzel")
      XCTAssertEqual(d.names[0].asName, "Daughter")

      XCTAssertEqual(d.names[1].name, "Pascal")
      XCTAssertEqual(d.names[1].asName, nil)

      XCTAssertStatement(stmt, "(from Tangled import: (Rapunzel as: Daughter) Pascal)")
      XCTAssertEqual(stmt.start, loc0)
      XCTAssertEqual(stmt.end,   loc15)
    }
  }

  /// from Tangled import (Rapunzel, Pascal)
  func test_from_module_multiple_inParens() {
    var parser = self.createStmtParser(
      self.token(.from,                   start: loc0, end: loc1),
      self.token(.identifier("Tangled"),  start: loc2, end: loc3),
      self.token(.import,                 start: loc4, end: loc5),
      self.token(.leftParen,              start: loc6, end: loc7),
      self.token(.identifier("Rapunzel"), start: loc8, end: loc9),
      self.token(.comma,                  start: loc10, end: loc11),
      self.token(.identifier("Pascal"),   start: loc12, end: loc13),
      self.token(.rightParen,             start: loc14, end: loc15)
    )

    if let stmt = self.parseStmt(&parser) {
      guard let d = self.matchImportFrom(stmt) else { return }

      XCTAssertEqual(d.moduleName, "Tangled")
      XCTAssertEqual(d.level, 0)

      XCTAssertEqual(d.names.count, 2)
      guard d.names.count == 2 else { return }

      XCTAssertEqual(d.names[0].name, "Rapunzel")
      XCTAssertEqual(d.names[0].asName, nil)

      XCTAssertEqual(d.names[1].name, "Pascal")
      XCTAssertEqual(d.names[1].asName, nil)

      XCTAssertStatement(stmt, "(from Tangled import: Rapunzel Pascal)")
      XCTAssertEqual(stmt.start, loc0)
      XCTAssertEqual(stmt.end,   loc15)
    }
  }

  /// from Disnep.Tangled import Rapunzel
  func test_from_nestedModule() {
    var parser = self.createStmtParser(
      self.token(.from,                   start: loc0, end: loc1),
      self.token(.identifier("Disnep"),   start: loc2, end: loc3),
      self.token(.dot,                    start: loc4, end: loc5),
      self.token(.identifier("Tangled"),  start: loc6, end: loc7),
      self.token(.import,                 start: loc8, end: loc9),
      self.token(.identifier("Rapunzel"), start: loc10, end: loc11)
    )

    if let stmt = self.parseStmt(&parser) {
      guard let d = self.matchImportFrom(stmt) else { return }

      XCTAssertEqual(d.moduleName, "Disnep.Tangled")
      XCTAssertEqual(d.level, 0)

      XCTAssertEqual(d.names.count, 1)
      guard d.names.count == 1 else { return }

      XCTAssertEqual(d.names[0].name, "Rapunzel")
      XCTAssertEqual(d.names[0].asName, nil)

      XCTAssertStatement(stmt, "(from Disnep.Tangled import: Rapunzel)")
      XCTAssertEqual(stmt.start, loc0)
      XCTAssertEqual(stmt.end,   loc11)
    }
  }

  /// from Tangled import *
  func test_from_module_importAll() {
    var parser = self.createStmtParser(
      self.token(.from,                  start: loc0, end: loc1),
      self.token(.identifier("Tangled"), start: loc2, end: loc3),
      self.token(.import,                start: loc4, end: loc5),
      self.token(.star,                  start: loc6, end: loc7)
    )

    if let stmt = self.parseStmt(&parser) {
      guard let d = self.matchImportFrom(stmt) else { return }

      XCTAssertEqual(d.moduleName, "Tangled")
      XCTAssertEqual(d.level, 0)

      XCTAssertEqual(d.names.count, 1)
      guard d.names.count == 1 else { return }

      XCTAssertEqual(d.names[0].name, "*")
      XCTAssertEqual(d.names[0].asName, nil)

      XCTAssertStatement(stmt, "(from Tangled import: *)")
      XCTAssertEqual(stmt.start, loc0)
      XCTAssertEqual(stmt.end,   loc7)
    }
  }

  /// from . import Rapunzel
  func test_from_dir() {
    var parser = self.createStmtParser(
      self.token(.from,                   start: loc0, end: loc1),
      self.token(.dot,                    start: loc2, end: loc3),
      self.token(.import,                 start: loc4, end: loc5),
      self.token(.identifier("Rapunzel"), start: loc6, end: loc7)
    )

    if let stmt = self.parseStmt(&parser) {
      guard let d = self.matchImportFrom(stmt) else { return }

      XCTAssertEqual(d.moduleName, nil)
      XCTAssertEqual(d.level, 1)

      XCTAssertEqual(d.names.count, 1)
      guard d.names.count == 1 else { return }

      XCTAssertEqual(d.names[0].name, "Rapunzel")
      XCTAssertEqual(d.names[0].asName, nil)

      XCTAssertStatement(stmt, "(from . import: Rapunzel)")
      XCTAssertEqual(stmt.start, loc0)
      XCTAssertEqual(stmt.end,   loc7)
    }
  }

  /// from ... import Rapunzel
  func test_from_elipsis() {
    var parser = self.createStmtParser(
      self.token(.from,                   start: loc0, end: loc1),
      self.token(.ellipsis,               start: loc2, end: loc3),
      self.token(.import,                 start: loc4, end: loc5),
      self.token(.identifier("Rapunzel"), start: loc6, end: loc7)
    )

    if let stmt = self.parseStmt(&parser) {
      guard let d = self.matchImportFrom(stmt) else { return }

      XCTAssertEqual(d.moduleName, nil)
      XCTAssertEqual(d.level, 3)

      XCTAssertEqual(d.names.count, 1)
      guard d.names.count == 1 else { return }

      XCTAssertEqual(d.names[0].name, "Rapunzel")
      XCTAssertEqual(d.names[0].asName, nil)

      XCTAssertStatement(stmt, "(from ... import: Rapunzel)")
      XCTAssertEqual(stmt.start, loc0)
      XCTAssertEqual(stmt.end,   loc7)
    }
  }

  /// from .Tangled import Rapunzel
  func test_from_dotModule() {
    var parser = self.createStmtParser(
      self.token(.from,                   start: loc0, end: loc1),
      self.token(.dot,                    start: loc2, end: loc3),
      self.token(.identifier("Tangled"),  start: loc4, end: loc5),
      self.token(.import,                 start: loc6, end: loc7),
      self.token(.identifier("Rapunzel"), start: loc8, end: loc9)
    )

    if let stmt = self.parseStmt(&parser) {
      guard let d = self.matchImportFrom(stmt) else { return }

      XCTAssertEqual(d.moduleName, "Tangled")
      XCTAssertEqual(d.level, 1)

      XCTAssertEqual(d.names.count, 1)
      guard d.names.count == 1 else { return }

      XCTAssertEqual(d.names[0].name, "Rapunzel")
      XCTAssertEqual(d.names[0].asName, nil)

      XCTAssertStatement(stmt, "(from .Tangled import: Rapunzel)")
      XCTAssertEqual(stmt.start, loc0)
      XCTAssertEqual(stmt.end,   loc9)
    }
  }

  /// from ...Tangled import Rapunzel
  func test_from_elipsisModule() {
    var parser = self.createStmtParser(
      self.token(.from,                   start: loc0, end: loc1),
      self.token(.ellipsis,               start: loc2, end: loc3),
      self.token(.identifier("Tangled"),  start: loc4, end: loc5),
      self.token(.import,                 start: loc6, end: loc7),
      self.token(.identifier("Rapunzel"), start: loc8, end: loc9)
    )

    if let stmt = self.parseStmt(&parser) {
      guard let d = self.matchImportFrom(stmt) else { return }

      XCTAssertEqual(d.moduleName, "Tangled")
      XCTAssertEqual(d.level, 3)

      XCTAssertEqual(d.names.count, 1)
      guard d.names.count == 1 else { return }

      XCTAssertEqual(d.names[0].name, "Rapunzel")
      XCTAssertEqual(d.names[0].asName, nil)

      XCTAssertStatement(stmt, "(from ...Tangled import: Rapunzel)")
      XCTAssertEqual(stmt.start, loc0)
      XCTAssertEqual(stmt.end,   loc9)
    }
  }
}
