import XCTest
import Core
import Parser
import Bytecode
@testable import Compiler

/// Use 'Scripts/dump_dis.py' for reference.
class CompileDictionary: CompileTestCase {

  /// { }
  func test_empty() {
    let expr = self.expression(.dictionary([]))

    let expected: [EmittedInstruction] = [
      .init(.buildMap, "0"),
      .init(.return)
    ]

    if let code = self.compile(expr: expr) {
      XCTAssertCode(code, name: "<module>", qualified: "", type: .module)
      XCTAssertInstructions(code, expected)
    }
  }

  /// { 'ariel': 'mermaid', 'eric': 'human' }
  func test_constantsOnly() {
    let expr = self.expression(.dictionary([
      .keyValue(
        key: self.expression(.string(.literal("ariel"))),
        value: self.expression(.string(.literal("mermaid")))
      ),
      .keyValue(
        key: self.expression(.string(.literal("eric"))),
        value: self.expression(.string(.literal("human")))
      )
    ]))

    let expected: [EmittedInstruction] = [
      .init(.loadConst, "'ariel'"),
      .init(.loadConst, "'mermaid'"),
      .init(.loadConst, "'eric'"),
      .init(.loadConst, "'human'"),
      .init(.buildMap,  "2"),
      .init(.return)
    ]

    if let code = self.compile(expr: expr) {
      XCTAssertCode(code, name: "<module>", qualified: "", type: .module)
      XCTAssertInstructions(code, expected)
    }
  }

  /// { ariel: 'mermaid', eric: human }
  func test_withIdentifier() {
    let expr = self.expression(.dictionary([
      .keyValue(
        key: self.identifierExpr("ariel"),
        value: self.expression(.string(.literal("mermaid")))
      ),
      .keyValue(
        key: self.identifierExpr("eric"),
        value: self.identifierExpr("human")
      )
    ]))

    let expected: [EmittedInstruction] = [
      .init(.loadName,  "ariel"),
      .init(.loadConst, "'mermaid'"),
      .init(.loadName,  "eric"),
      .init(.loadName,  "human"),
      .init(.buildMap,  "2"),
      .init(.return)
    ]

    if let code = self.compile(expr: expr) {
      XCTAssertCode(code, name: "<module>", qualified: "", type: .module)
      XCTAssertInstructions(code, expected)
    }
  }

  /// { ariel: 'mermaid', **sea }
  ///
  ///  0 LOAD_NAME                0 (ariel)
  ///  2 LOAD_CONST               0 ('mermaid')
  ///  4 BUILD_MAP                1
  ///  6 LOAD_NAME                1 (sea)
  ///  8 BUILD_MAP_UNPACK         2
  /// 10 RETURN_VALUE
  func test_withUnpack() {
    let expr = self.expression(.dictionary([
      .keyValue(
        key: self.identifierExpr("ariel"),
        value: self.expression(.string(.literal("mermaid")))
      ),
      .unpacking(self.identifierExpr("sea"))
    ]))

    let expected: [EmittedInstruction] = [
      .init(.loadName,  "ariel"),
      .init(.loadConst, "'mermaid'"),
      .init(.buildMap,  "1"),
      .init(.loadName,  "sea"),
      .init(.buildMapUnpack, "2"),
      .init(.return)
    ]

    if let code = self.compile(expr: expr) {
      XCTAssertCode(code, name: "<module>", qualified: "", type: .module)
      XCTAssertInstructions(code, expected)
    }
  }

  /// { ariel: 'mermaid', **sea, **land, eric: human }
  ///
  ///  0 LOAD_NAME                0 (ariel)
  ///  2 LOAD_CONST               0 ('mermaid')
  ///  4 BUILD_MAP                1
  ///  6 LOAD_NAME                1 (sea)
  ///  8 LOAD_NAME                2 (land)
  /// 10 LOAD_NAME                3 (eric)
  /// 12 LOAD_NAME                4 (human)
  /// 14 BUILD_MAP                1
  /// 16 BUILD_MAP_UNPACK         4
  /// 18 RETURN_VALUE
  func test_withUnpack_multiple() {
    let expr = self.expression(.dictionary([
      .keyValue(
        key: self.identifierExpr("ariel"),
        value: self.expression(.string(.literal("mermaid")))
      ),
      .unpacking(self.identifierExpr("sea")),
      .unpacking(self.identifierExpr("land")),
      .keyValue(
        key: self.identifierExpr("eric"),
        value: self.identifierExpr("human")
      )
    ]))

    let expected: [EmittedInstruction] = [
      .init(.loadName,  "ariel"),
      .init(.loadConst, "'mermaid'"),
      .init(.buildMap,  "1"),
      .init(.loadName,  "sea"),
      .init(.loadName,  "land"),
      .init(.loadName,  "eric"),
      .init(.loadName,  "human"),
      .init(.buildMap, "1"),
      .init(.buildMapUnpack, "4"),
      .init(.return)
    ]

    if let code = self.compile(expr: expr) {
      XCTAssertCode(code, name: "<module>", qualified: "", type: .module)
      XCTAssertInstructions(code, expected)
    }
  }
}
