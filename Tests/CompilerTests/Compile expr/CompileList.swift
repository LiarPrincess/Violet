import XCTest
import Core
import Parser
import Bytecode
@testable import Compiler

/// Use 'Scripts/dump_dis.py' for reference.
class CompileList: CompileTestCase {

  /// []
  func test_empty() {
    let expr = self.listExpr(elements: [])

    let expected: [EmittedInstruction] = [
      .init(.buildList, "0"),
      .init(.return)
    ]

    if let code = self.compile(expr: expr) {
      XCTAssertCode(code, name: "<module>", qualified: "", type: .module)
      XCTAssertInstructions(code, expected)
    }
  }

  /// ['ariel', True]
  func test_constantsOnly() {
    let expr = self.listExpr(elements: [
      self.stringExpr(value: .literal("ariel")),
      self.trueExpr()
    ])

    let expected: [EmittedInstruction] = [
      .init(.loadConst, "'ariel'"),
      .init(.loadConst, "true"),
      .init(.buildList, "2"),
      .init(.return)
    ]

    if let code = self.compile(expr: expr) {
      XCTAssertCode(code, name: "<module>", qualified: "", type: .module)
      XCTAssertInstructions(code, expected)
    }
  }

  /// [ariel, True]
  func test_withIdentifier() {
    let expr = self.listExpr(elements: [
      self.identifierExpr(value: "ariel"),
      self.trueExpr()
    ])

    let expected: [EmittedInstruction] = [
      .init(.loadName,  "ariel"),
      .init(.loadConst, "true"),
      .init(.buildList, "2"),
      .init(.return)
    ]

    if let code = self.compile(expr: expr) {
      XCTAssertCode(code, name: "<module>", qualified: "", type: .module)
      XCTAssertInstructions(code, expected)
    }
  }

  /// [ariel, *sea]
  ///
  /// 0 LOAD_NAME                0 (ariel)
  /// 2 BUILD_TUPLE              1
  /// 4 LOAD_NAME                1 (sea)
  /// 6 BUILD_LIST_UNPACK        2
  /// 8 RETURN_VALUE
  func test_withUnpack() {
    let expr = self.listExpr(elements: [
      self.identifierExpr(value: "ariel"),
      self.starredExpr(expression: self.identifierExpr(value: "sea"))
    ])

    let expected: [EmittedInstruction] = [
      .init(.loadName,   "ariel"),
      .init(.buildTuple, "1"), // <- tuple!
      .init(.loadName,   "sea"),
      .init(.buildListUnpack, "2"),
      .init(.return)
    ]

    if let code = self.compile(expr: expr) {
      XCTAssertCode(code, name: "<module>", qualified: "", type: .module)
      XCTAssertInstructions(code, expected)
    }
  }

  /// [ariel, *sea, *land, eric]
  ///
  ///  0 LOAD_NAME                0 (ariel)
  ///  2 BUILD_TUPLE              1
  ///  4 LOAD_NAME                1 (sea)
  ///  6 LOAD_NAME                2 (land)
  ///  8 LOAD_NAME                3 (eric)
  /// 10 BUILD_TUPLE              1
  /// 12 BUILD_LIST_UNPACK        4
  /// 14 RETURN_VALUE
  func test_withUnpack_multiple() {
    let expr = self.listExpr(elements: [
      self.identifierExpr(value: "ariel"),
      self.starredExpr(expression: self.identifierExpr(value: "sea")),
      self.starredExpr(expression: self.identifierExpr(value: "land")),
      self.identifierExpr(value: "eric")
    ])

    let expected: [EmittedInstruction] = [
      .init(.loadName,   "ariel"),
      .init(.buildTuple, "1"),
      .init(.loadName,   "sea"),
      .init(.loadName,   "land"),
      .init(.loadName,   "eric"),
      .init(.buildTuple, "1"),
      .init(.buildListUnpack, "4"),
      .init(.return)
    ]

    if let code = self.compile(expr: expr) {
      XCTAssertCode(code, name: "<module>", qualified: "", type: .module)
      XCTAssertInstructions(code, expected)
    }
  }
}
