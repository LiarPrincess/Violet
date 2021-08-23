import XCTest
import VioletCore
import VioletParser
import VioletBytecode
@testable import VioletCompiler

// swiftlint:disable function_body_length
// swiftlint:disable file_length

/// Use './Scripts/dump' for reference.
class CompileIfStmt: CompileTestCase {

  // MARK: - If

  /// if eat_me: big
  ///
  ///  0 LOAD_NAME                0 (eat_me)
  ///  2 POP_JUMP_IF_FALSE        8
  ///
  ///  4 LOAD_NAME                1 (big)
  ///  6 POP_TOP
  ///  8 LOAD_CONST               0 (None)
  /// 10 RETURN_VALUE
  func test_if() {
    let stmt = self.ifStmt(
      test: self.identifierExpr(value: "eat_me"),
      body: [
        self.identifierStmt(value: "big")
      ],
      orElse: []
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
        .loadName(name: "eat_me"),
        .popJumpIfFalse(target: 8),
        .loadName(name: "big"),
        .popTop,
        .loadConst(.none),
        .return
      ]
    )
  }

  // MARK: - Unary

  /// if not eat_me:
  ///     big
  ///
  ///  0 LOAD_NAME                0 (eat_me)
  ///  2 POP_JUMP_IF_TRUE         8
  ///  4 LOAD_NAME                1 (big)
  ///  6 POP_TOP
  ///  8 LOAD_CONST               0 (None)
  /// 10 RETURN_VALUE
  func test_if_unaryNot() {
    let stmt = self.ifStmt(
      test: self.unaryOpExpr(
        op: .not,
        right: self.identifierExpr(value: "eat_me")
      ),
      body: [
        self.identifierStmt(value: "big")
      ],
      orElse: []
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
        .loadName(name: "eat_me"), // 0
        .popJumpIfTrue(target: 8), // 2
        .loadName(name: "big"), // 4
        .popTop, // 6
        .loadConst(.none), // 8
        .return // 10
      ]
    )
  }

  // MARK: - Binary

  /// if eat_me and drink_me:
  ///     big
  ///
  ///  0 LOAD_NAME                0 (eat_me)
  ///  2 POP_JUMP_IF_FALSE       12
  ///  4 LOAD_NAME                1 (drink_me)
  ///  6 POP_JUMP_IF_FALSE       12
  ///  8 LOAD_NAME                2 (big)
  /// 10 POP_TOP
  /// 12 LOAD_CONST               0 (None)
  /// 14 RETURN_VALUE
  func test_if_binaryAnd() {
    let stmt = self.ifStmt(
      test: self.boolOpExpr(
        op: .and,
        left: self.identifierExpr(value: "eat_me"),
        right: self.identifierExpr(value: "drink_me")
      ),
      body: [
        self.identifierStmt(value: "big")
      ],
      orElse: []
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
        .loadName(name: "eat_me"),
        .popJumpIfFalse(target: 12),
        .loadName(name: "drink_me"),
        .popJumpIfFalse(target: 12),
        .loadName(name: "big"),
        .popTop,
        .loadConst(.none),
        .return
      ]
    )
  }

  /// if eat_me or drink_me:
  ///     big
  ///
  ///  0 LOAD_NAME                0 (eat_me)
  ///  2 POP_JUMP_IF_TRUE         8
  ///  4 LOAD_NAME                1 (drink_me)
  ///  6 POP_JUMP_IF_FALSE       12
  ///  8 LOAD_NAME                2 (big)
  /// 10 POP_TOP
  /// 12 LOAD_CONST               0 (None)
  /// 14 RETURN_VALUE
  func test_if_binaryOr() {
    let stmt = self.ifStmt(
      test: self.boolOpExpr(
        op: .or,
        left: self.identifierExpr(value: "eat_me"),
        right: self.identifierExpr(value: "drink_me")
      ),
      body: [
        self.identifierStmt(value: "big")
      ],
      orElse: []
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
        .loadName(name: "eat_me"),
        .popJumpIfTrue(target: 8),
        .loadName(name: "drink_me"),
        .popJumpIfFalse(target: 12),
        .loadName(name: "big"),
        .popTop,
        .loadConst(.none),
        .return
      ]
    )
  }

  // MARK: - IfExpr

  /// if eat_me if cake else drink_me:
  ///     big
  ///
  ///  0 LOAD_NAME                0 (cake)
  ///  2 POP_JUMP_IF_FALSE       10
  ///  4 LOAD_NAME                1 (eat_me)
  ///  6 POP_JUMP_IF_FALSE       18
  ///  8 JUMP_FORWARD             4 (to 14)
  /// 10 LOAD_NAME                2 (drink_me)
  /// 12 POP_JUMP_IF_FALSE       18
  /// 14 LOAD_NAME                3 (big)
  /// 16 POP_TOP
  /// 18 LOAD_CONST               0 (None)
  /// 20 RETURN_VALUE
  func test_if_ifExpr() {
    let stmt = self.ifStmt(
      test: self.ifExpr(
        test: self.identifierExpr(value: "cake"),
        body: self.identifierExpr(value: "eat_me"),
        orElse: self.identifierExpr(value: "drink_me")
      ),
      body: [
        self.identifierStmt(value: "big")
      ],
      orElse: []
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
        .loadName(name: "cake"), // 0
        .popJumpIfFalse(target: 10), // 2
        .loadName(name: "eat_me"), // 4
        .popJumpIfFalse(target: 18), // 6
        .jumpAbsolute(target: 14), // 8
        .loadName(name: "drink_me"), // 10
        .popJumpIfFalse(target: 18), // 12
        .loadName(name: "big"), // 14
        .popTop, // 16
        .loadConst(.none), // 18
        .return // 20
      ]
    )
  }

  // MARK: - CompareExpr

  /// if smol_alice < big_alice:
  ///     cake
  ///
  ///  0 LOAD_NAME                0 (smol_alice)
  ///  2 LOAD_NAME                1 (big_alice)
  ///  4 COMPARE_OP               0 (<)
  ///  6 POP_JUMP_IF_FALSE       12
  ///  8 LOAD_NAME                2 (cake)
  /// 10 POP_TOP
  /// 12 LOAD_CONST               0 (None)
  /// 14 RETURN_VALUE
  func test_if_compare_single() {
    let stmt = self.ifStmt(
      test: self.compareExpr(
        left: self.identifierExpr(value: "smol_alice"),
        elements: [
          CompareExpr.Element(
            op: .less,
            right: self.identifierExpr(value: "big_alice")
          )
        ]
      ),
      body: [
        self.identifierStmt(value: "cake")
      ],
      orElse: []
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
        .loadName(name: "smol_alice"),
        .loadName(name: "big_alice"),
        .compareOp(type: .less),
        .popJumpIfFalse(target: 12),
        .loadName(name: "cake"),
        .popTop,
        .loadConst(.none),
        .return
      ]
    )
  }

  /// if smol_alice < alice <= big_alice:
  ///     cake
  ///
  ///  0 LOAD_NAME                0 (smol_alice)
  ///  2 LOAD_NAME                1 (alice)
  ///  4 DUP_TOP
  ///  6 ROT_THREE
  ///  8 COMPARE_OP               0 (<)
  /// 10 POP_JUMP_IF_FALSE       20
  /// 12 LOAD_NAME                2 (big_alice)
  /// 14 COMPARE_OP               1 (<=)
  /// 16 POP_JUMP_IF_FALSE       28
  /// 18 JUMP_FORWARD             4 (to 24)
  /// 20 POP_TOP
  /// 22 JUMP_FORWARD             4 (to 28)
  /// 24 LOAD_NAME                3 (cake)
  /// 26 POP_TOP
  /// 28 LOAD_CONST               0 (None)
  /// 30 RETURN_VALUE
  func test_if_compare_multiple() {
    let stmt = self.ifStmt(
      test: self.compareExpr(
        left: self.identifierExpr(value: "smol_alice"),
        elements: [
          CompareExpr.Element(
            op: .less,
            right: self.identifierExpr(value: "alice")
          ),
          CompareExpr.Element(
            op: .lessEqual,
            right: self.identifierExpr(value: "big_alice")
          )
        ]
      ),
      body: [
        self.identifierStmt(value: "cake")
      ],
      orElse: []
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
        .loadName(name: "smol_alice"), // 0
        .loadName(name: "alice"), // 2
        .dupTop, // 4
        .rotThree, // 6
        .compareOp(type: .less), // 8
        .popJumpIfFalse(target: 20), // 10
        .loadName(name: "big_alice"), // 12
        .compareOp(type: .lessEqual), // 14
        .popJumpIfFalse(target: 28), // 16
        .jumpAbsolute(target: 24), // 18
        .popTop, // 20
        .jumpAbsolute(target: 28), // 22
        .loadName(name: "cake"), // 24
        .popTop, // 26
        .loadConst(.none), // 28
        .return // 30
      ]
    )
  }

  // MARK: - If/else

  /// if eat_me: big
  /// else: smol
  ///
  ///  0 LOAD_NAME                0 (eat_me)
  ///  2 POP_JUMP_IF_FALSE       10
  ///
  ///  4 LOAD_NAME                1 (big)
  ///  6 POP_TOP
  ///  8 JUMP_FORWARD             4 (to 14)
  ///
  /// 10 LOAD_NAME                2 (smol)
  /// 12 POP_TOP
  /// 14 LOAD_CONST               0 (None)
  /// 16 RETURN_VALUE
  func test_if_withElse() {
    let stmt = self.ifStmt(
      test: self.identifierExpr(value: "eat_me"),
      body: [
        self.identifierStmt(value: "big")
      ],
      orElse: [
        self.identifierStmt(value: "smol")
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
        .loadName(name: "eat_me"),
        .popJumpIfFalse(target: 10),
        .loadName(name: "big"),
        .popTop,
        .jumpAbsolute(target: 14),
        .loadName(name: "smol"),
        .popTop,
        .loadConst(.none),
        .return
      ]
    )
  }

  /// if eat_me: big
  /// elif drink_me: smol
  /// else: alice
  ///
  ///  0 LOAD_NAME                0 (eat_me)
  ///  2 POP_JUMP_IF_FALSE       10
  ///  4 LOAD_NAME                1 (big)
  ///  6 POP_TOP
  ///  8 JUMP_FORWARD            14 (to 24)
  ///
  /// 10 LOAD_NAME                2 (drink_me)
  /// 12 POP_JUMP_IF_FALSE       20
  /// 14 LOAD_NAME                3 (smol)
  /// 16 POP_TOP
  ///  18 JUMP_FORWARD             4 (to 24)
  ///
  /// 20 LOAD_NAME                4 (alice)
  /// 22 POP_TOP
  /// 24 LOAD_CONST               0 (None)
  /// 26 RETURN_VALUE
  func test_multiple() {
    let stmt = self.ifStmt(
      test: self.identifierExpr(value: "eat_me"),
      body: [
        self.identifierStmt(value: "big")
      ],
      orElse: [
        self.ifStmt(
          test: self.identifierExpr(value: "drink_me"),
          body: [
            self.identifierStmt(value: "smol")
          ],
          orElse: [
            self.identifierStmt(value: "alice")
          ]
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
        .loadName(name: "eat_me"),
        .popJumpIfFalse(target: 10),
        .loadName(name: "big"),
        .popTop,
        .jumpAbsolute(target: 24),
        .loadName(name: "drink_me"),
        .popJumpIfFalse(target: 20),
        .loadName(name: "smol"),
        .popTop,
        .jumpAbsolute(target: 24),
        .loadName(name: "alice"),
        .popTop,
        .loadConst(.none),
        .return
      ]
    )
  }

  // MARK: - Constants

  /// if True: big
  /// else: smol
  ///
  /// But we don't have dead code elimination, so it will be different
  ///
  ///   3           0 LOAD_NAME                0 (big)
  ///               2 POP_TOP
  ///               4 LOAD_CONST               0 (None)
  ///               6 RETURN_VALUE
  func test_true() {
    let stmt = self.ifStmt(
      test: self.trueExpr(),
      body: [
        self.identifierStmt(value: "big")
      ],
      orElse: [
        self.identifierStmt(value: "smol")
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
        .loadName(name: "big"), // 0
        .popTop, // 2
        .jumpAbsolute(target: 10), // 4
        .loadName(name: "smol"), // 6
        .popTop, // 8
        .loadConst(.none), // 10
        .return // 12
      ]
    )
  }

  /// if False: big
  /// else: smol
  /// But we don't have dead code elimination, so it will be different
  ///
  ///   5           0 LOAD_NAME                0 (smol)
  ///               2 POP_TOP
  ///               4 LOAD_CONST               0 (None)
  ///               6 RETURN_VALUE
  func test_false() {
    let stmt = self.ifStmt(
      test: self.falseExpr(),
      body: [
        self.identifierStmt(value: "big")
      ],
      orElse: [
        self.identifierStmt(value: "smol")
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
        .loadConst(.false),
        .popJumpIfFalse(target: 10),
        .loadName(name: "big"),
        .popTop,
        .jumpAbsolute(target: 14),
        .loadName(name: "smol"),
        .popTop,
        .loadConst(.none),
        .return
      ]
    )
  }
}
