import Foundation

class Parser {

  private let lexer: Lexer
  /// Current token that we are looking at
  private var token: Token
  /// Documentation collected for `self.token`
  private var collectedDoc = [String]()
  /// Location of `self.token` (for error messages)
  private var location: SourceLocation

  private var result: SourceFile

  init(url: URL, lexer: Lexer) {
    self.lexer = lexer
    self.token = self.lexer.getToken()
    self.location = self.token.location
    self.result = SourceFile(url: url)
  }

  // MARK: - Parse

  func parse() -> SourceFile {
    while self.token.kind != .eof {
      switch self.token.kind {
      case .alias:
        let def = self.handleAlias()
        self.result.appendAlias(def)
      case .enum:
        let def = self.handleEnum()
        self.result.appendEnum(def)
      case .indirect:
        let def = self.handleEnum()
        self.result.appendIndirectEnum(def)
      case .struct:
        let def = self.handleProductType()
        self.result.appendStruct(def)
      case .class:
        let def = self.handleProductType()
        self.result.appendClass(def)
      case .final:
        let def = self.handleProductType()
        self.result.appendFinalClass(def)
      case .name(let value):
        self.fail("'\(value)' is not a valid entity declaration. " +
          "Expected @struct, @enum or @indirect.")
      default:
        self.fail("Unexpected '\(self.token.kind)'.")
      }
    }

    return self.result
  }

  // MARK: - Alias

  private func handleAlias() -> SourceFile.Alias {
    assert(self.token.kind == .alias)
    self.advance() // @alias

    let before = self.consumeNameOrFail()
    self.consumeOrFail(.equal)
    let after = self.consumeTypeNameOrFail()

    return SourceFile.Alias(before: before, after: after)
  }

  // MARK: - Enum

  private func handleEnum() -> Enumeration {
    assert(self.token.kind == .enum || self.token.kind == .indirect)

    let doc = self.useCollectedDoc()
    let isIndirect = self.token.kind == .indirect
    self.advance() // @enum, @indirect

    let name = self.consumeNameWithPossibleDotOrFail()
    let bases = self.consumeBaseTypes()
    self.consumeOrFail(.equal)

    var cases = [Enumeration.Case]()
    cases.append(self.handleEnumCase())

    while self.token.kind == .or {
      self.advance() // |
      cases.append(self.handleEnumCase())
    }

    return Enumeration(name: name.name,
                       bases: bases,
                       cases: cases,
                       isIndirect: isIndirect,
                       enclosingTypeName: name.enclosingTypeName,
                       doc: doc)
  }

  private func handleEnumCase() -> Enumeration.Case {
    let doc = self.useCollectedDoc()
    let name = self.consumeNameOrFail()
    let properties = self.handleEnumCaseProperties()
    return Enumeration.Case(name, properties: properties, doc: doc)
  }

  private func handleEnumCaseProperties() -> [Enumeration.CaseProperty] {
    // enum properties are optional
    guard self.token.kind == .leftParen else {
      return []
    }

    self.advance() // (
    var result = [Enumeration.CaseProperty]()

    while self.token.kind != .rightParen {
      let typeString = self.consumeNameOrFail()
      let typeAlias = self.resolveAlias(name: typeString)
      let typeName = Type(inFile: typeString, afterAlias: typeAlias)

      let modifier = self.consumePropertyModifier()
      let type = PropertyType(type: typeName, modifier: modifier)

      // 'name' is optional
      var name: String?
      if case let Token.Kind.name(nameValue) = self.token.kind {
        self.advance() // name
        name = nameValue
      }

      let property = Enumeration.CaseProperty(name, type: type)
      result.append(property)

      if self.token.kind != .rightParen {
        self.consumeOrFail(.comma)
      }
    }

    self.consumeOrFail(.rightParen)
    return result
  }

  // MARK: - Product type

  private func handleProductType() -> ProductType {
    let tokenKind = self.token.kind
    assert(tokenKind == .struct || tokenKind == .class || tokenKind == .final)

    let doc = self.useCollectedDoc()
    self.advance() // @struct

    let name = self.consumeNameWithPossibleDotOrFail()
    let bases = self.consumeBaseTypes()
    self.consumeOrFail(.equal)
    let properties = self.handleProductTypeProperties()

    return ProductType(name: name.name,
                       bases: bases,
                       properties: properties,
                       enclosingTypeName: name.enclosingTypeName,
                       doc: doc)
  }

  private func handleProductTypeProperties() -> [ProductType.Property] {
    self.consumeOrFail(.leftParen)

    var result = [ProductType.Property]()
    while self.token.kind != .rightParen {
      let doc = self.useCollectedDoc()

      let typeString = self.consumeNameOrFail()
      let typeAlias = self.resolveAlias(name: typeString)
      let typeName = Type(inFile: typeString, afterAlias: typeAlias)

      let modifier = self.consumePropertyModifier()
      let type = PropertyType(type: typeName, modifier: modifier)

      let name = self.consumeNameOrFail()
      let hasUnderscoreInit = self.consumeIfEqual(kind: .underscoreInit)

      let property = ProductType.Property(name,
                                          type: type,
                                          hasUnderscoreInInit: hasUnderscoreInit,
                                          doc: doc)

      result.append(property)

      if self.token.kind != .rightParen {
        self.consumeOrFail(.comma)
      }
    }

    self.consumeOrFail(.rightParen)
    return result
  }

  // MARK: - Advance

  @discardableResult
  private func advance() -> Token {
    // Should not happen if we wrote everything else correctly
    if self.token.kind == .eof {
      self.fail("Trying to advance past eof.")
    }

    self.advanceToken()
    self.collectDoc()
    return self.token
  }

  private func advanceToken() {
    self.token = self.lexer.getToken()
    self.location = self.token.location
  }

  // MARK: - Doc

  private func collectDoc() {
    var result = [String]()

    while case let Token.Kind.doc(value) = self.token.kind {
      result.append(value)
      self.advanceToken()
    }

    if !result.isEmpty {
      self.collectedDoc = result
    }
  }

  private func useCollectedDoc() -> Doc? {
    let lines = self.collectedDoc
    self.collectedDoc = []
    return lines.isEmpty ? nil : Doc(lines: lines)
  }

  // MARK: - Consume

  private func consumeIfEqual(kind: Token.Kind) -> Bool {
    if self.token.kind == kind {
      self.advance()
      return true
    }

    return false
  }

  private func consumeOrFail(_ kind: Token.Kind) {
    guard self.token.kind == kind else {
      self.fail("Invalid token. Expected: '\(kind)', got: '\(self.token.kind)'.")
    }

    self.advance()
  }

  private func consumeNameOrFail() -> String {
    guard case let .name(name) = self.token.kind else {
      self.fail("Invalid token. Expected: 'name', got: '\(self.token.kind)'.")
    }

    self.advance() // name
    return name
  }

  private func consumeTypeNameOrFail() -> Type {
    let name = self.consumeNameOrFail()
    let alias = self.resolveAlias(name: name)
    return Type(inFile: name, afterAlias: alias)
  }

  private func resolveAlias(name: String) -> Type? {
    let alias = self.result.aliases.first { $0.before == name }
    return alias?.after
  }

  private func consumeBaseTypes() -> BaseTypes {
    guard self.consumeIfEqual(kind: .colon) else {
      return BaseTypes(types: [])
    }

    var result = [Type]()
    result.append(self.consumeTypeNameOrFail())

    while self.token.kind == .comma {
      self.advance() // ,
      result.append(self.consumeTypeNameOrFail())
    }

    return BaseTypes(types: result)
  }

  private func consumePropertyModifier() -> PropertyType.Modifier {
    if self.consumeIfEqual(kind: .star) { return .many }
    if self.consumeIfEqual(kind: .option) { return .optional }
    if self.consumeIfEqual(kind: .plus) { return .min1 }
    return .single
  }

  private struct NameWithPossibleDot {
    fileprivate let name: Type
    fileprivate let enclosingTypeName: Type?
  }

  private func consumeNameWithPossibleDotOrFail() -> NameWithPossibleDot {
    let nameWithPossibleDot = self.consumeNameOrFail()

    guard let dotIndex = nameWithPossibleDot.lastIndex(of: ".") else {
      let noDot = nameWithPossibleDot
      let alias = self.resolveAlias(name: noDot)
      let type = Type(inFile: noDot, afterAlias: alias)
      return NameWithPossibleDot(name: type, enclosingTypeName: nil)
    }

    let withDot = nameWithPossibleDot
    assert(dotIndex != withDot.endIndex)

    // Handle before '.'
    let parentString = String(withDot[..<dotIndex])
    let parentAlias = self.resolveAlias(name: parentString)
    let parentType = Type(inFile: parentString, afterAlias: parentAlias)

    // Handle after '.'
    let nameStart = withDot.index(after: dotIndex)
    let nameString = String(withDot[nameStart...])
    let nameAlias = self.resolveAlias(name: nameString)
    let name = Type(inFile: nameString, afterAlias: nameAlias)

    return NameWithPossibleDot(name: name, enclosingTypeName: parentType)
  }

  // MARK: - Fail

  private func fail(_ message: String, location: SourceLocation? = nil) -> Never {
    trap("\(location ?? self.location): \(message)")
  }
}
