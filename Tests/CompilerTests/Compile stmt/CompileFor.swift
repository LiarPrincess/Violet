import XCTest
import VioletCore
import VioletParser
import VioletBytecode
@testable import VioletCompiler

// swiftlint:disable file_length

/// Use './Scripts/dump' for reference.
class CompileFor: CompileTestCase {

  // MARK: - Simple

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

  // MARK: - Else

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

  // MARK: - Continue

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
  ///   try:
  ///     raise spell
  ///   except spell as e:
  ///     continue
  ///
  ///  0 SETUP_LOOP              58 (to 60)
  ///  2 LOAD_NAME                0 (castle)
  ///  4 GET_ITER
  ///  6 FOR_ITER                50 (to 58)
  ///  8 STORE_NAME               1 (person)
  /// 10 SETUP_EXCEPT             8 (to 20)
  /// 12 LOAD_NAME                2 (spell)
  /// 14 RAISE_VARARGS            1
  /// 16 POP_BLOCK
  /// 18 JUMP_ABSOLUTE            6
  /// 20 DUP_TOP
  /// 22 LOAD_NAME                2 (spell)
  /// 24 COMPARE_OP              10 (exception match)
  /// 26 POP_JUMP_IF_FALSE       54
  ///   28 POP_TOP - NOPE, we only store exception on stack (without type and traceback)
  /// 30 STORE_NAME               3 (e)
  ///   32 POP_TOP - NOPE, we only store exception on stack (without type and traceback)
  /// 34 SETUP_FINALLY            6 (to 42)
  /// 36 CONTINUE_LOOP            6
  /// 38 POP_BLOCK
  /// 40 LOAD_CONST               0 (None)
  /// 42 LOAD_CONST               0 (None)
  /// 44 STORE_NAME               3 (e)
  /// 46 DELETE_NAME              3 (e)
  /// 48 END_FINALLY
  /// 50 POP_EXCEPT
  /// 52 JUMP_ABSOLUTE            6
  /// 54 END_FINALLY
  /// 56 JUMP_ABSOLUTE            6
  /// 58 POP_BLOCK
  /// 60 LOAD_CONST               0 (None)
  /// 62 RETURN_VALUE
  func test_continue_inExcept() {
    // swiftlint:disable:previous function_body_length

    let body = self.tryStmt(
      body: [
        self.raiseStmt(
          exception: self.identifierExpr(value: "spell"),
          cause: nil
        )
      ],
      handlers: [
        self.exceptHandler(
          kind: .typed(type: self.identifierExpr(value: "spell"), asName: "e"),
          body: [self.continueStmt()]
        )
      ],
      orElse: [],
      finally: []
    )

    let stmt = self.forStmt(
      target: self.identifierExpr(value: "person", context: .store),
      iterable: self.identifierExpr(value: "castle"),
      body: [body],
      orElse: []
    )

    let expected: [EmittedInstruction] = [
      .init(.setupLoop, "56"),
      .init(.loadName, "castle"),
      .init(.getIter),
      .init(.forIter, "54"),
      .init(.storeName, "person"),
      .init(.setupExcept, "20"),
      .init(.loadName, "spell"),
      .init(.raiseVarargs, "exception"),
      .init(.popBlock),
      .init(.jumpAbsolute, "52"), // will jump to: '.init(.jumpAbsolute, "6")'
      .init(.dupTop),
      .init(.loadName, "spell"),
      .init(.compareOp, "exception match"),
      .init(.popJumpIfFalse, "50"),
//      .init(.popTop),
      .init(.storeName, "e"),
//      .init(.popTop),
      .init(.setupFinally, "38"),
      .init(.continue, "0"),
      .init(.popBlock),
      .init(.loadConst, "none"),
      .init(.loadConst, "none"),
      .init(.storeName, "e"),
      .init(.deleteName, "e"),
      .init(.endFinally),
      .init(.popExcept),
      .init(.jumpAbsolute, "52"), // will jump to: '.init(.jumpAbsolute, "6")'
      .init(.endFinally),
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

  // MARK: - Break

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
