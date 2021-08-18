// In CPython:
// Python -> peephole.c

extension PeepholeOptimizer {

  /// Remove unreachable ops after RETURN.
  internal func optimizeReturn(result: inout [Instruction],
                               ret: PeepholeInstruction) {
    var index = ret.startIndex + 1

    while index < result.count {
      if self.hasJumpTargetBetween(ret, and: index) {
        return
      }

      result[index] = .nop
      index += 1
    }
  }
}
