import SwiftSyntax

struct Type {

  let name: String

  init(_ node: TypeSyntax) {
    self.name = node.description.trimmed
  }
}

struct InheritedType {

  let typeName: String

  init(_ node: InheritedTypeSyntax) {
    self.typeName = node.typeName.description.trimmed
  }
}

struct TypeAnnotation {

  let typeName: String

  init(_ node: TypeAnnotationSyntax) {
    self.typeName = node.type.description.trimmed
  }
}
