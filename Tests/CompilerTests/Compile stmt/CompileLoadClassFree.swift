import XCTest
import VioletCore
import VioletParser
import VioletBytecode
@testable import VioletCompiler

// swiftlint:disable line_length
// swiftlint:disable function_body_length
// cSpell:ignore CLASSDEREF

// Very specific case, see 'LOAD_NAME and STORE_NAME (and LOAD_CLASSDEREF)' on:
// https://tenthousandmeters.com/blog/python-behind-the-scenes-5-how-variables-are-implemented-in-cpython/

/// Use './Scripts/dump' for reference.
class CompileLoadClassFree: CompileTestCase {

  // MARK: - Load

  /// def sing():
  ///     lyrics = 'Tale as old as time'
  ///
  ///     class Princess:
  ///         lyrics
  ///
  /// Song is: 'Tale as old as time' from 'Beauty and the beast'.
  ///
  ///  0 LOAD_CONST               0 (<code object sing at 0x106f4d030, file "<dis>", line 1>)
  ///  2 LOAD_CONST               1 ('sing')
  ///  4 MAKE_FUNCTION            0
  ///  6 STORE_NAME               0 (sing)
  ///  8 LOAD_CONST               2 (None)
  /// 10 RETURN_VALUE
  /// f <code object sing at 0x106f4d030, file "<dis>", line 1>:
  ///  0 LOAD_CONST               1 ('Tale as old as time')
  ///  2 STORE_DEREF              0 (lyrics)
  ///  4 LOAD_BUILD_CLASS
  ///  6 LOAD_CLOSURE             0 (lyrics)
  ///  8 BUILD_TUPLE              1
  /// 10 LOAD_CONST               2 (<code object Princess at 0x106f50810, file "<dis>", line 4>)
  /// 12 LOAD_CONST               3 ('Princess')
  /// 14 MAKE_FUNCTION            8
  /// 16 LOAD_CONST               3 ('Princess')
  /// 18 CALL_FUNCTION            2
  /// 20 STORE_FAST               0 (Princess)
  /// 22 LOAD_CONST               0 (None)
  /// 24 RETURN_VALUE
  /// f <code object Princess at 0x106f50810, file "<dis>", line 4>:
  ///  0 LOAD_NAME                0 (__name__)
  ///  2 STORE_NAME               1 (__module__)
  ///  4 LOAD_CONST               0 ('sing.<locals>.Princess')
  ///  6 STORE_NAME               2 (__qualname__)
  ///  8 LOAD_CLASSDEREF          0 (lyrics)
  /// 10 POP_TOP
  /// 12 LOAD_CONST               1 (None)
  /// 14 RETURN_VALUE
  func test_loadClassFree_isUsed() {
    let stmt = self.functionDefStmt(
      name: "sing",
      args: self.arguments(),
      body: [
        self.assignStmt(
          targets: [
            self.identifierExpr(value: "lyrics", context: .store)
          ],
          value: self.stringExpr(value: .literal("Tale as old as time"))
        ),
        self.classDefStmt(
          name: "Princess",
          bases: [],
          keywords: [],
          body: [
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

    guard let functionCode = code.getChildCodeObject(atIndex: 0) else {
      return
    }

    XCTAssertCodeObject(
      functionCode,
      name: "sing",
      qualifiedName: "sing",
      kind: .function,
      flags: [.nested, .newLocals, .optimized],
      instructions: [
        .loadConst(string: "Tale as old as time"),
        .storeCell(cell: MangledName(withoutClass: "lyrics")),
        .loadBuildClass,
        .loadClosure(cellOrFree: MangledName(withoutClass: "lyrics")),
        .buildTuple(elementCount: 1),
        .loadConst(codeObject: .any),
        .loadConst(string: "sing.<locals>.Princess"),
        .makeFunction(flags: [.hasFreeVariables]),
        .loadConst(string: "Princess"),
        .callFunction(argumentCount: 2),
        .storeFast(variable: MangledName(withoutClass: "Princess")),
        .loadConst(.none),
        .return
      ],
      childCodeObjectCount: 1
    )

    guard let classCode = functionCode.getChildCodeObject(atIndex: 0) else {
      return
    }

    XCTAssertCodeObject(
      classCode,
      name: "Princess",
      qualifiedName: "sing.<locals>.Princess",
      kind: .class,
      flags: [],
      instructions: [
        .loadName(name: "__name__"),
        .storeName(name: "__module__"),
        .loadConst(string: "sing.<locals>.Princess"),
        .storeName(name: "__qualname__"),
        .loadClassFree(free: MangledName(withoutClass: "lyrics")),
        .popTop,
        .loadConst(.none),
        .return
      ]
    )
  }

  // MARK: - Store

  /// def sing():
  ///     lyrics = 'Tale as old as time'
  ///
  ///     class Princess:
  ///         lyrics = 'Tune as old as song.'
  ///
  ///  0 LOAD_CONST               0 (<code object sing at 0x10bac9810, file "<dis>", line 1>)
  ///  2 LOAD_CONST               1 ('sing')
  ///  4 MAKE_FUNCTION            0
  ///  6 STORE_NAME               0 (sing)
  ///  8 LOAD_CONST               2 (None)
  /// 10 RETURN_VALUE
  /// f <code object sing at 0x10bac9810, file "<dis>", line 1>:
  ///  0 LOAD_CONST               1 ('Tale as old as time')
  ///  2 STORE_FAST               0 (lyrics)
  ///  4 LOAD_BUILD_CLASS
  ///  6 LOAD_CONST               2 (<code object Princess at 0x10bac9780, file "<dis>", line 4>)
  ///  8 LOAD_CONST               3 ('Princess')
  /// 10 MAKE_FUNCTION            0
  /// 12 LOAD_CONST               3 ('Princess')
  /// 14 CALL_FUNCTION            2
  /// 16 STORE_FAST               1 (Princess)
  /// 18 LOAD_CONST               0 (None)
  /// 20 RETURN_VALUE
  /// f <code object Princess at 0x10bac9780, file "<dis>", line 4>:
  ///  0 LOAD_NAME                0 (__name__)
  ///  2 STORE_NAME               1 (__module__)
  ///  4 LOAD_CONST               0 ('sing.<locals>.Princess')
  ///  6 STORE_NAME               2 (__qualname__)
  ///  8 LOAD_CONST               1 ('Tune as old as song.')
  /// 10 STORE_NAME               3 (lyrics)
  /// 12 LOAD_CONST               2 (None)
  /// 14 RETURN_VALUE
  func test_loadClassFree_forStore_isNotUsed() {
    let stmt = self.functionDefStmt(
      name: "sing",
      args: self.arguments(),
      body: [
        self.assignStmt(
          targets: [
            self.identifierExpr(value: "lyrics", context: .store)
          ],
          value: self.stringExpr(value: .literal("Tale as old as time"))
        ),
        self.classDefStmt(
          name: "Princess",
          bases: [],
          keywords: [],
          body: [
            self.assignStmt(
              targets: [
                self.identifierExpr(value: "lyrics", context: .store)
              ],
              value: self.stringExpr(value: .literal("Tune as old as song."))
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

    guard let functionCode = code.getChildCodeObject(atIndex: 0) else {
      return
    }

    XCTAssertCodeObject(
      functionCode,
      name: "sing",
      qualifiedName: "sing",
      kind: .function,
      flags: [.nested, .newLocals, .optimized],
      instructions: [
        .loadConst(string: "Tale as old as time"),
        .storeFast(variable: MangledName(withoutClass: "lyrics")),
        .loadBuildClass,
        .loadConst(codeObject: .any),
        .loadConst(string: "sing.<locals>.Princess"),
        .makeFunction(flags: []),
        .loadConst(string: "Princess"),
        .callFunction(argumentCount: 2),
        .storeFast(variable: MangledName(withoutClass: "Princess")),
        .loadConst(.none),
        .return
      ],
      childCodeObjectCount: 1
    )

    guard let classCode = functionCode.getChildCodeObject(atIndex: 0) else {
      return
    }

    XCTAssertCodeObject(
      classCode,
      name: "Princess",
      qualifiedName: "sing.<locals>.Princess",
      kind: .class,
      flags: [],
      instructions: [
        .loadName(name: "__name__"),
        .storeName(name: "__module__"),
        .loadConst(string: "sing.<locals>.Princess"),
        .storeName(name: "__qualname__"),
        .loadConst(string: "Tune as old as song."),
        .storeName(name: "lyrics"),
        .loadConst(.none),
        .return
      ]
    )
  }
}
