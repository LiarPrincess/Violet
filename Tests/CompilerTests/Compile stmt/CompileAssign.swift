import XCTest
import VioletCore
import VioletParser
import VioletBytecode
@testable import VioletCompiler

// cSpell:ignore subscr

/// Use './Scripts/dump' for reference.
class CompileAssign: CompileTestCase {

  // MARK: - Trivial

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
        .loadName(name: "beast"),
        .storeName(name: "prince"),
        .loadConst(.none),
        .return
      ]
    )
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
        .loadName(name: "items"),
        .dupTop,
        .storeName(name: "lumiere"),
        .dupTop,
        .storeName(name: "mrsPotts"),
        .storeName(name: "cogsworth"),
        .loadConst(.none),
        .return
      ]
    )
  }

  // MARK: - Attribute

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
        .loadName(name: "hairy"),
        .loadAttribute(name: "beast"),
        .loadName(name: "pretty"),
        .storeAttribute(name: "prince"),
        .loadConst(.none),
        .return
      ]
    )
  }

  // MARK: - Subscript

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
        .loadName(name: "items"),
        .loadName(name: "random"),
        .binarySubscript,
        .loadName(name: "castle"),
        .loadName(name: "inhabitant"),
        .storeSubscript,
        .loadConst(.none),
        .return
      ]
    )
  }

  // MARK: - To tuple

  /// (lumiere, mrsPotts, cogsworth) = items
  ///
  ///  0 LOAD_NAME                0 (items)
  ///  2 UNPACK_SEQUENCE          3
  ///  4 STORE_NAME               1 (lumiere)
  ///  6 STORE_NAME               2 (mrsPotts)
  ///  8 STORE_NAME               3 (cogsworth)
  /// 10 LOAD_CONST               0 (None)
  /// 12 RETURN_VALUE
  func test_toTuple() {
    let stmt = self.assignStmt(
      targets: [
        self.tupleExpr(
          elements: [
            self.identifierExpr(value: "lumiere", context: .store),
            self.identifierExpr(value: "mrsPotts", context: .store),
            self.identifierExpr(value: "cogsworth", context: .store)
          ],
          context: .store
        )
      ],
      value: self.identifierExpr(value: "items")
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
        .loadName(name: "items"),
        .unpackSequence(elementCount: 3),
        .storeName(name: "lumiere"),
        .storeName(name: "mrsPotts"),
        .storeName(name: "cogsworth"),
        .loadConst(.none),
        .return
      ]
    )
  }

  /// (lumiere, mrsPotts, *other_pots, cogsworth) = items
  ///
  ///  0 LOAD_NAME                0 (items)
  ///  2 EXTENDED_ARG             1
  ///  4 UNPACK_EX              258
  ///  6 STORE_NAME               1 (lumiere)
  ///  8 STORE_NAME               2 (mrsPotts)
  /// 10 STORE_NAME               3 (other_pots)
  /// 12 STORE_NAME               4 (cogsworth)
  /// 14 LOAD_CONST               0 (None)
  /// 16 RETURN_VALUE
  func test_toTuple_withUnpack() {
    let stmt = self.assignStmt(
      targets: [
        self.tupleExpr(
          elements: [
            self.identifierExpr(value: "lumiere", context: .store),
            self.identifierExpr(value: "mrsPotts", context: .store),
            self.starredExpr(
              expression: self.identifierExpr(value: "other_pots", context: .store),
              context: .store
            ),
            self.identifierExpr(value: "cogsworth", context: .store)
          ],
          context: .store
        )
      ],
      value: self.identifierExpr(value: "items")
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
        .loadName(name: "items"),
        .unpackEx(arg: Instruction.UnpackExArg(countBefore: 2, countAfter: 1)),
        .storeName(name: "lumiere"),
        .storeName(name: "mrsPotts"),
        .storeName(name: "other_pots"),
        .storeName(name: "cogsworth"),
        .loadConst(.none),
        .return
      ]
    )
  }
}
