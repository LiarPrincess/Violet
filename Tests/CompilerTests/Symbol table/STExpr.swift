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
      XCTAssert(top.varnames.isEmpty)
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
    let value = self.expression(.identifier("elsa"), start: loc1)
    let kind = ExpressionKind.string(
      .formattedValue(value, conversion: .repr, spec: "^30")
    )

    if let table = self.createSymbolTable(forExpr: kind) {
      let top = table.top
      XCTAssertScope(top, name: "top", type: .module, flags: [])
      XCTAssert(top.children.isEmpty)
      XCTAssert(top.varnames.isEmpty)

      XCTAssertEqual(top.symbols.count, 1)
      XCTAssertContainsSymbol(top,
                              name: "elsa",
                              flags: [.use, .srcGlobalImplicit],
                              location: loc1)
    }
  }

  /// f'let {it!r:^30} go'
  func test_string_joined() {
    let value = self.expression(.identifier("it"), start: loc1)
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
      XCTAssert(top.varnames.isEmpty)

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
      let right = self.expression(.identifier("elsa"), start: loc1)
      let kind = ExpressionKind.unaryOp(op, right: right)

      if let table = self.createSymbolTable(forExpr: kind) {
        let top = table.top
        XCTAssertScope(top, name: "top", type: .module, flags: [])
        XCTAssert(top.children.isEmpty)
        XCTAssert(top.varnames.isEmpty)

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
      let left = self.expression(.identifier("anna"), start: loc1)
      let right = self.expression(.identifier("elsa"), start: loc2)
      let kind = ExpressionKind.binaryOp(op, left: left, right: right)

      if let table = self.createSymbolTable(forExpr: kind) {
        let top = table.top
        XCTAssertScope(top, name: "top", type: .module, flags: [])
        XCTAssert(top.children.isEmpty)
        XCTAssert(top.varnames.isEmpty)

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
      let left = self.expression(.identifier("anna"), start: loc1)
      let right = self.expression(.identifier("elsa"), start: loc2)
      let kind = ExpressionKind.boolOp(op, left: left, right: right)

      if let table = self.createSymbolTable(forExpr: kind) {
        let top = table.top
        XCTAssertScope(top, name: "top", type: .module, flags: [])
        XCTAssert(top.children.isEmpty)
        XCTAssert(top.varnames.isEmpty)

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
      let left = self.expression(.identifier("anna"), start: loc1)
      let right = self.expression(.identifier("elsa"), start: loc2)

      let element = ComparisonElement(op: op, right: right)
      let kind = ExpressionKind.compare(left: left,
                                        elements: NonEmptyArray(first: element))

      if let table = self.createSymbolTable(forExpr: kind) {
        let top = table.top
        XCTAssertScope(top, name: "top", type: .module, flags: [])
        XCTAssert(top.children.isEmpty)
        XCTAssert(top.varnames.isEmpty)

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
    let left = self.expression(.identifier("anna"), start: loc1)
    let right = self.expression(.identifier("elsa"), start: loc2)
    let kind = ExpressionKind.tuple([left, right])

    if let table = self.createSymbolTable(forExpr: kind) {
      let top = table.top
      XCTAssertScope(top, name: "top", type: .module, flags: [])
      XCTAssert(top.children.isEmpty)
      XCTAssert(top.varnames.isEmpty)

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
    let left = self.expression(.identifier("anna"), start: loc1)
    let right = self.expression(.identifier("elsa"), start: loc2)
    let kind = ExpressionKind.list([left, right])

    if let table = self.createSymbolTable(forExpr: kind) {
      let top = table.top
      XCTAssertScope(top, name: "top", type: .module, flags: [])
      XCTAssert(top.children.isEmpty)
      XCTAssert(top.varnames.isEmpty)

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
    let left = self.expression(.identifier("anna"), start: loc1)
    let right = self.expression(.identifier("elsa"), start: loc2)
    let kind = ExpressionKind.set([left, right])

    if let table = self.createSymbolTable(forExpr: kind) {
      let top = table.top
      XCTAssertScope(top, name: "top", type: .module, flags: [])
      XCTAssert(top.children.isEmpty)
      XCTAssert(top.varnames.isEmpty)

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
    let key = self.expression(.identifier("anna"), start: loc1)
    let value = self.expression(.identifier("elsa"), start: loc2)
    let unpack = self.expression(.identifier("snowgies"), start: loc3)

    let kind = ExpressionKind.dictionary([
      .keyValue(key: key, value: value),
      .unpacking(unpack)
    ])

    if let table = self.createSymbolTable(forExpr: kind) {
      let top = table.top
      XCTAssertScope(top, name: "top", type: .module, flags: [])
      XCTAssert(top.children.isEmpty)
      XCTAssert(top.varnames.isEmpty)

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
    let obj = self.expression(.identifier("frozen"), start: loc1)
    let kind = ExpressionKind.attribute(obj, name: "elsa")

    if let table = self.createSymbolTable(forExpr: kind) {
      let top = table.top
      XCTAssertScope(top, name: "top", type: .module, flags: [])
      XCTAssert(top.children.isEmpty)
      XCTAssert(top.varnames.isEmpty)

      XCTAssertEqual(top.symbols.count, 1)
      XCTAssertContainsSymbol(top,
                              name: "frozen",
                              flags: [.use, .srcGlobalImplicit],
                              location: loc1)
    }
  }

  /// frozen[elsa]
  func test_trailers_subscript_index() {
    let obj = self.expression(.identifier("frozen"), start: loc1)
    let index = self.expression(.identifier("elsa"), start: loc2)

    let kind = ExpressionKind.subscript(obj, slice: self.slice(
      .index(index)
    ))

    if let table = self.createSymbolTable(forExpr: kind) {
      let top = table.top
      XCTAssertScope(top, name: "top", type: .module, flags: [])
      XCTAssert(top.children.isEmpty)
      XCTAssert(top.varnames.isEmpty)

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
    let obj = self.expression(.identifier("frozen"), start: loc1)
    let lower = self.expression(.identifier("elsa"), start: loc2)
    let upper = self.expression(.identifier("anna"), start: loc3)
    let step = self.expression(.identifier("snowgies"), start: loc4)

    let kind = ExpressionKind.subscript(obj, slice: self.slice(
      .slice(lower: lower, upper: upper, step: step)
    ))

    if let table = self.createSymbolTable(forExpr: kind) {
      let top = table.top
      XCTAssertScope(top, name: "top", type: .module, flags: [])
      XCTAssert(top.children.isEmpty)
      XCTAssert(top.varnames.isEmpty)

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
    let expr = self.expression(.identifier("frozen"), start: loc1)
    let kind = ExpressionKind.starred(expr)

    if let table = self.createSymbolTable(forExpr: kind) {
      let top = table.top
      XCTAssertScope(top, name: "top", type: .module, flags: [])
      XCTAssert(top.children.isEmpty)
      XCTAssert(top.varnames.isEmpty)

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
    let right = self.expression(.identifier("elsa"), start: loc1)
    let kind = ExpressionKind.await(right)

    if let table = self.createSymbolTable(forExpr: kind) {
      let top = table.top
      XCTAssertScope(top, name: "top", type: .module, flags: [.isCoroutine])
      XCTAssert(top.children.isEmpty)
      XCTAssert(top.varnames.isEmpty)

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
      XCTAssert(top.varnames.isEmpty)
    }
  }

  /// yield elsa
  func test_yield_value() {
    let right = self.expression(.identifier("elsa"), start: loc1)
    let kind = ExpressionKind.yield(right)

    if let table = self.createSymbolTable(forExpr: kind) {
      let top = table.top
      XCTAssertScope(top, name: "top", type: .module, flags: [.isGenerator])
      XCTAssert(top.children.isEmpty)
      XCTAssert(top.varnames.isEmpty)

      XCTAssertEqual(top.symbols.count, 1)
      XCTAssertContainsSymbol(top,
                              name: "elsa",
                              flags: [.use, .srcGlobalImplicit],
                              location: loc1)
    }
  }

  /// yield from elsa
  func test_yieldFrom() {
    let right = self.expression(.identifier("elsa"), start: loc1)
    let kind = ExpressionKind.yieldFrom(right)

    if let table = self.createSymbolTable(forExpr: kind) {
      let top = table.top
      XCTAssertScope(top, name: "top", type: .module, flags: [.isGenerator])
      XCTAssert(top.children.isEmpty)
      XCTAssert(top.varnames.isEmpty)

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
    let body = self.expression(.identifier("snow"), start: loc1)
    let test = self.expression(.identifier("elsa"), start: loc2)
    let orElse = self.expression(.identifier("anna"), start: loc3)

    let kind = ExpressionKind.ifExpression(test: test, body: body, orElse: orElse)

    if let table = self.createSymbolTable(forExpr: kind) {
      let top = table.top
      XCTAssertScope(top, name: "top", type: .module, flags: [])
      XCTAssert(top.children.isEmpty)
      XCTAssert(top.varnames.isEmpty)

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
    let f = self.expression(.identifier("let_it_go"), start: loc1)
    let arg = self.expression(.identifier("elsa"), start: loc2)

    let kwArg = self.expression(.identifier("anna"), start: loc3)
    let kw = self.keyword(name: "who", value: kwArg)

    let kind = ExpressionKind.call(f: f, args: [arg], keywords: [kw])

    if let table = self.createSymbolTable(forExpr: kind) {
      let top = table.top
      XCTAssertScope(top, name: "top", type: .module, flags: [])
      XCTAssert(top.children.isEmpty)
      XCTAssert(top.varnames.isEmpty)

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

  // MARK: - Lambda

  /// lambda elsa, anna: elsa
  /// (We have more tests in function def)
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
  func test_call_lambda() {
    let arg1 = self.arg("elsa", annotation: nil, start: loc1)
    let arg2 = self.arg("anna", annotation: nil, start: loc2)
    let body = self.expression(.identifier("elsa"), start: loc3)

    let kind = ExpressionKind.lambda(
      args: self.arguments(args: [arg1, arg2]),
      body: body
    )

    if let table = self.createSymbolTable(forExpr: kind) {
      let top = table.top
      XCTAssertScope(top, name: "top", type: .module, flags: [])
      XCTAssert(top.symbols.isEmpty)
      XCTAssert(top.varnames.isEmpty)

      XCTAssertEqual(top.children.count, 1)
      guard top.children.count == 1 else { return }

      let lambdaScope = top.children[0]
      XCTAssertScope(lambdaScope, name: "lambda", type: .function, flags: [.isNested])
      XCTAssert(lambdaScope.children.isEmpty)

      XCTAssertEqual(lambdaScope.varnames.count, 2)
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
}
