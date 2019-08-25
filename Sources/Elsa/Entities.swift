public enum Entity {
  case `enum`(EnumDef)
  case `struct`(StructDef)
}

// MARK: - Struct

public struct StructDef {
  /// Structure name
  public let name: String
  /// Implemented protocols
  public let bases: [String]
  public let properties: [StructProperty]
  /// Comment above definition
  public let doc: String?

  public init(_ name:     String,
              bases:      [String],
              properties: [StructProperty],
              doc:        String? = nil) {
    self.name = pascalCase(name)
    self.bases = bases
    self.properties = properties
    self.doc = fixDocNewLines(doc)
  }
}

public struct StructProperty {
  /// Property name
  public let name: String
  /// Type of the property
  public let type: String
  /// `baseType` modifier. `baseType + kind = type`
  public let kind: PropertyKind
  /// Type of the property excluding `kind` modifiers.
  /// For example for `type = [Int]`, `baseType = Int`.
  /// `baseType + kind = type`
  public let baseType: String
  /// Comment above definition
  public let doc: String?
  /// Underscore in initializer: `init(_ x: T)`
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
    self.baseType = pascalCase(baseType)
    self.type = getType(baseType: pascalCase(baseType), kind: kind)
    self.kind = kind
    self.underscoreInit = underscoreInit
    self.doc = fixDocNewLines(doc)
  }
}

// MARK: - Enum

public struct EnumDef {
  /// Enum name
  public let name: String
  /// Implemented protocols
  public let bases: [String]
  public let cases: [EnumCaseDef]
  /// Use `indirect enum` instead of `enum`
  public let indirect: Bool
  /// Comment above definition
  public let doc: String?

  public init(_ name:   String,
              bases:    [String],
              cases:    [EnumCaseDef],
              indirect: Bool    = false,
              doc:      String? = nil) {
    self.name = pascalCase(name)
    self.bases = bases
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
  /// Type of the property
  public let type: String
  /// `baseType` modifier. `baseType + kind = type`
  public let kind: PropertyKind
  /// Type of the property excluding `kind` modifiers.
  /// For example for `type = [Int]`, `baseType = Int`.
  /// `baseType + kind = type`
  public let baseType: String

  public var nameColonType: String? {
    return self.name.map { "\($0): \(self.type)" }
  }

  public init(_ name: String?, type baseType: String, kind: PropertyKind) {
    self.name = name.map { camelCase($0) }
    self.baseType = pascalCase(baseType)
    self.type = getType(baseType: pascalCase(baseType), kind: kind)
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

private func getType(baseType type: String, kind: PropertyKind) -> String {
  switch kind {
  case .single:   return type
  case .min1:     return "NonEmptyArray<" + type + ">"
  case .many:     return "[" + type + "]"
  case .optional: return type + "?"
  }
}
