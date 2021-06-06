import VioletCore

extension CodeObjectBuilder {

  // MARK: - Make function

  /// Append a `makeFunction` instruction to this code object.
  public func appendMakeFunction(flags: Instruction.FunctionFlags) {
    self.append(.makeFunction(flags: flags))
  }

  // MARK: - Call function

  /// Append a `callFunction` instruction to this code object.
  public func appendCallFunction(argumentCount: Int) {
    let arg = self.appendExtendedArgIfNeeded(argumentCount)
    self.append(.callFunction(argumentCount: arg))
  }

  /// Append a `callFunctionKw` instruction to this code object.
  public func appendCallFunctionKw(argumentCount: Int) {
    let arg = self.appendExtendedArgIfNeeded(argumentCount)
    self.append(.callFunctionKw(argumentCount: arg))
  }

  /// Append a `callFunctionEx` instruction to this code object.
  public func appendCallFunctionEx(hasKeywordArguments: Bool) {
    self.append(.callFunctionEx(hasKeywordArguments: hasKeywordArguments))
  }

  // MARK: - Load method

  /// Append a `loadMethod` instruction to this code object.
  public func appendLoadMethod(name: String) {
    let arg = self.appendExtendedArgsForNameIndex(name: name)
    self.append(.loadMethod(nameIndex: arg))
  }

  // MARK: - Call method

  /// Append a `callMethod` instruction to this code object.
  public func appendCallMethod(argumentCount: Int) {
    let arg = self.appendExtendedArgIfNeeded(argumentCount)
    self.append(.callMethod(argumentCount: arg))
  }

  // MARK: - Return

  /// Append a `returnValue` instruction to this code object.
  public func appendReturn() {
    self.append(.return)
  }
}
