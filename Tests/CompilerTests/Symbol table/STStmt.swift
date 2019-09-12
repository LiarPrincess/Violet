import XCTest
import Core
import Parser
@testable import Compiler

// swiftlint:disable function_body_length
// swiftlint:disable file_length

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
        XCTAssert(top.varNames.isEmpty, msg)
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
    let stmt = self.functionDef(
      name: "let_it_go",
      args: self.arguments(args: [self.arg("elsa")]),
      body: [
        self.statement(.return(
          self.identifierExpr("elsa", start: loc1)
        ))
      ]
    )

    if let table = self.createSymbolTable(forStmt: stmt) {
      let top = table.top
      XCTAssertScope(top, name: "top", type: .module, flags: [])
      XCTAssert(top.varNames.isEmpty)

      XCTAssertEqual(top.symbols.count, 1)
      XCTAssertContainsSymbol(top,
                              name: "let_it_go",
                              flags: [.defLocal, .srcLocal])

      XCTAssertEqual(top.children.count, 1)
      guard top.children.count == 1 else { return }

      let bodyScope = top.children[0]
      XCTAssertScope(bodyScope, name: "let_it_go", type: .function, flags: [.hasReturnValue, .isNested])
      XCTAssert(bodyScope.children.isEmpty)

      XCTAssertEqual(bodyScope.varNames.count, 1)
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
    let stmt = self.delete(
      self.identifierExpr("elsa", start: loc1),
      self.identifierExpr("anna", start: loc2)
    )

    if let table = self.createSymbolTable(forStmt: stmt) {
      let top = table.top
      XCTAssertScope(top, name: "top", type: .module, flags: [])
      XCTAssert(top.varNames.isEmpty)
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
    let kind = StatementKind.assert(
      test: self.identifierExpr("elsa", start: loc1),
      msg: self.identifierExpr("anna", start: loc2)
    )

    if let table = self.createSymbolTable(forStmt: kind) {
      let top = table.top
      XCTAssertScope(top, name: "top", type: .module, flags: [])
      XCTAssert(top.varNames.isEmpty)
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
    let kind = self.for(
      target: self.identifierExpr("elsa", start: loc1),
      iter: self.identifierExpr("frozen", start: loc2),
      body: [
        self.identifierStmt("elsa", exprStart: loc3)
      ],
      orElse: [
        self.identifierStmt("anna", exprStart: loc4)
      ]
    )

    if let table = self.createSymbolTable(forStmt: kind) {
      let top = table.top
      XCTAssertScope(top, name: "top", type: .module, flags: [])
      XCTAssert(top.varNames.isEmpty)
      XCTAssert(top.children.isEmpty)

      XCTAssertEqual(top.symbols.count, 3)
      XCTAssertContainsSymbol(top,
                              name: "elsa",
                              flags: [.defLocal, .srcLocal, .use],
                              location: loc1)
      XCTAssertContainsSymbol(top,
                              name: "frozen",
                              flags: [.srcGlobalImplicit, .use],
                              location: loc2)
      XCTAssertContainsSymbol(top,
                              name: "anna",
                              flags: [.srcGlobalImplicit, .use],
                              location: loc4)
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
    let kind = self.while(
      test: self.identifierExpr("elsa", start: loc1),
      body: [
        self.identifierStmt("anna", exprStart: loc2)
      ],
      orElse: [
        self.identifierStmt("snowgies", exprStart: loc3)
      ]
    )

    if let table = self.createSymbolTable(forStmt: kind) {
      let top = table.top
      XCTAssertScope(top, name: "top", type: .module, flags: [])
      XCTAssert(top.varNames.isEmpty)
      XCTAssert(top.children.isEmpty)

      XCTAssertEqual(top.symbols.count, 3)
      XCTAssertContainsSymbol(top,
                              name: "elsa",
                              flags: [.srcGlobalImplicit, .use],
                              location: loc1)
      XCTAssertContainsSymbol(top,
                              name: "anna",
                              flags: [.srcGlobalImplicit, .use],
                              location: loc2)
      XCTAssertContainsSymbol(top,
                              name: "snowgies",
                              flags: [.srcGlobalImplicit, .use],
                              location: loc3)
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
    let kind = self.if(
      test: self.identifierExpr("elsa", start: loc1),
      body: self.identifierExpr("anna", start: loc2),
      orElse: self.identifierExpr("snowgies", start: loc3)
    )

    if let table = self.createSymbolTable(forStmt: kind) {
      let top = table.top
      XCTAssertScope(top, name: "top", type: .module, flags: [])
      XCTAssert(top.varNames.isEmpty)
      XCTAssert(top.children.isEmpty)

      XCTAssertEqual(top.symbols.count, 3)
      XCTAssertContainsSymbol(top,
                              name: "elsa",
                              flags: [.srcGlobalImplicit, .use],
                              location: loc1)
      XCTAssertContainsSymbol(top,
                              name: "anna",
                              flags: [.srcGlobalImplicit, .use],
                              location: loc2)
      XCTAssertContainsSymbol(top,
                              name: "snowgies",
                              flags: [.srcGlobalImplicit, .use],
                              location: loc3)
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
    let item = self.withItem(
      contextExpr: self.identifierExpr("elsa", start: loc1),
      optionalVars: self.identifierExpr("queen", start: loc2)
    )

    let stmt = self.with(
      items: [item],
      body: [
        self.identifierStmt("queen", exprStart: loc3)
      ]
    )

    if let table = self.createSymbolTable(forStmt: stmt) {
      let top = table.top
      XCTAssertScope(top, name: "top", type: .module, flags: [])
      XCTAssert(top.varNames.isEmpty)
      XCTAssert(top.children.isEmpty)

      XCTAssertEqual(top.symbols.count, 2)
      XCTAssertContainsSymbol(top,
                              name: "elsa",
                              flags: [.srcGlobalImplicit, .use],
                              location: loc1)
      XCTAssertContainsSymbol(top,
                              name: "queen",
                              flags: [.defLocal, .srcLocal, .use],
                              location: loc2)
    }
  }

  // MARK: - Exceptions

  /// raise elsa from arendelle
  ///
  /// ```c
  /// name: top
  /// lineno: 0
  /// symbols:
  ///   elsa - referenced, global,
  ///   arendelle - referenced, global,
  /// ```
  func test_raise() {
    let kind = StatementKind.raise(
      exception: self.identifierExpr("elsa", start: loc1),
      cause: self.identifierExpr("arendelle", start: loc2)
    )

    if let table = self.createSymbolTable(forStmt: kind) {
      let top = table.top
      XCTAssertScope(top, name: "top", type: .module, flags: [])
      XCTAssert(top.varNames.isEmpty)
      XCTAssert(top.children.isEmpty)

      XCTAssertEqual(top.symbols.count, 2)
      XCTAssertContainsSymbol(top,
                              name: "elsa",
                              flags: [.srcGlobalImplicit, .use],
                              location: loc1)
      XCTAssertContainsSymbol(top,
                              name: "arendelle",
                              flags: [.srcGlobalImplicit, .use],
                              location: loc2)
    }
  }

  /// try: magic
  /// except elsa as queen: queen
  /// else: spell
  /// finally: sing
  ///
  /// ```c
  /// name: top
  ///  lineno: 0
  ///  symbols:
  ///    magic - referenced, global,
  ///    spell - referenced, global,
  ///    elsa - referenced, global,
  ///    queen - referenced, local, assigned,
  ///    sing - referenced, global,
  /// ```
  func test_try() {
    let handler = self.exceptHandler(
      type: self.identifierExpr("elsa", start: loc4),
      name: "queen",
      body: self.statement(expr: .identifier("queen")),
      start: loc5
    )

    let stmt = self.try(
      body: self.identifierExpr("magic", start: loc1),
      handlers: [handler],
      orElse: [self.identifierExpr("spell", start: loc2)],
      finalBody: [self.identifierExpr("sing", start: loc3)]
    )

    if let table = self.createSymbolTable(forStmt: stmt) {
      let top = table.top
      XCTAssertScope(top, name: "top", type: .module, flags: [])
      XCTAssert(top.varNames.isEmpty)
      XCTAssert(top.children.isEmpty)

      XCTAssertEqual(top.symbols.count, 5)
      XCTAssertContainsSymbol(top,
                              name: "magic",
                              flags: [.srcGlobalImplicit, .use],
                              location: loc1)
      XCTAssertContainsSymbol(top,
                              name: "spell",
                              flags: [.srcGlobalImplicit, .use],
                              location: loc2)
      XCTAssertContainsSymbol(top,
                              name: "elsa",
                              flags: [.srcGlobalImplicit, .use],
                              location: loc4)
      XCTAssertContainsSymbol(top,
                              name: "queen",
                              flags: [.defLocal, .srcLocal, .use],
                              location: loc5)
      XCTAssertContainsSymbol(top,
                              name: "sing",
                              flags: [.srcGlobalImplicit, .use],
                              location: loc3)
    }
  }
}
