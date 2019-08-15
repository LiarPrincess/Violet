import XCTest
import Core
import Lexer
@testable import Parser

// swiftlint:disable file_length
// swiftlint:disable type_body_length
// swiftlint:disable function_body_length

class FunctionDefTests: XCTestCase,
  Common, DestructExpressionKind, DestructStatementKind {

  // MARK: - No arguments

  /// def cook(): "Ratatouille"
  func test_noArguments() {
    var parser = self.createStmtParser(
      self.token(.def,                   start: loc0, end: loc1),
      self.token(.identifier("cook"),    start: loc2, end: loc3),
      self.token(.leftParen,             start: loc4, end: loc5),
      self.token(.rightParen,            start: loc6, end: loc7),
      self.token(.colon,                 start: loc8, end: loc9),
      self.token(.string("Ratatouille"), start: loc10, end: loc11)
    )

    if let stmt = self.parseStmt(&parser) {
      guard let d = self.destructFunctionDef(stmt) else { return }

      XCTAssertEqual(d.name, "cook")
      XCTAssertEqual(d.returns, nil)

      XCTAssertEqual(d.args.args, [])
      XCTAssertEqual(d.args.defaults, [])
      XCTAssertEqual(d.args.vararg, .none)
      XCTAssertEqual(d.args.kwOnlyArgs, [])
      XCTAssertEqual(d.args.kwOnlyDefaults, [])
      XCTAssertEqual(d.args.kwarg, nil)
      XCTAssertEqual(d.args.start, loc6)
      XCTAssertEqual(d.args.end,   loc6)

      XCTAssertEqual(d.body.count, 1)
      guard d.body.count == 1 else { return }
      XCTAssertStatement(d.body[0], "\"Ratatouille\"")

      XCTAssertStatement(stmt, "(def cook () do: \"Ratatouille\")")
      XCTAssertEqual(stmt.start, loc0)
      XCTAssertEqual(stmt.end,   loc11)
    }
  }

  /// def cook() -> Dish: "Ratatouille"
  func test_noArguments_return() {
    var parser = self.createStmtParser(
      self.token(.def,                   start: loc0, end: loc1),
      self.token(.identifier("cook"),    start: loc2, end: loc3),
      self.token(.leftParen,             start: loc4, end: loc5),
      self.token(.rightParen,            start: loc6, end: loc7),
      self.token(.rightArrow,            start: loc8, end: loc9),
      self.token(.identifier("Dish"),    start: loc10, end: loc11),
      self.token(.colon,                 start: loc12, end: loc13),
      self.token(.string("Ratatouille"), start: loc14, end: loc15)
    )

    if let stmt = self.parseStmt(&parser) {
      guard let d = self.destructFunctionDef(stmt) else { return }

      XCTAssertEqual(d.name, "cook")
      XCTAssertExpression(d.returns, "Dish")

      XCTAssertEqual(d.args.args, [])
      XCTAssertEqual(d.args.defaults, [])
      XCTAssertEqual(d.args.vararg, .none)
      XCTAssertEqual(d.args.kwOnlyArgs, [])
      XCTAssertEqual(d.args.kwOnlyDefaults, [])
      XCTAssertEqual(d.args.kwarg, nil)
      XCTAssertEqual(d.args.start, loc6)
      XCTAssertEqual(d.args.end,   loc6)

      XCTAssertEqual(d.body.count, 1)
      guard d.body.count == 1 else { return }
      XCTAssertStatement(d.body[0], "\"Ratatouille\"")

      XCTAssertStatement(stmt, "(def cook () -> Dish do: \"Ratatouille\")")
      XCTAssertEqual(stmt.start, loc0)
      XCTAssertEqual(stmt.end,   loc15)
    }
  }

  // MARK: - Positional

  /// def cook(zucchini): "Ratatouille"
  func test_positional() {
    var parser = self.createStmtParser(
      self.token(.def,                    start: loc0, end: loc1),
      self.token(.identifier("cook"),     start: loc2, end: loc3),
      self.token(.leftParen,              start: loc4, end: loc5),
      self.token(.identifier("zucchini"), start: loc6, end: loc7),
      self.token(.rightParen,             start: loc8, end: loc9),
      self.token(.colon,                  start: loc10, end: loc11),
      self.token(.string("Ratatouille"),  start: loc12, end: loc13)
    )

    if let stmt = self.parseStmt(&parser) {
      guard let d = self.destructFunctionDef(stmt) else { return }

      XCTAssertEqual(d.name, "cook")
      XCTAssertEqual(d.returns, nil)

      let argA = Arg(name: "zucchini", annotation: nil, start: loc6, end: loc7)
      XCTAssertEqual(d.args.args, [argA])
      XCTAssertEqual(d.args.defaults, [])
      XCTAssertEqual(d.args.vararg, .none)
      XCTAssertEqual(d.args.kwOnlyArgs, [])
      XCTAssertEqual(d.args.kwOnlyDefaults, [])
      XCTAssertEqual(d.args.kwarg, nil)
      XCTAssertEqual(d.args.start, loc6)
      XCTAssertEqual(d.args.end,   loc7)

      XCTAssertEqual(d.body.count, 1)
      guard d.body.count == 1 else { return }
      XCTAssertStatement(d.body[0], "\"Ratatouille\"")

      XCTAssertStatement(stmt, "(def cook (zucchini) do: \"Ratatouille\")")
      XCTAssertEqual(stmt.start, loc0)
      XCTAssertEqual(stmt.end,   loc13)
    }
  }

  /// def cook(zucchini: Vegetable): "Ratatouille"
  func test_positional_withType() {
    var parser = self.createStmtParser(
      self.token(.def,                     start: loc0, end: loc1),
      self.token(.identifier("cook"),      start: loc2, end: loc3),
      self.token(.leftParen,               start: loc4, end: loc5),
      self.token(.identifier("zucchini"),  start: loc6, end: loc7),
      self.token(.colon,                   start: loc8, end: loc9),
      self.token(.identifier("Vegetable"), start: loc10, end: loc11),
      self.token(.rightParen,              start: loc12, end: loc13),
      self.token(.colon,                   start: loc14, end: loc15),
      self.token(.string("Ratatouille"),   start: loc16, end: loc17)
    )

    if let stmt = self.parseStmt(&parser) {
      guard let d = self.destructFunctionDef(stmt) else { return }

      XCTAssertEqual(d.name, "cook")
      XCTAssertEqual(d.returns, nil)

      let annA = Expression(kind: .identifier("Vegetable"), start: loc10, end: loc11)
      let argA = Arg(name: "zucchini", annotation: annA, start: loc6, end: loc11)
      XCTAssertEqual(d.args.args, [argA])
      XCTAssertEqual(d.args.defaults, [])
      XCTAssertEqual(d.args.vararg, .none)
      XCTAssertEqual(d.args.kwOnlyArgs, [])
      XCTAssertEqual(d.args.kwOnlyDefaults, [])
      XCTAssertEqual(d.args.kwarg, nil)
      XCTAssertEqual(d.args.start, loc6)
      XCTAssertEqual(d.args.end,   loc11)

      XCTAssertEqual(d.body.count, 1)
      guard d.body.count == 1 else { return }
      XCTAssertStatement(d.body[0], "\"Ratatouille\"")

      XCTAssertStatement(stmt, "(def cook (zucchini:Vegetable) do: \"Ratatouille\")")
      XCTAssertEqual(stmt.start, loc0)
      XCTAssertEqual(stmt.end,   loc17)
    }
  }

  /// def cook(zucchini = 1): "Ratatouille"
  func test_positional_default() {
    var parser = self.createStmtParser(
      self.token(.def,                    start: loc0, end: loc1),
      self.token(.identifier("cook"),     start: loc2, end: loc3),
      self.token(.leftParen,              start: loc4, end: loc5),
      self.token(.identifier("zucchini"), start: loc6, end: loc7),
      self.token(.equal,                  start: loc8, end: loc9),
      self.token(.float(1.0),             start: loc10, end: loc11),
      self.token(.rightParen,             start: loc12, end: loc13),
      self.token(.colon,                  start: loc14, end: loc15),
      self.token(.string("Ratatouille"),  start: loc16, end: loc17)
    )

    if let stmt = self.parseStmt(&parser) {
      guard let d = self.destructFunctionDef(stmt) else { return }

      XCTAssertEqual(d.name, "cook")
      XCTAssertEqual(d.returns, nil)

      let argA = Arg(name: "zucchini", annotation: nil, start: loc6, end: loc7)
      let defA = Expression(.float(1.0), start: loc10, end: loc11)
      XCTAssertEqual(d.args.args, [argA])
      XCTAssertEqual(d.args.defaults, [defA])
      XCTAssertEqual(d.args.vararg, .none)
      XCTAssertEqual(d.args.kwOnlyArgs, [])
      XCTAssertEqual(d.args.kwOnlyDefaults, [])
      XCTAssertEqual(d.args.kwarg, nil)
      XCTAssertEqual(d.args.start, loc6)
      XCTAssertEqual(d.args.end,   loc11)

      XCTAssertEqual(d.body.count, 1)
      guard d.body.count == 1 else { return }
      XCTAssertStatement(d.body[0], "\"Ratatouille\"")

      XCTAssertStatement(stmt, "(def cook (zucchini=1.0) do: \"Ratatouille\")")
      XCTAssertEqual(stmt.start, loc0)
      XCTAssertEqual(stmt.end,   loc17)
    }
  }

  /// def cook(zucchini, tomato): "Ratatouille"
  func test_positional_multiple() {
    var parser = self.createStmtParser(
      self.token(.def,                    start: loc0, end: loc1),
      self.token(.identifier("cook"),     start: loc2, end: loc3),
      self.token(.leftParen,              start: loc4, end: loc5),
      self.token(.identifier("zucchini"), start: loc6, end: loc7),
      self.token(.comma,                  start: loc8, end: loc9),
      self.token(.identifier("tomato"),   start: loc10, end: loc11),
      self.token(.rightParen,             start: loc12, end: loc13),
      self.token(.colon,                  start: loc14, end: loc15),
      self.token(.string("Ratatouille"),  start: loc16, end: loc17)
    )

    if let stmt = self.parseStmt(&parser) {
      guard let d = self.destructFunctionDef(stmt) else { return }

      XCTAssertEqual(d.name, "cook")
      XCTAssertEqual(d.returns, nil)

      let argA = Arg(name: "zucchini", annotation: nil, start: loc6, end: loc7)
      let argB = Arg(name: "tomato", annotation: nil, start: loc10, end: loc11)
      XCTAssertEqual(d.args.args, [argA, argB])
      XCTAssertEqual(d.args.defaults, [])
      XCTAssertEqual(d.args.vararg, .none)
      XCTAssertEqual(d.args.kwOnlyArgs, [])
      XCTAssertEqual(d.args.kwOnlyDefaults, [])
      XCTAssertEqual(d.args.kwarg, nil)
      XCTAssertEqual(d.args.start, loc6)
      XCTAssertEqual(d.args.end,   loc11)

      XCTAssertEqual(d.body.count, 1)
      guard d.body.count == 1 else { return }
      XCTAssertStatement(d.body[0], "\"Ratatouille\"")

      XCTAssertStatement(stmt, "(def cook (zucchini tomato) do: \"Ratatouille\")")
      XCTAssertEqual(stmt.start, loc0)
      XCTAssertEqual(stmt.end,   loc17)
    }
  }

  /// def cook(zucchini, tomato=1): "Ratatouille"
  func test_positional_default_afterRequired() {
    var parser = self.createStmtParser(
      self.token(.def,                    start: loc0, end: loc1),
      self.token(.identifier("cook"),     start: loc2, end: loc3),
      self.token(.leftParen,              start: loc4, end: loc5),
      self.token(.identifier("zucchini"), start: loc6, end: loc7),
      self.token(.comma,                  start: loc8, end: loc9),
      self.token(.identifier("tomato"),   start: loc10, end: loc11),
      self.token(.equal,                  start: loc12, end: loc13),
      self.token(.float(1.0),             start: loc14, end: loc15),
      self.token(.rightParen,             start: loc16, end: loc17),
      self.token(.colon,                  start: loc18, end: loc19),
      self.token(.string("Ratatouille"),  start: loc20, end: loc21)
    )

    if let stmt = self.parseStmt(&parser) {
      guard let d = self.destructFunctionDef(stmt) else { return }

      XCTAssertEqual(d.name, "cook")
      XCTAssertEqual(d.returns, nil)

      let argA = Arg(name: "zucchini", annotation: nil, start: loc6, end: loc7)
      let argB = Arg(name: "tomato", annotation: nil, start: loc10, end: loc11)
      let defB = Expression(.float(1.0), start: loc14, end: loc15)
      XCTAssertEqual(d.args.args, [argA, argB])
      XCTAssertEqual(d.args.defaults, [defB])
      XCTAssertEqual(d.args.vararg, .none)
      XCTAssertEqual(d.args.kwOnlyArgs, [])
      XCTAssertEqual(d.args.kwOnlyDefaults, [])
      XCTAssertEqual(d.args.kwarg, nil)
      XCTAssertEqual(d.args.start, loc6)
      XCTAssertEqual(d.args.end,   loc15)

      XCTAssertEqual(d.body.count, 1)
      guard d.body.count == 1 else { return }
      XCTAssertStatement(d.body[0], "\"Ratatouille\"")

      XCTAssertStatement(stmt, "(def cook (zucchini tomato=1.0) do: \"Ratatouille\")")
      XCTAssertEqual(stmt.start, loc0)
      XCTAssertEqual(stmt.end,   loc21)
    }
  }

  /// def cook(zucchini = 1, tomato): "Ratatouille"
  func test_positional_requited_afterDefault_throws() {
    var parser = self.createStmtParser(
      self.token(.def,                    start: loc0, end: loc1),
      self.token(.identifier("cook"),     start: loc2, end: loc3),
      self.token(.leftParen,              start: loc4, end: loc5),
      self.token(.identifier("zucchini"), start: loc6, end: loc7),
      self.token(.equal,                  start: loc8, end: loc9),
      self.token(.float(1.0),             start: loc10, end: loc11),
      self.token(.comma,                  start: loc12, end: loc13),
      self.token(.identifier("tomato"),   start: loc14, end: loc15),
      self.token(.rightParen,             start: loc16, end: loc17),
      self.token(.colon,                  start: loc18, end: loc19),
      self.token(.string("Ratatouille"),  start: loc20, end: loc21)
    )

    if let error = self.error(&parser) {
      XCTAssertEqual(error.kind, .defaultAfterNonDefaultArgument)
      XCTAssertEqual(error.location, loc14)
    }
  }

  // MARK: - Variadic

  /// def cook(*zucchini): "Ratatouille"
  func test_varargs() {
    var parser = self.createStmtParser(
      self.token(.def,                    start: loc0, end: loc1),
      self.token(.identifier("cook"),     start: loc2, end: loc3),
      self.token(.leftParen,              start: loc4, end: loc5),
      self.token(.star,                   start: loc6, end: loc7),
      self.token(.identifier("zucchini"), start: loc8, end: loc9),
      self.token(.rightParen,             start: loc10, end: loc11),
      self.token(.colon,                  start: loc12, end: loc13),
      self.token(.string("Ratatouille"),  start: loc14, end: loc15)
    )

    if let stmt = self.parseStmt(&parser) {
      guard let d = self.destructFunctionDef(stmt) else { return }

      XCTAssertEqual(d.name, "cook")
      XCTAssertEqual(d.returns, nil)

      let varargA = Arg(name: "zucchini", annotation: nil, start: loc8, end: loc9)
      XCTAssertEqual(d.args.args, [])
      XCTAssertEqual(d.args.defaults, [])
      XCTAssertEqual(d.args.vararg, .named(varargA))
      XCTAssertEqual(d.args.kwOnlyArgs, [])
      XCTAssertEqual(d.args.kwOnlyDefaults, [])
      XCTAssertEqual(d.args.kwarg, nil)
      XCTAssertEqual(d.args.start, loc6)
      XCTAssertEqual(d.args.end,   loc9)

      XCTAssertEqual(d.body.count, 1)
      guard d.body.count == 1 else { return }
      XCTAssertStatement(d.body[0], "\"Ratatouille\"")

      XCTAssertStatement(stmt, "(def cook (*zucchini) do: \"Ratatouille\")")
      XCTAssertEqual(stmt.start, loc0)
      XCTAssertEqual(stmt.end,   loc15)
    }
  }

  /// def cook(*zucchini, tomato=1): "Ratatouille"
  func test_varargs_keywordOnly_withDefault() {
    var parser = self.createStmtParser(
      self.token(.def,                    start: loc0, end: loc1),
      self.token(.identifier("cook"),     start: loc2, end: loc3),
      self.token(.leftParen,              start: loc4, end: loc5),
      self.token(.star,                   start: loc6, end: loc7),
      self.token(.identifier("zucchini"), start: loc8, end: loc9),
      self.token(.comma,                  start: loc10, end: loc11),
      self.token(.identifier("tomato"),   start: loc12, end: loc13),
      self.token(.equal,                  start: loc14, end: loc15),
      self.token(.float(1.0),             start: loc16, end: loc17),
      self.token(.rightParen,             start: loc18, end: loc19),
      self.token(.colon,                  start: loc20, end: loc21),
      self.token(.string("Ratatouille"),  start: loc22, end: loc23)
    )

    if let stmt = self.parseStmt(&parser) {
      guard let d = self.destructFunctionDef(stmt) else { return }

      XCTAssertEqual(d.name, "cook")
      XCTAssertEqual(d.returns, nil)

      let varargA = Arg(name: "zucchini", annotation: nil, start: loc8, end: loc9)
      let kwB     = Arg(name: "tomato", annotation: nil, start: loc12, end: loc13)
      let kwDefB  = Expression(.float(1), start: loc16, end: loc17)
      XCTAssertEqual(d.args.args, [])
      XCTAssertEqual(d.args.defaults, [])
      XCTAssertEqual(d.args.vararg, .named(varargA))
      XCTAssertEqual(d.args.kwOnlyArgs, [kwB])
      XCTAssertEqual(d.args.kwOnlyDefaults, [kwDefB])
      XCTAssertEqual(d.args.kwarg, nil)
      XCTAssertEqual(d.args.start, loc6)
      XCTAssertEqual(d.args.end,   loc17)

      XCTAssertEqual(d.body.count, 1)
      guard d.body.count == 1 else { return }
      XCTAssertStatement(d.body[0], "\"Ratatouille\"")

      XCTAssertStatement(stmt, "(def cook (*zucchini tomato=1.0) do: \"Ratatouille\")")
      XCTAssertEqual(stmt.start, loc0)
      XCTAssertEqual(stmt.end,   loc23)
    }
  }

  /// def cook(*zucchini, tomato): "Ratatouille"
  func test_varargs_keywordOnly_withoutDefault_isImplicitNone() {
    var parser = self.createStmtParser(
      self.token(.def,                    start: loc0, end: loc1),
      self.token(.identifier("cook"),     start: loc2, end: loc3),
      self.token(.leftParen,              start: loc4, end: loc5),
      self.token(.star,                   start: loc6, end: loc7),
      self.token(.identifier("zucchini"), start: loc8, end: loc9),
      self.token(.comma,                  start: loc10, end: loc11),
      self.token(.identifier("tomato"),   start: loc12, end: loc13),
      self.token(.rightParen,             start: loc14, end: loc15),
      self.token(.colon,                  start: loc16, end: loc17),
      self.token(.string("Ratatouille"),  start: loc18, end: loc19)
    )

    if let stmt = self.parseStmt(&parser) {
      guard let d = self.destructFunctionDef(stmt) else { return }

      XCTAssertEqual(d.name, "cook")
      XCTAssertEqual(d.returns, nil)

      let varargA = Arg(name: "zucchini", annotation: nil, start: loc8, end: loc9)
      let kwB     = Arg(name: "tomato", annotation: nil, start: loc12, end: loc13)
      let kwDefB = Expression(.none, start: loc13, end: loc13)
      XCTAssertEqual(d.args.args, [])
      XCTAssertEqual(d.args.defaults, [])
      XCTAssertEqual(d.args.vararg, .named(varargA))
      XCTAssertEqual(d.args.kwOnlyArgs, [kwB])
      XCTAssertEqual(d.args.kwOnlyDefaults, [kwDefB])
      XCTAssertEqual(d.args.kwarg, nil)
      XCTAssertEqual(d.args.start, loc6)
      XCTAssertEqual(d.args.end,   loc13)

      XCTAssertEqual(d.body.count, 1)
      guard d.body.count == 1 else { return }
      XCTAssertStatement(d.body[0], "\"Ratatouille\"")

      XCTAssertStatement(stmt, "(def cook (*zucchini tomato=None) do: \"Ratatouille\")")
      XCTAssertEqual(stmt.start, loc0)
      XCTAssertEqual(stmt.end,   loc19)
    }
  }

  /// def cook(*zucchini, *tomato): "Ratatouille"
  func test_varargs_duplicate_throws() {
    var parser = self.createStmtParser(
      self.token(.def,                    start: loc0, end: loc1),
      self.token(.identifier("cook"),     start: loc2, end: loc3),
      self.token(.leftParen,              start: loc4, end: loc5),
      self.token(.star,                   start: loc6, end: loc7),
      self.token(.identifier("zucchini"), start: loc8, end: loc9),
      self.token(.comma,                  start: loc10, end: loc11),
      self.token(.star,                   start: loc12, end: loc13),
      self.token(.identifier("tomato"),   start: loc14, end: loc15),
      self.token(.rightParen,             start: loc16, end: loc17),
      self.token(.colon,                  start: loc18, end: loc19),
      self.token(.string("Ratatouille"),  start: loc20, end: loc21)
    )

    if let error = self.error(&parser) {
      XCTAssertEqual(error.kind, .duplicateVarargs)
      XCTAssertEqual(error.location, loc12)
    }
  }

  /// def cook(*, zucchini): "Ratatouille"
  func test_varargsUnnamed() {
    var parser = self.createStmtParser(
      self.token(.def,                    start: loc0, end: loc1),
      self.token(.identifier("cook"),     start: loc2, end: loc3),
      self.token(.leftParen,              start: loc4, end: loc5),
      self.token(.star,                   start: loc6, end: loc7),
      self.token(.comma,                  start: loc8, end: loc9),
      self.token(.identifier("zucchini"), start: loc10, end: loc11),
      self.token(.rightParen,             start: loc12, end: loc13),
      self.token(.colon,                  start: loc14, end: loc15),
      self.token(.string("Ratatouille"),  start: loc16, end: loc17)
    )

    if let stmt = self.parseStmt(&parser) {
      guard let d = self.destructFunctionDef(stmt) else { return }

      XCTAssertEqual(d.name, "cook")
      XCTAssertEqual(d.returns, nil)

      let kwA = Arg(name: "zucchini", annotation: nil, start: loc10, end: loc11)
      let kwDefA = Expression(.none, start: loc11, end: loc11)
      XCTAssertEqual(d.args.args, [])
      XCTAssertEqual(d.args.defaults, [])
      XCTAssertEqual(d.args.vararg, .unnamed)
      XCTAssertEqual(d.args.kwOnlyArgs, [kwA])
      XCTAssertEqual(d.args.kwOnlyDefaults, [kwDefA])
      XCTAssertEqual(d.args.kwarg, nil)
      XCTAssertEqual(d.args.start, loc6)
      XCTAssertEqual(d.args.end,   loc11)

      XCTAssertEqual(d.body.count, 1)
      guard d.body.count == 1 else { return }
      XCTAssertStatement(d.body[0], "\"Ratatouille\"")

      XCTAssertStatement(stmt, "(def cook (* zucchini=None) do: \"Ratatouille\")")
      XCTAssertEqual(stmt.start, loc0)
      XCTAssertEqual(stmt.end,   loc17)
    }
  }

  /// def cook(*): "Ratatouille"
  func test_varargsUnnamed_withoutFollowingArguments_throws() {
    var parser = self.createStmtParser(
      self.token(.def,                    start: loc0, end: loc1),
      self.token(.identifier("cook"),     start: loc2, end: loc3),
      self.token(.leftParen,              start: loc4, end: loc5),
      self.token(.star,                   start: loc6, end: loc7),
      self.token(.rightParen,             start: loc8, end: loc9),
      self.token(.colon,                  start: loc10, end: loc11),
      self.token(.string("Ratatouille"),  start: loc12, end: loc13)
    )

    if let error = self.error(&parser) {
      XCTAssertEqual(error.kind, .starWithoutFollowingArguments)
      XCTAssertEqual(error.location, loc8)
    }
  }

  // MARK: - Kwargs

  /// def cook(**zucchini): "Ratatouille"
  func test_kwargs() {
    var parser = self.createStmtParser(
      self.token(.def,                    start: loc0, end: loc1),
      self.token(.identifier("cook"),     start: loc2, end: loc3),
      self.token(.leftParen,              start: loc4, end: loc5),
      self.token(.starStar,               start: loc6, end: loc7),
      self.token(.identifier("zucchini"), start: loc8, end: loc9),
      self.token(.rightParen,             start: loc10, end: loc11),
      self.token(.colon,                  start: loc12, end: loc13),
      self.token(.string("Ratatouille"),  start: loc14, end: loc15)
    )

    if let stmt = self.parseStmt(&parser) {
      guard let d = self.destructFunctionDef(stmt) else { return }

      XCTAssertEqual(d.name, "cook")
      XCTAssertEqual(d.returns, nil)

      let kwargA = Arg(name: "zucchini", annotation: nil, start: loc8, end: loc9)
      XCTAssertEqual(d.args.args, [])
      XCTAssertEqual(d.args.defaults, [])
      XCTAssertEqual(d.args.vararg, .none)
      XCTAssertEqual(d.args.kwOnlyArgs, [])
      XCTAssertEqual(d.args.kwOnlyDefaults, [])
      XCTAssertEqual(d.args.kwarg, kwargA)
      XCTAssertEqual(d.args.start, loc6)
      XCTAssertEqual(d.args.end,   loc9)

      XCTAssertEqual(d.body.count, 1)
      guard d.body.count == 1 else { return }
      XCTAssertStatement(d.body[0], "\"Ratatouille\"")

      XCTAssertStatement(stmt, "(def cook (**zucchini) do: \"Ratatouille\")")
      XCTAssertEqual(stmt.start, loc0)
      XCTAssertEqual(stmt.end,   loc15)
    }
  }

  /// def cook(**zucchini,): "Ratatouille"
  func test_kwargs_withCommaAfter() {
    var parser = self.createStmtParser(
      self.token(.def,                    start: loc0, end: loc1),
      self.token(.identifier("cook"),     start: loc2, end: loc3),
      self.token(.leftParen,              start: loc4, end: loc5),
      self.token(.starStar,               start: loc6, end: loc7),
      self.token(.identifier("zucchini"), start: loc8, end: loc9),
      self.token(.comma,                  start: loc10, end: loc11),
      self.token(.rightParen,             start: loc12, end: loc13),
      self.token(.colon,                  start: loc14, end: loc15),
      self.token(.string("Ratatouille"),  start: loc16, end: loc17)
    )

    if let stmt = self.parseStmt(&parser) {
      guard let d = self.destructFunctionDef(stmt) else { return }

      XCTAssertEqual(d.name, "cook")
      XCTAssertEqual(d.returns, nil)

      let kwargA = Arg(name: "zucchini", annotation: nil, start: loc8, end: loc9)
      XCTAssertEqual(d.args.args, [])
      XCTAssertEqual(d.args.defaults, [])
      XCTAssertEqual(d.args.vararg, .none)
      XCTAssertEqual(d.args.kwOnlyArgs, [])
      XCTAssertEqual(d.args.kwOnlyDefaults, [])
      XCTAssertEqual(d.args.kwarg, kwargA)
      XCTAssertEqual(d.args.start, loc6)
      XCTAssertEqual(d.args.end,   loc11)

      XCTAssertEqual(d.body.count, 1)
      guard d.body.count == 1 else { return }
      XCTAssertStatement(d.body[0], "\"Ratatouille\"")

      XCTAssertStatement(stmt, "(def cook (**zucchini) do: \"Ratatouille\")")
      XCTAssertEqual(stmt.start, loc0)
      XCTAssertEqual(stmt.end,   loc17)
    }
  }

  /// def cook(**zucchini, **tomato): "Ratatouille"
  func test_kwargs_duplicate_throws() {
    var parser = self.createStmtParser(
      self.token(.def,                    start: loc0, end: loc1),
      self.token(.identifier("cook"),     start: loc2, end: loc3),
      self.token(.leftParen,              start: loc4, end: loc5),
      self.token(.starStar,               start: loc6, end: loc7),
      self.token(.identifier("zucchini"), start: loc8, end: loc9),
      self.token(.comma,                  start: loc10, end: loc11),
      self.token(.starStar,               start: loc12, end: loc13),
      self.token(.identifier("tomato"),   start: loc14, end: loc15),
      self.token(.rightParen,             start: loc16, end: loc17),
      self.token(.colon,                  start: loc18, end: loc19),
      self.token(.string("Ratatouille"),  start: loc20, end: loc21)
    )

    if let error = self.error(&parser) {
      XCTAssertEqual(error.kind, .duplicateKwargs)
      XCTAssertEqual(error.location, loc12)
    }
  }

  // MARK: - All

  /// def cook(zucchini, *tomato, pepper, **eggplant): "Ratatouille"
  func test_all() {
    var parser = self.createStmtParser(
      self.token(.def,                    start: loc0, end: loc1),
      self.token(.identifier("cook"),     start: loc2, end: loc3),
      self.token(.leftParen,              start: loc4, end: loc5),
      self.token(.identifier("zucchini"), start: loc6, end: loc7),
      self.token(.comma,                  start: loc8, end: loc9),
      self.token(.star,                   start: loc10, end: loc11),
      self.token(.identifier("tomato"),   start: loc12, end: loc13),
      self.token(.comma,                  start: loc14, end: loc15),
      self.token(.identifier("pepper"),   start: loc16, end: loc17),
      self.token(.comma,                  start: loc18, end: loc19),
      self.token(.starStar,               start: loc20, end: loc21),
      self.token(.identifier("eggplant"), start: loc22, end: loc23),
      self.token(.rightParen,             start: loc24, end: loc25),
      self.token(.colon,                  start: loc26, end: loc27),
      self.token(.string("Ratatouille"),  start: loc28, end: loc29)
    )

    if let stmt = self.parseStmt(&parser) {
      guard let d = self.destructFunctionDef(stmt) else { return }

      XCTAssertEqual(d.name, "cook")
      XCTAssertEqual(d.returns, nil)

      let argA    = Arg(name: "zucchini", annotation: nil, start: loc6, end: loc7)
      let varargB = Arg(name: "tomato", annotation: nil, start: loc12, end: loc13)
      let kwC     = Arg(name: "pepper", annotation: nil, start: loc16, end: loc17)
      let kwDefC  = Expression(.none, start: loc17, end: loc17)
      let kwargD = Arg(name: "eggplant", annotation: nil, start: loc22, end: loc23)
      XCTAssertEqual(d.args.args, [argA])
      XCTAssertEqual(d.args.defaults, [])
      XCTAssertEqual(d.args.vararg, .named(varargB))
      XCTAssertEqual(d.args.kwOnlyArgs, [kwC])
      XCTAssertEqual(d.args.kwOnlyDefaults, [kwDefC])
      XCTAssertEqual(d.args.kwarg, kwargD)
      XCTAssertEqual(d.args.start, loc6)
      XCTAssertEqual(d.args.end,   loc23)

      XCTAssertEqual(d.body.count, 1)
      guard d.body.count == 1 else { return }
      XCTAssertStatement(d.body[0], "\"Ratatouille\"")

      XCTAssertStatement(stmt, "(def cook (zucchini *tomato pepper=None **eggplant) do: \"Ratatouille\")")
      XCTAssertEqual(stmt.start, loc0)
      XCTAssertEqual(stmt.end,   loc29)
    }
  }
}
