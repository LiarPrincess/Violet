import XCTest
import Core
import Parser
import Bytecode
@testable import Compiler

// swiftlint:disable function_body_length
// swiftlint:disable file_length

/// Use 'Scripts/dump_dis.py' for reference.
class CompileClassDef: XCTestCase, CommonCompiler {

  // MARK: - No base

  /// class Princess: sing
  ///
  ///  0 LOAD_BUILD_CLASS
  ///  2 LOAD_CONST               0 (<code object Princess at 0x10b18a930, file "<dis>", line 2>)
  ///  4 LOAD_CONST               1 ('Princess')
  ///  6 MAKE_FUNCTION            0
  ///  8 LOAD_CONST               1 ('Princess')
  /// 10 CALL_FUNCTION            2
  /// 12 STORE_NAME               0 (Princess)
  /// 14 LOAD_CONST               2 (None)
  /// 16 RETURN_VALUE
  /// f <code object Princess at 0x10b18a930, file "<dis>", line 2>:
  ///  0 LOAD_NAME                0 (__name__)
  ///  2 STORE_NAME               1 (__module__)
  ///  4 LOAD_CONST               0 ('Princess')
  ///  6 STORE_NAME               2 (__qualname__)
  ///  8 LOAD_NAME                3 (sing)
  /// 10 POP_TOP
  /// 12 LOAD_CONST               1 (None)
  /// 14 RETURN_VALUE
  func test_noBase() {
    let stmt = self.class(
      name: "Princess",
      bases: [],
      keywords: [],
      body: [self.identifierStmt("sing")]
    )

    let expected: [EmittedInstruction] = [
      .init(.loadBuildClass),
      .init(.loadConst, "<code object Princess>"),
      .init(.loadConst, "'Princess'"),
      .init(.makeFunction, "0"),
      .init(.loadConst, "'Princess'"),
      .init(.callFunction, "2"),
      .init(.storeName, "Princess"),
      .init(.loadConst, "none"),
      .init(.return)
    ]

    let classExpected: [EmittedInstruction] = [
      .init(.loadName, "__name__"),
      .init(.storeName, "__module__"),
      .init(.loadConst, "'Princess'"),
      .init(.storeName, "__qualname__"),
      .init(.loadName, "sing"),
      .init(.popTop),
      .init(.loadConst, "none"),
      .init(.return)
    ]

    if let code = self.compile(stmt: stmt) {
      XCTAssertCode(code, name: "<module>", qualified: "", type: .module)
      XCTAssertInstructions(code, expected)

      if let cls = self.getCodeObject(parent: code, qualifiedName: "Princess") {
        XCTAssertCode(cls, name: "Princess", type: .class)
        XCTAssertInstructions(cls, classExpected)
      }
    }
  }

  // MARK: - Bases

  /// class Aurora(Princess): sleep
  ///
  ///  0 LOAD_BUILD_CLASS
  ///  2 LOAD_CONST               0 (<code object Aurora at 0x10a7b6930, file "<dis>", line 2>)
  ///  4 LOAD_CONST               1 ('Aurora')
  ///  6 MAKE_FUNCTION            0
  ///  8 LOAD_CONST               1 ('Aurora')
  /// 10 LOAD_NAME                0 (Princess)
  /// 12 CALL_FUNCTION            3
  /// 14 STORE_NAME               1 (Aurora)
  /// 16 LOAD_CONST               2 (None)
  /// 18 RETURN_VALUE
  /// f <code object Aurora at 0x10a7b6930, file "<dis>", line 2>:
  ///  0 LOAD_NAME                0 (__name__)
  ///  2 STORE_NAME               1 (__module__)
  ///  4 LOAD_CONST               0 ('Aurora')
  ///  6 STORE_NAME               2 (__qualname__)
  ///  8 LOAD_NAME                3 (sleep)
  /// 10 POP_TOP
  /// 12 LOAD_CONST               1 (None)
  /// 14 RETURN_VALUE
  func test_base_single() {
    let stmt = self.class(
      name: "Aurora",
      bases: [self.identifierExpr("Princess")],
      keywords: [],
      body: [self.identifierStmt("sleep")]
    )

    let expected: [EmittedInstruction] = [
      .init(.loadBuildClass),
      .init(.loadConst, "<code object Aurora>"),
      .init(.loadConst, "'Aurora'"),
      .init(.makeFunction, "0"),
      .init(.loadConst, "'Aurora'"),
      .init(.loadName, "Princess"),
      .init(.callFunction, "3"),
      .init(.storeName, "Aurora"),
      .init(.loadConst, "none"),
      .init(.return)
    ]

    let classExpected: [EmittedInstruction] = [
      .init(.loadName, "__name__"),
      .init(.storeName, "__module__"),
      .init(.loadConst, "'Aurora'"),
      .init(.storeName, "__qualname__"),
      .init(.loadName, "sleep"),
      .init(.popTop),
      .init(.loadConst, "none"),
      .init(.return)
    ]

    if let code = self.compile(stmt: stmt) {
      XCTAssertCode(code, name: "<module>", qualified: "", type: .module)
      XCTAssertInstructions(code, expected)

      if let cls = self.getCodeObject(parent: code, qualifiedName: "Aurora") {
        XCTAssertCode(cls, name: "Aurora", type: .class)
        XCTAssertInstructions(cls, classExpected)
      }
    }
  }

  /// class Aurora(Princess, Human): sleep
  ///
  ///  0 LOAD_BUILD_CLASS
  ///  2 LOAD_CONST               0 (<code object Aurora at 0x106038930, file "<dis>", line 2>)
  ///  4 LOAD_CONST               1 ('Aurora')
  ///  6 MAKE_FUNCTION            0
  ///  8 LOAD_CONST               1 ('Aurora')
  /// 10 LOAD_NAME                0 (Princess)
  /// 12 LOAD_NAME                1 (Human)
  /// 14 CALL_FUNCTION            4
  /// 16 STORE_NAME               2 (Aurora)
  /// 18 LOAD_CONST               2 (None)
  /// 20 RETURN_VALUE
  /// f <code object Aurora at 0x106038930, file "<dis>", line 2>:
  ///  0 LOAD_NAME                0 (__name__)
  ///  2 STORE_NAME               1 (__module__)
  ///  4 LOAD_CONST               0 ('Aurora')
  ///  6 STORE_NAME               2 (__qualname__)
  ///  8 LOAD_NAME                3 (sleep)
  /// 10 POP_TOP
  /// 12 LOAD_CONST               1 (None)
  /// 14 RETURN_VALUE
  func test_base_multiple() {
    let stmt = self.class(
      name: "Aurora",
      bases: [self.identifierExpr("Princess"), self.identifierExpr("Human")],
      keywords: [],
      body: [self.identifierStmt("sleep")]
    )

    let expected: [EmittedInstruction] = [
      .init(.loadBuildClass),
      .init(.loadConst, "<code object Aurora>"),
      .init(.loadConst, "'Aurora'"),
      .init(.makeFunction, "0"),
      .init(.loadConst, "'Aurora'"),
      .init(.loadName, "Princess"),
      .init(.loadName, "Human"),
      .init(.callFunction, "4"),
      .init(.storeName, "Aurora"),
      .init(.loadConst, "none"),
      .init(.return)
    ]

    let classExpected: [EmittedInstruction] = [
      .init(.loadName, "__name__"),
      .init(.storeName, "__module__"),
      .init(.loadConst, "'Aurora'"),
      .init(.storeName, "__qualname__"),
      .init(.loadName, "sleep"),
      .init(.popTop),
      .init(.loadConst, "none"),
      .init(.return)
    ]

    if let code = self.compile(stmt: stmt) {
      XCTAssertCode(code, name: "<module>", qualified: "", type: .module)
      XCTAssertInstructions(code, expected)

      if let cls = self.getCodeObject(parent: code, qualifiedName: "Aurora") {
        XCTAssertCode(cls, name: "Aurora", type: .class)
        XCTAssertInstructions(cls, classExpected)
      }
    }
  }

  // MARK: - Base - star

  ///  0 LOAD_BUILD_CLASS
  ///  2 LOAD_CONST               0 (<code object Aurora at 0x106885930, file "<dis>", line 2>)
  ///  4 LOAD_CONST               1 ('Aurora')
  ///  6 MAKE_FUNCTION            0
  ///  8 LOAD_CONST               1 ('Aurora')
  /// 10 BUILD_TUPLE              2
  /// 12 LOAD_NAME                0 (Princess)
  /// 14 BUILD_TUPLE_UNPACK_WITH_CALL     2
  /// 16 CALL_FUNCTION_EX         0
  /// 18 STORE_NAME               1 (Aurora)
  /// 20 LOAD_CONST               2 (None)
  /// 22 RETURN_VALUE
  /// f <code object Aurora at 0x106885930, file "<dis>", line 2>:
  ///  0 LOAD_NAME                0 (__name__)
  ///  2 STORE_NAME               1 (__module__)
  ///  4 LOAD_CONST               0 ('Aurora')
  ///  6 STORE_NAME               2 (__qualname__)
  ///  8 LOAD_NAME                3 (sleep)
  /// 10 POP_TOP
  /// 12 LOAD_CONST               1 (None)
  /// 14 RETURN_VALUE
  func test_base_withStar() {
    let stmt = self.class(
      name: "Aurora",
      bases: [self.expression(.starred(self.identifierExpr("Princess")))],
      keywords: [],
      body: [self.identifierStmt("sleep")]
    )

    let expected: [EmittedInstruction] = [
      .init(.loadBuildClass),
      .init(.loadConst, "<code object Aurora>"),
      .init(.loadConst, "'Aurora'"),
      .init(.makeFunction, "0"),
      .init(.loadConst, "'Aurora'"),
      .init(.buildTuple, "2"),
      .init(.loadName, "Princess"),
      .init(.buildTupleUnpackWithCall, "2"),
      .init(.callFunctionEx, "0"),
      .init(.storeName, "Aurora"),
      .init(.loadConst, "none"),
      .init(.return)
    ]

    let classExpected: [EmittedInstruction] = [
      .init(.loadName, "__name__"),
      .init(.storeName, "__module__"),
      .init(.loadConst, "'Aurora'"),
      .init(.storeName, "__qualname__"),
      .init(.loadName, "sleep"),
      .init(.popTop),
      .init(.loadConst, "none"),
      .init(.return)
    ]

    if let code = self.compile(stmt: stmt) {
      XCTAssertCode(code, name: "<module>", qualified: "", type: .module)
      XCTAssertInstructions(code, expected)

      if let cls = self.getCodeObject(parent: code, qualifiedName: "Aurora") {
        XCTAssertCode(cls, name: "Aurora", type: .class)
        XCTAssertInstructions(cls, classExpected)
      }
    }
  }

  /// class Aurora(Princess=1, *Human): sleep
  ///
  ///  0 LOAD_BUILD_CLASS
  ///  2 LOAD_CONST               0 (<code object Aurora at 0x103aec930, file "<dis>", line 2>)
  ///  4 LOAD_CONST               1 ('Aurora')
  ///  6 MAKE_FUNCTION            0
  ///  8 LOAD_CONST               1 ('Aurora')
  /// 10 BUILD_TUPLE              2
  /// 12 LOAD_NAME                0 (Human)
  /// 14 BUILD_TUPLE_UNPACK_WITH_CALL     2
  /// 16 LOAD_CONST               2 ('Princess')
  /// 18 LOAD_CONST               3 (1)
  /// 20 BUILD_MAP                1
  /// 22 CALL_FUNCTION_EX         1
  /// 24 STORE_NAME               1 (Aurora)
  /// 26 LOAD_CONST               4 (None)
  /// 28 RETURN_VALUE
  /// f <code object Aurora at 0x103aec930, file "<dis>", line 2>:
  ///  0 LOAD_NAME                0 (__name__)
  ///  2 STORE_NAME               1 (__module__)
  ///  4 LOAD_CONST               0 ('Aurora')
  ///  6 STORE_NAME               2 (__qualname__)
  ///  8 LOAD_NAME                3 (sleep)
  /// 10 POP_TOP
  /// 12 LOAD_CONST               1 (None)
  /// 14 RETURN_VALUE
  func test_base_withStar_afterKeyword() {
    let stmt = self.class(
      name: "Aurora",
      bases: [self.expression(.starred(self.identifierExpr("Human")))],
      keywords: [
        self.keyword(
          kind: .named("Princess"),
          value: self.expression(.int(BigInt(1)))
        )
      ],
      body: [self.identifierStmt("sleep")]
    )

    let expected: [EmittedInstruction] = [
      .init(.loadBuildClass),
      .init(.loadConst, "<code object Aurora>"),
      .init(.loadConst, "'Aurora'"),
      .init(.makeFunction, "0"),
      .init(.loadConst, "'Aurora'"),
      .init(.buildTuple, "2"),
      .init(.loadName, "Human"),
      .init(.buildTupleUnpackWithCall, "2"),
      .init(.loadConst, "'Princess'"),
      .init(.loadConst, "1"),
      .init(.buildMap, "1"),
      .init(.callFunctionEx, "1"),
      .init(.storeName, "Aurora"),
      .init(.loadConst, "none"),
      .init(.return)
    ]

    let classExpected: [EmittedInstruction] = [
      .init(.loadName, "__name__"),
      .init(.storeName, "__module__"),
      .init(.loadConst, "'Aurora'"),
      .init(.storeName, "__qualname__"),
      .init(.loadName, "sleep"),
      .init(.popTop),
      .init(.loadConst, "none"),
      .init(.return)
    ]

    if let code = self.compile(stmt: stmt) {
      XCTAssertCode(code, name: "<module>", qualified: "", type: .module)
      XCTAssertInstructions(code, expected)

      if let cls = self.getCodeObject(parent: code, qualifiedName: "Aurora") {
        XCTAssertCode(cls, name: "Aurora", type: .class)
        XCTAssertInstructions(cls, classExpected)
      }
    }
  }

  // MARK: - Keyword

  /// class Aurora(Princess=1): sleep
  ///
  ///  0 LOAD_BUILD_CLASS
  ///  2 LOAD_CONST               0 (<code object Aurora at 0x106c29930, file "<dis>", line 2>)
  ///  4 LOAD_CONST               1 ('Aurora')
  ///  6 MAKE_FUNCTION            0
  ///  8 LOAD_CONST               1 ('Aurora')
  /// 10 LOAD_CONST               2 (1)
  /// 12 LOAD_CONST               3 (('Princess',))
  /// 14 CALL_FUNCTION_KW         3
  /// 16 STORE_NAME               0 (Aurora)
  /// 18 LOAD_CONST               4 (None)
  /// 20 RETURN_VALUE
  /// f <code object Aurora at 0x106c29930, file "<dis>", line 2>:
  ///  0 LOAD_NAME                0 (__name__)
  ///  2 STORE_NAME               1 (__module__)
  ///  4 LOAD_CONST               0 ('Aurora')
  ///  6 STORE_NAME               2 (__qualname__)
  ///  8 LOAD_NAME                3 (sleep)
  /// 10 POP_TOP
  /// 12 LOAD_CONST               1 (None)
  /// 14 RETURN_VALUE
  func test_keyword_single() {
    let stmt = self.class(
      name: "Aurora",
      bases: [],
      keywords: [
        self.keyword(kind: .named("Princess"), value: self.expression(.int(BigInt(1))))
      ],
      body: [self.identifierStmt("sleep")]
    )

    let expected: [EmittedInstruction] = [
      .init(.loadBuildClass),
      .init(.loadConst, "<code object Aurora>"),
      .init(.loadConst, "'Aurora'"),
      .init(.makeFunction, "0"),
      .init(.loadConst, "'Aurora'"),
      .init(.loadConst, "1"),
      .init(.loadConst, "('Princess')"),
      .init(.callFunctionKw, "3"),
      .init(.storeName, "Aurora"),
      .init(.loadConst, "none"),
      .init(.return)
    ]

    let classExpected: [EmittedInstruction] = [
      .init(.loadName, "__name__"),
      .init(.storeName, "__module__"),
      .init(.loadConst, "'Aurora'"),
      .init(.storeName, "__qualname__"),
      .init(.loadName, "sleep"),
      .init(.popTop),
      .init(.loadConst, "none"),
      .init(.return)
    ]

    if let code = self.compile(stmt: stmt) {
      XCTAssertCode(code, name: "<module>", qualified: "", type: .module)
      XCTAssertInstructions(code, expected)

      if let cls = self.getCodeObject(parent: code, qualifiedName: "Aurora") {
        XCTAssertCode(cls, name: "Aurora", type: .class)
        XCTAssertInstructions(cls, classExpected)
      }
    }
  }

  /// class Aurora(Princess=1, Human=2): sleep
  ///
  ///  0 LOAD_BUILD_CLASS
  ///  2 LOAD_CONST               0 (<code object Aurora at 0x10bcbe930, file "<dis>", line 2>)
  ///  4 LOAD_CONST               1 ('Aurora')
  ///  6 MAKE_FUNCTION            0
  ///  8 LOAD_CONST               1 ('Aurora')
  /// 10 LOAD_CONST               2 (1)
  /// 12 LOAD_CONST               3 (2)
  /// 14 LOAD_CONST               4 (('Princess', 'Human'))
  /// 16 CALL_FUNCTION_KW         4
  /// 18 STORE_NAME               0 (Aurora)
  /// 20 LOAD_CONST               5 (None)
  /// 22 RETURN_VALUE
  /// f <code object Aurora at 0x10bcbe930, file "<dis>", line 2>:
  ///  0 LOAD_NAME                0 (__name__)
  ///  2 STORE_NAME               1 (__module__)
  ///  4 LOAD_CONST               0 ('Aurora')
  ///  6 STORE_NAME               2 (__qualname__)
  ///  8 LOAD_NAME                3 (sleep)
  /// 10 POP_TOP
  /// 12 LOAD_CONST               1 (None)
  /// 14 RETURN_VALUE
  func test_keyword_multiple() {
    let stmt = self.class(
      name: "Aurora",
      bases: [],
      keywords: [
        self.keyword(kind: .named("Princess"), value: self.expression(.int(BigInt(1)))),
        self.keyword(kind: .named("Human"),    value: self.expression(.int(BigInt(2))))
      ],
      body: [self.identifierStmt("sleep")]
    )

    let expected: [EmittedInstruction] = [
      .init(.loadBuildClass),
      .init(.loadConst, "<code object Aurora>"),
      .init(.loadConst, "'Aurora'"),
      .init(.makeFunction, "0"),
      .init(.loadConst, "'Aurora'"),
      .init(.loadConst, "1"),
      .init(.loadConst, "2"),
      .init(.loadConst, "('Princess', 'Human')"),
      .init(.callFunctionKw, "4"),
      .init(.storeName, "Aurora"),
      .init(.loadConst, "none"),
      .init(.return)
    ]

    let classExpected: [EmittedInstruction] = [
      .init(.loadName, "__name__"),
      .init(.storeName, "__module__"),
      .init(.loadConst, "'Aurora'"),
      .init(.storeName, "__qualname__"),
      .init(.loadName, "sleep"),
      .init(.popTop),
      .init(.loadConst, "none"),
      .init(.return)
    ]

    if let code = self.compile(stmt: stmt) {
      XCTAssertCode(code, name: "<module>", qualified: "", type: .module)
      XCTAssertInstructions(code, expected)

      if let cls = self.getCodeObject(parent: code, qualifiedName: "Aurora") {
        XCTAssertCode(cls, name: "Aurora", type: .class)
        XCTAssertInstructions(cls, classExpected)
      }
    }
  }

  // MARK: - Keyword - star star

  /// class Aurora(**Princess): sleep
  ///
  ///  0 LOAD_BUILD_CLASS
  ///  2 LOAD_CONST               0 (<code object Aurora at 0x10d2cd930, file "<dis>", line 2>)
  ///  4 LOAD_CONST               1 ('Aurora')
  ///  6 MAKE_FUNCTION            0
  ///  8 LOAD_CONST               1 ('Aurora')
  /// 10 BUILD_TUPLE              2
  /// 12 LOAD_NAME                0 (Princess)
  /// 14 CALL_FUNCTION_EX         1
  /// 16 STORE_NAME               1 (Aurora)
  /// 18 LOAD_CONST               2 (None)
  /// 20 RETURN_VALUE
  /// f <code object Aurora at 0x10d2cd930, file "<dis>", line 2>:
  ///  0 LOAD_NAME                0 (__name__)
  ///  2 STORE_NAME               1 (__module__)
  ///  4 LOAD_CONST               0 ('Aurora')
  ///  6 STORE_NAME               2 (__qualname__)
  ///  8 LOAD_NAME                3 (sleep)
  /// 10 POP_TOP
  /// 12 LOAD_CONST               1 (None)
  /// 14 RETURN_VALUE
  func test_keyword_withStarStar() {
    let stmt = self.class(
      name: "Aurora",
      bases: [],
      keywords: [
        self.keyword(kind: .dictionaryUnpack, value: self.identifierExpr("**Princess"))
      ],
      body: [self.identifierStmt("sleep")]
    )

    let expected: [EmittedInstruction] = [
      .init(.loadBuildClass),
      .init(.loadConst, "<code object Aurora>"),
      .init(.loadConst, "'Aurora'"),
      .init(.makeFunction, "0"),
      .init(.loadConst, "'Aurora'"),
      .init(.buildTuple, "2"),
      .init(.loadName, "**Princess"),
      .init(.callFunctionEx, "1"),
      .init(.storeName, "Aurora"),
      .init(.loadConst, "none"),
      .init(.return)
    ]

    let classExpected: [EmittedInstruction] = [
      .init(.loadName, "__name__"),
      .init(.storeName, "__module__"),
      .init(.loadConst, "'Aurora'"),
      .init(.storeName, "__qualname__"),
      .init(.loadName, "sleep"),
      .init(.popTop),
      .init(.loadConst, "none"),
      .init(.return)
    ]

    if let code = self.compile(stmt: stmt) {
      XCTAssertCode(code, name: "<module>", qualified: "", type: .module)
      XCTAssertInstructions(code, expected)

      if let cls = self.getCodeObject(parent: code, qualifiedName: "Aurora") {
        XCTAssertCode(cls, name: "Aurora", type: .class)
        XCTAssertInstructions(cls, classExpected)
      }
    }
  }

  /// class Aurora(Princess, **Human): sleep
  ///
  ///  0 LOAD_BUILD_CLASS
  ///  2 LOAD_CONST               0 (<code object Aurora at 0x1089d8930, file "<dis>", line 2>)
  ///  4 LOAD_CONST               1 ('Aurora')
  ///  6 MAKE_FUNCTION            0
  ///  8 LOAD_CONST               1 ('Aurora')
  /// 10 LOAD_NAME                0 (Princess)
  /// 12 BUILD_TUPLE              3
  /// 14 LOAD_NAME                1 (Human)
  /// 16 CALL_FUNCTION_EX         1
  /// 18 STORE_NAME               2 (Aurora)
  /// 20 LOAD_CONST               2 (None)
  /// 22 RETURN_VALUE
  /// f <code object Aurora at 0x1089d8930, file "<dis>", line 2>:
  ///  0 LOAD_NAME                0 (__name__)
  ///  2 STORE_NAME               1 (__module__)
  ///  4 LOAD_CONST               0 ('Aurora')
  ///  6 STORE_NAME               2 (__qualname__)
  ///  8 LOAD_NAME                3 (sleep)
  /// 10 POP_TOP
  /// 12 LOAD_CONST               1 (None)
  /// 14 RETURN_VALUE
  func test_keyword_withStarStar_afterNormal() {
    let stmt = self.class(
      name: "Aurora",
      bases: [self.identifierExpr("Princess")],
      keywords: [
        self.keyword(kind: .dictionaryUnpack, value: self.identifierExpr("**Human"))
      ],
      body: [self.identifierStmt("sleep")]
    )

    let expected: [EmittedInstruction] = [
      .init(.loadBuildClass),
      .init(.loadConst, "<code object Aurora>"),
      .init(.loadConst, "'Aurora'"),
      .init(.makeFunction, "0"),
      .init(.loadConst, "'Aurora'"),
      .init(.loadName, "Princess"),
      .init(.buildTuple, "3"),
      .init(.loadName, "**Human"),
      .init(.callFunctionEx, "1"),
      .init(.storeName, "Aurora"),
      .init(.loadConst, "none"),
      .init(.return)
    ]

    let classExpected: [EmittedInstruction] = [
      .init(.loadName, "__name__"),
      .init(.storeName, "__module__"),
      .init(.loadConst, "'Aurora'"),
      .init(.storeName, "__qualname__"),
      .init(.loadName, "sleep"),
      .init(.popTop),
      .init(.loadConst, "none"),
      .init(.return)
    ]

    if let code = self.compile(stmt: stmt) {
      XCTAssertCode(code, name: "<module>", qualified: "", type: .module)
      XCTAssertInstructions(code, expected)

      if let cls = self.getCodeObject(parent: code, qualifiedName: "Aurora") {
        XCTAssertCode(cls, name: "Aurora", type: .class)
        XCTAssertInstructions(cls, classExpected)
      }
    }
  }
}
