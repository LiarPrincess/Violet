// Used for generating Emitted (instruction)

// swiftlint:disable function_body_length

public final class CodeObjectTestHelpersEmitter: EmitterBase {

  public func emit(entities: [Entity]) {
    self.writeHeader(command: "code-object-test")

    self.write("import Foundation")
    self.write("import Core")
    self.write("import Bytecode")
    self.write()

    self.write("// swiftlint:disable trailing_newline")
    self.write("// swiftlint:disable file_length")
    self.write("// swiftlint:disable vertical_whitespace_closing_braces")
    self.write()

    self.emitEmittedInstruction()
    self.write()

    guard let instructions = self.getInstructionsEnum(from: entities) else {
      return
    }

    self.emitEmittedInstructionKind(instructions)
    self.emitInstructionExtension(instructions)
  }

  private func getInstructionsEnum(from entities: [Entity]) -> EnumDef? {
    for entity in entities {
      switch entity {
      case let .enum(e) where e.name == "Instruction":
        return e
      case .enum,
           .struct:
        break
      }
    }

    return nil
  }

  private func emitEmittedInstruction() {
    self.write("/// Expected emitted instruction.")
    self.write("struct EmittedInstruction {")
    self.write("  let kind: EmittedInstructionKind")
    self.write("  let arg:  String?")
    self.write("")
    self.write("  init(_ kind: EmittedInstructionKind, _ arg:  String? = nil) {")
    self.write("    self.kind = kind")
    self.write("    self.arg  = arg")
    self.write("  }")
    self.write("}")
  }

  private func emitEmittedInstructionKind(_ enumDef: EnumDef) {
    self.write("/// Basically `Instruction`, but without associated values.")
    self.write("enum EmittedInstructionKind {")
    for caseDef in enumDef.cases {
      self.write("  case \(caseDef.escapedName)")
    }
    self.write("}")
    self.write("")
  }

  private func emitInstructionExtension(_ enumDef: EnumDef) {
    self.write("extension \(enumDef.name) {")
    self.write("")

    self.write("  var asEmitted: EmittedInstruction {")
    self.write("    switch self {")
    for caseDef in enumDef.cases {
      if caseDef.properties.isEmpty {
        self.write("    case .\(caseDef.escapedName):")
        self.write("      return EmittedInstruction(.\(caseDef.name))")
      } else if caseDef.name == "formatValue" {
        self.write("    case let .formatValue(conversion: conversion, hasFormat: hasFormat):")
        let arg = "\\(conversion) hasFormat: \\(hasFormat)"
        self.write("      return EmittedInstruction(.\(caseDef.name), \"\(arg)\")")
      } else {
        let matcher = getEnumMatcher(caseDef)
        self.write("    case let .\(caseDef.escapedName)(\(matcher.bindings)):")
        let arg = "String(describing: \(matcher.arg)"
        self.write("      return EmittedInstruction(.\(caseDef.name), \(arg)))")
      }
    }
    self.write("    }")
    self.write("  }")
    self.write("")

    self.write("}")
    self.write("")  }
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
