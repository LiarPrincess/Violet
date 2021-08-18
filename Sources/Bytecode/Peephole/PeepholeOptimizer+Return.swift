// In CPython:
// Python -> peephole.c

extension PeepholeOptimizer {

  /// Remove unreachable ops after RETURN.
  internal func optimizeReturn(result: inout OptimizationResult,
                               ret: PeepholeInstruction) {
    var index = ret.startIndex + 1

    while index < result.instructions.count {
      if self.oldJumpTable.hasJumpTargetBetween(ret, and: index) {
        return
      }

      result.instructions[index] = .nop
      index += 1
    }
  }
}
