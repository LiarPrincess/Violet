import Lexer

// In CPython:
// Python -> ast.c
//  ast_for_atom(struct compiling *c, const node *n)

extension Parser {

  // MARK: - Tuple/yield/generator

  internal mutating func atomLeftParen() throws -> Expression {
    assert(self.peek.kind == .leftParen)

    let start = self.peek.start
    try self.advance() // (

    if self.peek.kind == .rightParen { // a = () -> empty tuple
      let end = self.peek.end
      try self.advance() // )
      return self.expression(.tuple([]), start: start, end: end)
    }

    if let yield = try self.yieldExprOrNop(closingTokens: [.rightParen]) {
      try self.advance() // )
      return yield
    }

    let test = try self.testListComp(closingToken: .rightParen)

    assert(self.peek.kind == .rightParen)
    let end = self.peek.end
    try self.advance() // )

    switch test {
    case let .single(e):
      // rebind start/end to include parens
      return self.expression(e.kind, start: start, end: end)
    case let .multiple(es):
      return self.expression(.tuple(es), start: start, end: end)
    case let .listComprehension(elt: elt, generators: gen):
      let kind = ExpressionKind.generatorExp(elt: elt, generators: gen)
      return self.expression(kind, start: start, end: end)
    }
  }

  // MARK: - List

  internal mutating func atomLeftSquareBracket() throws -> Expression {
    assert(self.peek.kind == .leftSqb)

    let start = self.peek.start
    try self.advance() // [

    if self.peek.kind == .rightSqb { // a = [] -> empty list
      let end = self.peek.end
      try self.advance() // ]

      return self.expression(.list([]), start: start, end: end)
    }

    let test = try self.testListComp(closingToken: .rightSqb)

    let end = self.peek.end
    try self.consumeOrThrow(.rightSqb)

    switch test {
    case let .single(e):
      return self.expression(.list([e]), start: start, end: end)
    case let .multiple(es):
      return self.expression(.list(es), start: start, end: end)
    case let .listComprehension(elt: elt, generators: gen):
      let kind = ExpressionKind.listComprehension(elt: elt, generators: gen)
      return self.expression(kind, start: start, end: end)
    }
  }

  // MARK: - Set/dictionary

  /// ```c
  /// dictorsetmaker:
  /// (
  ///   (
  ///     (test ':' test | '**' expr)
  ///     (comp_for | (',' (test ':' test | '**' expr))* [','])
  ///   )
  ///   |
  ///   (
  ///     (test | star_expr)
  ///     (comp_for | (',' (test | star_expr))* [','])
  ///   )
  /// )
  /// ```
  internal mutating func atomLeftBrace() throws -> Expression {
    // swiftlint:disable:previous function_body_length
    assert(self.peek.kind == .leftBrace)

    let start = self.peek.start
    try self.advance() // {

    // empty dict
    if self.peek.kind == .rightBrace {
      let end = self.peek.end
      try self.advance() // }

      return self.expression(.dictionary([]), start: start, end: end)
    }

    // star
    if let expr = try self.starExprOrNop() {
      return try self.setDisplay(first: expr,
                                 start: start,
                                 closingToken: .rightBrace)
    }

    // star star
    if self.peek.kind == .starStar {
      let starStarStart = self.peek.start
      try self.advance() // **

      let expr = try self.expr()

      // { **a for b in [] } <- throws
      if self.isCompFor() {
        let kind = ParserErrorKind.dictUnpackingInsideComprehension
        throw self.error(kind, location: starStarStart)
      }

      return try self.dictionaryDisplay(first: .unpacking(expr),
                                        start: start,
                                        closingToken: .rightBrace)
    }

    let first = try self.test()

    // set with single element
    if self.peek.kind == .rightBrace {
      let end = self.peek.end
      try self.advance() // }

      let kind = ExpressionKind.set([first])
      return self.expression(kind, start: start, end: end)
    }

    // set comprehension
    if let generators = try self.compForOrNop(closingTokens: [.rightBrace]) {
      let end = self.peek.end
      try self.consumeOrThrow(.rightBrace)

      let kind = ExpressionKind.setComprehension(elt: first,
                                                 generators: generators)
      return self.expression(kind, start: start, end: end)
    }

    // set with multiple elements
    if self.peek.kind == .comma {
      return try self.setDisplay(first: first,
                                 start: start,
                                 closingToken: .rightBrace)
    }

    // it is a dictionary
    try self.consumeOrThrow(.colon)
    let value = try self.test()

    // dictionary comprehension
    if let generators = try self.compForOrNop(closingTokens: [.rightBrace]) {
      let end = self.peek.end
      try self.consumeOrThrow(.rightBrace)

      let kind = ExpressionKind.dictionaryComprehension(key: first,
                                                        value: value,
                                                        generators: generators)
      return self.expression(kind, start: start, end: end)
    }

    // dictionary
    return try self.dictionaryDisplay(first: .keyValue(key: first, value: value),
                                      start: start,
                                      closingToken: .rightBrace)
  }

  /// `(comp_for | (',' (test | star_expr))* [','])`
  private mutating func setDisplay(first: Expression,
                                   start: SourceLocation,
                                   closingToken: TokenKind) throws -> Expression {

    var elements = [Expression]()
    elements.append(first)

    while self.peek.kind == .comma && self.peekNext.kind != closingToken {
      try self.advance() // ,

      let test = try self.testOrStarExpr()
      elements.append(test)
    }

    // optional trailing comma
    if self.peek.kind == .comma {
      try self.advance() // ,
    }

    let end = self.peek.end
    try self.consumeOrThrow(closingToken)

    return self.expression(.set(elements), start: start, end: end)
  }

  /// `(comp_for | (',' (test ':' test | '**' expr))* [','])`
  private mutating func dictionaryDisplay(first: DictionaryElement,
                                          start: SourceLocation,
                                          closingToken: TokenKind) throws -> Expression {

    var elements = [DictionaryElement]()
    elements.append(first)

    // while
    while self.peek.kind == .comma && self.peekNext.kind != closingToken {
      try self.advance() // ,

      if self.peek.kind == .starStar {
        try self.advance() // **
        let expr = try self.expr()
        elements.append(.unpacking(expr))
      } else {
        let key = try self.test()
        try self.consumeOrThrow(.colon)
        let value = try self.test()
        elements.append(.keyValue(key: key, value: value))
      }
    }

    // optional trailing comma
    if self.peek.kind == .comma {
      try self.advance() // ,
    }

    let end = self.peek.end
    try self.consumeOrThrow(closingToken)

    return self.expression(.dictionary(elements), start: start, end: end)
  }
}
