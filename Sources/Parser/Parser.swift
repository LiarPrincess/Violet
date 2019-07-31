// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Lexer

// https://docs.python.org/3/reference/index.html
// Python/ast.c in CPython

private enum ParserState {
  case notStarted
  case finished(Expression)
}

public struct Parser {

  /// Token source.
  internal var lexer: LexerType

  /// Current parser state, used for example for: caching parsing result.
  private var state = ParserState.notStarted

  public init(lexer: LexerType) {
    self.lexer = lexer
  }

  // MARK: - Traversal

  /// Current token.
  internal var peek = Token(.comment(""), start: .start, end: .start)

  /// Token after `self.peek`.
  internal var peekNext = Token(.comment(""), start: .start, end: .start)

  @discardableResult
  internal mutating func advance() throws -> Token? {
    if self.peek.kind == .eof {
      throw self.unimplemented("Important, because we no longer have nil on end: self.failUnexpectedEOF")
    }

    repeat {
      self.peek = self.peekNext
      self.peekNext = try self.lexer.getToken()
    } while self.isComment(self.peek) && !self.isEOF(self.peek)

    return self.peek
  }

  private func isComment(_ token: Token?) -> Bool {
    guard let kind = token?.kind else { return false }
    guard case TokenKind.comment(_) = kind else { return false }
    return true
  }

  private func isEOF(_ token: Token?) -> Bool {
    guard let kind = token?.kind else { return false }
    return kind == .eof
  }

  // MARK: - Parse

  public mutating func parse() throws -> Expression {
    switch self.state {
    case .notStarted:
      // populate peeks
      self.peek = try self.lexer.getToken()
      self.peekNext = try self.lexer.getToken()

      let expr = try self.expression()
      self.state = .finished(expr)
      return expr

    case .finished(let ast):
      return ast
    }
  }

  // MARK: - Consume

  internal mutating func consumeIdentifierOrThrow() throws -> String {
    if case let TokenKind.identifier(value) = self.peek.kind {
      try self.advance() // identifier
      return value
    }

    throw self.unimplemented()
  }

  internal mutating func consumeOrThrow(_ kind: TokenKind) throws {
    guard try self.consumeIf(kind) else {
      throw self.unimplemented("consumeOrThrow: \(kind)")
    }
  }

  internal mutating func consumeIf(_ kind: TokenKind) throws -> Bool {
    if self.peek.kind == kind {
      try self.advance()
      return true
    }

    return false
  }

  // TODO: start/end?
  /// Create parser error
  internal func error(_ kind:   ParserErrorKind,
                      location: SourceLocation? = nil) -> ParserError {
    return ParserError(kind, location: location ?? self.peek.start)
  }

  // @available(*, deprecated, message: "Unimplemented")
  internal func unimplemented(_ message: String? = nil,
                              function:  StaticString = #function) -> ParserError {
    return self.error(.unimplemented("\(function): \(message ?? "")"))
  }

  // TODO: unexpectedTokenError()
  internal func failUnexpectedToken(expected: ExpectedToken...,
                                    function:  StaticString = #function) -> Error {
    switch self.peek.kind {
    case .eof:
      // self.failUnexpectedEOF
      return self.error(.unimplemented("\(function): unexpected eof, expected: \(expected)"))
    default:
      return self.error(.unimplemented("\(function): unexpected \(self.peek.kind), expected: \(expected)"))
    }
  }
}
