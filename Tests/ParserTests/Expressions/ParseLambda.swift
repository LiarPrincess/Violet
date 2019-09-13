import XCTest
import Core
import Lexer
@testable import Parser

// swiftlint:disable file_length
// swiftlint:disable function_body_length

class ParseLambda: XCTestCase, Common, ExpressionMatcher {

  // MARK: - No arguments

  /// lambda: "Ratatouille"
  func test_noArguments() {
    var parser = self.createExprParser(
      self.token(.lambda,                start: loc0, end: loc1),
      self.token(.colon,                 start: loc8, end: loc9),
      self.token(.string("Ratatouille"), start: loc10, end: loc11)
    )

    if let expr = self.parseExpr(&parser) {
      guard let d = self.matchLambda(expr) else { return }

      XCTAssertArguments(d.args.args, [])
      XCTAssertArgumentDefaults(d.args.defaults, [])
      XCTAssertVararg(d.args.vararg, .none)
      XCTAssertArguments(d.args.kwOnlyArgs, [])
      XCTAssertArgumentDefaults(d.args.kwOnlyDefaults, [])
      XCTAssertEqual(d.args.kwarg, nil)
      XCTAssertEqual(d.args.start, loc8)
      XCTAssertEqual(d.args.end,   loc8)

      XCTAssertExpression(d.body, "'Ratatouille'")

      XCTAssertExpression(expr, "(λ () do: 'Ratatouille')")
      XCTAssertEqual(expr.start, loc0)
      XCTAssertEqual(expr.end,   loc11)
    }
  }

  // MARK: - Positional

  /// lambda zucchini: "Ratatouille"
  func test_positional() {
    var parser = self.createExprParser(
      self.token(.lambda,                 start: loc0, end: loc1),
      self.token(.identifier("zucchini"), start: loc6, end: loc7),
      self.token(.colon,                  start: loc10, end: loc11),
      self.token(.string("Ratatouille"),  start: loc12, end: loc13)
    )

    if let expr = self.parseExpr(&parser) {
      guard let d = self.matchLambda(expr) else { return }

      let argA = Arg("zucchini", annotation: nil, start: loc6, end: loc7)
      XCTAssertArguments(d.args.args, [argA])
      XCTAssertArgumentDefaults(d.args.defaults, [])
      XCTAssertVararg(d.args.vararg, .none)
      XCTAssertArguments(d.args.kwOnlyArgs, [])
      XCTAssertArgumentDefaults(d.args.kwOnlyDefaults, [])
      XCTAssertEqual(d.args.kwarg, nil)
      XCTAssertEqual(d.args.start, loc6)
      XCTAssertEqual(d.args.end,   loc7)

      XCTAssertExpression(d.body, "'Ratatouille'")

      XCTAssertExpression(expr, "(λ (zucchini) do: 'Ratatouille')")
      XCTAssertEqual(expr.start, loc0)
      XCTAssertEqual(expr.end,   loc13)
    }
  }

  /// lambda zucchini = 1: "Ratatouille"
  func test_positional_default() {
    var parser = self.createExprParser(
      self.token(.lambda,                 start: loc0, end: loc1),
      self.token(.identifier("zucchini"), start: loc6, end: loc7),
      self.token(.equal,                  start: loc8, end: loc9),
      self.token(.float(1.0),             start: loc10, end: loc11),
      self.token(.colon,                  start: loc14, end: loc15),
      self.token(.string("Ratatouille"),  start: loc16, end: loc17)
    )

    if let expr = self.parseExpr(&parser) {
      guard let d = self.matchLambda(expr) else { return }

      let argA = Arg("zucchini", annotation: nil, start: loc6, end: loc7)
      let defA = Expression(.float(1.0), start: loc10, end: loc11)
      XCTAssertArguments(d.args.args, [argA])
      XCTAssertArgumentDefaults(d.args.defaults, [defA])
      XCTAssertVararg(d.args.vararg, .none)
      XCTAssertArguments(d.args.kwOnlyArgs, [])
      XCTAssertArgumentDefaults(d.args.kwOnlyDefaults, [])
      XCTAssertEqual(d.args.kwarg, nil)
      XCTAssertEqual(d.args.start, loc6)
      XCTAssertEqual(d.args.end,   loc11)

      XCTAssertExpression(d.body, "'Ratatouille'")

      XCTAssertExpression(expr, "(λ (zucchini=1.0) do: 'Ratatouille')")
      XCTAssertEqual(expr.start, loc0)
      XCTAssertEqual(expr.end,   loc17)
    }
  }

  /// lambda zucchini, tomato: "Ratatouille"
  func test_positional_multiple() {
    var parser = self.createExprParser(
      self.token(.lambda,                 start: loc0, end: loc1),
      self.token(.identifier("zucchini"), start: loc6, end: loc7),
      self.token(.comma,                  start: loc8, end: loc9),
      self.token(.identifier("tomato"),   start: loc10, end: loc11),
      self.token(.colon,                  start: loc14, end: loc15),
      self.token(.string("Ratatouille"),  start: loc16, end: loc17)
    )

    if let expr = self.parseExpr(&parser) {
      guard let d = self.matchLambda(expr) else { return }

      let argA = Arg("zucchini", annotation: nil, start: loc6, end: loc7)
      let argB = Arg("tomato", annotation: nil, start: loc10, end: loc11)
      XCTAssertArguments(d.args.args, [argA, argB])
      XCTAssertArgumentDefaults(d.args.defaults, [])
      XCTAssertVararg(d.args.vararg, .none)
      XCTAssertArguments(d.args.kwOnlyArgs, [])
      XCTAssertArgumentDefaults(d.args.kwOnlyDefaults, [])
      XCTAssertEqual(d.args.kwarg, nil)
      XCTAssertEqual(d.args.start, loc6)
      XCTAssertEqual(d.args.end,   loc11)

      XCTAssertExpression(d.body, "'Ratatouille'")

      XCTAssertExpression(expr, "(λ (zucchini tomato) do: 'Ratatouille')")
      XCTAssertEqual(expr.start, loc0)
      XCTAssertEqual(expr.end,   loc17)
    }
  }

  /// lambda zucchini, tomato=1: "Ratatouille"
  func test_positional_default_afterRequired() {
    var parser = self.createExprParser(
      self.token(.lambda,                 start: loc0, end: loc1),
      self.token(.identifier("zucchini"), start: loc6, end: loc7),
      self.token(.comma,                  start: loc8, end: loc9),
      self.token(.identifier("tomato"),   start: loc10, end: loc11),
      self.token(.equal,                  start: loc12, end: loc13),
      self.token(.float(1.0),             start: loc14, end: loc15),
      self.token(.colon,                  start: loc18, end: loc19),
      self.token(.string("Ratatouille"),  start: loc20, end: loc21)
    )

    if let expr = self.parseExpr(&parser) {
      guard let d = self.matchLambda(expr) else { return }

      let argA = Arg("zucchini", annotation: nil, start: loc6, end: loc7)
      let argB = Arg("tomato", annotation: nil, start: loc10, end: loc11)
      let defB = Expression(.float(1.0), start: loc14, end: loc15)
      XCTAssertArguments(d.args.args, [argA, argB])
      XCTAssertArgumentDefaults(d.args.defaults, [defB])
      XCTAssertVararg(d.args.vararg, .none)
      XCTAssertArguments(d.args.kwOnlyArgs, [])
      XCTAssertArgumentDefaults(d.args.kwOnlyDefaults, [])
      XCTAssertEqual(d.args.kwarg, nil)
      XCTAssertEqual(d.args.start, loc6)
      XCTAssertEqual(d.args.end,   loc15)

      XCTAssertExpression(d.body, "'Ratatouille'")

      XCTAssertExpression(expr, "(λ (zucchini tomato=1.0) do: 'Ratatouille')")
      XCTAssertEqual(expr.start, loc0)
      XCTAssertEqual(expr.end,   loc21)
    }
  }

  /// lambda zucchini = 1, tomato: "Ratatouille"
  func test_positional_requited_afterDefault_throws() {
    var parser = self.createExprParser(
      self.token(.lambda,                 start: loc0, end: loc1),
      self.token(.identifier("zucchini"), start: loc6, end: loc7),
      self.token(.equal,                  start: loc8, end: loc9),
      self.token(.float(1.0),             start: loc10, end: loc11),
      self.token(.comma,                  start: loc12, end: loc13),
      self.token(.identifier("tomato"),   start: loc14, end: loc15),
      self.token(.colon,                  start: loc18, end: loc19),
      self.token(.string("Ratatouille"),  start: loc20, end: loc21)
    )

    if let error = self.error(&parser) {
      XCTAssertEqual(error.kind, .defaultAfterNonDefaultArgument)
      XCTAssertEqual(error.location, loc14)
    }
  }

  // MARK: - Variadic

  /// lambda *zucchini: "Ratatouille"
  func test_varargs() {
    var parser = self.createExprParser(
      self.token(.lambda,                 start: loc0, end: loc1),
      self.token(.star,                   start: loc6, end: loc7),
      self.token(.identifier("zucchini"), start: loc8, end: loc9),
      self.token(.colon,                  start: loc12, end: loc13),
      self.token(.string("Ratatouille"),  start: loc14, end: loc15)
    )

    if let expr = self.parseExpr(&parser) {
      guard let d = self.matchLambda(expr) else { return }

      let varargA = Arg("zucchini", annotation: nil, start: loc8, end: loc9)
      XCTAssertArguments(d.args.args, [])
      XCTAssertArgumentDefaults(d.args.defaults, [])
      XCTAssertVararg(d.args.vararg, .named(varargA))
      XCTAssertArguments(d.args.kwOnlyArgs, [])
      XCTAssertArgumentDefaults(d.args.kwOnlyDefaults, [])
      XCTAssertEqual(d.args.kwarg, nil)
      XCTAssertEqual(d.args.start, loc6)
      XCTAssertEqual(d.args.end,   loc9)

      XCTAssertExpression(d.body, "'Ratatouille'")

      XCTAssertExpression(expr, "(λ (*zucchini) do: 'Ratatouille')")
      XCTAssertEqual(expr.start, loc0)
      XCTAssertEqual(expr.end,   loc15)
    }
  }

  /// lambda *zucchini, tomato=1: "Ratatouille"
  func test_varargs_keywordOnly_withDefault() {
    var parser = self.createExprParser(
      self.token(.lambda,                 start: loc0, end: loc1),
      self.token(.star,                   start: loc6, end: loc7),
      self.token(.identifier("zucchini"), start: loc8, end: loc9),
      self.token(.comma,                  start: loc10, end: loc11),
      self.token(.identifier("tomato"),   start: loc12, end: loc13),
      self.token(.equal,                  start: loc14, end: loc15),
      self.token(.float(1.0),             start: loc16, end: loc17),
      self.token(.colon,                  start: loc20, end: loc21),
      self.token(.string("Ratatouille"),  start: loc22, end: loc23)
    )

    if let expr = self.parseExpr(&parser) {
      guard let d = self.matchLambda(expr) else { return }

      let varargA = Arg("zucchini", annotation: nil, start: loc8, end: loc9)
      let kwB     = Arg("tomato", annotation: nil, start: loc12, end: loc13)
      let kwDefB  = Expression(.float(1), start: loc16, end: loc17)
      XCTAssertArguments(d.args.args, [])
      XCTAssertArgumentDefaults(d.args.defaults, [])
      XCTAssertVararg(d.args.vararg, .named(varargA))
      XCTAssertArguments(d.args.kwOnlyArgs, [kwB])
      XCTAssertArgumentDefaults(d.args.kwOnlyDefaults, [kwDefB])
      XCTAssertEqual(d.args.kwarg, nil)
      XCTAssertEqual(d.args.start, loc6)
      XCTAssertEqual(d.args.end,   loc17)

      XCTAssertExpression(d.body, "'Ratatouille'")

      XCTAssertExpression(expr, "(λ (*zucchini tomato=1.0) do: 'Ratatouille')")
      XCTAssertEqual(expr.start, loc0)
      XCTAssertEqual(expr.end,   loc23)
    }
  }

  /// lambda *zucchini, tomato: "Ratatouille"
  func test_varargs_keywordOnly_withoutDefault_isImplicitNone() {
    var parser = self.createExprParser(
      self.token(.lambda,                 start: loc0, end: loc1),
      self.token(.star,                   start: loc6, end: loc7),
      self.token(.identifier("zucchini"), start: loc8, end: loc9),
      self.token(.comma,                  start: loc10, end: loc11),
      self.token(.identifier("tomato"),   start: loc12, end: loc13),
      self.token(.colon,                  start: loc16, end: loc17),
      self.token(.string("Ratatouille"),  start: loc18, end: loc19)
    )

    if let expr = self.parseExpr(&parser) {
      guard let d = self.matchLambda(expr) else { return }

      let varargA = Arg("zucchini", annotation: nil, start: loc8, end: loc9)
      let kwB     = Arg("tomato", annotation: nil, start: loc12, end: loc13)
      let kwDefB = Expression(.none, start: loc13, end: loc13)
      XCTAssertArguments(d.args.args, [])
      XCTAssertArgumentDefaults(d.args.defaults, [])
      XCTAssertVararg(d.args.vararg, .named(varargA))
      XCTAssertArguments(d.args.kwOnlyArgs, [kwB])
      XCTAssertArgumentDefaults(d.args.kwOnlyDefaults, [kwDefB])
      XCTAssertEqual(d.args.kwarg, nil)
      XCTAssertEqual(d.args.start, loc6)
      XCTAssertEqual(d.args.end,   loc13)

      XCTAssertExpression(d.body, "'Ratatouille'")

      XCTAssertExpression(expr, "(λ (*zucchini tomato=None) do: 'Ratatouille')")
      XCTAssertEqual(expr.start, loc0)
      XCTAssertEqual(expr.end,   loc19)
    }
  }

  /// lambda *zucchini, *tomato: "Ratatouille"
  func test_varargs_duplicate_throws() {
    var parser = self.createExprParser(
      self.token(.lambda,                 start: loc0, end: loc1),
      self.token(.star,                   start: loc6, end: loc7),
      self.token(.identifier("zucchini"), start: loc8, end: loc9),
      self.token(.comma,                  start: loc10, end: loc11),
      self.token(.star,                   start: loc12, end: loc13),
      self.token(.identifier("tomato"),   start: loc14, end: loc15),
      self.token(.colon,                  start: loc18, end: loc19),
      self.token(.string("Ratatouille"),  start: loc20, end: loc21)
    )

    if let error = self.error(&parser) {
      XCTAssertEqual(error.kind, .duplicateVarargs)
      XCTAssertEqual(error.location, loc12)
    }
  }

  /// lambda *, zucchini: "Ratatouille"
  func test_varargsUnnamed() {
    var parser = self.createExprParser(
      self.token(.lambda,                 start: loc0, end: loc1),
      self.token(.star,                   start: loc6, end: loc7),
      self.token(.comma,                  start: loc8, end: loc9),
      self.token(.identifier("zucchini"), start: loc10, end: loc11),
      self.token(.colon,                  start: loc14, end: loc15),
      self.token(.string("Ratatouille"),  start: loc16, end: loc17)
    )

    if let expr = self.parseExpr(&parser) {
      guard let d = self.matchLambda(expr) else { return }

      let kwA = Arg("zucchini", annotation: nil, start: loc10, end: loc11)
      let kwDefA = Expression(.none, start: loc11, end: loc11)
      XCTAssertArguments(d.args.args, [])
      XCTAssertArgumentDefaults(d.args.defaults, [])
      XCTAssertVararg(d.args.vararg, .unnamed)
      XCTAssertArguments(d.args.kwOnlyArgs, [kwA])
      XCTAssertArgumentDefaults(d.args.kwOnlyDefaults, [kwDefA])
      XCTAssertEqual(d.args.kwarg, nil)
      XCTAssertEqual(d.args.start, loc6)
      XCTAssertEqual(d.args.end,   loc11)

      XCTAssertExpression(d.body, "'Ratatouille'")

      XCTAssertExpression(expr, "(λ (* zucchini=None) do: 'Ratatouille')")
      XCTAssertEqual(expr.start, loc0)
      XCTAssertEqual(expr.end,   loc17)
    }
  }

  /// lambda *: "Ratatouille"
  func test_varargsUnnamed_withoutFollowingArguments_throws() {
    var parser = self.createExprParser(
      self.token(.lambda,                 start: loc0, end: loc1),
      self.token(.star,                   start: loc6, end: loc7),
      self.token(.colon,                  start: loc10, end: loc11),
      self.token(.string("Ratatouille"),  start: loc12, end: loc13)
    )

    if let error = self.error(&parser) {
      XCTAssertEqual(error.kind, .starWithoutFollowingArguments)
      XCTAssertEqual(error.location, loc10)
    }
  }

  // MARK: - Kwargs

  /// lambda **zucchini: "Ratatouille"
  func test_kwargs() {
    var parser = self.createExprParser(
      self.token(.lambda,                 start: loc0, end: loc1),
      self.token(.starStar,               start: loc6, end: loc7),
      self.token(.identifier("zucchini"), start: loc8, end: loc9),
      self.token(.colon,                  start: loc12, end: loc13),
      self.token(.string("Ratatouille"),  start: loc14, end: loc15)
    )

    if let expr = self.parseExpr(&parser) {
      guard let d = self.matchLambda(expr) else { return }

      let kwargA = Arg("zucchini", annotation: nil, start: loc8, end: loc9)
      XCTAssertArguments(d.args.args, [])
      XCTAssertArgumentDefaults(d.args.defaults, [])
      XCTAssertVararg(d.args.vararg, .none)
      XCTAssertArguments(d.args.kwOnlyArgs, [])
      XCTAssertArgumentDefaults(d.args.kwOnlyDefaults, [])
      XCTAssertArgument(d.args.kwarg, kwargA)
      XCTAssertEqual(d.args.start, loc6)
      XCTAssertEqual(d.args.end,   loc9)

      XCTAssertExpression(d.body, "'Ratatouille'")

      XCTAssertExpression(expr, "(λ (**zucchini) do: 'Ratatouille')")
      XCTAssertEqual(expr.start, loc0)
      XCTAssertEqual(expr.end,   loc15)
    }
  }

  /// lambda **zucchini,: "Ratatouille"
  func test_kwargs_withCommaAfter() {
    var parser = self.createExprParser(
      self.token(.lambda,                 start: loc0, end: loc1),
      self.token(.starStar,               start: loc6, end: loc7),
      self.token(.identifier("zucchini"), start: loc8, end: loc9),
      self.token(.comma,                  start: loc10, end: loc11),
      self.token(.colon,                  start: loc14, end: loc15),
      self.token(.string("Ratatouille"),  start: loc16, end: loc17)
    )

    if let expr = self.parseExpr(&parser) {
      guard let d = self.matchLambda(expr) else { return }

      let kwargA = Arg("zucchini", annotation: nil, start: loc8, end: loc9)
      XCTAssertArguments(d.args.args, [])
      XCTAssertArgumentDefaults(d.args.defaults, [])
      XCTAssertVararg(d.args.vararg, .none)
      XCTAssertArguments(d.args.kwOnlyArgs, [])
      XCTAssertArgumentDefaults(d.args.kwOnlyDefaults, [])
      XCTAssertArgument(d.args.kwarg, kwargA)
      XCTAssertEqual(d.args.start, loc6)
      XCTAssertEqual(d.args.end,   loc11)

      XCTAssertExpression(d.body, "'Ratatouille'")

      XCTAssertExpression(expr, "(λ (**zucchini) do: 'Ratatouille')")
      XCTAssertEqual(expr.start, loc0)
      XCTAssertEqual(expr.end,   loc17)
    }
  }

  /// lambda **zucchini, **tomato: "Ratatouille"
  func test_kwargs_duplicate_throws() {
    var parser = self.createExprParser(
      self.token(.lambda,                 start: loc0, end: loc1),
      self.token(.starStar,               start: loc6, end: loc7),
      self.token(.identifier("zucchini"), start: loc8, end: loc9),
      self.token(.comma,                  start: loc10, end: loc11),
      self.token(.starStar,               start: loc12, end: loc13),
      self.token(.identifier("tomato"),   start: loc14, end: loc15),
      self.token(.colon,                  start: loc18, end: loc19),
      self.token(.string("Ratatouille"),  start: loc20, end: loc21)
    )

    if let error = self.error(&parser) {
      XCTAssertEqual(error.kind, .duplicateKwargs)
      XCTAssertEqual(error.location, loc12)
    }
  }

  // MARK: - All

  /// lambda zucchini, *tomato, pepper, **eggplant: "Ratatouille"
  func test_all() {
    var parser = self.createExprParser(
      self.token(.lambda,                 start: loc0, end: loc1),
      self.token(.identifier("zucchini"), start: loc6, end: loc7),
      self.token(.comma,                  start: loc8, end: loc9),
      self.token(.star,                   start: loc10, end: loc11),
      self.token(.identifier("tomato"),   start: loc12, end: loc13),
      self.token(.comma,                  start: loc14, end: loc15),
      self.token(.identifier("pepper"),   start: loc16, end: loc17),
      self.token(.comma,                  start: loc18, end: loc19),
      self.token(.starStar,               start: loc20, end: loc21),
      self.token(.identifier("eggplant"), start: loc22, end: loc23),
      self.token(.colon,                  start: loc26, end: loc27),
      self.token(.string("Ratatouille"),  start: loc28, end: loc29)
    )

    if let expr = self.parseExpr(&parser) {
      guard let d = self.matchLambda(expr) else { return }

      let argA    = Arg("zucchini", annotation: nil, start: loc6, end: loc7)
      let varargB = Arg("tomato", annotation: nil, start: loc12, end: loc13)
      let kwC     = Arg("pepper", annotation: nil, start: loc16, end: loc17)
      let kwDefC  = Expression(.none, start: loc17, end: loc17)
      let kwargD = Arg("eggplant", annotation: nil, start: loc22, end: loc23)
      XCTAssertArguments(d.args.args, [argA])
      XCTAssertArgumentDefaults(d.args.defaults, [])
      XCTAssertVararg(d.args.vararg, .named(varargB))
      XCTAssertArguments(d.args.kwOnlyArgs, [kwC])
      XCTAssertArgumentDefaults(d.args.kwOnlyDefaults, [kwDefC])
      XCTAssertArgument(d.args.kwarg, kwargD)
      XCTAssertEqual(d.args.start, loc6)
      XCTAssertEqual(d.args.end,   loc23)

      XCTAssertExpression(d.body, "'Ratatouille'")

      XCTAssertExpression(expr, "(λ (zucchini *tomato pepper=None **eggplant) do: 'Ratatouille')")
      XCTAssertEqual(expr.start, loc0)
      XCTAssertEqual(expr.end,   loc29)
    }
  }
}
