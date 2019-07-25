// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation

internal struct Parser {

  private var lexer: Lexer
  private var token: Token? /// peek, nil on eof
  private var location = SourceLocation.start

  private var typedefs = [String:String]()

  internal init(lexer: Lexer) {
    self.lexer = lexer
    self.lexNextToken()
  }

  // MARK: - Traversal

  @discardableResult
  private mutating func advance() -> Token? {
    // should not happen if we wrote everything else correctly
    if self.token == nil {
      print("Trying to advance past eof.")
      exit(1)
    }

    self.lexNextToken()
    let token = self.token
    return token
  }

  private mutating func lexNextToken() {
    let next = self.lexer.getToken()
    self.token = next.kind == .eof ? nil : next
    self.location = self.token?.location ?? self.location
  }

  // MARK: - Parse

  internal mutating func parse() -> [Entity] {
    var result = [Entity]()

    while let token = self.token {
      switch token.kind {
      case .typedef:
        self.typedef()
      case .enum:
        let value = self.enum()
        result.append(.enum(value))
      default:
        print("Not implemented: \(token)")
        // self.advance()
        exit(1)
      }
    }

    return result
  }

  private mutating func typedef() {
    assert(self.token?.kind == .some(.typedef))
    self.advance() // typedef

    let oldName = self.consumeNameOrFail()
    self.consumeOrFail(kind: .equal)
    let newName = self.consumeNameOrFail()

    self.typedefs[oldName] = newName
  }

  private mutating func `enum`() -> Enum {
    assert(self.token?.kind == .some(.enum))
    self.advance() // enum

    let name = self.consumeNameOrFail()
    self.consumeOrFail(kind: .equal)

    var cases = [EnumCase]()
    cases.append(self.enumCase())

    while let token = self.token, token.kind == .or {
      self.advance() // |
      cases.append(self.enumCase())
    }

    return Enum(name: name, cases: cases)
  }

  private mutating func enumCase() -> EnumCase {
    let name = self.consumeNameOrFail()
    let properties = self.properties()
    return EnumCase(name: name, properties: properties)
  }

//  private mutating func `struct`() -> Struct {
//
//  }

  private mutating func properties() -> [Property] {
    guard self.token?.kind == .leftParen else {
      return []
    }

    self.advance() // (

    var result = [Property]()
    while let token = self.token, token.kind != .rightParen {
      let property = self.property()
      result.append(property)
    }

    self.consumeOrFail(kind: .rightParen)
    return result
  }

  private mutating func property() -> Property {
    var kind = PropertyKind.default

    let type = self.consumeNameOrFail()
    if self.consumeIfEqual(kind: .star) { kind = .many }
    if self.consumeIfEqual(kind: .option) { kind = .optional }
    let name = self.consumeNameOrFail()

    return Property(name: name, type: type, kind: kind)
  }

  // MARK: - Helpers

  private mutating func consumeIfEqual(kind: TokenKind) -> Bool {
    let token = self.tokenOrFail()

    guard token.kind == kind else {
      return false
    }

    self.advance()
    return true
  }

  private mutating func consumeOrFail(kind: TokenKind) {
    let token = self.tokenOrFail()

    guard token.kind == kind else {
      print("\(self.location) Invalid token kind. Expected: '\(kind)', got: '\(token.kind)'.")
      exit(1)
    }

    self.advance()
  }

  private mutating func consumeNameOrFail() -> String {
    let token = self.tokenOrFail()

    guard case let TokenKind.name(value) = token.kind else {
      print("\(self.location) Invalid token kind. Expected: 'name', got: '\(token.kind)'.")
      exit(1)
    }

    self.advance()
    return self.typedefs[value] ?? value
  }

  private mutating func tokenOrFail() -> Token {
    guard let token = self.token else {
      print("Trying to use eof token.")
      exit(1)
    }

    return token
  }
}
