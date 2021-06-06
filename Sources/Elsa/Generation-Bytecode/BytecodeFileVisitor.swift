/// Common stuff for all `Bytecode` visitors.
class BytecodeFileVisitor: SourceFileVisitor {

  struct CasePropertyBinding {
    /// Value used in `case let .\(escapedName)(\(properties.bindings)):`
    ///
    /// For example: `value0, left: value1, right: value2`
    fileprivate(set) var bindings: String = ""
    /// Value used for description: `return \"\(name)(\(properties.description))\"`.
    ///
    /// For example: `value0, \(left): \(value1), right: \(value2)`
    fileprivate(set) var description: String = ""
  }

  func createCasePropertyBinding(_ caseDef: Enumeration.Case) -> CasePropertyBinding {
    var result = CasePropertyBinding()
    let properties = caseDef.properties

    for (i, property) in properties.enumerated() {
      let isLast = i == properties.count - 1
      let comma = isLast ? "" : ", "

      // 'left: '
      let labelColonSpace = property.name.map { $0 + ": " } ?? ""
      // Name used for binding, for example 'value0'
      let valueBinding = "value\(i)"

      // Part used defining case matching:
      // - without label: 'value0, '
      // - with label:    'left: value1, '
      result.bindings += "\(labelColonSpace)\(valueBinding)\(comma)"

      // Part used when printing description:
      // - without label: '\(value0), '
      // - with label:    'left: \(value0), '
      let description: String = {
        let isUInt8 = property.type.afterResolvingAlias == "UInt8"
        let valueToPrint = isUInt8 ? "hex(\(valueBinding))" : valueBinding
        return "\(labelColonSpace)\\(\(valueToPrint))\(comma)"
      }()

      result.description += description
    }

    return result
  }
}
