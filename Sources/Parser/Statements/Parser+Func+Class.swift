import Core
import Lexer

// In CPython:
// Python -> ast.c
//  ast_for_funcdef_impl(struct compiling *c, const node *n0, ...)
//  ast_for_classdef(struct compiling *c, const node *n, ...)

extension Parser {

  // MARK: - Function

  /// `funcdef: 'def' NAME parameters ['->' test] ':' suite`
  internal mutating func funcDef(
    isAsync:       Bool = false,
    start:         SourceLocation? = nil,
    decoratorList: [Expression] = []) throws -> Statement {

    assert(self.peek.kind == .def)

    let start = start ?? self.peek.start
    try self.advance() // def

    let name = try self.consumeIdentifierOrThrow()
    try self.checkForbiddenName(name)
    let args = try self.parameters()

    var returns: Expression?
    if self.peek.kind == .rightArrow {
      try self.advance() // ->
      returns = try self.test()
    }

    try self.consumeOrThrow(.colon)
    let body = try self.suite()

    let kind: StatementKind = isAsync ?
      .asyncFunctionDef(name: name, args: args, body: Array(body),
                        decoratorList: decoratorList, returns: returns) :
      .functionDef     (name: name, args: args, body: Array(body),
                        decoratorList: decoratorList, returns: returns)

    return self.statement(kind, start: start, end: body.last.end)
  }

  // MARK: - Class

  /// `classdef: 'class' NAME ['(' [arglist] ')'] ':' suite`
  internal mutating func classDef(
    start:         SourceLocation? = nil,
    decoratorList: [Expression] = []) throws -> Statement {

    assert(self.peek.kind == .class)

    let start = start ?? self.peek.start
    try self.advance() // class

    let name = try self.consumeIdentifierOrThrow()
    try self.checkForbiddenName(name)
    let args = try self.parseBaseClass()
    try self.consumeOrThrow(.colon)
    let body = try self.suite()

    let kind = StatementKind.classDef(name: name,
                                      bases: args?.args ?? [],
                                      keywords: args?.keywords ?? [], // PEP3115
                                      body: Array(body),
                                      decoratorList: decoratorList)

    let end = body.last.end
    return self.statement(kind, start: start, end: end)
  }

  private mutating func parseBaseClass() throws -> CallIR? {
    guard self.peek.kind == .leftParen else {
      return nil
    }

    try self.advance() // (

    // empty parens -> no base class
    if self.peek.kind == .rightParen {
      try self.advance() // )
      return nil
    }

    let result = try self.argList(closingToken: .rightParen, isBaseClass: true)
    try self.consumeOrThrow(.rightParen)
    return result
  }
}
