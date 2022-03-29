import XCTest
import VioletCore
import VioletParser
import VioletBytecode
@testable import VioletCompiler

/// Use 'Scripts/dump_dis.py' for reference.
class CompileCall: CompileTestCase {

  // MARK: - No arguments

  /// cook()
  ///
  /// 0 LOAD_NAME                0 (cook)
  /// 2 CALL_FUNCTION            0
  /// 4 RETURN_VALUE
  func test_noArgs() {
    let expr = self.callExpr(
      function: self.identifierExpr(value: "cook"),
      args: [],
      keywords: []
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
        .loadName(name: "cook"),
        .callFunction(argumentCount: 0),
        .return
      ]
    )
  }

  // MARK: - Args

  /// cook(zucchini, tomato)
  ///
  /// 0 LOAD_NAME                0 (cook)
  /// 2 LOAD_NAME                1 (zucchini)
  /// 4 LOAD_NAME                2 (tomato)
  /// 6 CALL_FUNCTION            2
  /// 8 RETURN_VALUE
  func test_args() {
    let expr = self.callExpr(
      function: self.identifierExpr(value: "cook"),
      args: [
        self.identifierExpr(value: "zucchini"),
        self.identifierExpr(value: "tomato")
      ],
      keywords: []
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
        .loadName(name: "cook"),
        .loadName(name: "zucchini"),
        .loadName(name: "tomato"),
        .callFunction(argumentCount: 2),
        .return
      ]
    )
  }

  /// cook(zucchini, *tomato)
  ///
  ///  0 LOAD_NAME                0 (cook)
  ///  2 LOAD_NAME                1 (zucchini)
  ///  4 BUILD_TUPLE              1
  ///  6 LOAD_NAME                2 (tomato)
  ///  8 BUILD_TUPLE_UNPACK_WITH_CALL     2
  /// 10 CALL_FUNCTION_EX         0
  /// 12 RETURN_VALUE
  func test_args_unpack() {
    let expr = self.callExpr(
      function: self.identifierExpr(value: "cook"),
      args: [
        self.identifierExpr(value: "zucchini"),
        self.starredExpr(
          expression: self.identifierExpr(value: "tomato")
        )
      ],
      keywords: []
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
        .loadName(name: "cook"),
        .loadName(name: "zucchini"),
        .buildTuple(elementCount: 1),
        .loadName(name: "tomato"),
        .buildTupleUnpackWithCall(elementCount: 2),
        .callFunctionEx(hasKeywordArguments: false),
        .return
      ]
    )
  }

  /// cook(zucchini, *tomato, *pepper, eggplant)
  ///
  ///  0 LOAD_NAME                0 (cook)
  ///  2 LOAD_NAME                1 (zucchini)
  ///  4 BUILD_TUPLE              1
  ///  6 LOAD_NAME                2 (tomato)
  ///  8 LOAD_NAME                3 (pepper)
  /// 10 LOAD_NAME                4 (eggplant)
  /// 12 BUILD_TUPLE              1
  /// 14 BUILD_TUPLE_UNPACK_WITH_CALL     4
  /// 16 CALL_FUNCTION_EX         0
  /// 18 RETURN_VALUE
  func test_args_unpack_multiple() {
    let expr = self.callExpr(
      function: self.identifierExpr(value: "cook"),
      args: [
        self.identifierExpr(value: "zucchini"),
        self.starredExpr(
          expression: self.identifierExpr(value: "tomato")
        ),
        self.starredExpr(
          expression: self.identifierExpr(value: "pepper")
        ),
        self.identifierExpr(value: "eggplant")
      ],
      keywords: []
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
        .loadName(name: "cook"),
        .loadName(name: "zucchini"),
        .buildTuple(elementCount: 1),
        .loadName(name: "tomato"),
        .loadName(name: "pepper"),
        .loadName(name: "eggplant"),
        .buildTuple(elementCount: 1),
        .buildTupleUnpackWithCall(elementCount: 4),
        .callFunctionEx(hasKeywordArguments: false),
        .return
      ]
    )
  }

  // MARK: - Keywords

  /// cook(zucchini=tomato, pepper=eggplant)
  ///
  ///  0 LOAD_NAME                0 (cook)
  ///  2 LOAD_NAME                1 (tomato)
  ///  4 LOAD_NAME                2 (eggplant)
  ///  6 LOAD_CONST               0 (('zucchini', 'pepper'))
  ///  8 CALL_FUNCTION_KW         2
  /// 10 RETURN_VALUE
  func test_keyword() {
    let expr = self.callExpr(
      function: self.identifierExpr(value: "cook"),
      args: [],
      keywords: [
        self.keyword(kind: .named("zucchini"), value: self.identifierExpr(value: "tomato")),
        self.keyword(kind: .named("pepper"), value: self.identifierExpr(value: "eggplant"))
      ]
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
        .loadName(name: "cook"),
        .loadName(name: "tomato"),
        .loadName(name: "eggplant"),
        .loadConst(tuple: ["zucchini", "pepper"]),
        .callFunctionKw(argumentCount: 2),
        .return
      ]
    )
  }

  /// cook(zucchini=tomato, salt=pepper, **eggplant)
  ///
  ///  0 LOAD_NAME                0 (cook)
  ///  2 BUILD_TUPLE              0
  ///  4 LOAD_NAME                1 (tomato)
  ///  6 LOAD_NAME                2 (pepper)
  ///  8 LOAD_CONST               0 (('zucchini', 'salt'))
  /// 10 BUILD_CONST_KEY_MAP      2
  /// 12 LOAD_NAME                3 (eggplant)
  /// 14 BUILD_MAP_UNPACK_WITH_CALL     2
  /// 16 CALL_FUNCTION_EX         1
  /// 18 RETURN_VALUE
  func test_keyword_unpack() {
    let expr = self.callExpr(
      function: self.identifierExpr(value: "cook"),
      args: [],
      keywords: [
        self.keyword(kind: .named("zucchini"), value: self.identifierExpr(value: "tomato")),
        self.keyword(kind: .named("salt"), value: self.identifierExpr(value: "pepper")),
        self.keyword(kind: .dictionaryUnpack, value: self.identifierExpr(value: "eggplant"))
      ]
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
        .loadName(name: "cook"),
        .buildTuple(elementCount: 0),
        .loadName(name: "tomato"),
        .loadName(name: "pepper"),
        .loadConst(tuple: ["zucchini", "salt"]),
        .buildConstKeyMap(elementCount: 2),
        .loadName(name: "eggplant"),
        .buildMapUnpackWithCall(elementCount: 2),
        .callFunctionEx(hasKeywordArguments: true),
        .return
      ]
    )
  }

  /// cook(zucchini=tomato, **pepper, **eggplant, salt=onion)
  ///
  ///  0 LOAD_NAME                0 (cook)
  ///  2 BUILD_TUPLE              0
  ///  4 LOAD_CONST               0 ('zucchini')
  ///  6 LOAD_NAME                1 (tomato)
  ///  8 BUILD_MAP                1
  /// 10 LOAD_NAME                2 (pepper)
  /// 12 LOAD_NAME                3 (eggplant)
  /// 14 LOAD_CONST               1 ('salt')
  /// 16 LOAD_NAME                4 (onion)
  /// 18 BUILD_MAP                1
  /// 20 BUILD_MAP_UNPACK_WITH_CALL     4
  /// 22 CALL_FUNCTION_EX         1
  /// 24 RETURN_VALUE
  func test_keyword_unpack_multiple() {
    let expr = self.callExpr(
      function: self.identifierExpr(value: "cook"),
      args: [],
      keywords: [
        self.keyword(kind: .named("zucchini"), value: self.identifierExpr(value: "tomato")),
        self.keyword(kind: .dictionaryUnpack, value: self.identifierExpr(value: "pepper")),
        self.keyword(kind: .dictionaryUnpack, value: self.identifierExpr(value: "eggplant")),
        self.keyword(kind: .named("salt"), value: self.identifierExpr(value: "onion"))
      ]
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
        .loadName(name: "cook"),
        .buildTuple(elementCount: 0),
        .loadConst(string: "zucchini"),
        .loadName(name: "tomato"),
        .buildMap(elementCount: 1),
        .loadName(name: "pepper"),
        .loadName(name: "eggplant"),
        .loadConst(string: "salt"),
        .loadName(name: "onion"),
        .buildMap(elementCount: 1),
        .buildMapUnpackWithCall(elementCount: 4),
        .callFunctionEx(hasKeywordArguments: true),
        .return
      ]
    )
  }

  // MARK: - All

  // cook(zucchini, *tomato, pepper=salt, **eggplant)
  ///
  ///  0 LOAD_NAME                0 (cook)
  ///  2 LOAD_NAME                1 (zucchini)
  ///  4 BUILD_TUPLE              1
  ///  6 LOAD_NAME                2 (tomato)
  ///  8 BUILD_TUPLE_UNPACK_WITH_CALL     2
  /// 10 LOAD_CONST               0 ('pepper')
  /// 12 LOAD_NAME                3 (salt)
  /// 14 BUILD_MAP                1
  /// 16 LOAD_NAME                4 (eggplant)
  /// 18 BUILD_MAP_UNPACK_WITH_CALL     2
  /// 20 CALL_FUNCTION_EX         1
  /// 22 RETURN_VALUE
  func test_all() {
    let expr = self.callExpr(
      function: self.identifierExpr(value: "cook"),
      args: [
        self.identifierExpr(value: "zucchini"),
        self.starredExpr(
          expression: self.identifierExpr(value: "tomato")
        )
      ],
      keywords: [
        self.keyword(kind: .named("pepper"), value: self.identifierExpr(value: "salt")),
        self.keyword(kind: .dictionaryUnpack, value: self.identifierExpr(value: "eggplant"))
      ]
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
        .loadName(name: "cook"),
        .loadName(name: "zucchini"),
        .buildTuple(elementCount: 1),
        .loadName(name: "tomato"),
        .buildTupleUnpackWithCall(elementCount: 2),
        .loadConst(string: "pepper"),
        .loadName(name: "salt"),
        .buildMap(elementCount: 1),
        .loadName(name: "eggplant"),
        .buildMapUnpackWithCall(elementCount: 2),
        .callFunctionEx(hasKeywordArguments: true),
        .return
      ]
    )
  }
}
