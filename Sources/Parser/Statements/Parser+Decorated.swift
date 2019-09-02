import Core
import Lexer

// In CPython:
// Python -> ast.c
//  ast_for_decorated (struct compiling *c, const node *n)
//  ast_for_decorators(struct compiling *c, const node *n)
//  ast_for_decorator (struct compiling *c, const node *n)

extension Parser {

  /// decorated: decorators (classdef | funcdef | async_funcdef)
  /// async_funcdef: 'async' funcdef
  internal mutating func decorated() throws -> Statement {
    assert(self.peek.kind == .at)

    let start = self.peek.start
    let decoratorsRaw = try self.decorators()
    let decorators = Array(decoratorsRaw)

    switch self.peek.kind {
    case .class:
      return try self.classDef(start: start, decoratorList: decorators)

    case .def:
      return try self.funcDef(start: start, decoratorList: decorators)

    case .async:
      try self.advance() // async

      switch self.peek.kind {
      case .def:
        return try self.funcDef(isAsync: true,
                                start: start,
                                decoratorList: decorators)

      default:
        throw self.unexpectedToken(expected: [.def])
      }

    default:
      throw self.unexpectedToken(expected: [.class, .def, .async])
    }
  }

  /// decorators: decorator+
  internal mutating func decorators() throws -> NonEmptyArray<Expression> {
    assert(self.peek.kind == .at)

    let first = try self.decorator()
    var result = NonEmptyArray(first: first)

    while self.peek.kind == .at {
      let element = try self.decorator()
      result.append(element)
    }

    return result
  }

  /// decorator: '@' dotted_name [ '(' [arglist] ')' ] NEWLINE
  internal mutating func decorator() throws -> Expression {
    assert(self.peek.kind == .at)

    try self.advance() // @

    let name = try self.dottedNameForDecorator()
    let call = try self.parseCall(to: name)

    try self.consumeOrThrow(.newLine)
    return call
  }

  /// dotted_name: NAME ('.' NAME)*
  /// It is different implementation of `dotted_name` than in import!
  /// Even though it is using the same grammar rule (CPython does the same).
  internal mutating func dottedNameForDecorator() throws -> Expression {
    // We cannot set start location at '@' because AST does not contain '@'
    // symbol and we would end up with malformed source range!

    let firstToken = self.peek
    let firstId = try self.consumeIdentifierOrThrow()
    let first = self.expression(.identifier(firstId),
                                start: firstToken.start,
                                end: firstToken.end)

    var result = first
    while self.peek.kind == .dot {
      try self.advance() // .

      let end = self.peek.end
      let id = try self.consumeIdentifierOrThrow()
      result = self.expression(.attribute(result, name: id),
                               start: result.start,
                               end: end)
    }

    return result
  }

  private mutating func parseCall(to left: Expression) throws -> Expression {
    // no parens -> no call
    guard self.peek.kind == .leftParen else {
      return left
    }

    try self.advance() // (

    // call with no args
    if self.peek.kind == .rightParen {
      let end = self.peek.end
      try self.advance() // )

      let kind = ExpressionKind.call(function: left, args: [], keywords: [])
      return self.expression(kind, start: left.start, end: end)
    }

    let args = try self.argList(closingToken: .rightParen)

    let end = self.peek.end
    try self.consumeOrThrow(.rightParen)

    let kind = args.compile(calling: left)
    return self.expression(kind, start: left.start, end: end)
  }
}
