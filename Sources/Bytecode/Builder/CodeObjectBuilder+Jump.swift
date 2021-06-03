import VioletCore

extension CodeObjectBuilder {

  // MARK: - Absolute

  /// Append a `jumpAbsolute` instruction to this code object.
  public func appendJumpAbsolute(to label: NotAssignedLabel) {
    let arg = self.appendExtendedArgsForLabelIndex(label)
    self.append(.jumpAbsolute(labelIndex: arg))
  }

  // MARK: - If

  /// Append a `popJumpIfTrue` instruction to this code object.
  public func appendPopJumpIfTrue(to label: NotAssignedLabel) {
    let arg = self.appendExtendedArgsForLabelIndex(label)
    self.append(.popJumpIfTrue(labelIndex: arg))
  }

  /// Append a `popJumpIfFalse` instruction to this code object.
  public func appendPopJumpIfFalse(to label: NotAssignedLabel) {
    let arg = self.appendExtendedArgsForLabelIndex(label)
    self.append(.popJumpIfFalse(labelIndex: arg))
  }

  // MARK: - Pop

  /// Append a `jumpIfTrueOrPop` instruction to this code object.
  public func appendJumpIfTrueOrPop(to label: NotAssignedLabel) {
    let arg = self.appendExtendedArgsForLabelIndex(label)
    self.append(.jumpIfTrueOrPop(labelIndex: arg))
  }

  /// Append a `jumpIfFalseOrPop` instruction to this code object.
  public func appendJumpIfFalseOrPop(to label: NotAssignedLabel) {
    let arg = self.appendExtendedArgsForLabelIndex(label)
    self.append(.jumpIfFalseOrPop(labelIndex: arg))
  }
}
