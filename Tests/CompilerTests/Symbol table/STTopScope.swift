import XCTest
import Core
import Parser
@testable import Compiler

/// Use 'Tools/dump_symtable.py' for reference.
class STTopScope: SymbolTableTestCase {

  // MARK: - No modifiers

  /// elsa
  func test_identifier_expression() {
    let kind = ExpressionKind.identifier("elsa")
    let expr = self.expression(kind, start: loc1)

    if let table = self.createSymbolTable(forExpr: expr) {
      let top = table.top
      XCTAssertScope(top, name: "top", type: .module, flags: [])

      XCTAssertEqual(top.symbols.count, 1)
      XCTAssertContainsSymbol(top,
                              name: "elsa",
                              flags: [.use, .srcGlobalImplicit],
                              location: loc1)

      XCTAssert(top.children.isEmpty)
      XCTAssert(top.varNames.isEmpty)
    }
  }

  /// elsa
  func test_identifier_statement() {
    let kind = ExpressionKind.identifier("elsa")
    let expr = self.expression(kind, start: loc1)

    if let table = self.createSymbolTable(forStmt: StatementKind.expr(expr)) {
      let top = table.top
      XCTAssertScope(top, name: "top", type: .module, flags: [])

      XCTAssertEqual(top.symbols.count, 1)
      XCTAssertContainsSymbol(top,
                              name: "elsa",
                              flags: [.use, .srcGlobalImplicit],
                              location: loc1)

      XCTAssert(top.children.isEmpty)
      XCTAssert(top.varNames.isEmpty)
    }
  }

  // MARK: - Global

  /// global elsa
  func test_global() {
    let stmt = self.global(name: "elsa", start: loc1)

    if let table = self.createSymbolTable(forStmt: stmt) {
      let top = table.top
      XCTAssertScope(top, name: "top", type: .module, flags: [])

      XCTAssertEqual(top.symbols.count, 1)
      XCTAssertContainsSymbol(top,
                              name: "elsa",
                              flags: [.defGlobal, .srcGlobalExplicit],
                              location: loc1)

      XCTAssert(top.children.isEmpty)
      XCTAssert(top.varNames.isEmpty)
    }
  }

  /// def let_it_go(elsa): global elsa
  func test_global_equalToParam_throws() {
    let stmt = self.functionDef(
      name: "let_it_go",
      args: self.arguments(args: [self.arg("elsa")]),
      body: [
        self.global(name: "elsa", start: loc1)
      ]
    )

    if let error = self.error(forStmt: stmt) {
      XCTAssertEqual(error.kind, .globalParam("elsa"))
      XCTAssertEqual(error.location, loc1)
    }
  }

  /// elsa
  /// global elsa
  func test_useAsLocal_thenGlobal_throws() {
    let stmt1 = self.statement(expr: .identifier("elsa"))
    let stmt2 = self.global(name: "elsa", start: loc1)

    if let error = self.error(forStmts: [stmt1, stmt2]) {
      XCTAssertEqual(error.kind, .globalAfterUse("elsa"))
      XCTAssertEqual(error.location, loc1)
    }
  }

  /// elsa: Queen = 5
  /// global elsa
  func test_annotatedLocal_thenGlobal_throws() {
    let stmt1 = self.statement(.annAssign(
      target: self.identifierExpr("elsa"),
      annotation: self.identifierExpr("Queen"),
      value: self.expression(.int(BigInt(5))),
      isSimple: true)
    )

    let stmt2 = self.global(name: "elsa", start: loc1)

    if let error = self.error(forStmts: [stmt1, stmt2]) {
      XCTAssertEqual(error.kind, .globalAnnot("elsa"))
      XCTAssertEqual(error.location, loc1)
    }
  }

  // MARK: - Nonlocal

  /// nonlocal elsa
  func test_nonlocal_atModuleScope_throws() {
    let stmt = self.nonlocal(name: "elsa", start: loc1)

    if let error = self.error(forStmt: stmt) {
      XCTAssertEqual(error.kind, .nonlocalAtModuleLevel("elsa"))
      XCTAssertEqual(error.location, loc1)
    }
  }

  /// def let_it_go(elsa): nonlocal elsa
  func test_nonlocal_equalToParam_throws() {
    let stmt = self.functionDef(
      name: "let_it_go",
      args: self.arguments(
        args: [self.arg("elsa")]
      ),
      body: [self.nonlocal(name: "elsa", start: loc1)]
    )

    if let error = self.error(forStmt: stmt) {
      XCTAssertEqual(error.kind, .nonlocalParam("elsa"))
      XCTAssertEqual(error.location, loc1)
    }
  }

  /// elsa
  /// nonlocal elsa
  func test_useAsLocal_thenNonlocal_throws() {
    let stmt1 = self.statement(expr: .identifier("elsa"))
    let stmt2 = self.nonlocal(name: "elsa", start: loc1)

    if let error = self.error(forStmts: [stmt1, stmt2]) {
      XCTAssertEqual(error.kind, .nonlocalAfterUse("elsa"))
      XCTAssertEqual(error.location, loc1)
    }
  }

  /// elsa: Queen = 5
  /// nonlocal elsa
  func test_annotatedLocal_thenNonlocal_throws() {
    let stmt1 = self.statement(.annAssign(
      target: self.identifierExpr("elsa"),
      annotation: self.identifierExpr("Queen"),
      value: self.expression(.int(BigInt(5))),
      isSimple: true)
    )

    let stmt2 = self.nonlocal(name: "elsa", start: loc1)

    if let error = self.error(forStmts: [stmt1, stmt2]) {
      XCTAssertEqual(error.kind, .nonlocalAnnot("elsa"))
      XCTAssertEqual(error.location, loc1)
    }
  }
}
