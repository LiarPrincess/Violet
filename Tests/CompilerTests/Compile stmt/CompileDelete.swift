import XCTest
import VioletCore
import VioletParser
import VioletBytecode
@testable import VioletCompiler

// cSpell:ignore subscr

/// Use './Scripts/dump' for reference.
class CompileDelete: CompileTestCase {

  /// del jafar
  ///
  /// 0 DELETE_NAME              0 (jafar)
  /// 2 LOAD_CONST               0 (None)
  /// 4 RETURN_VALUE
  func test_identifier() {
    let stmt = self.deleteStmt(
      values: [
        self.identifierExpr(value: "jafar", context: .del)
      ]
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
        .deleteName(name: "jafar"),
        .loadConst(.none),
        .return
      ]
    )
  }

  /// del jafar, iago
  ///
  /// 0 DELETE_NAME              0 (jafar)
  /// 2 DELETE_NAME              1 (iago)
  /// 4 LOAD_CONST               0 (None)
  /// 6 RETURN_VALUE
  func test_multiple() {
    let stmt = self.deleteStmt(
      values: [
        self.identifierExpr(value: "jafar", context: .del),
        self.identifierExpr(value: "iago", context: .del)
      ]
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
        .deleteName(name: "jafar"),
        .deleteName(name: "iago"),
        .loadConst(.none),
        .return
      ]
    )
  }

  /// del (jafar, iago)
  ///
  /// 0 DELETE_NAME              0 (jafar)
  /// 2 DELETE_NAME              1 (iago)
  /// 4 LOAD_CONST               0 (None)
  /// 6 RETURN_VALUE
  func test_tuple() {
    let stmt = self.deleteStmt(
      values: [
        self.tupleExpr(
          elements: [
            self.identifierExpr(value: "jafar", context: .del),
            self.identifierExpr(value: "iago", context: .del)
          ],
          context: .del
        )
      ]
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
        .deleteName(name: "jafar"),
        .deleteName(name: "iago"),
        .loadConst(.none),
        .return
      ]
    )
  }

  /// del agrabah.jafar
  ///
  /// 0 LOAD_NAME                0 (agrabah)
  /// 2 DELETE_ATTR              1 (jafar)
  /// 4 LOAD_CONST               0 (None)
  /// 6 RETURN_VALUE
  func test_attribute() {
    let stmt = self.deleteStmt(
      values: [
        self.attributeExpr(
          object: self.identifierExpr(value: "agrabah"),
          name: "jafar",
          context: .del
        )
      ]
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
        .loadName(name: "agrabah"),
        .deleteAttribute(name: "jafar"),
        .loadConst(.none),
        .return
      ]
    )
  }

  /// del agrabah[jafar]
  ///
  ///  0 LOAD_NAME                0 (agrabah)
  ///  2 LOAD_NAME                1 (jafar)
  ///  4 DELETE_SUBSCR
  ///  6 LOAD_CONST               0 (None)
  ///  8 RETURN_VALUE
  func test_subscript() {
    let stmt = self.deleteStmt(
      values: [
        self.subscriptExpr(
          object: self.identifierExpr(value: "agrabah"),
          slice: self.slice(
            kind: .index(self.identifierExpr(value: "jafar"))
          ),
          context: .del
        )
      ]
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
        .loadName(name: "agrabah"),
        .loadName(name: "jafar"),
        .deleteSubscript,
        .loadConst(.none),
        .return
      ]
    )
  }
}
