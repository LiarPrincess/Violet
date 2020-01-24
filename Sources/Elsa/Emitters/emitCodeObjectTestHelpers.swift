import Foundation

public func emitCodeObjectTestHelpers(inputFile: URL, outputFile: URL) {
  withRedirectedStandardOutput(to: outputFile) {
    emitCodeObjectTestHelpers(inputFile: inputFile)
  }
}

private func emitCodeObjectTestHelpers(inputFile: URL) {
  print(createHeader(inputFile: inputFile))

  print("import Core")
  print("import Bytecode")
  print("import Foundation")
  print()

  print("// swiftlint:disable trailing_newline")
  print()

  print("/// Expected emitted instruction.")
  print("struct EmittedInstruction {")
  print("  let kind: EmittedInstructionKind")
  print("  let arg:  String?")
  print("")
  print("  init(_ kind: EmittedInstructionKind, _ arg:  String? = nil) {")
  print("    self.kind = kind")
  print("    self.arg  = arg")
  print("  }")
  print("}")
  print()

  let entities = parse(url: inputFile)
  let instructions = getInstructionsEnum(from: entities)
  emitEmittedInstructionKind(instructions)
}

private func getInstructionsEnum(from entities: [Entity]) -> EnumDef {
  var otherEnums = [EnumDef]()
  for entity in entities {
    switch entity {
    case let .enum(e) where e.name == "Instruction":
      return e
    case let .enum(e):
      otherEnums.append(e)
    case .struct, .class:
      break
    }
  }

  let names = otherEnums.map { $0.name }.joined(", ")
  printErr("Unable to find 'Instruction'. Found: \(names).")
  exit(EXIT_FAILURE)
}

private func emitEmittedInstructionKind(_ enumDef: EnumDef) {
  print("/// Basically `Instruction`, but without associated values.")
  print("enum EmittedInstructionKind {")
  for caseDef in enumDef.cases {
    print("  case \(caseDef.escapedName)")
  }
  print("}")
  print("")
}

private func emitInstructionExtension(_ enumDef: EnumDef) {
  print("extension \(enumDef.name) {")
  print("")

  print("  var asEmitted: EmittedInstruction {")
  print("    switch self {")
  for caseDef in enumDef.cases {
    if caseDef.properties.isEmpty {
      print("    case .\(caseDef.escapedName):")
      print("      return EmittedInstruction(.\(caseDef.name))")
    } else if caseDef.name == "formatValue" {
      print("    case let .formatValue(conversion: conversion, hasFormat: hasFormat):")
      let arg = "\\(conversion) hasFormat: \\(hasFormat)"
      print("      return EmittedInstruction(.\(caseDef.name), \"\(arg)\")")
    } else {
      let matcher = getEnumMatcher(caseDef)
      print("    case let .\(caseDef.escapedName)(\(matcher.bindings)):")
      let arg = "String(describing: \(matcher.arg)"
      print("      return EmittedInstruction(.\(caseDef.name), \(arg)))")
    }
  }
  print("    }")
  print("  }")
  print()

  print("}")
  print()
}

// MARK: - EnumDestruction

private struct EnumMatcher {
  /// e.g. value0, left: value1, right: value2
  fileprivate var bindings: String = ""
  /// e.g. value0, value1, value2
  fileprivate var arg: String = ""
}

private func getEnumMatcher(_ caseDef: EnumCaseDef) -> EnumMatcher {
  var destruction = EnumMatcher()

  for (i, property) in caseDef.properties.enumerated() {
    let isLast = i == caseDef.properties.count - 1
    let comma = isLast ? "" : ", "

    let label = property.name.map { $0 + ": " } ?? ""

    let binding = "value\(i)"
    destruction.bindings += "\(label)\(binding)\(comma)"

    destruction.arg += binding
  }

  return destruction
}
