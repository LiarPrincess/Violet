import XCTest
import Core
import Parser
import Bytecode
@testable import Compiler

/// Use './Scripts/dump_compiler_test' for reference.
class CompileAssign: CompileTestCase {

  /// prince = beast
  ///
  ///  0 LOAD_NAME                0 (beast)
  ///  2 STORE_NAME               1 (prince)
  ///  4 LOAD_CONST               0 (None)
  ///  6 RETURN_VALUE
  func test_single() {
    let stmt = self.assign(
      target: [self.identifierExpr("prince")],
      value: self.identifierExpr("beast")
    )

    let expected: [EmittedInstruction] = [
      .init(.loadName, "beast"),
      .init(.storeName, "prince"),
      .init(.loadConst, "none"),
      .init(.return)
    ]

    if let code = self.compile(stmt: stmt) {
      XCTAssertCode(code, name: "<module>", qualified: "", type: .module)
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
    let stmt = self.assign(
      target: [
        self.identifierExpr("lumiere"),
        self.identifierExpr("mrsPotts"),
        self.identifierExpr("cogsworth")
      ],
      value: self.identifierExpr("items")
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
      XCTAssertCode(code, name: "<module>", qualified: "", type: .module)
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
    let stmt = self.assign(
      target: [
        self.expression(.attribute(
          self.identifierExpr("pretty"),
          name: "prince"
        ))
      ],
      value: self.expression(.attribute(
        self.identifierExpr("hairy"),
        name: "beast"
      ))
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
      XCTAssertCode(code, name: "<module>", qualified: "", type: .module)
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
    let stmt = self.assign(
      target: [
        self.expression(.subscript(
          self.identifierExpr("castle"),
          slice: self.slice(.index(
            self.identifierExpr("inhabitant")
          ))
        ))
      ],
      value: self.expression(.subscript(
        self.identifierExpr("items"),
        slice: self.slice(.index(
          self.identifierExpr("random")
        ))
      ))
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
      XCTAssertCode(code, name: "<module>", qualified: "", type: .module)
      XCTAssertInstructions(code, expected)
    }
  }
}
