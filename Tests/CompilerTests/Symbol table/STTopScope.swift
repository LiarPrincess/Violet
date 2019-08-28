import XCTest
import Core
import Parser
@testable import Compiler

class STTopScope: XCTestCase, CommonSymbolTable {

  func test_identifier() {
    let kind = ExpressionKind.identifier("Elsa")

    if let table = self.createSymbolTable(forExpr: kind) {
      let top = table.top
      XCTAssertScope(top, name: "top", type: .module, flags: [])

      XCTAssertEqual(top.symbols.count, 1)
      XCTAssertContainsSymbol(top, name: "Elsa", flags: [.use, .srcGlobalImplicit])

      XCTAssert(top.children.isEmpty)
      XCTAssert(top.varnames.isEmpty)
    }
  }

  func test_global() {
    let kind = StatementKind.global(NonEmptyArray(first: "Elsa"))

    if let table = self.createSymbolTable(forStmt: kind) {
      let top = table.top
      XCTAssertScope(top, name: "top", type: .module, flags: [])

      XCTAssertEqual(top.symbols.count, 1)
      XCTAssertContainsSymbol(top, name: "Elsa", flags: [.defGlobal, .srcGlobalExplicit])

      XCTAssert(top.children.isEmpty)
      XCTAssert(top.varnames.isEmpty)
    }
  }

  func test_nonlocal_throws() {
    let kind = StatementKind.nonlocal(NonEmptyArray(first: "Elsa"))

    if let error = self.error(forStmt: kind) {
      XCTAssertEqual(error.kind, .nonlocalAtModuleLevel("Elsa"))
      XCTAssertEqual(error.location, self.startLocation)
    }
  }
}
