import XCTest
import Core
import Parser
@testable import Compiler

// swiftlint:disable function_body_length
// swiftlint:disable file_length
// swiftlint:disable type_body_length

/// Basic checks for statements, without nested scopes.
/// Just so we know that we visit all childs.
/// Use 'Tools/dump_symtable.py' for reference.
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
      XCTAssert(top.children.isEmpty)

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
      XCTAssert(top.children.isEmpty)

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
  /// for elsa in frozen:
  ///   elsa
  /// else: anna
  ///
  /// ```c
  /// name: top
  /// lineno: 0
  /// symbols:
  ///   elsa - referenced, local, assigned,
  ///   frozen - referenced, global,
  ///   anna - referenced, global,
  /// ```
  func test_for() {
    let targetLoc = SourceLocation(line: 10, column: 13)
    let target = Expression(.identifier("elsa"), start: targetLoc, end: self.end)

    let iterLoc = SourceLocation(line: 12, column: 15)
    let iter = Expression(.identifier("frozen"), start: iterLoc, end: self.end)

    let bodyLoc = SourceLocation(line: 14, column: 17)
    let bodyExpr = Expression(.identifier("elsa"), start: bodyLoc, end: self.end)
    let body = self.statement(.expr(bodyExpr))

    let elseLoc = SourceLocation(line: 16, column: 19)
    let elseExpr = Expression(.identifier("anna"), start: elseLoc, end: self.end)
    let elseOr = self.statement(.expr(elseExpr))

    let kind = StatementKind.for(target: target,
                                 iter: iter,
                                 body: NonEmptyArray(first: body),
                                 orElse: [elseOr])

    if let table = self.createSymbolTable(forStmt: kind) {
      let top = table.top
      XCTAssertScope(top, name: "top", type: .module, flags: [])
      XCTAssert(top.varnames.isEmpty)
      XCTAssert(top.children.isEmpty)

      XCTAssertEqual(top.symbols.count, 3)
      XCTAssertContainsSymbol(top,
                              name: "elsa",
                              flags: [.defLocal, .srcLocal, .use],
                              location: targetLoc)
      XCTAssertContainsSymbol(top,
                              name: "frozen",
                              flags: [.srcGlobalImplicit, .use],
                              location: iterLoc)
      XCTAssertContainsSymbol(top,
                              name: "anna",
                              flags: [.srcGlobalImplicit, .use],
                              location: elseLoc)
    }
  }

  /// while elsa:
  ///   anna
  /// else: snowgies
  ///
  /// ```c
  /// name: top
  /// lineno: 0
  /// symbols:
  ///   elsa - referenced, global,
  ///   anna - referenced, global,
  ///   snowgies - referenced, global,
  /// ```
  func test_while() {
    let testLoc = SourceLocation(line: 10, column: 13)
    let test = Expression(.identifier("elsa"), start: testLoc, end: self.end)

    let bodyLoc = SourceLocation(line: 12, column: 15)
    let bodyExpr = Expression(.identifier("anna"), start: bodyLoc, end: self.end)
    let body = self.statement(.expr(bodyExpr))

    let elseLoc = SourceLocation(line: 14, column: 17)
    let elseExpr = Expression(.identifier("snowgies"), start: elseLoc, end: self.end)
    let elseOr = self.statement(.expr(elseExpr))

    let kind = StatementKind.while(test: test,
                                   body: NonEmptyArray(first: body),
                                   orElse: [elseOr])

    if let table = self.createSymbolTable(forStmt: kind) {
      let top = table.top
      XCTAssertScope(top, name: "top", type: .module, flags: [])
      XCTAssert(top.varnames.isEmpty)
      XCTAssert(top.children.isEmpty)

      XCTAssertEqual(top.symbols.count, 3)
      XCTAssertContainsSymbol(top,
                              name: "elsa",
                              flags: [.srcGlobalImplicit, .use],
                              location: testLoc)
      XCTAssertContainsSymbol(top,
                              name: "anna",
                              flags: [.srcGlobalImplicit, .use],
                              location: bodyLoc)
      XCTAssertContainsSymbol(top,
                              name: "snowgies",
                              flags: [.srcGlobalImplicit, .use],
                              location: elseLoc)
    }
  }

  /// if elsa:
  ///   anna
  /// else: snowgies
  ///
  /// ```c
  /// name: top
  /// lineno: 0
  /// symbols:
  ///   elsa - referenced, global,
  ///   anna - referenced, global,
  ///   snowgies - referenced, global,
  /// ```
  func test_if() {
    let testLoc = SourceLocation(line: 10, column: 13)
    let test = Expression(.identifier("elsa"), start: testLoc, end: self.end)

    let bodyLoc = SourceLocation(line: 12, column: 15)
    let bodyExpr = Expression(.identifier("anna"), start: bodyLoc, end: self.end)
    let body = self.statement(.expr(bodyExpr))

    let elseLoc = SourceLocation(line: 14, column: 17)
    let elseExpr = Expression(.identifier("snowgies"), start: elseLoc, end: self.end)
    let elseOr = self.statement(.expr(elseExpr))

    let kind = StatementKind.if(test: test,
                                body: NonEmptyArray(first: body),
                                orElse: [elseOr])

    if let table = self.createSymbolTable(forStmt: kind) {
      let top = table.top
      XCTAssertScope(top, name: "top", type: .module, flags: [])
      XCTAssert(top.varnames.isEmpty)
      XCTAssert(top.children.isEmpty)

      XCTAssertEqual(top.symbols.count, 3)
      XCTAssertContainsSymbol(top,
                              name: "elsa",
                              flags: [.srcGlobalImplicit, .use],
                              location: testLoc)
      XCTAssertContainsSymbol(top,
                              name: "anna",
                              flags: [.srcGlobalImplicit, .use],
                              location: bodyLoc)
      XCTAssertContainsSymbol(top,
                              name: "snowgies",
                              flags: [.srcGlobalImplicit, .use],
                              location: elseLoc)
    }
  }

  // MARK: - With

  /// with elsa as queen:
  ///   queen
  ///
  /// ```c
  /// name: top
  /// lineno: 0
  /// symbols:
  ///   elsa - referenced, global,
  ///   queen - referenced, local, assigned,
  /// ```
  func test_with() {
    let ctxLoc = SourceLocation(line: 10, column: 13)
    let ctx = Expression(.identifier("elsa"), start: ctxLoc, end: self.end)

    let nameLoc = SourceLocation(line: 12, column: 15)
    let name = Expression(.identifier("queen"), start: nameLoc, end: self.end)

    let bodyLoc = SourceLocation(line: 14, column: 17)
    let bodyExpr = Expression(.identifier("queen"), start: bodyLoc, end: self.end)
    let body = self.statement(.expr(bodyExpr))

    let item = self.withItem(contextExpr: ctx, optionalVars: name)
    let kind = StatementKind.with(items: NonEmptyArray(first: item),
                                  body: NonEmptyArray(first: body))

    if let table = self.createSymbolTable(forStmt: kind) {
      let top = table.top
      XCTAssertScope(top, name: "top", type: .module, flags: [])
      XCTAssert(top.varnames.isEmpty)
      XCTAssert(top.children.isEmpty)

      XCTAssertEqual(top.symbols.count, 2)
      XCTAssertContainsSymbol(top,
                              name: "elsa",
                              flags: [.srcGlobalImplicit, .use],
                              location: ctxLoc)
      XCTAssertContainsSymbol(top,
                              name: "queen",
                              flags: [.defLocal, .srcLocal, .use],
                              location: nameLoc)
    }
  }

  // MARK: - Exceptions
//  raise(exc, cause):
//  try(body, handlers, orElse, finalBody):

  // MARK: - import
//  import(names),
}
