import XCTest
import VioletCore
import VioletParser
@testable import VioletCompiler

/// Use 'Tools/dump_symtable.py' for reference.
class STTopScope: SymbolTableTestCase {

  // MARK: - No modifiers

  /// elsa
  func test_identifier_expression() {
    let expr = self.identifierExpr(value: "elsa", start: loc1)

    guard let table = self.createSymbolTable(expr: expr) else {
      return
    }

    XCTAssertScope(
      table.top,
      name: "top",
      kind: .module,
      flags: [],
      symbols: [
        .init(name: "elsa", flags: [.use, .srcGlobalImplicit], location: loc1)
      ],
      parameters: [],
      childrenCount: 0
    )
  }

  /// elsa
  func test_identifier_statement() {
    let expr = self.identifierExpr(value: "elsa", start: loc1)
    let stmt = self.exprStmt(expression: expr)

    guard let table = self.createSymbolTable(stmt: stmt) else {
      return
    }

    XCTAssertScope(
      table.top,
      name: "top",
      kind: .module,
      flags: [],
      symbols: [
        .init(name: "elsa", flags: [.use, .srcGlobalImplicit], location: loc1)
      ],
      parameters: [],
      childrenCount: 0
    )
  }

  // MARK: - Global

  /// global elsa
  func test_global() {
    let stmt = self.globalStmt(identifier: "elsa", start: loc1)

    guard let table = self.createSymbolTable(stmt: stmt) else {
      return
    }

    XCTAssertScope(
      table.top,
      name: "top",
      kind: .module,
      flags: [],
      symbols: [
        .init(name: "elsa", flags: [.defGlobal, .srcGlobalExplicit], location: loc1)
      ],
      parameters: [],
      childrenCount: 0
    )
  }

  /// def let_it_go(elsa): global elsa
  func test_global_equalToParam_throws() {
    let stmt = self.functionDefStmt(
      name: "let_it_go",
      args: self.arguments(
        args: [self.arg(name: "elsa")]
      ),
      body: [
        self.globalStmt(identifier: "elsa", start: loc1)
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
    let stmt1 = self.identifierStmt(value: "elsa")
    let stmt2 = self.globalStmt(identifier: "elsa", start: loc1)

    if let error = self.error(forStmts: [stmt1, stmt2]) {
      XCTAssertEqual(error.kind, .globalAfterUse("elsa"))
      XCTAssertEqual(error.location, loc1)
    }
  }

  /// elsa: Queen = 5
  /// global elsa
  func test_annotatedLocal_thenGlobal_throws() {
    let stmt1 = self.annAssignStmt(
      target: self.identifierExpr(value: "elsa"),
      annotation: self.identifierExpr(value: "Queen"),
      value: self.intExpr(value: 5),
      isSimple: true
    )

    let stmt2 = self.globalStmt(identifier: "elsa", start: loc1)

    if let error = self.error(forStmts: [stmt1, stmt2]) {
      XCTAssertEqual(error.kind, .globalAnnotated("elsa"))
      XCTAssertEqual(error.location, loc1)
    }
  }

  // MARK: - Nonlocal

  /// nonlocal elsa
  func test_nonlocal_atModuleScope_throws() {
    let stmt = self.nonlocalStmt(identifier: "elsa", start: loc1)

    if let error = self.error(forStmt: stmt) {
      XCTAssertEqual(error.kind, .nonlocalAtModuleLevel("elsa"))
      XCTAssertEqual(error.location, loc1)
    }
  }

  /// def let_it_go(elsa): nonlocal elsa
  func test_nonlocal_equalToParam_throws() {
    let stmt = self.functionDefStmt(
      name: "let_it_go",
      args: self.arguments(
        args: [self.arg(name: "elsa")]
      ),
      body: [
        self.nonlocalStmt(identifier: "elsa", start: loc1)
      ]
    )

    if let error = self.error(forStmt: stmt) {
      XCTAssertEqual(error.kind, .nonlocalParam("elsa"))
      XCTAssertEqual(error.location, loc1)
    }
  }

  /// elsa
  /// nonlocal elsa
  func test_useAsLocal_thenNonlocal_throws() {
    let stmt1 = self.identifierStmt(value: "elsa")
    let stmt2 = self.nonlocalStmt(identifier: "elsa", start: loc1)

    if let error = self.error(forStmts: [stmt1, stmt2]) {
      XCTAssertEqual(error.kind, .nonlocalAfterUse("elsa"))
      XCTAssertEqual(error.location, loc1)
    }
  }

  /// elsa: Queen = 5
  /// nonlocal elsa
  func test_annotatedLocal_thenNonlocal_throws() {
    let stmt1 = self.annAssignStmt(
      target: self.identifierExpr(value: "elsa"),
      annotation: self.identifierExpr(value: "Queen"),
      value: self.intExpr(value: 5),
      isSimple: true
    )

    let stmt2 = self.nonlocalStmt(identifier: "elsa", start: loc1)

    if let error = self.error(forStmts: [stmt1, stmt2]) {
      XCTAssertEqual(error.kind, .nonlocalAnnotated("elsa"))
      XCTAssertEqual(error.location, loc1)
    }
  }
}
