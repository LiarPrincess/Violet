/// Common stuff for all `Bytecode` visitors.
class BytecodeFileVisitor: SourceFileVisitor {

  // MARK: - Instruction enum

  static let instructionEnumName = "Instruction"

  func getInstructionEnum() -> Enumeration {
    for def in self.sourceFile.definitions {
      switch def {
      case let .enum(e),
           let .indirectEnum(e):
        let name = e.name.afterResolvingAlias
        if name == Self.instructionEnumName {
          return e
        }

      default:
        break
      }
    }

    trap("Did not find the '\(Self.instructionEnumName)' enumeration")
  }

  // MARK: - Case property

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
      result.description += "\(labelColonSpace)\\(\(valueBinding))\(comma)"
    }

    return result
  }

  // MARK: - Filled instructions

  static let filledEnumName = "Filled"

  struct FilledInstruction {
    let doc: Doc?
    let name: String
    let escapedName: String
    let properties: [Property]

    // swiftlint:disable:next nesting
    struct Property {
      let label: String?
      let type: String
      let index: Int
      let isLast: Bool
    }
  }

  func getFilledInstructions() -> [FilledInstruction] {
    var result = [FilledInstruction]()

    let instructionEnum = self.getInstructionEnum()
    for caseDef in instructionEnum.cases {
      // We no longer need 'extendedArg', because we will apply it
      // to get a proper index
      let name = caseDef.name
      if name == "extendedArg" {
        continue
      }

      var properties = [FilledInstruction.Property]()
      for (index, p) in caseDef.properties.enumerated() {
        let isLast = index == caseDef.properties.count - 1
        let property = self.createFilledInstructionProperty(case: caseDef,
                                                            property: p,
                                                            index: index,
                                                            isLast: isLast)
        properties.append(property)
      }

      let instruction = FilledInstruction(doc: caseDef.doc,
                                          name: name,
                                          escapedName: caseDef.escapedName,
                                          properties: properties)
      result.append(instruction)
    }

    return result
  }

  // swiftlint:disable:next function_body_length
  private func createFilledInstructionProperty(
    case: Enumeration.Case,
    property: Enumeration.CaseProperty,
    index: Int,
    isLast: Bool
  ) -> FilledInstruction.Property {
    func create(label: String?, type: String) -> FilledInstruction.Property {
      return FilledInstruction.Property(label: label,
                                        type: type,
                                        index: index,
                                        isLast: isLast)
    }

    let label = property.name

    // Special case
    let isUnpackEx = `case`.name == "unpackEx"
    if isUnpackEx {
      assert(`case`.properties.count == 1)
      return create(label: label, type: "Instruction.UnpackExArg")
    }

    // Standard cases
    let typeInFile = property.type.inFile
    switch typeInFile {
    case "LabelIndex":
      return create(label: self.removeIndexWord(label), type: "CodeObject.Label")
    case "ConstantIndex":
      return create(label: self.removeIndexWord(label), type: "CodeObject.Constant")
    case "NameIndex":
      return create(label: self.removeIndexWord(label), type: "String")
    case "VariableIndex":
      return create(label: self.removeIndexWord(label), type: "MangledName")
    case "CellIndex":
      return create(label: self.removeIndexWord(label), type: "MangledName")
    case "FreeIndex":
      return create(label: self.removeIndexWord(label), type: "MangledName")
    case "CellOrFreeIndex":
      return create(label: self.removeIndexWord(label), type: "MangledName")
    case "Count":
      return create(label: label, type: "Int")
    case "RelativeStackIndex":
      return create(label: label, type: "Int")
    default:
      return create(label: label, type: property.type.value)
    }
  }

  private func removeIndexWord(_ name: String?) -> String? {
    guard let n = name else {
      return nil
    }

    let result = n
      .replacingOccurrences(of: "Index", with: "")
      .replacingOccurrences(of: "index", with: "")

    return result.isEmpty ? nil : result
  }
}
