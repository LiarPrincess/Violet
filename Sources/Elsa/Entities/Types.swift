// MARK: - Type

struct Type: Equatable {

  let inFile: String
  let afterResolvingAlias: String

  init(name: String) {
    self.inFile = name
    self.afterResolvingAlias = name
  }

  init(inFile: String, afterAlias: Type?) {
    self.inFile = inFile
    self.afterResolvingAlias = afterAlias?.afterResolvingAlias ?? inFile
  }

  static func == (_ lhs: Self, rhs: Self) -> Bool {
    return lhs.afterResolvingAlias == rhs.afterResolvingAlias
  }
}

// MARK: - PropertyType

struct PropertyType {

  enum Modifier {
    case single
    case min1
    case many
    case optional
  }

  /// Original name in source file.
  let inFile: String
  /// Name after resolving alias, before applying modifier.
  let afterResolvingAlias: String
  /// Name after alias and modifier.
  ///
  /// (This is probably what you are looking for.)
  let value: String
  let modifier: Modifier

  init(type: Type, modifier: Modifier) {
    self.inFile = type.inFile
    self.afterResolvingAlias = type.afterResolvingAlias
    self.modifier = modifier
    self.value = Self.apply(modifier: modifier, type: type.afterResolvingAlias)
  }

  private static func apply(modifier: Modifier, type: String) -> String {
    switch modifier {
    case .single: return type
    case .min1: return "NonEmptyArray<" + type + ">"
    case .many: return "[" + type + "]"
    case .optional: return type + "?"
    }
  }
}

// MARK: - Base types

/// Base type/implemented protocols
struct BaseTypes {

  private let values: [Type]

  var first: Type? {
    return self.values.first
  }

  init(types: [Type]) {
    self.values = types
  }

  func contains(type: Type) -> Bool {
    return self.values.contains { $0 == type }
  }

  func contains(type: String) -> Bool {
    return self.values.contains { $0.afterResolvingAlias == type }
  }

  func joinWithColonSpaceBefore() -> String {
    if self.values.isEmpty {
      return ""
    }

    let strings = self.values.map { $0.afterResolvingAlias }
    return ": " + strings.joined(separator: ", ")
  }
}
