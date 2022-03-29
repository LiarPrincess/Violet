import XCTest
import VioletCore
import VioletParser
import VioletBytecode
@testable import VioletCompiler

// swiftlint:disable function_body_length

/// Use 'Scripts/dump_dis.py' for reference.
class CompileOperators: CompileTestCase {

  // MARK: - Unary

  /// + rapunzel
  ///
  /// 0 LOAD_NAME                0 (rapunzel)
  /// 2 UNARY_POSITIVE
  /// 4 RETURN_VALUE
  func test_unary() {
    let operators: [(UnaryOpExpr.Operator, Instruction.Filled)] = [
      (.plus, .unaryPositive),
      (.minus, .unaryNegative),
      (.not, .unaryNot),
      (.invert, .unaryInvert)
    ]

    for (astOp, op) in operators {
      let right = self.identifierExpr(value: "rapunzel")
      let expr = self.unaryOpExpr(op: astOp, right: right)

      guard let code = self.compile(expr: expr) else {
        continue
      }

      XCTAssertCodeObject(
        code,
        name: "<module>",
        qualifiedName: "",
        kind: .module,
        flags: [],
        instructions: [
          .loadName(name: "rapunzel"),
          op,
          .return
        ]
      )
    }
  }

  /// +- rapunzel
  ///
  /// 0 LOAD_NAME                0 (rapunzel)
  /// 2 UNARY_NEGATIVE
  /// 4 UNARY_POSITIVE
  /// 6 RETURN_VALUE
  func test_unary_multiple() {
    let right = self.identifierExpr(value: "rapunzel")

    let expr = self.unaryOpExpr(
      op: .plus,
      right: self.unaryOpExpr(op: .minus, right: right)
    )

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
        .loadName(name: "rapunzel"),
        .unaryNegative,
        .unaryPositive,
        .return
      ]
    )
  }

  // MARK: - Binary

  /// rapunzel + cassandra
  /// (because cassandra > eugene)
  ///
  /// 0 LOAD_NAME                0 (rapunzel)
  /// 2 LOAD_NAME                1 (cassandra)
  /// 4 BINARY_ADD
  /// 6 RETURN_VALUE
  func test_binary() {
    let operators: [(BinaryOpExpr.Operator, Instruction.Filled)] = [
      (.add, .binaryAdd),
      (.sub, .binarySubtract),
      (.mul, .binaryMultiply),
      (.matMul, .binaryMatrixMultiply),
      (.div, .binaryTrueDivide),
      (.modulo, .binaryModulo),
      (.pow, .binaryPower),
      (.leftShift, .binaryLShift),
      (.rightShift, .binaryRShift),
      (.bitOr, .binaryOr),
      (.bitXor, .binaryXor),
      (.bitAnd, .binaryAnd),
      (.floorDiv, .binaryFloorDivide)
    ]

    for (astOp, op) in operators {
      let left = self.identifierExpr(value: "rapunzel")
      let right = self.identifierExpr(value: "cassandra")
      let expr = self.binaryOpExpr(op: astOp, left: left, right: right)

      guard let code = self.compile(expr: expr) else {
        continue
      }

      XCTAssertCodeObject(
        code,
        name: "<module>",
        qualifiedName: "",
        kind: .module,
        flags: [],
        instructions: [
          .loadName(name: "rapunzel"),
          .loadName(name: "cassandra"),
          op,
          .return
        ]
      )
    }
  }

  /// eugene + rapunzel - cassandra
  ///
  ///  0 LOAD_NAME                0 (eugene)
  ///  2 LOAD_NAME                1 (rapunzel)
  ///  4 BINARY_ADD
  ///  6 LOAD_NAME                2 (cassandra)
  ///  8 BINARY_SUBTRACT
  /// 10 RETURN_VALUE
  func test_binary_multiple() {
    let left = self.identifierExpr(value: "eugene")
    let middle = self.identifierExpr(value: "rapunzel")
    let right = self.identifierExpr(value: "cassandra")

    let add = self.binaryOpExpr(op: .add, left: left, right: middle)
    let expr = self.binaryOpExpr(op: .sub, left: add, right: right)

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
        .loadName(name: "eugene"),
        .loadName(name: "rapunzel"),
        .binaryAdd,
        .loadName(name: "cassandra"), // Spoiler!
        .binarySubtract,
        .return
      ]
    )
  }

  // MARK: - Boolean

  /// rapunzel and cassandra
  /// (because cassandra > eugene)
  ///
  /// 0 LOAD_NAME                0 (rapunzel)
  /// 2 JUMP_IF_FALSE_OR_POP     6
  /// 4 LOAD_NAME                1 (cassandra)
  /// 6 RETURN_VALUE
  func test_boolean_and() {
    let left = self.identifierExpr(value: "rapunzel")
    let right = self.identifierExpr(value: "cassandra")
    let expr = self.boolOpExpr(op: .and, left: left, right: right)

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
        .loadName(name: "rapunzel"),
        .jumpIfFalseOrPop(target: 6),
        .loadName(name: "cassandra"),
        .return
      ]
    )
  }

  /// rapunzel or cassandra
  /// (because cassandra > eugene)
  ///
  /// 0 LOAD_NAME                0 (rapunzel)
  /// 2 JUMP_IF_TRUE_OR_POP      6
  /// 4 LOAD_NAME                1 (cassandra)
  /// 6 RETURN_VALUE
  func test_boolean_or() {
    let left = self.identifierExpr(value: "rapunzel")
    let right = self.identifierExpr(value: "cassandra")
    let expr = self.boolOpExpr(op: .or, left: left, right: right)

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
        .loadName(name: "rapunzel"),
        .jumpIfTrueOrPop(target: 6),
        .loadName(name: "cassandra"),
        .return
      ]
    )
  }

  /// rapunzel and cassandra or eugene
  ///
  /// (This is CPython, we generate different code, but the result is similar)
  ///  0 LOAD_NAME                0 (rapunzel)
  ///  2 POP_JUMP_IF_FALSE        8
  ///  4 LOAD_NAME                1 (cassandra)
  ///  6 JUMP_IF_TRUE_OR_POP     10
  ///  8 LOAD_NAME                2 (eugene)
  /// 10 RETURN_VALUE
  func test_boolean_multiple() {
    let left = self.identifierExpr(value: "rapunzel")
    let middle = self.identifierExpr(value: "cassandra")
    let right = self.identifierExpr(value: "eugene")

    let and = self.boolOpExpr(op: .and, left: left, right: middle)
    let expr = self.boolOpExpr(op: .or, left: and, right: right)

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
        .loadName(name: "rapunzel"),
        .popJumpIfFalse(target: 8),
        .loadName(name: "cassandra"),
        .jumpIfTrueOrPop(target: 10),
        .loadName(name: "eugene"),
        .return
      ]
    )
  }

  // MARK: - Compare

  /// rapunzel < cassandra
  /// (because cassandra > eugene)
  ///
  /// 0 LOAD_NAME                0 (rapunzel)
  /// 2 LOAD_NAME                1 (cassandra)
  /// 4 COMPARE_OP               0 (<)
  /// 6 RETURN_VALUE
  func test_compare() {
    let operators: [(CompareExpr.Operator, Instruction.CompareType)] = [
      (.equal, .equal),
      (.notEqual, .notEqual),
      (.less, .less),
      (.lessEqual, .lessEqual),
      (.greater, .greater),
      (.greaterEqual, .greaterEqual),
      (.is, .is),
      (.isNot, .isNot),
      (.in, .in),
      (.notIn, .notIn)
    ]

    for (astOp, compareType) in operators {
      let left = self.identifierExpr(value: "rapunzel")
      let right = self.identifierExpr(value: "cassandra")

      let expr = self.compareExpr(
        left: left,
        elements: [CompareExpr.Element(op: astOp, right: right)]
      )

      guard let code = self.compile(expr: expr) else {
        continue
      }

      XCTAssertCodeObject(
        code,
        name: "<module>",
        qualifiedName: "",
        kind: .module,
        flags: [],
        instructions: [
          .loadName(name: "rapunzel"),
          .loadName(name: "cassandra"),
          .compareOp(type: compareType),
          .return
        ]
      )
    }
  }

  /// eugene < rapunzel < cassandra
  ///
  ///  0 LOAD_NAME                0 (eugene)
  ///  2 LOAD_NAME                1 (rapunzel)
  ///  4 DUP_TOP
  ///  6 ROT_THREE
  ///  8 COMPARE_OP               0 (<)
  /// 10 JUMP_IF_FALSE_OR_POP    18
  /// 12 LOAD_NAME                2 (cassandra)
  /// 14 COMPARE_OP               0 (<)
  /// 16 RETURN_VALUE
  /// 18 ROT_TWO
  /// 20 POP_TOP
  /// 22 RETURN_VALUE
  func test_compare_triple() {
    let left = self.identifierExpr(value: "eugene")
    let middle = self.identifierExpr(value: "rapunzel")
    let right = self.identifierExpr(value: "cassandra")

    let expr = self.compareExpr(
      left: left,
      elements: [
        CompareExpr.Element(op: .less, right: middle),
        CompareExpr.Element(op: .less, right: right)
      ]
    )

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
        .loadName(name: "eugene"),
        .loadName(name: "rapunzel"),
        .dupTop,
        .rotThree,
        .compareOp(type: .less),
        .jumpIfFalseOrPop(target: 18),
        .loadName(name: "cassandra"),
        .compareOp(type: .less),
        .return,
        .rotTwo,
        .popTop,
        .return
      ]
    )
  }

  /// eugene < pascal < rapunzel < cassandra
  ///
  ///  0 LOAD_NAME                0 (eugene)
  ///  2 LOAD_NAME                1 (pascal)
  ///  4 DUP_TOP
  ///  6 ROT_THREE
  ///  8 COMPARE_OP               0 (<)
  /// 10 JUMP_IF_FALSE_OR_POP    28
  /// 12 LOAD_NAME                2 (rapunzel)
  /// 14 DUP_TOP
  /// 16 ROT_THREE
  /// 18 COMPARE_OP               0 (<)
  /// 20 JUMP_IF_FALSE_OR_POP    28
  /// 22 LOAD_NAME                3 (cassandra)
  /// 24 COMPARE_OP               0 (<)
  /// 26 RETURN_VALUE
  /// 28 ROT_TWO
  /// 30 POP_TOP
  /// 32 RETURN_VALUE
  func test_compare_quad() {
    let element1 = self.identifierExpr(value: "eugene")
    let element2 = self.identifierExpr(value: "pascal")
    let element3 = self.identifierExpr(value: "rapunzel")
    let element4 = self.identifierExpr(value: "cassandra")

    let expr = self.compareExpr(
      left: element1,
      elements: [
        CompareExpr.Element(op: .less, right: element2),
        CompareExpr.Element(op: .less, right: element3),
        CompareExpr.Element(op: .less, right: element4)
      ]
    )

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
        .loadName(name: "eugene"),
        .loadName(name: "pascal"),
        .dupTop,
        .rotThree,
        .compareOp(type: .less),
        .jumpIfFalseOrPop(target: 28),
        .loadName(name: "rapunzel"),
        .dupTop,
        .rotThree,
        .compareOp(type: .less),
        .jumpIfFalseOrPop(target: 28),
        .loadName(name: "cassandra"),
        .compareOp(type: .less),
        .return,
        .rotTwo,
        .popTop,
        .return
      ]
    )
  }

  /// 1 < 2
  ///
  /// 0 LOAD_CONST               0 (1)
  /// 2 LOAD_CONST               1 (2)
  /// 4 COMPARE_OP               0 (<)
  /// 6 RETURN_VALUE
  func test_compare_const() {
    let left = self.intExpr(value: 1)
    let right = self.intExpr(value: 2)

    let expr = self.compareExpr(
      left: left,
      elements: [
        CompareExpr.Element(op: .less, right: right)
      ]
    )

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
        .loadConst(integer: 1),
        .loadConst(integer: 2),
        .compareOp(type: .less),
        .return
      ]
    )
  }
}
