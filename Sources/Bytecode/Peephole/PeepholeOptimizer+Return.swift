// In CPython:
// Python -> peephole.c

extension PeepholeOptimizer {

  /// Remove unreachable ops after RETURN.
  internal func optimizeReturn(result: inout [Instruction], ret: InstructionInfo) {
    let index = ret.startIndex

    var afterReturnNotJumpTarget = index + 1
    while afterReturnNotJumpTarget < self.instructions.count
            && !self.hasJumpTargetBetween(index, and: afterReturnNotJumpTarget) {
      afterReturnNotJumpTarget += 1
    }

    if afterReturnNotJumpTarget > index + 1 {
      self.fillNop(result: &result,
                   startIndex: ret.startIndex + 1,
                   endIndex: afterReturnNotJumpTarget)
    }
  }
}
