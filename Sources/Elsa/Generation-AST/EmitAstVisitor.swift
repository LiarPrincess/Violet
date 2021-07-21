import Foundation

// cSpell:ignore kwonlyargs

class EmitAstVisitor: AstSourceFileVisitor {

  // MARK: - Header

  override func printHeader() {
    print("import Foundation")
    print("import BigInt")
    print("import VioletCore")
    print("import VioletLexer")
    print()

    print("// swiftlint:disable file_length")
    print("// swiftlint:disable trailing_newline")
    print("// swiftlint:disable vertical_whitespace")
    print("// swiftlint:disable vertical_whitespace_closing_braces")
    print("// cSpell:ignore kwonlyargs")
    print("")
  }

  // MARK: - Enum

  override func printEnum(_ def: Enumeration) {
    self.printEnum(def, isIndirect: false)
  }

  override func printIndirectEnum(_ def: Enumeration) {
    self.printEnum(def, isIndirect: true)
  }

  private func printEnum(_ def: Enumeration, isIndirect: Bool) {
    print("// MARK: - \(def.name.afterResolvingAlias)")
    print()

    let enclosingType = getEnclosingTypeExtension(def.enclosingTypeName)
    let indent = enclosingType.indent

    self.printExtensionStart(enclosingType)
    self.printDoc(def.doc, indent: indent)
    self.printTypeStart(def, isIndirect: isIndirect, indent: indent)
    print()
    self.printCases(def, indent: indent)
    print()
    self.printCustomStringConvertible(indent: indent)
    self.printTypeEnd(enclosingType)
    print()
  }

  // MARK: - Product type

  override func printStruct(_ def: ProductType) {
    self.printProduct(def, kind: .struct)
  }

  override func printClass(_ def: ProductType) {
    self.printProduct(def, kind: .class)
  }

  override func printFinalClass(_ def: ProductType) {
    self.printProduct(def, kind: .finalClass)
  }

  private func printProduct(_ def: ProductType, kind: ProductKind) {
    print("// MARK: - \(def.name.afterResolvingAlias)")
    print()

    let enclosingType = getEnclosingTypeExtension(def.enclosingTypeName)
    let indent = enclosingType.indent

    self.printExtensionStart(enclosingType)
    self.printDoc(def.doc, indent: indent)
    self.printTypeStart(def, kind: kind, indent: indent)
    print()
    self.printProperties(def, indent: indent)
    print()

    let hasCustomStringConvertible = def.bases.contains(type: "CustomStringConvertible")
    if hasCustomStringConvertible {
      self.printCustomStringConvertible(indent: indent)
      print()
    }

    self.printInit(def, indent: indent)
    print()
    self.printVisitor(def)
    self.printTypeEnd(enclosingType)
    print()
  }

  // swiftlint:disable:next function_body_length
  private func printVisitor(_ def: ProductType) {
    guard let nodeKind = self.getASTNodeKind(def) else {
      return
    }

    let prefix: String = {
      switch nodeKind {
      case .ast,
           .astSubclass: return "AST"
      case .statement,
           .statementSubclass: return "Statement"
      case .expression,
           .expressionSubclass: return "Expression"
      }
    }()

    switch nodeKind {
    case .ast,
         .statement,
         .expression:
      print("""
        public func accept<V: \(prefix)Visitor>(
            _ visitor: V
        ) throws -> V.\(prefix)Result {
          trap("'accept' method should be overridden in subclass")
        }

        public func accept<V: \(prefix)VisitorWithPayload>(
            _ visitor: V,
            payload: V.\(prefix)Payload
        ) throws -> V.\(prefix)Result {
          trap("'accept' method should be overridden in subclass")
        }
      """)
    case .astSubclass,
         .statementSubclass,
         .expressionSubclass:
      print("""
        override public func accept<V: \(prefix)Visitor>(
            _ visitor: V
        ) throws -> V.\(prefix)Result {
          try visitor.visit(self)
        }

        override public func accept<V: \(prefix)VisitorWithPayload>(
            _ visitor: V,
            payload: V.\(prefix)Payload
        ) throws -> V.\(prefix)Result {
          try visitor.visit(self, payload: payload)
        }
      """)
    }
  }

  // MARK: - Helpers

  private func printCustomStringConvertible(indent: String) {
    print("""
      \(indent)public var description: String {
      \(indent)  let printer = ASTPrinter()
      \(indent)  let doc = printer.visit(self)
      \(indent)  return doc.layout()
      \(indent)}
    """)
  }
}
