import XCTest
import Core
import Lexer
@testable import Parser

// swiftlint:disable file_length
// swiftlint:disable type_body_length
// swiftlint:disable function_body_length

class LambdaTests: XCTestCase, Common, DestructExpressionKind {

  // MARK: - No arguments

  /// lambda: 5
  func test_noArguments() {
    var parser = self.createExprParser(
      self.token(.lambda,   start: loc0, end: loc1),
      self.token(.colon,    start: loc2, end: loc3),
      self.token(.float(5), start: loc4, end: loc5)
    )

    if let expr = self.parse(&parser) {
      guard let l = self.destructLambda(expr) else { return }

      XCTAssertEqual(l.args.args, [])
      XCTAssertEqual(l.args.defaults, [])
      XCTAssertEqual(l.args.vararg, .none)
      XCTAssertEqual(l.args.kwOnlyArgs, [])
      XCTAssertEqual(l.args.kwOnlyDefaults, [])
      XCTAssertEqual(l.args.kwarg, nil)
      XCTAssertEqual(l.args.start, loc2)
      XCTAssertEqual(l.args.end,   loc2)

      let bodyKind = ExpressionKind.float(5.0)
      XCTAssertEqual(l.body, Expression(bodyKind, start: loc4, end: loc5))

      XCTAssertExpression(expr, "(lambda () 5.0)")
      XCTAssertEqual(expr.start, loc0)
      XCTAssertEqual(expr.end,   loc5)
    }
  }

  // MARK: - Positional

  /// lambda a: 5
  func test_positional() {
    var parser = self.createExprParser(
      self.token(.lambda,          start: loc0, end: loc1),
      self.token(.identifier("a"), start: loc2, end: loc3),
      self.token(.colon,           start: loc4, end: loc5),
      self.token(.float(5.0),      start: loc6, end: loc7)
    )

    if let expr = self.parse(&parser) {
      guard let l = self.destructLambda(expr) else { return }

      let argA = Arg(name: "a", annotation: nil, start: loc2, end: loc3)
      XCTAssertEqual(l.args.args, [argA])
      XCTAssertEqual(l.args.defaults, [])
      XCTAssertEqual(l.args.vararg, .none)
      XCTAssertEqual(l.args.kwOnlyArgs, [])
      XCTAssertEqual(l.args.kwOnlyDefaults, [])
      XCTAssertEqual(l.args.kwarg, nil)
      XCTAssertEqual(l.args.start, loc2)
      XCTAssertEqual(l.args.end,   loc3)

      let bodyKind = ExpressionKind.float(5.0)
      XCTAssertEqual(l.body, Expression(bodyKind, start: loc6, end: loc7))

      XCTAssertExpression(expr, "(lambda (a) 5.0)")
      XCTAssertEqual(expr.start, loc0)
      XCTAssertEqual(expr.end,   loc7)
    }
  }

  /// lambda a = 1: 5
  func test_positional_default() {
    var parser = self.createExprParser(
      self.token(.lambda,          start: loc0, end: loc1),
      self.token(.identifier("a"), start: loc2, end: loc3),
      self.token(.equal,           start: loc4, end: loc5),
      self.token(.float(1.0),      start: loc6, end: loc7),
      self.token(.colon,           start: loc8, end: loc9),
      self.token(.float(5.0),      start: loc10, end: loc11)
    )

    if let expr = self.parse(&parser) {
      guard let l = self.destructLambda(expr) else { return }

      let argA = Arg(name: "a", annotation: nil, start: loc2, end: loc3)
      let defA = Expression(.float(1.0), start: loc6, end: loc7)
      XCTAssertEqual(l.args.args, [argA])
      XCTAssertEqual(l.args.defaults, [defA])
      XCTAssertEqual(l.args.vararg, .none)
      XCTAssertEqual(l.args.kwOnlyArgs, [])
      XCTAssertEqual(l.args.kwOnlyDefaults, [])
      XCTAssertEqual(l.args.kwarg, nil)
      XCTAssertEqual(l.args.start, loc2)
      XCTAssertEqual(l.args.end,   loc7)

      let bodyKind = ExpressionKind.float(5.0)
      XCTAssertEqual(l.body, Expression(bodyKind, start: loc10, end: loc11))

      XCTAssertExpression(expr, "(lambda (a=1.0) 5.0)")
      XCTAssertEqual(expr.start, loc0)
      XCTAssertEqual(expr.end,   loc11)
    }
  }

  /// lambda a, b: 5
  func test_positional_multiple() {
    var parser = self.createExprParser(
      self.token(.lambda,          start: loc0, end: loc1),
      self.token(.identifier("a"), start: loc2, end: loc3),
      self.token(.comma,           start: loc4, end: loc5),
      self.token(.identifier("b"), start: loc6, end: loc7),
      self.token(.colon,           start: loc8, end: loc9),
      self.token(.float(5.0),      start: loc10, end: loc11)
    )

    if let expr = self.parse(&parser) {
      guard let l = self.destructLambda(expr) else { return }

      let argA = Arg(name: "a", annotation: nil, start: loc2, end: loc3)
      let argB = Arg(name: "b", annotation: nil, start: loc6, end: loc7)
      XCTAssertEqual(l.args.args, [argA, argB])
      XCTAssertEqual(l.args.defaults, [])
      XCTAssertEqual(l.args.vararg, .none)
      XCTAssertEqual(l.args.kwOnlyArgs, [])
      XCTAssertEqual(l.args.kwOnlyDefaults, [])
      XCTAssertEqual(l.args.kwarg, nil)
      XCTAssertEqual(l.args.start, loc2)
      XCTAssertEqual(l.args.end,   loc7)

      let bodyKind = ExpressionKind.float(5.0)
      XCTAssertEqual(l.body, Expression(bodyKind, start: loc10, end: loc11))

      XCTAssertExpression(expr, "(lambda (a b) 5.0)")
      XCTAssertEqual(expr.start, loc0)
      XCTAssertEqual(expr.end,   loc11)
    }
  }

  /// lambda a, b = 1: 5
  func test_positional_default_afterRequired() {
    var parser = self.createExprParser(
      self.token(.lambda,          start: loc0, end: loc1),
      self.token(.identifier("a"), start: loc2, end: loc3),
      self.token(.comma,           start: loc4, end: loc5),
      self.token(.identifier("b"), start: loc6, end: loc7),
      self.token(.equal,           start: loc8, end: loc9),
      self.token(.float(1.0),      start: loc10, end: loc11),
      self.token(.colon,           start: loc12, end: loc13),
      self.token(.float(5.0),      start: loc14, end: loc15)
    )

    if let expr = self.parse(&parser) {
      guard let l = self.destructLambda(expr) else { return }

      let argA = Arg(name: "a", annotation: nil, start: loc2, end: loc3)
      let argB = Arg(name: "b", annotation: nil, start: loc6, end: loc7)
      let defB = Expression(.float(1.0), start: loc10, end: loc11)
      XCTAssertEqual(l.args.args, [argA, argB])
      XCTAssertEqual(l.args.defaults, [defB])
      XCTAssertEqual(l.args.vararg, .none)
      XCTAssertEqual(l.args.kwOnlyArgs, [])
      XCTAssertEqual(l.args.kwOnlyDefaults, [])
      XCTAssertEqual(l.args.kwarg, nil)
      XCTAssertEqual(l.args.start, loc2)
      XCTAssertEqual(l.args.end,   loc11)

      let bodyKind = ExpressionKind.float(5.0)
      XCTAssertEqual(l.body, Expression(bodyKind, start: loc14, end: loc15))

      XCTAssertExpression(expr, "(lambda (a b=1.0) 5.0)")
      XCTAssertEqual(expr.start, loc0)
      XCTAssertEqual(expr.end,   loc15)
    }
  }

  /// lambda a = 1, b: 5
  func test_positional_requited_afterDefault_throws() {
    var parser = self.createExprParser(
      self.token(.lambda,          start: loc0, end: loc1),
      self.token(.identifier("a"), start: loc2, end: loc3),
      self.token(.equal,           start: loc4, end: loc5),
      self.token(.float(1.0),      start: loc6, end: loc7),
      self.token(.comma,           start: loc8, end: loc9),
      self.token(.identifier("b"), start: loc10, end: loc11),
      self.token(.colon,           start: loc12, end: loc13),
      self.token(.float(5.0),      start: loc14, end: loc15)
    )

    if let error = self.error(&parser) {
      XCTAssertEqual(error.kind, .defaultAfterNonDefaultArgument)
      XCTAssertEqual(error.location, loc12)
    }
  }

  // MARK: - Variadic

  /// lambda *a: 5
  func test_varargs() {
    var parser = self.createExprParser(
      self.token(.lambda,          start: loc0, end: loc1),
      self.token(.star,            start: loc2, end: loc3),
      self.token(.identifier("a"), start: loc4, end: loc5),
      self.token(.colon,           start: loc6, end: loc7),
      self.token(.float(5.0),      start: loc8, end: loc9)
    )

    if let expr = self.parse(&parser) {
      guard let l = self.destructLambda(expr) else { return }

      let varargA = Arg(name: "a", annotation: nil, start: loc4, end: loc5)
      XCTAssertEqual(l.args.args, [])
      XCTAssertEqual(l.args.defaults, [])
      XCTAssertEqual(l.args.vararg, .named(varargA))
      XCTAssertEqual(l.args.kwOnlyArgs, [])
      XCTAssertEqual(l.args.kwOnlyDefaults, [])
      XCTAssertEqual(l.args.kwarg, nil)
      XCTAssertEqual(l.args.start, loc2)
      XCTAssertEqual(l.args.end,   loc5)

      let bodyKind = ExpressionKind.float(5.0)
      XCTAssertEqual(l.body, Expression(bodyKind, start: loc8, end: loc9))

      XCTAssertExpression(expr, "(lambda (*a) 5.0)")
      XCTAssertEqual(expr.start, loc0)
      XCTAssertEqual(expr.end,   loc9)
    }
  }

  /// lambda *a, b = 1: 5
  func test_varargs_keywordOnly_withDefault() {
    var parser = self.createExprParser(
      self.token(.lambda,          start: loc0, end: loc1),
      self.token(.star,            start: loc2, end: loc3),
      self.token(.identifier("a"), start: loc4, end: loc5),
      self.token(.comma,           start: loc6, end: loc7),
      self.token(.identifier("b"), start: loc8, end: loc9),
      self.token(.equal,           start: loc10, end: loc11),
      self.token(.float(1.0),      start: loc12, end: loc13),
      self.token(.colon,           start: loc14, end: loc15),
      self.token(.float(5.0),      start: loc16, end: loc17)
    )

    if let expr = self.parse(&parser) {
      guard let l = self.destructLambda(expr) else { return }

      let varargA = Arg(name: "a", annotation: nil, start: loc4, end: loc5)
      let kwB     = Arg(name: "b", annotation: nil, start: loc8, end: loc9)
      let kwDefB  = Expression(.float(1), start: loc12, end: loc13)
      XCTAssertEqual(l.args.args, [])
      XCTAssertEqual(l.args.defaults, [])
      XCTAssertEqual(l.args.vararg, .named(varargA))
      XCTAssertEqual(l.args.kwOnlyArgs, [kwB])
      XCTAssertEqual(l.args.kwOnlyDefaults, [kwDefB])
      XCTAssertEqual(l.args.kwarg, nil)
      XCTAssertEqual(l.args.start, loc2)
      XCTAssertEqual(l.args.end,   loc13)

      let bodyKind = ExpressionKind.float(5.0)
      XCTAssertEqual(l.body, Expression(bodyKind, start: loc16, end: loc17))

      XCTAssertExpression(expr, "(lambda (*a b=1.0) 5.0)")
      XCTAssertEqual(expr.start, loc0)
      XCTAssertEqual(expr.end,   loc17)
    }
  }

  /// lambda *a, b: 5
  func test_varargs_keywordOnly_withoutDefault_isImplicitNone() {
    var parser = self.createExprParser(
      self.token(.lambda,          start: loc0, end: loc1),
      self.token(.star,            start: loc2, end: loc3),
      self.token(.identifier("a"), start: loc4, end: loc5),
      self.token(.comma,           start: loc6, end: loc7),
      self.token(.identifier("b"), start: loc8, end: loc9),
      self.token(.colon,           start: loc10, end: loc11),
      self.token(.float(5.0),      start: loc12, end: loc13)
    )

    if let expr = self.parse(&parser) {
      guard let l = self.destructLambda(expr) else { return }

      let varargA = Arg(name: "a", annotation: nil, start: loc4, end: loc5)
      let kwB     = Arg(name: "b", annotation: nil, start: loc8, end: loc9)
      let kwDefB = Expression(.none, start: loc9, end: loc9)
      XCTAssertEqual(l.args.args, [])
      XCTAssertEqual(l.args.defaults, [])
      XCTAssertEqual(l.args.vararg, .named(varargA))
      XCTAssertEqual(l.args.kwOnlyArgs, [kwB])
      XCTAssertEqual(l.args.kwOnlyDefaults, [kwDefB])
      XCTAssertEqual(l.args.kwarg, nil)
      XCTAssertEqual(l.args.start, loc2)
      XCTAssertEqual(l.args.end,   loc9)

      let bodyKind = ExpressionKind.float(5.0)
      XCTAssertEqual(l.body, Expression(bodyKind, start: loc12, end: loc13))

      XCTAssertExpression(expr, "(lambda (*a b=None) 5.0)")
      XCTAssertEqual(expr.start, loc0)
      XCTAssertEqual(expr.end,   loc13)
    }
  }

  /// lambda *a, *b: 5
  func test_varargs_duplicate_throws() {
    var parser = self.createExprParser(
      self.token(.lambda,          start: loc0, end: loc1),
      self.token(.star,            start: loc2, end: loc3),
      self.token(.identifier("a"), start: loc4, end: loc5),
      self.token(.comma,           start: loc6, end: loc7),
      self.token(.star,            start: loc8, end: loc9),
      self.token(.identifier("b"), start: loc10, end: loc11),
      self.token(.colon,           start: loc12, end: loc13),
      self.token(.float(5.0),      start: loc14, end: loc15)
    )

    if let error = self.error(&parser) {
      XCTAssertEqual(error.kind, .duplicateVarargs)
      XCTAssertEqual(error.location, loc8)
    }
  }

  /// lambda *, a: 5
  func test_varargsUnnamed() {
    var parser = self.createExprParser(
      self.token(.lambda,          start: loc0, end: loc1),
      self.token(.star,            start: loc2, end: loc3),
      self.token(.comma,           start: loc4, end: loc5),
      self.token(.identifier("a"), start: loc6, end: loc7),
      self.token(.colon,           start: loc8, end: loc9),
      self.token(.float(5.0),      start: loc10, end: loc11)
    )

    if let expr = self.parse(&parser) {
      guard let l = self.destructLambda(expr) else { return }

      let kwA = Arg(name: "a", annotation: nil, start: loc6, end: loc7)
      let kwDefA = Expression(.none, start: loc7, end: loc7)
      XCTAssertEqual(l.args.args, [])
      XCTAssertEqual(l.args.defaults, [])
      XCTAssertEqual(l.args.vararg, .unnamed)
      XCTAssertEqual(l.args.kwOnlyArgs, [kwA])
      XCTAssertEqual(l.args.kwOnlyDefaults, [kwDefA])
      XCTAssertEqual(l.args.kwarg, nil)
      XCTAssertEqual(l.args.start, loc2)
      XCTAssertEqual(l.args.end,   loc7)

      let bodyKind = ExpressionKind.float(5.0)
      XCTAssertEqual(l.body, Expression(bodyKind, start: loc10, end: loc11))

      XCTAssertExpression(expr, "(lambda (* a=None) 5.0)")
      XCTAssertEqual(expr.start, loc0)
      XCTAssertEqual(expr.end,   loc11)
    }
  }

  /// lambda *: 5
  func test_varargsUnnamed_withoutFollowingArguments_throws() {
    var parser = self.createExprParser(
      self.token(.lambda,          start: loc0, end: loc1),
      self.token(.star,            start: loc2, end: loc3),
      self.token(.colon,           start: loc4, end: loc5),
      self.token(.float(5.0),      start: loc6, end: loc7)
    )

    if let error = self.error(&parser) {
      XCTAssertEqual(error.kind, .starWithoutFollowingArguments)
      XCTAssertEqual(error.location, loc4)
    }
  }

  // MARK: - Kwargs

  /// lambda **a: 5
  func test_kwargs() {
    var parser = self.createExprParser(
      self.token(.lambda,          start: loc0, end: loc1),
      self.token(.starStar,        start: loc2, end: loc3),
      self.token(.identifier("a"), start: loc4, end: loc5),
      self.token(.colon,           start: loc6, end: loc7),
      self.token(.float(5.0),      start: loc8, end: loc9)
    )

    if let expr = self.parse(&parser) {
      guard let l = self.destructLambda(expr) else { return }

      let kwargA = Arg(name: "a", annotation: nil, start: loc4, end: loc5)
      XCTAssertEqual(l.args.args, [])
      XCTAssertEqual(l.args.defaults, [])
      XCTAssertEqual(l.args.vararg, .none)
      XCTAssertEqual(l.args.kwOnlyArgs, [])
      XCTAssertEqual(l.args.kwOnlyDefaults, [])
      XCTAssertEqual(l.args.kwarg, kwargA)
      XCTAssertEqual(l.args.start, loc2)
      XCTAssertEqual(l.args.end,   loc5)

      let bodyKind = ExpressionKind.float(5.0)
      XCTAssertEqual(l.body, Expression(bodyKind, start: loc8, end: loc9))

      XCTAssertExpression(expr, "(lambda (**a) 5.0)")
      XCTAssertEqual(expr.start, loc0)
      XCTAssertEqual(expr.end,   loc9)
    }
  }

  /// lambda **a,: 5
  func test_kwargs_withCommaAfter() {
    var parser = self.createExprParser(
      self.token(.lambda,          start: loc0, end: loc1),
      self.token(.starStar,        start: loc2, end: loc3),
      self.token(.identifier("a"), start: loc4, end: loc5),
      self.token(.comma,           start: loc6, end: loc7),
      self.token(.colon,           start: loc8, end: loc9),
      self.token(.float(5.0),      start: loc10, end: loc11)
    )

    if let expr = self.parse(&parser) {
      guard let l = self.destructLambda(expr) else { return }

      let kwargA = Arg(name: "a", annotation: nil, start: loc4, end: loc5)
      XCTAssertEqual(l.args.args, [])
      XCTAssertEqual(l.args.defaults, [])
      XCTAssertEqual(l.args.vararg, .none)
      XCTAssertEqual(l.args.kwOnlyArgs, [])
      XCTAssertEqual(l.args.kwOnlyDefaults, [])
      XCTAssertEqual(l.args.kwarg, kwargA)
      XCTAssertEqual(l.args.start, loc2)
      XCTAssertEqual(l.args.end,   loc7)

      let bodyKind = ExpressionKind.float(5.0)
      XCTAssertEqual(l.body, Expression(bodyKind, start: loc10, end: loc11))

      XCTAssertExpression(expr, "(lambda (**a) 5.0)")
      XCTAssertEqual(expr.start, loc0)
      XCTAssertEqual(expr.end,   loc11)
    }
  }

  /// lambda **a, **b: 5
  func test_kwargs_duplicate_throws() {
    var parser = self.createExprParser(
      self.token(.lambda,          start: loc0, end: loc1),
      self.token(.starStar,        start: loc2, end: loc3),
      self.token(.identifier("a"), start: loc4, end: loc5),
      self.token(.comma,           start: loc6, end: loc7),
      self.token(.starStar,        start: loc8, end: loc9),
      self.token(.identifier("b"), start: loc10, end: loc11),
      self.token(.colon,           start: loc12, end: loc13),
      self.token(.float(5.0),      start: loc14, end: loc15)
    )

    if let error = self.error(&parser) {
      XCTAssertEqual(error.kind, .duplicateKwargs)
      XCTAssertEqual(error.location, loc8)
    }
  }

  // MARK: - All

  /// lambda a, *b, c, **d: 5
  func test_all() {
    var parser = self.createExprParser(
      self.token(.lambda,          start: loc0, end: loc1),
      self.token(.identifier("a"), start: loc2, end: loc3),
      self.token(.comma,           start: loc4, end: loc5),
      self.token(.star,            start: loc6, end: loc7),
      self.token(.identifier("b"), start: loc8, end: loc9),
      self.token(.comma,           start: loc10, end: loc11),
      self.token(.identifier("c"), start: loc12, end: loc13),
      self.token(.comma,           start: loc14, end: loc15),
      self.token(.starStar,        start: loc16, end: loc17),
      self.token(.identifier("d"), start: loc18, end: loc19),
      self.token(.colon,           start: loc20, end: loc21),
      self.token(.float(5.0),      start: loc22, end: loc23)
    )

    if let expr = self.parse(&parser) {
      guard let l = self.destructLambda(expr) else { return }

      let argA    = Arg(name: "a", annotation: nil, start: loc2, end: loc3)
      let varargB = Arg(name: "b", annotation: nil, start: loc8, end: loc9)
      let kwC     = Arg(name: "c", annotation: nil, start: loc12, end: loc13)
      let kwDefC  = Expression(.none, start: loc13, end: loc13)
      let kwargD = Arg(name: "d", annotation: nil, start: loc18, end: loc19)
      XCTAssertEqual(l.args.args, [argA])
      XCTAssertEqual(l.args.defaults, [])
      XCTAssertEqual(l.args.vararg, .named(varargB))
      XCTAssertEqual(l.args.kwOnlyArgs, [kwC])
      XCTAssertEqual(l.args.kwOnlyDefaults, [kwDefC])
      XCTAssertEqual(l.args.kwarg, kwargD)
      XCTAssertEqual(l.args.start, loc2)
      XCTAssertEqual(l.args.end,   loc19)

      let bodyKind = ExpressionKind.float(5.0)
      XCTAssertEqual(l.body, Expression(bodyKind, start: loc22, end: loc23))

      XCTAssertExpression(expr, "(lambda (a *b c=None **d) 5.0)")
      XCTAssertEqual(expr.start, loc0)
      XCTAssertEqual(expr.end,   loc23)
    }
  }
}
