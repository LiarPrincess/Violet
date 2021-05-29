import XCTest
import VioletCore
import VioletParser
import VioletBytecode
@testable import VioletCompiler

// swiftlint:disable file_length

/// Use './Scripts/dump' for reference.
class CompileFunctionDef: CompileTestCase {

  // MARK: - No arguments

  /// def cook(): ratatouille
  ///
  ///  0 LOAD_CONST               0 (<code object cook at 0x1052c6930, file "<dis>", line 2>)
  ///  2 LOAD_CONST               1 ('cook')
  ///  4 MAKE_FUNCTION            0
  ///  6 STORE_NAME               0 (cook)
  ///  8 LOAD_CONST               2 (None)
  /// 10 RETURN_VALUE
  /// f <code object cook at 0x1052c6930, file "<dis>", line 2>:
  ///  0 LOAD_GLOBAL              0 (ratatouille)
  ///  2 POP_TOP
  ///  4 LOAD_CONST               0 (None)
  ///  6 RETURN_VALUE
  func test_noArguments() {
    let stmt = self.functionDefStmt(
      name: "cook",
      args: self.arguments(),
      body: [self.identifierStmt(value: "ratatouille")]
    )

    let expected: [EmittedInstruction] = [
      .init(.loadConst, "<code object cook>"),
      .init(.loadConst, "'cook'"),
      .init(.makeFunction, "0"),
      .init(.storeName, "cook"),
      .init(.loadConst, "none"),
      .init(.return)
    ]

    let defExpected: [EmittedInstruction] = [
      .init(.loadGlobal, "ratatouille"),
      .init(.popTop),
      .init(.loadConst, "none"),
      .init(.return)
    ]

    if let code = self.compile(stmt: stmt) {
      XCTAssertCode(code, name: "<module>", qualified: "", kind: .module)
      XCTAssertInstructions(code, expected)

      if let def = self.getCodeObject(parent: code, qualifiedName: "cook") {
        XCTAssertCode(def, name: "cook", kind: .function)
        XCTAssertInstructions(def, defExpected)
      }
    }
  }

  // MARK: - Return

  /// def cook() -> Dish: ratatouille
  ///
  ///  0 LOAD_NAME                0 (Dish)
  ///  2 LOAD_CONST               0 (('return',))
  ///  4 BUILD_CONST_KEY_MAP      1
  ///  6 LOAD_CONST               1 (<code object cook at 0x10c14aa50, file "<dis>", line 2>)
  ///  8 LOAD_CONST               2 ('cook')
  /// 10 MAKE_FUNCTION            4
  /// 12 STORE_NAME               1 (cook)
  /// 14 LOAD_CONST               3 (None)
  /// 16 RETURN_VALUE
  /// f <code object cook at 0x10c14aa50, file "<dis>", line 2>:
  ///  0 LOAD_GLOBAL              0 (ratatouille)
  ///  2 POP_TOP
  ///  4 LOAD_CONST               0 (None)
  ///  6 RETURN_VALUE
  func test_noArguments_return() {
    let stmt = self.functionDefStmt(
      name: "cook",
      args: self.arguments(),
      body: [self.identifierStmt(value: "ratatouille")],
      returns: self.identifierExpr(value: "Dish")
    )

    let expected: [EmittedInstruction] = [
      .init(.loadName, "Dish"),
      .init(.loadConst, "('return')"),
      .init(.buildConstKeyMap, "1"),
      .init(.loadConst, "<code object cook>"),
      .init(.loadConst, "'cook'"),
      .init(.makeFunction, "4"),
      .init(.storeName, "cook"),
      .init(.loadConst, "none"),
      .init(.return)
    ]

    let defExpected: [EmittedInstruction] = [
      .init(.loadGlobal, "ratatouille"),
      .init(.popTop),
      .init(.loadConst, "none"),
      .init(.return)
    ]

    if let code = self.compile(stmt: stmt) {
      XCTAssertCode(code, name: "<module>", qualified: "", kind: .module)
      XCTAssertInstructions(code, expected)

      if let def = self.getCodeObject(parent: code, qualifiedName: "cook") {
        XCTAssertCode(def, name: "cook", kind: .function)
        XCTAssertInstructions(def, defExpected)
      }
    }
  }

  // MARK: - Positional

  /// def cook(zucchini): ratatouille
  ///
  ///  0 LOAD_CONST               0 (<code object cook at 0x10c282a50, file "<dis>", line 2>)
  ///  2 LOAD_CONST               1 ('cook')
  ///  4 MAKE_FUNCTION            0
  ///  6 STORE_NAME               0 (cook)
  ///  8 LOAD_CONST               2 (None)
  /// 10 RETURN_VALUE
  /// f <code object cook at 0x10c282a50, file "<dis>", line 2>:
  ///  0 LOAD_GLOBAL              0 (ratatouille)
  ///  2 POP_TOP
  ///  4 LOAD_CONST               0 (None)
  ///  6 RETURN_VALUE
  func test_positional() {
    let stmt = self.functionDefStmt(
      name: "cook",
      args: self.arguments(
        args: [self.arg(name: "zucchini")]
      ),
      body: [self.identifierStmt(value: "ratatouille")]
    )

    let expected: [EmittedInstruction] = [
      .init(.loadConst, "<code object cook>"),
      .init(.loadConst, "'cook'"),
      .init(.makeFunction, "0"),
      .init(.storeName, "cook"),
      .init(.loadConst, "none"),
      .init(.return)
    ]

    let defExpected: [EmittedInstruction] = [
      .init(.loadGlobal, "ratatouille"),
      .init(.popTop),
      .init(.loadConst, "none"),
      .init(.return)
    ]

    if let code = self.compile(stmt: stmt) {
      XCTAssertCode(code, name: "<module>", qualified: "", kind: .module)
      XCTAssertInstructions(code, expected)

      if let def = self.getCodeObject(parent: code, qualifiedName: "cook") {
        XCTAssertCode(def, name: "cook", kind: .function)
        XCTAssertInstructions(def, defExpected)
      }
    }
  }

  /// def cook(zucchini: Vegetable): ratatouille
  ///
  ///  0 LOAD_NAME                0 (Vegetable)
  ///  2 LOAD_CONST               0 (('zucchini',))
  ///  4 BUILD_CONST_KEY_MAP      1
  ///  6 LOAD_CONST               1 (<code object cook at 0x10eb5fa50, file "<dis>", line 2>)
  ///  8 LOAD_CONST               2 ('cook')
  /// 10 MAKE_FUNCTION            4
  /// 12 STORE_NAME               1 (cook)
  /// 14 LOAD_CONST               3 (None)
  /// 16 RETURN_VALUE
  /// f <code object cook at 0x10eb5fa50, file "<dis>", line 2>:
  ///  0 LOAD_GLOBAL              0 (ratatouille)
  ///  2 POP_TOP
  ///  4 LOAD_CONST               0 (None)
  ///  6 RETURN_VALUE
  func test_positional_withType() {
    let stmt = self.functionDefStmt(
      name: "cook",
      args: self.arguments(
        args: [
          self.arg(name: "zucchini", annotation: self.identifierExpr(value: "Vegetable"))
        ]
      ),
      body: [self.identifierStmt(value: "ratatouille")]
    )

    let expected: [EmittedInstruction] = [
      .init(.loadName, "Vegetable"),
      .init(.loadConst, "('zucchini')"),
      .init(.buildConstKeyMap, "1"),
      .init(.loadConst, "<code object cook>"),
      .init(.loadConst, "'cook'"),
      .init(.makeFunction, "4"),
      .init(.storeName, "cook"),
      .init(.loadConst, "none"),
      .init(.return)
    ]

    let defExpected: [EmittedInstruction] = [
      .init(.loadGlobal, "ratatouille"),
      .init(.popTop),
      .init(.loadConst, "none"),
      .init(.return)
    ]

    if let code = self.compile(stmt: stmt) {
      XCTAssertCode(code, name: "<module>", qualified: "", kind: .module)
      XCTAssertInstructions(code, expected)

      if let def = self.getCodeObject(parent: code, qualifiedName: "cook") {
        XCTAssertCode(def, name: "cook", kind: .function)
        XCTAssertInstructions(def, defExpected)
      }
    }
  }

  /// def cook(zucchini = 1): ratatouille
  ///
  ///  0 LOAD_CONST               4 ((1,))
  ///  2 LOAD_CONST               1 (<code object cook at 0x10d69ea50, file "<dis>", line 2>)
  ///  4 LOAD_CONST               2 ('cook')
  ///  6 MAKE_FUNCTION            1
  ///  8 STORE_NAME               0 (cook)
  /// 10 LOAD_CONST               3 (None)
  /// 12 RETURN_VALUE
  /// f <code object cook at 0x10d69ea50, file "<dis>", line 2>:
  ///  0 LOAD_GLOBAL              0 (ratatouille)
  ///  2 POP_TOP
  ///  4 LOAD_CONST               0 (None)
  ///  6 RETURN_VALUE
  func test_positional_default() {
    let stmt = self.functionDefStmt(
      name: "cook",
      args: self.arguments(
        args: [self.arg(name: "zucchini")],
        defaults: [self.intExpr(value: 1)]
      ),
      body: [self.identifierStmt(value: "ratatouille")]
    )

    let expected: [EmittedInstruction] = [
      .init(.loadConst, "1"),
      .init(.buildTuple, "1"), //  <-- we don't have constant propagation!
      .init(.loadConst, "<code object cook>"),
      .init(.loadConst, "'cook'"),
      .init(.makeFunction, "1"),
      .init(.storeName, "cook"),
      .init(.loadConst, "none"),
      .init(.return)
    ]

    let defExpected: [EmittedInstruction] = [
      .init(.loadGlobal, "ratatouille"),
      .init(.popTop),
      .init(.loadConst, "none"),
      .init(.return)
    ]

    if let code = self.compile(stmt: stmt) {
      XCTAssertCode(code, name: "<module>", qualified: "", kind: .module)
      XCTAssertInstructions(code, expected)

      if let def = self.getCodeObject(parent: code, qualifiedName: "cook") {
        XCTAssertCode(def, name: "cook", kind: .function)
        XCTAssertInstructions(def, defExpected)
      }
    }
  }

  /// def cook(zucchini, tomato): ratatouille
  ///
  ///  0 LOAD_CONST               0 (<code object cook at 0x10733fa50, file "<dis>", line 2>)
  ///  2 LOAD_CONST               1 ('cook')
  ///  4 MAKE_FUNCTION            0
  ///  6 STORE_NAME               0 (cook)
  ///  8 LOAD_CONST               2 (None)
  /// 10 RETURN_VALUE
  /// f <code object cook at 0x10733fa50, file "<dis>", line 2>:
  ///  0 LOAD_GLOBAL              0 (ratatouille)
  ///  2 POP_TOP
  ///  4 LOAD_CONST               0 (None)
  ///  6 RETURN_VALUE
  func test_positional_multiple() {
    let stmt = self.functionDefStmt(
      name: "cook",
      args: self.arguments(
        args: [self.arg(name: "zucchini"), self.arg(name: "tomato")]
      ),
      body: [self.identifierStmt(value: "ratatouille")]
    )

    let expected: [EmittedInstruction] = [
      .init(.loadConst, "<code object cook>"),
      .init(.loadConst, "'cook'"),
      .init(.makeFunction, "0"),
      .init(.storeName, "cook"),
      .init(.loadConst, "none"),
      .init(.return)
    ]

    let defExpected: [EmittedInstruction] = [
      .init(.loadGlobal, "ratatouille"),
      .init(.popTop),
      .init(.loadConst, "none"),
      .init(.return)
    ]

    if let code = self.compile(stmt: stmt) {
      XCTAssertCode(code, name: "<module>", qualified: "", kind: .module)
      XCTAssertInstructions(code, expected)

      if let def = self.getCodeObject(parent: code, qualifiedName: "cook") {
        XCTAssertCode(def, name: "cook", kind: .function)
        XCTAssertInstructions(def, defExpected)
      }
    }
  }

  /// def cook(zucchini, tomato=1): ratatouille
  ///
  ///  0 LOAD_CONST               4 ((1,))
  ///  2 LOAD_CONST               1 (<code object cook at 0x109f00a50, file "<dis>", line 2>)
  ///  4 LOAD_CONST               2 ('cook')
  ///  6 MAKE_FUNCTION            1
  ///  8 STORE_NAME               0 (cook)
  /// 10 LOAD_CONST               3 (None)
  /// 12 RETURN_VALUE
  /// f <code object cook at 0x109f00a50, file "<dis>", line 2>:
  ///  0 LOAD_GLOBAL              0 (ratatouille)
  ///  2 POP_TOP
  ///  4 LOAD_CONST               0 (None)
  ///  6 RETURN_VALUE
  func test_positional_default_afterRequired() {
    let stmt = self.functionDefStmt(
      name: "cook",
      args: self.arguments(
        args: [self.arg(name: "zucchini"), self.arg(name: "tomato")],
        defaults: [self.intExpr(value: 1)]
      ),
      body: [self.identifierStmt(value: "ratatouille")]
    )

    let expected: [EmittedInstruction] = [
      .init(.loadConst, "1"),
      .init(.buildTuple, "1"), //  <-- we don't have constant propagation!
      .init(.loadConst, "<code object cook>"),
      .init(.loadConst, "'cook'"),
      .init(.makeFunction, "1"),
      .init(.storeName, "cook"),
      .init(.loadConst, "none"),
      .init(.return)
    ]

    let defExpected: [EmittedInstruction] = [
      .init(.loadGlobal, "ratatouille"),
      .init(.popTop),
      .init(.loadConst, "none"),
      .init(.return)
    ]

    if let code = self.compile(stmt: stmt) {
      XCTAssertCode(code, name: "<module>", qualified: "", kind: .module)
      XCTAssertInstructions(code, expected)

      if let def = self.getCodeObject(parent: code, qualifiedName: "cook") {
        XCTAssertCode(def, name: "cook", kind: .function)
        XCTAssertInstructions(def, defExpected)
      }
    }
  }

  // MARK: - Variadic

  /// def cook(*zucchini): ratatouille
  ///
  ///  0 LOAD_CONST               0 (<code object cook at 0x105964a50, file "<dis>", line 2>)
  ///  2 LOAD_CONST               1 ('cook')
  ///  4 MAKE_FUNCTION            0
  ///  6 STORE_NAME               0 (cook)
  ///  8 LOAD_CONST               2 (None)
  /// 10 RETURN_VALUE
  /// f <code object cook at 0x105964a50, file "<dis>", line 2>:
  ///  0 LOAD_GLOBAL              0 (ratatouille)
  ///  2 POP_TOP
  ///  4 LOAD_CONST               0 (None)
  ///  6 RETURN_VALUE
  func test_varargs() {
    let stmt = self.functionDefStmt(
      name: "cook",
      args: self.arguments(
        vararg: .named(self.arg(name: "zucchini"))
      ),
      body: [self.identifierStmt(value: "ratatouille")]
    )

    let expected: [EmittedInstruction] = [
      .init(.loadConst, "<code object cook>"),
      .init(.loadConst, "'cook'"),
      .init(.makeFunction, "0"),
      .init(.storeName, "cook"),
      .init(.loadConst, "none"),
      .init(.return)
    ]

    let defExpected: [EmittedInstruction] = [
      .init(.loadGlobal, "ratatouille"),
      .init(.popTop),
      .init(.loadConst, "none"),
      .init(.return)
    ]

    if let code = self.compile(stmt: stmt) {
      XCTAssertCode(code, name: "<module>", qualified: "", kind: .module)
      XCTAssertInstructions(code, expected)

      if let def = self.getCodeObject(parent: code, qualifiedName: "cook") {
        XCTAssertCode(def, name: "cook", kind: .function)
        XCTAssertInstructions(def, defExpected)
      }
    }
  }

  /// def cook(*zucchini, tomato=1): ratatouille
  ///
  ///  0 LOAD_CONST               0 (1)
  ///  2 LOAD_CONST               1 (('tomato',))
  ///  4 BUILD_CONST_KEY_MAP      1
  ///  6 LOAD_CONST               2 (<code object cook at 0x106f41a50, file "<dis>", line 2>)
  ///  8 LOAD_CONST               3 ('cook')
  /// 10 MAKE_FUNCTION            2
  /// 12 STORE_NAME               0 (cook)
  /// 14 LOAD_CONST               4 (None)
  /// 16 RETURN_VALUE
  /// f <code object cook at 0x106f41a50, file "<dis>", line 2>:
  ///  0 LOAD_GLOBAL              0 (ratatouille)
  ///  2 POP_TOP
  ///  4 LOAD_CONST               0 (None)
  ///  6 RETURN_VALUE
  func test_varargs_keywordOnly_withDefault() {
    let stmt = self.functionDefStmt(
      name: "cook",
      args: self.arguments(
        vararg: .named(self.arg(name: "zucchini")),
        kwOnlyArgs: [self.arg(name: "tomato")],
        kwOnlyDefaults: [self.intExpr(value: 1)]
      ),
      body: [self.identifierStmt(value: "ratatouille")]
    )

    let expected: [EmittedInstruction] = [
      .init(.loadConst, "1"),
      .init(.loadConst, "('tomato')"),
      .init(.buildConstKeyMap, "1"),
      .init(.loadConst, "<code object cook>"),
      .init(.loadConst, "'cook'"),
      .init(.makeFunction, "2"),
      .init(.storeName, "cook"),
      .init(.loadConst, "none"),
      .init(.return)
    ]

    let defExpected: [EmittedInstruction] = [
      .init(.loadGlobal, "ratatouille"),
      .init(.popTop),
      .init(.loadConst, "none"),
      .init(.return)
    ]

    if let code = self.compile(stmt: stmt) {
      XCTAssertCode(code, name: "<module>", qualified: "", kind: .module)
      XCTAssertInstructions(code, expected)

      if let def = self.getCodeObject(parent: code, qualifiedName: "cook") {
        XCTAssertCode(def, name: "cook", kind: .function)
        XCTAssertInstructions(def, defExpected)
      }
    }
  }

  /// def cook(*, zucchini): ratatouille
  ///
  ///  0 LOAD_CONST               0 (<code object cook at 0x10a6a3a50, file "<dis>", line 2>)
  ///  2 LOAD_CONST               1 ('cook')
  ///  4 MAKE_FUNCTION            0
  ///  6 STORE_NAME               0 (cook)
  ///  8 LOAD_CONST               2 (None)
  /// 10 RETURN_VALUE
  /// f <code object cook at 0x10a6a3a50, file "<dis>", line 2>:
  ///  0 LOAD_GLOBAL              0 (ratatouille)
  ///  2 POP_TOP
  ///  4 LOAD_CONST               0 (None)
  ///  6 RETURN_VALUE
  func test_varargsUnnamed() {
    let stmt = self.functionDefStmt(
      name: "cook",
      args: self.arguments(
        vararg: .unnamed,
        kwOnlyArgs: [self.arg(name: "zucchini")],
        kwOnlyDefaults: [self.noneExpr()] // default
      ),
      body: [self.identifierStmt(value: "ratatouille")]
    )

    let expected: [EmittedInstruction] = [
      .init(.loadConst, "<code object cook>"),
      .init(.loadConst, "'cook'"),
      .init(.makeFunction, "0"),
      .init(.storeName, "cook"),
      .init(.loadConst, "none"),
      .init(.return)
    ]

    let defExpected: [EmittedInstruction] = [
      .init(.loadGlobal, "ratatouille"),
      .init(.popTop),
      .init(.loadConst, "none"),
      .init(.return)
    ]

    if let code = self.compile(stmt: stmt) {
      XCTAssertCode(code, name: "<module>", qualified: "", kind: .module)
      XCTAssertInstructions(code, expected)

      if let def = self.getCodeObject(parent: code, qualifiedName: "cook") {
        XCTAssertCode(def, name: "cook", kind: .function)
        XCTAssertInstructions(def, defExpected)
      }
    }
  }

  // MARK: - Kwargs

  /// def cook(**zucchini): ratatouille
  ///
  ///  0 LOAD_CONST               0 (<code object cook at 0x107666a50, file "<dis>", line 2>)
  ///  2 LOAD_CONST               1 ('cook')
  ///  4 MAKE_FUNCTION            0
  ///  6 STORE_NAME               0 (cook)
  ///  8 LOAD_CONST               2 (None)
  /// 10 RETURN_VALUE
  /// f <code object cook at 0x107666a50, file "<dis>", line 2>:
  ///  0 LOAD_GLOBAL              0 (ratatouille)
  ///  2 POP_TOP
  ///  4 LOAD_CONST               0 (None)
  ///  6 RETURN_VALUE
  func test_kwargs() {
    let stmt = self.functionDefStmt(
      name: "cook",
      args: self.arguments(
        kwarg: self.arg(name: "zucchini")
      ),
      body: [self.identifierStmt(value: "ratatouille")]
    )

    let expected: [EmittedInstruction] = [
      .init(.loadConst, "<code object cook>"),
      .init(.loadConst, "'cook'"),
      .init(.makeFunction, "0"),
      .init(.storeName, "cook"),
      .init(.loadConst, "none"),
      .init(.return)
    ]

    let defExpected: [EmittedInstruction] = [
      .init(.loadGlobal, "ratatouille"),
      .init(.popTop),
      .init(.loadConst, "none"),
      .init(.return)
    ]

    if let code = self.compile(stmt: stmt) {
      XCTAssertCode(code, name: "<module>", qualified: "", kind: .module)
      XCTAssertInstructions(code, expected)

      if let def = self.getCodeObject(parent: code, qualifiedName: "cook") {
        XCTAssertCode(def, name: "cook", kind: .function)
        XCTAssertInstructions(def, defExpected)
      }
    }
  }

  // MARK: - All

  /// def cook(zucchini, *tomato, pepper, **eggplant): ratatouille
  ///
  ///  0 LOAD_CONST               0 (<code object cook at 0x108cb2a50, file "<dis>", line 2>)
  ///  2 LOAD_CONST               1 ('cook')
  ///  4 MAKE_FUNCTION            0
  ///  6 STORE_NAME               0 (cook)
  ///  8 LOAD_CONST               2 (None)
  /// 10 RETURN_VALUE
  /// f <code object cook at 0x108cb2a50, file "<dis>", line 2>:
  ///  0 LOAD_GLOBAL              0 (ratatouille)
  ///  2 POP_TOP
  ///  4 LOAD_CONST               0 (None)
  ///  6 RETURN_VALUE
  func test_all() {
    let stmt = self.functionDefStmt(
      name: "cook",
      args: self.arguments(
        args: [self.arg(name: "zucchini")],
        vararg: .named(self.arg(name: "tomato")),
        kwOnlyArgs: [self.arg(name: "pepper")],
        kwOnlyDefaults: [self.noneExpr()], // default
        kwarg: self.arg(name: "eggplant")
      ),
      body: [self.identifierStmt(value: "ratatouille")]
    )

    let expected: [EmittedInstruction] = [
      .init(.loadConst, "<code object cook>"),
      .init(.loadConst, "'cook'"),
      .init(.makeFunction, "0"),
      .init(.storeName, "cook"),
      .init(.loadConst, "none"),
      .init(.return)
    ]

    let defExpected: [EmittedInstruction] = [
      .init(.loadGlobal, "ratatouille"),
      .init(.popTop),
      .init(.loadConst, "none"),
      .init(.return)
    ]

    if let code = self.compile(stmt: stmt) {
      XCTAssertCode(code, name: "<module>", qualified: "", kind: .module)
      XCTAssertInstructions(code, expected)

      if let def = self.getCodeObject(parent: code, qualifiedName: "cook") {
        XCTAssertCode(def, name: "cook", kind: .function)
        XCTAssertInstructions(def, defExpected)
      }
    }
  }
}
