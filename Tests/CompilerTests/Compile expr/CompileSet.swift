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

    guard let code = self.compile(expr: expr) else {
      return
    }

    XCTAssertCodeObject(
      code,
      name: "<module>",
      qualifiedName: "",
      kind: .module,
      flags: [],
      instructions: [
        .loadConst(string: "ariel"),
        .loadConst(.true),
        .buildSet(elementCount: 2),
        .return
      ]
    )
  }

  /// { ariel, True }
  func test_withIdentifier() {
    let expr = self.setExpr(elements: [
      self.identifierExpr(value: "ariel"),
      self.trueExpr()
    ])

    guard let code = self.compile(expr: expr) else {
      return
    }

    XCTAssertCodeObject(
      code,
      name: "<module>",
      qualifiedName: "",
      kind: .module,
      flags: [],
      instructions: [
        .loadName(name: "ariel"),
        .loadConst(.true),
        .buildSet(elementCount: 2),
        .return
      ]
    )
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

    guard let code = self.compile(expr: expr) else {
      return
    }

    XCTAssertCodeObject(
      code,
      name: "<module>",
      qualifiedName: "",
      kind: .module,
      flags: [],
      instructions: [
        .loadName(name: "ariel"),
        .buildSet(elementCount: 1),
        .loadName(name: "sea"),
        .buildSetUnpack(elementCount: 2),
        .return
      ]
    )
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

    guard let code = self.compile(expr: expr) else {
      return
    }

    XCTAssertCodeObject(
      code,
      name: "<module>",
      qualifiedName: "",
      kind: .module,
      flags: [],
      instructions: [
        .loadName(name: "ariel"),
        .buildSet(elementCount: 1),
        .loadName(name: "sea"),
        .loadName(name: "land"),
        .loadName(name: "eric"),
        .buildSet(elementCount: 1),
        .buildSetUnpack(elementCount: 4),
        .return
      ]
    )
  }
}
