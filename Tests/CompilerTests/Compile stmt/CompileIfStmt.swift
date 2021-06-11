import XCTest
import VioletCore
import VioletParser
import VioletBytecode
@testable import VioletCompiler

// swiftlint:disable function_body_length

/// Use './Scripts/dump' for reference.
class CompileIfStmt: CompileTestCase {

  /// if eat_me: big
  ///
  ///  0 LOAD_NAME                0 (eat_me)
  ///  2 POP_JUMP_IF_FALSE        8
  ///
  ///  4 LOAD_NAME                1 (big)
  ///  6 POP_TOP
  ///  8 LOAD_CONST               0 (None)
  /// 10 RETURN_VALUE
  func test_onlyTrue() {
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
  func test_withElse() {
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
        .loadConst(.true),
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
