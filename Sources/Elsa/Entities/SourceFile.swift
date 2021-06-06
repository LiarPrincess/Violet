import Foundation

/// Represents everything inside of a 'letItGo' source file.
final class SourceFile {

  struct Alias {
    let before: String
    let after: Type
  }

  enum Definition {
    case alias(Alias)
    case `enum`(Enumeration)
    case indirectEnum(Enumeration)
    case `struct`(ProductType)
    case `class`(ProductType)
    case finalClass(ProductType)
  }

  let url: URL
  private(set) var aliases = [Alias]()
  private(set) var definitions = [Definition]()

  init(url: URL) {
    self.url = url
  }

  // MARK: - Append

  func appendAlias(_ def: Alias) {
    self.aliases.append(def)
    self.definitions.append(.alias(def))
  }

  func appendEnum(_ def: Enumeration) {
    self.definitions.append(.enum(def))
  }

  func appendIndirectEnum(_ def: Enumeration) {
    self.definitions.append(.indirectEnum(def))
  }

  func appendStruct(_ def: ProductType) {
    self.definitions.append(.struct(def))
  }

  func appendClass(_ def: ProductType) {
    self.definitions.append(.class(def))
  }

  func appendFinalClass(_ def: ProductType) {
    self.definitions.append(.finalClass(def))
  }
}
