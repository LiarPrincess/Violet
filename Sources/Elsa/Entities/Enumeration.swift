final class Enumeration {

  /// Enum name
  let name: Type
  /// Implemented protocols
  let bases: BaseTypes
  let cases: [Enumeration.Case]
  /// Type in which we are nested inside.
  ///
  /// Will generate:
  /// ``` Swift
  /// extension ParentName {
  ///   struct Name { … }
  /// }
  /// ```
  let enclosingTypeName: Type?
  /// Comment above definition
  let doc: Doc?

  init(name: Type,
       bases: BaseTypes,
       cases: [Enumeration.Case],
       isIndirect: Bool,
       enclosingTypeName: Type?,
       doc: Doc?) {
    self.name = name
    self.bases = bases
    self.cases = cases
    self.enclosingTypeName = enclosingTypeName
    self.doc = doc
  }

  // MARK: - Case

  struct Case {

    let name: String
    let properties: [CaseProperty]
    let doc: Doc?

    var escapedName: String {
      return escapeSwiftKeyword(self.name)
    }

    init(_ name: String, properties: [CaseProperty], doc: Doc?) {
      self.name = name.camelCase
      self.properties = properties
      self.doc = doc
    }
  }

  // MARK: - CaseProperty

  struct CaseProperty {

    let name: String?
    let type: PropertyType

    /// String to use when defining this `enum`
    func formatForDefinition() -> String {
      let type = self.type.value

      switch self.name {
      case .some(let n):
        return n + ": " + type
      case .none:
        return type
      }
    }

    init(_ name: String?, type: PropertyType) {
      self.name = name.map { $0.camelCase }
      self.type = type
    }
  }
}
