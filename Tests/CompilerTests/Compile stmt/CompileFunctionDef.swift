import XCTest
import VioletCore
import VioletParser
import VioletBytecode
@testable import VioletCompiler

// swiftlint:disable function_body_length
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
        .loadConst(codeObject: .any),
        .loadConst(string: "cook"),
        .makeFunction(flags: []),
        .storeName(name: "cook"),
        .loadConst(.none),
        .return
      ],
      childCodeObjectCount: 1
    )

    guard let functionCode = code.getChildCodeObject(atIndex: 0) else {
      return
    }

    XCTAssertCodeObject(
      functionCode,
      name: "cook",
      qualifiedName: "cook",
      kind: .function,
      flags: [.nested, .newLocals, .optimized],
      instructions: [
        .loadGlobal(name: "ratatouille"),
        .popTop,
        .loadConst(.none),
        .return
      ]
    )
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
        .loadName(name: "Dish"),
        .loadConst(tuple: ["return"]),
        .buildConstKeyMap(elementCount: 1),
        .loadConst(codeObject: .any),
        .loadConst(string: "cook"),
        .makeFunction(flags: [.hasAnnotations]),
        .storeName(name: "cook"),
        .loadConst(.none),
        .return
      ],
      childCodeObjectCount: 1
    )

    guard let functionCode = code.getChildCodeObject(atIndex: 0) else {
      return
    }

    XCTAssertCodeObject(
      functionCode,
      name: "cook",
      qualifiedName: "cook",
      kind: .function,
      flags: [.nested, .newLocals, .optimized],
      instructions: [
        .loadGlobal(name: "ratatouille"),
        .popTop,
        .loadConst(.none),
        .return
      ]
    )
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
        .loadConst(codeObject: .any),
        .loadConst(string: "cook"),
        .makeFunction(flags: []),
        .storeName(name: "cook"),
        .loadConst(.none),
        .return
      ],
      childCodeObjectCount: 1
    )

    guard let functionCode = code.getChildCodeObject(atIndex: 0) else {
      return
    }

    XCTAssertCodeObject(
      functionCode,
      name: "cook",
      qualifiedName: "cook",
      kind: .function,
      flags: [.nested, .newLocals, .optimized],
      instructions: [
        .loadGlobal(name: "ratatouille"),
        .popTop,
        .loadConst(.none),
        .return
      ],
      argCount: 1
    )
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
        .loadName(name: "Vegetable"),
        .loadConst(tuple: ["zucchini"]),
        .buildConstKeyMap(elementCount: 1),
        .loadConst(codeObject: .any),
        .loadConst(string: "cook"),
        .makeFunction(flags: [.hasAnnotations]),
        .storeName(name: "cook"),
        .loadConst(.none),
        .return
      ],
      childCodeObjectCount: 1
    )

    guard let functionCode = code.getChildCodeObject(atIndex: 0) else {
      return
    }

    XCTAssertCodeObject(
      functionCode,
      name: "cook",
      qualifiedName: "cook",
      kind: .function,
      flags: [.nested, .newLocals, .optimized],
      instructions: [
        .loadGlobal(name: "ratatouille"),
        .popTop,
        .loadConst(.none),
        .return
      ],
      argCount: 1
    )
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
        .loadConst(tuple: .integer(1)),
        .loadConst(codeObject: .any),
        .loadConst(string: "cook"),
        .makeFunction(flags: [.hasPositionalArgDefaults]),
        .storeName(name: "cook"),
        .loadConst(.none),
        .return
      ],
      childCodeObjectCount: 1
    )

    guard let functionCode = code.getChildCodeObject(atIndex: 0) else {
      return
    }

    XCTAssertCodeObject(
      functionCode,
      name: "cook",
      qualifiedName: "cook",
      kind: .function,
      flags: [.nested, .newLocals, .optimized],
      instructions: [
        .loadGlobal(name: "ratatouille"),
        .popTop,
        .loadConst(.none),
        .return
      ],
      argCount: 1
    )
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
        .loadConst(codeObject: .any),
        .loadConst(string: "cook"),
        .makeFunction(flags: []),
        .storeName(name: "cook"),
        .loadConst(.none),
        .return
      ],
      childCodeObjectCount: 1
    )

    guard let functionCode = code.getChildCodeObject(atIndex: 0) else {
      return
    }

    XCTAssertCodeObject(
      functionCode,
      name: "cook",
      qualifiedName: "cook",
      kind: .function,
      flags: [.nested, .newLocals, .optimized],
      instructions: [
        .loadGlobal(name: "ratatouille"),
        .popTop,
        .loadConst(.none),
        .return
      ],
      argCount: 2
    )
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
        .loadConst(tuple: .integer(1)),
        .loadConst(codeObject: .any),
        .loadConst(string: "cook"),
        .makeFunction(flags: [.hasPositionalArgDefaults]),
        .storeName(name: "cook"),
        .loadConst(.none),
        .return
      ],
      childCodeObjectCount: 1
    )

    guard let functionCode = code.getChildCodeObject(atIndex: 0) else {
      return
    }

    XCTAssertCodeObject(
      functionCode,
      name: "cook",
      qualifiedName: "cook",
      kind: .function,
      flags: [.nested, .newLocals, .optimized],
      instructions: [
        .loadGlobal(name: "ratatouille"),
        .popTop,
        .loadConst(.none),
        .return
      ],
      argCount: 2
    )
  }

  // MARK: - Positional only

  /// def cook(zucchini, /, tomato): ratatouille
  ///
  ///  0 LOAD_CONST               0 (<code object cook at 0x107c267c0, file "<dis>", line 1>)
  ///  2 LOAD_CONST               1 ('cook')
  ///  4 MAKE_FUNCTION            0
  ///  6 STORE_NAME               0 (cook)
  ///  8 LOAD_CONST               2 (None)
  /// 10 RETURN_VALUE
  /// f <code object cook at 0x107c267c0, file "<dis>", line 1>:
  ///  0 LOAD_GLOBAL              0 (ratatouille)
  ///  2 POP_TOP
  ///  4 LOAD_CONST               0 (None)
  ///  6 RETURN_VALUE
  func test_positionalOnly() {
    let stmt = self.functionDefStmt(
      name: "cook",
      args: self.arguments(
        args: [self.arg(name: "zucchini"), self.arg(name: "tomato")],
        posOnlyArgCount: 1
      ),
      body: [self.identifierStmt(value: "ratatouille")]
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
        .loadConst(codeObject: .any),
        .loadConst(string: "cook"),
        .makeFunction(flags: []),
        .storeName(name: "cook"),
        .loadConst(.none),
        .return
      ],
      childCodeObjectCount: 1
    )

    guard let functionCode = code.getChildCodeObject(atIndex: 0) else {
      return
    }

    XCTAssertCodeObject(
      functionCode,
      name: "cook",
      qualifiedName: "cook",
      kind: .function,
      flags: [.nested, .newLocals, .optimized],
      instructions: [
        .loadGlobal(name: "ratatouille"),
        .popTop,
        .loadConst(.none),
        .return
      ],
      argCount: 2,
      posOnlyArgCount: 1
    )
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
        .loadConst(codeObject: .any),
        .loadConst(string: "cook"),
        .makeFunction(flags: []),
        .storeName(name: "cook"),
        .loadConst(.none),
        .return
      ],
      childCodeObjectCount: 1
    )

    guard let functionCode = code.getChildCodeObject(atIndex: 0) else {
      return
    }

    XCTAssertCodeObject(
      functionCode,
      name: "cook",
      qualifiedName: "cook",
      kind: .function,
      flags: [.nested, .newLocals, .optimized, .varArgs],
      instructions: [
        .loadGlobal(name: "ratatouille"),
        .popTop,
        .loadConst(.none),
        .return
      ],
      argCount: 0
    )
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
        .loadConst(integer: 1),
        .loadConst(tuple: ["tomato"]),
        .buildConstKeyMap(elementCount: 1),
        .loadConst(codeObject: .any),
        .loadConst(string: "cook"),
        .makeFunction(flags: [.hasKwOnlyArgDefaults]),
        .storeName(name: "cook"),
        .loadConst(.none),
        .return
      ],
      childCodeObjectCount: 1
    )

    guard let functionCode = code.getChildCodeObject(atIndex: 0) else {
      return
    }

    XCTAssertCodeObject(
      functionCode,
      name: "cook",
      qualifiedName: "cook",
      kind: .function,
      flags: [.nested, .newLocals, .optimized, .varArgs],
      instructions: [
        .loadGlobal(name: "ratatouille"),
        .popTop,
        .loadConst(.none),
        .return
      ],
      argCount: 0,
      kwOnlyArgCount: 1
    )
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
        .loadConst(codeObject: .any),
        .loadConst(string: "cook"),
        .makeFunction(flags: []),
        .storeName(name: "cook"),
        .loadConst(.none),
        .return
      ],
      childCodeObjectCount: 1
    )

    guard let functionCode = code.getChildCodeObject(atIndex: 0) else {
      return
    }

    XCTAssertCodeObject(
      functionCode,
      name: "cook",
      qualifiedName: "cook",
      kind: .function,
      flags: [.nested, .newLocals, .optimized],
      instructions: [
        .loadGlobal(name: "ratatouille"),
        .popTop,
        .loadConst(.none),
        .return
      ],
      argCount: 0,
      kwOnlyArgCount: 1
    )
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
        .loadConst(codeObject: .any),
        .loadConst(string: "cook"),
        .makeFunction(flags: []),
        .storeName(name: "cook"),
        .loadConst(.none),
        .return
      ],
      childCodeObjectCount: 1
    )

    guard let functionCode = code.getChildCodeObject(atIndex: 0) else {
      return
    }

    XCTAssertCodeObject(
      functionCode,
      name: "cook",
      qualifiedName: "cook",
      kind: .function,
      flags: [.nested, .newLocals, .optimized, .varKeywords],
      instructions: [
        .loadGlobal(name: "ratatouille"),
        .popTop,
        .loadConst(.none),
        .return
      ],
      argCount: 0,
      kwOnlyArgCount: 0
    )
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
        .loadConst(codeObject: .any),
        .loadConst(string: "cook"),
        .makeFunction(flags: []),
        .storeName(name: "cook"),
        .loadConst(.none),
        .return
      ],
      childCodeObjectCount: 1
    )

    guard let functionCode = code.getChildCodeObject(atIndex: 0) else {
      return
    }

    XCTAssertCodeObject(
      functionCode,
      name: "cook",
      qualifiedName: "cook",
      kind: .function,
      flags: [.nested, .newLocals, .optimized, .varArgs, .varKeywords],
      instructions: [
        .loadGlobal(name: "ratatouille"),
        .popTop,
        .loadConst(.none),
        .return
      ],
      argCount: 1,
      kwOnlyArgCount: 1
    )
  }
}
