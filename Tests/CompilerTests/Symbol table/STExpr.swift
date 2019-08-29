import XCTest
import Core
import Parser
@testable import Compiler

// swiftlint:disable function_body_length
// swiftlint:disable file_length
// swiftlint:disable type_body_length

/// Basic checks for expressions, without nested scopes.
/// Just so we know that we visit all child expressions.
class STExpr: XCTestCase, CommonSymbolTable {

  // MARK: - Empty

  func test_empty() {
    if let table = self.createSymbolTable(forStmts: []) {
      let top = table.top
      XCTAssertScope(top, name: "top", type: .module, flags: [])

      XCTAssert(top.symbols.isEmpty)
      XCTAssert(top.children.isEmpty)
      XCTAssert(top.varnames.isEmpty)
    }
  }

  // MARK: - Simple atoms

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
        XCTAssert(top.varnames.isEmpty, msg)
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
      XCTAssert(top.varnames.isEmpty)
    }
  }

  /// f'{elsa!r:^30}'
  func test_string_formattedValue() {
    let loc = SourceLocation(line: 10, column: 13)
    let value = Expression(.identifier("elsa"), start: loc, end: self.end)
    let kind = ExpressionKind.string(
      .formattedValue(value, conversion: .repr, spec: "^30")
    )

    if let table = self.createSymbolTable(forExpr: kind) {
      let top = table.top
      XCTAssertScope(top, name: "top", type: .module, flags: [])

      XCTAssertEqual(top.symbols.count, 1)
      XCTAssertContainsSymbol(top,
                              name: "elsa",
                              flags: [.use, .srcGlobalImplicit],
                              location: loc)

      XCTAssert(top.children.isEmpty)
      XCTAssert(top.varnames.isEmpty)
    }
  }

  /// f'let {it!r:^30} go'
  func test_string_joined() {
    let loc = SourceLocation(line: 10, column: 13)
    let value = Expression(.identifier("it"), start: loc, end: self.end)

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

      XCTAssertEqual(top.symbols.count, 1)
      XCTAssertContainsSymbol(top,
                              name: "it",
                              flags: [.use, .srcGlobalImplicit],
                              location: loc)

      XCTAssert(top.children.isEmpty)
      XCTAssert(top.varnames.isEmpty)
    }
  }

  // MARK: - Operations

  /// +elsa
  func test_operations_unary() {
    let operators: [UnaryOperator] = [.invert, .not, .plus, .minus]

    for op in operators {
      let loc = SourceLocation(line: 10, column: 13)
      let right = Expression(.identifier("elsa"), start: loc, end: self.end)

      let kind = ExpressionKind.unaryOp(op, right: right)

      if let table = self.createSymbolTable(forExpr: kind) {
        let top = table.top
        XCTAssertScope(top, name: "top", type: .module, flags: [])

        XCTAssertEqual(top.symbols.count, 1)
        XCTAssertContainsSymbol(top,
                                name: "elsa",
                                flags: [.use, .srcGlobalImplicit],
                                location: loc)

        XCTAssert(top.children.isEmpty)
        XCTAssert(top.varnames.isEmpty)
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
      let loc1 = SourceLocation(line: 10, column: 13)
      let left = Expression(.identifier("anna"), start: loc1, end: self.end)

      let loc2 = SourceLocation(line: 12, column: 15)
      let right = Expression(.identifier("elsa"), start: loc2, end: self.end)

      let kind = ExpressionKind.binaryOp(op, left: left, right: right)

      if let table = self.createSymbolTable(forExpr: kind) {
        let top = table.top
        XCTAssertScope(top, name: "top", type: .module, flags: [])

        XCTAssertEqual(top.symbols.count, 2)
        XCTAssertContainsSymbol(top,
                                name: "anna",
                                flags: [.use, .srcGlobalImplicit],
                                location: loc1)
        XCTAssertContainsSymbol(top,
                                name: "elsa",
                                flags: [.use, .srcGlobalImplicit],
                                location: loc2)

        XCTAssert(top.children.isEmpty)
        XCTAssert(top.varnames.isEmpty)
      }
    }
  }

  /// anna or elsa
  func test_operations_bool() {
    let operators: [BooleanOperator] = [.and, .or]

    for op in operators {
      let loc1 = SourceLocation(line: 10, column: 13)
      let left = Expression(.identifier("anna"), start: loc1, end: self.end)

      let loc2 = SourceLocation(line: 12, column: 15)
      let right = Expression(.identifier("elsa"), start: loc2, end: self.end)

      let kind = ExpressionKind.boolOp(op, left: left, right: right)

      if let table = self.createSymbolTable(forExpr: kind) {
        let top = table.top
        XCTAssertScope(top, name: "top", type: .module, flags: [])

        XCTAssertEqual(top.symbols.count, 2)
        XCTAssertContainsSymbol(top,
                                name: "anna",
                                flags: [.use, .srcGlobalImplicit],
                                location: loc1)
        XCTAssertContainsSymbol(top,
                                name: "elsa",
                                flags: [.use, .srcGlobalImplicit],
                                location: loc2)

        XCTAssert(top.children.isEmpty)
        XCTAssert(top.varnames.isEmpty)
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
      let loc1 = SourceLocation(line: 10, column: 13)
      let left = Expression(.identifier("anna"), start: loc1, end: self.end)

      let loc2 = SourceLocation(line: 12, column: 15)
      let right = Expression(.identifier("elsa"), start: loc2, end: self.end)

      let element = ComparisonElement(op: op, right: right)
      let kind = ExpressionKind.compare(left: left,
                                        elements: NonEmptyArray(first: element))

      if let table = self.createSymbolTable(forExpr: kind) {
        let top = table.top
        XCTAssertScope(top, name: "top", type: .module, flags: [])

        XCTAssertEqual(top.symbols.count, 2)
        XCTAssertContainsSymbol(top,
                                name: "anna",
                                flags: [.use, .srcGlobalImplicit],
                                location: loc1)
        XCTAssertContainsSymbol(top,
                                name: "elsa",
                                flags: [.use, .srcGlobalImplicit],
                                location: loc2)

        XCTAssert(top.children.isEmpty)
        XCTAssert(top.varnames.isEmpty)
      }
    }
  }

  // MARK: - Collections

  /// (anna, elsa)
  func test_collections_tuple() {
    let loc1 = SourceLocation(line: 10, column: 13)
    let left = Expression(.identifier("anna"), start: loc1, end: self.end)

    let loc2 = SourceLocation(line: 12, column: 15)
    let right = Expression(.identifier("elsa"), start: loc2, end: self.end)

    let kind = ExpressionKind.tuple([left, right])

    if let table = self.createSymbolTable(forExpr: kind) {
      let top = table.top
      XCTAssertScope(top, name: "top", type: .module, flags: [])

      XCTAssertEqual(top.symbols.count, 2)
      XCTAssertContainsSymbol(top,
                              name: "anna",
                              flags: [.use, .srcGlobalImplicit],
                              location: loc1)
      XCTAssertContainsSymbol(top,
                              name: "elsa",
                              flags: [.use, .srcGlobalImplicit],
                              location: loc2)

      XCTAssert(top.children.isEmpty)
      XCTAssert(top.varnames.isEmpty)
    }
  }

  /// [anna, elsa]
  func test_collections_list() {
    let loc1 = SourceLocation(line: 10, column: 13)
    let left = Expression(.identifier("anna"), start: loc1, end: self.end)

    let loc2 = SourceLocation(line: 12, column: 15)
    let right = Expression(.identifier("elsa"), start: loc2, end: self.end)

    let kind = ExpressionKind.list([left, right])

    if let table = self.createSymbolTable(forExpr: kind) {
      let top = table.top
      XCTAssertScope(top, name: "top", type: .module, flags: [])

      XCTAssertEqual(top.symbols.count, 2)
      XCTAssertContainsSymbol(top,
                              name: "anna",
                              flags: [.use, .srcGlobalImplicit],
                              location: loc1)
      XCTAssertContainsSymbol(top,
                              name: "elsa",
                              flags: [.use, .srcGlobalImplicit],
                              location: loc2)

      XCTAssert(top.children.isEmpty)
      XCTAssert(top.varnames.isEmpty)
    }
  }

  /// {anna, elsa}
  func test_collections_set() {
    let loc1 = SourceLocation(line: 10, column: 13)
    let left = Expression(.identifier("anna"), start: loc1, end: self.end)

    let loc2 = SourceLocation(line: 12, column: 15)
    let right = Expression(.identifier("elsa"), start: loc2, end: self.end)

    let kind = ExpressionKind.set([left, right])

    if let table = self.createSymbolTable(forExpr: kind) {
      let top = table.top
      XCTAssertScope(top, name: "top", type: .module, flags: [])

      XCTAssertEqual(top.symbols.count, 2)
      XCTAssertContainsSymbol(top,
                              name: "anna",
                              flags: [.use, .srcGlobalImplicit],
                              location: loc1)
      XCTAssertContainsSymbol(top,
                              name: "elsa",
                              flags: [.use, .srcGlobalImplicit],
                              location: loc2)

      XCTAssert(top.children.isEmpty)
      XCTAssert(top.varnames.isEmpty)
    }
  }

  /// {anna:elsa, **snowgies}
  func test_collections_dictionary() {
    let loc1 = SourceLocation(line: 10, column: 13)
    let key = Expression(.identifier("anna"), start: loc1, end: self.end)

    let loc2 = SourceLocation(line: 12, column: 15)
    let value = Expression(.identifier("elsa"), start: loc2, end: self.end)

    let loc3 = SourceLocation(line: 10, column: 13)
    let unpack = Expression(.identifier("snowgies"), start: loc3, end: self.end)

    let kind = ExpressionKind.dictionary([
      .keyValue(key: key, value: value),
      .unpacking(unpack)
    ])

    if let table = self.createSymbolTable(forExpr: kind) {
      let top = table.top
      XCTAssertScope(top, name: "top", type: .module, flags: [])

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

      XCTAssert(top.children.isEmpty)
      XCTAssert(top.varnames.isEmpty)
    }
  }

  // MARK: - Trailers

  /// frozen.elsa
  func test_trailers_attribute() {
    let loc1 = SourceLocation(line: 10, column: 13)
    let obj = Expression(.identifier("frozen"), start: loc1, end: self.end)

    let kind = ExpressionKind.attribute(obj, name: "elsa")

    if let table = self.createSymbolTable(forExpr: kind) {
      let top = table.top
      XCTAssertScope(top, name: "top", type: .module, flags: [])

      XCTAssertEqual(top.symbols.count, 1)
      XCTAssertContainsSymbol(top,
                              name: "frozen",
                              flags: [.use, .srcGlobalImplicit],
                              location: loc1)

      XCTAssert(top.children.isEmpty)
      XCTAssert(top.varnames.isEmpty)
    }
  }

  /// frozen[elsa]
  func test_trailers_subscript_index() {
    let loc1 = SourceLocation(line: 10, column: 13)
    let obj = Expression(.identifier("frozen"), start: loc1, end: self.end)

    let loc2 = SourceLocation(line: 12, column: 15)
    let index = Expression(.identifier("elsa"), start: loc2, end: self.end)

    let kind = ExpressionKind.subscript(obj, slice: self.slice(
      .index(index)
    ))

    if let table = self.createSymbolTable(forExpr: kind) {
      let top = table.top
      XCTAssertScope(top, name: "top", type: .module, flags: [])

      XCTAssertEqual(top.symbols.count, 2)
      XCTAssertContainsSymbol(top,
                              name: "frozen",
                              flags: [.use, .srcGlobalImplicit],
                              location: loc1)
      XCTAssertContainsSymbol(top,
                              name: "elsa",
                              flags: [.use, .srcGlobalImplicit],
                              location: loc2)

      XCTAssert(top.children.isEmpty)
      XCTAssert(top.varnames.isEmpty)
    }
  }

  /// frozen[elsa:anna:snowgies]
  func test_trailers_subscript_slice() {
    let loc1 = SourceLocation(line: 10, column: 13)
    let obj = Expression(.identifier("frozen"), start: loc1, end: self.end)

    let loc2 = SourceLocation(line: 12, column: 15)
    let lower = Expression(.identifier("elsa"), start: loc2, end: self.end)

    let loc3 = SourceLocation(line: 14, column: 17)
    let upper = Expression(.identifier("anna"), start: loc3, end: self.end)

    let loc4 = SourceLocation(line: 15, column: 19)
    let step = Expression(.identifier("snowgies"), start: loc4, end: self.end)

    let kind = ExpressionKind.subscript(obj, slice: self.slice(
      .slice(lower: lower, upper: upper, step: step)
    ))

    if let table = self.createSymbolTable(forExpr: kind) {
      let top = table.top
      XCTAssertScope(top, name: "top", type: .module, flags: [])

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

      XCTAssert(top.children.isEmpty)
      XCTAssert(top.varnames.isEmpty)
    }
  }

  // MARK: - Starred

  /// *frozen
  func test_starred() {
    let loc1 = SourceLocation(line: 10, column: 13)
    let expr = Expression(.identifier("frozen"), start: loc1, end: self.end)

    let kind = ExpressionKind.starred(expr)

    if let table = self.createSymbolTable(forExpr: kind) {
      let top = table.top
      XCTAssertScope(top, name: "top", type: .module, flags: [])

      XCTAssertEqual(top.symbols.count, 1)
      XCTAssertContainsSymbol(top,
                              name: "frozen",
                              flags: [.use, .srcGlobalImplicit],
                              location: loc1)

      XCTAssert(top.children.isEmpty)
      XCTAssert(top.varnames.isEmpty)
    }
  }

  // MARK: - Generators/corutines

  /// await elsa
  func test_await() {
    let loc = SourceLocation(line: 10, column: 13)
    let right = Expression(.identifier("elsa"), start: loc, end: self.end)

    let kind = ExpressionKind.await(right)

    if let table = self.createSymbolTable(forExpr: kind) {
      let top = table.top
      XCTAssertScope(top, name: "top", type: .module, flags: [.isCoroutine])

      XCTAssertEqual(top.symbols.count, 1)
      XCTAssertContainsSymbol(top,
                              name: "elsa",
                              flags: [.use, .srcGlobalImplicit],
                              location: loc)

      XCTAssert(top.children.isEmpty)
      XCTAssert(top.varnames.isEmpty)
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
      XCTAssert(top.varnames.isEmpty)
    }
  }

  /// yield elsa
  func test_yield_value() {
    let loc = SourceLocation(line: 10, column: 13)
    let right = Expression(.identifier("elsa"), start: loc, end: self.end)

    let kind = ExpressionKind.yield(right)

    if let table = self.createSymbolTable(forExpr: kind) {
      let top = table.top
      XCTAssertScope(top, name: "top", type: .module, flags: [.isGenerator])

      XCTAssertEqual(top.symbols.count, 1)
      XCTAssertContainsSymbol(top,
                              name: "elsa",
                              flags: [.use, .srcGlobalImplicit],
                              location: loc)

      XCTAssert(top.children.isEmpty)
      XCTAssert(top.varnames.isEmpty)
    }
  }

  /// yield from elsa
  func test_yieldFrom() {
    let loc = SourceLocation(line: 10, column: 13)
    let right = Expression(.identifier("elsa"), start: loc, end: self.end)

    let kind = ExpressionKind.yieldFrom(right)

    if let table = self.createSymbolTable(forExpr: kind) {
      let top = table.top
      XCTAssertScope(top, name: "top", type: .module, flags: [.isGenerator])

      XCTAssertEqual(top.symbols.count, 1)
      XCTAssertContainsSymbol(top,
                              name: "elsa",
                              flags: [.use, .srcGlobalImplicit],
                              location: loc)

      XCTAssert(top.children.isEmpty)
      XCTAssert(top.varnames.isEmpty)
    }
  }

  // MARK: - If expression
  //  case let .ifExpression(test, body, orElse):
}
