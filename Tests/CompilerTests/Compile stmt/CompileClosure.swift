import XCTest
import VioletCore
import VioletParser
import VioletBytecode
@testable import VioletCompiler

// swiftlint:disable function_body_length

/// Use 'Scripts/dump_dis.py' for reference.
class CompileClosureTests: CompileTestCase {

  // MARK: - Load

  /// def sing():
  ///     lyrics = 'Under the sea'
  ///
  ///     def sing_loud():
  ///         nonlocal lyrics
  ///         lyrics
  ///
  ///  0 LOAD_CONST               0 (<code object sing at 0x10e6f2810, file "<dis>", line 1>)
  ///  2 LOAD_CONST               1 ('sing')
  ///  4 MAKE_FUNCTION            0
  ///  6 STORE_NAME               0 (sing)
  ///  8 LOAD_CONST               2 (None)
  /// 10 RETURN_VALUE
  /// f <code object sing at 0x10e6f2810, file "<dis>", line 1>:
  ///  0 LOAD_CONST               1 ('Under the sea')
  ///  2 STORE_DEREF              0 (lyrics)
  ///  4 LOAD_CLOSURE             0 (lyrics)
  ///  6 BUILD_TUPLE              1
  ///  8 LOAD_CONST               2 (<code object sing_loud at 0x10e6f2780, file "<dis>", line 4>)
  /// 10 LOAD_CONST               3 ('sing.<locals>.sing_loud')
  /// 12 MAKE_FUNCTION            8
  /// 14 STORE_FAST               0 (sing_loud)
  /// 16 LOAD_CONST               0 (None)
  /// 18 RETURN_VALUE
  /// f <code object sing_loud at 0x10e6f2780, file "<dis>", line 4>:
  ///  0 LOAD_DEREF               0 (lyrics)
  ///  2 POP_TOP
  ///  4 LOAD_CONST               0 (None)
  ///  6 RETURN_VALUE
  func test_nonlocal_inNestedFunction_load() {
    let stmt = self.functionDefStmt(
      name: "sing",
      args: self.arguments(),
      body: [
        self.assignStmt(
          targets: [
            self.identifierExpr(value: "lyrics", context: .store)
          ],
          value: self.stringExpr(value: .literal("Under the sea"))
        ),
        self.functionDefStmt(
          name: "sing_loud",
          args: self.arguments(),
          body: [
            self.nonlocalStmt(identifier: "lyrics"),
            self.identifierStmt(value: "lyrics")
          ]
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
        .loadConst(codeObject: .any),
        .loadConst(string: "sing"),
        .makeFunction(flags: []),
        .storeName(name: "sing"),
        .loadConst(.none),
        .return
      ],
      childCodeObjectCount: 1
    )

    guard let outerFunctionCode = code.getChildCodeObject(atIndex: 0) else {
      return
    }

    XCTAssertCodeObject(
      outerFunctionCode,
      name: "sing",
      qualifiedName: "sing",
      kind: .function,
      flags: [.nested, .newLocals, .optimized],
      instructions: [
        .loadConst(string: "Under the sea"),
        .storeCell(cell: MangledName(withoutClass: "lyrics")),
        .loadClosure(cellOrFree: MangledName(withoutClass: "lyrics")),
        .buildTuple(elementCount: 1),
        .loadConst(codeObject: .any),
        .loadConst(string: "sing.<locals>.sing_loud"),
        .makeFunction(flags: [.hasFreeVariables]),
        .storeFast(variable: MangledName(withoutClass: "sing_loud")),
        .loadConst(.none),
        .return
      ],
      childCodeObjectCount: 1
    )

    guard let innerFunctionCode = outerFunctionCode.getChildCodeObject(atIndex: 0) else {
      return
    }

    XCTAssertCodeObject(
      innerFunctionCode,
      name: "sing_loud",
      qualifiedName: "sing.<locals>.sing_loud",
      kind: .function,
      flags: [.nested, .newLocals, .optimized],
      instructions: [
        .loadFree(free: MangledName(withoutClass: "lyrics")),
        .popTop,
        .loadConst(.none),
        .return
      ]
    )
  }

  // MARK: - Store

  /// def sing():
  ///     lyrics = 'Under the sea'
  ///
  ///     def sing_loud():
  ///         nonlocal lyrics
  ///         lyrics = 'Part Of Your World'
  ///
  ///  0 LOAD_CONST               0 (<code object sing at 0x103216810, file "<dis>", line 1>)
  ///  2 LOAD_CONST               1 ('sing')
  ///  4 MAKE_FUNCTION            0
  ///  6 STORE_NAME               0 (sing)
  ///  8 LOAD_CONST               2 (None)
  /// 10 RETURN_VALUE
  /// f <code object sing at 0x103216810, file "<dis>", line 1>:
  ///  0 LOAD_CONST               1 ('Under the sea')
  ///  2 STORE_DEREF              0 (lyrics)
  ///  4 LOAD_CLOSURE             0 (lyrics)
  ///  6 BUILD_TUPLE              1
  ///  8 LOAD_CONST               2 (<code object sing_loud at 0x103216780, file "<dis>", line 4>)
  /// 10 LOAD_CONST               3 ('sing.<locals>.sing_loud')
  /// 12 MAKE_FUNCTION            8
  /// 14 STORE_FAST               0 (sing_loud)
  /// 16 LOAD_CONST               0 (None)
  /// 18 RETURN_VALUE
  /// f <code object sing_loud at 0x103216780, file "<dis>", line 4>:
  ///  0 LOAD_CONST               1 ('Part Of Your World')
  ///  2 STORE_DEREF              0 (lyrics)
  ///  4 LOAD_CONST               0 (None)
  ///  6 RETURN_VALUE
  func test_nonlocal_inNestedFunction_store() {
    let stmt = self.functionDefStmt(
      name: "sing",
      args: self.arguments(),
      body: [
        self.assignStmt(
          targets: [
            self.identifierExpr(value: "lyrics", context: .store)
          ],
          value: self.stringExpr(value: .literal("Under the sea"))
        ),
        self.functionDefStmt(
          name: "sing_loud",
          args: self.arguments(),
          body: [
            self.nonlocalStmt(identifier: "lyrics"),
            self.assignStmt(
              targets: [
                self.identifierExpr(value: "lyrics", context: .store)
              ],
              value: self.stringExpr(value: .literal("Part Of Your World"))
            )
          ]
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
        .loadConst(codeObject: .any),
        .loadConst(string: "sing"),
        .makeFunction(flags: []),
        .storeName(name: "sing"),
        .loadConst(.none),
        .return
      ],
      childCodeObjectCount: 1
    )

    guard let outerFunctionCode = code.getChildCodeObject(atIndex: 0) else {
      return
    }

    XCTAssertCodeObject(
      outerFunctionCode,
      name: "sing",
      qualifiedName: "sing",
      kind: .function,
      flags: [.nested, .newLocals, .optimized],
      instructions: [
        .loadConst(string: "Under the sea"),
        .storeCell(cell: MangledName(withoutClass: "lyrics")),
        .loadClosure(cellOrFree: MangledName(withoutClass: "lyrics")),
        .buildTuple(elementCount: 1),
        .loadConst(codeObject: .any),
        .loadConst(string: "sing.<locals>.sing_loud"),
        .makeFunction(flags: [.hasFreeVariables]),
        .storeFast(variable: MangledName(withoutClass: "sing_loud")),
        .loadConst(.none),
        .return
      ],
      childCodeObjectCount: 1
    )

    guard let innerFunctionCode = outerFunctionCode.getChildCodeObject(atIndex: 0) else {
      return
    }

    XCTAssertCodeObject(
      innerFunctionCode,
      name: "sing_loud",
      qualifiedName: "sing.<locals>.sing_loud",
      kind: .function,
      flags: [.nested, .newLocals, .optimized],
      instructions: [
        .loadConst(string: "Part Of Your World"),
        .storeFree(free: MangledName(withoutClass: "lyrics")),
        .loadConst(.none),
        .return
      ]
    )
  }

  // MARK: - Del

  /// def sing():
  ///     lyrics = 'Under the sea'
  ///
  ///     def sing_loud():
  ///         nonlocal lyrics
  ///         del lyrics
  ///
  ///  0 LOAD_CONST               0 (<code object sing at 0x104951810, file "<dis>", line 1>)
  ///  2 LOAD_CONST               1 ('sing')
  ///  4 MAKE_FUNCTION            0
  ///  6 STORE_NAME               0 (sing)
  ///  8 LOAD_CONST               2 (None)
  /// 10 RETURN_VALUE
  /// f <code object sing at 0x104951810, file "<dis>", line 1>:
  ///  0 LOAD_CONST               1 ('Under the sea')
  ///  2 STORE_DEREF              0 (lyrics)
  ///  4 LOAD_CLOSURE             0 (lyrics)
  ///  6 BUILD_TUPLE              1
  ///  8 LOAD_CONST               2 (<code object sing_loud at 0x104951780, file "<dis>", line 4>)
  /// 10 LOAD_CONST               3 ('sing.<locals>.sing_loud')
  /// 12 MAKE_FUNCTION            8
  /// 14 STORE_FAST               0 (sing_loud)
  /// 16 LOAD_CONST               0 (None)
  /// 18 RETURN_VALUE
  /// f <code object sing_loud at 0x104951780, file "<dis>", line 4>:
  ///  0 DELETE_DEREF             0 (lyrics)
  ///  2 LOAD_CONST               0 (None)
  ///  4 RETURN_VALUE
  func test_nonlocal_inNestedFunction_del() {
    let stmt = self.functionDefStmt(
      name: "sing",
      args: self.arguments(),
      body: [
        self.assignStmt(
          targets: [
            self.identifierExpr(value: "lyrics", context: .store)
          ],
          value: self.stringExpr(value: .literal("Under the sea"))
        ),
        self.functionDefStmt(
          name: "sing_loud",
          args: self.arguments(),
          body: [
            self.nonlocalStmt(identifier: "lyrics"),
            self.deleteStmt(
              values: [
                self.identifierExpr(value: "lyrics", context: .del)
              ]
            )
          ]
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
        .loadConst(codeObject: .any),
        .loadConst(string: "sing"),
        .makeFunction(flags: []),
        .storeName(name: "sing"),
        .loadConst(.none),
        .return
      ],
      childCodeObjectCount: 1
    )

    guard let outerFunctionCode = code.getChildCodeObject(atIndex: 0) else {
      return
    }

    XCTAssertCodeObject(
      outerFunctionCode,
      name: "sing",
      qualifiedName: "sing",
      kind: .function,
      flags: [.nested, .newLocals, .optimized],
      instructions: [
        .loadConst(string: "Under the sea"),
        .storeCell(cell: MangledName(withoutClass: "lyrics")),
        .loadClosure(cellOrFree: MangledName(withoutClass: "lyrics")),
        .buildTuple(elementCount: 1),
        .loadConst(codeObject: .any),
        .loadConst(string: "sing.<locals>.sing_loud"),
        .makeFunction(flags: [.hasFreeVariables]),
        .storeFast(variable: MangledName(withoutClass: "sing_loud")),
        .loadConst(.none),
        .return
      ],
      childCodeObjectCount: 1
    )

    guard let innerFunctionCode = outerFunctionCode.getChildCodeObject(atIndex: 0) else {
      return
    }

    XCTAssertCodeObject(
      innerFunctionCode,
      name: "sing_loud",
      qualifiedName: "sing.<locals>.sing_loud",
      kind: .function,
      flags: [.nested, .newLocals, .optimized],
      instructions: [
        .deleteFree(free: MangledName(withoutClass: "lyrics")),
        .loadConst(.none),
        .return
      ]
    )
  }

  // MARK: - Load __class__

  /// class Princess:
  ///     def sing():
  ///         __class__
  ///
  ///  0 LOAD_BUILD_CLASS
  ///  2 LOAD_CONST               0 (<code object Princess at 0x10cc9b810, file "<dis>", line 1>)
  ///  4 LOAD_CONST               1 ('Princess')
  ///  6 MAKE_FUNCTION            0
  ///  8 LOAD_CONST               1 ('Princess')
  /// 10 CALL_FUNCTION            2
  /// 12 STORE_NAME               0 (Princess)
  /// 14 LOAD_CONST               2 (None)
  /// 16 RETURN_VALUE
  /// f <code object Princess at 0x10cc9b810, file "<dis>", line 1>:
  ///  0 LOAD_NAME                0 (__name__)
  ///  2 STORE_NAME               1 (__module__)
  ///  4 LOAD_CONST               0 ('Princess')
  ///  6 STORE_NAME               2 (__qualname__)
  ///  8 LOAD_CLOSURE             0 (__class__)
  /// 10 BUILD_TUPLE              1
  /// 12 LOAD_CONST               1 (<code object sing at 0x10cc9b780, file "<dis>", line 2>)
  /// 14 LOAD_CONST               2 ('Princess.sing')
  /// 16 MAKE_FUNCTION            8
  /// 18 STORE_NAME               3 (sing)
  /// 20 LOAD_CLOSURE             0 (__class__)
  /// 22 DUP_TOP
  /// 24 STORE_NAME               4 (__classcell__)
  /// 26 RETURN_VALUE
  /// f <code object sing at 0x10cc9b780, file "<dis>", line 2>:
  ///  0 LOAD_DEREF               0 (__class__)
  ///  2 POP_TOP
  ///  4 LOAD_CONST               0 (None)
  ///  6 RETURN_VALUE
  func test__class__inNestedFunction_load() {
    let stmt = self.classDefStmt(
      name: "Princess",
      bases: [],
      keywords: [],
      body: [
        self.functionDefStmt(
          name: "sing",
          args: self.arguments(),
          body: [
            self.identifierStmt(value: "__class__")
          ]
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
        .loadBuildClass,
        .loadConst(codeObject: .any),
        .loadConst(string: "Princess"),
        .makeFunction(flags: []),
        .loadConst(string: "Princess"),
        .callFunction(argumentCount: 2),
        .storeName(name: "Princess"),
        .loadConst(.none),
        .return
      ],
      childCodeObjectCount: 1
    )

    guard let outerFunctionCode = code.getChildCodeObject(atIndex: 0) else {
      return
    }

    XCTAssertCodeObject(
      outerFunctionCode,
      name: "Princess",
      qualifiedName: "Princess",
      kind: .class,
      flags: [],
      instructions: [
        .loadName(name: "__name__"),
        .storeName(name: "__module__"),
        .loadConst(string: "Princess"),
        .storeName(name: "__qualname__"),
        .loadClosure(cellOrFree: MangledName(withoutClass: "__class__")),
        .buildTuple(elementCount: 1),
        .loadConst(codeObject: .any),
        .loadConst(string: "Princess.sing"),
        .makeFunction(flags: [.hasFreeVariables]),
        .storeName(name: "sing"),
        .loadClosure(cellOrFree: MangledName(withoutClass: "__class__")),
        .dupTop,
        .storeName(name: "__classcell__"),
        .return
      ],
      childCodeObjectCount: 1
    )

    guard let innerFunctionCode = outerFunctionCode.getChildCodeObject(atIndex: 0) else {
      return
    }

    XCTAssertCodeObject(
      innerFunctionCode,
      name: "sing",
      qualifiedName: "Princess.sing",
      kind: .function,
      flags: [.nested, .newLocals, .optimized],
      instructions: [
        .loadFree(free: MangledName(withoutClass: "__class__")),
        .popTop,
        .loadConst(.none),
        .return
      ]
    )
  }
}
