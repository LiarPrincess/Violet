import VioletCore
import VioletLexer

// In CPython:
// Python -> ast.c
//  ast_for_funcdef_impl(struct compiling *c, const node *n0, ...)
//  ast_for_classdef(struct compiling *c, const node *n, ...)

extension Parser {

  // MARK: - Function

  /// `funcdef: 'def' NAME parameters ['->' test] ':' suite`
  internal func funcDef(isAsync: Bool = false,
                        start: SourceLocation? = nil,
                        decorators: [Expression] = []) throws -> Statement {
    assert(self.peek.kind == .def)

    let start = start ?? self.peek.start
    try self.advance() // def

    let nameLocation = self.peek.start
    let name = try self.consumeIdentifierOrThrow()
    try self.checkForbiddenName(name, location: nameLocation)

    let args = try self.parameters()

    var returns: Expression?
    if try self.consumeIf(.rightArrow) {
      returns = try self.test(context: .load)
    }

    try self.consumeOrThrow(.colon)
    let body = try self.suite()
    let end = body.last.end

    // swiftlint:disable multiline_arguments
    return isAsync ?
      self.builder.asyncFunctionDefStmt(name: name, args: args, body: body,
                                        decorators: decorators, returns: returns,
                                        start: start, end: end) :
      self.builder.functionDefStmt(name: name, args: args, body: body,
                                   decorators: decorators, returns: returns,
                                   start: start, end: end)
    // swiftlint:enable multiline_arguments
  }

  // MARK: - Class

  /// `classdef: 'class' NAME ['(' [arglist] ')'] ':' suite`
  internal func classDef(start: SourceLocation? = nil,
                         decorators: [Expression] = []) throws -> Statement {
    assert(self.peek.kind == .class)

    let start = start ?? self.peek.start
    try self.advance() // class

    let nameLocation = self.peek.start
    let name = try self.consumeIdentifierOrThrow()
    try self.checkForbiddenName(name, location: nameLocation)

    let args = try self.parseBaseClass()
    try self.consumeOrThrow(.colon)
    let body = try self.suite()

    return self.builder.classDefStmt(name: name,
                                     bases: args?.args ?? [],
                                     keywords: args?.keywords ?? [], // PEP3115
                                     body: body,
                                     decorators: decorators,
                                     start: start,
                                     end: body.last.end)
  }

  private func parseBaseClass() throws -> CallIR? {
    guard self.peek.kind == .leftParen else {
      return nil
    }

    try self.advance() // (

    // empty parens -> no base class
    if try self.consumeIf(.rightParen) {
      return nil
    }

    let result = try self.argList(closingToken: .rightParen, isBaseClass: true)
    try self.consumeOrThrow(.rightParen)
    return result
  }
}
