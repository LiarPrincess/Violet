import XCTest
import Core
import Parser
import Bytecode
@testable import Compiler

// swiftlint:disable file_length

/// Use 'Scripts/dump_dis.py' for reference.
class CompileImportFrom: XCTestCase, CommonCompiler {

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
    let stmt = self.importFrom(
      moduleName: "Tangled",
      names: [
        self.alias(name: "Rapunzel", asName: nil)
      ],
      level: 0
    )

    let expected: [EmittedInstruction] = [
      .init(.loadConst, "0"),
      .init(.loadConst, "('Rapunzel')"),
      .init(.importName, "Tangled"),
      .init(.importFrom, "Rapunzel"),
      .init(.storeName, "Rapunzel"),
      .init(.popTop),
      .init(.loadConst, "none"),
      .init(.return)
    ]

    if let code = self.compile(stmt: stmt) {
      XCTAssertCode(code, name: "<module>", qualified: "", type: .module)
      XCTAssertInstructions(code, expected)
    }
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
    let stmt = self.importFrom(
      moduleName: "Tangled",
      names: [
        self.alias(name: "Rapunzel", asName: "Daughter")
      ],
      level: 0
    )

    let expected: [EmittedInstruction] = [
      .init(.loadConst, "0"),
      .init(.loadConst, "('Rapunzel')"),
      .init(.importName, "Tangled"),
      .init(.importFrom, "Rapunzel"),
      .init(.storeName, "Daughter"),
      .init(.popTop),
      .init(.loadConst, "none"),
      .init(.return)
    ]

    if let code = self.compile(stmt: stmt) {
      XCTAssertCode(code, name: "<module>", qualified: "", type: .module)
      XCTAssertInstructions(code, expected)
    }
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
    let stmt = self.importFrom(
      moduleName: "Tangled",
      names: [
        self.alias(name: "Rapunzel", asName: "Daughter"),
        self.alias(name: "Pascal",   asName: nil)
      ],
      level: 0
    )

    let expected: [EmittedInstruction] = [
      .init(.loadConst, "0"),
      .init(.loadConst, "('Rapunzel', 'Pascal')"),
      .init(.importName, "Tangled"),
      .init(.importFrom, "Rapunzel"),
      .init(.storeName, "Daughter"),
      .init(.importFrom, "Pascal"),
      .init(.storeName, "Pascal"),
      .init(.popTop),
      .init(.loadConst, "none"),
      .init(.return)
    ]

    if let code = self.compile(stmt: stmt) {
      XCTAssertCode(code, name: "<module>", qualified: "", type: .module)
      XCTAssertInstructions(code, expected)
    }
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
    let stmt = self.importFrom(
      moduleName: "Disnep.Tangled",
      names: [
        self.alias(name: "Rapunzel", asName: nil)
      ],
      level: 0
    )

    let expected: [EmittedInstruction] = [
      .init(.loadConst, "0"),
      .init(.loadConst, "('Rapunzel')"),
      .init(.importName, "Disnep.Tangled"),
      .init(.importFrom, "Rapunzel"),
      .init(.storeName, "Rapunzel"),
      .init(.popTop),
      .init(.loadConst, "none"),
      .init(.return)
    ]

    if let code = self.compile(stmt: stmt) {
      XCTAssertCode(code, name: "<module>", qualified: "", type: .module)
      XCTAssertInstructions(code, expected)
    }
  }

  // MARK: - Import all

  /// from Tangled import *
  /// additional_block <-- so that we don't get returns at the end
  ///
  ///  0 LOAD_CONST               0 (0)
  ///  2 LOAD_CONST               1 (('*',))
  ///  4 IMPORT_NAME              0 (Tangled)
  ///  6 IMPORT_STAR
  ///  8 LOAD_NAME                1 (additional_block) <- skip that
  /// 10 POP_TOP
  /// 12 LOAD_CONST               2 (None)
  /// 14 RETURN_VALUE
  func test_module_importAll() {
    let stmt = self.importFromStar(
      moduleName: "Tangled",
      level: 0
    )

    let expected: [EmittedInstruction] = [
      .init(.loadConst, "0"),
      .init(.loadConst, "('*')"),
      .init(.importName, "Tangled"),
      .init(.importStar),
      .init(.popTop),
      .init(.loadConst, "none"),
      .init(.return)
    ]

    if let code = self.compile(stmt: stmt) {
      XCTAssertCode(code, name: "<module>", qualified: "", type: .module)
      XCTAssertInstructions(code, expected)
    }
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
    let stmt = self.importFrom(
      moduleName: nil,
      names: [
        self.alias(name: "Rapunzel", asName: nil)
      ],
      level: 1
    )

    let expected: [EmittedInstruction] = [
      .init(.loadConst, "1"),
      .init(.loadConst, "('Rapunzel')"),
      .init(.importName, ""),
      .init(.importFrom, "Rapunzel"),
      .init(.storeName, "Rapunzel"),
      .init(.popTop),
      .init(.loadConst, "none"),
      .init(.return)
    ]

    if let code = self.compile(stmt: stmt) {
      XCTAssertCode(code, name: "<module>", qualified: "", type: .module)
      XCTAssertInstructions(code, expected)
    }
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
    let stmt = self.importFrom(
      moduleName: "Tangled",
      names: [
        self.alias(name: "Rapunzel", asName: nil)
      ],
      level: 1
    )

    let expected: [EmittedInstruction] = [
      .init(.loadConst, "1"),
      .init(.loadConst, "('Rapunzel')"),
      .init(.importName, "Tangled"),
      .init(.importFrom, "Rapunzel"),
      .init(.storeName, "Rapunzel"),
      .init(.popTop),
      .init(.loadConst, "none"),
      .init(.return)
    ]

    if let code = self.compile(stmt: stmt) {
      XCTAssertCode(code, name: "<module>", qualified: "", type: .module)
      XCTAssertInstructions(code, expected)
    }
  }
}
