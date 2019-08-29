import XCTest
import Core
import Parser
@testable import Compiler

// swiftlint:disable function_body_length
// swiftlint:disable file_length

/// Basic checks for expressions, without nested scopes.
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

  /// 'Elsa'
  func test_string_simple() {
    let kind = ExpressionKind.string(.literal("Elsa"))

    if let table = self.createSymbolTable(forExpr: kind) {
      let top = table.top
      XCTAssertScope(top, name: "top", type: .module, flags: [])

      XCTAssert(top.symbols.isEmpty)
      XCTAssert(top.children.isEmpty)
      XCTAssert(top.varnames.isEmpty)
    }
  }

  /// f'{Elsa!r:^30}'
  func test_string_formattedValue() {
    let loc = SourceLocation(line: 10, column: 13)
    let value = Expression(.identifier("Elsa"), start: loc, end: self.end)
    let kind = ExpressionKind.string(
      .formattedValue(value, conversion: .repr, spec: "^30")
    )

    if let table = self.createSymbolTable(forExpr: kind) {
      let top = table.top
      XCTAssertScope(top, name: "top", type: .module, flags: [])

      XCTAssertEqual(top.symbols.count, 1)
      XCTAssertContainsSymbol(top,
                              name: "Elsa",
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

  /// +Elsa
  func test_operations_unary() {
    let operators: [UnaryOperator] = [.invert, .not, .plus, .minus]

    for op in operators {
      let loc = SourceLocation(line: 10, column: 13)
      let right = Expression(.identifier("Elsa"), start: loc, end: self.end)

      let kind = ExpressionKind.unaryOp(op, right: right)

      if let table = self.createSymbolTable(forExpr: kind) {
        let top = table.top
        XCTAssertScope(top, name: "top", type: .module, flags: [])

        XCTAssertEqual(top.symbols.count, 1)
        XCTAssertContainsSymbol(top,
                                name: "Elsa",
                                flags: [.use, .srcGlobalImplicit],
                                location: loc)

        XCTAssert(top.children.isEmpty)
        XCTAssert(top.varnames.isEmpty)
      }
    }
  }

  /// Anna + Elsa
  func test_operations_binary() {
    let operators: [BinaryOperator] = [
      .add, .sub, .mul, .matMul, .div, .modulo, .pow,
      .leftShift, .rightShift,
      .bitOr, .bitXor, .bitAnd, .floorDiv
    ]

    for op in operators {
      let loc1 = SourceLocation(line: 10, column: 13)
      let left = Expression(.identifier("Anna"), start: loc1, end: self.end)

      let loc2 = SourceLocation(line: 10, column: 13)
      let right = Expression(.identifier("Elsa"), start: loc2, end: self.end)

      let kind = ExpressionKind.binaryOp(op, left: left, right: right)

      if let table = self.createSymbolTable(forExpr: kind) {
        let top = table.top
        XCTAssertScope(top, name: "top", type: .module, flags: [])

        XCTAssertEqual(top.symbols.count, 2)
        XCTAssertContainsSymbol(top,
                                name: "Anna",
                                flags: [.use, .srcGlobalImplicit],
                                location: loc1)
        XCTAssertContainsSymbol(top,
                                name: "Elsa",
                                flags: [.use, .srcGlobalImplicit],
                                location: loc2)

        XCTAssert(top.children.isEmpty)
        XCTAssert(top.varnames.isEmpty)
      }
    }
  }

  /// Anna or Elsa
  func test_operations_bool() {
    let operators: [BooleanOperator] = [.and, .or]

    for op in operators {
      let loc1 = SourceLocation(line: 10, column: 13)
      let left = Expression(.identifier("Anna"), start: loc1, end: self.end)

      let loc2 = SourceLocation(line: 10, column: 13)
      let right = Expression(.identifier("Elsa"), start: loc2, end: self.end)

      let kind = ExpressionKind.boolOp(op, left: left, right: right)

      if let table = self.createSymbolTable(forExpr: kind) {
        let top = table.top
        XCTAssertScope(top, name: "top", type: .module, flags: [])

        XCTAssertEqual(top.symbols.count, 2)
        XCTAssertContainsSymbol(top,
                                name: "Anna",
                                flags: [.use, .srcGlobalImplicit],
                                location: loc1)
        XCTAssertContainsSymbol(top,
                                name: "Elsa",
                                flags: [.use, .srcGlobalImplicit],
                                location: loc2)

        XCTAssert(top.children.isEmpty)
        XCTAssert(top.varnames.isEmpty)
      }
    }
  }

  /// Anna is Elsa
  func test_operations_comparison() {
    let operators: [ComparisonOperator] = [
      .equal, .notEqual,
      .less, .lessEqual, .greater, .greaterEqual,
      .is, .isNot, .in, .notIn
    ]

    for op in operators {
      let loc1 = SourceLocation(line: 10, column: 13)
      let left = Expression(.identifier("Anna"), start: loc1, end: self.end)

      let loc2 = SourceLocation(line: 10, column: 13)
      let right = Expression(.identifier("Elsa"), start: loc2, end: self.end)

      let element = ComparisonElement(op: op, right: right)
      let kind = ExpressionKind.compare(left: left,
                                        elements: NonEmptyArray(first: element))

      if let table = self.createSymbolTable(forExpr: kind) {
        let top = table.top
        XCTAssertScope(top, name: "top", type: .module, flags: [])

        XCTAssertEqual(top.symbols.count, 2)
        XCTAssertContainsSymbol(top,
                                name: "Anna",
                                flags: [.use, .srcGlobalImplicit],
                                location: loc1)
        XCTAssertContainsSymbol(top,
                                name: "Elsa",
                                flags: [.use, .srcGlobalImplicit],
                                location: loc2)

        XCTAssert(top.children.isEmpty)
        XCTAssert(top.varnames.isEmpty)
      }
    }
  }

//  case let .tuple(elements),
//       let .list(elements):
//  case let .set(elements):
//  case let .dictionary(elements):

//  case let .await(value):
//  case let .yield(value):
//  case let .yieldFrom(value):

//  case let .ifExpression(test, body, orElse):

//  case let .attribute(expr, _):
//  case let .subscript(expr, slice):
//  case let .starred(expr):
}
