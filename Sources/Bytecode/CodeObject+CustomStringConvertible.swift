import VioletCore

extension CodeObject: CustomStringConvertible {

  public var description: String {
    let instructions = self.createInstructionsDescription()
    return """
      Name: \(self.name)
      QualifiedName: \(self.qualifiedName)
      Filename: \(self.filename)
      Kind: \(self.kind)
      Flags: \(self.flags)
      Arg count: \(self.argCount)
      Positional only arg count: \(self.posOnlyArgCount)
      Keyword only arg count: \(self.kwOnlyArgCount)
      First line: \(self.firstLine)

      \(instructions)
      """
  }

  private func createInstructionsDescription() -> String {
    guard self.instructions.any else {
      return "(No instructions)"
    }

    var result = "Instructions (line, byte, instruction):\n"
    let linesColumnWidth = self.getLinesColumnWidth()

    var instructionIndex: Int? = 0
    while let index = instructionIndex {
      let line = self.instructionLines[index]
      let lineString = self.pad(value: line, to: linesColumnWidth)

      let byte = index * Instruction.byteSize
      let byteString = self.pad(value: byte, to: linesColumnWidth)

      let filled = self.getFilledInstruction(index: index)
      let instruction = filled.instruction

      let isLast = filled.nextInstructionIndex == nil
      let newLine = isLast ? "" : "\n"

      result.append("\(lineString) \(byteString) \(instruction)\(newLine)")
      instructionIndex = filled.nextInstructionIndex // IMPORTANT!
    }

    return result
  }

  private func getLinesColumnWidth() -> Int {
    let minWidth = 4

    guard let maxLine = self.instructionLines.last else {
      return minWidth
    }

    let maxLineString = String(maxLine)
    return Swift.max(minWidth, maxLineString.count)
  }

  private func pad(value: SourceLine, to width: Int) -> String {
    return self.pad(value: Int(value), to: width)
  }

  private func pad(value: Int, to width: Int) -> String {
    // There is 'string.padding(toLength:, withPad:, startingAt:)',
    // but it tends to trap on invalid input.

    let string = String(value)
    let stringCount = string.count

    let paddingCount = width - stringCount
    guard paddingCount > 0 else {
      return string
    }

    let padding = String(repeating: " ", count: paddingCount)
    return padding + string
  }
}
