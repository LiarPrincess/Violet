import SwiftSyntax

/// Something like `<T: CustomStringConvertible>`.
struct GenericParameter {

  let name: String
  let inheritedType: Type?

  init(_ node: GenericParameterSyntax) {
    self.name = node.name.text.trimmed
    self.inheritedType = node.inheritedType.map(Type.init)
    assert(node.attributes == nil)
  }
}

/// Something like `where T: CustomStringConvertible`.
struct GenericRequirement {

  enum Kind {
    case conformance
    case sameType
  }

  let kind: Kind
  let leftType: Type
  let rightType: Type

  init(_ node: GenericRequirementSyntax) {
    let body = node.body

    if let node = ConformanceRequirementSyntax(body) {
      self.kind = .conformance
      self.leftType = Type(node.leftTypeIdentifier)
      self.rightType = Type(node.rightTypeIdentifier)
      return
    }

    if let node = SameTypeRequirementSyntax(node.body) {
      self.kind = .sameType
      self.leftType = Type(node.leftTypeIdentifier)
      self.rightType = Type(node.rightTypeIdentifier)
      return
    }

    trap("Unknown generic requirement shape!")
  }
}
