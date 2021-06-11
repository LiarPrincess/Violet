import XCTest
import VioletCore
import VioletParser
import VioletBytecode
@testable import VioletCompiler

// swiftlint:disable function_body_length

/// Use './Scripts/dump' for reference.
class CompileWith: CompileTestCase {

  /// with alice: wonderland
  ///
  ///  0 LOAD_NAME                0 (alice)
  ///  2 SETUP_WITH              10 (to 14)
  ///  4 POP_TOP
  ///  6 LOAD_NAME                1 (wonderland)
  ///  8 POP_TOP
  /// 10 POP_BLOCK
  /// 12 LOAD_CONST               0 (None)
  /// 14 WITH_CLEANUP_START
  /// 16 WITH_CLEANUP_FINISH
  /// 18 END_FINALLY
  /// 20 LOAD_CONST               0 (None)
  /// 22 RETURN_VALUE
  func test_simple() {
    let stmt = self.withStmt(
      items: [
        self.withItem(
          contextExpr: self.identifierExpr(value: "alice"),
          optionalVars: nil
        )
      ],
      body: [self.identifierStmt(value: "wonderland")]
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
        .loadName(name: "alice"),
        .setupWith(afterBodyTarget: 14),
        .popTop,
        .loadName(name: "wonderland"),
        .popTop,
        .popBlock,
        .loadConst(.none),
        .withCleanupStart,
        .withCleanupFinish,
        .endFinally,
        .loadConst(.none),
        .return
      ]
    )
  }

  /// with alice as smol: wonderland
  ///
  ///  0 LOAD_NAME                0 (alice)
  ///  2 SETUP_WITH              10 (to 14)
  ///  4 STORE_NAME               1 (smol)
  ///  6 LOAD_NAME                2 (wonderland)
  ///  8 POP_TOP
  /// 10 POP_BLOCK
  /// 12 LOAD_CONST               0 (None)
  /// 14 WITH_CLEANUP_START
  /// 16 WITH_CLEANUP_FINISH
  /// 18 END_FINALLY
  /// 20 LOAD_CONST               0 (None)
  /// 22 RETURN_VALUE
  func test_alias() {
    let stmt = self.withStmt(
      items: [
        self.withItem(
          contextExpr: self.identifierExpr(value: "alice"),
          optionalVars: self.identifierExpr(value: "smol", context: .store)
        )
      ],
      body: [self.identifierStmt(value: "wonderland")]
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
        .loadName(name: "alice"),
        .setupWith(afterBodyTarget: 14),
        .storeName(name: "smol"),
        .loadName(name: "wonderland"),
        .popTop,
        .popBlock,
        .loadConst(.none),
        .withCleanupStart,
        .withCleanupFinish,
        .endFinally,
        .loadConst(.none),
        .return
      ]
    )
  }

  /// with alice, rabbit: wonderland
  ///
  ///  0 LOAD_NAME                0 (alice)
  ///  2 SETUP_WITH              26 (to 30)
  ///  4 POP_TOP
  ///  6 LOAD_NAME                1 (rabbit)
  ///  8 SETUP_WITH              10 (to 20)
  /// 10 POP_TOP
  /// 12 LOAD_NAME                2 (wonderland)
  /// 14 POP_TOP
  /// 16 POP_BLOCK
  /// 18 LOAD_CONST               0 (None)
  /// 20 WITH_CLEANUP_START
  /// 22 WITH_CLEANUP_FINISH
  /// 24 END_FINALLY
  /// 26 POP_BLOCK
  /// 28 LOAD_CONST               0 (None)
  /// 30 WITH_CLEANUP_START
  /// 32 WITH_CLEANUP_FINISH
  /// 34 END_FINALLY
  /// 36 LOAD_CONST               0 (None)
  /// 38 RETURN_VALUE
  func test_multipleItems() {
    let stmt = self.withStmt(
      items: [
        self.withItem(
          contextExpr: self.identifierExpr(value: "alice"),
          optionalVars: nil
        ),
        self.withItem(
          contextExpr: self.identifierExpr(value: "rabbit"),
          optionalVars: nil
        )
      ],
      body: [self.identifierStmt(value: "wonderland")]
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
        .loadName(name: "alice"),
        .setupWith(afterBodyTarget: 30),
        .popTop,
        .loadName(name: "rabbit"),
        .setupWith(afterBodyTarget: 20),
        .popTop,
        .loadName(name: "wonderland"),
        .popTop,
        .popBlock,
        .loadConst(.none),
        .withCleanupStart,
        .withCleanupFinish,
        .endFinally,
        .popBlock,
        .loadConst(.none),
        .withCleanupStart,
        .withCleanupFinish,
        .endFinally,
        .loadConst(.none),
        .return
      ]
    )
  }

  /// with alice as big, rabbit as smol: wonderland
  ///
  ///  0 LOAD_NAME                0 (alice)
  ///  2 SETUP_WITH              26 (to 30)
  ///  4 STORE_NAME               1 (big)
  ///  6 LOAD_NAME                2 (rabbit)
  ///  8 SETUP_WITH              10 (to 20)
  /// 10 STORE_NAME               3 (smol)
  /// 12 LOAD_NAME                4 (wonderland)
  /// 14 POP_TOP
  /// 16 POP_BLOCK
  /// 18 LOAD_CONST               0 (None)
  /// 20 WITH_CLEANUP_START
  /// 22 WITH_CLEANUP_FINISH
  /// 24 END_FINALLY
  /// 26 POP_BLOCK
  /// 28 LOAD_CONST               0 (None)
  /// 30 WITH_CLEANUP_START
  /// 32 WITH_CLEANUP_FINISH
  /// 34 END_FINALLY
  /// 36 LOAD_CONST               0 (None)
  /// 38 RETURN_VALUE
  func test_multipleItemsAlias() {
    let stmt = self.withStmt(
      items: [
        self.withItem(
          contextExpr: self.identifierExpr(value: "alice"),
          optionalVars: self.identifierExpr(value: "big", context: .store)
        ),
        self.withItem(
          contextExpr: self.identifierExpr(value: "rabbit"),
          optionalVars: self.identifierExpr(value: "smol", context: .store)
        )
      ],
      body: [self.identifierStmt(value: "wonderland")]
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
        .loadName(name: "alice"),
        .setupWith(afterBodyTarget: 30),
        .storeName(name: "big"),
        .loadName(name: "rabbit"),
        .setupWith(afterBodyTarget: 20),
        .storeName(name: "smol"),
        .loadName(name: "wonderland"),
        .popTop,
        .popBlock,
        .loadConst(.none),
        .withCleanupStart,
        .withCleanupFinish,
        .endFinally,
        .popBlock,
        .loadConst(.none),
        .withCleanupStart,
        .withCleanupFinish,
        .endFinally,
        .loadConst(.none),
        .return
      ]
    )
  }
}
