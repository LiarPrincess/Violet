import XCTest
import Core
import Parser
import Bytecode
@testable import Compiler

/// Use './Scripts/dump' for reference.
class CompileRaise: CompileTestCase {

  /// raise
  ///
  /// 0 RAISE_VARARGS            0
  /// 2 LOAD_CONST               0 (None)
  /// 4 RETURN_VALUE
  func test_reRaise() {
    let stmt = self.raiseStmt(
      exception: nil,
      cause: nil
    )

    let expected: [EmittedInstruction] = [
      .init(.raiseVarargs, "reRaise"),
      .init(.loadConst, "none"),
      .init(.return)
    ]

    if let code = self.compile(stmt: stmt) {
      XCTAssertCode(code, name: "<module>", qualified: "", type: .module)
      XCTAssertInstructions(code, expected)
    }
  }

  /// raise Hades
  ///
  /// 0 LOAD_NAME                0 (Hades)
  /// 2 RAISE_VARARGS            1
  /// 4 LOAD_CONST               0 (None)
  /// 6 RETURN_VALUE
  func test_raise_exception() {
    let stmt = self.raiseStmt(
      exception: self.identifierExpr(value: "Hades"),
      cause: nil
    )

    let expected: [EmittedInstruction] = [
      .init(.loadName, "Hades"),
      .init(.raiseVarargs, "exception"),
      .init(.loadConst, "none"),
      .init(.return)
    ]

    if let code = self.compile(stmt: stmt) {
      XCTAssertCode(code, name: "<module>", qualified: "", type: .module)
      XCTAssertInstructions(code, expected)
    }
  }

  /// raise Hercules from Olympus
  ///
  /// 0 LOAD_NAME                0 (Hercules)
  /// 2 LOAD_NAME                1 (Olympus)
  /// 4 RAISE_VARARGS            2
  /// 6 LOAD_CONST               0 (None)
  /// 8 RETURN_VALUE
  func test_raise_exception_from() {
    let stmt = self.raiseStmt(
      exception: self.identifierExpr(value: "Hercules"),
      cause: self.identifierExpr(value: "Olympus")
    )

    let expected: [EmittedInstruction] = [
      .init(.loadName, "Hercules"),
      .init(.loadName, "Olympus"),
      .init(.raiseVarargs, "exception, cause"),
      .init(.loadConst, "none"),
      .init(.return)
    ]

    if let code = self.compile(stmt: stmt) {
      XCTAssertCode(code, name: "<module>", qualified: "", type: .module)
      XCTAssertInstructions(code, expected)
    }
  }
}
