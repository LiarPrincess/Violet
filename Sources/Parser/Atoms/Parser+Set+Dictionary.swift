import Core
import Lexer

// In CPython:
// Python -> ast.c
//  ast_for_atom(struct compiling *c, const node *n)

extension Parser {

  /// ```c
  /// atom:
  ///   '{' [dictorsetmaker] '}'
  ///    and other stuff...
  ///
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
  internal mutating func atomSetDictionary() throws -> Expression {
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
    try self.consumeIf(.comma)

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

      if try self.consumeIf(.starStar) {
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
    try self.consumeIf(.comma)

    let end = self.peek.end
    try self.consumeOrThrow(closingToken)

    return self.expression(.dictionary(elements), start: start, end: end)
  }
}
