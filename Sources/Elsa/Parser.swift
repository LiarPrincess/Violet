import Foundation

internal struct Parser {

  private var lexer: Lexer
  private var token: Token
  private var location = SourceLocation.start

  private var aliases = [String:String]()
  private var pendingEntityDoc: String? = nil

  internal init(lexer: Lexer) {
    self.lexer = lexer
    self.token = self.lexer.getToken()
  }

  // MARK: - Traversal

  @discardableResult
  private mutating func advance() -> Token {
    // should not happen if we wrote everything else correctly
    if self.token.kind == .eof {
      self.fail("Trying to advance past eof.")
    }

    self.token = self.lexer.getToken()
    self.location = token.location
    return self.token
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

      case .doc:
        self.pendingEntityDoc = self.consumeDocIfAny()

      case .name(let value):
        self.fail("'\(value)' is not a valid entity declaration (missing '@'?).")
      default:
        self.fail("Invalid token '\(token.kind)'.")
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

    let doc = self.useEntityDoc()
    return EnumDef(name, cases: cases, indirect: indirect, doc: doc)
  }

  private mutating func enumCaseDef() -> EnumCaseDef {
    let name = self.consumeNameOrFail()
    let properties = self.enumProperties()
    let doc = self.consumeDocIfAny()
    return EnumCaseDef(name, properties: properties, doc: doc)
  }

  // MARK: - Struct

  private mutating func structDef() -> StructDef {
    assert(self.token.kind == .struct)
    self.advance() // struct

    let name = self.consumeNameOrFail()
    self.consumeOrFail(.equal)
    let properties = self.structProperties()

    let doc = self.useEntityDoc()
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

      let type = self.consumeNameOrFail()
      if self.consumeIfEqual(kind: .star) { kind = .many }
      if self.consumeIfEqual(kind: .option) { kind = .optional }
      let name = self.consumeNameOrFail()
      let doc = self.consumeDocIfAny()

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

  private mutating func useEntityDoc() -> String? {
    let doc = self.pendingEntityDoc
    self.pendingEntityDoc = nil
    return doc
  }

  private mutating func consumeIfEqual(kind: TokenKind) -> Bool {
    if self.token.kind == kind {
      self.advance()
      return true
    }

    return false
  }

  private mutating func consumeOrFail(_ kind: TokenKind) {
    guard self.token.kind == kind else {
      self.fail("Invalid token kind. Expected: '\(kind)', got: '\(token.kind)'.")
    }

    self.advance()
  }

  private mutating func consumeNameOrFail() -> String {
    guard case let .name(value) = self.token.kind else {
      self.fail("Invalid token kind. Expected: 'name', got: '\(self.token.kind)'.")
    }

    self.advance()
    return self.aliases[value] ?? value
  }

  private mutating func consumeDocIfAny() -> String? {
    guard self.consumeIfEqual(kind: .doc) else {
      return nil
    }

    guard case let .string(value) = self.token.kind else {
      self.fail("Invalid token kind. Expected: 'string', got: '\(self.token.kind)'.")
    }

    self.advance() // value
    return value
  }

  private func fail(_ message: String, location: SourceLocation? = nil) -> Never {
    print("\(location ?? self.location): \(message)")
    exit(EXIT_FAILURE)
  }
}
