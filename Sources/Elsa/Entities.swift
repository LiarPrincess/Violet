public enum Entity {
  case `enum`(EnumDef)
  case `struct`(StructDef)
  case `class`(ClassDef)
}

// MARK: - Product types

public protocol ProductType {
  /// Structure name
  var name: String { get }
  /// Implemented protocols
  var bases: [String] { get }
  /// Properties (I don't know what to say...)
  var properties: [ProductProperty] { get }
  /// Comment above type definition
  var doc: String? { get }
}

public struct StructDef: ProductType {
  public let name: String
  public let bases: [String]
  public let properties: [ProductProperty]
  public let doc: String?

  public init(_ name: String,
              bases: [String],
              properties: [ProductProperty],
              doc: String? = nil) {
    self.name = pascalCase(name)
    self.bases = bases
    self.properties = properties
    self.doc = fixDocNewLines(doc)
  }
}

public struct ClassDef: ProductType {
  public let name: String
  public let bases: [String]
  public let properties: [ProductProperty]
  public let doc: String?
  public let isFinal: Bool

  public init(_ name: String,
              bases: [String],
              properties: [ProductProperty],
              isFinal: Bool,
              doc: String? = nil) {
    self.name = pascalCase(name)
    self.bases = bases
    self.properties = properties
    self.isFinal = isFinal
    self.doc = fixDocNewLines(doc)
  }
}

public struct ProductProperty {
  /// Property name
  public let name: String
  /// Type of the property without `kind` modifiers.
  ///
  /// For example for `type = [Int]`:
  /// - baseType: `Int`
  /// - kind: `many`
  ///
  /// `baseType + kind = type`
  public let baseType: String
  /// `baseType` modifier.
  ///
  /// For example for `type = [Int]`:
  /// - baseType: `Int`
  /// - kind: `many`
  ///
  /// `baseType + kind = type`
  public let kind: PropertyKind
  /// Comment above definition
  public let doc: String?
  /// Underscore in initializer: `init(_ x: T)`
  public let underscoreInit: Bool

  /// Swift type
  ///
  /// `baseType + kind = type`
  public var type: String {
    return getType(baseType: self.baseType, kind: kind)
  }

  public var nameColonType: String {
    return "\(self.name): \(self.type)"
  }

  public init(_ name: String,
              type baseType: String,
              kind: PropertyKind,
              underscoreInit: Bool,
              doc: String? = nil) {
    self.name = camelCase(name)
    self.baseType = pascalCase(baseType)
    self.kind = kind
    self.underscoreInit = underscoreInit
    self.doc = fixDocNewLines(doc)
  }
}

// MARK: - Enum type

public struct EnumDef {
  /// Enum name
  public let name: String
  /// Implemented protocols
  public let bases: [String]
  public let cases: [EnumCaseDef]
  /// Use `indirect enum` instead of `enum`
  public let isIndirect: Bool
  /// Comment above definition
  public let doc: String?

  public init(_ name: String,
              bases: [String],
              cases: [EnumCaseDef],
              isIndirect: Bool = false,
              doc: String? = nil) {
    self.name = pascalCase(name)
    self.bases = bases
    self.cases = cases
    self.doc = doc
    self.isIndirect = isIndirect
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
  /// Type of the property without `kind` modifiers.
  ///
  /// For example for `type = [Int]`:
  /// - baseType: `Int`
  /// - kind: `many`
  ///
  /// `baseType + kind = type`
  public let baseType: String
  /// `baseType` modifier.
  ///
  /// For example for `type = [Int]`:
  /// - baseType: `Int`
  /// - kind: `many`
  ///
  /// `baseType + kind = type`
  public let kind: PropertyKind

  /// Swift type
  ///
  /// `baseType + kind = type`
  public var type: String {
    return getType(baseType: self.baseType, kind: kind)
  }

  public var nameColonType: String? {
    return self.name.map { "\($0): \(self.type)" }
  }

  public init(_ name: String?, type baseType: String, kind: PropertyKind) {
    self.name = name.map { camelCase($0) }
    self.baseType = pascalCase(baseType)
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

private func getType(baseType type: String, kind: PropertyKind) -> String {
  switch kind {
  case .single:   return type
  case .min1:     return "NonEmptyArray<" + type + ">"
  case .many:     return "[" + type + "]"
  case .optional: return type + "?"
  }
}

// MARK: - Helpers

private func fixDocNewLines(_ doc: String?) -> String? {
  return doc?.replacingOccurrences(of: "\\n", with: "\n")
}
