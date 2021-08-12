import SwiftSyntax

public struct Type {

  public let name: String

  public init(name: String) {
    self.name = name
  }

  internal init(_ node: TypeSyntax) {
    self.name = node.description.trimmed
  }
}

public struct InheritedType {

  public let typeName: String

  public init(typeName: String) {
    self.typeName = typeName
  }

  internal init(_ node: InheritedTypeSyntax) {
    self.typeName = node.typeName.description.trimmed
  }
}

public struct TypeAnnotation {

  public let typeName: String

  public init(typeName: String) {
    self.typeName = typeName
  }

  internal init(_ node: TypeAnnotationSyntax) {
    self.typeName = node.type.description.trimmed
  }
}
