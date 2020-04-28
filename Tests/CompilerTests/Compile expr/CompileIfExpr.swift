import XCTest
import VioletCore
import VioletParser
import VioletBytecode
@testable import VioletCompiler

/// Use 'Scripts/dump_dis.py' for reference.
class CompileIfExpr: CompileTestCase {

  /// 'genie' if 'touched' else 'lamp'
  /// additional_block <-- so that we don't get returns at the end
  ///
  /// Note that currently we do not have fast path for constants,
  /// so our bytecode will be different.
  ///
  ///  0 LOAD_CONST               0 (touched)
  ///  2 POP_JUMP_IF_FALSE        8
  ///  4 LOAD_CONST               1 (genie)
  ///  6 JUMP_FORWARD             2 (to 10)
  ///  8 LOAD_CONST               2 (lamp)
  /// 10 POP_TOP <-- unused result
  ///
  /// 12 LOAD_NAME                3 (additional_block)
  /// 14 POP_TOP
  /// 16 LOAD_CONST               0 (None)
  /// 18 RETURN_VALUE
  func test_constants() {
    let expr = self.ifExpr(
      test: self.stringExpr(value: .literal("touched")),
      body: self.stringExpr(value: .literal("genie")),
      orElse: self.stringExpr(value: .literal("lamp"))
    )

    let expected: [EmittedInstruction] = [
      .init(.loadConst, "'touched'"),
      .init(.popJumpIfFalse, "8"),
      .init(.loadConst, "'genie'"),
      .init(.jumpAbsolute, "10"),
      .init(.loadConst, "'lamp'"),
      .init(.return)
    ]

    if let code = self.compile(expr: expr) {
      XCTAssertCode(code, name: "<module>", qualified: "", kind: .module)
      XCTAssertInstructions(code, expected)
    }
  }

  /// genie if touched else lamp
  /// additional_block <-- so that we don't get returns at the end
  ///
  ///  0 LOAD_NAME                0 (touched)
  ///  2 POP_JUMP_IF_FALSE        8
  ///  4 LOAD_NAME                1 (genie)
  ///  6 JUMP_FORWARD             2 (to 10)
  ///  8 LOAD_NAME                2 (lamp)
  /// 10 POP_TOP
  ///
  /// 12 LOAD_NAME                3 (additional_block)
  /// 14 POP_TOP
  /// 16 LOAD_CONST               0 (None)
  /// 18 RETURN_VALUE
  func test_withIdentifier() {
    let expr = self.ifExpr(
      test: self.identifierExpr(value: "touched"),
      body: self.identifierExpr(value: "genie"),
      orElse: self.identifierExpr(value: "lamp")
    )

    let expected: [EmittedInstruction] = [
      .init(.loadName, "touched"),
      .init(.popJumpIfFalse, "8"),
      .init(.loadName, "genie"),
      .init(.jumpAbsolute, "10"),
      .init(.loadName, "lamp"),
      .init(.return)
    ]

    if let code = self.compile(expr: expr) {
      XCTAssertCode(code, name: "<module>", qualified: "", kind: .module)
      XCTAssertInstructions(code, expected)
    }
  }

  /// aladdin if jasmine else (ali if prince else thief)
  ///
  ///  0 LOAD_NAME                0 (jasmine)
  ///  2 POP_JUMP_IF_FALSE        8
  ///  4 LOAD_NAME                1 (aladdin)
  ///  6 JUMP_FORWARD            10 (to 18)
  ///  8 LOAD_NAME                2 (prince)
  /// 10 POP_JUMP_IF_FALSE       16
  /// 12 LOAD_NAME                3 (ali)
  /// 14 JUMP_FORWARD             2 (to 18)
  /// 16 LOAD_NAME                4 (thief)
  /// 18 POP_TOP
  ///
  /// 20 LOAD_NAME                5 (additional_block)
  /// 22 POP_TOP
  /// 24 LOAD_CONST               0 (None)
  /// 26 RETURN_VALUE
  func test_nested() {
    let expr = self.ifExpr(
      test: self.identifierExpr(value: "jasmine"),
      body: self.identifierExpr(value: "aladdin"),
      orElse: self.ifExpr(
        test: self.identifierExpr(value: "prince"),
        body: self.identifierExpr(value: "ali"),
        orElse: self.identifierExpr(value: "thief")
      )
    )

    let expected: [EmittedInstruction] = [
      .init(.loadName, "jasmine"),
      .init(.popJumpIfFalse, "8"),
      .init(.loadName, "aladdin"),
      .init(.jumpAbsolute, "18"),
      .init(.loadName, "prince"),
      .init(.popJumpIfFalse, "16"),
      .init(.loadName, "ali"),
      .init(.jumpAbsolute, "18"),
      .init(.loadName, "thief"),
      .init(.return)
    ]

    if let code = self.compile(expr: expr) {
      XCTAssertCode(code, name: "<module>", qualified: "", kind: .module)
      XCTAssertInstructions(code, expected)
    }
  }
}
