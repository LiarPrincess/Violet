// swiftlint:disable file_length
// swiftlint:disable pattern_matching_keywords

/// Convert: `Declaration` -> `String`
public struct Formatter {

  /// Formatter used to implement `description`.
  public static let forDescription = Formatter(
    newLineAfterAttribute: false,
    maxInitializerLength: 50
  )

  private let newLineAfterAttribute: Bool
  private let maxInitializerLength: Int?

  public init(newLineAfterAttribute: Bool,
              maxInitializerLength: Int?) {
    self.newLineAfterAttribute = newLineAfterAttribute
    self.maxInitializerLength = maxInitializerLength
  }

  // MARK: - Declaration

  public func format(_ node: Declaration) -> String {
    // This is a small hack, but what we want to do is to call a proper method
    // on 'self'. For this we will introduce auxiliary 'DeclarationVisitor' type.

    class Visitor: DeclarationVisitor {
      var result = ""
      let formatter: Formatter

      init(formatter: Formatter) {
        self.formatter = formatter
      }

      func visit(_ node: Enumeration) { self.result = self.formatter.format(node) }
      func visit(_ node: Structure) { self.result = self.formatter.format(node) }
      func visit(_ node: Class) { self.result = self.formatter.format(node) }
      func visit(_ node: Protocol) { self.result = self.formatter.format(node) }
      func visit(_ node: Typealias) { self.result = self.formatter.format(node) }
      func visit(_ node: Extension) { self.result = self.formatter.format(node) }
      func visit(_ node: Variable) { self.result = self.formatter.format(node) }
      func visit(_ node: Initializer) { self.result = self.formatter.format(node) }
      func visit(_ node: Function) { self.result = self.formatter.format(node) }
      func visit(_ node: Subscript) { self.result = self.formatter.format(node) }
      func visit(_ node: Operator) { self.result = self.formatter.format(node) }
      func visit(_ node: AssociatedType) { self.result = self.formatter.format(node) }
    }

    let visitor = Visitor(formatter: self)
    visitor.visit(node)
    assert(visitor.result.any)
    return visitor.result
  }

  // MARK: - Enumeration

  /// @available(macOS 10.15, *)
  /// private indirect enum Elsa<T>: Princess where T: Ice
  public func format(_ node: Enumeration) -> String {
    var result = ""
    result += self.formatWithNewLineAfterEach(node.attributes)
    result += self.formatWithSpaceAfter(node.accessModifier)
    result += self.formatWithSpaceAfter(node.modifiers)
    result += "enum "
    result += node.name
    result += self.formatInAngledBrackets(node.genericParameters)
    result += self.formatWithColonSpaceBefore(node.inheritance)
    result += self.formatWithSpaceBeforeWhere(node.genericRequirements)
    return result.trimmed
  }

  // MARK: - Struct

  /// @available(macOS 10.15, *)
  /// private struct Elsa<T>: Princess where T: Ice
  public func format(_ node: Structure) -> String {
    var result = ""
    result += self.formatWithNewLineAfterEach(node.attributes)
    result += self.formatWithSpaceAfter(node.accessModifier)
    result += self.formatWithSpaceAfter(node.modifiers)
    result += "struct "
    result += node.name
    result += self.formatInAngledBrackets(node.genericParameters)
    result += self.formatWithColonSpaceBefore(node.inheritance)
    result += self.formatWithSpaceBeforeWhere(node.genericRequirements)
    return result.trimmed
  }

  // MARK: - Class

  /// @available(macOS 10.15, *)
  /// private final class Elsa<T>: Princess where T: Ice
  public func format(_ node: Class) -> String {
    var result = ""
    result += self.formatWithNewLineAfterEach(node.attributes)
    result += self.formatWithSpaceAfter(node.accessModifier)
    result += self.formatWithSpaceAfter(node.modifiers)
    result += "class "
    result += node.name
    result += self.formatInAngledBrackets(node.genericParameters)
    result += self.formatWithColonSpaceBefore(node.inheritance)
    result += self.formatWithSpaceBeforeWhere(node.genericRequirements)
    return result.trimmed
  }

  // MARK: - Protocol

  /// @available(macOS 10.15, *)
  /// private protocol Elsa: Princess where Element == Ice
  public func format(_ node: Protocol) -> String {
    var result = ""
    result += self.formatWithNewLineAfterEach(node.attributes)
    result += self.formatWithSpaceAfter(node.accessModifier)
    result += self.formatWithSpaceAfter(node.modifiers)
    result += "protocol "
    result += node.name
    result += self.formatWithColonSpaceBefore(node.inheritance)
    result += self.formatWithSpaceBeforeWhere(node.genericRequirements)
    return result.trimmed
  }

  // MARK: - AssociatedType

  /// @available(macOS 10.15, *)
  /// associatedtype elsa: Princess
  public func format(_ node: AssociatedType) -> String {
    var result = ""
    result += self.formatWithNewLineAfterEach(node.attributes)
    result += self.formatWithSpaceAfter(node.accessModifier)
    result += self.formatWithSpaceAfter(node.modifiers)
    result += "associatedtype "
    result += node.name
    result += self.formatWithColonSpaceBefore(node.inheritance)
    result += self.formatWithSpaceEqualsSpaceBefore(node.initializer)
    result += self.formatWithSpaceBeforeWhere(node.genericRequirements)
    return result.trimmed
  }

  // MARK: - Typealias

  /// @available(macOS 10.15, *)
  /// private typealias Elsa<T> = Princess where T: Ice
  public func format(_ node: Typealias) -> String {
    var result = ""
    result += self.formatWithNewLineAfterEach(node.attributes)
    result += self.formatWithSpaceAfter(node.accessModifier)
    result += self.formatWithSpaceAfter(node.modifiers)
    result += "typealias "
    result += node.name
    result += self.formatInAngledBrackets(node.genericParameters)
    result += self.formatWithSpaceEqualsSpaceBefore(node.initializer)
    result += self.formatWithSpaceBeforeWhere(node.genericRequirements)
    return result.trimmed
  }

  // MARK: - Extension

  /// @available(macOS 10.15, *)
  /// private extension Elsa: Princess where T: Ice
  public func format(_ node: Extension) -> String {
    var result = ""
    result += self.formatWithNewLineAfterEach(node.attributes)
    result += self.formatWithSpaceAfter(node.accessModifier)
    result += self.formatWithSpaceAfter(node.modifiers)
    result += "extension "
    result += node.extendedType
    result += self.formatWithColonSpaceBefore(node.inheritance)
    result += self.formatWithSpaceBeforeWhere(node.genericRequirements)
    return result.trimmed
  }

  // MARK: - Variable

  /// @available(macOS 10.15, *)
  /// private let elsa: Princess = Princess()
  public func format(_ node: Variable) -> String {
    var result = ""
    result += self.formatWithNewLineAfterEach(node.attributes)
    result += self.formatWithSpaceAfter(node.accessModifiers)
    result += self.formatWithSpaceAfter(node.modifiers)
    result += node.keyword + " "
    result += node.name
    result += self.formatWithColonSpaceBefore(node.typeAnnotation)
    result += self.formatWithSpaceEqualsSpaceBefore(node.initializer)
    result += self.formatWithSpaceBefore(node.accessors)
    return result.trimmed
  }

  // MARK: - Initializer

  /// @available(macOS 10.15, *)
  /// private init?<T>(arg: T) throws where T: Ice
  public func format(_ node: Initializer) -> String {
    var result = ""
    result += self.formatWithNewLineAfterEach(node.attributes)
    result += self.formatWithSpaceAfter(node.accessModifier)
    result += self.formatWithSpaceAfter(node.modifiers)
    result += "init"

    if node.isOptional {
      result += "?"
    }

    result += self.formatInAngledBrackets(node.genericParameters)
    result += self.formatInBrackets(node.parameters)
    result += self.formatWithSpaceBefore(node.throws)
    result += self.formatWithSpaceBeforeWhere(node.genericRequirements)
    return result.trimmed
  }

  // MARK: - Function

  /// @available(macOS 10.15, *)
  /// private func elsa<T>(arg: T) throws -> Princess where T: Ice
  public func format(_ node: Function) -> String {
    var result = ""
    result += self.formatWithNewLineAfterEach(node.attributes)
    result += self.formatWithSpaceAfter(node.accessModifier)
    result += self.formatWithSpaceAfter(node.modifiers)
    result += "func "
    result += node.name
    result += self.formatInAngledBrackets(node.genericParameters)
    result += self.formatInBrackets(node.parameters)
    result += self.formatWithSpaceBefore(node.throws)
    result += self.formatWithArrowBefore(node.output)
    result += self.formatWithSpaceBeforeWhere(node.genericRequirements)
    return result.trimmed
  }

  // MARK: - Subscript

  /// @available(macOS 10.15, *)
  /// private subscript<T>(arg: T) -> Elsa where T: Ice
  public func format(_ node: Subscript) -> String {
    var result = ""
    result += self.formatWithNewLineAfterEach(node.attributes)
    result += self.formatWithSpaceAfter(node.accessModifiers)
    result += self.formatWithSpaceAfter(node.modifiers)
    result += "subscript"
    result += self.formatInAngledBrackets(node.genericParameters)
    result += self.formatInBrackets(node.indices)
    result += self.formatWithArrowBefore(node.result)
    result += self.formatWithSpaceBefore(node.accessors)
    result += self.formatWithSpaceBeforeWhere(node.genericRequirements)
    return result.trimmed
  }

  // MARK: - Operator

  /// @available(macOS 10.15, *)
  /// infix operator <+>: MultiplicationPrecedence
  public func format(_ node: Operator) -> String {
    var result = ""
    result += self.formatWithNewLineAfterEach(node.attributes)
    result += self.formatWithSpaceAfter(node.accessModifier)
    result += self.formatWithSpaceAfter(node.modifiers)

    result += node.kind.rawValue
    result += " operator "
    result += node.name

    if node.operatorPrecedenceAndTypes.any {
      result += ": "
      result += self.join(node.operatorPrecedenceAndTypes, separator: ", ")
    }

    return result.trimmed
  }

  // MARK: - Parameter

  internal func format(_ node: Parameter) -> String {
    var result = ""

    switch (node.firstName, node.secondName) {
    case (.none, .none): result += "?"
    case (.some(let fn), .none): result += fn
    case (.none, .some(let sn)): result += sn
    case (.some(let fn), .some(let sn)): result += "\(fn) \(sn)"
    }

    result += self.formatWithColonSpaceBefore(node.type)

    if node.isVariadic {
      assert(node.type != nil, "Variadic without type?")
      result += "..."
    }

    result += self.formatWithSpaceEqualsSpaceBefore(node.defaultValue)
    return result.trimmed
  }

  // MARK: - Helper - Attribues

  private func formatWithNewLineAfterEach(_ attributes: [Attribute]) -> String {
    if attributes.isEmpty {
      return ""
    }

    // Do not use 'self.join', we want that new line at the end!
    var result = ""
    let newLine = self.newLineAfterAttribute ? "\n" : " "

    for attribute in attributes {
      result += "@" + attribute.name + newLine
    }

    return result
  }

  // MARK: - Helper - Modifiers

  /// For example: `|private |`
  private func formatWithSpaceAfter(_ modifier: AccessModifier?) -> String {
    if let m = modifier {
      return m.rawValue + " "
    }

    return ""
  }

  /// For example: `|private |`
  private func formatWithSpaceAfter(_ modifiers: GetSetAccessModifiers?) -> String {
    var result = ""

    if let get = modifiers?.get {
      result += get.rawValue + " "
    }

    if let set = modifiers?.set {
      result += set.rawValue + "(set) "
    }

    return result
  }

  /// For example: `|final mutating |`
  private func formatWithSpaceAfter(_ modifiers: [Modifier]) -> String {
    var result = ""

    for modifier in modifiers {
      result += modifier.rawValue + " "
    }

    return result
  }

  // MARK: - Helper - Parameters

  /// For example: `|(name: String, movie: String)|`
  private func formatInBrackets(_ parameters: [Parameter]) -> String {
    let joined = self.join(parameters, separator: ", ") { self.format($0) }
    return "(" + joined + ")"
  }

  // MARK: - Helper - Generic

  /// For example: `|<T: Princess>|`
  private func formatInAngledBrackets(_ parameters: [GenericParameter]) -> String {
    if parameters.isEmpty {
      return ""
    }

    let joined = self.join(parameters, separator: ", ") { param -> String in
      let inheritedType = self.formatWithColonSpaceBefore(param.inheritedType)
      return param.name + inheritedType
    }

    return "<" + joined + ">"
  }

  private func formatWithSpaceBeforeWhere(_ requirements: [GenericRequirement]) -> String {
    if requirements.isEmpty {
      return ""
    }

    var result = " where "

    for (index, requirement) in requirements.enumerated() {
      result += self.format(requirement.leftType)

      switch requirement.kind {
      case .conformance:
        result += ": "
      case .sameType:
        result += " == "
      }

      result += self.format(requirement.rightType)

      let isLast = index == requirements.count - 1
      if !isLast {
        result += ", "
      }
    }

    return result
  }

  // MARK: - Helper - types

  private func format(_ type: Type) -> String {
    type.name
  }

  private func formatWithArrowBefore(_ type: Type?) -> String {
    guard let type = type else {
      return ""
    }

    return " -> " + self.format(type)
  }

  private func formatWithColonSpaceBefore(_ type: Type?) -> String {
    guard let type = type else {
      return ""
    }

    return ": " + self.format(type)
  }

  /// For example: `|: Princess, IceMage|`
  private func formatWithColonSpaceBefore(_ types: [InheritedType]) -> String {
    if types.isEmpty {
      return ""
    }

    let types = self.join(types, separator: ", ") { $0.typeName }
    return ": " + types
  }

  /// For example: `|: Princess|`
  private func formatWithColonSpaceBefore(_ node: TypeAnnotation?) -> String {
    guard let node = node else {
      return ""
    }

    return ": " + node.typeName
  }

  // MARK: - Helper - Initializers

  /// For example: `| = Princess|`
  private func formatWithSpaceEqualsSpaceBefore(_ node: TypeInitializer?) -> String {
    guard let node = node else {
      return ""
    }

    return " = " + node.value
  }

  /// For example: `| = 2|`
  private func formatWithSpaceEqualsSpaceBefore(_ node: VariableInitializer?) -> String {
    guard let node = node else {
      return ""
    }

    var value = node.value
    if let maxCount = maxInitializerLength, value.count > maxCount {
      let prefix = String(value.prefix(maxCount))

      // We have to close any unclosed " and """.
      // Otherwise syntax highlighters would go crazy.
      // Btw. we do not support #""" syntax and if we end with " then it may fail.
      var braces = ""
      let unclosedBraces = self.hasUnclosedBraces(string: prefix)
      if unclosedBraces.hasUnclosedTripleBraces {
        braces = "\"\"\""
      } else if unclosedBraces.hasUnclosedSingleBraces {
        braces = "\""
      }

      value = prefix + " <and so on…>" + braces
    }

    return " = " + value
  }

  private struct UnclosedBraces {
    fileprivate var hasUnclosedSingleBraces = false
    fileprivate var hasUnclosedTripleBraces = false
  }

  private func hasUnclosedBraces(string: String) -> UnclosedBraces {
    var result = UnclosedBraces()

    var index = string.startIndex
    while index != string.endIndex {
      let ch = string[index]
      guard ch == "\"" else {
        string.formIndex(after: &index)
        continue
      }

      // Is it escaped?
      let isEscaped: Bool = {
        let isInsideString = result.hasUnclosedSingleBraces || result.hasUnclosedTripleBraces
        guard isInsideString else { return false }

        if index == string.startIndex { return false }

        let indexBefore = string.index(before: index)
        let chBefore = string[indexBefore]
        return chBefore == "\\"
      }()

      if isEscaped {
        string.formIndex(after: &index)
        continue
      }

      // Deal with a """
      if let index2 = string.index(index, offsetBy: 2, limitedBy: string.endIndex) {
        let index1 = string.index(after: index)
        let ch1After = string[index1]
        let ch2After = string[index2]
        if ch1After == "\"" && ch2After == "\"" {
          result.hasUnclosedTripleBraces.toggle()
          index = index2
          string.formIndex(after: &index)
          continue
        }
      }

      // This is a "
      result.hasUnclosedSingleBraces.toggle()
      string.formIndex(after: &index)
    }

    return result
  }

  // MARK: - Helper - Accessor

  /// `| { get set }|`
  private func formatWithSpaceBefore(_ accessors: [Accessor]) -> String {
    if accessors.isEmpty {
      return ""
    }

    var result = " { "

    for (index, accessor) in accessors.enumerated() {
      assert(accessor.attributes.isEmpty)

      if let modifier = accessor.modifier {
        result += modifier.rawValue + " "
      }

      result += accessor.kind.rawValue

      let isLast = index == accessors.count - 1
      if !isLast {
        result += "; "
      }
    }

    result += " }"
    return result
  }

  // MARK: - Helper - Throwing

  /// For example: `| throws|`
  private func formatWithSpaceBefore(_ status: ThrowingStatus?) -> String {
    switch status {
    case .none: return ""
    case .some(.throws): return " throws"
    case .some(.rethrows): return " rethrows"
    }
  }

  // MARK: - Join

  private func join<T: CustomStringConvertible>(
    _ values: [T],
    separator: String
  ) -> String {
    // swiftlint:disable:next trailing_closure
    return self.join(values, separator: separator, transform: { $0 })
  }

  private func join<T, U: CustomStringConvertible>(
    _ values: [T],
    separator: String,
    transform: (T) -> U
  ) -> String {
    var result = ""

    for (index, element) in values.enumerated() {
      let transformed = transform(element)
      result += String(describing: transformed)

      let isLast = index == values.count - 1
      if !isLast {
        result += separator
      }
    }

    return result
  }
}
