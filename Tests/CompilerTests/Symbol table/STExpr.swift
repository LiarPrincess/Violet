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
    guard let table = self.createSymbolTable(stmts: []) else {
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

  // MARK: - Bool

  func test_true() {
    let expr = self.trueExpr()

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
      childrenCount: 0
    )
  }

  func test_false() {
    let expr = self.falseExpr()

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
      childrenCount: 0
    )
  }

  // MARK: - None

  func test_none() {
    let expr = self.noneExpr()

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
      childrenCount: 0
    )
  }

  // MARK: - Ellipsis

  func test_ellipsis() {
    let expr = self.ellipsisExpr()

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
      childrenCount: 0
    )
  }

  // MARK: - Int

  func test_int() {
    let expr = self.intExpr(value: 1)

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
      childrenCount: 0
    )
  }

  // MARK: - Float

  func test_float() {
    let expr = self.floatExpr(value: 2.0)

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
      childrenCount: 0
    )
  }

  // MARK: - Complex

  func test_complex() {
    let expr = self.complexExpr(real: 3.0, imag: 4.0)

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
      childrenCount: 0
    )
  }

  // MARK: - Bytes

  func test_bytes() {
    let expr = self.bytesExpr(value: Data())

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
      childrenCount: 0
    )
  }

  // MARK: - String

  /// 'elsa'
  func test_string_simple() {
    let expr = self.stringExpr(value: .literal("elsa"))

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
      childrenCount: 0
    )
  }

  /// f'{elsa!r:^30}'
  func test_string_formattedValue() {
    let value = self.identifierExpr(value: "elsa", start: loc1)
    let expr = self.stringExpr(
      value: .formattedValue(value, conversion: .repr, spec: "^30")
    )

    guard let table = self.createSymbolTable(expr: expr) else {
      return
    }

    XCTAssertScope(
      table.top,
      name: "top",
      kind: .module,
      flags: [],
      symbols: [
        .init(name: "elsa", flags: [.use, .srcGlobalImplicit], location: loc1)
      ],
      parameters: [],
      childrenCount: 0
    )
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

    guard let table = self.createSymbolTable(expr: expr) else {
      return
    }

    XCTAssertScope(
      table.top,
      name: "top",
      kind: .module,
      flags: [],
      symbols: [
        .init(name: "it", flags: [.use, .srcGlobalImplicit], location: loc1)
      ],
      parameters: [],
      childrenCount: 0
    )
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

      guard let table = self.createSymbolTable(expr: expr) else {
        continue
      }

      XCTAssertScope(
        table.top,
        name: "top",
        kind: .module,
        flags: [],
        symbols: [
          .init(name: "elsa", flags: [.use, .srcGlobalImplicit], location: loc1)
        ],
        parameters: [],
        childrenCount: 0
      )
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

      guard let table = self.createSymbolTable(expr: expr) else {
        continue
      }

      XCTAssertScope(
        table.top,
        name: "top",
        kind: .module,
        flags: [],
        symbols: [
          .init(name: "anna", flags: [.use, .srcGlobalImplicit], location: loc1),
          .init(name: "elsa", flags: [.use, .srcGlobalImplicit], location: loc2)
        ],
        parameters: [],
        childrenCount: 0
      )
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

      guard let table = self.createSymbolTable(expr: expr) else {
        continue
      }

      XCTAssertScope(
        table.top,
        name: "top",
        kind: .module,
        flags: [],
        symbols: [
          .init(name: "anna", flags: [.use, .srcGlobalImplicit], location: loc1),
          .init(name: "elsa", flags: [.use, .srcGlobalImplicit], location: loc2)
        ],
        parameters: [],
        childrenCount: 0
      )
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

      let expr = self.compareExpr(
        left: left,
        elements: [CompareExpr.Element(op: op, right: right)]
      )

      guard let table = self.createSymbolTable(expr: expr) else {
        continue
      }

      XCTAssertScope(
        table.top,
        name: "top",
        kind: .module,
        flags: [],
        symbols: [
          .init(name: "anna", flags: [.use, .srcGlobalImplicit], location: loc1),
          .init(name: "elsa", flags: [.use, .srcGlobalImplicit], location: loc2)
        ],
        parameters: [],
        childrenCount: 0
      )
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

    guard let table = self.createSymbolTable(expr: expr) else {
      return
    }

    XCTAssertScope(
      table.top,
      name: "top",
      kind: .module,
      flags: [],
      symbols: [
        .init(name: "anna", flags: [.use, .srcGlobalImplicit], location: loc1),
        .init(name: "elsa", flags: [.use, .srcGlobalImplicit], location: loc2)
      ],
      parameters: [],
      childrenCount: 0
    )
  }

  /// [anna, elsa]
  func test_collections_list() {
    let expr = self.listExpr(
      elements: [
        self.identifierExpr(value: "anna", start: loc1),
        self.identifierExpr(value: "elsa", start: loc2)
      ]
    )

    guard let table = self.createSymbolTable(expr: expr) else {
      return
    }

    XCTAssertScope(
      table.top,
      name: "top",
      kind: .module,
      flags: [],
      symbols: [
        .init(name: "anna", flags: [.use, .srcGlobalImplicit], location: loc1),
        .init(name: "elsa", flags: [.use, .srcGlobalImplicit], location: loc2)
      ],
      parameters: [],
      childrenCount: 0
    )
  }

  /// {anna, elsa}
  func test_collections_set() {
    let expr = self.setExpr(
      elements: [
        self.identifierExpr(value: "anna", start: loc1),
        self.identifierExpr(value: "elsa", start: loc2)
      ]
    )

    guard let table = self.createSymbolTable(expr: expr) else {
      return
    }

    XCTAssertScope(
      table.top,
      name: "top",
      kind: .module,
      flags: [],
      symbols: [
        .init(name: "anna", flags: [.use, .srcGlobalImplicit], location: loc1),
        .init(name: "elsa", flags: [.use, .srcGlobalImplicit], location: loc2)
      ],
      parameters: [],
      childrenCount: 0
    )
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

    guard let table = self.createSymbolTable(expr: expr) else {
      return
    }

    XCTAssertScope(
      table.top,
      name: "top",
      kind: .module,
      flags: [],
      symbols: [
        .init(name: "anna", flags: [.use, .srcGlobalImplicit], location: loc1),
        .init(name: "elsa", flags: [.use, .srcGlobalImplicit], location: loc2),
        .init(name: "snowgies", flags: [.use, .srcGlobalImplicit], location: loc3)
      ],
      parameters: [],
      childrenCount: 0
    )
  }

  // MARK: - Trailers

  /// frozen.elsa
  func test_trailers_attribute() {
    let object = self.identifierExpr(value: "frozen", start: loc1)
    let expr = self.attributeExpr(object: object, name: "elsa")

    guard let table = self.createSymbolTable(expr: expr) else {
      return
    }

    XCTAssertScope(
      table.top,
      name: "top",
      kind: .module,
      flags: [],
      symbols: [
        .init(name: "frozen", flags: [.use, .srcGlobalImplicit], location: loc1)
      ],
      parameters: [],
      childrenCount: 0
    )
  }

  /// frozen[elsa]
  func test_trailers_subscript_index() {
    let expr = self.subscriptExpr(
      object: self.identifierExpr(value: "frozen", start: loc1),
      slice: self.slice(
        kind: .index(self.identifierExpr(value: "elsa", start: loc2))
      )
    )

    guard let table = self.createSymbolTable(expr: expr) else {
      return
    }

    XCTAssertScope(
      table.top,
      name: "top",
      kind: .module,
      flags: [],
      symbols: [
        .init(name: "frozen", flags: [.use, .srcGlobalImplicit], location: loc1),
        .init(name: "elsa", flags: [.use, .srcGlobalImplicit], location: loc2)
      ],
      parameters: [],
      childrenCount: 0
    )
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

    guard let table = self.createSymbolTable(expr: expr) else {
      return
    }

    XCTAssertScope(
      table.top,
      name: "top",
      kind: .module,
      flags: [],
      symbols: [
        .init(name: "frozen", flags: [.use, .srcGlobalImplicit], location: loc1),
        .init(name: "elsa", flags: [.use, .srcGlobalImplicit], location: loc2),
        .init(name: "anna", flags: [.use, .srcGlobalImplicit], location: loc3),
        .init(name: "snowgies", flags: [.use, .srcGlobalImplicit], location: loc4)
      ],
      parameters: [],
      childrenCount: 0
    )
  }

  // MARK: - Starred

  /// *frozen
  func test_starred() {
    let expr = self.starredExpr(
      expression: self.identifierExpr(value: "frozen", start: loc1)
    )

    guard let table = self.createSymbolTable(expr: expr) else {
      return
    }

    XCTAssertScope(
      table.top,
      name: "top",
      kind: .module,
      flags: [],
      symbols: [
        .init(name: "frozen", flags: [.use, .srcGlobalImplicit], location: loc1)
      ],
      parameters: [],
      childrenCount: 0
    )
  }

  // MARK: - Generators and coroutines

  /// await elsa
  func test_await() {
    let right = self.identifierExpr(value: "elsa", start: loc1)
    let expr = self.awaitExpr(value: right)

    guard let table = self.createSymbolTable(expr: expr) else {
      return
    }

    XCTAssertScope(
      table.top,
      name: "top",
      kind: .module,
      flags: [.isCoroutine],
      symbols: [
        .init(name: "elsa", flags: [.use, .srcGlobalImplicit], location: loc1)
      ],
      parameters: [],
      childrenCount: 0
    )
  }

  /// yield
  func test_yield() {
    let expr = self.yieldExpr(value: nil)

    guard let table = self.createSymbolTable(expr: expr) else {
      return
    }

    XCTAssertScope(
      table.top,
      name: "top",
      kind: .module,
      flags: [.isGenerator],
      symbols: [],
      parameters: [],
      childrenCount: 0
    )
  }

  /// yield elsa
  func test_yield_value() {
    let right = self.identifierExpr(value: "elsa", start: loc1)
    let expr = self.yieldExpr(value: right)

    guard let table = self.createSymbolTable(expr: expr) else {
      return
    }

    XCTAssertScope(
      table.top,
      name: "top",
      kind: .module,
      flags: [.isGenerator],
      symbols: [
        .init(name: "elsa", flags: [.use, .srcGlobalImplicit], location: loc1)
      ],
      parameters: [],
      childrenCount: 0
    )
  }

  /// yield from elsa
  func test_yieldFrom() {
    let right = self.identifierExpr(value: "elsa", start: loc1)
    let expr = self.yieldFromExpr(value: right)

    guard let table = self.createSymbolTable(expr: expr) else {
      return
    }

    XCTAssertScope(
      table.top,
      name: "top",
      kind: .module,
      flags: [.isGenerator],
      symbols: [
        .init(name: "elsa", flags: [.use, .srcGlobalImplicit], location: loc1)
      ],
      parameters: [],
      childrenCount: 0
    )
  }

  // MARK: - If expression

  /// snow if elsa else anna
  func test_ifExpression() {
    let expr = self.ifExpr(
      test: self.identifierExpr(value: "elsa", start: loc2),
      body: self.identifierExpr(value: "snow", start: loc1),
      orElse: self.identifierExpr(value: "anna", start: loc3)
    )

    guard let table = self.createSymbolTable(expr: expr) else {
      return
    }

    XCTAssertScope(
      table.top,
      name: "top",
      kind: .module,
      flags: [],
      symbols: [
        .init(name: "elsa", flags: [.use, .srcGlobalImplicit], location: loc2),
        .init(name: "snow", flags: [.use, .srcGlobalImplicit], location: loc1),
        .init(name: "anna", flags: [.use, .srcGlobalImplicit], location: loc3)
      ],
      parameters: [],
      childrenCount: 0
    )
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

    guard let table = self.createSymbolTable(expr: expr) else {
      return
    }

    let top = table.top
    XCTAssertScope(
      top,
      name: "top",
      kind: .module,
      flags: [],
      symbols: [
        .init(name: "let_it_go", flags: [.srcGlobalImplicit, .use], location: loc1),
        .init(name: "elsa", flags: [.srcGlobalImplicit, .use], location: loc2),
        .init(name: "anna", flags: [.srcGlobalImplicit, .use], location: loc3)
      ],
      parameters: [],
      childrenCount: 0)
  }
}
