import XCTest
import VioletCore
import VioletParser
import VioletBytecode
@testable import VioletCompiler

/// Use './Scripts/dump' for reference.
class CompileAssert: CompileTestCase {

  /// assert pooh
  ///
  ///  0 LOAD_NAME                0 (pooh)
  ///  2 POP_JUMP_IF_TRUE         8
  ///  4 LOAD_GLOBAL              1 (AssertionError)
  ///  6 RAISE_VARARGS            1
  ///  8 LOAD_CONST               0 (None)
  /// 10 RETURN_VALUE
  func test_simple() {
    let stmt = self.assertStmt(
      test: self.identifierExpr(value: "pooh"),
      msg: nil
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
        .loadName(name: "pooh"),
        .popJumpIfTrue(target: 8),
        .loadGlobal(name: "AssertionError"),
        .raiseVarargs(type: .exceptionOnly),
        .loadConst(.none),
        .return
      ]
    )
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
    let stmt = self.assertStmt(
      test: self.identifierExpr(value: "pooh"),
      msg: self.stringExpr(value: .literal("Stuck at Rabbits Howse"))
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
        .loadName(name: "pooh"),
        .popJumpIfTrue(target: 12),
        .loadGlobal(name: "AssertionError"),
        .loadConst(string: "Stuck at Rabbits Howse"),
        .callFunction(argumentCount: 1),
        .raiseVarargs(type: .exceptionOnly),
        .loadConst(.none),
        .return
      ]
    )
  }

  /// assert pooh
  ///
  ///  0 LOAD_NAME                0 (pooh)
  ///  2 POP_JUMP_IF_TRUE         8
  ///  4 LOAD_GLOBAL              1 (AssertionError)
  ///  6 RAISE_VARARGS            1
  ///  8 LOAD_CONST               0 (None)
  /// 10 RETURN_VALUE
  func test_withOptimization_emitsNothing() {
    let stmt = self.assertStmt(
      test: self.identifierExpr(value: "pooh"),
      msg: nil
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
        .loadName(name: "pooh"),
        .popJumpIfTrue(target: 8),
        .loadGlobal(name: "AssertionError"),
        .raiseVarargs(type: .exceptionOnly),
        .loadConst(.none),
        .return
      ]
    )
  }
}
