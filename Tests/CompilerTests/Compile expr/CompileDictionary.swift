import XCTest
import VioletCore
import VioletParser
import VioletBytecode
@testable import VioletCompiler

/// Use 'Scripts/dump_dis.py' for reference.
class CompileDictionary: CompileTestCase {

  /// { }
  func test_empty() {
    let expr = self.dictionaryExpr(elements: [])

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
        .buildMap(elementCount: 0),
        .return
      ]
    )
  }

  /// { 'ariel': 'mermaid', 'eric': 'human' }
  func test_constantsOnly() {
    let expr = self.dictionaryExpr(elements: [
      .keyValue(
        key: self.stringExpr(value: .literal("ariel")),
        value: self.stringExpr(value: .literal("mermaid"))
      ),
      .keyValue(
        key: self.stringExpr(value: .literal("eric")),
        value: self.stringExpr(value: .literal("human"))
      )
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
        .loadConst(string: "mermaid"),
        .loadConst(string: "eric"),
        .loadConst(string: "human"),
        .buildMap(elementCount: 2),
        .return
      ]
    )
  }

  /// { ariel: 'mermaid', eric: human }
  func test_withIdentifier() {
    let expr = self.dictionaryExpr(elements: [
      .keyValue(
        key: self.identifierExpr(value: "ariel"),
        value: self.stringExpr(value: .literal("mermaid"))
      ),
      .keyValue(
        key: self.identifierExpr(value: "eric"),
        value: self.identifierExpr(value: "human")
      )
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
        .loadConst(string: "mermaid"),
        .loadName(name: "eric"),
        .loadName(name: "human"),
        .buildMap(elementCount: 2),
        .return
      ]
    )
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
    let expr = self.dictionaryExpr(elements: [
      .keyValue(
        key: self.identifierExpr(value: "ariel"),
        value: self.stringExpr(value: .literal("mermaid"))
      ),
      .unpacking(self.identifierExpr(value: "sea"))
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
        .loadConst(string: "mermaid"),
        .buildMap(elementCount: 1),
        .loadName(name: "sea"),
        .buildMapUnpack(elementCount: 2),
        .return
      ]
    )
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
    let expr = self.dictionaryExpr(elements: [
      .keyValue(
        key: self.identifierExpr(value: "ariel"),
        value: self.stringExpr(value: .literal("mermaid"))
      ),
      .unpacking(self.identifierExpr(value: "sea")),
      .unpacking(self.identifierExpr(value: "land")),
      .keyValue(
        key: self.identifierExpr(value: "eric"),
        value: self.identifierExpr(value: "human")
      )
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
        .loadConst(string: "mermaid"),
        .buildMap(elementCount: 1),
        .loadName(name: "sea"),
        .loadName(name: "land"),
        .loadName(name: "eric"),
        .loadName(name: "human"),
        .buildMap(elementCount: 1),
        .buildMapUnpack(elementCount: 4),
        .return
      ]
    )
  }
}
