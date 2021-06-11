import XCTest
import VioletCore
import VioletParser
import VioletBytecode
@testable import VioletCompiler

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
        .raiseVarargs(type: .reRaise),
        .loadConst(.none),
        .return
      ]
    )
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
        .loadName(name: "Hades"),
        .raiseVarargs(type: .exceptionOnly),
        .loadConst(.none),
        .return
      ]
    )
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
        .loadName(name: "Hercules"),
        .loadName(name: "Olympus"),
        .raiseVarargs(type: .exceptionAndCause),
        .loadConst(.none),
        .return
      ]
    )
  }
}
