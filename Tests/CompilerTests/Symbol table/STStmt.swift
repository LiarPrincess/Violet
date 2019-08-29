import XCTest
import Core
import Parser
@testable import Compiler

// swiftlint:disable function_body_length
// swiftlint:disable file_length
// swiftlint:disable type_body_length

/// Basic checks for statements, without nested scopes.
/// Just so we know that we visit all childs.
class STStmt: XCTestCase, CommonSymbolTable {

  // MARK: - Pass, break, continue, return, delete and assert

  func test_pass_break_continue() {
    let stmtKinds: [StatementKind] = [
      .pass, .break, .continue
    ]

    for kind in stmtKinds {
      let msg = "for '\(kind)'"

      if let table = self.createSymbolTable(forStmt: kind) {
        let top = table.top
        XCTAssertScope(top, name: "top", type: .module, flags: [], msg)

        XCTAssert(top.symbols.isEmpty, msg)
        XCTAssert(top.children.isEmpty, msg)
        XCTAssert(top.varnames.isEmpty, msg)
      }
    }
  }

  /// def let_it_go(elsa):
  ///   return elsa
  ///
  /// ```c
  /// name: top
  /// lineno: 0
  /// symbols:
  ///   let_it_go - local, assigned, namespace,
  /// children:
  ///   name: let_it_go
  ///   lineno: 2
  ///   is optimized
  ///   parameters: ('elsa',)
  ///   locals: ('elsa',)
  ///   symbols:
  ///     elsa - referenced, parameter, local,
  /// ```
  func test_return() {
    let arg = self.arg("elsa")
    let args = self.arguments(args: [arg])

    let loc = SourceLocation(line: 10, column: 13)
    let expr = Expression(.identifier("elsa"), start: loc, end: self.end)
    let body = self.statement(.return(expr))

    let f = self.functionDef(name: "let_it_go",
                             args: args,
                             body: NonEmptyArray(first: body))

    if let table = self.createSymbolTable(forStmt: f) {
      let top = table.top
      XCTAssertScope(top, name: "top", type: .module, flags: [])
      XCTAssert(top.varnames.isEmpty)

      XCTAssertEqual(top.symbols.count, 1)
      XCTAssertContainsSymbol(top,
                              name: "let_it_go",
                              flags: [.defLocal, .srcLocal])

      XCTAssertEqual(top.children.count, 1)
      guard top.children.count == 1 else { return }

      let bodyScope = top.children[0]
      XCTAssertScope(bodyScope,
                     name: "let_it_go",
                     type: .function,
                     flags: [.hasReturnValue, .isNested])

      XCTAssert(bodyScope.children.isEmpty)

      XCTAssertEqual(bodyScope.varnames.count, 1)
      XCTAssertContainsParameter(bodyScope, name: "elsa")

      // We have '.use' flag, which means that return value was visited
      XCTAssertEqual(bodyScope.symbols.count, 1)
      XCTAssertContainsSymbol(bodyScope,
                              name: "elsa",
                              flags: [.defParam, .srcLocal, .use])
    }
  }

  /// del elsa, anna
  ///
  /// ```c
  /// name: top
  /// lineno: 0
  /// symbols:
  ///   elsa - local, assigned, <- not sure CPython classified them in this way
  ///   anna - local, assigned,
  /// ```
  func test_delete() {
    let loc1 = SourceLocation(line: 10, column: 13)
    let expr1 = Expression(.identifier("elsa"), start: loc1, end: self.end)

    let loc2 = SourceLocation(line: 12, column: 15)
    let expr2 = Expression(.identifier("anna"), start: loc2, end: self.end)

    let kind = StatementKind.delete(NonEmptyArray(first: expr1, rest: [expr2]))

    if let table = self.createSymbolTable(forStmt: kind) {
      let top = table.top
      XCTAssertScope(top, name: "top", type: .module, flags: [])
      XCTAssert(top.varnames.isEmpty)
      XCTAssert(top.varnames.isEmpty)

      XCTAssertEqual(top.symbols.count, 2)
      XCTAssertContainsSymbol(top,
                              name: "elsa",
                              flags: [.srcGlobalImplicit, .use],
                              location: loc1)
      XCTAssertContainsSymbol(top,
                              name: "anna",
                              flags: [.srcGlobalImplicit, .use],
                              location: loc2)
    }
  }

  /// assert elsa, anna
  ///
  /// ```c
  /// name: top
  /// lineno: 0
  /// symbols:
  ///   elsa - referenced, global,
  ///   anna - referenced, global,
  /// ```
  func test_assert() {
    let loc1 = SourceLocation(line: 10, column: 13)
    let expr1 = Expression(.identifier("elsa"), start: loc1, end: self.end)

    let loc2 = SourceLocation(line: 12, column: 15)
    let expr2 = Expression(.identifier("anna"), start: loc2, end: self.end)

    let kind = StatementKind.assert(test: expr1, msg: expr2)

    if let table = self.createSymbolTable(forStmt: kind) {
      let top = table.top
      XCTAssertScope(top, name: "top", type: .module, flags: [])
      XCTAssert(top.varnames.isEmpty)
      XCTAssert(top.varnames.isEmpty)

      XCTAssertEqual(top.symbols.count, 2)
      XCTAssertContainsSymbol(top,
                              name: "elsa",
                              flags: [.srcGlobalImplicit, .use],
                              location: loc1)
      XCTAssertContainsSymbol(top,
                              name: "anna",
                              flags: [.srcGlobalImplicit, .use],
                              location: loc2)
    }
  }

  // MARK: - For, while, if

//  for(target, iter, body, orElse),
//  while(test, body, orElse):
//  if(test, body, orElse):

  // MARK: - With
//  with(items, body),

  // MARK: - Exceptions
//  raise(exc, cause):
//  try(body, handlers, orElse, finalBody):

  // MARK: - import
//  import(names),
}
