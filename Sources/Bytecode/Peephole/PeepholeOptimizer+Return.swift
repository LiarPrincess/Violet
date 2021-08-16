// In CPython:
// Python -> peephole.c

extension PeepholeOptimizer {

  /// Remove unreachable ops after RETURN.
  internal func optimizeReturn(result: inout [Instruction], ret: InstructionInfo) {
    let returnIndex = ret.startIndex
    var index = returnIndex + 1

    while index < self.instructions.count {
      if self.hasJumpTargetBetween(returnIndex, and: index) {
        return
      }

      result[index] = .nop
      index += 1
    }
  }
}
