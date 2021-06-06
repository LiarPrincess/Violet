import Foundation

class EmitBytecodeTestHelpersVisitor: BytecodeFileVisitor {

  private static let instructionEnumName = "Instruction"
  private var hasSeenInstructionEnum = false

  // MARK: - Header

  override func printHeader() {
    print("import VioletCore")
    print("import VioletBytecode")
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
  }

  // MARK: - Footer

  override func printFooter() {
    if !self.hasSeenInstructionEnum {
      trap("Did not find the '\(Self.instructionEnumName)' enumeration")
    }
  }

  // MARK: - Enum
  override func printIndirectEnum(_ def: Enumeration) {
    self.printEnum(def)
  }

  override func printEnum(_ def: Enumeration) {
    let name = def.name.afterResolvingAlias
    guard name == Self.instructionEnumName else {
      return
    }

    self.hasSeenInstructionEnum = true
    self.emitEmittedInstructionKind(def)
//    self.emitInstructionExtension(def)
  }

  private func emitEmittedInstructionKind(_ def: Enumeration) {
    print("/// Basically `Instruction`, but without associated values.")
    print("enum EmittedInstructionKind {")
    for caseDef in def.cases {
      print("  case \(caseDef.escapedName)")
    }
    print("}")
    print("")
  }

  private func emitInstructionExtension(_ def: Enumeration) {
    let name = def.name.afterResolvingAlias
    print("extension \(name) {")
    print("")

    print("  var asEmitted: EmittedInstruction {")
    print("    switch self {")

    for caseDef in def.cases {
      let name = caseDef.name
      let escapedName = caseDef.escapedName

      if caseDef.properties.isEmpty {
        print("    case .\(escapedName):")
        print("      return EmittedInstruction(.\(name))")
      } else if caseDef.name == "formatValue" {
        print("    case let .formatValue(conversion: conversion, hasFormat: hasFormat):")
        let arg = "\\(conversion) hasFormat: \\(hasFormat)"
        print("      return EmittedInstruction(.\(name), \"\(arg)\")")
      } else {
        let properties = self.getEnumMatcher(caseDef)
        let arg = "String(describing: \(properties.arg)"
        print("    case let .\(escapedName)(\(properties.bindings)):")
        print("      return EmittedInstruction(.\(name), \(arg)))")
      }
    }

    print("    }") // switch
    print("  }") // asEmitted
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

  private func getEnumMatcher(_ caseDef: Enumeration.Case) -> EnumMatcher {
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
}
