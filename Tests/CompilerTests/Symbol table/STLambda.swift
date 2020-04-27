import XCTest
import VioletCore
import VioletParser
@testable import VioletCompiler

// swiftlint:disable function_body_length

/// Use 'Tools/dump_symtable.py' for reference.
class STLambda: SymbolTableTestCase {

  /// lambda elsa, anna: elsa
  ///
  /// ```c
  /// name: top
  /// lineno: 0
  /// symbols:
  /// children:
  ///   name: lambda
  ///   lineno: 1
  ///   is optimized
  ///   parameters: ('elsa', 'anna')
  ///   locals: ('elsa', 'anna')
  ///   symbols:
  ///     elsa - referenced, parameter, local,
  ///     anna - parameter, local,
  /// ```
  func test_lambda() {
    let expr = self.lambdaExpr(
      args: self.arguments(
        args: [
          self.arg(name: "elsa", annotation: nil, start: loc1),
          self.arg(name: "anna", annotation: nil, start: loc2)
        ]
      ),
      body: self.identifierExpr(value: "elsa", start: loc3)
    )

    if let table = self.createSymbolTable(expr: expr) {
      let top = table.top
      XCTAssertScope(top, name: "top", type: .module, flags: [])
      XCTAssert(top.symbols.isEmpty)
      XCTAssert(top.parameterNames.isEmpty)

      XCTAssertEqual(top.children.count, 1)
      guard top.children.count == 1 else { return }

      let lambdaScope = top.children[0]
      XCTAssertScope(lambdaScope, name: "lambda", type: .function, flags: [.isNested])
      XCTAssert(lambdaScope.children.isEmpty)

      XCTAssertEqual(lambdaScope.parameterNames.count, 2)
      XCTAssertContainsParameter(lambdaScope, name: "elsa")
      XCTAssertContainsParameter(lambdaScope, name: "anna")

      XCTAssertEqual(lambdaScope.symbols.count, 2)
      XCTAssertContainsSymbol(lambdaScope,
                              name: "elsa",
                              flags: [.defParam, .srcLocal, .use],
                              location: loc1)
      XCTAssertContainsSymbol(lambdaScope,
                              name: "anna",
                              flags: [.defParam, .srcLocal],
                              location: loc2)
    }
  }

  /// def let_it_go():
  ///   elsa = 1
  ///   lambda: elsa
  ///
  /// ```c
  /// name: top
  ///  lineno: 0
  ///  symbols:
  ///    let_it_go - local, assigned, namespace,
  ///  children:
  ///    name: let_it_go
  ///    lineno: 2
  ///    is optimized
  ///    locals: ('elsa',)
  ///    symbols:
  ///      elsa - local, assigned, (+ cell)
  ///    children:
  ///      name: lambda
  ///      lineno: 4
  ///      is optimized
  ///      is nested
  ///      frees: ('elsa',)
  ///      symbols:
  ///        elsa - referenced, free,
  /// ```
  func test_lambda_free_cell() {
    let stmt1 = self.assignStmt(
      targets: [
        self.identifierExpr(value: "elsa", context: .store, start: loc1)
      ],
      value: self.intExpr(value: 1)
    )

    let stmt2 = self.exprStmt(
      expression: self.lambdaExpr(
        args: self.arguments(),
        body: self.identifierExpr(value: "elsa", start: loc2)
      )
    )

    let stmt = self.functionDefStmt(
      name: "let_it_go",
      args: self.arguments(),
      body: [stmt1, stmt2],
      start: loc3
    )

    if let table = self.createSymbolTable(stmt: stmt) {
      let top = table.top
      XCTAssertScope(top, name: "top", type: .module, flags: [])
      XCTAssert(top.parameterNames.isEmpty)

      XCTAssertEqual(top.symbols.count, 1)
      XCTAssertContainsSymbol(top,
                              name: "let_it_go",
                              flags: [.defLocal, .srcLocal],
                              location: loc3)

      // function
      XCTAssertEqual(top.children.count, 1)
      guard top.children.count == 1 else { return }

      let defScope = top.children[0]
      XCTAssertScope(defScope, name: "let_it_go", type: .function, flags: [.isNested])
      XCTAssert(defScope.parameterNames.isEmpty)

      XCTAssertEqual(defScope.symbols.count, 1)
      XCTAssertContainsSymbol(defScope,
                              name: "elsa", // missing: srcLocal
                              flags: [.defLocal, .srcLocal, .cell],
                              location: loc1)

      // lambda
      XCTAssertEqual(defScope.children.count, 1)
      guard defScope.children.count == 1 else { return }

      let lambda = defScope.children[0]
      XCTAssertScope(lambda, name: "lambda", type: .function, flags: [.isNested])
      XCTAssert(lambda.parameterNames.isEmpty)
      XCTAssert(lambda.children.isEmpty)

      XCTAssertEqual(lambda.symbols.count, 1)
      XCTAssertContainsSymbol(lambda,
                              name: "elsa",
                              flags: [.use, .srcFree],
                              location: loc2)
    }
  }
}
