import XCTest
import VioletCore
import VioletParser
import VioletBytecode
@testable import VioletCompiler

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
    let operators: [BinaryOpExpr.Operator: EmittedInstructionKind] = [
      .add: .inplaceAdd,
      .sub: .inplaceSubtract,
      .mul: .inplaceMultiply,
      .matMul: .inplaceMatrixMultiply,
      .div: .inplaceTrueDivide,
      .modulo: .inplaceModulo,
      .pow: .inplacePower,
      .leftShift: .inplaceLShift,
      .rightShift: .inplaceRShift,
      .bitOr: .inplaceOr,
      .bitXor: .inplaceXor,
      .bitAnd: .inplaceAnd,
      .floorDiv: .inplaceFloorDivide
    ]

    for (op, emittedOp) in operators {
      let msg = "for '\(op)'"

      let stmt = self.augAssignStmt(
        target: self.identifierExpr(value: "prince", context: .store),
        op: op,
        value: self.identifierExpr(value: "beast")
      )

      let expected: [EmittedInstruction] = [
        .init(.loadName, "prince"),
        .init(.loadName, "beast"),
        .init(emittedOp),
        .init(.storeName, "prince"),
        .init(.loadConst, "none"),
        .init(.return)
      ]

      if let code = self.compile(stmt: stmt) {
        XCTAssertCode(code, name: "<module>", qualified: "", kind: .module, msg)
        XCTAssertInstructions(code, expected, msg)
      }
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

    let expected: [EmittedInstruction] = [
      .init(.loadName, "pretty"),
      .init(.dupTop),
      .init(.loadAttribute, "prince"),
      .init(.loadName, "hairy"),
      .init(.loadAttribute, "beast"),
      .init(.inplaceAdd),
      .init(.rotTwo),
      .init(.storeAttribute, "prince"),
      .init(.loadConst, "none"),
      .init(.return)
    ]

    if let code = self.compile(stmt: stmt) {
      XCTAssertCode(code, name: "<module>", qualified: "", kind: .module)
      XCTAssertInstructions(code, expected)
    }
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

    let expected: [EmittedInstruction] = [
      .init(.loadName, "castle"),
      .init(.loadName, "inhabitant"),
      .init(.dupTopTwo),
      .init(.binarySubscript),
      .init(.loadName, "items"),
      .init(.loadName, "random"),
      .init(.binarySubscript),
      .init(.inplaceAdd),
      .init(.rotThree),
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
