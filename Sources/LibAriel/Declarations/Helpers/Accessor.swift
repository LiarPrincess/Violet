import SwiftSyntax

public struct Accessor {

  public enum Kind: String {
    case get
    case set
    case _read
    case _modify
  }

  public enum Modifier: String {
    case nonmutating
  }

  public let kind: Kind
  public let modifier: Modifier?
  public let attributes: [Attribute]

  public init(kind: Kind, modifier: Modifier?, attributes: [Attribute]) {
    self.kind = kind
    self.modifier = modifier
    self.attributes = attributes
  }

  // MARK: - Init many

  internal static func initMany(_ node: Syntax) -> [Accessor] {
    let children = Array(node.children)

    // Something like:
    // `var description: String { return "" }`
    if let accessor = Self.parseCodeBlockItemListInBraces(children: children) {
      return [accessor]
    }

    // Something like (in protocols):
    // `var description: String { get }`
    if let accessors = Self.parseAccessorDeclsInBraces(children: children) {
      return accessors
    }

    trap("Unknown variable accessor shape")
  }

  // MARK: - var description: String { return "" }

  private static func parseCodeBlockItemListInBraces(children: [Syntax]) -> Accessor? {
    guard children.count == 3 else {
      return nil
    }

    guard Self.isSurroundedByBraces(children) else {
      return nil
    }

    let middleChild = children[1]
    let isCodeBlockItemList = CodeBlockItemListSyntax(middleChild) != nil
    guard isCodeBlockItemList else {
      return nil
    }

    return Accessor(kind: .get, modifier: nil, attributes: [])
  }

  // MARK: - var description: String { get }

  // swiftlint:disable:next discouraged_optional_collection
  private static func parseAccessorDeclsInBraces(children: [Syntax]) -> [Accessor]? {
    guard children.count == 3 else {
      return nil
    }

    guard Self.isSurroundedByBraces(children) else {
      return nil
    }

    let middleChild = children[1]
    guard let accessorList = AccessorListSyntax(middleChild) else {
      return nil
    }

    var result = [Accessor]()
    for node in accessorList {
      let kindString = node.accessorKind.text.trimmed

      guard let kind = Accessor.Kind(rawValue: kindString) else {
        trap("Unknown accessor kind: '\(kindString)'")
      }

      assert(!result.contains { $0.kind == kind })

      let modifier = Self.parseModifier(node.modifier)
      let attributes = Self.parseAttributes(node.attributes)
      let accessor = Accessor(kind: kind, modifier: modifier, attributes: attributes)
      result.append(accessor)
    }

    return result
  }

  private static func parseModifier(_ node: DeclModifierSyntax?) -> Modifier? {
    guard let node = node else {
      return nil
    }

    let parsed = ParseModifiers.single(node)

    switch parsed {
    case .modifier(.nonmutating):
      return .nonmutating
    case .accessModifier,
         .setAccessModifier,
         .operatorKind,
         .modifier:
      trap("Invalid accessor modifier: '\(node)'")
    }
  }

  private static func parseAttributes(_ list: AttributeListSyntax?) -> [Attribute] {
    return list?.map(Attribute.init) ?? []
  }

  // MARK: - Helpers

  private static func isSurroundedByBraces(_ children: [Syntax]) -> Bool {
    assert(children.any)
    let first = children[0]
    let last = children[children.count - 1]
    return first.isToken(withText: "{") && last.isToken(withText: "}")
  }
}
