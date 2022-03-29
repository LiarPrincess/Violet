import XCTest
import VioletCore
import VioletParser
import VioletBytecode
@testable import VioletCompiler

// swiftlint:disable function_body_length
// cSpell:ignore subscr whozits whatzits

/// Use './Scripts/dump' for reference.
class CompileAnnAssign: CompileTestCase {

  /// flounder:Animal = "Friend"
  ///
  ///  0 SETUP_ANNOTATIONS
  ///  2 LOAD_CONST               0 ('Friend')
  ///  4 STORE_NAME               0 (flounder)
  ///  6 LOAD_NAME                1 (Animal)
  ///  8 LOAD_NAME                2 (__annotations__)
  /// 10 LOAD_CONST               1 ('flounder')
  /// 12 STORE_SUBSCR
  /// 14 LOAD_CONST               2 (None)
  /// 16 RETURN_VALUE
  func test_simple() {
    let stmt = self.annAssignStmt(
      target: self.identifierExpr(value: "flounder", context: .store),
      annotation: self.identifierExpr(value: "Animal"),
      value: self.stringExpr(value: .literal("Friend")),
      isSimple: true
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
        .setupAnnotations,
        .loadConst(string: "Friend"),
        .storeName(name: "flounder"),
        .loadName(name: "Animal"),
        .loadName(name: "__annotations__"),
        .loadConst(string: "flounder"),
        .storeSubscript,
        .loadConst(.none),
        .return
      ]
    )
  }

  /// ariel:Mermaid
  ///
  ///  0 SETUP_ANNOTATIONS
  ///  2 LOAD_NAME                0 (Mermaid)
  ///  4 LOAD_NAME                1 (__annotations__)
  ///  6 LOAD_CONST               0 ('ariel')
  ///  8 STORE_SUBSCR
  /// 10 LOAD_CONST               1 (None)
  /// 12 RETURN_VALUE
  func test_withoutValue() {
    let stmt = self.annAssignStmt(
      target: self.identifierExpr(value: "ariel", context: .store),
      annotation: self.identifierExpr(value: "Mermaid"),
      value: nil,
      isSimple: true
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
        .setupAnnotations,
        .loadName(name: "Mermaid"),
        .loadName(name: "__annotations__"),
        .loadConst(string: "ariel"),
        .storeSubscript,
        .loadConst(.none),
        .return
      ]
    )
  }

  // MARK: - Attribute

  /// sea.flounder:Animal = "Friend"
  ///
  ///  0 SETUP_ANNOTATIONS
  ///  2 LOAD_CONST               0 ('Friend')
  ///  4 LOAD_NAME                0 (sea)
  ///  6 STORE_ATTR               1 (flounder)
  ///  8 LOAD_NAME                2 (Animal)
  /// 10 POP_TOP
  /// 12 LOAD_CONST               1 (None)
  /// 14 RETURN_VALUE
  func test_toAttribute() {
    let stmt = self.annAssignStmt(
      target: self.attributeExpr(
        object: self.identifierExpr(value: "sea"),
        name: "flounder",
        context: .store
      ),
      annotation: self.identifierExpr(value: "Animal"),
      value: self.stringExpr(value: .literal("Friend")),
      isSimple: false
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
        .setupAnnotations,
        .loadConst(string: "Friend"),
        .loadName(name: "sea"),
        .storeAttribute(name: "flounder"),
        .loadName(name: "Animal"),
        .popTop,
        .loadConst(.none),
        .return
      ]
    )
  }

  // MARK: - Subscript

  /// sea[whozits]:Items = "Owned by Ariel"
  ///
  ///  0 SETUP_ANNOTATIONS
  ///  2 LOAD_CONST               0 ('Friend')
  ///  4 LOAD_NAME                0 (sea)
  ///  6 LOAD_NAME                1 (flounder)
  ///  8 STORE_SUBSCR
  /// 10 LOAD_NAME                2 (Animal)
  /// 12 POP_TOP
  /// 14 LOAD_CONST               1 (None)
  /// 16 RETURN_VALUE
  func test_toIndex() {
    let stmt = self.annAssignStmt(
      target: self.subscriptExpr(
        object: self.identifierExpr(value: "sea"),
        slice: self.slice(
          kind: .index(self.identifierExpr(value: "whozits"))
        ),
        context: .store
      ),
      annotation: self.identifierExpr(value: "Items"),
      value: self.stringExpr(value: .literal("Owned by Ariel")),
      isSimple: false
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
        .setupAnnotations,
        .loadConst(string: "Owned by Ariel"),
        .loadName(name: "sea"),
        .loadName(name: "whozits"),
        .storeSubscript,
        .loadName(name: "Items"),
        .popTop,
        .loadConst(.none),
        .return
      ]
    )
  }

  /// sea[whozits]: Items
  /// https://www.elyrics.net/read/l/little-mermaid-lyrics/part-of-that-world-lyrics.html
  ///
  ///  0 SETUP_ANNOTATIONS
  ///  2 LOAD_NAME                0 (sea)
  ///  4 POP_TOP
  ///  6 LOAD_NAME                1 (whozits)
  ///  8 POP_TOP
  /// 10 LOAD_NAME                2 (Items)
  /// 12 POP_TOP
  /// 14 LOAD_CONST               0 (None)
  /// 16 RETURN_VALUE
  func test_toIndex_withoutValue() {
    let stmt = self.annAssignStmt(
      target: self.subscriptExpr(
        object: self.identifierExpr(value: "sea"),
        slice: self.slice(
          kind: .index(self.identifierExpr(value: "whozits"))
        ),
        context: .store
      ),
      annotation: self.identifierExpr(value: "Items"),
      value: nil,
      isSimple: false
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
        .setupAnnotations,
        .loadName(name: "sea"),
        .popTop,
        .loadName(name: "whozits"),
        .popTop,
        .loadName(name: "Items"),
        .popTop,
        .loadConst(.none),
        .return
      ]
    )
  }

  /// sea[whozits:whatzits:thingamabobs]:Items
  /// https://www.elyrics.net/read/l/little-mermaid-lyrics/part-of-that-world-lyrics.html
  ///
  ///  0 SETUP_ANNOTATIONS
  ///  2 LOAD_NAME                0 (sea)
  ///  4 POP_TOP
  ///  6 LOAD_NAME                1 (whozits)
  ///  8 POP_TOP
  /// 10 LOAD_NAME                2 (whatzits)
  /// 12 POP_TOP
  /// 14 LOAD_NAME                3 (thingamabobs)
  /// 16 POP_TOP
  /// 18 LOAD_NAME                4 (Items)
  /// 20 POP_TOP
  /// 22 LOAD_CONST               0 (None)
  /// 24 RETURN_VALUE
  func test_toSlice_withoutValue() {
    let stmt = self.annAssignStmt(
      target: self.subscriptExpr(
        object: self.identifierExpr(value: "sea"),
        slice: self.slice(
          kind: .slice(
            lower: self.identifierExpr(value: "whozits"),
            upper: self.identifierExpr(value: "whatzits"),
            step: self.identifierExpr(value: "thingamabobs")
          )
        ),
        context: .store
      ),
      annotation: self.identifierExpr(value: "Items"),
      value: nil,
      isSimple: false
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
        .setupAnnotations,
        .loadName(name: "sea"),
        .popTop,
        .loadName(name: "whozits"),
        .popTop,
        .loadName(name: "whatzits"),
        .popTop,
        .loadName(name: "thingamabobs"),
        .popTop,
        .loadName(name: "Items"),
        .popTop,
        .loadConst(.none),
        .return
      ]
    )
  }
}
