import XCTest
import Core
import Parser
import Bytecode
@testable import Compiler

// swiftlint:disable function_body_length
// swiftlint:disable file_length
// swiftlint:disable type_body_length

/// Use 'Scripts/dump_dis.py' for reference.
class CompileFunctionDef: XCTestCase, CommonCompiler {

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
    let stmt = self.functionDef(
      name: "cook",
      args: self.arguments(),
      body: [self.statement(expr: .identifier("ratatouille"))]
    )

    let expected: [EmittedInstruction] = [
      .init(.loadConst, "<code object cook>"),
      .init(.loadConst, "cook"),
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
      XCTAssertCode(code, name: "<module>", qualified: "", type: .module)
      XCTAssertInstructions(code, expected)

      if let def = self.getCodeObject(parent: code, qualifiedName: "cook") {
        XCTAssertCode(def, name: "cook", type: .function)
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
    let stmt = self.functionDef(
      name: "cook",
      args: self.arguments(),
      body: [self.statement(expr: .identifier("ratatouille"))],
      returns: self.identifierExpr("Dish")
    )

    let expected: [EmittedInstruction] = [
      .init(.loadName, "Dish"),
      .init(.loadConst, "(return)"),
      .init(.buildConstKeyMap, "1"),
      .init(.loadConst, "<code object cook>"),
      .init(.loadConst, "cook"),
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
      XCTAssertCode(code, name: "<module>", qualified: "", type: .module)
      XCTAssertInstructions(code, expected)

      if let def = self.getCodeObject(parent: code, qualifiedName: "cook") {
        XCTAssertCode(def, name: "cook", type: .function)
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
    let stmt = self.functionDef(
      name: "cook",
      args: self.arguments(
        args: [self.arg("zucchini")]
      ),
      body: [self.statement(expr: .identifier("ratatouille"))]
    )

    let expected: [EmittedInstruction] = [
      .init(.loadConst, "<code object cook>"),
      .init(.loadConst, "cook"),
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
      XCTAssertCode(code, name: "<module>", qualified: "", type: .module)
      XCTAssertInstructions(code, expected)

      if let def = self.getCodeObject(parent: code, qualifiedName: "cook") {
        XCTAssertCode(def, name: "cook", type: .function)
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
    let stmt = self.functionDef(
      name: "cook",
      args: self.arguments(
        args: [
          self.arg("zucchini", annotation: self.identifierExpr("Vegetable"))
        ]
      ),
      body: [self.statement(expr: .identifier("ratatouille"))]
    )

    let expected: [EmittedInstruction] = [
      .init(.loadName, "Vegetable"),
      .init(.loadConst, "(zucchini)"),
      .init(.buildConstKeyMap, "1"),
      .init(.loadConst, "<code object cook>"),
      .init(.loadConst, "cook"),
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
      XCTAssertCode(code, name: "<module>", qualified: "", type: .module)
      XCTAssertInstructions(code, expected)

      if let def = self.getCodeObject(parent: code, qualifiedName: "cook") {
        XCTAssertCode(def, name: "cook", type: .function)
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
    let stmt = self.functionDef(
      name: "cook",
      args: self.arguments(
        args: [self.arg("zucchini")],
        defaults: [self.expression(.int(BigInt(1)))]
      ),
      body: [self.statement(expr: .identifier("ratatouille"))]
    )

    let expected: [EmittedInstruction] = [
      .init(.loadConst, "1"),
      .init(.buildTuple, "1"), //  <-- we don't have constatnt propagation!
      .init(.loadConst, "<code object cook>"),
      .init(.loadConst, "cook"),
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
      XCTAssertCode(code, name: "<module>", qualified: "", type: .module)
      XCTAssertInstructions(code, expected)

      if let def = self.getCodeObject(parent: code, qualifiedName: "cook") {
        XCTAssertCode(def, name: "cook", type: .function)
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
    let stmt = self.functionDef(
      name: "cook",
      args: self.arguments(
        args: [self.arg("zucchini"), self.arg("tomato")]
      ),
      body: [self.statement(expr: .identifier("ratatouille"))]
    )

    let expected: [EmittedInstruction] = [
      .init(.loadConst, "<code object cook>"),
      .init(.loadConst, "cook"),
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
      XCTAssertCode(code, name: "<module>", qualified: "", type: .module)
      XCTAssertInstructions(code, expected)

      if let def = self.getCodeObject(parent: code, qualifiedName: "cook") {
        XCTAssertCode(def, name: "cook", type: .function)
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
    let stmt = self.functionDef(
      name: "cook",
      args: self.arguments(
        args: [self.arg("zucchini"), self.arg("tomato")],
        defaults: [self.expression(.int(BigInt(1)))]
      ),
      body: [self.statement(expr: .identifier("ratatouille"))]
    )

    let expected: [EmittedInstruction] = [
      .init(.loadConst, "1"),
      .init(.buildTuple, "1"), //  <-- we don't have constatnt propagation!
      .init(.loadConst, "<code object cook>"),
      .init(.loadConst, "cook"),
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
      XCTAssertCode(code, name: "<module>", qualified: "", type: .module)
      XCTAssertInstructions(code, expected)

      if let def = self.getCodeObject(parent: code, qualifiedName: "cook") {
        XCTAssertCode(def, name: "cook", type: .function)
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
    let stmt = self.functionDef(
      name: "cook",
      args: self.arguments(
        vararg: .named(self.arg("zucchini"))
      ),
      body: [self.statement(expr: .identifier("ratatouille"))]
    )

    let expected: [EmittedInstruction] = [
      .init(.loadConst, "<code object cook>"),
      .init(.loadConst, "cook"),
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
      XCTAssertCode(code, name: "<module>", qualified: "", type: .module)
      XCTAssertInstructions(code, expected)

      if let def = self.getCodeObject(parent: code, qualifiedName: "cook") {
        XCTAssertCode(def, name: "cook", type: .function)
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
    let stmt = self.functionDef(
      name: "cook",
      args: self.arguments(
        vararg: .named(self.arg("zucchini")),
        kwOnlyArgs: [self.arg("tomato")],
        kwOnlyDefaults: [self.expression(.int(BigInt(1)))]
      ),
      body: [self.statement(expr: .identifier("ratatouille"))]
    )

    let expected: [EmittedInstruction] = [
      .init(.loadConst, "1"),
      .init(.loadConst, "(tomato)"),
      .init(.buildConstKeyMap, "1"),
      .init(.loadConst, "<code object cook>"),
      .init(.loadConst, "cook"),
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
      XCTAssertCode(code, name: "<module>", qualified: "", type: .module)
      XCTAssertInstructions(code, expected)

      if let def = self.getCodeObject(parent: code, qualifiedName: "cook") {
        XCTAssertCode(def, name: "cook", type: .function)
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
    let stmt = self.functionDef(
      name: "cook",
      args: self.arguments(
        vararg: .unnamed,
        kwOnlyArgs: [self.arg("zucchini")],
        kwOnlyDefaults: [self.expression(.none)] // default
      ),
      body: [self.statement(expr: .identifier("ratatouille"))]
    )

    let expected: [EmittedInstruction] = [
      .init(.loadConst, "<code object cook>"),
      .init(.loadConst, "cook"),
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
      XCTAssertCode(code, name: "<module>", qualified: "", type: .module)
      XCTAssertInstructions(code, expected)

      if let def = self.getCodeObject(parent: code, qualifiedName: "cook") {
        XCTAssertCode(def, name: "cook", type: .function)
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
    let stmt = self.functionDef(
      name: "cook",
      args: self.arguments(
        kwarg: self.arg("zucchini")
      ),
      body: [self.statement(expr: .identifier("ratatouille"))]
    )

    let expected: [EmittedInstruction] = [
      .init(.loadConst, "<code object cook>"),
      .init(.loadConst, "cook"),
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
      XCTAssertCode(code, name: "<module>", qualified: "", type: .module)
      XCTAssertInstructions(code, expected)

      if let def = self.getCodeObject(parent: code, qualifiedName: "cook") {
        XCTAssertCode(def, name: "cook", type: .function)
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
    let stmt = self.functionDef(
      name: "cook",
      args: self.arguments(
        args: [self.arg("zucchini")],
        vararg: .named(self.arg("tomato")),
        kwOnlyArgs: [self.arg("pepper")],
        kwOnlyDefaults: [self.expression(.none)], // default
        kwarg: self.arg("eggplant")
      ),
      body: [self.statement(expr: .identifier("ratatouille"))]
    )

    let expected: [EmittedInstruction] = [
      .init(.loadConst, "<code object cook>"),
      .init(.loadConst, "cook"),
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
      XCTAssertCode(code, name: "<module>", qualified: "", type: .module)
      XCTAssertInstructions(code, expected)

      if let def = self.getCodeObject(parent: code, qualifiedName: "cook") {
        XCTAssertCode(def, name: "cook", type: .function)
        XCTAssertInstructions(def, defExpected)
      }
    }
  }
}
