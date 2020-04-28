import XCTest
import VioletCore
import VioletParser
@testable import VioletCompiler

// swiftlint:disable file_length
// swiftlint:disable function_body_length

/// Use 'Tools/dump_symtable.py' for reference.
class STFunction: SymbolTableTestCase {

  // MARK: - Arguments

  /// def let_it_go(elsa, anna=sister):
  ///   anna
  ///
  /// ```c
  /// name: top
  /// lineno: 0
  /// symbols:
  ///   let_it_go - local, assigned, namespace,
  ///   sister - referenced, global,
  /// children:
  ///   name: let_it_go
  ///   lineno: 2
  ///   is optimized
  ///   parameters: ('elsa', 'anna')
  ///   locals: ('elsa', 'anna')
  ///   symbols:
  ///     elsa - parameter, local,
  ///     anna - referenced, parameter, local,
  /// ```
  func test_arguments_positional() {
    let arg2Default = self.identifierExpr(value: "sister", start: loc2)

    let stmt = self.functionDefStmt(
      name: "let_it_go",
      args: self.arguments(
        args: [
          self.arg(name: "elsa", annotation: nil, start: loc1),
          self.arg(name: "anna", annotation: arg2Default, start: loc3)
        ]
      ),
      body: [
        self.identifierStmt(value: "anna")
      ],
      start: loc4
    )

    if let table = self.createSymbolTable(stmt: stmt) {
      let top = table.top
      XCTAssertScope(top, name: "top", type: .module, flags: [])
      XCTAssert(top.parameterNames.isEmpty)

      XCTAssertEqual(top.symbols.count, 2)
      XCTAssertContainsSymbol(top,
                              name: "let_it_go",
                              flags: [.defLocal, .srcLocal],
                              location: loc4)
      XCTAssertContainsSymbol(top,
                              name: "sister",
                              flags: [.srcGlobalImplicit, .use],
                              location: loc2)

      XCTAssertEqual(top.children.count, 1)
      guard top.children.count == 1 else { return }

      let nested = top.children[0]
      XCTAssertScope(nested, name: "let_it_go", type: .function, flags: [.isNested])
      XCTAssert(nested.children.isEmpty)

      XCTAssertEqual(nested.parameterNames.count, 2)
      XCTAssertContainsParameter(nested, name: "elsa")
      XCTAssertContainsParameter(nested, name: "anna")

      XCTAssertEqual(nested.symbols.count, 2)
      XCTAssertContainsSymbol(nested,
                              name: "elsa",
                              flags: [.defParam, .srcLocal],
                              location: loc1)
      XCTAssertContainsSymbol(nested,
                              name: "anna",
                              flags: [.defParam, .srcLocal, .use],
                              location: loc3)
    }
  }

  /// def let_it_go(*elsa, anna=sister):
  ///   anna
  ///
  /// ```c
  /// name: top
  /// lineno: 0
  /// symbols:
  ///   let_it_go - local, assigned, namespace,
  ///   sister - referenced, global,
  /// children:
  ///   name: let_it_go
  ///   lineno: 2
  ///   is optimized
  ///   parameters: ('anna', 'elsa')
  ///   locals: ('anna', 'elsa')
  ///   symbols:
  ///     anna - referenced, parameter, local,
  ///     elsa - parameter, local,
  /// ```
  func test_arguments_vararg_keywordOnly() {
    let vararg = self.arg(name: "elsa", annotation: nil, start: loc1)

    let argDefault = self.identifierExpr(value: "sister", start: loc2)
    let arg = self.arg(name: "anna", annotation: argDefault, start: loc3)

    let stmt = self.functionDefStmt(
      name: "let_it_go",
      args: self.arguments(
        vararg: .named(vararg),
        kwOnlyArgs: [arg],
        kwOnlyDefaults: [argDefault]
      ),
      body: [self.identifierStmt(value: "anna")],
      start: loc4
    )

    if let table = self.createSymbolTable(stmt: stmt) {
      let top = table.top
      XCTAssertScope(top, name: "top", type: .module, flags: [])
      XCTAssert(top.parameterNames.isEmpty)

      XCTAssertEqual(top.symbols.count, 2)
      XCTAssertContainsSymbol(top,
                              name: "let_it_go",
                              flags: [.defLocal, .srcLocal],
                              location: loc4)
      XCTAssertContainsSymbol(top,
                              name: "sister",
                              flags: [.srcGlobalImplicit, .use],
                              location: loc2)

      XCTAssertEqual(top.children.count, 1)
      guard top.children.count == 1 else { return }

      let nested = top.children[0]
      XCTAssertScope(nested, name: "let_it_go", type: .function, flags: [.isNested, .hasVarargs])
      XCTAssert(nested.children.isEmpty)

      XCTAssertEqual(nested.parameterNames.count, 2)
      XCTAssertContainsParameter(nested, name: "elsa")
      XCTAssertContainsParameter(nested, name: "anna")

      XCTAssertEqual(nested.symbols.count, 2)
      XCTAssertContainsSymbol(nested,
                              name: "elsa",
                              flags: [.defParam, .srcLocal],
                              location: loc1)
      XCTAssertContainsSymbol(nested,
                              name: "anna",
                              flags: [.defParam, .srcLocal, .use],
                              location: loc3)
    }
  }

  /// def let_it_go(**elsa):
  ///   elsa
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
  func test_arguments_kwarg() {
    let arg = self.arg(name: "elsa", annotation: nil, start: loc1)

    let stmt = self.functionDefStmt(
      name: "let_it_go",
      args: self.arguments(kwarg: arg),
      body: [self.identifierStmt(value: "elsa")],
      start: loc4
    )

    if let table = self.createSymbolTable(stmt: stmt) {
      let top = table.top
      XCTAssertScope(top, name: "top", type: .module, flags: [])
      XCTAssert(top.parameterNames.isEmpty)

      XCTAssertEqual(top.symbols.count, 1)
      XCTAssertContainsSymbol(top,
                              name: "let_it_go",
                              flags: [.defLocal, .srcLocal],
                              location: loc4)

      XCTAssertEqual(top.children.count, 1)
      guard top.children.count == 1 else { return }

      let nested = top.children[0]
      XCTAssertScope(nested,
                     name: "let_it_go",
                     type: .function,
                     flags: [.isNested, .hasVarKeywords])
      XCTAssert(nested.children.isEmpty)

      XCTAssertEqual(nested.parameterNames.count, 1)
      XCTAssertContainsParameter(nested, name: "elsa")

      XCTAssertEqual(nested.symbols.count, 1)
      XCTAssertContainsSymbol(nested,
                              name: "elsa",
                              flags: [.defParam, .srcLocal, .use],
                              location: loc1)
    }
  }

  // MARK: - Async

  /// async def let_it_go():
  ///   pass
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
  ///   symbols:
  /// ```
  func test_arguments_async() {
    let stmt = self.asyncFunctionDefStmt(
      name: "let_it_go",
      args: self.arguments(),
      body: [self.passStmt()],
      start: loc4
    )

    if let table = self.createSymbolTable(stmt: stmt) {
      let top = table.top
      XCTAssertScope(top, name: "top", type: .module, flags: [])
      XCTAssert(top.parameterNames.isEmpty)

      XCTAssertEqual(top.symbols.count, 1)
      XCTAssertContainsSymbol(top,
                              name: "let_it_go",
                              flags: [.defLocal, .srcLocal],
                              location: loc4)

      XCTAssertEqual(top.children.count, 1)
      guard top.children.count == 1 else { return }

      let nested = top.children[0]
      XCTAssertScope(nested,
                     name: "let_it_go",
                     type: .function,
                     flags: [.isNested, .isCoroutine])
      XCTAssert(nested.children.isEmpty)
      XCTAssert(nested.parameterNames.isEmpty)
      XCTAssert(nested.symbols.isEmpty)
    }
  }

  // MARK: - Returns

  /// def let_it_go(elsa) -> Int:
  ///   return elsa
  ///
  /// ```c
  /// name: top
  /// lineno: 0
  /// symbols:
  ///   let_it_go - local, assigned, namespace,
  ///   Int - referenced, global,
  /// children:
  ///   name: let_it_go
  ///   lineno: 2
  ///   is optimized
  ///   parameters: ('elsa',)
  ///   locals: ('elsa',)
  ///   symbols:
  ///     elsa - referenced, parameter, local,
  /// ```
  func test_returns() {
    let arg = self.arg(name: "elsa", annotation: nil, start: loc1)
    let ret = self.identifierExpr(value: "Int", start: loc2)

    let stmt = self.functionDefStmt(
      name: "let_it_go",
      args: self.arguments(args: [arg]),
      body: [
        self.identifierStmt(value: "elsa")
      ],
      returns: ret,
      start: loc4
    )

    if let table = self.createSymbolTable(stmt: stmt) {
      let top = table.top
      XCTAssertScope(top, name: "top", type: .module, flags: [])
      XCTAssert(top.parameterNames.isEmpty)
      XCTAssertEqual(top.children.count, 1)

      XCTAssertEqual(top.symbols.count, 2)
      XCTAssertContainsSymbol(top,
                              name: "let_it_go",
                              flags: [.defLocal, .srcLocal],
                              location: loc4)
      XCTAssertContainsSymbol(top,
                              name: "Int",
                              flags: [.srcGlobalImplicit, .use],
                              location: loc2)
    }
  }

  // MARK: - Nonlocal

  /// def let_it_go():
  ///   elsa = 1
  ///   def sing():
  ///     nonlocal elsa
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
  ///   locals: ('elsa', 'sing')
  ///   symbols:
  ///     elsa - local, assigned,
  ///     sing - local, assigned, namespace,
  ///   children:
  ///     name: sing
  ///     lineno: 4
  ///     is optimized
  ///     is nested
  ///     frees: ('elsa',)
  ///     symbols:
  ///       elsa - free,
  /// ```
  func test_nonlocal() {
    let assign = self.assignStmt(
      targets: [
        self.identifierExpr(value: "elsa", context: .store, start: loc1)
      ],
      value: self.intExpr(value: 1)
    )

    let inner = self.functionDefStmt(
      name: "sing",
      args: self.arguments(),
      body: [self.nonlocalStmt(identifier: "elsa", start: loc2)],
      start: loc3
    )

    let outer = self.functionDefStmt(
      name: "let_it_go",
      args: self.arguments(),
      body: [assign, inner],
      start: loc4
    )

    if let table = self.createSymbolTable(stmt: outer) {
      let top = table.top
      XCTAssertScope(top, name: "top", type: .module, flags: [])
      XCTAssert(top.parameterNames.isEmpty)

      XCTAssertEqual(top.symbols.count, 1)
      XCTAssertContainsSymbol(top,
                              name: "let_it_go",
                              flags: [.defLocal, .srcLocal],
                              location: loc4)

      // let_it_go
      XCTAssertEqual(top.children.count, 1)
      guard top.children.count == 1 else { return }

      let letItGo = top.children[0]
      XCTAssertScope(letItGo, name: "let_it_go", type: .function, flags: [.isNested])
      XCTAssert(letItGo.parameterNames.isEmpty)

      XCTAssertEqual(letItGo.symbols.count, 2)
      XCTAssertContainsSymbol(letItGo,
                              name: "elsa",
                              flags: [.defLocal, .srcLocal, .cell],
                              location: loc1)
      XCTAssertContainsSymbol(letItGo,
                              name: "sing",
                              flags: [.defLocal, .srcLocal],
                              location: loc3)

      // sing
      XCTAssertEqual(letItGo.children.count, 1)
      guard letItGo.children.count == 1 else { return }

      let sing = letItGo.children[0]
      XCTAssertScope(sing, name: "sing", type: .function, flags: [.isNested])
      XCTAssert(sing.parameterNames.isEmpty)
      XCTAssert(sing.children.isEmpty)

      XCTAssertEqual(sing.symbols.count, 1)
      XCTAssertContainsSymbol(sing,
                              name: "elsa",
                              flags: [.defNonlocal, .srcFree],
                              location: loc2)
    }
  }

  // MARK: - Error - Nonlocal and global

  /// def let_it_go():
  ///   elsa = 1
  ///   def sing():
  ///     nonlocal elsa
  ///     global elsa
  func test_nonlocal_thenGlobal_throws() {
    let stmt1 = self.assignStmt(
      targets: [self.identifierExpr(value: "elsa")],
      value: self.intExpr(value: 1)
    )

    let stmt2 = self.nonlocalStmt(identifier: "elsa", start: loc1)
    let stmt3 = self.globalStmt(identifier: "elsa")

    let inner = self.functionDefStmt(
      name: "sing",
      args: self.arguments(),
      body: [stmt2, stmt3]
    )

    let outer = self.functionDefStmt(
      name: "let_it_go",
      args: self.arguments(),
      body: [stmt1, inner]
    )

    if let error = self.error(forStmt: outer) {
      XCTAssertEqual(error.kind, .bothGlobalAndNonlocal("elsa"))
      XCTAssertEqual(error.location, loc1)
    }
  }

  /// def let_it_go():
  ///   elsa = 1
  ///   def sing():
  ///     global elsa
  ///     nonlocal elsa
  func test_global_thenNonlocal_throws() {
    let stmt1 = self.assignStmt(
      targets: [self.identifierExpr(value: "elsa")],
      value: self.intExpr(value: 1)
    )

    let stmt2 = self.globalStmt(identifier: "elsa", start: loc1)
    let stmt3 = self.nonlocalStmt(identifier: "elsa")

    let inner = self.functionDefStmt(
      name: "sing",
      args: self.arguments(),
      body: [stmt2, stmt3]
    )

    let outer = self.functionDefStmt(
      name: "let_it_go",
      args: self.arguments(),
      body: [stmt1, inner]
    )

    if let error = self.error(forStmt: outer) {
      XCTAssertEqual(error.kind, .bothGlobalAndNonlocal("elsa"))
      XCTAssertEqual(error.location, loc1)
    }
  }

  // MARK: - Error - Nonlocal without binding

  /// def let_it_go():
  ///   nonlocal elsa
  func test_nonlocal_withoutBinding_throws() {
    let outer = self.functionDefStmt(
      name: "let_it_go",
      args: self.arguments(),
      body: [
        self.nonlocalStmt(identifier: "elsa", start: loc1)
      ]
    )

    if let error = self.error(forStmt: outer) {
      XCTAssertEqual(error.kind, .nonlocalWithoutBinding("elsa"))
      XCTAssertEqual(error.location, loc1)
    }
  }

  // MARK: - Error - Duplicate argument

  func test_duplicateArgument_args_args_throws() {
    let arg0 = self.arg(name: "elsa", annotation: nil)
    let arg1 = self.arg(name: "elsa", annotation: nil, start: loc1)

    let def = self.functionDefStmt(
      name: "let_it_go",
      args: self.arguments(
        args: [arg0, arg1]
      ),
      body: [self.passStmt()]
    )

    if let error = self.error(forStmt: def) {
      XCTAssertEqual(error.kind, .duplicateArgument("elsa"))
      XCTAssertEqual(error.location, loc1)
    }
  }

  func test_duplicateArgument_args_vararg_throws() {
    let arg0 = self.arg(name: "elsa", annotation: nil)
    let arg1 = self.arg(name: "elsa", annotation: nil, start: loc1)

    let def = self.functionDefStmt(
      name: "let_it_go",
      args: self.arguments(
        args: [arg0],
        vararg: .named(arg1)
      ),
      body: [self.passStmt()]
    )

    if let error = self.error(forStmt: def) {
      XCTAssertEqual(error.kind, .duplicateArgument("elsa"))
      XCTAssertEqual(error.location, loc1)
    }
  }

  func test_duplicateArgument_vararg_kwOnlyArgs_throws() {
    let arg0 = self.arg(name: "elsa", annotation: nil)
    let arg1 = self.arg(name: "elsa", annotation: nil, start: loc1)

    let def = self.functionDefStmt(
      name: "let_it_go",
      args: self.arguments(
        vararg: .named(arg0),
        kwOnlyArgs: [arg1]
      ),
      body: [self.passStmt()]
    )

    if let error = self.error(forStmt: def) {
      XCTAssertEqual(error.kind, .duplicateArgument("elsa"))
      XCTAssertEqual(error.location, loc1)
    }
  }

  func test_duplicateArgument_kwOnlyArgs_kwarg_throws() {
    let arg0 = self.arg(name: "elsa", annotation: nil)
    let arg1 = self.arg(name: "elsa", annotation: nil, start: loc1)

    let def = self.functionDefStmt(
      name: "let_it_go",
      args: self.arguments(
        kwOnlyArgs: [arg0],
        kwarg: arg1
      ),
      body: [self.passStmt()]
    )

    if let error = self.error(forStmt: def) {
      XCTAssertEqual(error.kind, .duplicateArgument("elsa"))
      XCTAssertEqual(error.location, loc1)
    }
  }

  // MARK: - Local variable

  /// def let_it_go(): x = 2
  ///
  /// ```c
  /// name: top
  /// lineno: 0
  /// symbols:
  ///   let_it_go - local, assigned, namespace,
  /// children:
  ///   name: let_it_go
  ///   lineno: 1
  ///   is optimized
  ///   locals: ('elsa',)
  ///   symbols:
  ///     elsa - local, assigned,
  /// ```
  func test_localVariable() {
    let stmt = self.functionDefStmt(
      name: "let_it_go",
      args: self.arguments(),
      body: [
        self.assignStmt(
          targets: [self.identifierExpr(value: "elsa", context: .store, start: loc0)],
          value: self.intExpr(value: 2)
        )
      ],
      start: loc4
    )

    if let table = self.createSymbolTable(stmt: stmt) {
      let top = table.top
      XCTAssertScope(top, name: "top", type: .module, flags: [])
      XCTAssert(top.parameterNames.isEmpty)

      XCTAssertEqual(top.symbols.count, 1)
      XCTAssertContainsSymbol(top,
                              name: "let_it_go",
                              flags: [.defLocal, .srcLocal],
                              location: loc4)

      XCTAssertEqual(top.children.count, 1)
      guard top.children.count == 1 else { return }

      let letItGo = top.children[0]
      XCTAssertScope(letItGo, name: "let_it_go", type: .function, flags: [.isNested])
      XCTAssert(letItGo.parameterNames.isEmpty)
      XCTAssertEqual(letItGo.children.count, 0)

      XCTAssertEqual(letItGo.symbols.count, 1)
      XCTAssertContainsSymbol(letItGo,
                              name: "elsa",
                              flags: [.defLocal, .srcLocal],
                              location: loc0)
    }
  }
}
