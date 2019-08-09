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

  public var nameColonType: String {
    return "\(self.name): \(self.type)"
  }

  public init(_ name:        String,
              type baseType: String,
              kind:          PropertyKind,
              doc:           String? = nil) {
    self.name = camelCase(name)
    self.type = getType(baseType: baseType, kind: kind)
    self.kind = kind
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
  case .many:     return "[" + type + "]"
  case .optional: return type + "?"
  }
}

/// https://docs.swift.org/swift-book/ReferenceManual/LexicalStructure.html
private let swiftKeywords = Set<String>([
  "associatedtype", "class", "deinit", "enum", "extension", "fileprivate",
  "func", "import", "init", "inout", "internal", "let", "open", "operator",
  "private", "protocol", "public", "static", "struct", "subscript", "typealias",
  "var,", "break", "case", "continue", "default", "defer", "do", "else",
  "fallthrough", "for", "guard", "if", "in", "repeat", "return", "switch",
  "where", "while", "as", "Any", "catch", "false", "is", "nil", "rethrows",
  "super", "self", "Self", "throw", "throws", "true", "try"
])

private func escaped(_ name: String) -> String {
  return swiftKeywords.contains(name) ? "`\(name)`" : name
}
