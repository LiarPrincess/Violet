import XCTest
import VioletCore
import VioletLexer
@testable import VioletParser

// swiftlint:disable file_length
// swiftlint:disable function_body_length
// swiftformat:disable consecutiveSpaces

class ParseFunctionDef: XCTestCase {

  // MARK: - No arguments

  /// def cook(): "Ratatouille"
  func test_noArguments() {
    let parser = createStmtParser(
      createToken(.def,                   start: loc0, end: loc1),
      createToken(.identifier("cook"),    start: loc2, end: loc3),
      createToken(.leftParen,             start: loc4, end: loc5),
      createToken(.rightParen,            start: loc6, end: loc7),
      createToken(.colon,                 start: loc8, end: loc9),
      createToken(.string("Ratatouille"), start: loc10, end: loc11)
    )

    guard let ast = parse(parser) else { return }

    XCTAssertAST(ast, """
    ModuleAST(start: 0:0, end: 11:16)
      FunctionDefStmt(start: 0:0, end: 11:16)
        Name: cook
        Args
          Arguments(start: 6:6, end: 6:6)
            Args: none
            PosOnlyArgCount: 0
            Defaults: none
            Vararg: none
            KwOnlyArgs: none
            KwOnlyDefaults: none
            Kwarg: none
        Body
          ExprStmt(start: 10:10, end: 11:16)
            StringExpr(context: Load, start: 10:10, end: 11:16)
              String: 'Ratatouille'
        Decorators: none
        Returns: none
    """)
  }

  /// def cook() -> Dish: "Ratatouille"
  func test_noArguments_return() {
    let parser = createStmtParser(
      createToken(.def,                   start: loc0, end: loc1),
      createToken(.identifier("cook"),    start: loc2, end: loc3),
      createToken(.leftParen,             start: loc4, end: loc5),
      createToken(.rightParen,            start: loc6, end: loc7),
      createToken(.rightArrow,            start: loc8, end: loc9),
      createToken(.identifier("Dish"),    start: loc10, end: loc11),
      createToken(.colon,                 start: loc12, end: loc13),
      createToken(.string("Ratatouille"), start: loc14, end: loc15)
    )

    guard let ast = parse(parser) else { return }

    XCTAssertAST(ast, """
    ModuleAST(start: 0:0, end: 15:20)
      FunctionDefStmt(start: 0:0, end: 15:20)
        Name: cook
        Args
          Arguments(start: 6:6, end: 6:6)
            Args: none
            PosOnlyArgCount: 0
            Defaults: none
            Vararg: none
            KwOnlyArgs: none
            KwOnlyDefaults: none
            Kwarg: none
        Body
          ExprStmt(start: 14:14, end: 15:20)
            StringExpr(context: Load, start: 14:14, end: 15:20)
              String: 'Ratatouille'
        Decorators: none
        Returns
          IdentifierExpr(context: Load, start: 10:10, end: 11:16)
            Value: Dish
    """)
  }

  // MARK: - Positional

  /// def cook(zucchini): "Ratatouille"
  func test_positional() {
    let parser = createStmtParser(
      createToken(.def,                    start: loc0, end: loc1),
      createToken(.identifier("cook"),     start: loc2, end: loc3),
      createToken(.leftParen,              start: loc4, end: loc5),
      createToken(.identifier("zucchini"), start: loc6, end: loc7),
      createToken(.rightParen,             start: loc8, end: loc9),
      createToken(.colon,                  start: loc10, end: loc11),
      createToken(.string("Ratatouille"),  start: loc12, end: loc13)
    )

    guard let ast = parse(parser) else { return }

    XCTAssertAST(ast, """
    ModuleAST(start: 0:0, end: 13:18)
      FunctionDefStmt(start: 0:0, end: 13:18)
        Name: cook
        Args
          Arguments(start: 6:6, end: 7:12)
            Args
              Arg
                Name: zucchini
                Annotation: none
            PosOnlyArgCount: 0
            Defaults: none
            Vararg: none
            KwOnlyArgs: none
            KwOnlyDefaults: none
            Kwarg: none
        Body
          ExprStmt(start: 12:12, end: 13:18)
            StringExpr(context: Load, start: 12:12, end: 13:18)
              String: 'Ratatouille'
        Decorators: none
        Returns: none
    """)
  }

  /// def cook(zucchini: Vegetable): "Ratatouille"
  func test_positional_withType() {
    let parser = createStmtParser(
      createToken(.def,                     start: loc0, end: loc1),
      createToken(.identifier("cook"),      start: loc2, end: loc3),
      createToken(.leftParen,               start: loc4, end: loc5),
      createToken(.identifier("zucchini"),  start: loc6, end: loc7),
      createToken(.colon,                   start: loc8, end: loc9),
      createToken(.identifier("Vegetable"), start: loc10, end: loc11),
      createToken(.rightParen,              start: loc12, end: loc13),
      createToken(.colon,                   start: loc14, end: loc15),
      createToken(.string("Ratatouille"),   start: loc16, end: loc17)
    )

    guard let ast = parse(parser) else { return }

    XCTAssertAST(ast, """
    ModuleAST(start: 0:0, end: 17:22)
      FunctionDefStmt(start: 0:0, end: 17:22)
        Name: cook
        Args
          Arguments(start: 6:6, end: 11:16)
            Args
              Arg
                Name: zucchini
                Annotation
                  IdentifierExpr(context: Load, start: 10:10, end: 11:16)
                    Value: Vegetable
            PosOnlyArgCount: 0
            Defaults: none
            Vararg: none
            KwOnlyArgs: none
            KwOnlyDefaults: none
            Kwarg: none
        Body
          ExprStmt(start: 16:16, end: 17:22)
            StringExpr(context: Load, start: 16:16, end: 17:22)
              String: 'Ratatouille'
        Decorators: none
        Returns: none
    """)
  }

  /// def cook(zucchini = 1): "Ratatouille"
  func test_positional_default() {
    let parser = createStmtParser(
      createToken(.def,                    start: loc0, end: loc1),
      createToken(.identifier("cook"),     start: loc2, end: loc3),
      createToken(.leftParen,              start: loc4, end: loc5),
      createToken(.identifier("zucchini"), start: loc6, end: loc7),
      createToken(.equal,                  start: loc8, end: loc9),
      createToken(.float(1.0),             start: loc10, end: loc11),
      createToken(.rightParen,             start: loc12, end: loc13),
      createToken(.colon,                  start: loc14, end: loc15),
      createToken(.string("Ratatouille"),  start: loc16, end: loc17)
    )

    guard let ast = parse(parser) else { return }

    XCTAssertAST(ast, """
    ModuleAST(start: 0:0, end: 17:22)
      FunctionDefStmt(start: 0:0, end: 17:22)
        Name: cook
        Args
          Arguments(start: 6:6, end: 11:16)
            Args
              Arg
                Name: zucchini
                Annotation: none
            PosOnlyArgCount: 0
            Defaults
              FloatExpr(context: Load, start: 10:10, end: 11:16)
                Value: 1.0
            Vararg: none
            KwOnlyArgs: none
            KwOnlyDefaults: none
            Kwarg: none
        Body
          ExprStmt(start: 16:16, end: 17:22)
            StringExpr(context: Load, start: 16:16, end: 17:22)
              String: 'Ratatouille'
        Decorators: none
        Returns: none
    """)
  }

  /// def cook(zucchini, tomato): "Ratatouille"
  func test_positional_multiple() {
    let parser = createStmtParser(
      createToken(.def,                    start: loc0, end: loc1),
      createToken(.identifier("cook"),     start: loc2, end: loc3),
      createToken(.leftParen,              start: loc4, end: loc5),
      createToken(.identifier("zucchini"), start: loc6, end: loc7),
      createToken(.comma,                  start: loc8, end: loc9),
      createToken(.identifier("tomato"),   start: loc10, end: loc11),
      createToken(.rightParen,             start: loc12, end: loc13),
      createToken(.colon,                  start: loc14, end: loc15),
      createToken(.string("Ratatouille"),  start: loc16, end: loc17)
    )

    guard let ast = parse(parser) else { return }

    XCTAssertAST(ast, """
    ModuleAST(start: 0:0, end: 17:22)
      FunctionDefStmt(start: 0:0, end: 17:22)
        Name: cook
        Args
          Arguments(start: 6:6, end: 11:16)
            Args
              Arg
                Name: zucchini
                Annotation: none
              Arg
                Name: tomato
                Annotation: none
            PosOnlyArgCount: 0
            Defaults: none
            Vararg: none
            KwOnlyArgs: none
            KwOnlyDefaults: none
            Kwarg: none
        Body
          ExprStmt(start: 16:16, end: 17:22)
            StringExpr(context: Load, start: 16:16, end: 17:22)
              String: 'Ratatouille'
        Decorators: none
        Returns: none
    """)
  }

  /// def cook(zucchini, tomato=1): "Ratatouille"
  func test_positional_default_afterRequired() {
    let parser = createStmtParser(
      createToken(.def,                    start: loc0, end: loc1),
      createToken(.identifier("cook"),     start: loc2, end: loc3),
      createToken(.leftParen,              start: loc4, end: loc5),
      createToken(.identifier("zucchini"), start: loc6, end: loc7),
      createToken(.comma,                  start: loc8, end: loc9),
      createToken(.identifier("tomato"),   start: loc10, end: loc11),
      createToken(.equal,                  start: loc12, end: loc13),
      createToken(.float(1.0),             start: loc14, end: loc15),
      createToken(.rightParen,             start: loc16, end: loc17),
      createToken(.colon,                  start: loc18, end: loc19),
      createToken(.string("Ratatouille"),  start: loc20, end: loc21)
    )

    guard let ast = parse(parser) else { return }

    XCTAssertAST(ast, """
    ModuleAST(start: 0:0, end: 21:26)
      FunctionDefStmt(start: 0:0, end: 21:26)
        Name: cook
        Args
          Arguments(start: 6:6, end: 15:20)
            Args
              Arg
                Name: zucchini
                Annotation: none
              Arg
                Name: tomato
                Annotation: none
            PosOnlyArgCount: 0
            Defaults
              FloatExpr(context: Load, start: 14:14, end: 15:20)
                Value: 1.0
            Vararg: none
            KwOnlyArgs: none
            KwOnlyDefaults: none
            Kwarg: none
        Body
          ExprStmt(start: 20:20, end: 21:26)
            StringExpr(context: Load, start: 20:20, end: 21:26)
              String: 'Ratatouille'
        Decorators: none
        Returns: none
    """)
  }

  /// def cook(zucchini = 1, tomato): "Ratatouille"
  func test_positional_requited_afterDefault_throws() {
    let parser = createStmtParser(
      createToken(.def,                    start: loc0, end: loc1),
      createToken(.identifier("cook"),     start: loc2, end: loc3),
      createToken(.leftParen,              start: loc4, end: loc5),
      createToken(.identifier("zucchini"), start: loc6, end: loc7),
      createToken(.equal,                  start: loc8, end: loc9),
      createToken(.float(1.0),             start: loc10, end: loc11),
      createToken(.comma,                  start: loc12, end: loc13),
      createToken(.identifier("tomato"),   start: loc14, end: loc15),
      createToken(.rightParen,             start: loc16, end: loc17),
      createToken(.colon,                  start: loc18, end: loc19),
      createToken(.string("Ratatouille"),  start: loc20, end: loc21)
    )

    if let error = parseError(parser) {
      XCTAssertEqual(error.kind, .defaultAfterNonDefaultArgument)
      XCTAssertEqual(error.location, loc14)
    }
  }

  // MARK: - Positional only

  /// def cook(zucchini, / , tomato): "Ratatouille"
  func test_positionalOnly() {
    let parser = createStmtParser(
      createToken(.def,                    start: loc0, end: loc1),
      createToken(.identifier("cook"),     start: loc2, end: loc3),
      createToken(.leftParen,              start: loc4, end: loc5),
      createToken(.identifier("zucchini"), start: loc6, end: loc7),
      createToken(.comma,                  start: loc8, end: loc9),
      createToken(.slash,                  start: loc10, end: loc11),
      createToken(.comma,                  start: loc12, end: loc13),
      createToken(.identifier("tomato"),   start: loc14, end: loc15),
      createToken(.rightParen,             start: loc16, end: loc17),
      createToken(.colon,                  start: loc18, end: loc19),
      createToken(.string("Ratatouille"),  start: loc20, end: loc21)
    )

    guard let ast = parse(parser) else { return }

    XCTAssertAST(ast, """
    ModuleAST(start: 0:0, end: 21:26)
      FunctionDefStmt(start: 0:0, end: 21:26)
        Name: cook
        Args
          Arguments(start: 6:6, end: 15:20)
            Args
              Arg
                Name: zucchini
                Annotation: none
              Arg
                Name: tomato
                Annotation: none
            PosOnlyArgCount: 1
            Defaults: none
            Vararg: none
            KwOnlyArgs: none
            KwOnlyDefaults: none
            Kwarg: none
        Body
          ExprStmt(start: 20:20, end: 21:26)
            StringExpr(context: Load, start: 20:20, end: 21:26)
              String: 'Ratatouille'
        Decorators: none
        Returns: none
    """)
  }

  // MARK: - Variadic

  /// def cook(*zucchini): "Ratatouille"
  func test_varargs() {
    let parser = createStmtParser(
      createToken(.def,                    start: loc0, end: loc1),
      createToken(.identifier("cook"),     start: loc2, end: loc3),
      createToken(.leftParen,              start: loc4, end: loc5),
      createToken(.star,                   start: loc6, end: loc7),
      createToken(.identifier("zucchini"), start: loc8, end: loc9),
      createToken(.rightParen,             start: loc10, end: loc11),
      createToken(.colon,                  start: loc12, end: loc13),
      createToken(.string("Ratatouille"),  start: loc14, end: loc15)
    )

    guard let ast = parse(parser) else { return }

    XCTAssertAST(ast, """
    ModuleAST(start: 0:0, end: 15:20)
      FunctionDefStmt(start: 0:0, end: 15:20)
        Name: cook
        Args
          Arguments(start: 6:6, end: 9:14)
            Args: none
            PosOnlyArgCount: 0
            Defaults: none
            Vararg
              Named
                Arg
                  Name: zucchini
                  Annotation: none
            KwOnlyArgs: none
            KwOnlyDefaults: none
            Kwarg: none
        Body
          ExprStmt(start: 14:14, end: 15:20)
            StringExpr(context: Load, start: 14:14, end: 15:20)
              String: 'Ratatouille'
        Decorators: none
        Returns: none
    """)
  }

  /// def cook(*zucchini, tomato=1): "Ratatouille"
  func test_varargs_keywordOnly_withDefault() {
    let parser = createStmtParser(
      createToken(.def,                    start: loc0, end: loc1),
      createToken(.identifier("cook"),     start: loc2, end: loc3),
      createToken(.leftParen,              start: loc4, end: loc5),
      createToken(.star,                   start: loc6, end: loc7),
      createToken(.identifier("zucchini"), start: loc8, end: loc9),
      createToken(.comma,                  start: loc10, end: loc11),
      createToken(.identifier("tomato"),   start: loc12, end: loc13),
      createToken(.equal,                  start: loc14, end: loc15),
      createToken(.float(1.0),             start: loc16, end: loc17),
      createToken(.rightParen,             start: loc18, end: loc19),
      createToken(.colon,                  start: loc20, end: loc21),
      createToken(.string("Ratatouille"),  start: loc22, end: loc23)
    )

    guard let ast = parse(parser) else { return }

    XCTAssertAST(ast, """
    ModuleAST(start: 0:0, end: 23:28)
      FunctionDefStmt(start: 0:0, end: 23:28)
        Name: cook
        Args
          Arguments(start: 6:6, end: 17:22)
            Args: none
            PosOnlyArgCount: 0
            Defaults: none
            Vararg
              Named
                Arg
                  Name: zucchini
                  Annotation: none
            KwOnlyArgs
              Arg
                Name: tomato
                Annotation: none
            KwOnlyDefaults
              FloatExpr(context: Load, start: 16:16, end: 17:22)
                Value: 1.0
            Kwarg: none
        Body
          ExprStmt(start: 22:22, end: 23:28)
            StringExpr(context: Load, start: 22:22, end: 23:28)
              String: 'Ratatouille'
        Decorators: none
        Returns: none
    """)
  }

  /// def cook(*zucchini, tomato): "Ratatouille"
  func test_varargs_keywordOnly_withoutDefault_isImplicitNone() {
    let parser = createStmtParser(
      createToken(.def,                    start: loc0, end: loc1),
      createToken(.identifier("cook"),     start: loc2, end: loc3),
      createToken(.leftParen,              start: loc4, end: loc5),
      createToken(.star,                   start: loc6, end: loc7),
      createToken(.identifier("zucchini"), start: loc8, end: loc9),
      createToken(.comma,                  start: loc10, end: loc11),
      createToken(.identifier("tomato"),   start: loc12, end: loc13),
      createToken(.rightParen,             start: loc14, end: loc15),
      createToken(.colon,                  start: loc16, end: loc17),
      createToken(.string("Ratatouille"),  start: loc18, end: loc19)
    )

    guard let ast = parse(parser) else { return }

    XCTAssertAST(ast, """
    ModuleAST(start: 0:0, end: 19:24)
      FunctionDefStmt(start: 0:0, end: 19:24)
        Name: cook
        Args
          Arguments(start: 6:6, end: 13:18)
            Args: none
            PosOnlyArgCount: 0
            Defaults: none
            Vararg
              Named
                Arg
                  Name: zucchini
                  Annotation: none
            KwOnlyArgs
              Arg
                Name: tomato
                Annotation: none
            KwOnlyDefaults
              NoneExpr(context: Load, start: 13:18, end: 13:18)
            Kwarg: none
        Body
          ExprStmt(start: 18:18, end: 19:24)
            StringExpr(context: Load, start: 18:18, end: 19:24)
              String: 'Ratatouille'
        Decorators: none
        Returns: none
    """)
  }

  /// def cook(*zucchini, *tomato): "Ratatouille"
  func test_varargs_duplicate_throws() {
    let parser = createStmtParser(
      createToken(.def,                    start: loc0, end: loc1),
      createToken(.identifier("cook"),     start: loc2, end: loc3),
      createToken(.leftParen,              start: loc4, end: loc5),
      createToken(.star,                   start: loc6, end: loc7),
      createToken(.identifier("zucchini"), start: loc8, end: loc9),
      createToken(.comma,                  start: loc10, end: loc11),
      createToken(.star,                   start: loc12, end: loc13),
      createToken(.identifier("tomato"),   start: loc14, end: loc15),
      createToken(.rightParen,             start: loc16, end: loc17),
      createToken(.colon,                  start: loc18, end: loc19),
      createToken(.string("Ratatouille"),  start: loc20, end: loc21)
    )

    if let error = parseError(parser) {
      XCTAssertEqual(error.kind, .duplicateVarargs)
      XCTAssertEqual(error.location, loc12)
    }
  }

  /// def cook(*, zucchini): "Ratatouille"
  func test_varargsUnnamed() {
    let parser = createStmtParser(
      createToken(.def,                    start: loc0, end: loc1),
      createToken(.identifier("cook"),     start: loc2, end: loc3),
      createToken(.leftParen,              start: loc4, end: loc5),
      createToken(.star,                   start: loc6, end: loc7),
      createToken(.comma,                  start: loc8, end: loc9),
      createToken(.identifier("zucchini"), start: loc10, end: loc11),
      createToken(.rightParen,             start: loc12, end: loc13),
      createToken(.colon,                  start: loc14, end: loc15),
      createToken(.string("Ratatouille"),  start: loc16, end: loc17)
    )

    guard let ast = parse(parser) else { return }

    XCTAssertAST(ast, """
    ModuleAST(start: 0:0, end: 17:22)
      FunctionDefStmt(start: 0:0, end: 17:22)
        Name: cook
        Args
          Arguments(start: 6:6, end: 11:16)
            Args: none
            PosOnlyArgCount: 0
            Defaults: none
            Vararg: unnamed
            KwOnlyArgs
              Arg
                Name: zucchini
                Annotation: none
            KwOnlyDefaults
              NoneExpr(context: Load, start: 11:16, end: 11:16)
            Kwarg: none
        Body
          ExprStmt(start: 16:16, end: 17:22)
            StringExpr(context: Load, start: 16:16, end: 17:22)
              String: 'Ratatouille'
        Decorators: none
        Returns: none
    """)
  }

  /// def cook(*): "Ratatouille"
  func test_varargsUnnamed_withoutFollowingArguments_throws() {
    let parser = createStmtParser(
      createToken(.def,                    start: loc0, end: loc1),
      createToken(.identifier("cook"),     start: loc2, end: loc3),
      createToken(.leftParen,              start: loc4, end: loc5),
      createToken(.star,                   start: loc6, end: loc7),
      createToken(.rightParen,             start: loc8, end: loc9),
      createToken(.colon,                  start: loc10, end: loc11),
      createToken(.string("Ratatouille"),  start: loc12, end: loc13)
    )

    if let error = parseError(parser) {
      XCTAssertEqual(error.kind, .starWithoutFollowingArguments)
      XCTAssertEqual(error.location, loc8)
    }
  }

  // MARK: - Kwargs

  /// def cook(**zucchini): "Ratatouille"
  func test_kwargs() {
    let parser = createStmtParser(
      createToken(.def,                    start: loc0, end: loc1),
      createToken(.identifier("cook"),     start: loc2, end: loc3),
      createToken(.leftParen,              start: loc4, end: loc5),
      createToken(.starStar,               start: loc6, end: loc7),
      createToken(.identifier("zucchini"), start: loc8, end: loc9),
      createToken(.rightParen,             start: loc10, end: loc11),
      createToken(.colon,                  start: loc12, end: loc13),
      createToken(.string("Ratatouille"),  start: loc14, end: loc15)
    )

    guard let ast = parse(parser) else { return }

    XCTAssertAST(ast, """
    ModuleAST(start: 0:0, end: 15:20)
      FunctionDefStmt(start: 0:0, end: 15:20)
        Name: cook
        Args
          Arguments(start: 6:6, end: 9:14)
            Args: none
            PosOnlyArgCount: 0
            Defaults: none
            Vararg: none
            KwOnlyArgs: none
            KwOnlyDefaults: none
            Kwarg
              Arg
                Name: zucchini
                Annotation: none
        Body
          ExprStmt(start: 14:14, end: 15:20)
            StringExpr(context: Load, start: 14:14, end: 15:20)
              String: 'Ratatouille'
        Decorators: none
        Returns: none
    """)
  }

  /// def cook(**zucchini,): "Ratatouille"
  func test_kwargs_withCommaAfter() {
    let parser = createStmtParser(
      createToken(.def,                    start: loc0, end: loc1),
      createToken(.identifier("cook"),     start: loc2, end: loc3),
      createToken(.leftParen,              start: loc4, end: loc5),
      createToken(.starStar,               start: loc6, end: loc7),
      createToken(.identifier("zucchini"), start: loc8, end: loc9),
      createToken(.comma,                  start: loc10, end: loc11),
      createToken(.rightParen,             start: loc12, end: loc13),
      createToken(.colon,                  start: loc14, end: loc15),
      createToken(.string("Ratatouille"),  start: loc16, end: loc17)
    )

    guard let ast = parse(parser) else { return }

    XCTAssertAST(ast, """
    ModuleAST(start: 0:0, end: 17:22)
      FunctionDefStmt(start: 0:0, end: 17:22)
        Name: cook
        Args
          Arguments(start: 6:6, end: 11:16)
            Args: none
            PosOnlyArgCount: 0
            Defaults: none
            Vararg: none
            KwOnlyArgs: none
            KwOnlyDefaults: none
            Kwarg
              Arg
                Name: zucchini
                Annotation: none
        Body
          ExprStmt(start: 16:16, end: 17:22)
            StringExpr(context: Load, start: 16:16, end: 17:22)
              String: 'Ratatouille'
        Decorators: none
        Returns: none
    """)
  }

  /// def cook(**zucchini, **tomato): "Ratatouille"
  func test_kwargs_duplicate_throws() {
    let parser = createStmtParser(
      createToken(.def,                    start: loc0, end: loc1),
      createToken(.identifier("cook"),     start: loc2, end: loc3),
      createToken(.leftParen,              start: loc4, end: loc5),
      createToken(.starStar,               start: loc6, end: loc7),
      createToken(.identifier("zucchini"), start: loc8, end: loc9),
      createToken(.comma,                  start: loc10, end: loc11),
      createToken(.starStar,               start: loc12, end: loc13),
      createToken(.identifier("tomato"),   start: loc14, end: loc15),
      createToken(.rightParen,             start: loc16, end: loc17),
      createToken(.colon,                  start: loc18, end: loc19),
      createToken(.string("Ratatouille"),  start: loc20, end: loc21)
    )

    if let error = parseError(parser) {
      XCTAssertEqual(error.kind, .duplicateKwargs)
      XCTAssertEqual(error.location, loc12)
    }
  }

  // MARK: - All

  /// def cook(zucchini, *tomato, pepper, **eggplant): "Ratatouille"
  func test_all() {
    let parser = createStmtParser(
      createToken(.def,                    start: loc0, end: loc1),
      createToken(.identifier("cook"),     start: loc2, end: loc3),
      createToken(.leftParen,              start: loc4, end: loc5),
      createToken(.identifier("zucchini"), start: loc6, end: loc7),
      createToken(.comma,                  start: loc8, end: loc9),
      createToken(.star,                   start: loc10, end: loc11),
      createToken(.identifier("tomato"),   start: loc12, end: loc13),
      createToken(.comma,                  start: loc14, end: loc15),
      createToken(.identifier("pepper"),   start: loc16, end: loc17),
      createToken(.comma,                  start: loc18, end: loc19),
      createToken(.starStar,               start: loc20, end: loc21),
      createToken(.identifier("eggplant"), start: loc22, end: loc23),
      createToken(.rightParen,             start: loc24, end: loc25),
      createToken(.colon,                  start: loc26, end: loc27),
      createToken(.string("Ratatouille"),  start: loc28, end: loc29)
    )

    guard let ast = parse(parser) else { return }

    XCTAssertAST(ast, """
    ModuleAST(start: 0:0, end: 29:34)
      FunctionDefStmt(start: 0:0, end: 29:34)
        Name: cook
        Args
          Arguments(start: 6:6, end: 23:28)
            Args
              Arg
                Name: zucchini
                Annotation: none
            PosOnlyArgCount: 0
            Defaults: none
            Vararg
              Named
                Arg
                  Name: tomato
                  Annotation: none
            KwOnlyArgs
              Arg
                Name: pepper
                Annotation: none
            KwOnlyDefaults
              NoneExpr(context: Load, start: 17:22, end: 17:22)
            Kwarg
              Arg
                Name: eggplant
                Annotation: none
        Body
          ExprStmt(start: 28:28, end: 29:34)
            StringExpr(context: Load, start: 28:28, end: 29:34)
              String: 'Ratatouille'
        Decorators: none
        Returns: none
    """)
  }
}
