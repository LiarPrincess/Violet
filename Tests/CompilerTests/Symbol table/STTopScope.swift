import XCTest
import Core
import Parser
@testable import Compiler

class STTopScope: XCTestCase, CommonSymbolTable {

  /// Elsa
  func test_identifier() {
    let loc = SourceLocation(line: 10, column: 13)
    let kind = ExpressionKind.identifier("Elsa")
    let expr = Expression(kind, start: loc, end: self.end)

    if let table = self.createSymbolTable(forExpr: expr) {
      let top = table.top
      XCTAssertScope(top, name: "top", type: .module, flags: [])

      XCTAssertEqual(top.symbols.count, 1)
      XCTAssertContainsSymbol(top,
                              name: "Elsa",
                              flags: [.use, .srcGlobalImplicit],
                              location: loc)

      XCTAssert(top.children.isEmpty)
      XCTAssert(top.varnames.isEmpty)
    }
  }

  /// global Elsa
  func test_global() {
    let loc = SourceLocation(line: 10, column: 13)
    let kind = StatementKind.global(NonEmptyArray(first: "Elsa"))
    let stmt = Statement(kind, start: loc, end: self.end)

    if let table = self.createSymbolTable(forStmt: stmt) {
      let top = table.top
      XCTAssertScope(top, name: "top", type: .module, flags: [])

      XCTAssertEqual(top.symbols.count, 1)
      XCTAssertContainsSymbol(top,
                              name: "Elsa",
                              flags: [.defGlobal, .srcGlobalExplicit],
                              location: loc)

      XCTAssert(top.children.isEmpty)
      XCTAssert(top.varnames.isEmpty)
    }
  }

  /// nonlocal Elsa
  func test_nonlocal_throws() {
    let loc = SourceLocation(line: 10, column: 13)
    let kind = StatementKind.nonlocal(NonEmptyArray(first: "Elsa"))
    let stmt = Statement(kind, start: loc, end: self.end)

    if let error = self.error(forStmt: stmt) {
      XCTAssertEqual(error.kind, .nonlocalAtModuleLevel("Elsa"))
      XCTAssertEqual(error.location, loc)
    }
  }
}
