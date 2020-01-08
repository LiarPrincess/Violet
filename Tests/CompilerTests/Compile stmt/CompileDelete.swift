import XCTest
import Core
import Parser
import Bytecode
@testable import Compiler

/// Use 'Scripts/dump_dis.py' for reference.
class CompileDelete: CompileTestCase {

  /// del jafar
  ///
  /// 0 DELETE_NAME              0 (jafar)
  /// 2 LOAD_CONST               0 (None)
  /// 4 RETURN_VALUE
  func test_identifier() {
    let stmt = self.delete(
      self.identifierExpr("jafar")
    )

    let expected: [EmittedInstruction] = [
      .init(.deleteName, "jafar"),
      .init(.loadConst, "none"),
      .init(.return)
    ]

    if let code = self.compile(stmt: stmt) {
      XCTAssertCode(code, name: "<module>", qualified: "", type: .module)
      XCTAssertInstructions(code, expected)
    }
  }

  /// del jafar, iago
  ///
  /// 0 DELETE_NAME              0 (jafar)
  /// 2 DELETE_NAME              1 (iago)
  /// 4 LOAD_CONST               0 (None)
  /// 6 RETURN_VALUE
  func test_multiple() {
    let stmt = self.delete(
      self.identifierExpr("jafar"),
      self.identifierExpr("iago")
    )

    let expected: [EmittedInstruction] = [
      .init(.deleteName, "jafar"),
      .init(.deleteName, "iago"),
      .init(.loadConst, "none"),
      .init(.return)
    ]

    if let code = self.compile(stmt: stmt) {
      XCTAssertCode(code, name: "<module>", qualified: "", type: .module)
      XCTAssertInstructions(code, expected)
    }
  }

  /// del (jafar, iago)
  ///
  /// 0 DELETE_NAME              0 (jafar)
  /// 2 DELETE_NAME              1 (iago)
  /// 4 LOAD_CONST               0 (None)
  /// 6 RETURN_VALUE
  func test_tuple() {
    let stmt = self.delete(
      self.expression(.tuple([
        self.identifierExpr("jafar"),
        self.identifierExpr("iago")
      ]))
    )

    let expected: [EmittedInstruction] = [
      .init(.deleteName, "jafar"),
      .init(.deleteName, "iago"),
      .init(.loadConst, "none"),
      .init(.return)
    ]

    if let code = self.compile(stmt: stmt) {
      XCTAssertCode(code, name: "<module>", qualified: "", type: .module)
      XCTAssertInstructions(code, expected)
    }
  }

  /// del agrabah.jafar
  ///
  /// 0 LOAD_NAME                0 (agrabah)
  /// 2 DELETE_ATTR              1 (jafar)
  /// 4 LOAD_CONST               0 (None)
  /// 6 RETURN_VALUE
  func test_attribute() {
    let stmt = self.delete(
      self.expression(
        .attribute(
          self.identifierExpr("agrabah"),
          name: "jafar"
        )
      )
    )

    let expected: [EmittedInstruction] = [
      .init(.loadName, "agrabah"),
      .init(.deleteAttribute, "jafar"),
      .init(.loadConst, "none"),
      .init(.return)
    ]

    if let code = self.compile(stmt: stmt) {
      XCTAssertCode(code, name: "<module>", qualified: "", type: .module)
      XCTAssertInstructions(code, expected)
    }
  }

  /// del agrabah[jafar]
  ///
  ///  0 LOAD_NAME                0 (agrabah)
  ///  2 LOAD_NAME                1 (jafar)
  ///  4 DELETE_SUBSCR
  ///  6 LOAD_CONST               0 (None)
  ///  8 RETURN_VALUE
  func test_subscript() {
    let stmt = self.delete(
      self.expression(
        .subscript(
          self.identifierExpr("agrabah"),
          slice: self.slice(.index(
            self.identifierExpr("jafar")
          ))
        )
      )
    )

    let expected: [EmittedInstruction] = [
      .init(.loadName, "agrabah"),
      .init(.loadName, "jafar"),
      .init(.deleteSubscript),
      .init(.loadConst, "none"),
      .init(.return)
    ]

    if let code = self.compile(stmt: stmt) {
      XCTAssertCode(code, name: "<module>", qualified: "", type: .module)
      XCTAssertInstructions(code, expected)
    }
  }
}
