// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation

internal struct Parser {

  private var lexer: Lexer
  private var token: Token? /// peek, nil on eof
  private var location = SourceLocation.start

  private var aliases = [String:String]()

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
      case .alias:
        self.alias()
      case .enum, .indirect:
        let value = self.enumDef()
        result.append(.enum(value))
      case .struct:
        let value = self.structDef()
        result.append(.struct(value))

      case .name(let value):
        self.fail("'\(value)' is not a valid entity declaration (missing '@'?).")
      default:
        self.fail("Invalid token '\(token.kind)'.")
      }
    }

    return result
  }

  private mutating func alias() {
    assert(self.token?.kind == .some(.alias))
    self.advance() // typedef

    let oldName = self.consumeNameOrFail()
    self.consumeOrFail(kind: .equal)
    let newName = self.consumeNameOrFail()

    self.aliases[oldName] = newName
  }

  private mutating func enumDef() -> EnumDef {
    assert(self.token?.kind == .some(.enum) || self.token?.kind == .some(.indirect))
    let indirect = self.token?.kind == .some(.indirect)
    self.advance() // enum

    let name = self.consumeNameOrFail()
    self.consumeOrFail(kind: .equal)

    var cases = [EnumCaseDef]()
    cases.append(self.enumCaseDef())

    while let token = self.token, token.kind == .or {
      self.advance() // |
      cases.append(self.enumCaseDef())
    }

    return EnumDef(name: name, cases: cases, indirect: indirect)
  }

  private mutating func enumCaseDef() -> EnumCaseDef {
    let name = self.consumeNameOrFail()
    let properties = self.properties()
    let doc = self.getDoc()
    return EnumCaseDef(name: name, properties: properties, doc: doc)
  }

  private mutating func structDef() -> StructDef {
    assert(self.token?.kind == .some(.struct))
    self.advance() // struct

    let name = self.consumeNameOrFail()
    self.consumeOrFail(kind: .equal)
    let properties = self.properties()
    return StructDef(name: name, properties: properties)
  }

  private mutating func properties() -> [Property] {
    guard self.token?.kind == .leftParen else {
      return []
    }

    self.advance() // (
    var result = [Property]()

    while let token = self.token, token.kind != .rightParen {
      let property = self.property()
      result.append(property)

      if self.token?.kind == .some(.comma) {
        self.advance() // comma is optional
      }
    }

    self.consumeOrFail(kind: .rightParen)
    return result
  }

  private mutating func property() -> Property {
    var kind = PropertyKind.single

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
      self.fail("Invalid token kind. Expected: '\(kind)', got: '\(token.kind)'.")
    }

    self.advance()
  }

  private mutating func consumeNameOrFail() -> String {
    let token = self.tokenOrFail()

    guard case let TokenKind.name(value) = token.kind else {
      self.fail("Invalid token kind. Expected: 'name', got: '\(token.kind)'.")
    }

    self.advance()
    return self.aliases[value] ?? value
  }

  private mutating func getDoc() -> String? {
    guard let docToken = self.token, docToken.kind == .doc else {
      return nil
    }

    self.advance() // doc
    let token = self.tokenOrFail()

    guard case let TokenKind.string(value) = token.kind else {
      self.fail("Invalid token kind. Expected: 'string', got: '\(token.kind)'.")
    }

    self.advance() // value
    return value
  }

  private mutating func tokenOrFail() -> Token {
    guard let token = self.token else {
      self.fail("Trying to use eof token.")
    }

    return token
  }

  private func fail(_ message: String, location: SourceLocation? = nil) -> Never {
    print("\(location ?? self.location): \(message)")
    exit(1)
  }
}
