import XCTest
import VioletCore
@testable import VioletBytecode

// swiftlint:disable number_separator
// swiftlint:disable function_body_length
// swiftformat:disable numberFormatting

// After mangling: '_Frozen__Elsa' etc.
private let elsa = MangledName(className: "Frozen", name: "__Elsa")
private let anna = MangledName(className: "Frozen", name: "__Anna")
private let kristoff = MangledName(className: "Frozen", name: "__Kristoff")
private let olaf = "Olaf"

private func line(_ value: SourceLine) -> SourceLocation {
  return SourceLocation(line: value, column: 0)
}

class CodeObjectDescriptionTests: XCTestCase {

  func test_noInstructions() {
    let builder = createBuilder(
      name: "Frozen",
      qualifiedName: "Disnep_Frozen",
      filename: "2013.py",
      kind: .module,
      flags: [.generator],
      variableNames: [elsa],
      freeVariableNames: [anna],
      cellVariableNames: [kristoff],
      argCount: 2013, // Year
      posOnlyArgCount: 1, // Series number
      kwOnlyArgCount: 102, // Duration (in minutes)
      firstLine: SourceLine(2) // Oscars: 'Animated Feature Film' and 'Music'
    )

    // We do not need peephole optimizer when testing description.
    let code = builder.finalize(usePeepholeOptimizer: false)
    let description = String(describing: code)

    XCTAssertEqual(description, """
    Name: Frozen
    QualifiedName: Disnep_Frozen
    Filename: 2013.py
    Kind: Module
    Flags: [generator]
    Arg count: 2013
    Positional only arg count: 1
    Keyword only arg count: 102
    First line: 2

    (No instructions)
    """)
  }

  func test_withInstructions() {
    let builder = createBuilder(
      name: "Frozen 2",
      qualifiedName: "Disnep_Frozen_2",
      filename: "2018.py",
      kind: .module,
      flags: [.generator],
      variableNames: [elsa],
      freeVariableNames: [anna],
      cellVariableNames: [kristoff],
      argCount: 2018, // Year
      posOnlyArgCount: 2, // Series number
      kwOnlyArgCount: 103, // Duration (in minutes)
      firstLine: SourceLine(1) // Oscar nominations: Music
    )

    let label = builder.createLabel()
    builder.appendNop()
    builder.setLabel(label)
    builder.setAppendLocation(line(2))
    builder.appendLoadName(olaf)
    builder.setAppendLocation(line(3))
    builder.appendStoreFast(elsa)
    builder.setAppendLocation(line(4))
    builder.appendDeleteFree(anna)
    builder.setAppendLocation(line(5))
    builder.appendLoadCell(kristoff)
    builder.setAppendLocation(line(6))
    builder.appendJumpAbsolute(to: label) // Infinite loop, because why not?

    // We do not need peephole optimizer when testing description.
    let code = builder.finalize(usePeepholeOptimizer: false)
    let description = String(describing: code)

    XCTAssertEqual(description, """
    Name: Frozen 2
    QualifiedName: Disnep_Frozen_2
    Filename: 2018.py
    Kind: Module
    Flags: [generator]
    Arg count: 2018
    Positional only arg count: 2
    Keyword only arg count: 103
    First line: 1

    Instructions (line, byte, instruction):
       1    0 nop
       2    2 loadName(name: Olaf)
       3    4 storeFast(variable: _Frozen__Elsa)
       4    6 deleteFree(free: _Frozen__Anna)
       5    8 loadCell(cell: _Frozen__Kristoff)
       6   10 jumpAbsolute(label: Label(instructionIndex: 1, byteOffset: 2))
    """)
  }
}
