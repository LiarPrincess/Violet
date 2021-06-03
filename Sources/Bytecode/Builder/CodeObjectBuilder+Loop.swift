import VioletCore

extension CodeObjectBuilder {

  // MARK: - Loops

  /// Append a `setupLoop` instruction to this code object.
  public func appendSetupLoop(loopEnd: CodeObject.Label) {
    let arg = self.addLabelWithExtendedArgIfNeeded(loopEnd)
    self.append(.setupLoop(loopEndLabel: arg))
  }

  /// Append a `getIter` instruction to this code object.
  public func appendGetIter() {
    self.append(.getIter)
  }

  /// Append a `forIter` instruction to this code object.
  public func appendForIter(ifEmpty: CodeObject.Label) {
    let arg = self.addLabelWithExtendedArgIfNeeded(ifEmpty)
    self.append(.forIter(ifEmptyLabel: arg))
  }

  /// Append a `getYieldFromIter` instruction to this code object.
  public func appendGetYieldFromIter() {
    self.append(.getYieldFromIter)
  }

  // MARK: - Break

  /// Append a `breakLoop` instruction to this code object.
  public func appendBreak() {
    self.append(.break)
  }

  // MARK: - Continue

  /// Continues a loop due to a continue statement.
  /// `loopStartLabel` is the address to jump to
  /// (which should be a `ForIter` instruction).
  public func appendContinue(loopStartLabel: CodeObject.Label) {
    let arg = self.addLabelWithExtendedArgIfNeeded(loopStartLabel)
    self.append(.continue(loopStartLabel: arg))
  }
}
