import VioletCore

extension CodeObjectBuilder {

  /// Append a `nop` instruction to this code object.
  public func appendNop() {
    self.append(.nop)
  }

  /// Append a `popTop` instruction to this code object.
  public func appendPopTop() {
    self.append(.popTop)
  }

  /// Append a `rotTwo` instruction to this code object.
  public func appendRotTwo() {
    self.append(.rotTwo)
  }

  /// Append a `rotThree` instruction to this code object.
  public func appendRotThree() {
    self.append(.rotThree)
  }

  /// Append a `dupTop` instruction to this code object.
  public func appendDupTop() {
    self.append(.dupTop)
  }

  /// Append a `dupTopTwo` instruction to this code object.
  public func appendDupTopTwo() {
    self.append(.dupTopTwo)
  }

  /// Append a `printExpr` instruction to this code object.
  public func appendPrintExpr() {
    self.append(.printExpr)
  }

  /// Append a `setupAnnotations` instruction to this code object.
  public func appendSetupAnnotations() {
    self.append(.setupAnnotations)
  }

  /// Append a `popBlock` instruction to this code object.
  public func appendPopBlock() {
    self.append(.popBlock)
  }

  /// Append a `buildSlice` instruction to this code object.
  public func appendBuildSlice(arg: Instruction.SliceArg) {
    self.append(.buildSlice(type: arg))
  }

  /// Append an `extendedArg` instruction to this code object.
  public func appendExtendedArg(value: UInt8) {
    self.append(.extendedArg(value))
  }
}
