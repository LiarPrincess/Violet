// cSpell:ignore markblocks CODEUNIT ISBASICBLOCK

/// Information about jumps.
internal struct PeepholeJumpTable {

  /// For every jump target we will increment a running value.
  ///
  /// The end result looks something like:
  /// ```
  /// 0
  /// 0
  /// 1 <- 1st jump target
  /// 1
  /// 1
  /// 2 <- 2nd jump target
  /// (an so on…)
  /// ```
  private var jumpTargetPartitions: [Int]

  /// static unsigned int *
  /// markblocks(_Py_CODEUNIT *code, Py_ssize_t len)
  internal init(instructions: [Instruction], labels: [CodeObject.Label]) {
    // Our code is simpler than the one in CPython, because all of our jumps
    // are absolute (and stored in a single array).
    self.jumpTargetPartitions = [Int](repeating: 0, count: instructions.count)

    // Mark jump targets with '1'.
    for label in labels {
      assert(label != CodeObject.Label.notAssigned)

      let jumpTarget = label.instructionIndex
      self.jumpTargetPartitions[jumpTarget] = 1
    }

    // Build partitions.
    var acc = 0
    for index in 0..<instructions.count {
      acc += self.jumpTargetPartitions[index]
      self.jumpTargetPartitions[index] = acc
    }
  }

  internal func hasJumpTargetBetween(_ instruction: PeepholeInstruction,
                                     and next: PeepholeInstruction) -> Bool {
    let index0 = instruction.startIndex
    let index1 = next.startIndex
    return self.hasJumpTargetBetween(index0, and: index1)
  }

  internal func hasJumpTargetBetween(_ instruction: PeepholeInstruction,
                                     and index: Int) -> Bool {
    let instructionIndex = instruction.startIndex
    return self.hasJumpTargetBetween(instructionIndex, and: index)
  }

  /// Opposite of:
  /// \#define ISBASICBLOCK(blocks, start, end) \
  ///     (blocks[start]==blocks[end])
  internal func hasJumpTargetBetween(_ startIndex: Int,
                                     and endIndex: Int) -> Bool {
    let partition0 = self.jumpTargetPartitions[startIndex]
    let partition1 = self.jumpTargetPartitions[endIndex]
    return partition0 != partition1
  }
}
