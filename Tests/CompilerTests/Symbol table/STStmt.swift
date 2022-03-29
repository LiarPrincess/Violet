import XCTest
import VioletCore
import VioletParser
@testable import VioletCompiler

/// Basic checks for statements, without nested scopes.
/// Just so we know that we visit all children.
/// Use 'Tools/dump_symtable.py' for reference.
class STStmt: SymbolTableTestCase {

  // MARK: - Pass

  func test_pass() {
    let stmt = self.passStmt()

    guard let table = self.createSymbolTable(stmt: stmt) else {
      return
    }

    XCTAssertScope(
      table.top,
      name: "top",
      kind: .module,
      flags: [],
      symbols: [],
      parameters: [],
      childrenCount: 0
    )
  }

  // MARK: - Break, continue

  func test_break() {
    let stmt = self.breakStmt()

    guard let table = self.createSymbolTable(stmt: stmt) else {
      return
    }

    XCTAssertScope(
      table.top,
      name: "top",
      kind: .module,
      flags: [],
      symbols: [],
      parameters: [],
      childrenCount: 0
    )
  }

  func test_continue() {
    let stmt = self.continueStmt()

    guard let table = self.createSymbolTable(stmt: stmt) else {
      return
    }

    XCTAssertScope(
      table.top,
      name: "top",
      kind: .module,
      flags: [],
      symbols: [],
      parameters: [],
      childrenCount: 0
    )
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

    guard let table = self.createSymbolTable(stmt: stmt) else {
      return
    }

    XCTAssertScope(
      table.top,
      name: "top",
      kind: .module,
      flags: [],
      symbols: [
        .init(name: "let_it_go", flags: [.defLocal, .srcLocal])
      ],
      parameters: [],
      childrenCount: 1
    )

    guard let function = self.getChildScope(table.top, at: 0) else {
      return
    }

    XCTAssertScope(
      function,
      name: "let_it_go",
      kind: .function,
      flags: [.hasReturnValue, .isNested],
      symbols: [
        // We have '.use' flag, which means that return value was visited
        .init(name: "elsa", flags: [.defParam, .srcLocal, .use])
      ],
      parameters: ["elsa"],
      childrenCount: 0
    )
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

    guard let table = self.createSymbolTable(stmt: stmt) else {
      return
    }

    XCTAssertScope(
      table.top,
      name: "top",
      kind: .module,
      flags: [],
      symbols: [
        .init(name: "elsa", flags: [.srcGlobalImplicit, .use], location: loc1),
        .init(name: "anna", flags: [.srcGlobalImplicit, .use], location: loc2)
      ],
      parameters: [],
      childrenCount: 0
    )
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

    guard let table = self.createSymbolTable(stmt: stmt) else {
      return
    }

    XCTAssertScope(
      table.top,
      name: "top",
      kind: .module,
      flags: [],
      symbols: [
        .init(name: "elsa", flags: [.srcGlobalImplicit, .use], location: loc1),
        .init(name: "anna", flags: [.srcGlobalImplicit, .use], location: loc2)
      ],
      parameters: [],
      childrenCount: 0
    )
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

    guard let table = self.createSymbolTable(stmt: stmt) else {
      return
    }

    XCTAssertScope(
      table.top,
      name: "top",
      kind: .module,
      flags: [],
      symbols: [
        .init(name: "elsa", flags: [.defLocal, .srcLocal, .use], location: loc1),
        .init(name: "frozen", flags: [.srcGlobalImplicit, .use], location: loc2),
        .init(name: "anna", flags: [.srcGlobalImplicit, .use], location: loc4)
      ],
      parameters: [],
      childrenCount: 0
    )
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

    guard let table = self.createSymbolTable(stmt: stmt) else {
      return
    }

    XCTAssertScope(
      table.top,
      name: "top",
      kind: .module,
      flags: [],
      symbols: [
        .init(name: "elsa", flags: [.srcGlobalImplicit, .use], location: loc1),
        .init(name: "anna", flags: [.srcGlobalImplicit, .use], location: loc2),
        .init(name: "snowgies", flags: [.srcGlobalImplicit, .use], location: loc3)
      ],
      parameters: [],
      childrenCount: 0
    )
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

    guard let table = self.createSymbolTable(stmt: stmt) else {
      return
    }

    XCTAssertScope(
      table.top,
      name: "top",
      kind: .module,
      flags: [],
      symbols: [
        .init(name: "elsa", flags: [.srcGlobalImplicit, .use], location: loc1),
        .init(name: "anna", flags: [.srcGlobalImplicit, .use], location: loc2),
        .init(name: "snowgies", flags: [.srcGlobalImplicit, .use], location: loc3)
      ],
      parameters: [],
      childrenCount: 0
    )
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

    guard let table = self.createSymbolTable(stmt: stmt) else {
      return
    }

    XCTAssertScope(
      table.top,
      name: "top",
      kind: .module,
      flags: [],
      symbols: [
        .init(name: "elsa", flags: [.srcGlobalImplicit, .use], location: loc1),
        .init(name: "queen", flags: [.defLocal, .srcLocal, .use], location: loc2)
      ],
      parameters: [],
      childrenCount: 0
    )
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

    guard let table = self.createSymbolTable(stmt: stmt) else {
      return
    }

    XCTAssertScope(
      table.top,
      name: "top",
      kind: .module,
      flags: [],
      symbols: [
        .init(name: "elsa", flags: [.srcGlobalImplicit, .use], location: loc1),
        .init(name: "arendelle", flags: [.srcGlobalImplicit, .use], location: loc2)
      ],
      parameters: [],
      childrenCount: 0
    )
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

    guard let table = self.createSymbolTable(stmt: stmt) else {
      return
    }

    XCTAssertScope(
      table.top,
      name: "top",
      kind: .module,
      flags: [],
      symbols: [
        .init(name: "magic", flags: [.srcGlobalImplicit, .use], location: loc1),
        .init(name: "elsa", flags: [.srcGlobalImplicit, .use], location: loc4),
        .init(name: "queen", flags: [.defLocal, .srcLocal, .use], location: loc5),
        .init(name: "spell", flags: [.srcGlobalImplicit, .use], location: loc2),
        .init(name: "sing", flags: [.srcGlobalImplicit, .use], location: loc3)
      ],
      parameters: [],
      childrenCount: 0
    )
  }
}
