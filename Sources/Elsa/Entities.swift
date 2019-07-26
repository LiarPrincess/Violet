// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

internal enum Entity {
  case `enum`(EnumDef)
  case `struct`(StructDef)
}

internal struct StructDef {
  internal let name: String
  internal let properties: [Property]

  internal init(name: String, properties: [Property]) {
    self.name = pascalCase(name)
    self.properties = properties
  }
}

internal struct EnumDef {
  internal let name: String
  internal let cases: [EnumCaseDef]
  internal let indirect: Bool

  internal init(name: String, cases: [EnumCaseDef], indirect: Bool = false) {
    self.name = pascalCase(name)
    self.cases = cases
    self.indirect = indirect
  }
}

internal struct EnumCaseDef {
  internal let name: String
  internal let properties: [Property]
  internal let doc: String?

  internal var escapedName: String { return escaped(self.name) }

  internal init(name: String, properties: [Property], doc: String?) {
    self.name = camelCase(name)
    self.properties = properties
    self.doc = doc?.replacingOccurrences(of: "\\n", with: "\n")
  }
}

internal enum PropertyKind {
  case single
  case many
  case optional
}

internal struct Property {
  internal let name: String
  internal let type: String
  internal let kind: PropertyKind

  internal init(name: String, type baseType: String, kind: PropertyKind) {
    self.name = camelCase(name)
    self.type = Property.getType(baseType: baseType, kind: kind)
    self.kind = kind
  }

  internal var nameColonType: String {
    return "\(self.name): \(self.type)"
  }

  private static func getType(baseType: String, kind: PropertyKind) -> String {
    switch kind {
    case .single:   return baseType
    case .many:     return "[" + baseType + "]"
    case .optional: return baseType + "?"
    }
  }
}

// MARK: - Processing

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
