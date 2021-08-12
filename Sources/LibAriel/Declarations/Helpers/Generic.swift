import SwiftSyntax

/// Something like `<T: CustomStringConvertible>`.
public struct GenericParameter {

  public let name: String
  public let inheritedType: Type?

  public init(name: String, inheritedType: Type?) {
    self.name = name
    self.inheritedType = inheritedType
  }

  internal init(_ node: GenericParameterSyntax) {
    self.name = node.name.text.trimmed
    self.inheritedType = node.inheritedType.map(Type.init)
    assert(node.attributes == nil)
  }
}

/// Something like `where T: CustomStringConvertible`.
public struct GenericRequirement {

  public enum Kind {
    case conformance
    case sameType
  }

  public let kind: Kind
  public let leftType: Type
  public let rightType: Type

  public init(kind: GenericRequirement.Kind, leftType: Type, rightType: Type) {
    self.kind = kind
    self.leftType = leftType
    self.rightType = rightType
  }

  internal init(_ node: GenericRequirementSyntax) {
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
