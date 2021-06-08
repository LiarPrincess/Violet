import XCTest
import VioletCore
import VioletParser
@testable import VioletCompiler

/// Use 'Tools/dump_symtable.py' for reference.
class STImport: SymbolTableTestCase {

  // MARK: - Import

  /// import frozen, tangled
  ///
  /// ```c
  /// name: top
  /// lineno: 0
  /// symbols:
  ///   frozen - imported, local,
  ///   tangled - imported, local,
  /// ```
  func test_import() {
    let stmt = self.importStmt(
      names: [
        self.alias(name: "frozen", asName: nil, start: loc1),
        self.alias(name: "tangled", asName: nil, start: loc2)
      ]
    )

    if let table = self.createSymbolTable(stmt: stmt) {
      let top = table.top
      XCTAssertScope(top, name: "top", kind: .module, flags: [])
      XCTAssert(top.parameterNames.isEmpty)
      XCTAssert(top.children.isEmpty)

      XCTAssertEqual(top.symbols.count, 2)
      XCTAssertContainsSymbol(top,
                              name: "frozen",
                              flags: [.defImport, .srcLocal],
                              location: loc1)
      XCTAssertContainsSymbol(top,
                              name: "tangled",
                              flags: [.defImport, .srcLocal],
                              location: loc2)
    }
  }

  /// import frozen, tangled as bestMovieEver
  func test_import_withAlias() {
    let stmt = self.importStmt(
      names: [
        self.alias(name: "frozen", asName: nil, start: loc1),
        self.alias(name: "tangled", asName: "bestMovieEver", start: loc2)
      ]
    )

    if let table = self.createSymbolTable(stmt: stmt) {
      let top = table.top
      XCTAssertScope(top, name: "top", kind: .module, flags: [])
      XCTAssert(top.parameterNames.isEmpty)
      XCTAssert(top.children.isEmpty)

      XCTAssertEqual(top.symbols.count, 2)
      XCTAssertContainsSymbol(top,
                              name: "frozen",
                              flags: [.defImport, .srcLocal],
                              location: loc1)
      XCTAssertContainsSymbol(top,
                              name: "bestMovieEver",
                              flags: [.defImport, .srcLocal],
                              location: loc2)
    }
  }

  /// import tangled.rapunzel
  ///
  /// ```c
  /// name: top
  /// lineno: 0
  /// symbols:
  ///   tangled - imported, local,
  /// ```
  func test_import_withAttribute() {
    let stmt = self.importStmt(
      names: [
        self.alias(name: "tangled.rapunzel", asName: nil, start: loc1)
      ]
    )

    if let table = self.createSymbolTable(stmt: stmt) {
      let top = table.top
      XCTAssertScope(top, name: "top", kind: .module, flags: [])
      XCTAssert(top.parameterNames.isEmpty)
      XCTAssert(top.children.isEmpty)

      XCTAssertEqual(top.symbols.count, 1)
      XCTAssertContainsSymbol(top,
                              name: "tangled",
                              flags: [.defImport, .srcLocal],
                              location: loc1)
    }
  }

  // MARK: - ImportFrom

  /// from disnep import elsa, rapunzel
  ///
  /// ```c
  /// name: top
  /// lineno: 0
  /// symbols:
  ///   elsa - imported, local,
  ///   rapunzel - imported, local,
  /// ```
  func test_importFrom() {
    let stmt = self.importFromStmt(
      moduleName: "disnep",
      names: [
        self.alias(name: "elsa", asName: nil, start: loc1),
        self.alias(name: "rapunzel", asName: nil, start: loc2)
      ],
      level: 0
    )

    if let table = self.createSymbolTable(stmt: stmt) {
      let top = table.top
      XCTAssertScope(top, name: "top", kind: .module, flags: [])
      XCTAssert(top.parameterNames.isEmpty)
      XCTAssert(top.children.isEmpty)

      XCTAssertEqual(top.symbols.count, 2)
      XCTAssertContainsSymbol(top,
                              name: "elsa",
                              flags: [.defImport, .srcLocal],
                              location: loc1)
      XCTAssertContainsSymbol(top,
                              name: "rapunzel",
                              flags: [.defImport, .srcLocal],
                              location: loc2)
    }
  }

  /// from disnep import elsa, rapunzel as princess
  ///
  /// ```c
  /// name: top
  /// lineno: 0
  /// symbols:
  ///   elsa - imported, local,
  ///   princess - imported, local,
  /// ```
  func test_importFrom_withAlias() {
    let stmt = self.importFromStmt(
      moduleName: "disnep",
      names: [
        self.alias(name: "elsa", asName: nil, start: loc1),
        self.alias(name: "rapunzel", asName: "princess", start: loc2)
      ],
      level: 0
    )

    if let table = self.createSymbolTable(stmt: stmt) {
      let top = table.top
      XCTAssertScope(top, name: "top", kind: .module, flags: [])
      XCTAssert(top.parameterNames.isEmpty)
      XCTAssert(top.children.isEmpty)

      XCTAssertEqual(top.symbols.count, 2)
      XCTAssertContainsSymbol(top,
                              name: "elsa",
                              flags: [.defImport, .srcLocal],
                              location: loc1)
      XCTAssertContainsSymbol(top,
                              name: "princess",
                              flags: [.defImport, .srcLocal],
                              location: loc2)
    }
  }

  /// from disnep import *
  ///
  /// ```c
  /// name: top
  /// lineno: 0
  /// symbols:
  /// ```
  func test_importFrom_withStar() {
    let stmt = self.importFromStarStmt(
      moduleName: "disnep",
      level: 0
    )

    if let table = self.createSymbolTable(stmt: stmt) {
      let top = table.top
      XCTAssertScope(top, name: "top", kind: .module, flags: [])
      XCTAssert(top.parameterNames.isEmpty)
      XCTAssert(top.children.isEmpty)
      XCTAssert(top.symbols.isEmpty)
    }
  }

  /// ```c
  /// def sing():
  ///   from disnep import *
  /// ```
  func test_importFrom_withStar_inFunction_throws() {
    let importStmt = self.importFromStarStmt(
      moduleName: "disnep",
      level: 0,
      start: loc1
    )

    let stmt = self.functionDefStmt(
      name: "sing",
      args: self.arguments(),
      body: [importStmt]
    )

    if let error = self.error(forStmt: stmt) {
      XCTAssertEqual(error.kind, .nonModuleImportStar)
      XCTAssertEqual(error.location, loc1)
    }
  }
}
