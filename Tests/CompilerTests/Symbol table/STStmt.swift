import XCTest
import VioletCore
import VioletParser
@testable import VioletCompiler

// swiftlint:disable file_length
// swiftlint:disable function_body_length

/// Basic checks for statements, without nested scopes.
/// Just so we know that we visit all childs.
/// Use 'Tools/dump_symtable.py' for reference.
class STStmt: SymbolTableTestCase {

  // MARK: - Pass

  func test_pass() {
    let stmt = self.passStmt()

    if let table = self.createSymbolTable(stmt: stmt) {
      let top = table.top
      XCTAssertScope(top, name: "top", type: .module, flags: [])

      XCTAssert(top.symbols.isEmpty)
      XCTAssert(top.children.isEmpty)
      XCTAssert(top.parameterNames.isEmpty)
    }
  }

  // MARK: - Break, continue

  func test_break() {
    let stmt = self.breakStmt()

    if let table = self.createSymbolTable(stmt: stmt) {
      let top = table.top
      XCTAssertScope(top, name: "top", type: .module, flags: [])

      XCTAssert(top.symbols.isEmpty)
      XCTAssert(top.children.isEmpty)
      XCTAssert(top.parameterNames.isEmpty)
    }
  }

  func test_continue() {
    let stmt = self.continueStmt()

    if let table = self.createSymbolTable(stmt: stmt) {
      let top = table.top
      XCTAssertScope(top, name: "top", type: .module, flags: [])

      XCTAssert(top.symbols.isEmpty)
      XCTAssert(top.children.isEmpty)
      XCTAssert(top.parameterNames.isEmpty)
    }
  }

  // MARK: - Return

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
    let stmt = self.functionDefStmt(
      name: "let_it_go",
      args: self.arguments(args: [self.arg(name: "elsa")]),
      body: [
        self.returnStmt(
          value: self.identifierExpr(value: "elsa", start: loc1)
        )
      ]
    )

    if let table = self.createSymbolTable(stmt: stmt) {
      let top = table.top
      XCTAssertScope(top, name: "top", type: .module, flags: [])
      XCTAssert(top.parameterNames.isEmpty)

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

      XCTAssertEqual(bodyScope.parameterNames.count, 1)
      XCTAssertContainsParameter(bodyScope, name: "elsa")

      // We have '.use' flag, which means that return value was visited
      XCTAssertEqual(bodyScope.symbols.count, 1)
      XCTAssertContainsSymbol(bodyScope,
                              name: "elsa",
                              flags: [.defParam, .srcLocal, .use])
    }
  }

  // MARK: - Delete

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
    let stmt = self.deleteStmt(
      values:
      [
        self.identifierExpr(value: "elsa", context: .del, start: loc1),
        self.identifierExpr(value: "anna", context: .del, start: loc2)
      ]
    )

    if let table = self.createSymbolTable(stmt: stmt) {
      let top = table.top
      XCTAssertScope(top, name: "top", type: .module, flags: [])
      XCTAssert(top.parameterNames.isEmpty)
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

  // MARK: - Assert

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
    let stmt = self.assertStmt(
      test: self.identifierExpr(value: "elsa", start: loc1),
      msg: self.identifierExpr(value: "anna", start: loc2)
    )

    if let table = self.createSymbolTable(stmt: stmt) {
      let top = table.top
      XCTAssertScope(top, name: "top", type: .module, flags: [])
      XCTAssert(top.parameterNames.isEmpty)
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
    let stmt = self.forStmt(
      target: self.identifierExpr(value: "elsa", context: .store, start: loc1),
      iterable: self.identifierExpr(value: "frozen", start: loc2),
      body: [
        self.identifierStmt(value: "elsa", exprStart: loc3)
      ],
      orElse: [
        self.identifierStmt(value: "anna", exprStart: loc4)
      ]
    )

    if let table = self.createSymbolTable(stmt: stmt) {
      let top = table.top
      XCTAssertScope(top, name: "top", type: .module, flags: [])
      XCTAssert(top.parameterNames.isEmpty)
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
    let stmt = self.whileStmt(
      test: self.identifierExpr(value: "elsa", start: loc1),
      body: [
        self.identifierStmt(value: "anna", exprStart: loc2)
      ],
      orElse: [
        self.identifierStmt(value: "snowgies", exprStart: loc3)
      ]
    )

    if let table = self.createSymbolTable(stmt: stmt) {
      let top = table.top
      XCTAssertScope(top, name: "top", type: .module, flags: [])
      XCTAssert(top.parameterNames.isEmpty)
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
    let stmt = self.ifStmt(
      test: self.identifierExpr(value: "elsa", start: loc1),
      body: [self.identifierStmt(value: "anna", exprStart: loc2)],
      orElse: [self.identifierStmt(value: "snowgies", exprStart: loc3)]
    )

    if let table = self.createSymbolTable(stmt: stmt) {
      let top = table.top
      XCTAssertScope(top, name: "top", type: .module, flags: [])
      XCTAssert(top.parameterNames.isEmpty)
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
      contextExpr: self.identifierExpr(value: "elsa", start: loc1),
      optionalVars: self.identifierExpr(value: "queen", context: .store, start: loc2)
    )

    let stmt = self.withStmt(
      items: [item],
      body: [
        self.identifierStmt(value: "queen", exprStart: loc3)
      ]
    )

    if let table = self.createSymbolTable(stmt: stmt) {
      let top = table.top
      XCTAssertScope(top, name: "top", type: .module, flags: [])
      XCTAssert(top.parameterNames.isEmpty)
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
    let stmt = self.raiseStmt(
      exception: self.identifierExpr(value: "elsa", start: loc1),
      cause: self.identifierExpr(value: "arendelle", start: loc2)
    )

    if let table = self.createSymbolTable(stmt: stmt) {
      let top = table.top
      XCTAssertScope(top, name: "top", type: .module, flags: [])
      XCTAssert(top.parameterNames.isEmpty)
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
      kind: .typed(
        type: self.identifierExpr(value: "elsa", start: loc4),
        asName: "queen"
      ),
      body: [self.identifierStmt(value: "queen")],
      start: loc5
    )

    let stmt = self.tryStmt(
      body: [self.identifierStmt(value: "magic", exprStart: loc1)],
      handlers: [handler],
      orElse: [self.identifierStmt(value: "spell", exprStart: loc2)],
      finally: [self.identifierStmt(value: "sing", exprStart: loc3)]
    )

    if let table = self.createSymbolTable(stmt: stmt) {
      let top = table.top
      XCTAssertScope(top, name: "top", type: .module, flags: [])
      XCTAssert(top.parameterNames.isEmpty)
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
