import XCTest
import Core
import Parser
@testable import Compiler

class STAtomExpr: XCTestCase, CommonSymbolTable {

  // MARK: - Empty

  func test_empty() {
    if let table = self.createSymbolTable(forStmts: []) {
      let top = table.top
      XCTAssertScope(top, name: "top", type: .module, flags: [])

      XCTAssert(top.symbols.isEmpty)
      XCTAssert(top.children.isEmpty)
      XCTAssert(top.varnames.isEmpty)
    }
  }

  // MARK: - Simple atoms

  func test_bool_none_ellipsis_numbers_bytes() {
    let exprKinds: [ExpressionKind] = [
      .true, .false,
      .none, .ellipsis,
      .int(BigInt(1)), .float(2.0), .complex(real: 3.0, imag: 4.0),
      .bytes(Data())
    ]

    for kind in exprKinds {
      let msg = "for '\(kind)'"

      if let table = self.createSymbolTable(forExpr: kind) {
        let top = table.top
        XCTAssertScope(top, name: "top", type: .module, flags: [], msg)

        XCTAssert(top.symbols.isEmpty, msg)
        XCTAssert(top.children.isEmpty, msg)
        XCTAssert(top.varnames.isEmpty, msg)
      }
    }
  }

  // MARK: - String

  /// 'Elsa'
  func test_string_simple() {
    let kind = ExpressionKind.string(.literal("Elsa"))

    if let table = self.createSymbolTable(forExpr: kind) {
      let top = table.top
      XCTAssertScope(top, name: "top", type: .module, flags: [])

      XCTAssert(top.symbols.isEmpty)
      XCTAssert(top.children.isEmpty)
      XCTAssert(top.varnames.isEmpty)
    }
  }

  /// f'{Elsa!r:^30}'
  func test_string_formattedValue() {
    let loc = SourceLocation(line: 10, column: 13)
    let value = Expression(.identifier("Elsa"), start: loc, end: self.end)
    let kind = ExpressionKind.string(
      .formattedValue(value, conversion: .repr, spec: "^30")
    )

    if let table = self.createSymbolTable(forExpr: kind) {
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

  /// f'let {it!r:^30} go'
  func test_string_joined() {
    let loc = SourceLocation(line: 10, column: 13)
    let value = Expression(.identifier("it"), start: loc, end: self.end)

    let kind = ExpressionKind.string(
      .joined([
        .literal("let "),
        .formattedValue(value, conversion: .repr, spec: "^30"),
        .literal(" go")
      ])
    )

    if let table = self.createSymbolTable(forExpr: kind) {
      let top = table.top
      XCTAssertScope(top, name: "top", type: .module, flags: [])

      XCTAssertEqual(top.symbols.count, 1)
      XCTAssertContainsSymbol(top,
                              name: "it",
                              flags: [.use, .srcGlobalImplicit],
                              location: loc)

      XCTAssert(top.children.isEmpty)
      XCTAssert(top.varnames.isEmpty)
    }
  }

  // MARK: - Operations
}
