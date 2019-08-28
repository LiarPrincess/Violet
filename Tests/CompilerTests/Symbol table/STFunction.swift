import XCTest
import Core
import Parser
@testable import Compiler

class STFunction: XCTestCase, CommonSymbolTable {

  // MARK: - Duplicate argument

  func test_duplicateArgument_args_args_throws() {
    let loc = SourceLocation(line: 10, column: 13)
    let arg0 = Arg("a", annotation: nil, start: self.start, end: self.end)
    let arg1 = Arg("a", annotation: nil, start: loc,        end: self.end)

    let def = StatementKind.functionDef(
      name: "Elsa",
      args: self.arguments(args: [arg0, arg1],
                           defaults: [],
                           vararg: .none,
                           kwOnlyArgs: [],
                           kwOnlyDefaults: [],
                           kwarg: nil),
      body: NonEmptyArray(first: self.statement(.pass)),
      decoratorList: [],
      returns: nil)

    if let error = self.error(forStmt: def) {
      XCTAssertEqual(error.kind, .duplicateArgument("a"))
      XCTAssertEqual(error.location, loc)
    }
  }

  func test_duplicateArgument_args_vararg_throws() {
    let loc = SourceLocation(line: 10, column: 13)
    let arg0 = Arg("a", annotation: nil, start: self.start, end: self.end)
    let arg1 = Arg("a", annotation: nil, start: loc,        end: self.end)

    let def = StatementKind.functionDef(
      name: "Elsa",
      args: self.arguments(args: [arg0],
                           defaults: [],
                           vararg: .named(arg1),
                           kwOnlyArgs: [],
                           kwOnlyDefaults: [],
                           kwarg: nil),
      body: NonEmptyArray(first: self.statement(.pass)),
      decoratorList: [],
      returns: nil)

    if let error = self.error(forStmt: def) {
      XCTAssertEqual(error.kind, .duplicateArgument("a"))
      XCTAssertEqual(error.location, loc)
    }
  }

  func test_duplicateArgument_vararg_kwOnlyArgs_throws() {
    let loc = SourceLocation(line: 10, column: 13)
    let arg0 = Arg("a", annotation: nil, start: self.start, end: self.end)
    let arg1 = Arg("a", annotation: nil, start: loc,        end: self.end)

    let def = StatementKind.functionDef(
      name: "Elsa",
      args: self.arguments(args: [],
                           defaults: [],
                           vararg: .named(arg0),
                           kwOnlyArgs: [arg1],
                           kwOnlyDefaults: [],
                           kwarg: nil),
      body: NonEmptyArray(first: self.statement(.pass)),
      decoratorList: [],
      returns: nil)

    if let error = self.error(forStmt: def) {
      XCTAssertEqual(error.kind, .duplicateArgument("a"))
      XCTAssertEqual(error.location, loc)
    }
  }

  func test_duplicateArgument_kwOnlyArgs_kwarg_throws() {
    let loc = SourceLocation(line: 10, column: 13)
    let arg0 = Arg("a", annotation: nil, start: self.start, end: self.end)
    let arg1 = Arg("a", annotation: nil, start: loc,        end: self.end)

    let def = StatementKind.functionDef(
      name: "Elsa",
      args: self.arguments(args: [],
                           defaults: [],
                           vararg: .unnamed,
                           kwOnlyArgs: [arg0],
                           kwOnlyDefaults: [],
                           kwarg: arg1),
      body: NonEmptyArray(first: self.statement(.pass)),
      decoratorList: [],
      returns: nil)

    if let error = self.error(forStmt: def) {
      XCTAssertEqual(error.kind, .duplicateArgument("a"))
      XCTAssertEqual(error.location, loc)
    }
  }
}
