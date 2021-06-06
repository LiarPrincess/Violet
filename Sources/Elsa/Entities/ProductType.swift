final class ProductType {

  /// Enum name
  let name: Type
  /// Implemented protocols
  let bases: BaseTypes
  let properties: [Property]
  /// Type in which we are nested inside.
  ///
  /// Will generate:
  /// ``` Swift
  /// extension ParentName {
  ///   struct Name { … }
  /// }
  /// ```
  let enclosingTypeName: Type?
  let doc: Doc?

  init(name: Type,
       bases: BaseTypes,
       properties: [Property],
       enclosingTypeName: Type?,
       doc: Doc?) {
    self.name = name
    self.bases = bases
    self.properties = properties
    self.enclosingTypeName = enclosingTypeName
    self.doc = doc
  }

  // MARK: - Property

  struct Property {

    let name: String
    var type: PropertyType
    /// Comment above definition
    let doc: Doc?
    /// Underscore in initializer: `init(_ x: T)`
    let hasUnderscoreInInit: Bool

    /// Something like: `elsa: Princess`
    var nameColonType: String {
      return "\(self.name): \(self.type.value)"
    }

    init(_ name: String,
         type: PropertyType,
         hasUnderscoreInInit: Bool,
         doc: Doc?) {
      self.name = name.camelCase
      self.type = type
      self.hasUnderscoreInInit = hasUnderscoreInInit
      self.doc = doc
    }
  }
}
