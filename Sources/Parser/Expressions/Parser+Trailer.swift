import Lexer

// In CPython:
// Python -> ast.c
//  ast_for_trailer(struct compiling *c, const node *n, expr_ty left_expr)
//  ast_for_slice(struct compiling *c, const node *n)

extension Parser {

  // MARK: - Trailer

  /// ```c
  /// trailer:
  ///     '(' [arglist] ')'
  ///   | '[' subscriptlist ']'
  ///   | '.' NAME
  /// ```
  /// 'Or nop' means that we terminate (without changing current parser state)
  /// if we can't parse according to this rule.
  internal mutating func trailerOrNop(for leftExpr: Expression) throws -> Expression? {
    switch self.peek.kind {
    case .leftParen:
      try self.advance() // (

      let ir = try self.argList(closingToken: .rightParen)

      let end = self.peek.end
      try self.consumeOrThrow(.rightParen)

      let kind = ir.compile(calling: leftExpr)
      return self.expression(kind, start: leftExpr.start, end: end)

    case .leftSqb:
      let start = self.peek.start
      try self.advance() // [

      let sliceKind = try self.subscriptList(closingToken: .rightSqb)

      let end = self.peek.end
      try self.consumeOrThrow(.rightSqb)

      let slice = Slice(sliceKind, start: start, end: end)
      let kind = ExpressionKind.subscript(leftExpr, slice: slice)
      return self.expression(kind, start: leftExpr.start, end: end)

    case .dot:
      try self.advance() // .

      let nameToken = self.peek
      let name = try self.consumeIdentifierOrThrow()
      let kind = ExpressionKind.attribute(leftExpr, name: name)
      return self.expression(kind, start: leftExpr.start, end: nameToken.end)

    default: // no trailer
      return nil
    }
  }

  // MARK: - Subscript

  /// `subscriptlist: subscript (',' subscript)* [',']`
  private mutating func subscriptList(closingToken: TokenKind) throws -> SliceKind {
    var elements = [Slice]()

    let first = try self.subscript(closingTokens: closingToken, .comma)
    elements.append(first)

    while self.peek.kind == .comma && self.peekNext.kind != closingToken {
      try self.advance() // ,

      let sub = try self.subscript(closingTokens: closingToken, .comma)
      elements.append(sub)
    }

    let hasTrailingComma = self.peek.kind == .comma
    if hasTrailingComma {
      try self.advance() // ,
    }

    // If we have coma then it is a tuple! (even if it has only 1 element!)
    if elements.count == 1 && !hasTrailingComma {
      return first.kind
    }

    /// The grammar is ambiguous here. The ambiguity is resolved
    /// by treating the sequence as a tuple literal if there are
    /// no slice features. (comment taken from CPython)
    if let tupleSlice = self.asTupleIndexIfAllElementsAreIndices(elements) {
      return tupleSlice
    }

    return .extSlice(dims: elements)
  }

  private func asTupleIndexIfAllElementsAreIndices(_ slices: [Slice]) -> SliceKind? {
    var indices = [Expression]()

    for slice in slices {
      switch slice.kind {
      case let .index(e): indices.append(e)
      case .slice, .extSlice: return nil
      }
    }

    // 0 slices is not allowed by grammar: `subscriptlist: subscript ...`
    // This case should be dealt with much sooner than here.
    assert(slices.count >= 1)
    let start = slices.first!.start // swiftlint:disable:this force_unwrapping
    let end   = slices.last!.end    // swiftlint:disable:this force_unwrapping

    let tupleKind = ExpressionKind.tuple(indices)
    let tuple = Expression(tupleKind, start: start, end: end)
    return .index(tuple)
  }

  /// ```c
  /// subscript: test | [test] ':' [test] [sliceop]
  /// sliceop: ':' [test]
  /// ```
  private mutating func `subscript`(closingTokens: TokenKind...) throws -> Slice {
    let start = self.peek.start
    var lower, upper, step: Expression?

    if self.peek.kind != .colon {
      lower = try self.test()
    }

    // subscript: test -> index
    if let index = lower, closingTokens.contains(self.peek.kind) {
      let kind = SliceKind.index(index)
      return Slice(kind, start: index.start, end: index.end)
    }

    // subscript: [test] ':' [test] [sliceop] -> slice
    var end = self.peek.end // from now on, everything is optional
    try self.consumeOrThrow(.colon)

    // do we have 2nd? a[1:(we are here)]
    if self.peek.kind != .colon && !closingTokens.contains(self.peek.kind) {
      upper = try self.test()
      end = upper?.end ?? end
    }

    // do we have 3rd? (sliceop) a[1:2(we are here)]
    if self.peek.kind == .colon {
      end = self.peek.end
      try self.advance() // :

      if !closingTokens.contains(self.peek.kind) {
        step = try self.test()
        end = step?.end ?? end
      }
    }

    let kind = SliceKind.slice(lower: lower, upper: upper, step: step)
    return Slice(kind, start: start, end: end)
  }
}
