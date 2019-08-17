public enum Entity {
  case `enum`(EnumDef)
  case `struct`(StructDef)
}

// MARK: - Struct

public struct StructDef {
  public let name: String
  public let properties: [StructProperty]
  public let doc: String?

  public init(_ name:     String,
              properties: [StructProperty],
              doc:        String? = nil) {
    self.name = pascalCase(name)
    self.properties = properties
    self.doc = fixDocNewLines(doc)
  }
}

public struct StructProperty {
  public let name: String
  public let type: String
  public let kind: PropertyKind
  public let doc:  String?
  public let underscoreInit: Bool

  public var nameColonType: String {
    return "\(self.name): \(self.type)"
  }

  public init(_ name:         String,
              type baseType:  String,
              kind:           PropertyKind,
              underscoreInit: Bool,
              doc:            String? = nil) {
    self.name = camelCase(name)
    self.type = getType(baseType: baseType, kind: kind)
    self.kind = kind
    self.underscoreInit = underscoreInit
    self.doc = fixDocNewLines(doc)
  }
}

// MARK: - Enum

public struct EnumDef {
  public let name: String
  public let cases: [EnumCaseDef]
  public let indirect: Bool
  public let doc: String?

  public init(_ name:   String,
              cases:    [EnumCaseDef],
              indirect: Bool    = false,
              doc:      String? = nil) {
    self.name = pascalCase(name)
    self.cases = cases
    self.doc = doc
    self.indirect = indirect
  }
}

public struct EnumCaseDef {
  public let name: String
  public let properties: [EnumCaseProperty]
  public let doc: String?

  public var escapedName: String { return escaped(self.name) }

  public init(_ name: String, properties: [EnumCaseProperty], doc: String?) {
    self.name = camelCase(name)
    self.properties = properties
    self.doc = fixDocNewLines(doc)
  }
}

public struct EnumCaseProperty {
  public let name: String?
  public let type: String
  public let kind: PropertyKind

  public var nameColonType: String? {
    return self.name.map { "\($0): \(self.type)" }
  }

  public init(_ name: String?, type baseType: String, kind: PropertyKind) {
    self.name = name.map { camelCase($0) }
    self.type = getType(baseType: baseType, kind: kind)
    self.kind = kind
  }
}

// MARK: - Property

public enum PropertyKind {
  case single
  case min1
  case many
  case optional
}

// MARK: - Helpers

private func fixDocNewLines(_ doc: String?) -> String? {
  return doc?.replacingOccurrences(of: "\\n", with: "\n")
}

private func getType(baseType: String, kind: PropertyKind) -> String {
  let type = pascalCase(baseType)
  switch kind {
  case .single:   return type
  case .min1:     return "NonEmptyArray<" + type + ">"
  case .many:     return "[" + type + "]"
  case .optional: return type + "?"
  }
}
