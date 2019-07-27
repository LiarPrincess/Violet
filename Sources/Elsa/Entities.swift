// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

public enum Entity {
  case `enum`(EnumDef)
  case `struct`(StructDef)
}

// MARK: - Struct

public struct StructDef {
  public let name: String
  public let properties: [Property]

  public init(name: String, properties: [Property]) {
    self.name = pascalCase(name)
    self.properties = properties
  }
}

// MARK: - Enum

public struct EnumDef {
  public let name: String
  public let cases: [EnumCaseDef]
  public let indirect: Bool

  public init(name: String, cases: [EnumCaseDef], indirect: Bool = false) {
    self.name = pascalCase(name)
    self.cases = cases
    self.indirect = indirect
  }
}

public struct EnumCaseDef {
  public let name: String
  public let properties: [Property]
  public let doc: String?

  public var escapedName: String { return escaped(self.name) }

  public init(name: String, properties: [Property], doc: String?) {
    self.name = camelCase(name)
    self.properties = properties
    self.doc = doc?.replacingOccurrences(of: "\\n", with: "\n")
  }
}

// MARK: - Property

public enum PropertyKind {
  case single
  case many
  case optional
}

public struct Property {
  public let name: String?
  public let type: String
  public let kind: PropertyKind

  public init(name: String?, type baseType: String, kind: PropertyKind) {
    self.name = name.map { camelCase($0) }
    self.type = getType(baseType: baseType, kind: kind)
    self.kind = kind
  }
}

// MARK: - Helpers

private func getType(baseType: String, kind: PropertyKind) -> String {
  switch kind {
  case .single:   return baseType
  case .many:     return "[" + baseType + "]"
  case .optional: return baseType + "?"
  }
}

private func pascalCase(_ s: String) -> String {
  let first = s.first?.uppercased() ?? ""
  return first + s.dropFirst()
}

private func camelCase(_ s: String) -> String {
  let first = s.first?.lowercased() ?? ""
  return first + s.dropFirst()
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
