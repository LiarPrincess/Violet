import XCTest
import Core
import Parser
@testable import Compiler

class STAtomExpr: XCTestCase, CommonSymbolTable {

  func test_empty() {
    if let table = self.createSymbolTable(forStmts: []) {
      let top = table.top
      XCTAssertScope(top, name: "top", type: .module, flags: [])

      XCTAssert(top.symbols.isEmpty)
      XCTAssert(top.children.isEmpty)
      XCTAssert(top.varnames.isEmpty)
    }
  }

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
}
