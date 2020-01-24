import Foundation

public func emitCodeObjectDescription(inputFile: URL, outputFile: URL) {
  withRedirectedStandardOutput(to: outputFile) {
    emitCodeObjectDescription(inputFile: inputFile)
  }
}

private func emitCodeObjectDescription(inputFile: URL) {
  print(createHeader(inputFile: inputFile))

  print("import Core")
  print("import Foundation")
  print()

  print("// swiftlint:disable file_length")
  print()

  for entity in parse(url: inputFile) {
    switch entity {
    case let .enum(e):
      emitDescription(e)
    case .struct, .class:
      break
    }
  }

  print("private func hex(_ value: UInt8) -> String {")
  print("  let s = String(value, radix: 16, uppercase: false)")
  print("  let prefix = s.count < 2 ? \"0\" : \"\"")
  print("  return \"0x\" + prefix + s")
  print("}")
}

private func emitDescription(_ def: EnumDef) {
  print("extension \(def.name): CustomStringConvertible {")
  print("  public var description: String {")
  print("    switch self {")

  for caseDef in def.cases {
    if caseDef.properties.isEmpty {
      print("    case .\(caseDef.escapedName):")
      print("      return \"\(caseDef.name)\"")
    } else {
      let matcher = getEnumMatcher(caseDef)
      print("    case let .\(caseDef.escapedName)(\(matcher.bindings)):")
      print("      return \"\(caseDef.name)(\(matcher.print))\"")
    }
  }

  print("    }")
  print("  }")
  print("}")
  print("")
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
