// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Lexer

public struct Parser {

  /// Token source.
  internal var lexer: LexerType

  /// Current token.
  internal var peek = Token(.amper, start: .start, end: .start)

  /// Token after `self.peek`.
  internal var peekNext = Token(.amper, start: .start, end: .start)

  public init(lexer: LexerType) {
    self.lexer = lexer
  }

  // MARK: - Traversal

  // TODO: self.location should remember start of token

  @discardableResult
  internal mutating func advance() throws -> Token? {
    // COMMENT, NEW LINE
    // should not happen if we wrote everything else correctly
    if self.peek.kind == .eof {
      throw self.unimplemented("Trying to advance past eof.")
    }

    self.peek = self.peekNext
    self.peekNext = try self.lexer.getToken()

//    self.lexNextToken()
//    let token = self.token
//    return token
    return nil
  }

  // MARK: - Parse

  public mutating func parse() throws {
    // TODO: Check if parsed before
    self.peek = try self.lexer.getToken()
    self.peekNext = try self.lexer.getToken()
  }

  // MARK: - Consume

  internal func consume(_ kind: ExpectedToken) { }

  internal func consumeIf(_ kind: ExpectedToken) -> Bool { return true }

//  internal mutating func consumeIdentifier() -> String {
//    guard case let .identifier(value) = self.peek else {
//      fatalError()
//    }
//
//    return ""
//  }

//  private mutating func consumeNameOrFail() -> String {
//    let token = self.tokenOrFail()
//
//    guard case let TokenKind.name(value) = token.kind else {
//      self.fail("Invalid token kind. Expected: 'name', got: '\(token.kind)'.")
//    }
//
//    self.advance()
//    return self.aliases[value] ?? value
//  }

//  private mutating func tokenOrFail() -> Token {
//    guard let token = self.token else {
//      self.fail("Trying to use eof token.")
//    }
//
//    return token
//  }

  // @available(*, deprecated, message: "Unimplemented")
  internal func unimplemented(_ message: String? = nil,
                              function:  StaticString = #function) -> ParserError {
    return ParserError.unimplemented("\(function): \(message ?? "")")
  }

  internal func failUnexpectedEOF(expected: ExpectedToken...) -> Error {
    return self.unimplemented()
  }

  internal func failUnexpectedToken(expected: ExpectedToken...) -> Error {
    switch self.peek.kind {
    case .eof: return self.failUnexpectedEOF()
    default:   return self.unimplemented()
    }
  }

//  private func fail(_ message: String, location: SourceLocation? = nil) -> Never {
//    print("\(location ?? self.location): \(message)")
//    exit(EXIT_FAILURE)
//  }
}
