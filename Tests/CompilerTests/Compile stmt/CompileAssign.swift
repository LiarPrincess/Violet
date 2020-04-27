import XCTest
import VioletCore
import VioletParser
import VioletBytecode
@testable import VioletCompiler

/// Use './Scripts/dump' for reference.
class CompileAssign: CompileTestCase {

  /// prince = beast
  ///
  ///  0 LOAD_NAME                0 (beast)
  ///  2 STORE_NAME               1 (prince)
  ///  4 LOAD_CONST               0 (None)
  ///  6 RETURN_VALUE
  func test_single() {
    let stmt = self.assignStmt(
      targets: [self.identifierExpr(value: "prince", context: .store)],
      value: self.identifierExpr(value: "beast")
    )

    let expected: [EmittedInstruction] = [
      .init(.loadName, "beast"),
      .init(.storeName, "prince"),
      .init(.loadConst, "none"),
      .init(.return)
    ]

    if let code = self.compile(stmt: stmt) {
      XCTAssertCode(code, name: "<module>", qualified: "", kind: .module)
      XCTAssertInstructions(code, expected)
    }
  }

  /// lumiere = mrsPotts = cogsworth = items
  ///
  ///  0 LOAD_NAME                0 (items)
  ///  2 DUP_TOP
  ///  4 STORE_NAME               1 (lumiere)
  ///  6 DUP_TOP
  ///  8 STORE_NAME               2 (mrsPotts)
  /// 10 STORE_NAME               3 (cogsworth)
  /// 12 LOAD_CONST               0 (None)
  /// 14 RETURN_VALUE
  func test_multiple() {
    let stmt = self.assignStmt(
      targets: [
        self.identifierExpr(value: "lumiere", context: .store),
        self.identifierExpr(value: "mrsPotts", context: .store),
        self.identifierExpr(value: "cogsworth", context: .store)
      ],
      value: self.identifierExpr(value: "items")
    )

    let expected: [EmittedInstruction] = [
      .init(.loadName, "items"),
      .init(.dupTop),
      .init(.storeName, "lumiere"),
      .init(.dupTop),
      .init(.storeName, "mrsPotts"),
      .init(.storeName, "cogsworth"),
      .init(.loadConst, "none"),
      .init(.return)
    ]

    if let code = self.compile(stmt: stmt) {
      XCTAssertCode(code, name: "<module>", qualified: "", kind: .module)
      XCTAssertInstructions(code, expected)
    }
  }

  /// pretty.prince = hairy.beast
  ///
  ///  0 LOAD_NAME                0 (hairy)
  ///  2 LOAD_ATTR                1 (beast)
  ///  4 LOAD_NAME                2 (pretty)
  ///  6 STORE_ATTR               3 (prince)
  ///  8 LOAD_CONST               0 (None)
  /// 10 RETURN_VALUE
  func test_attribute() {
    let stmt = self.assignStmt(
      targets: [
        self.attributeExpr(
          object: self.identifierExpr(value: "pretty"),
          name: "prince",
          context: .store
        )
      ],
      value: self.attributeExpr(
        object: self.identifierExpr(value: "hairy"),
        name: "beast"
      )
    )

    let expected: [EmittedInstruction] = [
      .init(.loadName, "hairy"),
      .init(.loadAttribute, "beast"),
      .init(.loadName, "pretty"),
      .init(.storeAttribute, "prince"),
      .init(.loadConst, "none"),
      .init(.return)
    ]

    if let code = self.compile(stmt: stmt) {
      XCTAssertCode(code, name: "<module>", qualified: "", kind: .module)
      XCTAssertInstructions(code, expected)
    }
  }

  /// castle[inhabitant] = items[random]
  ///
  ///  0 LOAD_NAME                0 (items)
  ///  2 LOAD_NAME                1 (random)
  ///  4 BINARY_SUBSCR
  ///  6 LOAD_NAME                2 (castle)
  ///  8 LOAD_NAME                3 (inhabitant)
  /// 10 STORE_SUBSCR
  /// 12 LOAD_CONST               0 (None)
  /// 14 RETURN_VALUE
  func test_subscript() {
    let stmt = self.assignStmt(
      targets: [
        self.subscriptExpr(
          object: self.identifierExpr(value: "castle"),
          slice: self.slice(
            kind: .index(self.identifierExpr(value: "inhabitant"))
          ),
          context: .store
        )
      ],
      value: self.subscriptExpr(
        object: self.identifierExpr(value: "items"),
        slice: self.slice(
          kind: .index(self.identifierExpr(value: "random"))
        )
      )
    )

    let expected: [EmittedInstruction] = [
      .init(.loadName, "items"),
      .init(.loadName, "random"),
      .init(.binarySubscript),
      .init(.loadName, "castle"),
      .init(.loadName, "inhabitant"),
      .init(.storeSubscript),
      .init(.loadConst, "none"),
      .init(.return)
    ]

    if let code = self.compile(stmt: stmt) {
      XCTAssertCode(code, name: "<module>", qualified: "", kind: .module)
      XCTAssertInstructions(code, expected)
    }
  }
}
