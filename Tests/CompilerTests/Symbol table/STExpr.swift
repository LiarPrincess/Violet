import XCTest
import Core
import Parser
@testable import Compiler

// swiftlint:disable function_body_length
// swiftlint:disable file_length
// swiftlint:disable type_body_length

/// Basic checks for expressions, without nested scopes.
/// Just so we know that we visit all childs.
/// Use 'Tools/dump_symtable.py' for reference.
class STExpr: XCTestCase, CommonSymbolTable {

  // MARK: - Empty

  func test_empty() {
    if let table = self.createSymbolTable(forStmts: []) {
      let top = table.top
      XCTAssertScope(top, name: "top", type: .module, flags: [])

      XCTAssert(top.symbols.isEmpty)
      XCTAssert(top.children.isEmpty)
      XCTAssert(top.varNames.isEmpty)
    }
  }

  // MARK: - Booleans, none, ellipsis, numbers and bytes

  func test_bool_none_ellipsis_numbers_bytes() {
    let exprKinds: [ExpressionKind] = [
      .true, .false,
      .none, .ellipsis,
      .int(BigInt(1)), .float(2.0), .complex(real: 3.0, imag: 4.0),
      .bytes(Data())
    ]

    for kind in exprKinds {
      let msg = "for '\(kind)'"

      if let table = self.createSymbolTable(forExpr: kind) {
        let top = table.top
        XCTAssertScope(top, name: "top", type: .module, flags: [], msg)

        XCTAssert(top.symbols.isEmpty, msg)
        XCTAssert(top.children.isEmpty, msg)
        XCTAssert(top.varNames.isEmpty, msg)
      }
    }
  }

  // MARK: - String

  /// 'elsa'
  func test_string_simple() {
    let kind = ExpressionKind.string(.literal("elsa"))

    if let table = self.createSymbolTable(forExpr: kind) {
      let top = table.top
      XCTAssertScope(top, name: "top", type: .module, flags: [])

      XCTAssert(top.symbols.isEmpty)
      XCTAssert(top.children.isEmpty)
      XCTAssert(top.varNames.isEmpty)
    }
  }

  /// f'{elsa!r:^30}'
  func test_string_formattedValue() {
    let value = self.identifierExpr("elsa", start: loc1)
    let kind = ExpressionKind.string(
      .formattedValue(value, conversion: .repr, spec: "^30")
    )

    if let table = self.createSymbolTable(forExpr: kind) {
      let top = table.top
      XCTAssertScope(top, name: "top", type: .module, flags: [])
      XCTAssert(top.children.isEmpty)
      XCTAssert(top.varNames.isEmpty)

      XCTAssertEqual(top.symbols.count, 1)
      XCTAssertContainsSymbol(top,
                              name: "elsa",
                              flags: [.use, .srcGlobalImplicit],
                              location: loc1)
    }
  }

  /// f'let {it!r:^30} go'
  func test_string_joined() {
    let value = self.identifierExpr("it", start: loc1)
    let kind = ExpressionKind.string(
      .joined([
        .literal("let "),
        .formattedValue(value, conversion: .repr, spec: "^30"),
        .literal(" go")
      ])
    )

    if let table = self.createSymbolTable(forExpr: kind) {
      let top = table.top
      XCTAssertScope(top, name: "top", type: .module, flags: [])
      XCTAssert(top.children.isEmpty)
      XCTAssert(top.varNames.isEmpty)

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
    let operators: [UnaryOperator] = [.invert, .not, .plus, .minus]

    for op in operators {
      let kind = ExpressionKind.unaryOp(
        op,
        right: self.identifierExpr("elsa", start: loc1)
      )

      if let table = self.createSymbolTable(forExpr: kind) {
        let top = table.top
        XCTAssertScope(top, name: "top", type: .module, flags: [])
        XCTAssert(top.children.isEmpty)
        XCTAssert(top.varNames.isEmpty)

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
    let operators: [BinaryOperator] = [
      .add, .sub, .mul, .matMul, .div, .modulo, .pow,
      .leftShift, .rightShift,
      .bitOr, .bitXor, .bitAnd, .floorDiv
    ]

    for op in operators {
      let kind = ExpressionKind.binaryOp(
        op,
        left: self.identifierExpr("anna", start: loc1),
        right: self.identifierExpr("elsa", start: loc2)
      )

      if let table = self.createSymbolTable(forExpr: kind) {
        let top = table.top
        XCTAssertScope(top, name: "top", type: .module, flags: [])
        XCTAssert(top.children.isEmpty)
        XCTAssert(top.varNames.isEmpty)

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
    let operators: [BooleanOperator] = [.and, .or]

    for op in operators {
      let kind = ExpressionKind.boolOp(
        op,
        left: self.identifierExpr("anna", start: loc1),
        right: self.identifierExpr("elsa", start: loc2)
      )

      if let table = self.createSymbolTable(forExpr: kind) {
        let top = table.top
        XCTAssertScope(top, name: "top", type: .module, flags: [])
        XCTAssert(top.children.isEmpty)
        XCTAssert(top.varNames.isEmpty)

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
    let operators: [ComparisonOperator] = [
      .equal, .notEqual,
      .less, .lessEqual, .greater, .greaterEqual,
      .is, .isNot, .in, .notIn
    ]

    for op in operators {
      let left = self.identifierExpr("anna", start: loc1)
      let right = self.identifierExpr("elsa", start: loc2)

      let element = ComparisonElement(op: op, right: right)
      let kind = ExpressionKind.compare(left: left,
                                        elements: NonEmptyArray(first: element))

      if let table = self.createSymbolTable(forExpr: kind) {
        let top = table.top
        XCTAssertScope(top, name: "top", type: .module, flags: [])
        XCTAssert(top.children.isEmpty)
        XCTAssert(top.varNames.isEmpty)

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
    let kind = ExpressionKind.tuple(
      [
        self.identifierExpr("anna", start: loc1),
        self.identifierExpr("elsa", start: loc2)
      ]
    )

    if let table = self.createSymbolTable(forExpr: kind) {
      let top = table.top
      XCTAssertScope(top, name: "top", type: .module, flags: [])
      XCTAssert(top.children.isEmpty)
      XCTAssert(top.varNames.isEmpty)

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
    let kind = ExpressionKind.list(
      [
        self.identifierExpr("anna", start: loc1),
        self.identifierExpr("elsa", start: loc2)
      ]
    )

    if let table = self.createSymbolTable(forExpr: kind) {
      let top = table.top
      XCTAssertScope(top, name: "top", type: .module, flags: [])
      XCTAssert(top.children.isEmpty)
      XCTAssert(top.varNames.isEmpty)

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
    let kind = ExpressionKind.set(
      [
        self.identifierExpr("anna", start: loc1),
        self.identifierExpr("elsa", start: loc2)
      ]
    )

    if let table = self.createSymbolTable(forExpr: kind) {
      let top = table.top
      XCTAssertScope(top, name: "top", type: .module, flags: [])
      XCTAssert(top.children.isEmpty)
      XCTAssert(top.varNames.isEmpty)

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
    let kind = ExpressionKind.dictionary([
      .keyValue(
        key: self.identifierExpr("anna", start: loc1),
        value: self.identifierExpr("elsa", start: loc2)
      ),
      .unpacking(
        self.identifierExpr("snowgies", start: loc3)
      )
    ])

    if let table = self.createSymbolTable(forExpr: kind) {
      let top = table.top
      XCTAssertScope(top, name: "top", type: .module, flags: [])
      XCTAssert(top.children.isEmpty)
      XCTAssert(top.varNames.isEmpty)

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
    let object = self.identifierExpr("frozen", start: loc1)
    let kind = ExpressionKind.attribute(object, name: "elsa")

    if let table = self.createSymbolTable(forExpr: kind) {
      let top = table.top
      XCTAssertScope(top, name: "top", type: .module, flags: [])
      XCTAssert(top.children.isEmpty)
      XCTAssert(top.varNames.isEmpty)

      XCTAssertEqual(top.symbols.count, 1)
      XCTAssertContainsSymbol(top,
                              name: "frozen",
                              flags: [.use, .srcGlobalImplicit],
                              location: loc1)
    }
  }

  /// frozen[elsa]
  func test_trailers_subscript_index() {
    let kind = ExpressionKind.subscript(
      self.identifierExpr("frozen", start: loc1),
      slice: self.slice(
        .index(self.identifierExpr("elsa", start: loc2))
      )
    )

    if let table = self.createSymbolTable(forExpr: kind) {
      let top = table.top
      XCTAssertScope(top, name: "top", type: .module, flags: [])
      XCTAssert(top.children.isEmpty)
      XCTAssert(top.varNames.isEmpty)

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
    let kind = ExpressionKind.subscript(
       self.expression(.identifier("frozen"), start: loc1),
       slice: self.slice(
        .slice(
          lower: self.identifierExpr("elsa", start: loc2),
          upper: self.identifierExpr("anna", start: loc3),
          step: self.identifierExpr("snowgies", start: loc4)
        )
      )
    )

    if let table = self.createSymbolTable(forExpr: kind) {
      let top = table.top
      XCTAssertScope(top, name: "top", type: .module, flags: [])
      XCTAssert(top.children.isEmpty)
      XCTAssert(top.varNames.isEmpty)

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
    let expr = self.identifierExpr("frozen", start: loc1)
    let kind = ExpressionKind.starred(expr)

    if let table = self.createSymbolTable(forExpr: kind) {
      let top = table.top
      XCTAssertScope(top, name: "top", type: .module, flags: [])
      XCTAssert(top.children.isEmpty)
      XCTAssert(top.varNames.isEmpty)

      XCTAssertEqual(top.symbols.count, 1)
      XCTAssertContainsSymbol(top,
                              name: "frozen",
                              flags: [.use, .srcGlobalImplicit],
                              location: loc1)
    }
  }

  // MARK: - Generators and corutines

  /// await elsa
  func test_await() {
    let right = self.identifierExpr("elsa", start: loc1)
    let kind = ExpressionKind.await(right)

    if let table = self.createSymbolTable(forExpr: kind) {
      let top = table.top
      XCTAssertScope(top, name: "top", type: .module, flags: [.isCoroutine])
      XCTAssert(top.children.isEmpty)
      XCTAssert(top.varNames.isEmpty)

      XCTAssertEqual(top.symbols.count, 1)
      XCTAssertContainsSymbol(top,
                              name: "elsa",
                              flags: [.use, .srcGlobalImplicit],
                              location: loc1)
    }
  }

  /// yield
  func test_yield() {
    let kind = ExpressionKind.yield(nil)

    if let table = self.createSymbolTable(forExpr: kind) {
      let top = table.top
      XCTAssertScope(top, name: "top", type: .module, flags: [.isGenerator])

      XCTAssert(top.symbols.isEmpty)
      XCTAssert(top.children.isEmpty)
      XCTAssert(top.varNames.isEmpty)
    }
  }

  /// yield elsa
  func test_yield_value() {
    let right = self.identifierExpr("elsa", start: loc1)
    let kind = ExpressionKind.yield(right)

    if let table = self.createSymbolTable(forExpr: kind) {
      let top = table.top
      XCTAssertScope(top, name: "top", type: .module, flags: [.isGenerator])
      XCTAssert(top.children.isEmpty)
      XCTAssert(top.varNames.isEmpty)

      XCTAssertEqual(top.symbols.count, 1)
      XCTAssertContainsSymbol(top,
                              name: "elsa",
                              flags: [.use, .srcGlobalImplicit],
                              location: loc1)
    }
  }

  /// yield from elsa
  func test_yieldFrom() {
    let right = self.identifierExpr("elsa", start: loc1)
    let kind = ExpressionKind.yieldFrom(right)

    if let table = self.createSymbolTable(forExpr: kind) {
      let top = table.top
      XCTAssertScope(top, name: "top", type: .module, flags: [.isGenerator])
      XCTAssert(top.children.isEmpty)
      XCTAssert(top.varNames.isEmpty)

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
    let kind = ExpressionKind.ifExpression(
      test: self.identifierExpr("elsa", start: loc2),
      body: self.identifierExpr("snow", start: loc1),
      orElse: self.identifierExpr("anna", start: loc3)
    )

    if let table = self.createSymbolTable(forExpr: kind) {
      let top = table.top
      XCTAssertScope(top, name: "top", type: .module, flags: [])
      XCTAssert(top.children.isEmpty)
      XCTAssert(top.varNames.isEmpty)

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
    let kind = ExpressionKind.call(
      function: self.identifierExpr("let_it_go", start: loc1),
      args: [
        self.identifierExpr("elsa", start: loc2)
      ],
      keywords: [
        self.keyword(
          name: "who",
          value: self.identifierExpr("anna", start: loc3)
        )
      ]
    )

    if let table = self.createSymbolTable(forExpr: kind) {
      let top = table.top
      XCTAssertScope(top, name: "top", type: .module, flags: [])
      XCTAssert(top.children.isEmpty)
      XCTAssert(top.varNames.isEmpty)

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
