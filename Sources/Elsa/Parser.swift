import Foundation

internal struct Parser {

  private var lexer: Lexer
  private var token: Token
  private var location = SourceLocation.start

  private var aliases = [String:String]()
  private var collectedDoc: String? = nil

  internal init(lexer: Lexer) {
    self.lexer = lexer
    self.token = self.lexer.getToken()
    self.location = self.token.location
  }

  // MARK: - Traversal

  @discardableResult
  private mutating func advance() -> Token {
    // should not happen if we wrote everything else correctly
    if self.token.kind == .eof {
      self.fail("Trying to advance past eof.")
    }

    self.advanceToken()
    self.collectDoc()
    return self.token
  }

  private mutating func advanceToken() {
    self.token = self.lexer.getToken()
    self.location = token.location
  }

  private mutating func collectDoc() {
    var result = ""

    while case let TokenKind.doc(value) = self.token.kind {
      if !result.isEmpty {
        result.append("\n")
      }
      result.append(value)
      self.advanceToken()
    }

    if !result.isEmpty {
      self.collectedDoc = result
    }
  }

  private mutating func useCollectedDoc() -> String? {
    let doc = self.collectedDoc
    self.collectedDoc = nil
    return doc
  }

  // MARK: - Parse

  internal mutating func parse() -> [Entity] {
    var result = [Entity]()

    while self.token.kind != .eof {
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
        self.fail("'\(value)' is not a valid entity declaration. " +
                  "Expected @struct, @enum or @indirect.")
      default:
        self.fail("Unexpected '\(token.kind)'.")
      }
    }

    return result
  }

  // MARK: - Alias

  private mutating func alias() {
    assert(self.token.kind == .alias)
    self.advance() // @alias

    let oldName = self.consumeNameOrFail()
    self.consumeOrFail(.equal)
    let newName = self.consumeNameOrFail()

    self.aliases[oldName] = newName
  }

  // MARK: - Enum

  private mutating func enumDef() -> EnumDef {
    assert(self.token.kind == .enum || self.token.kind == .indirect)

    let doc = self.useCollectedDoc()
    let indirect = self.token.kind == .indirect
    self.advance() // @enum, @indirect

    let name = self.consumeNameOrFail()
    self.consumeOrFail(.equal)

    var cases = [EnumCaseDef]()
    cases.append(self.enumCaseDef())

    while self.token.kind == .or {
      self.advance() // |
      cases.append(self.enumCaseDef())
    }

    return EnumDef(name, cases: cases, indirect: indirect, doc: doc)
  }

  private mutating func enumCaseDef() -> EnumCaseDef {
    let doc = self.useCollectedDoc()
    let name = self.consumeNameOrFail()
    let properties = self.enumProperties()
    return EnumCaseDef(name, properties: properties, doc: doc)
  }

  // MARK: - Struct

  private mutating func structDef() -> StructDef {
    assert(self.token.kind == .struct)

    let doc = self.useCollectedDoc()
    self.advance() // struct

    let name = self.consumeNameOrFail()
    self.consumeOrFail(.equal)
    let properties = self.structProperties()

    return StructDef(name, properties: properties, doc: doc)
  }

  // MARK: - Properties

  private mutating func enumProperties() -> [EnumCaseProperty] {
    // enum properties are optional
    guard self.token.kind == .leftParen else {
      return []
    }

    self.advance() // (
    var result = [EnumCaseProperty]()

    while self.token.kind != .rightParen {
      var kind = PropertyKind.single

      let type = self.consumeNameOrFail()
      if self.consumeIfEqual(kind: .star) { kind = .many }
      if self.consumeIfEqual(kind: .option) { kind = .optional }

      // name is optional
      var name: String? = nil
      if case let TokenKind.name(nameValue) = self.token.kind {
        self.advance() // name
        name = nameValue
      }

      let property = EnumCaseProperty(name, type: type, kind: kind)
      result.append(property)

      if self.token.kind != .rightParen {
        self.consumeOrFail(.comma)
      }
    }

    self.consumeOrFail(.rightParen)
    return result
  }

  private mutating func structProperties() -> [StructProperty] {
    self.consumeOrFail(.leftParen)

    var result = [StructProperty]()
    while self.token.kind != .rightParen {
      var kind = PropertyKind.single

      let doc = self.useCollectedDoc()
      let type = self.consumeNameOrFail()
      if self.consumeIfEqual(kind: .star) { kind = .many }
      if self.consumeIfEqual(kind: .option) { kind = .optional }
      let name = self.consumeNameOrFail()

      let property = StructProperty(name, type: type, kind: kind, doc: doc)
      result.append(property)

      if self.token.kind != .rightParen {
        self.consumeOrFail(.comma)
      }
    }

    self.consumeOrFail(.rightParen)
    return result
  }

  // MARK: - Helpers

  private mutating func consumeIfEqual(kind: TokenKind) -> Bool {
    if self.token.kind == kind {
      self.advance()
      return true
    }

    return false
  }

  private mutating func consumeOrFail(_ kind: TokenKind) {
    guard self.token.kind == kind else {
      self.fail("Invalid token. Expected: '\(kind)', got: '\(token.kind)'.")
    }

    self.advance()
  }

  private mutating func consumeNameOrFail() -> String {
    guard case let .name(value) = self.token.kind else {
      self.fail("Invalid token. Expected: 'name', got: '\(self.token.kind)'.")
    }

    self.advance()
    return self.aliases[value] ?? value
  }

  // MARK: - Fail

  private func fail(_ message: String, location: SourceLocation? = nil) -> Never {
    print("\(location ?? self.location): \(message)")
    exit(EXIT_FAILURE)
  }
}
