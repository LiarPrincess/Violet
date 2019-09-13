import Core

extension CodeObjectBuilder {

  // MARK: - Absolute

  /// Append a `jumpAbsolute` instruction to this code object.
  public func appendJumpAbsolute(to label: Label) {
    let index = self.addLabelWithExtendedArgIfNeeded(label)
    self.append(.jumpAbsolute(labelIndex: index))
  }

  // MARK: - If

  /// Append a `popJumpIfTrue` instruction to this code object.
  public func appendPopJumpIfTrue(to label: Label) {
    let index = self.addLabelWithExtendedArgIfNeeded(label)
    self.append(.popJumpIfTrue(labelIndex: index))
  }

  /// Append a `popJumpIfFalse` instruction to this code object.
  public func appendPopJumpIfFalse(to label: Label) {
    let index = self.addLabelWithExtendedArgIfNeeded(label)
    self.append(.popJumpIfFalse(labelIndex: index))
  }

  // MARK: - Pop

  /// Append a `jumpIfTrueOrPop` instruction to this code object.
  public func appendJumpIfTrueOrPop(to label: Label) {
    let index = self.addLabelWithExtendedArgIfNeeded(label)
    self.append(.jumpIfTrueOrPop(labelIndex: index))
  }

  /// Append a `jumpIfFalseOrPop` instruction to this code object.
  public func appendJumpIfFalseOrPop(to label: Label) {
    let index = self.addLabelWithExtendedArgIfNeeded(label)
    self.append(.jumpIfFalseOrPop(labelIndex: index))
  }
}
