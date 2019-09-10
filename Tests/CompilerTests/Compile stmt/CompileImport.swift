import XCTest
import Core
import Parser
import Bytecode
@testable import Compiler

/// Use 'Scripts/dump_dis.py' for reference.
class CompileImport: XCTestCase, CommonCompiler {

  /// import Rapunzel
  ///
  ///  0 LOAD_CONST               0 (0)
  ///  2 LOAD_CONST               1 (None)
  ///  4 IMPORT_NAME              0 (Rapunzel)
  ///  6 STORE_NAME               0 (Rapunzel)
  ///  8 LOAD_CONST               1 (None)
  /// 10 RETURN_VALUE
  func test_single() {
    let stmt = self.import(
      self.alias(name: "Rapunzel", asName: nil)
    )

    let expected: [EmittedInstruction] = [
      .init(.loadConst, "0"),
      .init(.loadConst, "none"),
      .init(.importName, "Rapunzel"),
      .init(.storeName, "Rapunzel"),
      .init(.loadConst, "none"),
      .init(.return)
    ]

    if let code = self.compile(stmt: stmt) {
      XCTAssertCode(code, name: "<module>", qualified: "", type: .module)
      XCTAssertInstructions(code, expected)
    }
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
    let stmt = self.import(
      self.alias(name: "Tangled.Rapunzel", asName: nil)
    )

    let expected: [EmittedInstruction] = [
      .init(.loadConst, "0"),
      .init(.loadConst, "none"),
      .init(.importName, "Tangled.Rapunzel"),
      .init(.storeName, "Tangled"),
      .init(.loadConst, "none"),
      .init(.return)
    ]

    if let code = self.compile(stmt: stmt) {
      XCTAssertCode(code, name: "<module>", qualified: "", type: .module)
      XCTAssertInstructions(code, expected)
    }
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
    let stmt = self.import(
      self.alias(name: "Rapunzel", asName: "Daughter")
    )

    let expected: [EmittedInstruction] = [
      .init(.loadConst, "0"),
      .init(.loadConst, "none"),
      .init(.importName, "Rapunzel"),
      .init(.storeName, "Daughter"),
      .init(.loadConst, "none"),
      .init(.return)
    ]

    if let code = self.compile(stmt: stmt) {
      XCTAssertCode(code, name: "<module>", qualified: "", type: .module)
      XCTAssertInstructions(code, expected)
    }
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
    let stmt = self.import(
      self.alias(name: "Rapunzel", asName: "Daughter"),
      self.alias(name: "Pascal",   asName: nil)
    )

    let expected: [EmittedInstruction] = [
      .init(.loadConst, "0"),
      .init(.loadConst, "none"),
      .init(.importName, "Rapunzel"),
      .init(.storeName, "Daughter"),
      .init(.loadConst, "0"),
      .init(.loadConst, "none"),
      .init(.importName, "Pascal"),
      .init(.storeName, "Pascal"),
      .init(.loadConst, "none"),
      .init(.return)
    ]

    if let code = self.compile(stmt: stmt) {
      XCTAssertCode(code, name: "<module>", qualified: "", type: .module)
      XCTAssertInstructions(code, expected)
    }
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
    let stmt = self.import(
      self.alias(name: "Tangled.Rapunzel", asName: "Daughter")
    )

    let expected: [EmittedInstruction] = [
      .init(.loadConst, "0"),
      .init(.loadConst, "none"),
      .init(.importName, "Tangled.Rapunzel"),
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
}
