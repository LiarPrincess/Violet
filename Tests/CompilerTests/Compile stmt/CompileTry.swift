import XCTest
import VioletCore
import VioletParser
@testable import VioletBytecode
@testable import VioletCompiler

// swiftlint:disable file_length
// swiftlint:disable function_body_length

/// Use './Scripts/dump' for reference.
class CompileTry: CompileTestCase {

  // MARK: - Only finally

  /// try:     ping
  /// finally: mulan
  ///
  ///  0 SETUP_FINALLY            8 (to 10)
  ///  2 LOAD_NAME                0 (ping)
  ///  4 POP_TOP
  ///  6 POP_BLOCK
  ///  8 LOAD_CONST               0 (None)
  /// 10 LOAD_NAME                1 (mulan)
  /// 12 POP_TOP
  /// 14 END_FINALLY
  /// 16 LOAD_CONST               0 (None)
  /// 18 RETURN_VALUE
  func test_finally() {
    let stmt = self.tryStmt(
      body: [self.identifierStmt(value: "ping")],
      handlers: [],
      orElse: [],
      finally: [self.identifierStmt(value: "mulan")]
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
        .setupFinally(finallyStartLabel: CodeObject.Label(jumpAddress: 5)),
        .loadName(name: "ping"),
        .popTop,
        .popBlock,
        .loadConst(.none),
        .loadName(name: "mulan"),
        .popTop,
        .endFinally,
        .loadConst(.none),
        .return
      ]
    )
  }

  // MARK: - Except

  /// try:    mulan
  /// except: ping
  ///
  ///  0 SETUP_EXCEPT             8 (to 10)
  ///  2 LOAD_NAME                0 (mulan)
  ///  4 POP_TOP
  ///  6 POP_BLOCK
  ///  8 JUMP_FORWARD            16 (to 26)
  /// 10 POP_TOP
  ///   12 POP_TOP - NOPE, we only store exception on stack (without type and traceback)
  ///   14 POP_TOP
  /// 16 LOAD_NAME                1 (ping)
  /// 18 POP_TOP
  /// 20 POP_EXCEPT
  /// 22 JUMP_FORWARD             2 (to 26)
  /// 24 END_FINALLY
  /// 26 LOAD_CONST               0 (None)
  /// 28 RETURN_VALUE
  func test_except() {
    let stmt = self.tryStmt(
      body: [self.identifierStmt(value: "mulan")],
      handlers: [
        self.exceptHandler(
          kind: .default,
          body: [self.identifierStmt(value: "ping")]
        )
      ],
      orElse: [],
      finally: []
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
        .setupExcept(firstExceptLabel: CodeObject.Label(jumpAddress: 5)),
        .loadName(name: "mulan"),
        .popTop,
        .popBlock,
        // different label as we pop only once
        .jumpAbsolute(label: CodeObject.Label(jumpAddress: 11)),
        .popTop,
//      .popTop,
//      .popTop,
        .loadName(name: "ping"),
        .popTop,
        .popExcept,
        // different label as we pop only once
        .jumpAbsolute(label: CodeObject.Label(jumpAddress: 11)),
        .endFinally,
        .loadConst(.none),
        .return
      ]
    )
  }

  /// try: mulan
  /// except soldier: ping
  ///
  ///  0 SETUP_EXCEPT             8 (to 10)
  ///  2 LOAD_NAME                0 (mulan)
  ///  4 POP_TOP
  ///  6 POP_BLOCK
  ///  8 JUMP_FORWARD            24 (to 34)
  /// 10 DUP_TOP
  /// 12 LOAD_NAME                1 (soldier)
  /// 14 COMPARE_OP              10 (exception match)
  /// 16 POP_JUMP_IF_FALSE       32
  /// 18 POP_TOP
  ///   20 POP_TOP - NOPE, we only store exception on stack (without type and traceback)
  ///   22 POP_TOP
  /// 24 LOAD_NAME                2 (ping)
  /// 26 POP_TOP
  /// 28 POP_EXCEPT
  /// 30 JUMP_FORWARD             2 (to 34)
  /// 32 END_FINALLY
  /// 34 LOAD_CONST               0 (None)
  /// 36 RETURN_VALUE
  func test_except_type() {
    let stmt = self.tryStmt(
      body: [self.identifierStmt(value: "mulan")],
      handlers: [
        self.exceptHandler(
          kind: .typed(
            type: self.identifierExpr(value: "soldier"),
            asName: nil
          ),
          body: [self.identifierStmt(value: "ping")]
        )
      ],
      orElse: [],
      finally: []
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
        .setupExcept(firstExceptLabel: CodeObject.Label(jumpAddress: 5)),
        .loadName(name: "mulan"),
        .popTop,
        .popBlock,
        // different label as we pop only once
        .jumpAbsolute(label: CodeObject.Label(jumpAddress: 15)),
        .dupTop,
        .loadName(name: "soldier"),
        .compareOp(type: .exceptionMatch),
        // different label as we pop only once
        .popJumpIfFalse(label: CodeObject.Label(jumpAddress: 14)),
        .popTop,
//      .popTop,
//      .popTop,
        .loadName(name: "ping"),
        .popTop,
        .popExcept,
        // different label as we pop only once
        .jumpAbsolute(label: CodeObject.Label(jumpAddress: 15)),
        .endFinally,
        .loadConst(.none),
        .return
      ]
    )
  }

  /// try: mulan
  /// except disguise as soldier: ping
  ///
  ///  0 SETUP_EXCEPT             8 (to 10)
  ///  2 LOAD_NAME                0 (mulan)
  ///  4 POP_TOP
  ///  6 POP_BLOCK
  ///  8 JUMP_FORWARD            38 (to 48)
  /// 10 DUP_TOP
  /// 12 LOAD_NAME                1 (disguise)
  /// 14 COMPARE_OP              10 (exception match)
  /// 16 POP_JUMP_IF_FALSE       46
  ///   18 POP_TOP - NOPE, we only store exception on stack (without type and traceback)
  /// 20 STORE_NAME               2 (soldier) - this stores exception
  ///   22 POP_TOP - NOPE, we only store exception on stack (without type and traceback)
  /// 24 SETUP_FINALLY            8 (to 34)
  /// 26 LOAD_NAME                3 (ping)
  /// 28 POP_TOP
  /// 30 POP_BLOCK
  /// 32 LOAD_CONST               0 (None)
  /// 34 LOAD_CONST               0 (None)
  /// 36 STORE_NAME               2 (soldier)
  /// 38 DELETE_NAME              2 (soldier)
  /// 40 END_FINALLY
  /// 42 POP_EXCEPT
  /// 44 JUMP_FORWARD             2 (to 48)
  /// 46 END_FINALLY
  /// 48 LOAD_CONST               0 (None)
  /// 50 RETURN_VALUE
  func test_except_type_withName() {
    let stmt = self.tryStmt(
      body: [self.identifierStmt(value: "mulan")],
      handlers: [
        self.exceptHandler(
          kind: .typed(
            type: self.identifierExpr(value: "disguise"),
            asName: "soldier"
          ),
          body: [self.identifierStmt(value: "ping")]
        )
      ],
      orElse: [],
      finally: []
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
        .setupExcept(firstExceptLabel: CodeObject.Label(jumpAddress: 5)),
        .loadName(name: "mulan"),
        .popTop,
        .popBlock,
        // different label as we pop only once
        .jumpAbsolute(label: CodeObject.Label(jumpAddress: 22)),
        .dupTop,
        .loadName(name: "disguise"),
        .compareOp(type: .exceptionMatch),
        // different label as we pop only once
        .popJumpIfFalse(label: CodeObject.Label(jumpAddress: 21)),
//      .popTop,
        .storeName(name: "soldier"),
//      .popTop,
        // different label as we pop only once
        .setupFinally(finallyStartLabel: CodeObject.Label(jumpAddress: 15)),
        .loadName(name: "ping"),
        .popTop,
        .popBlock,
        .loadConst(.none),
        .loadConst(.none),
        .storeName(name: "soldier"),
        .deleteName(name: "soldier"),
        .endFinally,
        .popExcept,
        // different label as we pop only once
        .jumpAbsolute(label: CodeObject.Label(jumpAddress: 22)),
        .endFinally,
        .loadConst(.none),
        .return
      ]
    )
  }

  /// try: mulan
  /// except soldier: ping
  /// except: pong
  ///
  ///  0 SETUP_EXCEPT             8 (to 10)
  ///  2 LOAD_NAME                0 (mulan)
  ///  4 POP_TOP
  ///  6 POP_BLOCK
  ///  8 JUMP_FORWARD            38 (to 48)
  /// 10 DUP_TOP
  /// 12 LOAD_NAME                1 (soldier)
  /// 14 COMPARE_OP              10 (exception match)
  /// 16 POP_JUMP_IF_FALSE       32
  /// 18 POP_TOP
  ///   20 POP_TOP - NOPE, we only store exception on stack (without type and traceback)
  ///   22 POP_TOP
  /// 24 LOAD_NAME                2 (ping)
  /// 26 POP_TOP
  /// 28 POP_EXCEPT
  /// 30 JUMP_FORWARD            16 (to 48)
  /// 32 POP_TOP
  ///   34 POP_TOP - NOPE, we only store exception on stack (without type and traceback)
  ///   36 POP_TOP
  /// 38 LOAD_NAME                3 (pong)
  /// 40 POP_TOP
  /// 42 POP_EXCEPT
  /// 44 JUMP_FORWARD             2 (to 48)
  /// 46 END_FINALLY
  /// 48 LOAD_CONST               0 (None)
  /// 50 RETURN_VALUE
  func test_except_multiple() {
    let stmt = self.tryStmt(
      body: [self.identifierStmt(value: "mulan")],
      handlers: [
        self.exceptHandler(
          kind: .typed(
            type: self.identifierExpr(value: "soldier"),
            asName: nil
          ),
          body: [self.identifierStmt(value: "ping")]
        ),
        self.exceptHandler(
          kind: .default,
          body: [self.identifierStmt(value: "pong")]
        )
      ],
      orElse: [],
      finally: []
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
        .setupExcept(firstExceptLabel: CodeObject.Label(jumpAddress: 5)),
        .loadName(name: "mulan"),
        .popTop,
        .popBlock,
        // different label as we pop only once
        .jumpAbsolute(label: CodeObject.Label(jumpAddress: 20)),
        .dupTop,
        .loadName(name: "soldier"),
        .compareOp(type: .exceptionMatch),
        // different label as we pop only once
        .popJumpIfFalse(label: CodeObject.Label(jumpAddress: 14)),
        .popTop,
  //      .popTop,
  //      .popTop,
        .loadName(name: "ping"),
        .popTop,
        .popExcept,
        // different label as we pop only once
        .jumpAbsolute(label: CodeObject.Label(jumpAddress: 20)),
        .popTop,
  //      .popTop,
  //      .popTop,
        .loadName(name: "pong"),
        .popTop,
        .popExcept,
        // different label as we pop only once
        .jumpAbsolute(label: CodeObject.Label(jumpAddress: 20)),
        .endFinally,
        .loadConst(.none), // this is 40
        .return
      ]
    )
  }

  /// try: mulan
  /// except: ping
  /// else: faMulan
  ///
  ///  0 SETUP_EXCEPT             8 (to 10)
  ///  2 LOAD_NAME                0 (mulan)
  ///  4 POP_TOP
  ///  6 POP_BLOCK
  ///  8 JUMP_FORWARD            16 (to 26)
  /// 10 POP_TOP
  ///   12 POP_TOP - NOPE, we only store exception on stack (without type and traceback)
  ///   14 POP_TOP
  /// 16 LOAD_NAME                1 (ping)
  /// 18 POP_TOP
  /// 20 POP_EXCEPT
  /// 22 JUMP_FORWARD             6 (to 30)
  /// 24 END_FINALLY
  /// 26 LOAD_NAME                2 (faMulan)
  /// 28 POP_TOP
  /// 30 LOAD_CONST               0 (None)
  /// 32 RETURN_VALUE
  func test_except_else() {
    let stmt = self.tryStmt(
      body: [self.identifierStmt(value: "mulan")],
      handlers: [
        self.exceptHandler(
          kind: .default,
          body: [self.identifierStmt(value: "ping")]
        )
      ],
      orElse: [self.identifierStmt(value: "faMulan")],
      finally: []
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
        .setupExcept(firstExceptLabel: CodeObject.Label(jumpAddress: 5)),
        .loadName(name: "mulan"),
        .popTop,
        .popBlock,
        // different label as we pop only once
        .jumpAbsolute(label: CodeObject.Label(jumpAddress: 11)),
        .popTop,
  //      .popTop,
  //      .popTop,
        .loadName(name: "ping"),
        .popTop,
        .popExcept,
        // different label as we pop only once
        .jumpAbsolute(label: CodeObject.Label(jumpAddress: 13)),
        .endFinally,
        .loadName(name: "faMulan"),
        .popTop,
        .loadConst(.none),
        .return
      ]
    )
  }

  /// try: mulan
  /// except: ping
  /// finally: faMulan
  ///
  ///  0 SETUP_FINALLY           30 (to 32)
  ///  2 SETUP_EXCEPT             8 (to 12)
  ///  4 LOAD_NAME                0 (mulan)
  ///  6 POP_TOP
  ///  8 POP_BLOCK
  /// 10 JUMP_FORWARD            16 (to 28)
  /// 12 POP_TOP
  ///   14 POP_TOP - NOPE, we only store exception on stack (without type and traceback)
  ///   16 POP_TOP
  /// 18 LOAD_NAME                1 (ping)
  /// 20 POP_TOP
  /// 22 POP_EXCEPT
  /// 24 JUMP_FORWARD             2 (to 28)
  /// 26 END_FINALLY
  /// 28 POP_BLOCK
  /// 30 LOAD_CONST               0 (None)
  /// 32 LOAD_NAME                2 (faMulan)
  /// 34 POP_TOP
  /// 36 END_FINALLY
  /// 38 LOAD_CONST               0 (None)
  /// 40 RETURN_VALUE
  func test_except_finally() {
    let stmt = self.tryStmt(
      body: [self.identifierStmt(value: "mulan")],
      handlers: [
        self.exceptHandler(
          kind: .default,
          body: [self.identifierStmt(value: "ping")]
        )
      ],
      orElse: [],
      finally: [self.identifierStmt(value: "faMulan")]
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
        // different label as we pop only once
        .setupFinally(finallyStartLabel: CodeObject.Label(jumpAddress: 14)),
        .setupExcept(firstExceptLabel: CodeObject.Label(jumpAddress: 6)),
        .loadName(name: "mulan"),
        .popTop,
        .popBlock,
        // different label as we pop only once
        .jumpAbsolute(label: CodeObject.Label(jumpAddress: 12)),
        .popTop, // 12
  //      .popTop,
  //      .popTop,
        .loadName(name: "ping"),
        .popTop,
        .popExcept,
        // different label as we pop only once
        .jumpAbsolute(label: CodeObject.Label(jumpAddress: 12)),
        .endFinally,
        .popBlock,
        .loadConst(.none),
        .loadName(name: "faMulan"),
        .popTop,
        .endFinally,
        .loadConst(.none),
        .return
      ]
    )
  }

  /// try: mulan
  /// except: ping
  /// else:   pong
  /// finally: faMulan
  ///
  ///  0 SETUP_FINALLY           34 (to 36)
  ///  2 SETUP_EXCEPT             8 (to 12)
  ///  4 LOAD_NAME                0 (mulan)
  ///  6 POP_TOP
  ///  8 POP_BLOCK
  /// 10 JUMP_FORWARD            16 (to 28)
  /// 12 POP_TOP
  ///   14 POP_TOP - NOPE, we only store exception on stack (without type and traceback)
  ///   16 POP_TOP
  /// 18 LOAD_NAME                1 (ping)
  /// 20 POP_TOP
  /// 22 POP_EXCEPT
  /// 24 JUMP_FORWARD             6 (to 32)
  /// 26 END_FINALLY
  /// 28 LOAD_NAME                2 (pong)
  /// 30 POP_TOP
  /// 32 POP_BLOCK
  /// 34 LOAD_CONST               0 (None)
  /// 36 LOAD_NAME                3 (faMulan)
  /// 38 POP_TOP
  /// 40 END_FINALLY
  /// 42 LOAD_CONST               0 (None)
  /// 44 RETURN_VALUE
  func test_except_else_finally() {
    let stmt = self.tryStmt(
      body: [self.identifierStmt(value: "mulan")],
      handlers: [
        self.exceptHandler(
          kind: .default,
          body: [self.identifierStmt(value: "ping")]
        )
      ],
      orElse: [self.identifierStmt(value: "pong")],
      finally: [self.identifierStmt(value: "faMulan")]
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
        // different label as we pop only once
        .setupFinally(finallyStartLabel: CodeObject.Label(jumpAddress: 16)),
        .setupExcept(firstExceptLabel: CodeObject.Label(jumpAddress: 6)),
        .loadName(name: "mulan"),
        .popTop,
        .popBlock,
        // different label as we pop only once
        .jumpAbsolute(label: CodeObject.Label(jumpAddress: 12)),
        .popTop,
  //      .popTop,
  //      .popTop,
        .loadName(name: "ping"),
        .popTop,
        .popExcept,
        // different label as we pop only once
        .jumpAbsolute(label: CodeObject.Label(jumpAddress: 14)),
        .endFinally,
        .loadName(name: "pong"),
        .popTop,
        .popBlock,
        .loadConst(.none),
        .loadName(name: "faMulan"),
        .popTop,
        .endFinally,
        .loadConst(.none),
        .return
      ]
    )
  }
}
