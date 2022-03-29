import XCTest
import VioletCore
import VioletParser
import VioletBytecode
@testable import VioletCompiler

/// Use './Scripts/dump' for reference.
class CompileImportFrom: CompileTestCase {

  // MARK: - Module

  /// from Tangled import Rapunzel
  ///
  ///  0 LOAD_CONST               0 (0)
  ///  2 LOAD_CONST               1 (('Rapunzel',))
  ///  4 IMPORT_NAME              0 (Tangled)
  ///  6 IMPORT_FROM              1 (Rapunzel)
  ///  8 STORE_NAME               1 (Rapunzel)
  /// 10 POP_TOP
  /// 12 LOAD_CONST               2 (None)
  /// 14 RETURN_VALUE
  func test_module() {
    let stmt = self.importFromStmt(
      moduleName: "Tangled",
      names: [
        self.alias(name: "Rapunzel", asName: nil)
      ],
      level: 0
    )

    guard let code = self.compile(stmt: stmt) else {
      return
    }

    XCTAssertCodeObject(
      code,
      name: "<module>",
      qualifiedName: "",
      kind: .module,
      flags: [],
      instructions: [
        .loadConst(integer: 0),
        .loadConst(tuple: ["Rapunzel"]),
        .importName(name: "Tangled"),
        .importFrom(name: "Rapunzel"),
        .storeName(name: "Rapunzel"),
        .popTop,
        .loadConst(.none),
        .return
      ]
    )
  }

  /// from Tangled import Rapunzel as Daughter
  ///
  ///  0 LOAD_CONST               0 (0)
  ///  2 LOAD_CONST               1 (('Rapunzel',))
  ///  4 IMPORT_NAME              0 (Tangled)
  ///  6 IMPORT_FROM              1 (Rapunzel)
  ///  8 STORE_NAME               2 (Daughter)
  /// 10 POP_TOP
  /// 12 LOAD_CONST               2 (None)
  /// 14 RETURN_VALUE
  func test_module_withAlias() {
    let stmt = self.importFromStmt(
      moduleName: "Tangled",
      names: [
        self.alias(name: "Rapunzel", asName: "Daughter")
      ],
      level: 0
    )

    guard let code = self.compile(stmt: stmt) else {
      return
    }

    XCTAssertCodeObject(
      code,
      name: "<module>",
      qualifiedName: "",
      kind: .module,
      flags: [],
      instructions: [
        .loadConst(integer: 0),
        .loadConst(tuple: ["Rapunzel"]),
        .importName(name: "Tangled"),
        .importFrom(name: "Rapunzel"),
        .storeName(name: "Daughter"),
        .popTop,
        .loadConst(.none),
        .return
      ]
    )
  }

  /// from Tangled import Rapunzel as Daughter, Pascal
  ///
  ///  0 LOAD_CONST               0 (0)
  ///  2 LOAD_CONST               1 (('Rapunzel', 'Pascal'))
  ///  4 IMPORT_NAME              0 (Tangled)
  ///  6 IMPORT_FROM              1 (Rapunzel)
  ///  8 STORE_NAME               2 (Daughter)

  /// 10 IMPORT_FROM              3 (Pascal)
  /// 12 STORE_NAME               3 (Pascal)
  /// 14 POP_TOP
  /// 16 LOAD_CONST               2 (None)
  /// 18 RETURN_VALUE
  func test_module_multiple() {
    let stmt = self.importFromStmt(
      moduleName: "Tangled",
      names: [
        self.alias(name: "Rapunzel", asName: "Daughter"),
        self.alias(name: "Pascal", asName: nil)
      ],
      level: 0
    )

    guard let code = self.compile(stmt: stmt) else {
      return
    }

    XCTAssertCodeObject(
      code,
      name: "<module>",
      qualifiedName: "",
      kind: .module,
      flags: [],
      instructions: [
        .loadConst(integer: 0),
        .loadConst(tuple: ["Rapunzel", "Pascal"]),
        .importName(name: "Tangled"),
        .importFrom(name: "Rapunzel"),
        .storeName(name: "Daughter"),
        .importFrom(name: "Pascal"),
        .storeName(name: "Pascal"),
        .popTop,
        .loadConst(.none),
        .return
      ]
    )
  }

  /// from Disnep.Tangled import Rapunzel
  ///
  ///  0 LOAD_CONST               0 (0)
  ///  2 LOAD_CONST               1 (('Rapunzel',))
  ///  4 IMPORT_NAME              0 (Disnep.Tangled)
  ///  6 IMPORT_FROM              1 (Rapunzel)
  ///  8 STORE_NAME               1 (Rapunzel)
  /// 10 POP_TOP
  /// 12 LOAD_CONST               2 (None)
  /// 14 RETURN_VALUE
  func test_module_nested() {
    let stmt = self.importFromStmt(
      moduleName: "Disnep.Tangled",
      names: [
        self.alias(name: "Rapunzel", asName: nil)
      ],
      level: 0
    )

    guard let code = self.compile(stmt: stmt) else {
      return
    }

    XCTAssertCodeObject(
      code,
      name: "<module>",
      qualifiedName: "",
      kind: .module,
      flags: [],
      instructions: [
        .loadConst(integer: 0),
        .loadConst(tuple: ["Rapunzel"]),
        .importName(name: "Disnep.Tangled"),
        .importFrom(name: "Rapunzel"),
        .storeName(name: "Rapunzel"),
        .popTop,
        .loadConst(.none),
        .return
      ]
    )
  }

  // MARK: - Import all

  /// from Tangled import *
  /// additional_block <-- so that we don't get returns at the end
  ///
  ///  0 LOAD_CONST               0 (0)
  ///  2 LOAD_CONST               1 (('*',))
  ///  4 IMPORT_NAME              0 (Tangled)
  ///  6 IMPORT_STAR
  /// 12 LOAD_CONST               2 (None)
  /// 14 RETURN_VALUE
  func test_module_importAll() {
    let stmt = self.importFromStarStmt(
      moduleName: "Tangled",
      level: 0
    )

    guard let code = self.compile(stmt: stmt) else {
      return
    }

    XCTAssertCodeObject(
      code,
      name: "<module>",
      qualifiedName: "",
      kind: .module,
      flags: [],
      instructions: [
        .loadConst(integer: 0),
        .loadConst(tuple: ["*"]),
        .importName(name: "Tangled"),
        .importStar,
        .loadConst(.none),
        .return
      ]
    )
  }

  // MARK: - Level

  /// from . import Rapunzel
  ///
  ///  0 LOAD_CONST               0 (1)
  ///  2 LOAD_CONST               1 (('Rapunzel',))
  ///  4 IMPORT_NAME              0
  ///  6 IMPORT_FROM              1 (Rapunzel)
  ///  8 STORE_NAME               1 (Rapunzel)
  /// 10 POP_TOP
  /// 12 LOAD_CONST               2 (None)
  /// 14 RETURN_VALUE
  func test_dir() {
    let stmt = self.importFromStmt(
      moduleName: nil,
      names: [
        self.alias(name: "Rapunzel", asName: nil)
      ],
      level: 1
    )

    guard let code = self.compile(stmt: stmt) else {
      return
    }

    XCTAssertCodeObject(
      code,
      name: "<module>",
      qualifiedName: "",
      kind: .module,
      flags: [],
      instructions: [
        .loadConst(integer: 1),
        .loadConst(tuple: ["Rapunzel"]),
        .importName(name: ""),
        .importFrom(name: "Rapunzel"),
        .storeName(name: "Rapunzel"),
        .popTop,
        .loadConst(.none),
        .return
      ]
    )
  }

  /// from .Tangled import Rapunzel
  ///
  ///  0 LOAD_CONST               0 (1)
  ///  2 LOAD_CONST               1 (('Rapunzel',))
  ///  4 IMPORT_NAME              0 (Tangled)
  ///  6 IMPORT_FROM              1 (Rapunzel)
  ///  8 STORE_NAME               1 (Rapunzel)
  /// 10 POP_TOP
  /// 12 LOAD_CONST               2 (None)
  /// 14 RETURN_VALUE
  func test_dotModule() {
    let stmt = self.importFromStmt(
      moduleName: "Tangled",
      names: [
        self.alias(name: "Rapunzel", asName: nil)
      ],
      level: 1
    )

    guard let code = self.compile(stmt: stmt) else {
      return
    }

    XCTAssertCodeObject(
      code,
      name: "<module>",
      qualifiedName: "",
      kind: .module,
      flags: [],
      instructions: [
        .loadConst(integer: 1),
        .loadConst(tuple: ["Rapunzel"]),
        .importName(name: "Tangled"),
        .importFrom(name: "Rapunzel"),
        .storeName(name: "Rapunzel"),
        .popTop,
        .loadConst(.none),
        .return
      ]
    )
  }
}
