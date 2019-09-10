import XCTest
import Core
import Parser
import Bytecode
@testable import Compiler

/// Use 'Scripts/dump_dis.py' for reference.
class CompileWhile: XCTestCase, CommonCompiler {

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
    let stmt = self.while(
      test: self.expression(.identifier("frollo")),
      body: [self.statement(expr: .identifier("quasimodo"))],
      orElse: []
    )

    let expected: [EmittedInstruction] = [
      .init(.setupLoop, "14"),
      .init(.loadName, "frollo"),
      .init(.popJumpIfFalse, "12"),
      .init(.loadName, "quasimodo"),
      .init(.popTop),
      .init(.jumpAbsolute, "2"),
      .init(.popBlock),
      .init(.loadConst, "none"),
      .init(.return)
    ]

    if let code = self.compile(stmt: stmt) {
      XCTAssertCode(code, name: "<module>", qualified: "", type: .module)
      XCTAssertInstructions(code, expected)
    }
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
    let stmt = self.while(
      test: self.expression(.identifier("frollo")),
      body:   [self.statement(expr: .identifier("quasimodo"))],
      orElse: [self.statement(expr: .identifier("esmeralda"))]
    )

    let expected: [EmittedInstruction] = [
      .init(.setupLoop, "18"),
      .init(.loadName, "frollo"),
      .init(.popJumpIfFalse, "12"),
      .init(.loadName, "quasimodo"),
      .init(.popTop),
      .init(.jumpAbsolute, "2"),
      .init(.popBlock),
      .init(.loadName, "esmeralda"),
      .init(.popTop),
      .init(.loadConst, "none"),
      .init(.return)
    ]

    if let code = self.compile(stmt: stmt) {
      XCTAssertCode(code, name: "<module>", qualified: "", type: .module)
      XCTAssertInstructions(code, expected)
    }
  }

  /// while frollo:
  ///  continue <- dont't try this at home kids
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
    let stmt = self.while(
      test: self.expression(.identifier("frollo")),
      body: [
        self.statement(.continue),
        self.statement(expr: .identifier("quasimodo"))
      ],
      orElse: []
    )

    let expected: [EmittedInstruction] = [
      .init(.setupLoop, "16"),
      .init(.loadName, "frollo"),
      .init(.popJumpIfFalse, "14"),
      .init(.jumpAbsolute, "2"),
      .init(.loadName, "quasimodo"),
      .init(.popTop),
      .init(.jumpAbsolute, "2"),
      .init(.popBlock),
      .init(.loadConst, "none"),
      .init(.return)
    ]

    if let code = self.compile(stmt: stmt) {
      XCTAssertCode(code, name: "<module>", qualified: "", type: .module)
      XCTAssertInstructions(code, expected)
    }
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
    let stmt = self.while(
      test: self.expression(.identifier("frollo")),
      body: [
        self.statement(.break),
        self.statement(expr: .identifier("quasimodo"))
      ],
      orElse: []
    )

    let expected: [EmittedInstruction] = [
      .init(.setupLoop, "16"),
      .init(.loadName, "frollo"),
      .init(.popJumpIfFalse, "14"),
      .init(.break),
      .init(.loadName, "quasimodo"),
      .init(.popTop),
      .init(.jumpAbsolute, "2"),
      .init(.popBlock),
      .init(.loadConst, "none"),
      .init(.return)
    ]

    if let code = self.compile(stmt: stmt) {
      XCTAssertCode(code, name: "<module>", qualified: "", type: .module)
      XCTAssertInstructions(code, expected)
    }
  }
}
