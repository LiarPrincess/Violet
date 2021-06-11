import XCTest
import VioletCore
import VioletParser
import VioletBytecode
@testable import VioletCompiler

/// Use './Scripts/dump' for reference.
class CompileImport: CompileTestCase {

  /// import Rapunzel
  ///
  ///  0 LOAD_CONST               0 (0)
  ///  2 LOAD_CONST               1 (None)
  ///  4 IMPORT_NAME              0 (Rapunzel)
  ///  6 STORE_NAME               0 (Rapunzel)
  ///  8 LOAD_CONST               1 (None)
  /// 10 RETURN_VALUE
  func test_single() {
    let stmt = self.importStmt(
      names: [self.alias(name: "Rapunzel", asName: nil)]
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
        .loadConst(.none),
        .importName(name: "Rapunzel"),
        .storeName(name: "Rapunzel"),
        .loadConst(.none),
        .return
      ]
    )
  }

  /// import Tangled.Rapunzel
  ///
  ///  0 LOAD_CONST               0 (0)
  ///  2 LOAD_CONST               1 (None)
  ///  4 IMPORT_NAME              0 (Tangled.Rapunzel)
  ///  6 STORE_NAME               1 (Tangled)
  ///  8 LOAD_CONST               1 (None)
  /// 10 RETURN_VALUE
  func test_simple_withDot() {
    let stmt = self.importStmt(
      names: [self.alias(name: "Tangled.Rapunzel", asName: nil)]
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
        .loadConst(.none),
        .importName(name: "Tangled.Rapunzel"),
        .storeName(name: "Tangled"),
        .loadConst(.none),
        .return
      ]
    )
  }

  /// import Rapunzel as Daughter
  ///
  ///  0 LOAD_CONST               0 (0)
  ///  2 LOAD_CONST               1 (None)
  ///  4 IMPORT_NAME              0 (Rapunzel)
  ///  6 STORE_NAME               1 (Daughter)
  ///  8 LOAD_CONST               1 (None)
  /// 10 RETURN_VALUE
  func test_alias() {
    let stmt = self.importStmt(
      names: [self.alias(name: "Rapunzel", asName: "Daughter")]
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
        .loadConst(.none),
        .importName(name: "Rapunzel"),
        .storeName(name: "Daughter"),
        .loadConst(.none),
        .return
      ]
    )
  }

  /// import Rapunzel as Daughter, Pascal
  ///
  ///  0 LOAD_CONST               0 (0)
  ///  2 LOAD_CONST               1 (None)
  ///  4 IMPORT_NAME              0 (Rapunzel)
  ///  6 STORE_NAME               1 (Daughter)
  ///  8 LOAD_CONST               0 (0)
  /// 10 LOAD_CONST               1 (None)
  /// 12 IMPORT_NAME              2 (Pascal)
  /// 14 STORE_NAME               2 (Pascal)
  /// 16 LOAD_CONST               1 (None)
  /// 18 RETURN_VALUE
  func test_alias_multiple() {
    let stmt = self.importStmt(
      names: [
        self.alias(name: "Rapunzel", asName: "Daughter"),
        self.alias(name: "Pascal", asName: nil)
      ]
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
        .loadConst(.none),
        .importName(name: "Rapunzel"),
        .storeName(name: "Daughter"),
        .loadConst(integer: 0),
        .loadConst(.none),
        .importName(name: "Pascal"),
        .storeName(name: "Pascal"),
        .loadConst(.none),
        .return
      ]
    )
  }

  /// import Tangled.Rapunzel as Daughter
  /// additional_block <-- so that we don't get returns at the end
  ///
  ///  0 LOAD_CONST               0 (0)
  ///  2 LOAD_CONST               1 (None)
  ///  4 IMPORT_NAME              0 (Tangled.Rapunzel)
  ///  6 IMPORT_FROM              1 (Rapunzel)
  ///  8 STORE_NAME               2 (Daughter)
  /// 10 POP_TOP
  /// 12 LOAD_NAME                3 (additional_block)
  /// 14 POP_TOP
  /// 16 LOAD_CONST               1 (None)
  /// 18 RETURN_VALUE
  func test_attributedModule() {
    let stmt = self.importStmt(
      names: [self.alias(name: "Tangled.Rapunzel", asName: "Daughter")]
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
        .loadConst(.none),
        .importName(name: "Tangled.Rapunzel"),
        .importFrom(name: "Rapunzel"),
        .storeName(name: "Daughter"),
        .popTop,
        .loadConst(.none),
        .return
      ]
    )
  }
}
