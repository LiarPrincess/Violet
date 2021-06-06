import Foundation

class EmitBytecodeVisitor: BytecodeFileVisitor {

  override func printHeader() {
    print("import Foundation")
    print("import VioletCore")
    print()

    print("// swiftlint:disable superfluous_disable_command")
    print("// swiftlint:disable line_length")
    print("// swiftlint:disable file_length")
    print("// swiftlint:disable trailing_newline")
    print("// swiftlint:disable vertical_whitespace_closing_braces")
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
    let enclosingType = getEnclosingTypeExtension(def.enclosingTypeName)
    let indent = enclosingType.indent

    self.printExtensionStart(enclosingType)
    self.printDoc(def.doc, indent: indent)
    self.printTypeStart(def, isIndirect: isIndirect, indent: indent)
    self.printCases(def, indent: indent)
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
    self.printInit(def, indent: indent)
    print()
    self.printTypeEnd(enclosingType)
    print()
  }
}
