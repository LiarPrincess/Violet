import VioletCore

extension CodeObjectBuilder {

  // MARK: - Loops

  /// Append a `setupLoop` instruction to this code object.
  public func appendSetupLoop(loopEnd: NotAssignedLabel) {
    let arg = self.appendExtendedArgsForLabelIndex(loopEnd)
    self.append(.setupLoop(loopEndLabelIndex: arg))
  }

  /// Append a `getIter` instruction to this code object.
  public func appendGetIter() {
    self.append(.getIter)
  }

  /// Append a `forIter` instruction to this code object.
  public func appendForIter(ifEmpty: NotAssignedLabel) {
    let arg = self.appendExtendedArgsForLabelIndex(ifEmpty)
    self.append(.forIter(ifEmptyLabelIndex: arg))
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
  public func appendContinue(loopStartLabel: NotAssignedLabel) {
    let arg = self.appendExtendedArgsForLabelIndex(loopStartLabel)
    self.append(.continue(loopStartLabelIndex: arg))
  }
}
