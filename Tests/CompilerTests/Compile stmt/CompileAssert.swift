import XCTest
import Core
import Parser
import Bytecode
@testable import Compiler

/// Use 'Scripts/dump_dis.py' for reference.
class CompileAssert: XCTestCase, CommonCompiler {

  /// assert pooh
  ///
  ///  0 LOAD_NAME                0 (pooh)
  ///  2 POP_JUMP_IF_TRUE         8
  ///  4 LOAD_GLOBAL              1 (AssertionError)
  ///  6 RAISE_VARARGS            1
  ///  8 LOAD_CONST               0 (None)
  /// 10 RETURN_VALUE
  func test_simple() {
    let stmt = self.statement(.assert(
      test: self.identifierExpr("pooh"),
      msg: nil
    ))

    let expected: [EmittedInstruction] = [
      .init(.loadName, "pooh"),
      .init(.popJumpIfTrue, "8"),
      .init(.loadGlobal, "AssertionError"),
      .init(.raiseVarargs, "exception"),
      .init(.loadConst, "none"),
      .init(.return)
    ]

    if let code = self.compile(stmt: stmt) {
      XCTAssertCode(code, name: "<module>", qualified: "", type: .module)
      XCTAssertInstructions(code, expected)
    }
  }

  /// assert pooh, 'Stuck at Rabbits Howse'
  ///
  ///  0 LOAD_NAME                0 (pooh)
  ///  2 POP_JUMP_IF_TRUE        12
  ///  4 LOAD_GLOBAL              1 (AssertionError)
  ///  6 LOAD_CONST               0 ('Stuck at Rabbits Howse')
  ///  8 CALL_FUNCTION            1
  /// 10 RAISE_VARARGS            1
  /// 12 LOAD_CONST               1 (None)
  /// 14 RETURN_VALUE
  func test_withMessage() {
    let stmt = self.statement(.assert(
      test: self.identifierExpr("pooh"),
      msg:  self.expression(.string(.literal("Stuck at Rabbits Howse")))
    ))

    let expected: [EmittedInstruction] = [
      .init(.loadName, "pooh"),
      .init(.popJumpIfTrue, "12"),
      .init(.loadGlobal, "AssertionError"),
      .init(.loadConst, "'Stuck at Rabbits Howse'"),
      .init(.callFunction, "1"),
      .init(.raiseVarargs, "exception"),
      .init(.loadConst, "none"),
      .init(.return)
    ]

    if let code = self.compile(stmt: stmt) {
      XCTAssertCode(code, name: "<module>", qualified: "", type: .module)
      XCTAssertInstructions(code, expected)
    }
  }

  /// assert pooh
  func test_withOptimization_emitsNothing() {
    let stmt = self.statement(.assert(
      test: self.identifierExpr("pooh"),
      msg:  nil
    ))

    let expected: [EmittedInstruction] = [
      .init(.loadConst, "none"),
      .init(.return)
    ]

    if let code = self.compile(stmt: stmt, optimizationLevel: 1) {
      XCTAssertCode(code, name: "<module>", qualified: "", type: .module)
      XCTAssertInstructions(code, expected)
    }
  }
}
