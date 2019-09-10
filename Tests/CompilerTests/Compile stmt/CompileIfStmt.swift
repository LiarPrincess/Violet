import XCTest
import Core
import Parser
import Bytecode
@testable import Compiler

/// Use 'Scripts/dump_dis.py' for reference.
class CompileIfStmt: XCTestCase, CommonCompiler {

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
    let stmt = self.statement(.if(
      test: self.expression(.identifier("eat_me")),
      body: NonEmptyArray(first:
        self.statement(expr: .identifier("big"))
      ),
      orElse: []
    ))

    let expected: [EmittedInstruction] = [
      .init(.loadName, "eat_me"),
      .init(.popJumpIfFalse, "8"),
      .init(.loadName, "big"),
      .init(.popTop),
      .init(.loadConst, "none"),
      .init(.return)
    ]

    if let code = self.compile(stmt: stmt) {
      XCTAssertCode(code, name: "<module>", qualified: "", type: .module)
      XCTAssertInstructions(code, expected)
    }
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
    let stmt = self.statement(.if(
      test: self.expression(.identifier("eat_me")),
      body: NonEmptyArray(first:
        self.statement(expr: .identifier("big"))
      ),
      orElse: [
        self.statement(expr: .identifier("smol"))
      ]
    ))

    let expected: [EmittedInstruction] = [
      .init(.loadName, "eat_me"),
      .init(.popJumpIfFalse, "10"),
      .init(.loadName, "big"),
      .init(.popTop),
      .init(.jumpAbsolute, "14"),
      .init(.loadName, "smol"),
      .init(.popTop),
      .init(.loadConst, "none"),
      .init(.return)
    ]

    if let code = self.compile(stmt: stmt) {
      XCTAssertCode(code, name: "<module>", qualified: "", type: .module)
      XCTAssertInstructions(code, expected)
    }
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
    // swiftlint:disable:previous function_body_length

    let stmt = self.statement(.if(
      test: self.expression(.identifier("eat_me")),
      body: NonEmptyArray(first:
        self.statement(expr: .identifier("big"))
      ),
      orElse: [
        self.statement(.if(
          test: self.expression(.identifier("drink_me")),
          body: NonEmptyArray(first:
            self.statement(expr: .identifier("smol"))
          ),
          orElse: [
            self.statement(expr: .identifier("alice"))
          ]
        ))
      ]
    ))

    let expected: [EmittedInstruction] = [
      .init(.loadName, "eat_me"),
      .init(.popJumpIfFalse, "10"),
      .init(.loadName, "big"),
      .init(.popTop),
      .init(.jumpAbsolute, "24"),
      .init(.loadName, "drink_me"),
      .init(.popJumpIfFalse, "20"),
      .init(.loadName, "smol"),
      .init(.popTop),
      .init(.jumpAbsolute, "24"),
      .init(.loadName, "alice"),
      .init(.popTop),
      .init(.loadConst, "none"),
      .init(.return)
    ]

    if let code = self.compile(stmt: stmt) {
      XCTAssertCode(code, name: "<module>", qualified: "", type: .module)
      XCTAssertInstructions(code, expected)
    }
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
    let stmt = self.statement(.if(
      test: self.expression(.true),
      body: NonEmptyArray(first:
        self.statement(expr: .identifier("big"))
      ),
      orElse: [
        self.statement(expr: .identifier("smol"))
      ]
    ))

    let expected: [EmittedInstruction] = [
      .init(.loadConst, "true"),
      .init(.popJumpIfFalse, "10"),
      .init(.loadName, "big"),
      .init(.popTop),
      .init(.jumpAbsolute, "14"),
      .init(.loadName, "smol"),
      .init(.popTop),
      .init(.loadConst, "none"),
      .init(.return)
    ]

    if let code = self.compile(stmt: stmt) {
      XCTAssertCode(code, name: "<module>", qualified: "", type: .module)
      XCTAssertInstructions(code, expected)
    }
  }

  /// if False: big
  /// else: smol
  /// But we dont have dead code elimination, so it will be different
  ///
  ///   5           0 LOAD_NAME                0 (smol)
  ///               2 POP_TOP
  ///               4 LOAD_CONST               0 (None)
  ///               6 RETURN_VALUE
  func test_false() {
    let stmt = self.statement(.if(
      test: self.expression(.false),
      body: NonEmptyArray(first:
        self.statement(expr: .identifier("big"))
      ),
      orElse: [
        self.statement(expr: .identifier("smol"))
      ]
    ))

    let expected: [EmittedInstruction] = [
      .init(.loadConst, "false"),
      .init(.popJumpIfFalse, "10"),
      .init(.loadName, "big"),
      .init(.popTop),
      .init(.jumpAbsolute, "14"),
      .init(.loadName, "smol"),
      .init(.popTop),
      .init(.loadConst, "none"),
      .init(.return)
    ]

    if let code = self.compile(stmt: stmt) {
      XCTAssertCode(code, name: "<module>", qualified: "", type: .module)
      XCTAssertInstructions(code, expected)
    }
  }
}
