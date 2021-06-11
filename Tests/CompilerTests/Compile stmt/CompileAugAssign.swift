import XCTest
import VioletCore
import VioletParser
import VioletBytecode
@testable import VioletCompiler

// swiftlint:disable function_body_length
// cSpell:ignore inplace subscr

/// Use './Scripts/dump' for reference.
class CompileAugAssign: CompileTestCase {

  /// prince += beast
  ///
  ///  0 LOAD_NAME                0 (prince)
  ///  2 LOAD_NAME                1 (beast)
  ///  4 INPLACE_ADD
  ///  6 STORE_NAME               0 (prince)
  ///  8 LOAD_CONST               0 (None)
  /// 10 RETURN_VALUE
  func test_simple() {
    let operators: [(BinaryOpExpr.Operator, Instruction.Filled)] = [
      (.add, .inPlaceAdd),
      (.sub, .inPlaceSubtract),
      (.mul, .inPlaceMultiply),
      (.matMul, .inPlaceMatrixMultiply),
      (.div, .inPlaceTrueDivide),
      (.modulo, .inPlaceModulo),
      (.pow, .inPlacePower),
      (.leftShift, .inPlaceLShift),
      (.rightShift, .inPlaceRShift),
      (.bitOr, .inPlaceOr),
      (.bitXor, .inPlaceXor),
      (.bitAnd, .inPlaceAnd),
      (.floorDiv, .inPlaceFloorDivide)
    ]

    for (astOp, op) in operators {
      let stmt = self.augAssignStmt(
        target: self.identifierExpr(value: "prince", context: .store),
        op: astOp,
        value: self.identifierExpr(value: "beast")
      )

      guard let code = self.compile(stmt: stmt) else {
        continue
      }

      XCTAssertCodeObject(
        code,
        name: "<module>",
        qualifiedName: "",
        kind: .module,
        flags: [],
        instructions: [
          .loadName(name: "prince"),
          .loadName(name: "beast"),
          op,
          .storeName(name: "prince"),
          .loadConst(.none),
          .return
        ]
      )
    }
  }

  /// pretty.prince += hairy.beast
  ///
  ///  0 LOAD_NAME                0 (pretty)
  ///  2 DUP_TOP
  ///  4 LOAD_ATTR                1 (prince)
  ///  6 LOAD_NAME                2 (hairy)
  ///  8 LOAD_ATTR                3 (beast)
  /// 10 INPLACE_ADD
  /// 12 ROT_TWO
  /// 14 STORE_ATTR               1 (prince)
  /// 16 LOAD_CONST               0 (None)
  /// 18 RETURN_VALUE
  func test_attribute() {
    let stmt = self.augAssignStmt(
      target: self.attributeExpr(
        object: self.identifierExpr(value: "pretty"),
        name: "prince",
        context: .store
      ),
      op: .add,
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
        .loadName(name: "pretty"),
        .dupTop,
        .loadAttribute(name: "prince"),
        .loadName(name: "hairy"),
        .loadAttribute(name: "beast"),
        .inPlaceAdd,
        .rotTwo,
        .storeAttribute(name: "prince"),
        .loadConst(.none),
        .return
      ]
    )
  }

  /// castle[inhabitant] += items[random]
  ///
  ///  0 LOAD_NAME                0 (castle)
  ///  2 LOAD_NAME                1 (inhabitant)
  ///  4 DUP_TOP_TWO
  ///  6 BINARY_SUBSCR
  ///  8 LOAD_NAME                2 (items)
  /// 10 LOAD_NAME                3 (random)
  /// 12 BINARY_SUBSCR
  /// 14 INPLACE_ADD
  /// 16 ROT_THREE
  /// 18 STORE_SUBSCR
  /// 20 LOAD_CONST               0 (None)
  /// 22 RETURN_VALUE
  func test_subscript() {
    let stmt = self.augAssignStmt(
      target: self.subscriptExpr(
        object: self.identifierExpr(value: "castle"),
        slice: self.slice(
          kind: .index(self.identifierExpr(value: "inhabitant"))
        ),
        context: .store
      ),
      op: .add,
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
        .loadName(name: "castle"),
        .loadName(name: "inhabitant"),
        .dupTopTwo,
        .binarySubscript,
        .loadName(name: "items"),
        .loadName(name: "random"),
        .binarySubscript,
        .inPlaceAdd,
        .rotThree,
        .storeSubscript,
        .loadConst(.none),
        .return
      ]
    )
  }
}
