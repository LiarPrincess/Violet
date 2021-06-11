import XCTest
import VioletCore
import VioletParser
import VioletBytecode
@testable import VioletCompiler

/// Use './Scripts/dump' for reference.
class CompileWhile: CompileTestCase {

  /// while frollo: quasimodo
  ///
  ///  0 SETUP_LOOP              12 (to 14)
  ///  2 LOAD_NAME                0 (frollo)
  ///  4 POP_JUMP_IF_FALSE       12
  ///  6 LOAD_NAME                1 (quasimodo)
  ///  8 POP_TOP
  /// 10 JUMP_ABSOLUTE            2
  /// 12 POP_BLOCK
  /// 14 LOAD_CONST               0 (None)
  /// 16 RETURN_VALUE
  func test_simple() {
    let stmt = self.whileStmt(
      test: self.identifierExpr(value: "frollo"),
      body: [self.identifierStmt(value: "quasimodo")],
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
        .setupLoop(loopEndTarget: 14),
        .loadName(name: "frollo"),
        .popJumpIfFalse(target: 12),
        .loadName(name: "quasimodo"),
        .popTop,
        .jumpAbsolute(target: 2),
        .popBlock,
        .loadConst(.none),
        .return
      ]
    )
  }

  /// while frollo: quasimodo
  /// else: esmeralda
  ///
  ///  0 SETUP_LOOP              16 (to 18)
  ///  2 LOAD_NAME                0 (frollo)
  ///  4 POP_JUMP_IF_FALSE       12
  ///  6 LOAD_NAME                1 (quasimodo)
  ///  8 POP_TOP
  /// 10 JUMP_ABSOLUTE            2
  /// 12 POP_BLOCK
  /// 14 LOAD_NAME                2 (esmeralda)
  /// 16 POP_TOP
  /// 18 LOAD_CONST               0 (None)
  /// 20 RETURN_VALUE
  func test_withElse() {
    let stmt = self.whileStmt(
      test: self.identifierExpr(value: "frollo"),
      body: [self.identifierStmt(value: "quasimodo")],
      orElse: [self.identifierStmt(value: "esmeralda")]
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
        .setupLoop(loopEndTarget: 18),
        .loadName(name: "frollo"),
        .popJumpIfFalse(target: 12),
        .loadName(name: "quasimodo"),
        .popTop,
        .jumpAbsolute(target: 2),
        .popBlock,
        .loadName(name: "esmeralda"),
        .popTop,
        .loadConst(.none),
        .return
      ]
    )
  }

  /// while frollo:
  ///  continue <- don't try this at home kids
  ///  quasimodo
  ///
  ///  0 SETUP_LOOP              14 (to 16)
  ///  2 LOAD_NAME                0 (frollo)
  ///  4 POP_JUMP_IF_FALSE       14
  ///  6 JUMP_ABSOLUTE            2
  ///  8 LOAD_NAME                1 (quasimodo)
  /// 10 POP_TOP
  /// 12 JUMP_ABSOLUTE            2
  /// 14 POP_BLOCK
  /// 16 LOAD_CONST               0 (None)
  /// 18 RETURN_VALUE
  func test_continue() {
    let stmt = self.whileStmt(
      test: self.identifierExpr(value: "frollo"),
      body: [
        self.continueStmt(),
        self.identifierStmt(value: "quasimodo")
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
        .setupLoop(loopEndTarget: 16),
        .loadName(name: "frollo"),
        .popJumpIfFalse(target: 14),
        .jumpAbsolute(target: 2),
        .loadName(name: "quasimodo"),
        .popTop,
        .jumpAbsolute(target: 2),
        .popBlock,
        .loadConst(.none),
        .return
      ]
    )
  }

  /// while frollo:
  ///  break
  ///  quasimodo
  ///
  ///  0 SETUP_LOOP              14 (to 16)
  ///  2 LOAD_NAME                0 (frollo)
  ///  4 POP_JUMP_IF_FALSE       14
  ///  6 BREAK_LOOP
  ///  8 LOAD_NAME                1 (quasimodo)
  /// 10 POP_TOP
  /// 12 JUMP_ABSOLUTE            2
  /// 14 POP_BLOCK
  /// 16 LOAD_CONST               0 (None)
  /// 18 RETURN_VALUE
  func test_break() {
    let stmt = self.whileStmt(
      test: self.identifierExpr(value: "frollo"),
      body: [
        self.breakStmt(),
        self.identifierStmt(value: "quasimodo")
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
        .setupLoop(loopEndTarget: 16),
        .loadName(name: "frollo"),
        .popJumpIfFalse(target: 14),
        .break,
        .loadName(name: "quasimodo"),
        .popTop,
        .jumpAbsolute(target: 2),
        .popBlock,
        .loadConst(.none),
        .return
      ]
    )
  }
}
