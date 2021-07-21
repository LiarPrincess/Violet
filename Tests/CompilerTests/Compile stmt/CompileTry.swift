import XCTest
import VioletCore
import VioletParser
import VioletBytecode
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
        .setupFinally(finallyStartTarget: 10),
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
        .setupExcept(firstExceptTarget: 10),
        .loadName(name: "mulan"),
        .popTop,
        .popBlock,
        // different label as we pop only once
        .jumpAbsolute(target: 22),
        .popTop,
//      .popTop,
//      .popTop,
        .loadName(name: "ping"),
        .popTop,
        .popExcept,
        // different label as we pop only once
        .jumpAbsolute(target: 22),
        .endFinally,
        .loadConst(.none),
        .return
      ]
    )
  }

  // MARK: - Except with type

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
        .setupExcept(firstExceptTarget: 10),
        .loadName(name: "mulan"),
        .popTop,
        .popBlock,
        // different label as we pop only once
        .jumpAbsolute(target: 30),
        .dupTop,
        .loadName(name: "soldier"),
        .compareOp(type: .exceptionMatch),
        // different label as we pop only once
        .popJumpIfFalse(target: 28),
        .popTop,
//      .popTop,
//      .popTop,
        .loadName(name: "ping"),
        .popTop,
        .popExcept,
        // different label as we pop only once
        .jumpAbsolute(target: 30),
        .endFinally,
        .loadConst(.none),
        .return
      ]
    )
  }

  // MARK: - Except with type and binding

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
        .setupExcept(firstExceptTarget: 10),
        .loadName(name: "mulan"),
        .popTop,
        .popBlock,
        // different label as we pop only once
        .jumpAbsolute(target: 44),
        .dupTop,
        .loadName(name: "disguise"),
        .compareOp(type: .exceptionMatch),
        // different label as we pop only once
        .popJumpIfFalse(target: 42),
//      .popTop,
        .storeName(name: "soldier"),
//      .popTop,
        // different label as we pop only once
        .setupFinally(finallyStartTarget: 30),
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
        .jumpAbsolute(target: 44),
        .endFinally,
        .loadConst(.none),
        .return
      ]
    )
  }

  /// def disguise():
  ///     try:
  ///         raise Woman('Mulan')
  ///     except NotAMan as e:
  ///         e.name
  ///
  ///  0 LOAD_CONST               0 (<code object disguise at 0x106791710, file "<dis>", line 1>)
  ///  2 LOAD_CONST               1 ('disguise')
  ///  4 MAKE_FUNCTION            0
  ///  6 STORE_NAME               0 (disguise)
  ///  8 LOAD_CONST               2 (None)
  /// 10 RETURN_VALUE
  /// f <code object disguise at 0x106791710, file "<dis>", line 1>:
  ///  0 SETUP_FINALLY           12 (to 14)
  ///  2 LOAD_GLOBAL              0 (Woman)
  ///  4 LOAD_CONST               1 ('Mulan')
  ///  6 CALL_FUNCTION            1
  ///  8 RAISE_VARARGS            1
  /// 10 POP_BLOCK
  /// 12 JUMP_FORWARD            40 (to 54)
  /// 14 DUP_TOP
  /// 16 LOAD_GLOBAL              1 (NotAMan)
  /// 18 COMPARE_OP              10 (exception match)
  /// 20 POP_JUMP_IF_FALSE       52
  /// 22   POP_TOP  - NOPE, we only store exception on stack (without type and traceback)
  /// 24 STORE_FAST               0 (e)
  /// 26   POP_TOP  - NOPE, we only store exception on stack (without type and traceback)
  /// 28 SETUP_FINALLY           10 (to 40)
  /// 30 LOAD_FAST                0 (e)
  /// 32 LOAD_ATTR                2 (name)
  /// 34 POP_TOP
  /// 36 POP_BLOCK
  /// 38 BEGIN_FINALLY
  /// 40 LOAD_CONST               0 (None)
  /// 42 STORE_FAST               0 (e)
  /// 44 DELETE_FAST              0 (e)
  /// 46 END_FINALLY
  /// 48 POP_EXCEPT
  /// 50 JUMP_FORWARD             2 (to 54)
  /// 52 END_FINALLY
  /// 54 LOAD_CONST               0 (None)
  /// 56 RETURN_VALUE
  func test_except_type_withName_inFunction() {
    // We need this test, because functions should use 'fast' for arguments

    let stmt = self.functionDefStmt(
      name: "disguise",
      args: self.arguments(),
      body: [
        self.tryStmt(
          body: [
            self.raiseStmt(
              exception:
                self.callExpr(
                  function: self.identifierExpr(value: "Woman"),
                  args: [self.stringExpr(value: .literal("Mulan"))],
                  keywords: []
                ),
              cause: nil
            )
          ],
          handlers: [
            self.exceptHandler(
              kind: .typed(
                type: self.identifierExpr(value: "NotAMan"),
                asName: "e"
              ),
              body: [
                self.exprStmt(
                  expression: self.attributeExpr(
                    object: self.identifierExpr(value: "e"),
                    name: "name"
                  )
                )
              ]
            )
          ],
          orElse: [],
          finally: []
        )
      ]
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
        .loadConst(codeObject: .any), // 0
        .loadConst(string: "disguise"), // 1
        .makeFunction(flags: []), // 2
        .storeName(name: "disguise"), // 3
        .loadConst(.none), // 4
        .return // 5
      ],
      childCodeObjectCount: 1
    )

    guard let functionCode = code.getChildCodeObject(atIndex: 0) else {
      return
    }

    XCTAssertCodeObject(
      functionCode,
      name: "disguise",
      qualifiedName: "disguise",
      kind: .function,
      flags: [.nested, .newLocals, .optimized],
      instructions: [
        // different label as we pop only once
        .setupExcept(firstExceptTarget: 14),
        .loadGlobal(name: "Woman"),
        .loadConst(string: "Mulan"),
        .callFunction(argumentCount: 1),
        .raiseVarargs(type: .exceptionOnly),
        .popBlock,
        // different label as we pop only once
        .jumpAbsolute(target: 50),
        .dupTop, // this is 7
        .loadGlobal(name: "NotAMan"),
        .compareOp(type: .exceptionMatch),
        // different label as we pop only once
        .popJumpIfFalse(target: 48),
//        .popTop,
        .storeFast(variable: MangledName(withoutClass: "e")),
//        .popTop,
        // different label as we pop only once
        .setupFinally(finallyStartTarget: 36),
        .loadFast(variable: MangledName(withoutClass: "e")),
        .loadAttribute(name: "name"),
        .popTop,
        .popBlock,
        .loadConst(.none),
        .loadConst(.none), // this is 36
        .storeFast(variable: MangledName(withoutClass: "e")),
        .deleteFast(variable: MangledName(withoutClass: "e")),
        .endFinally,
        .popExcept,
        .jumpAbsolute(target: 50),
        // different label as we pop only once
        .endFinally, // this is 48
        .loadConst(.none), // this is 50
        .return
      ]
    )
  }

  // MARK: - Multiple except

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
        .setupExcept(firstExceptTarget: 10),
        .loadName(name: "mulan"),
        .popTop,
        .popBlock,
        // different label as we pop only once
        .jumpAbsolute(target: 40),
        .dupTop,
        .loadName(name: "soldier"),
        .compareOp(type: .exceptionMatch),
        // different label as we pop only once
        .popJumpIfFalse(target: 28),
        .popTop,
  //      .popTop,
  //      .popTop,
        .loadName(name: "ping"),
        .popTop,
        .popExcept,
        // different label as we pop only once
        .jumpAbsolute(target: 40),
        .popTop,
  //      .popTop,
  //      .popTop,
        .loadName(name: "pong"),
        .popTop,
        .popExcept,
        // different label as we pop only once
        .jumpAbsolute(target: 40),
        .endFinally,
        .loadConst(.none), // this is 40
        .return
      ]
    )
  }

  // MARK: - Except, else

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
        .setupExcept(firstExceptTarget: 10),
        .loadName(name: "mulan"),
        .popTop,
        .popBlock,
        // different label as we pop only once
        .jumpAbsolute(target: 22),
        .popTop,
  //      .popTop,
  //      .popTop,
        .loadName(name: "ping"),
        .popTop,
        .popExcept,
        // different label as we pop only once
        .jumpAbsolute(target: 26),
        .endFinally,
        .loadName(name: "faMulan"),
        .popTop,
        .loadConst(.none),
        .return
      ]
    )
  }

  // MARK: - Except, finally

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
        .setupFinally(finallyStartTarget: 28),
        .setupExcept(firstExceptTarget: 12),
        .loadName(name: "mulan"),
        .popTop,
        .popBlock,
        // different label as we pop only once
        .jumpAbsolute(target: 24),
        .popTop, // 12
  //      .popTop,
  //      .popTop,
        .loadName(name: "ping"),
        .popTop,
        .popExcept,
        // different label as we pop only once
        .jumpAbsolute(target: 24),
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

  // MARK: - Except, else, finally

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
        .setupFinally(finallyStartTarget: 32),
        .setupExcept(firstExceptTarget: 12),
        .loadName(name: "mulan"),
        .popTop,
        .popBlock,
        // different label as we pop only once
        .jumpAbsolute(target: 24),
        .popTop,
  //      .popTop,
  //      .popTop,
        .loadName(name: "ping"),
        .popTop,
        .popExcept,
        // different label as we pop only once
        .jumpAbsolute(target: 28),
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
