import XCTest
import Core
import Parser
@testable import Compiler

/// Use 'Tools/dump_symtable.py' for reference.
class STFunction: XCTestCase, CommonSymbolTable {

  // MARK: - Duplicate argument

  func test_duplicateArgument_args_args_throws() {
    let arg0 = self.arg("a", annotation: nil)
    let arg1 = self.arg("a", annotation: nil, start: loc1)

    let def = self.functionDefStmt(
      name: "elsa",
      args: self.arguments(args: [arg0, arg1])
    )

    if let error = self.error(forStmt: def) {
      XCTAssertEqual(error.kind, .duplicateArgument("a"))
      XCTAssertEqual(error.location, loc1)
    }
  }

  func test_duplicateArgument_args_vararg_throws() {
    let arg0 = self.arg("a", annotation: nil)
    let arg1 = self.arg("a", annotation: nil, start: loc1)

    let def = self.functionDefStmt(
      name: "elsa",
      args: self.arguments(args: [arg0], vararg: .named(arg1))
    )

    if let error = self.error(forStmt: def) {
      XCTAssertEqual(error.kind, .duplicateArgument("a"))
      XCTAssertEqual(error.location, loc1)
    }
  }

  func test_duplicateArgument_vararg_kwOnlyArgs_throws() {
    let arg0 = self.arg("a", annotation: nil)
    let arg1 = self.arg("a", annotation: nil, start: loc1)

    let def = self.functionDefStmt(
      name: "elsa",
      args: self.arguments(vararg: .named(arg0), kwOnlyArgs: [arg1])
    )

    if let error = self.error(forStmt: def) {
      XCTAssertEqual(error.kind, .duplicateArgument("a"))
      XCTAssertEqual(error.location, loc1)
    }
  }

  func test_duplicateArgument_kwOnlyArgs_kwarg_throws() {
    let arg0 = self.arg("a", annotation: nil)
    let arg1 = self.arg("a", annotation: nil, start: loc1)

    let def = self.functionDefStmt(
      name: "elsa",
      args: self.arguments(kwOnlyArgs: [arg0], kwarg: arg1)
    )

    if let error = self.error(forStmt: def) {
      XCTAssertEqual(error.kind, .duplicateArgument("a"))
      XCTAssertEqual(error.location, loc1)
    }
  }
}
