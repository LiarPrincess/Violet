import XCTest
import Core
import Lexer
@testable import Parser

// swiftlint:disable file_length
// swiftlint:disable type_body_length
// swiftlint:disable function_body_length

class LambdaTests: XCTestCase, Common {

  // MARK: - No arguments

  /// lambda: 5
  func test_noArguments() {
    var parser = self.parser(
      self.token(.lambda,   start: self.loc0, end: self.loc1),
      self.token(.colon,    start: self.loc2, end: self.loc3),
      self.token(.float(5), start: self.loc4, end: self.loc5)
    )

    if let expr = self.parse(&parser) {
      guard let l = self.destructLambda(expr) else { return }

      XCTAssertEqual(l.args.args, [])
      XCTAssertEqual(l.args.defaults, [])
      XCTAssertEqual(l.args.vararg, .none)
      XCTAssertEqual(l.args.kwOnlyArgs, [])
      XCTAssertEqual(l.args.kwOnlyDefaults, [])
      XCTAssertEqual(l.args.kwarg, nil)
      XCTAssertEqual(l.args.start, self.loc2)
      XCTAssertEqual(l.args.end,   self.loc2)

      let bodyKind = ExpressionKind.float(5.0)
      XCTAssertEqual(l.body, Expression(bodyKind, start: self.loc4, end: self.loc5))

      XCTAssertExpression(expr, "(lambda () 5.0)")
      XCTAssertEqual(expr.start, self.loc0)
      XCTAssertEqual(expr.end,   self.loc5)
    }
  }

  // MARK: - Positional

  /// lambda a: 5
  func test_positional() {
    var parser = self.parser(
      self.token(.lambda,          start: self.loc0, end: self.loc1),
      self.token(.identifier("a"), start: self.loc2, end: self.loc3),
      self.token(.colon,           start: self.loc4, end: self.loc5),
      self.token(.float(5.0),      start: self.loc6, end: self.loc7)
    )

    if let expr = self.parse(&parser) {
      guard let l = self.destructLambda(expr) else { return }

      let argA = Arg(name: "a", annotation: nil, start: self.loc2, end: self.loc3)
      XCTAssertEqual(l.args.args, [argA])
      XCTAssertEqual(l.args.defaults, [])
      XCTAssertEqual(l.args.vararg, .none)
      XCTAssertEqual(l.args.kwOnlyArgs, [])
      XCTAssertEqual(l.args.kwOnlyDefaults, [])
      XCTAssertEqual(l.args.kwarg, nil)
      XCTAssertEqual(l.args.start, self.loc2)
      XCTAssertEqual(l.args.end,   self.loc3)

      let bodyKind = ExpressionKind.float(5.0)
      XCTAssertEqual(l.body, Expression(bodyKind, start: self.loc6, end: self.loc7))

      XCTAssertExpression(expr, "(lambda (a) 5.0)")
      XCTAssertEqual(expr.start, self.loc0)
      XCTAssertEqual(expr.end,   self.loc7)
    }
  }

  /// lambda a = 1: 5
  func test_positional_default() {
    var parser = self.parser(
      self.token(.lambda,          start: self.loc0, end: self.loc1),
      self.token(.identifier("a"), start: self.loc2, end: self.loc3),
      self.token(.equal,           start: self.loc4, end: self.loc5),
      self.token(.float(1.0),      start: self.loc6, end: self.loc7),
      self.token(.colon,           start: self.loc8, end: self.loc9),
      self.token(.float(5.0),      start: self.loc10, end: self.loc11)
    )

    if let expr = self.parse(&parser) {
      guard let l = self.destructLambda(expr) else { return }

      let argA = Arg(name: "a", annotation: nil, start: self.loc2, end: self.loc3)
      let defA = Expression(.float(1.0), start: self.loc6, end: self.loc7)
      XCTAssertEqual(l.args.args, [argA])
      XCTAssertEqual(l.args.defaults, [defA])
      XCTAssertEqual(l.args.vararg, .none)
      XCTAssertEqual(l.args.kwOnlyArgs, [])
      XCTAssertEqual(l.args.kwOnlyDefaults, [])
      XCTAssertEqual(l.args.kwarg, nil)
      XCTAssertEqual(l.args.start, self.loc2)
      XCTAssertEqual(l.args.end,   self.loc7)

      let bodyKind = ExpressionKind.float(5.0)
      XCTAssertEqual(l.body, Expression(bodyKind, start: self.loc10, end: self.loc11))

      XCTAssertExpression(expr, "(lambda (a=1.0) 5.0)")
      XCTAssertEqual(expr.start, self.loc0)
      XCTAssertEqual(expr.end,   self.loc11)
    }
  }

  /// lambda a, b: 5
  func test_positional_multiple() {
    var parser = self.parser(
      self.token(.lambda,          start: self.loc0, end: self.loc1),
      self.token(.identifier("a"), start: self.loc2, end: self.loc3),
      self.token(.comma,           start: self.loc4, end: self.loc5),
      self.token(.identifier("b"), start: self.loc6, end: self.loc7),
      self.token(.colon,           start: self.loc8, end: self.loc9),
      self.token(.float(5.0),      start: self.loc10, end: self.loc11)
    )

    if let expr = self.parse(&parser) {
      guard let l = self.destructLambda(expr) else { return }

      let argA = Arg(name: "a", annotation: nil, start: self.loc2, end: self.loc3)
      let argB = Arg(name: "b", annotation: nil, start: self.loc6, end: self.loc7)
      XCTAssertEqual(l.args.args, [argA, argB])
      XCTAssertEqual(l.args.defaults, [])
      XCTAssertEqual(l.args.vararg, .none)
      XCTAssertEqual(l.args.kwOnlyArgs, [])
      XCTAssertEqual(l.args.kwOnlyDefaults, [])
      XCTAssertEqual(l.args.kwarg, nil)
      XCTAssertEqual(l.args.start, self.loc2)
      XCTAssertEqual(l.args.end,   self.loc7)

      let bodyKind = ExpressionKind.float(5.0)
      XCTAssertEqual(l.body, Expression(bodyKind, start: self.loc10, end: self.loc11))

      XCTAssertExpression(expr, "(lambda (a b) 5.0)")
      XCTAssertEqual(expr.start, self.loc0)
      XCTAssertEqual(expr.end,   self.loc11)
    }
  }

  /// lambda a, b = 1: 5
  func test_positional_default_afterRequired() {
    var parser = self.parser(
      self.token(.lambda,          start: self.loc0, end: self.loc1),
      self.token(.identifier("a"), start: self.loc2, end: self.loc3),
      self.token(.comma,           start: self.loc4, end: self.loc5),
      self.token(.identifier("b"), start: self.loc6, end: self.loc7),
      self.token(.equal,           start: self.loc8, end: self.loc9),
      self.token(.float(1.0),      start: self.loc10, end: self.loc11),
      self.token(.colon,           start: self.loc12, end: self.loc13),
      self.token(.float(5.0),      start: self.loc14, end: self.loc15)
    )

    if let expr = self.parse(&parser) {
      guard let l = self.destructLambda(expr) else { return }

      let argA = Arg(name: "a", annotation: nil, start: self.loc2, end: self.loc3)
      let argB = Arg(name: "b", annotation: nil, start: self.loc6, end: self.loc7)
      let defB = Expression(.float(1.0), start: self.loc10, end: self.loc11)
      XCTAssertEqual(l.args.args, [argA, argB])
      XCTAssertEqual(l.args.defaults, [defB])
      XCTAssertEqual(l.args.vararg, .none)
      XCTAssertEqual(l.args.kwOnlyArgs, [])
      XCTAssertEqual(l.args.kwOnlyDefaults, [])
      XCTAssertEqual(l.args.kwarg, nil)
      XCTAssertEqual(l.args.start, self.loc2)
      XCTAssertEqual(l.args.end,   self.loc11)

      let bodyKind = ExpressionKind.float(5.0)
      XCTAssertEqual(l.body, Expression(bodyKind, start: self.loc14, end: self.loc15))

      XCTAssertExpression(expr, "(lambda (a b=1.0) 5.0)")
      XCTAssertEqual(expr.start, self.loc0)
      XCTAssertEqual(expr.end,   self.loc15)
    }
  }

  /// lambda a = 1, b: 5
  func test_positional_requited_afterDefault_throws() {
    var parser = self.parser(
      self.token(.lambda,          start: self.loc0, end: self.loc1),
      self.token(.identifier("a"), start: self.loc2, end: self.loc3),
      self.token(.equal,           start: self.loc4, end: self.loc5),
      self.token(.float(1.0),      start: self.loc6, end: self.loc7),
      self.token(.comma,           start: self.loc8, end: self.loc9),
      self.token(.identifier("b"), start: self.loc10, end: self.loc11),
      self.token(.colon,           start: self.loc12, end: self.loc13),
      self.token(.float(5.0),      start: self.loc14, end: self.loc15)
    )

    if let error = self.error(&parser) {
      XCTAssertEqual(error.kind, .defaultFollowedByNonDefaultArgument)
      XCTAssertEqual(error.location, self.loc12)
    }
  }

  // MARK: - Variadic

  /// lambda *a: 5
  func test_varargs() {
    var parser = self.parser(
      self.token(.lambda,          start: self.loc0, end: self.loc1),
      self.token(.star,            start: self.loc2, end: self.loc3),
      self.token(.identifier("a"), start: self.loc4, end: self.loc5),
      self.token(.colon,           start: self.loc6, end: self.loc7),
      self.token(.float(5.0),      start: self.loc8, end: self.loc9)
    )

    if let expr = self.parse(&parser) {
      guard let l = self.destructLambda(expr) else { return }

      let varargA = Arg(name: "a", annotation: nil, start: self.loc4, end: self.loc5)
      XCTAssertEqual(l.args.args, [])
      XCTAssertEqual(l.args.defaults, [])
      XCTAssertEqual(l.args.vararg, .named(varargA))
      XCTAssertEqual(l.args.kwOnlyArgs, [])
      XCTAssertEqual(l.args.kwOnlyDefaults, [])
      XCTAssertEqual(l.args.kwarg, nil)
      XCTAssertEqual(l.args.start, self.loc2)
      XCTAssertEqual(l.args.end,   self.loc5)

      let bodyKind = ExpressionKind.float(5.0)
      XCTAssertEqual(l.body, Expression(bodyKind, start: self.loc8, end: self.loc9))

      XCTAssertExpression(expr, "(lambda (*a) 5.0)")
      XCTAssertEqual(expr.start, self.loc0)
      XCTAssertEqual(expr.end,   self.loc9)
    }
  }

  /// lambda *a, b = 1: 5
  func test_varargs_keywordOnly_withDefault() {
    var parser = self.parser(
      self.token(.lambda,          start: self.loc0, end: self.loc1),
      self.token(.star,            start: self.loc2, end: self.loc3),
      self.token(.identifier("a"), start: self.loc4, end: self.loc5),
      self.token(.comma,           start: self.loc6, end: self.loc7),
      self.token(.identifier("b"), start: self.loc8, end: self.loc9),
      self.token(.equal,           start: self.loc10, end: self.loc11),
      self.token(.float(1.0),      start: self.loc12, end: self.loc13),
      self.token(.colon,           start: self.loc14, end: self.loc15),
      self.token(.float(5.0),      start: self.loc16, end: self.loc17)
    )

    if let expr = self.parse(&parser) {
      guard let l = self.destructLambda(expr) else { return }

      let varargA = Arg(name: "a", annotation: nil, start: self.loc4, end: self.loc5)
      let kwB     = Arg(name: "b", annotation: nil, start: self.loc8, end: self.loc9)
      let kwDefB  = Expression(.float(1), start: self.loc12, end: self.loc13)
      XCTAssertEqual(l.args.args, [])
      XCTAssertEqual(l.args.defaults, [])
      XCTAssertEqual(l.args.vararg, .named(varargA))
      XCTAssertEqual(l.args.kwOnlyArgs, [kwB])
      XCTAssertEqual(l.args.kwOnlyDefaults, [kwDefB])
      XCTAssertEqual(l.args.kwarg, nil)
      XCTAssertEqual(l.args.start, self.loc2)
      XCTAssertEqual(l.args.end,   self.loc13)

      let bodyKind = ExpressionKind.float(5.0)
      XCTAssertEqual(l.body, Expression(bodyKind, start: self.loc16, end: self.loc17))

      XCTAssertExpression(expr, "(lambda (*a b=1.0) 5.0)")
      XCTAssertEqual(expr.start, self.loc0)
      XCTAssertEqual(expr.end,   self.loc17)
    }
  }

  /// lambda *a, b: 5
  func test_varargs_keywordOnly_withoutDefault_isImplicitNone() {
    var parser = self.parser(
      self.token(.lambda,          start: self.loc0, end: self.loc1),
      self.token(.star,            start: self.loc2, end: self.loc3),
      self.token(.identifier("a"), start: self.loc4, end: self.loc5),
      self.token(.comma,           start: self.loc6, end: self.loc7),
      self.token(.identifier("b"), start: self.loc8, end: self.loc9),
      self.token(.colon,           start: self.loc10, end: self.loc11),
      self.token(.float(5.0),      start: self.loc12, end: self.loc13)
    )

    if let expr = self.parse(&parser) {
      guard let l = self.destructLambda(expr) else { return }

      let varargA = Arg(name: "a", annotation: nil, start: self.loc4, end: self.loc5)
      let kwB     = Arg(name: "b", annotation: nil, start: self.loc8, end: self.loc9)
      let kwDefB = Expression(.none, start: self.loc9, end: self.loc9)
      XCTAssertEqual(l.args.args, [])
      XCTAssertEqual(l.args.defaults, [])
      XCTAssertEqual(l.args.vararg, .named(varargA))
      XCTAssertEqual(l.args.kwOnlyArgs, [kwB])
      XCTAssertEqual(l.args.kwOnlyDefaults, [kwDefB])
      XCTAssertEqual(l.args.kwarg, nil)
      XCTAssertEqual(l.args.start, self.loc2)
      XCTAssertEqual(l.args.end,   self.loc9)

      let bodyKind = ExpressionKind.float(5.0)
      XCTAssertEqual(l.body, Expression(bodyKind, start: self.loc12, end: self.loc13))

      XCTAssertExpression(expr, "(lambda (*a b=None) 5.0)")
      XCTAssertEqual(expr.start, self.loc0)
      XCTAssertEqual(expr.end,   self.loc13)
    }
  }

  /// lambda *a, *b: 5
  func test_varargs_duplicate_throws() {
    var parser = self.parser(
      self.token(.lambda,          start: self.loc0, end: self.loc1),
      self.token(.star,            start: self.loc2, end: self.loc3),
      self.token(.identifier("a"), start: self.loc4, end: self.loc5),
      self.token(.comma,           start: self.loc6, end: self.loc7),
      self.token(.star,            start: self.loc8, end: self.loc9),
      self.token(.identifier("b"), start: self.loc10, end: self.loc11),
      self.token(.colon,           start: self.loc12, end: self.loc13),
      self.token(.float(5.0),      start: self.loc14, end: self.loc15)
    )

    if let error = self.error(&parser) {
      XCTAssertEqual(error.kind, .duplicateVarargs)
      XCTAssertEqual(error.location, self.loc8)
    }
  }

  /// lambda *, a: 5
  func test_varargsUnnamed() {
    var parser = self.parser(
      self.token(.lambda,          start: self.loc0, end: self.loc1),
      self.token(.star,            start: self.loc2, end: self.loc3),
      self.token(.comma,           start: self.loc4, end: self.loc5),
      self.token(.identifier("a"), start: self.loc6, end: self.loc7),
      self.token(.colon,           start: self.loc8, end: self.loc9),
      self.token(.float(5.0),      start: self.loc10, end: self.loc11)
    )

    if let expr = self.parse(&parser) {
      guard let l = self.destructLambda(expr) else { return }

      let kwA = Arg(name: "a", annotation: nil, start: self.loc6, end: self.loc7)
      let kwDefA = Expression(.none, start: self.loc7, end: self.loc7)
      XCTAssertEqual(l.args.args, [])
      XCTAssertEqual(l.args.defaults, [])
      XCTAssertEqual(l.args.vararg, .unnamed)
      XCTAssertEqual(l.args.kwOnlyArgs, [kwA])
      XCTAssertEqual(l.args.kwOnlyDefaults, [kwDefA])
      XCTAssertEqual(l.args.kwarg, nil)
      XCTAssertEqual(l.args.start, self.loc2)
      XCTAssertEqual(l.args.end,   self.loc7)

      let bodyKind = ExpressionKind.float(5.0)
      XCTAssertEqual(l.body, Expression(bodyKind, start: self.loc10, end: self.loc11))

      XCTAssertExpression(expr, "(lambda (* a=None) 5.0)")
      XCTAssertEqual(expr.start, self.loc0)
      XCTAssertEqual(expr.end,   self.loc11)
    }
  }

  /// lambda *: 5
  func test_varargsUnnamed_withoutFollowingArguments_throws() {
    var parser = self.parser(
      self.token(.lambda,          start: self.loc0, end: self.loc1),
      self.token(.star,            start: self.loc2, end: self.loc3),
      self.token(.colon,           start: self.loc4, end: self.loc5),
      self.token(.float(5.0),      start: self.loc6, end: self.loc7)
    )

    if let error = self.error(&parser) {
      XCTAssertEqual(error.kind, .starWithoutFollowingArguments)
      XCTAssertEqual(error.location, self.loc4)
    }
  }

  // MARK: - Kwargs

  /// lambda **a: 5
  func test_kwargs() {
    var parser = self.parser(
      self.token(.lambda,          start: self.loc0, end: self.loc1),
      self.token(.starStar,        start: self.loc2, end: self.loc3),
      self.token(.identifier("a"), start: self.loc4, end: self.loc5),
      self.token(.colon,           start: self.loc6, end: self.loc7),
      self.token(.float(5.0),      start: self.loc8, end: self.loc9)
    )

    if let expr = self.parse(&parser) {
      guard let l = self.destructLambda(expr) else { return }

      let kwargA = Arg(name: "a", annotation: nil, start: self.loc4, end: self.loc5)
      XCTAssertEqual(l.args.args, [])
      XCTAssertEqual(l.args.defaults, [])
      XCTAssertEqual(l.args.vararg, .none)
      XCTAssertEqual(l.args.kwOnlyArgs, [])
      XCTAssertEqual(l.args.kwOnlyDefaults, [])
      XCTAssertEqual(l.args.kwarg, kwargA)
      XCTAssertEqual(l.args.start, self.loc2)
      XCTAssertEqual(l.args.end,   self.loc5)

      let bodyKind = ExpressionKind.float(5.0)
      XCTAssertEqual(l.body, Expression(bodyKind, start: self.loc8, end: self.loc9))

      XCTAssertExpression(expr, "(lambda (**a) 5.0)")
      XCTAssertEqual(expr.start, self.loc0)
      XCTAssertEqual(expr.end,   self.loc9)
    }
  }

  /// lambda **a,: 5
  func test_kwargs_withCommaAfter() {
    var parser = self.parser(
      self.token(.lambda,          start: self.loc0, end: self.loc1),
      self.token(.starStar,        start: self.loc2, end: self.loc3),
      self.token(.identifier("a"), start: self.loc4, end: self.loc5),
      self.token(.comma,           start: self.loc6, end: self.loc7),
      self.token(.colon,           start: self.loc8, end: self.loc9),
      self.token(.float(5.0),      start: self.loc10, end: self.loc11)
    )

    if let expr = self.parse(&parser) {
      guard let l = self.destructLambda(expr) else { return }

      let kwargA = Arg(name: "a", annotation: nil, start: self.loc4, end: self.loc5)
      XCTAssertEqual(l.args.args, [])
      XCTAssertEqual(l.args.defaults, [])
      XCTAssertEqual(l.args.vararg, .none)
      XCTAssertEqual(l.args.kwOnlyArgs, [])
      XCTAssertEqual(l.args.kwOnlyDefaults, [])
      XCTAssertEqual(l.args.kwarg, kwargA)
      XCTAssertEqual(l.args.start, self.loc2)
      XCTAssertEqual(l.args.end,   self.loc7)

      let bodyKind = ExpressionKind.float(5.0)
      XCTAssertEqual(l.body, Expression(bodyKind, start: self.loc10, end: self.loc11))

      XCTAssertExpression(expr, "(lambda (**a) 5.0)")
      XCTAssertEqual(expr.start, self.loc0)
      XCTAssertEqual(expr.end,   self.loc11)
    }
  }

  /// lambda **a, **b: 5
  func test_kwargs_duplicate_throws() {
    var parser = self.parser(
      self.token(.lambda,          start: self.loc0, end: self.loc1),
      self.token(.starStar,        start: self.loc2, end: self.loc3),
      self.token(.identifier("a"), start: self.loc4, end: self.loc5),
      self.token(.comma,           start: self.loc6, end: self.loc7),
      self.token(.starStar,        start: self.loc8, end: self.loc9),
      self.token(.identifier("b"), start: self.loc10, end: self.loc11),
      self.token(.colon,           start: self.loc12, end: self.loc13),
      self.token(.float(5.0),      start: self.loc14, end: self.loc15)
    )

    if let error = self.error(&parser) {
      XCTAssertEqual(error.kind, .duplicateKwargs)
      XCTAssertEqual(error.location, self.loc8)
    }
  }

  // MARK: - All

  /// lambda a, *b, c, **d: 5
  func test_all() {
    var parser = self.parser(
      self.token(.lambda,          start: self.loc0, end: self.loc1),
      self.token(.identifier("a"), start: self.loc2, end: self.loc3),
      self.token(.comma,           start: self.loc4, end: self.loc5),
      self.token(.star,            start: self.loc6, end: self.loc7),
      self.token(.identifier("b"), start: self.loc8, end: self.loc9),
      self.token(.comma,           start: self.loc10, end: self.loc11),
      self.token(.identifier("c"), start: self.loc12, end: self.loc13),
      self.token(.comma,           start: self.loc14, end: self.loc15),
      self.token(.starStar,        start: self.loc16, end: self.loc17),
      self.token(.identifier("d"), start: self.loc18, end: self.loc19),
      self.token(.colon,           start: self.loc20, end: self.loc21),
      self.token(.float(5.0),      start: self.loc22, end: self.loc23)
    )

    if let expr = self.parse(&parser) {
      guard let l = self.destructLambda(expr) else { return }

      let argA    = Arg(name: "a", annotation: nil, start: self.loc2, end: self.loc3)
      let varargB = Arg(name: "b", annotation: nil, start: self.loc8, end: self.loc9)
      let kwC     = Arg(name: "c", annotation: nil, start: self.loc12, end: self.loc13)
      let kwDefC  = Expression(.none, start: self.loc13, end: self.loc13)
      let kwargD = Arg(name: "d", annotation: nil, start: self.loc18, end: self.loc19)
      XCTAssertEqual(l.args.args, [argA])
      XCTAssertEqual(l.args.defaults, [])
      XCTAssertEqual(l.args.vararg, .named(varargB))
      XCTAssertEqual(l.args.kwOnlyArgs, [kwC])
      XCTAssertEqual(l.args.kwOnlyDefaults, [kwDefC])
      XCTAssertEqual(l.args.kwarg, kwargD)
      XCTAssertEqual(l.args.start, self.loc2)
      XCTAssertEqual(l.args.end,   self.loc19)

      let bodyKind = ExpressionKind.float(5.0)
      XCTAssertEqual(l.body, Expression(bodyKind, start: self.loc22, end: self.loc23))

      XCTAssertExpression(expr, "(lambda (a *b c=None **d) 5.0)")
      XCTAssertEqual(expr.start, self.loc0)
      XCTAssertEqual(expr.end,   self.loc23)
    }
  }
}
