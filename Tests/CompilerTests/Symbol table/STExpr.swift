import XCTest
import VioletCore
import VioletParser
@testable import VioletCompiler

// swiftlint:disable file_length

/// Basic checks for expressions, without nested scopes.
/// Just so we know that we visit all children.
/// Use 'Tools/dump_symtable.py' for reference.
class STExpr: SymbolTableTestCase {

  // MARK: - Empty

  func test_empty() {
    if let table = self.createSymbolTable(stmts: []) {
      let top = table.top
      XCTAssertScope(top, name: "top", kind: .module, flags: [])

      XCTAssert(top.symbols.isEmpty)
      XCTAssert(top.children.isEmpty)
      XCTAssert(top.parameterNames.isEmpty)
    }
  }

  // MARK: - Bool

  func test_true() {
    let expr = self.trueExpr()

    if let table = self.createSymbolTable(expr: expr) {
      let top = table.top
      XCTAssertScope(top, name: "top", kind: .module, flags: [])

      XCTAssert(top.symbols.isEmpty)
      XCTAssert(top.children.isEmpty)
      XCTAssert(top.parameterNames.isEmpty)
    }
  }

  func test_false() {
    let expr = self.falseExpr()

    if let table = self.createSymbolTable(expr: expr) {
      let top = table.top
      XCTAssertScope(top, name: "top", kind: .module, flags: [])

      XCTAssert(top.symbols.isEmpty)
      XCTAssert(top.children.isEmpty)
      XCTAssert(top.parameterNames.isEmpty)
    }
  }

  // MARK: - None

  func test_none() {
    let expr = self.noneExpr()

    if let table = self.createSymbolTable(expr: expr) {
      let top = table.top
      XCTAssertScope(top, name: "top", kind: .module, flags: [])

      XCTAssert(top.symbols.isEmpty)
      XCTAssert(top.children.isEmpty)
      XCTAssert(top.parameterNames.isEmpty)
    }
  }

  // MARK: - Ellipsis

  func test_ellipsis() {
    let expr = self.ellipsisExpr()

    if let table = self.createSymbolTable(expr: expr) {
      let top = table.top
      XCTAssertScope(top, name: "top", kind: .module, flags: [])

      XCTAssert(top.symbols.isEmpty)
      XCTAssert(top.children.isEmpty)
      XCTAssert(top.parameterNames.isEmpty)
    }
  }

  // MARK: - Int

  func test_int() {
    let expr = self.intExpr(value: 1)

    if let table = self.createSymbolTable(expr: expr) {
      let top = table.top
      XCTAssertScope(top, name: "top", kind: .module, flags: [])

      XCTAssert(top.symbols.isEmpty)
      XCTAssert(top.children.isEmpty)
      XCTAssert(top.parameterNames.isEmpty)
    }
  }

  // MARK: - Float

  func test_float() {
    let expr = self.floatExpr(value: 2.0)

    if let table = self.createSymbolTable(expr: expr) {
      let top = table.top
      XCTAssertScope(top, name: "top", kind: .module, flags: [])

      XCTAssert(top.symbols.isEmpty)
      XCTAssert(top.children.isEmpty)
      XCTAssert(top.parameterNames.isEmpty)
    }
  }

  // MARK: - Complex

  func test_complex() {
    let expr = self.complexExpr(real: 3.0, imag: 4.0)

    if let table = self.createSymbolTable(expr: expr) {
      let top = table.top
      XCTAssertScope(top, name: "top", kind: .module, flags: [])

      XCTAssert(top.symbols.isEmpty)
      XCTAssert(top.children.isEmpty)
      XCTAssert(top.parameterNames.isEmpty)
    }
  }

  // MARK: - Bytes

  func test_bytes() {
    let expr = self.bytesExpr(value: Data())

    if let table = self.createSymbolTable(expr: expr) {
      let top = table.top
      XCTAssertScope(top, name: "top", kind: .module, flags: [])

      XCTAssert(top.symbols.isEmpty)
      XCTAssert(top.children.isEmpty)
      XCTAssert(top.parameterNames.isEmpty)
    }
  }

  // MARK: - String

  /// 'elsa'
  func test_string_simple() {
    let expr = self.stringExpr(value: .literal("elsa"))

    if let table = self.createSymbolTable(expr: expr) {
      let top = table.top
      XCTAssertScope(top, name: "top", kind: .module, flags: [])

      XCTAssert(top.symbols.isEmpty)
      XCTAssert(top.children.isEmpty)
      XCTAssert(top.parameterNames.isEmpty)
    }
  }

  /// f'{elsa!r:^30}'
  func test_string_formattedValue() {
    let value = self.identifierExpr(value: "elsa", start: loc1)
    let expr = self.stringExpr(
      value: .formattedValue(value, conversion: .repr, spec: "^30")
    )

    if let table = self.createSymbolTable(expr: expr) {
      let top = table.top
      XCTAssertScope(top, name: "top", kind: .module, flags: [])
      XCTAssert(top.children.isEmpty)
      XCTAssert(top.parameterNames.isEmpty)

      XCTAssertEqual(top.symbols.count, 1)
      XCTAssertContainsSymbol(top,
                              name: "elsa",
                              flags: [.use, .srcGlobalImplicit],
                              location: loc1)
    }
  }

  /// f'let {it!r:^30} go'
  func test_string_joined() {
    let value = self.identifierExpr(value: "it", start: loc1)
    let expr = self.stringExpr(
      value: .joined([
        .literal("let "),
        .formattedValue(value, conversion: .repr, spec: "^30"),
        .literal(" go")
      ])
    )

    if let table = self.createSymbolTable(expr: expr) {
      let top = table.top
      XCTAssertScope(top, name: "top", kind: .module, flags: [])
      XCTAssert(top.children.isEmpty)
      XCTAssert(top.parameterNames.isEmpty)

      XCTAssertEqual(top.symbols.count, 1)
      XCTAssertContainsSymbol(top,
                              name: "it",
                              flags: [.use, .srcGlobalImplicit],
                              location: loc1)
    }
  }

  // MARK: - Operations

  /// +elsa
  func test_operations_unary() {
    let operators: [UnaryOpExpr.Operator] = [.invert, .not, .plus, .minus]

    for op in operators {
      let expr = self.unaryOpExpr(
        op: op,
        right: self.identifierExpr(value: "elsa", start: loc1)
      )

      if let table = self.createSymbolTable(expr: expr) {
        let top = table.top
        XCTAssertScope(top, name: "top", kind: .module, flags: [])
        XCTAssert(top.children.isEmpty)
        XCTAssert(top.parameterNames.isEmpty)

        XCTAssertEqual(top.symbols.count, 1)
        XCTAssertContainsSymbol(top,
                                name: "elsa",
                                flags: [.use, .srcGlobalImplicit],
                                location: loc1)
      }
    }
  }

  /// anna + elsa
  func test_operations_binary() {
    let operators: [BinaryOpExpr.Operator] = [
      .add, .sub, .mul, .matMul, .div, .modulo, .pow,
      .leftShift, .rightShift,
      .bitOr, .bitXor, .bitAnd, .floorDiv
    ]

    for op in operators {
      let expr = self.binaryOpExpr(
        op: op,
        left: self.identifierExpr(value: "anna", start: loc1),
        right: self.identifierExpr(value: "elsa", start: loc2)
      )

      if let table = self.createSymbolTable(expr: expr) {
        let top = table.top
        XCTAssertScope(top, name: "top", kind: .module, flags: [])
        XCTAssert(top.children.isEmpty)
        XCTAssert(top.parameterNames.isEmpty)

        XCTAssertEqual(top.symbols.count, 2)
        XCTAssertContainsSymbol(top,
                                name: "anna",
                                flags: [.use, .srcGlobalImplicit],
                                location: loc1)
        XCTAssertContainsSymbol(top,
                                name: "elsa",
                                flags: [.use, .srcGlobalImplicit],
                                location: loc2)
      }
    }
  }

  /// anna or elsa
  func test_operations_bool() {
    let operators: [BoolOpExpr.Operator] = [.and, .or]

    for op in operators {
      let expr = self.boolOpExpr(
        op: op,
        left: self.identifierExpr(value: "anna", start: loc1),
        right: self.identifierExpr(value: "elsa", start: loc2)
      )

      if let table = self.createSymbolTable(expr: expr) {
        let top = table.top
        XCTAssertScope(top, name: "top", kind: .module, flags: [])
        XCTAssert(top.children.isEmpty)
        XCTAssert(top.parameterNames.isEmpty)

        XCTAssertEqual(top.symbols.count, 2)
        XCTAssertContainsSymbol(top,
                                name: "anna",
                                flags: [.use, .srcGlobalImplicit],
                                location: loc1)
        XCTAssertContainsSymbol(top,
                                name: "elsa",
                                flags: [.use, .srcGlobalImplicit],
                                location: loc2)
      }
    }
  }

  /// anna is elsa
  func test_operations_comparison() {
    let operators: [CompareExpr.Operator] = [
      .equal, .notEqual,
      .less, .lessEqual, .greater, .greaterEqual,
      .is, .isNot, .in, .notIn
    ]

    for op in operators {
      let left = self.identifierExpr(value: "anna", start: loc1)
      let right = self.identifierExpr(value: "elsa", start: loc2)

      let element = CompareExpr.Element(op: op, right: right)

      let expr = self.compareExpr(
        left: left,
        elements: [element]
      )

      if let table = self.createSymbolTable(expr: expr) {
        let top = table.top
        XCTAssertScope(top, name: "top", kind: .module, flags: [])
        XCTAssert(top.children.isEmpty)
        XCTAssert(top.parameterNames.isEmpty)

        XCTAssertEqual(top.symbols.count, 2)
        XCTAssertContainsSymbol(top,
                                name: "anna",
                                flags: [.use, .srcGlobalImplicit],
                                location: loc1)
        XCTAssertContainsSymbol(top,
                                name: "elsa",
                                flags: [.use, .srcGlobalImplicit],
                                location: loc2)
      }
    }
  }

  // MARK: - Collections

  /// (anna, elsa)
  func test_collections_tuple() {
    let expr = self.tupleExpr(
      elements: [
        self.identifierExpr(value: "anna", start: loc1),
        self.identifierExpr(value: "elsa", start: loc2)
      ]
    )

    if let table = self.createSymbolTable(expr: expr) {
      let top = table.top
      XCTAssertScope(top, name: "top", kind: .module, flags: [])
      XCTAssert(top.children.isEmpty)
      XCTAssert(top.parameterNames.isEmpty)

      XCTAssertEqual(top.symbols.count, 2)
      XCTAssertContainsSymbol(top,
                              name: "anna",
                              flags: [.use, .srcGlobalImplicit],
                              location: loc1)
      XCTAssertContainsSymbol(top,
                              name: "elsa",
                              flags: [.use, .srcGlobalImplicit],
                              location: loc2)
    }
  }

  /// [anna, elsa]
  func test_collections_list() {
    let expr = self.listExpr(
      elements: [
        self.identifierExpr(value: "anna", start: loc1),
        self.identifierExpr(value: "elsa", start: loc2)
      ]
    )

    if let table = self.createSymbolTable(expr: expr) {
      let top = table.top
      XCTAssertScope(top, name: "top", kind: .module, flags: [])
      XCTAssert(top.children.isEmpty)
      XCTAssert(top.parameterNames.isEmpty)

      XCTAssertEqual(top.symbols.count, 2)
      XCTAssertContainsSymbol(top,
                              name: "anna",
                              flags: [.use, .srcGlobalImplicit],
                              location: loc1)
      XCTAssertContainsSymbol(top,
                              name: "elsa",
                              flags: [.use, .srcGlobalImplicit],
                              location: loc2)
    }
  }

  /// {anna, elsa}
  func test_collections_set() {
    let expr = self.setExpr(
      elements: [
        self.identifierExpr(value: "anna", start: loc1),
        self.identifierExpr(value: "elsa", start: loc2)
      ]
    )

    if let table = self.createSymbolTable(expr: expr) {
      let top = table.top
      XCTAssertScope(top, name: "top", kind: .module, flags: [])
      XCTAssert(top.children.isEmpty)
      XCTAssert(top.parameterNames.isEmpty)

      XCTAssertEqual(top.symbols.count, 2)
      XCTAssertContainsSymbol(top,
                              name: "anna",
                              flags: [.use, .srcGlobalImplicit],
                              location: loc1)
      XCTAssertContainsSymbol(top,
                              name: "elsa",
                              flags: [.use, .srcGlobalImplicit],
                              location: loc2)
    }
  }

  /// {anna:elsa, **snowgies}
  func test_collections_dictionary() {
    let expr = self.dictionaryExpr(
      elements: [
        .keyValue(
          key: self.identifierExpr(value: "anna", start: loc1),
          value: self.identifierExpr(value: "elsa", start: loc2)
        ),
        .unpacking(
          self.identifierExpr(value: "snowgies", start: loc3)
        )
      ]
    )

    if let table = self.createSymbolTable(expr: expr) {
      let top = table.top
      XCTAssertScope(top, name: "top", kind: .module, flags: [])
      XCTAssert(top.children.isEmpty)
      XCTAssert(top.parameterNames.isEmpty)

      XCTAssertEqual(top.symbols.count, 3)
      XCTAssertContainsSymbol(top,
                              name: "anna",
                              flags: [.use, .srcGlobalImplicit],
                              location: loc1)
      XCTAssertContainsSymbol(top,
                              name: "elsa",
                              flags: [.use, .srcGlobalImplicit],
                              location: loc2)
      XCTAssertContainsSymbol(top,
                              name: "snowgies",
                              flags: [.use, .srcGlobalImplicit],
                              location: loc3)
    }
  }

  // MARK: - Trailers

  /// frozen.elsa
  func test_trailers_attribute() {
    let object = self.identifierExpr(value: "frozen", start: loc1)
    let expr = self.attributeExpr(object: object, name: "elsa")

    if let table = self.createSymbolTable(expr: expr) {
      let top = table.top
      XCTAssertScope(top, name: "top", kind: .module, flags: [])
      XCTAssert(top.children.isEmpty)
      XCTAssert(top.parameterNames.isEmpty)

      XCTAssertEqual(top.symbols.count, 1)
      XCTAssertContainsSymbol(top,
                              name: "frozen",
                              flags: [.use, .srcGlobalImplicit],
                              location: loc1)
    }
  }

  /// frozen[elsa]
  func test_trailers_subscript_index() {
    let expr = self.subscriptExpr(
      object: self.identifierExpr(value: "frozen", start: loc1),
      slice: self.slice(
        kind: .index(self.identifierExpr(value: "elsa", start: loc2))
      )
    )

    if let table = self.createSymbolTable(expr: expr) {
      let top = table.top
      XCTAssertScope(top, name: "top", kind: .module, flags: [])
      XCTAssert(top.children.isEmpty)
      XCTAssert(top.parameterNames.isEmpty)

      XCTAssertEqual(top.symbols.count, 2)
      XCTAssertContainsSymbol(top,
                              name: "frozen",
                              flags: [.use, .srcGlobalImplicit],
                              location: loc1)
      XCTAssertContainsSymbol(top,
                              name: "elsa",
                              flags: [.use, .srcGlobalImplicit],
                              location: loc2)
    }
  }

  /// frozen[elsa:anna:snowgies]
  func test_trailers_subscript_slice() {
    let expr = self.subscriptExpr(
      object: self.identifierExpr(value: "frozen", start: loc1),
      slice: self.slice(
        kind: .slice(
          lower: self.identifierExpr(value: "elsa", start: loc2),
          upper: self.identifierExpr(value: "anna", start: loc3),
          step: self.identifierExpr(value: "snowgies", start: loc4)
        )
      )
    )

    if let table = self.createSymbolTable(expr: expr) {
      let top = table.top
      XCTAssertScope(top, name: "top", kind: .module, flags: [])
      XCTAssert(top.children.isEmpty)
      XCTAssert(top.parameterNames.isEmpty)

      XCTAssertEqual(top.symbols.count, 4)
      XCTAssertContainsSymbol(top,
                              name: "frozen",
                              flags: [.use, .srcGlobalImplicit],
                              location: loc1)
      XCTAssertContainsSymbol(top,
                              name: "elsa",
                              flags: [.use, .srcGlobalImplicit],
                              location: loc2)
      XCTAssertContainsSymbol(top,
                              name: "anna",
                              flags: [.use, .srcGlobalImplicit],
                              location: loc3)
      XCTAssertContainsSymbol(top,
                              name: "snowgies",
                              flags: [.use, .srcGlobalImplicit],
                              location: loc4)
    }
  }

  // MARK: - Starred

  /// *frozen
  func test_starred() {
    let expr = self.starredExpr(
      expression: self.identifierExpr(value: "frozen", start: loc1)
    )

    if let table = self.createSymbolTable(expr: expr) {
      let top = table.top
      XCTAssertScope(top, name: "top", kind: .module, flags: [])
      XCTAssert(top.children.isEmpty)
      XCTAssert(top.parameterNames.isEmpty)

      XCTAssertEqual(top.symbols.count, 1)
      XCTAssertContainsSymbol(top,
                              name: "frozen",
                              flags: [.use, .srcGlobalImplicit],
                              location: loc1)
    }
  }

  // MARK: - Generators and coroutines

  /// await elsa
  func test_await() {
    let right = self.identifierExpr(value: "elsa", start: loc1)
    let expr = self.awaitExpr(value: right)

    if let table = self.createSymbolTable(expr: expr) {
      let top = table.top
      XCTAssertScope(top, name: "top", kind: .module, flags: [.isCoroutine])
      XCTAssert(top.children.isEmpty)
      XCTAssert(top.parameterNames.isEmpty)

      XCTAssertEqual(top.symbols.count, 1)
      XCTAssertContainsSymbol(top,
                              name: "elsa",
                              flags: [.use, .srcGlobalImplicit],
                              location: loc1)
    }
  }

  /// yield
  func test_yield() {
    let expr = self.yieldExpr(value: nil)

    if let table = self.createSymbolTable(expr: expr) {
      let top = table.top
      XCTAssertScope(top, name: "top", kind: .module, flags: [.isGenerator])

      XCTAssert(top.symbols.isEmpty)
      XCTAssert(top.children.isEmpty)
      XCTAssert(top.parameterNames.isEmpty)
    }
  }

  /// yield elsa
  func test_yield_value() {
    let right = self.identifierExpr(value: "elsa", start: loc1)
    let expr = self.yieldExpr(value: right)

    if let table = self.createSymbolTable(expr: expr) {
      let top = table.top
      XCTAssertScope(top, name: "top", kind: .module, flags: [.isGenerator])
      XCTAssert(top.children.isEmpty)
      XCTAssert(top.parameterNames.isEmpty)

      XCTAssertEqual(top.symbols.count, 1)
      XCTAssertContainsSymbol(top,
                              name: "elsa",
                              flags: [.use, .srcGlobalImplicit],
                              location: loc1)
    }
  }

  /// yield from elsa
  func test_yieldFrom() {
    let right = self.identifierExpr(value: "elsa", start: loc1)
    let expr = self.yieldFromExpr(value: right)

    if let table = self.createSymbolTable(expr: expr) {
      let top = table.top
      XCTAssertScope(top, name: "top", kind: .module, flags: [.isGenerator])
      XCTAssert(top.children.isEmpty)
      XCTAssert(top.parameterNames.isEmpty)

      XCTAssertEqual(top.symbols.count, 1)
      XCTAssertContainsSymbol(top,
                              name: "elsa",
                              flags: [.use, .srcGlobalImplicit],
                              location: loc1)
    }
  }

  // MARK: - If expression

  /// snow if elsa else anna
  func test_ifExpression() {
    let expr = self.ifExpr(
      test: self.identifierExpr(value: "elsa", start: loc2),
      body: self.identifierExpr(value: "snow", start: loc1),
      orElse: self.identifierExpr(value: "anna", start: loc3)
    )

    if let table = self.createSymbolTable(expr: expr) {
      let top = table.top
      XCTAssertScope(top, name: "top", kind: .module, flags: [])
      XCTAssert(top.children.isEmpty)
      XCTAssert(top.parameterNames.isEmpty)

      XCTAssertEqual(top.symbols.count, 3)
      XCTAssertContainsSymbol(top,
                              name: "snow",
                              flags: [.use, .srcGlobalImplicit],
                              location: loc1)
      XCTAssertContainsSymbol(top,
                              name: "elsa",
                              flags: [.use, .srcGlobalImplicit],
                              location: loc2)
      XCTAssertContainsSymbol(top,
                              name: "anna",
                              flags: [.use, .srcGlobalImplicit],
                              location: loc3)
    }
  }

  // MARK: - Call

  /// let_it_go(elsa, who=anna)
  ///
  /// ```c
  ///  name: top
  ///  lineno: 0
  ///  symbols:
  ///    let_it_go - referenced, global,
  ///    elsa - referenced, global,
  ///    anna - referenced, global,
  /// ```
  func test_call_args() {
    let expr = self.callExpr(
      function: self.identifierExpr(value: "let_it_go", start: loc1),
      args: [
        self.identifierExpr(value: "elsa", start: loc2)
      ],
      keywords: [
        self.keyword(
          kind: .named("who"),
          value: self.identifierExpr(value: "anna", start: loc3)
        )
      ]
    )

    if let table = self.createSymbolTable(expr: expr) {
      let top = table.top
      XCTAssertScope(top, name: "top", kind: .module, flags: [])
      XCTAssert(top.children.isEmpty)
      XCTAssert(top.parameterNames.isEmpty)

      XCTAssertEqual(top.symbols.count, 3)
      XCTAssertContainsSymbol(top,
                              name: "let_it_go",
                              flags: [.srcGlobalImplicit, .use],
                              location: loc1)
      XCTAssertContainsSymbol(top,
                              name: "elsa",
                              flags: [.srcGlobalImplicit, .use],
                              location: loc2)
      XCTAssertContainsSymbol(top,
                              name: "anna",
                              flags: [.srcGlobalImplicit, .use],
                              location: loc3)
    }
  }
}
