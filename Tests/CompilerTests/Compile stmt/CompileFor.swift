import XCTest
import Core
import Parser
import Bytecode
@testable import Compiler

/// Use './Scripts/dump' for reference.
class CompileFor: CompileTestCase {

  /// for person in castle: becomeItem
  ///
  ///  0 SETUP_LOOP              16 (to 18)
  ///  2 LOAD_NAME                0 (castle)
  ///  4 GET_ITER
  ///  6 FOR_ITER                 8 (to 16)
  ///  8 STORE_NAME               1 (person)
  /// 10 LOAD_NAME                2 (becomeItem)
  /// 12 POP_TOP
  /// 14 JUMP_ABSOLUTE            6
  /// 16 POP_BLOCK
  /// 18 LOAD_CONST               0 (None)
  /// 20 RETURN_VALUE
  func test_simple() {
    let stmt = self.forStmt(
      target: self.identifierExpr(value: "person", context: .store),
      iterable: self.identifierExpr(value: "castle"),
      body: [self.identifierStmt(value: "becomeItem")],
      orElse: []
    )

    let expected: [EmittedInstruction] = [
      .init(.setupLoop, "18"),
      .init(.loadName, "castle"),
      .init(.getIter),
      .init(.forIter, "16"),
      .init(.storeName, "person"),
      .init(.loadName, "becomeItem"),
      .init(.popTop),
      .init(.jumpAbsolute, "6"),
      .init(.popBlock),
      .init(.loadConst, "none"),
      .init(.return)
    ]

    if let code = self.compile(stmt: stmt) {
      XCTAssertCode(code, name: "<module>", qualified: "", type: .module)
      XCTAssertInstructions(code, expected)
    }
  }

  /// for person in belle: husband
  /// else: beast
  ///
  ///  0 SETUP_LOOP              20 (to 22)
  ///  2 LOAD_NAME                0 (belle)
  ///  4 GET_ITER
  ///  6 FOR_ITER                 8 (to 16)
  ///  8 STORE_NAME               1 (person)
  /// 10 LOAD_NAME                2 (husband)
  /// 12 POP_TOP
  /// 14 JUMP_ABSOLUTE            6
  /// 16 POP_BLOCK
  /// 18 LOAD_NAME                3 (beast)
  /// 20 POP_TOP
  /// 22 LOAD_CONST               0 (None)
  /// 24 RETURN_VALUE
  func test_withElse() {
    let stmt = self.forStmt(
      target: self.identifierExpr(value: "person", context: .store),
      iterable: self.identifierExpr(value: "belle"),
      body: [self.identifierStmt(value: "husband")],
      orElse: [self.identifierStmt(value: "beast")]
    )

    let expected: [EmittedInstruction] = [
      .init(.setupLoop, "22"),
      .init(.loadName, "belle"),
      .init(.getIter),
      .init(.forIter, "16"),
      .init(.storeName, "person"),
      .init(.loadName, "husband"),
      .init(.popTop),
      .init(.jumpAbsolute, "6"),
      .init(.popBlock),
      .init(.loadName, "beast"),
      .init(.popTop),
      .init(.loadConst, "none"),
      .init(.return)
    ]

    if let code = self.compile(stmt: stmt) {
      XCTAssertCode(code, name: "<module>", qualified: "", type: .module)
      XCTAssertInstructions(code, expected)
    }
  }

  /// for person in castle:
  ///  continue <- dont't try this at home kids
  ///  becomeItem
  ///
  ///  0 SETUP_LOOP              18 (to 20)
  ///  2 LOAD_NAME                0 (castle)
  ///  4 GET_ITER
  ///  6 FOR_ITER                10 (to 18)
  ///  8 STORE_NAME               1 (person)
  /// 10 JUMP_ABSOLUTE            6
  /// 12 LOAD_NAME                2 (becomeItem)
  /// 14 POP_TOP
  /// 16 JUMP_ABSOLUTE            6
  /// 18 POP_BLOCK
  /// 20 LOAD_CONST               0 (None)
  /// 22 RETURN_VALUE
  func test_continue() {
    let stmt = self.forStmt(
      target: self.identifierExpr(value: "person", context: .store),
      iterable: self.identifierExpr(value: "castle"),
      body: [
        self.continueStmt(),
        self.identifierStmt(value: "becomeItem")
      ],
      orElse: []
    )

    let expected: [EmittedInstruction] = [
      .init(.setupLoop, "20"),
      .init(.loadName, "castle"),
      .init(.getIter),
      .init(.forIter, "18"),
      .init(.storeName, "person"),
      .init(.jumpAbsolute, "6"),
      .init(.loadName, "becomeItem"),
      .init(.popTop),
      .init(.jumpAbsolute, "6"),
      .init(.popBlock),
      .init(.loadConst, "none"),
      .init(.return)
    ]

    if let code = self.compile(stmt: stmt) {
      XCTAssertCode(code, name: "<module>", qualified: "", type: .module)
      XCTAssertInstructions(code, expected)
    }
  }

  /// for person in castle:
  ///  break
  ///  becomeItem
  ///
  ///  0 SETUP_LOOP              18 (to 20)
  ///  2 LOAD_NAME                0 (castle)
  ///  4 GET_ITER
  ///  6 FOR_ITER                10 (to 18)
  ///  8 STORE_NAME               1 (person)
  /// 10 BREAK_LOOP
  /// 12 LOAD_NAME                2 (becomeItem)
  /// 14 POP_TOP
  /// 16 JUMP_ABSOLUTE            6
  /// 18 POP_BLOCK
  /// 20 LOAD_CONST               0 (None)
  /// 22 RETURN_VALUE
  func test_break() {
    let stmt = self.forStmt(
      target: self.identifierExpr(value: "person", context: .store),
      iterable: self.identifierExpr(value: "castle"),
      body: [
        self.breakStmt(),
        self.identifierStmt(value: "becomeItem")
      ],
      orElse: []
    )

    let expected: [EmittedInstruction] = [
      .init(.setupLoop, "20"),
      .init(.loadName, "castle"),
      .init(.getIter),
      .init(.forIter, "18"),
      .init(.storeName, "person"),
      .init(.break),
      .init(.loadName, "becomeItem"),
      .init(.popTop),
      .init(.jumpAbsolute, "6"),
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
