import XCTest
import VioletCore
import VioletParser
import VioletBytecode
@testable import VioletCompiler

// swiftlint:disable file_length
// swiftlint:disable function_body_length

/// Use 'Scripts/dump_dis.py' for reference.
class CompileLambda: CompileTestCase {

  // MARK: - No arguments

  /// lambda: ratatouille
  ///
  ///  0 LOAD_CONST               0 (<code object <lambda> at 0x1046af1e0, file "<dis>", line 1>)
  ///  2 LOAD_CONST               1 ('<lambda>')
  ///  4 MAKE_FUNCTION            0
  ///  6 RETURN_VALUE
  /// f <code object <lambda> at 0x1046af1e0, file "<dis>", line 1>:
  ///  0 LOAD_GLOBAL              0 (ratatouille)
  ///  2 RETURN_VALUE
  func test_noArguments() {
    let expr = self.lambdaExpr(
      args: self.arguments(),
      body: self.identifierExpr(value: "ratatouille")
    )

    guard let code = self.compile(expr: expr) else {
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
        .loadConst(string: "<lambda>"),
        .makeFunction(flags: []),
        .return
      ],
      childCodeObjectCount: 1
    )

    guard let lambdaCode = code.getChildCodeObject(atIndex: 0) else {
      return
    }

    XCTAssertCodeObject(
      lambdaCode,
      name: "<lambda>",
      qualifiedName: "<lambda>",
      kind: .lambda,
      flags: [.nested, .newLocals, .optimized],
      instructions: [
        .loadGlobal(name: "ratatouille"),
        .return
      ]
    )
  }

  /// cook = lambda: ratatouille
  ///
  ///  0 LOAD_CONST               0 (<code object <lambda> at 0x101d4a780, file "<dis>", line 1>)
  ///  2 LOAD_CONST               1 ('<lambda>')
  ///  4 MAKE_FUNCTION            0
  ///  6 STORE_NAME               0 (cook)
  ///  8 LOAD_CONST               2 (None)
  /// 10 RETURN_VALUE
  /// f <code object <lambda> at 0x101d4a780, file "<dis>", line 1>:
  ///  0 LOAD_GLOBAL              0 (ratatouille)
  ///  2 RETURN_VALUE
  func test_noArguments_store() {
    let stmt = self.assignStmt(
      targets: [self.identifierExpr(value: "cook", context: .store)],
      value: self.lambdaExpr(
        args: self.arguments(),
        body: self.identifierExpr(value: "ratatouille")
      )
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
        .loadConst(string: "<lambda>"),
        .makeFunction(flags: []),
        .storeName(name: "cook"),
        .loadConst(.none),
        .return
      ],
      childCodeObjectCount: 1
    )

    guard let lambdaCode = code.getChildCodeObject(atIndex: 0) else {
      return
    }

    XCTAssertCodeObject(
      lambdaCode,
      name: "<lambda>",
      qualifiedName: "<lambda>",
      kind: .lambda,
      flags: [.nested, .newLocals, .optimized],
      instructions: [
        .loadGlobal(name: "ratatouille"),
        .return
      ]
    )
  }

  // MARK: - Positional

  /// lambda zucchini: ratatouille
  ///
  ///  0 LOAD_CONST               0 (<code object <lambda> at 0x106aa51e0, file "<dis>", line 1>)
  ///  2 LOAD_CONST               1 ('<lambda>')
  ///  4 MAKE_FUNCTION            0
  ///  6 RETURN_VALUE
  /// f <code object <lambda> at 0x106aa51e0, file "<dis>", line 1>:
  ///  0 LOAD_GLOBAL              0 (ratatouille)
  ///  2 RETURN_VALUE
  func test_positional() {
    let expr = self.lambdaExpr(
      args: self.arguments(
        args: [self.arg(name: "zucchini")]
      ),
      body: self.identifierExpr(value: "ratatouille")
    )

    guard let code = self.compile(expr: expr) else {
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
        .loadConst(string: "<lambda>"),
        .makeFunction(flags: []),
        .return
      ],
      childCodeObjectCount: 1
    )

    guard let lambdaCode = code.getChildCodeObject(atIndex: 0) else {
      return
    }

    XCTAssertCodeObject(
      lambdaCode,
      name: "<lambda>",
      qualifiedName: "<lambda>",
      kind: .lambda,
      flags: [.nested, .newLocals, .optimized],
      instructions: [
        .loadGlobal(name: "ratatouille"),
        .return
      ],
      argCount: 1
    )
  }

  /// lambda zucchini = 1: ratatouille
  ///
  ///  0 LOAD_CONST               3 ((1,))
  ///  2 LOAD_CONST               1 (<code object <lambda> at 0x10c7801e0, file "<dis>", line 1>)
  ///  4 LOAD_CONST               2 ('<lambda>')
  ///  6 MAKE_FUNCTION            1
  ///  8 RETURN_VALUE
  /// f <code object <lambda> at 0x10c7801e0, file "<dis>", line 1>:
  ///  0 LOAD_GLOBAL              0 (ratatouille)
  ///  2 RETURN_VALUE
  func test_positional_default() {
    let expr = self.lambdaExpr(
      args: self.arguments(
        args: [self.arg(name: "zucchini")],
        defaults: [self.intExpr(value: 1)]
      ),
      body: self.identifierExpr(value: "ratatouille")
    )

    guard let code = self.compile(expr: expr) else {
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
        .loadConst(string: "<lambda>"),
        .makeFunction(flags: [.hasPositionalArgDefaults]),
        .return
      ],
      childCodeObjectCount: 1
    )

    guard let lambdaCode = code.getChildCodeObject(atIndex: 0) else {
      return
    }

    XCTAssertCodeObject(
      lambdaCode,
      name: "<lambda>",
      qualifiedName: "<lambda>",
      kind: .lambda,
      flags: [.nested, .newLocals, .optimized],
      instructions: [
        .loadGlobal(name: "ratatouille"),
        .return
      ],
      argCount: 1
    )
  }

  /// lambda zucchini, tomato: ratatouille
  ///
  ///  0 LOAD_CONST               0 (<code object <lambda> at 0x1028b81e0, file "<dis>", line 1>)
  ///  2 LOAD_CONST               1 ('<lambda>')
  ///  4 MAKE_FUNCTION            0
  ///  6 RETURN_VALUE
  /// f <code object <lambda> at 0x1028b81e0, file "<dis>", line 1>:
  ///  0 LOAD_GLOBAL              0 (ratatouille)
  ///  2 RETURN_VALUE
  func test_positional_multiple() {
    let expr = self.lambdaExpr(
      args: self.arguments(
        args: [self.arg(name: "zucchini"), self.arg(name: "tomato")]
      ),
      body: self.identifierExpr(value: "ratatouille")
    )

    guard let code = self.compile(expr: expr) else {
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
        .loadConst(string: "<lambda>"),
        .makeFunction(flags: []),
        .return
      ],
      childCodeObjectCount: 1
    )

    guard let lambdaCode = code.getChildCodeObject(atIndex: 0) else {
      return
    }

    XCTAssertCodeObject(
      lambdaCode,
      name: "<lambda>",
      qualifiedName: "<lambda>",
      kind: .lambda,
      flags: [.nested, .newLocals, .optimized],
      instructions: [
        .loadGlobal(name: "ratatouille"),
        .return
      ],
      argCount: 2
    )
  }

  func test_positional_default_afterRequired() {
    let expr = self.lambdaExpr(
      args: self.arguments(
        args: [self.arg(name: "zucchini"), self.arg(name: "tomato")],
        defaults: [self.intExpr(value: 1)]
      ),
      body: self.identifierExpr(value: "ratatouille")
    )

    guard let code = self.compile(expr: expr) else {
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
        .loadConst(string: "<lambda>"),
        .makeFunction(flags: [.hasPositionalArgDefaults]),
        .return
      ],
      childCodeObjectCount: 1
    )

    guard let lambdaCode = code.getChildCodeObject(atIndex: 0) else {
      return
    }

    XCTAssertCodeObject(
      lambdaCode,
      name: "<lambda>",
      qualifiedName: "<lambda>",
      kind: .lambda,
      flags: [.nested, .newLocals, .optimized],
      instructions: [
        .loadGlobal(name: "ratatouille"),
        .return
      ],
      argCount: 2
    )
  }

  // MARK: - Positional only

  /// lambda zucchini, /, tomato: ratatouille
  ///
  ///  0 LOAD_CONST               0 (<code object <lambda> at 0x1028b81e0, file "<dis>", line 1>)
  ///  2 LOAD_CONST               1 ('<lambda>')
  ///  4 MAKE_FUNCTION            0
  ///  6 RETURN_VALUE
  /// f <code object <lambda> at 0x1028b81e0, file "<dis>", line 1>:
  ///  0 LOAD_GLOBAL              0 (ratatouille)
  ///  2 RETURN_VALUE
  func test_positionalOnly() {
    let expr = self.lambdaExpr(
      args: self.arguments(
        args: [self.arg(name: "zucchini"), self.arg(name: "tomato")],
        posOnlyArgCount: 1
      ),
      body: self.identifierExpr(value: "ratatouille")
    )

    guard let code = self.compile(expr: expr) else {
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
        .loadConst(string: "<lambda>"),
        .makeFunction(flags: []),
        .return
      ],
      childCodeObjectCount: 1
    )

    guard let lambdaCode = code.getChildCodeObject(atIndex: 0) else {
      return
    }

    XCTAssertCodeObject(
      lambdaCode,
      name: "<lambda>",
      qualifiedName: "<lambda>",
      kind: .lambda,
      flags: [.nested, .newLocals, .optimized],
      instructions: [
        .loadGlobal(name: "ratatouille"),
        .return
      ],
      argCount: 2,
      posOnlyArgCount: 1
    )
  }

  // MARK: - Variadic

  /// lambda *zucchini: ratatouille
  ///
  ///  0 LOAD_CONST               0 (<code object <lambda> at 0x10f2131e0, file "<dis>", line 1>)
  ///  2 LOAD_CONST               1 ('<lambda>')
  ///  4 MAKE_FUNCTION            0
  ///  6 RETURN_VALUE
  /// f <code object <lambda> at 0x10f2131e0, file "<dis>", line 1>:
  ///  0 LOAD_GLOBAL              0 (ratatouille)
  ///  2 RETURN_VALUE
  func test_varargs() {
    let expr = self.lambdaExpr(
      args: self.arguments(
        vararg: .named(self.arg(name: "zucchini"))
      ),
      body: self.identifierExpr(value: "ratatouille")
    )

    guard let code = self.compile(expr: expr) else {
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
        .loadConst(string: "<lambda>"),
        .makeFunction(flags: []),
        .return
      ],
      childCodeObjectCount: 1
    )

    guard let lambdaCode = code.getChildCodeObject(atIndex: 0) else {
      return
    }

    XCTAssertCodeObject(
      lambdaCode,
      name: "<lambda>",
      qualifiedName: "<lambda>",
      kind: .lambda,
      flags: [.nested, .newLocals, .optimized, .varArgs],
      instructions: [
        .loadGlobal(name: "ratatouille"),
        .return
      ]
    )
  }

  /// lambda *zucchini, tomato=1: ratatouille
  ///
  ///  0 LOAD_CONST               0 (1)
  ///  2 LOAD_CONST               1 (('tomato',))
  ///  4 BUILD_CONST_KEY_MAP      1
  ///  6 LOAD_CONST               2 (<code object <lambda> at 0x108e081e0, file "<dis>", line 1>)
  ///  8 LOAD_CONST               3 ('<lambda>')
  /// 10 MAKE_FUNCTION            2
  /// 12 RETURN_VALUE
  /// f <code object <lambda> at 0x108e081e0, file "<dis>", line 1>:
  ///  0 LOAD_GLOBAL              0 (ratatouille)
  ///  2 RETURN_VALUE
  func test_varargs_keywordOnly_withDefault() {
    let expr = self.lambdaExpr(
      args: self.arguments(
        vararg: .named(self.arg(name: "zucchini")),
        kwOnlyArgs: [self.arg(name: "tomato")],
        kwOnlyDefaults: [self.intExpr(value: 1)]
      ),
      body: self.identifierExpr(value: "ratatouille")
    )

    guard let code = self.compile(expr: expr) else {
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
        .loadConst(tuple: .string("tomato")),
        .buildConstKeyMap(elementCount: 1),
        .loadConst(codeObject: .any),
        .loadConst(string: "<lambda>"),
        .makeFunction(flags: [.hasKwOnlyArgDefaults]),
        .return
      ],
      childCodeObjectCount: 1
    )

    guard let lambdaCode = code.getChildCodeObject(atIndex: 0) else {
      return
    }

    XCTAssertCodeObject(
      lambdaCode,
      name: "<lambda>",
      qualifiedName: "<lambda>",
      kind: .lambda,
      flags: [.nested, .newLocals, .optimized, .varArgs],
      instructions: [
        .loadGlobal(name: "ratatouille"),
        .return
      ],
      kwOnlyArgCount: 1
    )
  }

  /// lambda *, zucchini: ratatouille
  ///
  ///  0 LOAD_CONST               0 (<code object <lambda> at 0x1073f11e0, file "<dis>", line 1>)
  ///  2 LOAD_CONST               1 ('<lambda>')
  ///  4 MAKE_FUNCTION            0
  ///  6 RETURN_VALUE
  /// f <code object <lambda> at 0x1073f11e0, file "<dis>", line 1>:
  ///  0 LOAD_GLOBAL              0 (ratatouille)
  ///  2 RETURN_VALUE
  func test_varargsUnnamed() {
    let expr = self.lambdaExpr(
      args: self.arguments(
        vararg: .unnamed,
        kwOnlyArgs: [self.arg(name: "zucchini")],
        kwOnlyDefaults: [self.noneExpr()] // default
      ),
      body: self.identifierExpr(value: "ratatouille")
    )

    guard let code = self.compile(expr: expr) else {
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
        .loadConst(string: "<lambda>"),
        .makeFunction(flags: []),
        .return
      ],
      childCodeObjectCount: 1
    )

    guard let lambdaCode = code.getChildCodeObject(atIndex: 0) else {
      return
    }

    XCTAssertCodeObject(
      lambdaCode,
      name: "<lambda>",
      qualifiedName: "<lambda>",
      kind: .lambda,
      flags: [.nested, .newLocals, .optimized],
      instructions: [
        .loadGlobal(name: "ratatouille"),
        .return
      ],
      kwOnlyArgCount: 1
    )
  }

  /// lambda **zucchini: ratatouille
  ///
  ///  0 LOAD_CONST               0 (<code object <lambda> at 0x10ee4b1e0, file "<dis>", line 1>)
  ///  2 LOAD_CONST               1 ('<lambda>')
  ///  4 MAKE_FUNCTION            0
  ///  6 RETURN_VALUE
  /// f <code object <lambda> at 0x10ee4b1e0, file "<dis>", line 1>:
  ///  0 LOAD_GLOBAL              0 (ratatouille)
  ///  2 RETURN_VALUE
  func test_kwargs() {
    let expr = self.lambdaExpr(
      args: self.arguments(
        kwarg: self.arg(name: "zucchini")
      ),
      body: self.identifierExpr(value: "ratatouille")
    )

    guard let code = self.compile(expr: expr) else {
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
        .loadConst(string: "<lambda>"),
        .makeFunction(flags: []),
        .return
      ],
      childCodeObjectCount: 1
    )

    guard let lambdaCode = code.getChildCodeObject(atIndex: 0) else {
      return
    }

    XCTAssertCodeObject(
      lambdaCode,
      name: "<lambda>",
      qualifiedName: "<lambda>",
      kind: .lambda,
      flags: [.nested, .newLocals, .optimized, .varKeywords],
      instructions: [
        .loadGlobal(name: "ratatouille"),
        .return
      ]
    )
  }

  /// lambda zucchini, *tomato, pepper, **eggplant: ratatouille
  ///
  ///  0 LOAD_CONST               0 (<code object <lambda> at 0x10d8e61e0, file "<dis>", line 1>)
  ///  2 LOAD_CONST               1 ('<lambda>')
  ///  4 MAKE_FUNCTION            0
  ///  6 RETURN_VALUE
  /// f <code object <lambda> at 0x10d8e61e0, file "<dis>", line 1>:
  ///  0 LOAD_GLOBAL              0 (ratatouille)
  ///  2 RETURN_VALUE
  func test_all() {
    let expr = self.lambdaExpr(
      args: self.arguments(
        args: [self.arg(name: "zucchini")],
        vararg: .named(self.arg(name: "tomato")),
        kwOnlyArgs: [self.arg(name: "pepper")],
        kwOnlyDefaults: [self.noneExpr()], // default
        kwarg: self.arg(name: "eggplant")
      ),
      body: self.identifierExpr(value: "ratatouille")
    )

    guard let code = self.compile(expr: expr) else {
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
        .loadConst(string: "<lambda>"),
        .makeFunction(flags: []),
        .return
      ],
      childCodeObjectCount: 1
    )

    guard let lambdaCode = code.getChildCodeObject(atIndex: 0) else {
      return
    }

    XCTAssertCodeObject(
      lambdaCode,
      name: "<lambda>",
      qualifiedName: "<lambda>",
      kind: .lambda,
      flags: [.nested, .newLocals, .optimized, .varArgs, .varKeywords],
      instructions: [
        .loadGlobal(name: "ratatouille"),
        .return
      ],
      argCount: 1,
      kwOnlyArgCount: 1
    )
  }
}
