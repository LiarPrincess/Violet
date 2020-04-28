import XCTest
import VioletCore
import VioletParser
import VioletBytecode
@testable import VioletCompiler

/// Use 'Scripts/dump_dis.py' for reference.
class CompileSet: CompileTestCase {

  // '{}' crates new dictionary!
  // It is not possible to create empty set using literal.
  // func test_empty() { }

  /// { 'ariel', True }
  func test_constantsOnly() {
    let expr = self.setExpr(elements: [
      self.stringExpr(value: .literal("ariel")),
      self.trueExpr()
    ])

    let expected: [EmittedInstruction] = [
      .init(.loadConst, "'ariel'"),
      .init(.loadConst, "true"),
      .init(.buildSet, "2"),
      .init(.return)
    ]

    if let code = self.compile(expr: expr) {
      XCTAssertCode(code, name: "<module>", qualified: "", kind: .module)
      XCTAssertInstructions(code, expected)
    }
  }

  /// { ariel, True }
  func test_withIdentifier() {
    let expr = self.setExpr(elements: [
      self.identifierExpr(value: "ariel"),
      self.trueExpr()
    ])

    let expected: [EmittedInstruction] = [
      .init(.loadName, "ariel"),
      .init(.loadConst, "true"),
      .init(.buildSet, "2"),
      .init(.return)
    ]

    if let code = self.compile(expr: expr) {
      XCTAssertCode(code, name: "<module>", qualified: "", kind: .module)
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
    let expr = self.setExpr(elements: [
      self.identifierExpr(value: "ariel"),
      self.starredExpr(expression: self.identifierExpr(value: "sea"))
    ])

    let expected: [EmittedInstruction] = [
      .init(.loadName, "ariel"),
      .init(.buildSet, "1"),
      .init(.loadName, "sea"),
      .init(.buildSetUnpack, "2"),
      .init(.return)
    ]

    if let code = self.compile(expr: expr) {
      XCTAssertCode(code, name: "<module>", qualified: "", kind: .module)
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
    let expr = self.setExpr(elements: [
      self.identifierExpr(value: "ariel"),
      self.starredExpr(expression: self.identifierExpr(value: "sea")),
      self.starredExpr(expression: self.identifierExpr(value: "land")),
      self.identifierExpr(value: "eric")
    ])

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
      XCTAssertCode(code, name: "<module>", qualified: "", kind: .module)
      XCTAssertInstructions(code, expected)
    }
  }
}
