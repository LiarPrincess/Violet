import XCTest
import Core
import Parser
import Bytecode
@testable import Compiler

/// Use 'Scripts/dump_dis.py' for reference.
class CompileSet: XCTestCase, CommonCompiler {

  // '{}' crates new dictionary!
  // It is not possible to create empty set using literal.
  // func test_empty() { }

  /// { 'ariel', True }
  func test_constantsOnly() {
    let expr = self.expression(.set([
      self.expression(.string(.literal("ariel"))),
      self.expression(.true)
    ]))

    let expected: [EmittedInstruction] = [
      .init(.loadConst, "ariel"),
      .init(.loadConst, "true"),
      .init(.buildSet, "2"),
      .init(.return)
    ]

    if let code = self.compile(expr: expr) {
      XCTAssertCode(code, name: "<module>", qualified: "", type: .module)
      XCTAssertInstructions(code, expected)
    }
  }

  /// { ariel, True }
  func test_withIdentifier() {
    let expr = self.expression(.set([
      self.expression(.identifier("ariel")),
      self.expression(.true)
    ]))

    let expected: [EmittedInstruction] = [
      .init(.loadName,  "ariel"),
      .init(.loadConst, "true"),
      .init(.buildSet, "2"),
      .init(.return)
    ]

    if let code = self.compile(expr: expr) {
      XCTAssertCode(code, name: "<module>", qualified: "", type: .module)
      XCTAssertInstructions(code, expected)
    }
  }

  /// { ariel, *sea }
  ///
  /// 0 LOAD_NAME                0 (ariel)
  /// 2 BUILD_SET                1
  /// 4 LOAD_NAME                1 (sea)
  /// 6 BUILD_SET_UNPACK         2
  /// 8 RETURN_VALUE
  func test_withUnpack() {
    let expr = self.expression(.set([
      self.expression(.identifier("ariel")),
      self.expression(.starred(self.expression(.identifier("sea"))))
    ]))

    let expected: [EmittedInstruction] = [
      .init(.loadName, "ariel"),
      .init(.buildSet, "1"),
      .init(.loadName, "sea"),
      .init(.buildSetUnpack, "2"),
      .init(.return)
    ]

    if let code = self.compile(expr: expr) {
      XCTAssertCode(code, name: "<module>", qualified: "", type: .module)
      XCTAssertInstructions(code, expected)
    }
  }

  /// { ariel, *sea, *land, eric }
  ///
  ///  0 LOAD_NAME                0 (ariel)
  ///  2 BUILD_SET                1
  ///  4 LOAD_NAME                1 (sea)
  ///  6 LOAD_NAME                2 (land)
  ///  8 LOAD_NAME                3 (eric)
  /// 10 BUILD_SET                1
  /// 12 BUILD_SET_UNPACK         4
  /// 14 RETURN_VALUE
  func test_withUnpack_multiple() {
    let expr = self.expression(.set([
      self.expression(.identifier("ariel")),
      self.expression(.starred(self.expression(.identifier("sea")))),
      self.expression(.starred(self.expression(.identifier("land")))),
      self.expression(.identifier("eric"))
    ]))

    let expected: [EmittedInstruction] = [
      .init(.loadName, "ariel"),
      .init(.buildSet, "1"),
      .init(.loadName, "sea"),
      .init(.loadName, "land"),
      .init(.loadName, "eric"),
      .init(.buildSet, "1"),
      .init(.buildSetUnpack, "4"),
      .init(.return)
    ]

    if let code = self.compile(expr: expr) {
      XCTAssertCode(code, name: "<module>", qualified: "", type: .module)
      XCTAssertInstructions(code, expected)
    }
  }
}
