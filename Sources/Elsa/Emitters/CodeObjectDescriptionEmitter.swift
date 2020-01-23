// Used for generating description for CodeObjects.

public final class CodeObjectDescriptionEmitter: EmitterBase {

  public func emit(entities: [Entity], imports: [String]) {
    self.writeHeader(command: "code-object-descr")

    for i in imports {
      self.write("import \(i)")
    }
    self.write()

    self.write("// swiftlint:disable file_length")
    self.write()

    for entity in entities {
      switch entity {
      case let .enum(e):
        self.emitDescription(e)
      case .struct, .class:
        break
      }
    }

    self.write("private func hex(_ value: UInt8) -> String {")
    self.write("  let s = String(value, radix: 16, uppercase: false)")
    self.write("  let prefix = s.count < 2 ? \"0\" : \"\"")
    self.write("  return \"0x\" + prefix + s")
    self.write("}")
  }

  private func emitDescription(_ enumDef: EnumDef) {
    self.write("extension \(enumDef.name): CustomStringConvertible {")
    self.write("  public var description: String {")
    self.write("    switch self {")

    for caseDef in enumDef.cases {
      if caseDef.properties.isEmpty {
        self.write("    case .\(caseDef.escapedName):")
        self.write("      return \"\(caseDef.name)\"")
      } else {
        let matcher = getEnumMatcher(caseDef)
        self.write("    case let .\(caseDef.escapedName)(\(matcher.bindings)):")
        self.write("      return \"\(caseDef.name)(\(matcher.print))\"")
      }
    }

    self.write("    }")
    self.write("  }")
    self.write("}")
    self.write("")
  }
}

// MARK: - EnumDestruction

private struct EnumMatcher {
  /// e.g. value0, left: value1, right: value2
  fileprivate var bindings: String = ""
  /// e.g. value0, value1, value2
  fileprivate var print: String = ""
}

private func getEnumMatcher(_ caseDef: EnumCaseDef) -> EnumMatcher {
  var destruction = EnumMatcher()

  for (i, property) in caseDef.properties.enumerated() {
    let isLast = i == caseDef.properties.count - 1
    let comma = isLast ? "" : ", "

    let label = property.name.map { $0 + ": " } ?? ""

    let binding = "value\(i)"
    destruction.bindings += "\(label)\(binding)\(comma)"

    let value = property.type == "UInt8" ? "hex(\(binding))" : binding
    destruction.print += "\(label)\\(\(value))\(comma)"
  }

  return destruction
}
