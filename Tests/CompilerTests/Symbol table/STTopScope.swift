import XCTest
import Core
import Parser
@testable import Compiler

// TODO: Rename to STGlobal, STNonlocal

class STTopScope: XCTestCase, CommonSymbolTable {

  // MARK: - No modifiers

  /// elsa
  func test_identifier_expression() {
    let loc = SourceLocation(line: 10, column: 13)
    let kind = ExpressionKind.identifier("elsa")
    let expr = Expression(kind, start: loc, end: self.end)

    if let table = self.createSymbolTable(forExpr: expr) {
      let top = table.top
      XCTAssertScope(top, name: "top", type: .module, flags: [])

      XCTAssertEqual(top.symbols.count, 1)
      XCTAssertContainsSymbol(top,
                              name: "elsa",
                              flags: [.use, .srcGlobalImplicit],
                              location: loc)

      XCTAssert(top.children.isEmpty)
      XCTAssert(top.varnames.isEmpty)
    }
  }

  /// elsa
  func test_identifier_statement() {
    let loc = SourceLocation(line: 10, column: 13)
    let kind = ExpressionKind.identifier("elsa")
    let expr = Expression(kind, start: loc, end: self.end)

    if let table = self.createSymbolTable(forStmt: StatementKind.expr(expr)) {
      let top = table.top
      XCTAssertScope(top, name: "top", type: .module, flags: [])

      XCTAssertEqual(top.symbols.count, 1)
      XCTAssertContainsSymbol(top,
                              name: "elsa",
                              flags: [.use, .srcGlobalImplicit],
                              location: loc)

      XCTAssert(top.children.isEmpty)
      XCTAssert(top.varnames.isEmpty)
    }
  }

  // MARK: - Global

  /// global elsa
  func test_global() {
    let loc = SourceLocation(line: 10, column: 13)
    let stmt = self.createGlobalIdentifier(name: "elsa", location: loc)

    if let table = self.createSymbolTable(forStmt: stmt) {
      let top = table.top
      XCTAssertScope(top, name: "top", type: .module, flags: [])

      XCTAssertEqual(top.symbols.count, 1)
      XCTAssertContainsSymbol(top,
                              name: "elsa",
                              flags: [.defGlobal, .srcGlobalExplicit],
                              location: loc)

      XCTAssert(top.children.isEmpty)
      XCTAssert(top.varnames.isEmpty)
    }
  }

  /// def let_it_go(elsa): global elsa
  func test_global_equalToParam_throws() {
    let arg = self.arg("elsa")
    let args = self.arguments(args: [arg])

    let loc = SourceLocation(line: 10, column: 13)
    let body = self.createGlobalIdentifier(name: "elsa", location: loc)

    let f = self.functionDef(name: "let_it_go",
                             args: args,
                             body: NonEmptyArray(first: body))

    if let error = self.error(forStmt: f) {
      XCTAssertEqual(error.kind, .globalParam("elsa"))
      XCTAssertEqual(error.location, loc)
    }
  }

  /// elsa
  /// global elsa
  func test_global_afterUse_throws() {
    let stmt1 = self.statement(expr: .identifier("elsa"))

    let loc = SourceLocation(line: 10, column: 13)
    let stmt2 = self.createGlobalIdentifier(name: "elsa", location: loc)

    if let error = self.error(forStmts: [stmt1, stmt2]) {
      XCTAssertEqual(error.kind, .globalAfterUse("elsa"))
      XCTAssertEqual(error.location, loc)
    }
  }

  /// elsa: Queen = 5
  /// global elsa
  func test_global_afterAnnotatedLocal_throws() {
    let stmt1 = self.statement(.annAssign(
      target: self.expression(.identifier("elsa")),
      annotation: self.expression(.identifier("Queen")),
      value: self.expression(.int(BigInt(5))),
      isSimple: true)
    )

    let loc = SourceLocation(line: 10, column: 13)
    let stmt2 = self.createGlobalIdentifier(name: "elsa", location: loc)

    if let error = self.error(forStmts: [stmt1, stmt2]) {
      XCTAssertEqual(error.kind, .globalAnnot("elsa"))
      XCTAssertEqual(error.location, loc)
    }
  }

  private func createGlobalIdentifier(name: String,
                                      location: SourceLocation) -> Statement {
    let kind = StatementKind.global(NonEmptyArray(first: name))
    return Statement(kind, start: location, end: self.end)
  }

  // MARK: - Nonlocal

  /// nonlocal elsa
  func test_nonlocal_throws() {
    let loc = SourceLocation(line: 10, column: 13)
    let stmt = self.createNonlocallIdentifier(name: "elsa", location: loc)

    if let error = self.error(forStmt: stmt) {
      XCTAssertEqual(error.kind, .nonlocalAtModuleLevel("elsa"))
      XCTAssertEqual(error.location, loc)
    }
  }

  /// def let_it_go(elsa): nonlocal elsa
  func test_nonlocal_equalToParam_throws() {
    let arg = self.arg("elsa")
    let args = self.arguments(args: [arg])

    let loc = SourceLocation(line: 10, column: 13)
    let body = self.createNonlocallIdentifier(name: "elsa", location: loc)

    let f = self.functionDef(name: "let_it_go",
                             args: args,
                             body: NonEmptyArray(first: body))

    if let error = self.error(forStmt: f) {
      XCTAssertEqual(error.kind, .nonlocalParam("elsa"))
      XCTAssertEqual(error.location, loc)
    }
  }

  /// elsa
  /// nonlocal elsa
  func test_nonlocal_afterUse_throws() {
    let stmt1 = self.statement(expr: .identifier("elsa"))

    let loc = SourceLocation(line: 10, column: 13)
    let stmt2 = self.createNonlocallIdentifier(name: "elsa", location: loc)

    if let error = self.error(forStmts: [stmt1, stmt2]) {
      XCTAssertEqual(error.kind, .nonlocalAfterUse("elsa"))
      XCTAssertEqual(error.location, loc)
    }
  }

  /// elsa: Queen = 5
  /// nonlocal elsa
  func test_nonlocal_afterAnnotatedLocal_throws() {
    let stmt1 = self.statement(.annAssign(
      target: self.expression(.identifier("elsa")),
      annotation: self.expression(.identifier("Queen")),
      value: self.expression(.int(BigInt(5))),
      isSimple: true)
    )

    let loc = SourceLocation(line: 10, column: 13)
    let stmt2 = self.createNonlocallIdentifier(name: "elsa", location: loc)

    if let error = self.error(forStmts: [stmt1, stmt2]) {
      XCTAssertEqual(error.kind, .nonlocalAnnot("elsa"))
      XCTAssertEqual(error.location, loc)
    }
  }

  private func createNonlocallIdentifier(name: String,
                                         location: SourceLocation) -> Statement {
    let kind = StatementKind.nonlocal(NonEmptyArray(first: name))
    return Statement(kind, start: location, end: self.end)
  }
}
