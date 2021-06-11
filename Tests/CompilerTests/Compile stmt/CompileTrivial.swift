import XCTest
import VioletCore
import VioletParser
import VioletBytecode
@testable import VioletCompiler

/// Use './Scripts/dump' for reference.
class CompileTrivial: CompileTestCase {

  func test_empty() {
    guard let code = self.compile(stmts: []) else {
      return
    }

    XCTAssertCodeObject(
      code,
      name: "<module>",
      qualifiedName: "",
      kind: .module,
      flags: [],
      instructions: [
        .loadConst(.none),
        .return
      ]
    )
  }

  func test_pass_doesNothing() {
    let stmt = self.passStmt()

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
        .loadConst(.none),
        .return
      ]
    )
  }
}
