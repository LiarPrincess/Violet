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
    let expr = self.expression(.identifier("elsa"), start: loc1)
    let body = self.statement(.return(expr))

    let f = self.functionDefStmt(name: "let_it_go",
                                 args: self.arguments(args: [arg]),
                                 body: body)

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
      XCTAssertScope(bodyScope, name: "let_it_go", type: .function, flags: [.hasReturnValue, .isNested])
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
    let expr1 = self.expression(.identifier("elsa"), start: loc1)
    let expr2 = self.expression(.identifier("anna"), start: loc2)
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
    let expr1 = self.expression(.identifier("elsa"), start: loc1)
    let expr2 = self.expression(.identifier("anna"), start: loc2)
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
    let target = self.expression(.identifier("elsa"), start: loc1)
    let iter = self.expression(.identifier("frozen"), start: loc2)
    let body = self.expression(.identifier("elsa"), start: loc3)
    let orElse = self.expression(.identifier("anna"), start: loc4)

    let kind = self.forStmt(target: target, iter: iter, body: body, orElse: orElse)

    if let table = self.createSymbolTable(forStmt: kind) {
      let top = table.top
      XCTAssertScope(top, name: "top", type: .module, flags: [])
      XCTAssert(top.varnames.isEmpty)
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
    let test = self.expression(.identifier("elsa"), start: loc1)
    let body = self.expression(.identifier("anna"), start: loc2)
    let orElse = self.expression(.identifier("snowgies"), start: loc3)

    let kind = self.whileStmt(test: test, body: body, orElse: orElse)

    if let table = self.createSymbolTable(forStmt: kind) {
      let top = table.top
      XCTAssertScope(top, name: "top", type: .module, flags: [])
      XCTAssert(top.varnames.isEmpty)
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
    let test = self.expression(.identifier("elsa"), start: loc1)
    let body = self.expression(.identifier("anna"), start: loc2)
    let orElse = self.expression(.identifier("snowgies"), start: loc3)

    let kind = self.ifStmt(test: test, body: body, orElse: orElse)

    if let table = self.createSymbolTable(forStmt: kind) {
      let top = table.top
      XCTAssertScope(top, name: "top", type: .module, flags: [])
      XCTAssert(top.varnames.isEmpty)
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
    let ctx = self.expression(.identifier("elsa"), start: loc1)
    let name = self.expression(.identifier("queen"), start: loc2)

    let bodyExpr = self.expression(.identifier("queen"), start: loc3)
    let body = self.statement(.expr(bodyExpr))

    let item = self.withItem(contextExpr: ctx, optionalVars: name)
    let kind = StatementKind.with(items: NonEmptyArray(first: item),
                                  body:  NonEmptyArray(first: body))

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
    let exc = self.expression(.identifier("elsa"), start: loc1)
    let cause = self.expression(.identifier("arendelle"), start: loc2)

    let kind = StatementKind.raise(exc: exc, cause: cause)

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
    let body = self.expression(.identifier("magic"), start: loc1)
    let orElse = self.expression(.identifier("spell"), start: loc2)
    let finalBody = self.expression(.identifier("sing"), start: loc3)

    let handlerType = self.expression(.identifier("elsa"), start: loc4)
    let handlerBody = self.statement(expr: .identifier("queen"))
    let handler = self.exceptHandler(type: handlerType,
                                     name: "queen",
                                     body: handlerBody,
                                     start: loc5)

    let stmt = self.tryStmt(body: body,
                            handlers: [handler],
                            orElse: orElse,
                            finalBody: finalBody)

    if let table = self.createSymbolTable(forStmt: stmt) {
      let top = table.top
      XCTAssertScope(top, name: "top", type: .module, flags: [])
      XCTAssert(top.varnames.isEmpty)
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

  // MARK: - import

  /// import frozen, tangled
  ///
  /// ```c
  /// name: top
  /// lineno: 0
  /// symbols:
  ///   frozen - imported, local,
  ///   tangled - imported, local,
  /// ```
  func test_import() {
    let alias1 = self.alias(name: "frozen",  asName: nil, start: loc1)
    let alias2 = self.alias(name: "tangled", asName: nil, start: loc2)

    let stmt = self.importStmt(names: [alias1, alias2])

    if let table = self.createSymbolTable(forStmt: stmt) {
      let top = table.top
      XCTAssertScope(top, name: "top", type: .module, flags: [])
      XCTAssert(top.varnames.isEmpty)
      XCTAssert(top.children.isEmpty)

      XCTAssertEqual(top.symbols.count, 2)
      XCTAssertContainsSymbol(top,
                              name: "frozen",
                              flags: [.defImport, .srcLocal],
                              location: loc1)
      XCTAssertContainsSymbol(top,
                              name: "tangled",
                              flags: [.defImport, .srcLocal],
                              location: loc2)
    }
  }

  /// import frozen, tangled as bestMovieEver
  func test_import_withAlias() {
    let alias1 = self.alias(name: "frozen",  asName: nil, start: loc1)
    let alias2 = self.alias(name: "tangled", asName: "bestMovieEver", start: loc2)

    let stmt = self.importStmt(names: [alias1, alias2])

    if let table = self.createSymbolTable(forStmt: stmt) {
      let top = table.top
      XCTAssertScope(top, name: "top", type: .module, flags: [])
      XCTAssert(top.varnames.isEmpty)
      XCTAssert(top.children.isEmpty)

      XCTAssertEqual(top.symbols.count, 2)
      XCTAssertContainsSymbol(top,
                              name: "frozen",
                              flags: [.defImport, .srcLocal],
                              location: loc1)
      XCTAssertContainsSymbol(top,
                              name: "bestMovieEver",
                              flags: [.defImport, .srcLocal],
                              location: loc2)
    }
  }

  /// import tangled.rapunzel
  ///
  /// ```c
  /// name: top
  /// lineno: 0
  /// symbols:
  ///   tangled - imported, local,
  /// ```
  func test_import_withAttribute() {
    let alias = self.alias(name: "tangled.rapunzel", asName: nil, start: loc1)

    let stmt = self.importStmt(names: [alias])

    if let table = self.createSymbolTable(forStmt: stmt) {
      let top = table.top
      XCTAssertScope(top, name: "top", type: .module, flags: [])
      XCTAssert(top.varnames.isEmpty)
      XCTAssert(top.children.isEmpty)

      XCTAssertEqual(top.symbols.count, 1)
      XCTAssertContainsSymbol(top,
                              name: "tangled",
                              flags: [.defImport, .srcLocal],
                              location: loc1)
    }
  }

  /// from disnep import elsa, rapunzel
  ///
  /// ```c
  /// name: top
  /// lineno: 0
  /// symbols:
  ///   elsa - imported, local,
  ///   rapunzel - imported, local,
  /// ```
  func test_importFrom() {
    let alias1 = self.alias(name: "elsa",     asName: nil, start: loc1)
    let alias2 = self.alias(name: "rapunzel", asName: nil, start: loc2)

    let stmt = self.importFromStmt(moduleName: "disnep",
                                   names: [alias1, alias2])

    if let table = self.createSymbolTable(forStmt: stmt) {
      let top = table.top
      XCTAssertScope(top, name: "top", type: .module, flags: [])
      XCTAssert(top.varnames.isEmpty)
      XCTAssert(top.children.isEmpty)

      XCTAssertEqual(top.symbols.count, 2)
      XCTAssertContainsSymbol(top,
                              name: "elsa",
                              flags: [.defImport, .srcLocal],
                              location: loc1)
      XCTAssertContainsSymbol(top,
                              name: "rapunzel",
                              flags: [.defImport, .srcLocal],
                              location: loc2)
    }
  }

  /// from disnep import elsa, rapunzel as princess
  ///
  /// ```c
  /// name: top
  /// lineno: 0
  /// symbols:
  ///   elsa - imported, local,
  ///   princess - imported, local,
  /// ```
  func test_importFrom_withAlias() {
    let alias1 = self.alias(name: "elsa",     asName: nil, start: loc1)
    let alias2 = self.alias(name: "rapunzel", asName: "princess", start: loc2)

    let stmt = self.importFromStmt(moduleName: "disnep",
                                   names: [alias1, alias2])

    if let table = self.createSymbolTable(forStmt: stmt) {
      let top = table.top
      XCTAssertScope(top, name: "top", type: .module, flags: [])
      XCTAssert(top.varnames.isEmpty)
      XCTAssert(top.children.isEmpty)

      XCTAssertEqual(top.symbols.count, 2)
      XCTAssertContainsSymbol(top,
                              name: "elsa",
                              flags: [.defImport, .srcLocal],
                              location: loc1)
      XCTAssertContainsSymbol(top,
                              name: "princess",
                              flags: [.defImport, .srcLocal],
                              location: loc2)
    }
  }

  /// from disnep import *
  ///
  /// ```c
  /// name: top
  /// lineno: 0
  /// symbols:
  /// ```
  func test_importFrom_withStar() {
    let alias = self.alias(name: "*", asName: nil, start: loc1)
    let stmt = self.importFromStmt(moduleName: "disnep", names: [alias])

    if let table = self.createSymbolTable(forStmt: stmt) {
      let top = table.top
      XCTAssertScope(top, name: "top", type: .module, flags: [])
      XCTAssert(top.varnames.isEmpty)
      XCTAssert(top.children.isEmpty)
      XCTAssert(top.symbols.isEmpty)
    }
  }

  /// ```c
  /// def sing():
  ///   from disnep import *
  /// ```
  func test_importFrom_withStar_inFunction_throws() {
    let alias = self.alias(name: "*", asName: nil)
    let importStmt = self.importFromStmt(moduleName: "disnep",
                                         names: [alias],
                                         start: loc1)

    let stmt = self.functionDefStmt(name: "sing",
                                    args: self.arguments(),
                                    body: importStmt)

    if let error = self.error(forStmt: stmt) {
      XCTAssertEqual(error.kind, .nonModuleImportStar)
      XCTAssertEqual(error.location, loc1)
    }
  }
}
