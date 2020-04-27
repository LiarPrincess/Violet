import XCTest
import VioletCore
import VioletLexer
@testable import VioletParser

// swiftlint:disable file_length
// swiftlint:disable function_body_length

class ParseFunctionDef: XCTestCase, Common {

  // MARK: - No arguments

  /// def cook(): "Ratatouille"
  func test_noArguments() {
    let parser = self.createStmtParser(
      self.token(.def,                   start: loc0, end: loc1),
      self.token(.identifier("cook"),    start: loc2, end: loc3),
      self.token(.leftParen,             start: loc4, end: loc5),
      self.token(.rightParen,            start: loc6, end: loc7),
      self.token(.colon,                 start: loc8, end: loc9),
      self.token(.string("Ratatouille"), start: loc10, end: loc11)
    )

    guard let ast = self.parse(parser) else { return }

    XCTAssertAST(ast, """
    ModuleAST(start: 0:0, end: 11:16)
      FunctionDefStmt(start: 0:0, end: 11:16)
        Name: cook
        Args
          Arguments(start: 6:6, end: 6:6)
            Args: none
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
    let parser = self.createStmtParser(
      self.token(.def,                   start: loc0, end: loc1),
      self.token(.identifier("cook"),    start: loc2, end: loc3),
      self.token(.leftParen,             start: loc4, end: loc5),
      self.token(.rightParen,            start: loc6, end: loc7),
      self.token(.rightArrow,            start: loc8, end: loc9),
      self.token(.identifier("Dish"),    start: loc10, end: loc11),
      self.token(.colon,                 start: loc12, end: loc13),
      self.token(.string("Ratatouille"), start: loc14, end: loc15)
    )

    guard let ast = self.parse(parser) else { return }

    XCTAssertAST(ast, """
    ModuleAST(start: 0:0, end: 15:20)
      FunctionDefStmt(start: 0:0, end: 15:20)
        Name: cook
        Args
          Arguments(start: 6:6, end: 6:6)
            Args: none
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
    let parser = self.createStmtParser(
      self.token(.def,                    start: loc0, end: loc1),
      self.token(.identifier("cook"),     start: loc2, end: loc3),
      self.token(.leftParen,              start: loc4, end: loc5),
      self.token(.identifier("zucchini"), start: loc6, end: loc7),
      self.token(.rightParen,             start: loc8, end: loc9),
      self.token(.colon,                  start: loc10, end: loc11),
      self.token(.string("Ratatouille"),  start: loc12, end: loc13)
    )

    guard let ast = self.parse(parser) else { return }

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
    let parser = self.createStmtParser(
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

    guard let ast = self.parse(parser) else { return }

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
    let parser = self.createStmtParser(
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

    guard let ast = self.parse(parser) else { return }

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
    let parser = self.createStmtParser(
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

    guard let ast = self.parse(parser) else { return }

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
    let parser = self.createStmtParser(
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

    guard let ast = self.parse(parser) else { return }

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
    let parser = self.createStmtParser(
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

    if let error = self.error(parser) {
      XCTAssertEqual(error.kind, .defaultAfterNonDefaultArgument)
      XCTAssertEqual(error.location, loc14)
    }
  }

  // MARK: - Variadic

  /// def cook(*zucchini): "Ratatouille"
  func test_varargs() {
    let parser = self.createStmtParser(
      self.token(.def,                    start: loc0, end: loc1),
      self.token(.identifier("cook"),     start: loc2, end: loc3),
      self.token(.leftParen,              start: loc4, end: loc5),
      self.token(.star,                   start: loc6, end: loc7),
      self.token(.identifier("zucchini"), start: loc8, end: loc9),
      self.token(.rightParen,             start: loc10, end: loc11),
      self.token(.colon,                  start: loc12, end: loc13),
      self.token(.string("Ratatouille"),  start: loc14, end: loc15)
    )

    guard let ast = self.parse(parser) else { return }

    XCTAssertAST(ast, """
    ModuleAST(start: 0:0, end: 15:20)
      FunctionDefStmt(start: 0:0, end: 15:20)
        Name: cook
        Args
          Arguments(start: 6:6, end: 9:14)
            Args: none
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
    let parser = self.createStmtParser(
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

    guard let ast = self.parse(parser) else { return }

    XCTAssertAST(ast, """
    ModuleAST(start: 0:0, end: 23:28)
      FunctionDefStmt(start: 0:0, end: 23:28)
        Name: cook
        Args
          Arguments(start: 6:6, end: 17:22)
            Args: none
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
    let parser = self.createStmtParser(
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

    guard let ast = self.parse(parser) else { return }

    XCTAssertAST(ast, """
    ModuleAST(start: 0:0, end: 19:24)
      FunctionDefStmt(start: 0:0, end: 19:24)
        Name: cook
        Args
          Arguments(start: 6:6, end: 13:18)
            Args: none
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
    let parser = self.createStmtParser(
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

    if let error = self.error(parser) {
      XCTAssertEqual(error.kind, .duplicateVarargs)
      XCTAssertEqual(error.location, loc12)
    }
  }

  /// def cook(*, zucchini): "Ratatouille"
  func test_varargsUnnamed() {
    let parser = self.createStmtParser(
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

    guard let ast = self.parse(parser) else { return }

    XCTAssertAST(ast, """
    ModuleAST(start: 0:0, end: 17:22)
      FunctionDefStmt(start: 0:0, end: 17:22)
        Name: cook
        Args
          Arguments(start: 6:6, end: 11:16)
            Args: none
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
    let parser = self.createStmtParser(
      self.token(.def,                    start: loc0, end: loc1),
      self.token(.identifier("cook"),     start: loc2, end: loc3),
      self.token(.leftParen,              start: loc4, end: loc5),
      self.token(.star,                   start: loc6, end: loc7),
      self.token(.rightParen,             start: loc8, end: loc9),
      self.token(.colon,                  start: loc10, end: loc11),
      self.token(.string("Ratatouille"),  start: loc12, end: loc13)
    )

    if let error = self.error(parser) {
      XCTAssertEqual(error.kind, .starWithoutFollowingArguments)
      XCTAssertEqual(error.location, loc8)
    }
  }

  // MARK: - Kwargs

  /// def cook(**zucchini): "Ratatouille"
  func test_kwargs() {
    let parser = self.createStmtParser(
      self.token(.def,                    start: loc0, end: loc1),
      self.token(.identifier("cook"),     start: loc2, end: loc3),
      self.token(.leftParen,              start: loc4, end: loc5),
      self.token(.starStar,               start: loc6, end: loc7),
      self.token(.identifier("zucchini"), start: loc8, end: loc9),
      self.token(.rightParen,             start: loc10, end: loc11),
      self.token(.colon,                  start: loc12, end: loc13),
      self.token(.string("Ratatouille"),  start: loc14, end: loc15)
    )

    guard let ast = self.parse(parser) else { return }

    XCTAssertAST(ast, """
    ModuleAST(start: 0:0, end: 15:20)
      FunctionDefStmt(start: 0:0, end: 15:20)
        Name: cook
        Args
          Arguments(start: 6:6, end: 9:14)
            Args: none
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
    let parser = self.createStmtParser(
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

    guard let ast = self.parse(parser) else { return }

    XCTAssertAST(ast, """
    ModuleAST(start: 0:0, end: 17:22)
      FunctionDefStmt(start: 0:0, end: 17:22)
        Name: cook
        Args
          Arguments(start: 6:6, end: 11:16)
            Args: none
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
    let parser = self.createStmtParser(
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

    if let error = self.error(parser) {
      XCTAssertEqual(error.kind, .duplicateKwargs)
      XCTAssertEqual(error.location, loc12)
    }
  }

  // MARK: - All

  /// def cook(zucchini, *tomato, pepper, **eggplant): "Ratatouille"
  func test_all() {
    let parser = self.createStmtParser(
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

    guard let ast = self.parse(parser) else { return }

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
