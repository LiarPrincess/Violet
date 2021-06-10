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

    guard let table = self.createSymbolTable(expr: expr) else {
      return
    }

    XCTAssertScope(
      table.top,
      name: "top",
      kind: .module,
      flags: [],
      symbols: [],
      parameters: [],
      childrenCount: 1
    )

    guard let lambda = self.getChildScope(table.top, at: 0) else {
      return
    }

    XCTAssertScope(
      lambda,
      name: "lambda",
      kind: .lambda,
      flags: [.isNested],
      symbols: [
        .init(name: "elsa", flags: [.defParam, .srcLocal, .use], location: loc1),
        .init(name: "anna", flags: [.defParam, .srcLocal], location: loc2)
      ],
      parameters: ["elsa", "anna"],
      childrenCount: 0
    )
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

    guard let table = self.createSymbolTable(stmt: stmt) else {
      return
    }

    XCTAssertScope(
      table.top,
      name: "top",
      kind: .module,
      flags: [],
      symbols: [
        .init(name: "let_it_go", flags: [.defLocal, .srcLocal], location: loc3)
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
      flags: [.isNested],
      symbols: [
        .init(name: "elsa", flags: [.defLocal, .srcLocal, .cell], location: loc1)
      ],
      parameters: [],
      childrenCount: 1
    )

    guard let lambda = self.getChildScope(function, at: 0) else {
      return
    }

    XCTAssertScope(
      lambda,
      name: "lambda",
      kind: .lambda,
      flags: [.isNested],
      symbols: [
        .init(name: "elsa", flags: [.use, .srcFree], location: loc2)
      ],
      parameters: [],
      childrenCount: 0
    )
  }
}
