// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Lexer

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
      return self.peek
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

  internal mutating func consumeIf(_ kind: TokenKind) throws -> Bool {
    if self.peek.kind == kind {
      try self.advance()
      return true
    }

    return false
  }

  // @available(*, deprecated, message: "Unimplemented")
  internal func unimplemented(_ message: String? = nil,
                              function:  StaticString = #function) -> ParserError {
    return ParserError.unimplemented("\(function): \(message ?? "")")
  }

  internal func failUnexpectedToken(expected: ExpectedToken...) -> Error {
    switch self.peek.kind {
    case .eof: return self.unimplemented() // self.failUnexpectedEOF
    default:   return self.unimplemented()
    }
  }
}
