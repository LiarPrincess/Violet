import Foundation

internal class Parser {

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
  private func advance() -> Token {
    // should not happen if we wrote everything else correctly
    if self.token.kind == .eof {
      self.fail("Trying to advance past eof.")
    }

    self.advanceToken()
    self.collectDoc()
    return self.token
  }

  private func advanceToken() {
    self.token = self.lexer.getToken()
    self.location = token.location
  }

  private func collectDoc() {
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

  private func useCollectedDoc() -> String? {
    let doc = self.collectedDoc
    self.collectedDoc = nil
    return doc
  }

  // MARK: - Parse

  internal func parse() -> [Entity] {
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

  private func alias() {
    assert(self.token.kind == .alias)
    self.advance() // @alias

    let oldName = self.consumeNameOrFail()
    self.consumeOrFail(.equal)
    let newName = self.consumeNameOrFail()

    self.aliases[oldName] = newName
  }

  // MARK: - Enum

  private func enumDef() -> EnumDef {
    assert(self.token.kind == .enum || self.token.kind == .indirect)

    let doc = self.useCollectedDoc()
    let indirect = self.token.kind == .indirect
    self.advance() // @enum, @indirect

    let name = self.consumeNameOrFail()
    let bases = self.consumeProtocols()
    self.consumeOrFail(.equal)

    var cases = [EnumCaseDef]()
    cases.append(self.enumCaseDef())

    while self.token.kind == .or {
      self.advance() // |
      cases.append(self.enumCaseDef())
    }

    return EnumDef(name, bases: bases, cases: cases, indirect: indirect, doc: doc)
  }

  private func enumCaseDef() -> EnumCaseDef {
    let doc = self.useCollectedDoc()
    let name = self.consumeNameOrFail()
    let properties = self.enumProperties()
    return EnumCaseDef(name, properties: properties, doc: doc)
  }

  // MARK: - Struct

  private func structDef() -> StructDef {
    assert(self.token.kind == .struct)

    let doc = self.useCollectedDoc()
    self.advance() // struct

    let name = self.consumeNameOrFail()
    let bases = self.consumeProtocols()
    self.consumeOrFail(.equal)
    let properties = self.structProperties()

    return StructDef(name, bases: bases, properties: properties, doc: doc)
  }

  // MARK: - Properties

  private func enumProperties() -> [EnumCaseProperty] {
    // enum properties are optional
    guard self.token.kind == .leftParen else {
      return []
    }

    self.advance() // (
    var result = [EnumCaseProperty]()

    while self.token.kind != .rightParen {
      let type = self.consumeNameOrFail()
      let kind = self.consumePropertyKind()

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

  private func structProperties() -> [StructProperty] {
    self.consumeOrFail(.leftParen)

    var result = [StructProperty]()
    while self.token.kind != .rightParen {
      let doc = self.useCollectedDoc()
      let type = self.consumeNameOrFail()
      let kind = self.consumePropertyKind()
      let name = self.consumeNameOrFail()
      let underscoreInit = self.consumeIfEqual(kind: .underscoreInit)

      let property = StructProperty(name,
                                    type: type,
                                    kind: kind,
                                    underscoreInit: underscoreInit,
                                    doc: doc)
      result.append(property)

      if self.token.kind != .rightParen {
        self.consumeOrFail(.comma)
      }
    }

    self.consumeOrFail(.rightParen)
    return result
  }

  // MARK: - Helpers

  private func consumeIfEqual(kind: TokenKind) -> Bool {
    if self.token.kind == kind {
      self.advance()
      return true
    }

    return false
  }

  private func consumeOrFail(_ kind: TokenKind) {
    guard self.token.kind == kind else {
      self.fail("Invalid token. Expected: '\(kind)', got: '\(token.kind)'.")
    }

    self.advance()
  }

  private func consumeNameOrFail() -> String {
    guard case let .name(value) = self.token.kind else {
      self.fail("Invalid token. Expected: 'name', got: '\(self.token.kind)'.")
    }

    self.advance()
    return self.aliases[value] ?? value
  }

  private func consumePropertyKind() -> PropertyKind {
    if self.consumeIfEqual(kind: .star)   { return .many }
    if self.consumeIfEqual(kind: .option) { return .optional }
    if self.consumeIfEqual(kind: .plus)   { return .min1 }
    return .single
  }

  private func consumeProtocols() -> [String] {
    guard self.consumeIfEqual(kind: .colon) else {
      return []
    }

    var result = [String]()
    result.append(self.consumeNameOrFail())

    while self.token.kind == .comma {
      self.advance() // ,
      result.append(self.consumeNameOrFail())
    }

    return result
  }


  // MARK: - Fail

  private func fail(_ message: String, location: SourceLocation? = nil) -> Never {
    print("\(location ?? self.location): \(message)")
    exit(EXIT_FAILURE)
  }
}
