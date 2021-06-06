import VioletCore

extension CodeObjectBuilder {

  // MARK: - Build

  /// Append a `buildTuple` instruction to this code object.
  public func appendBuildTuple(elementCount: Int) {
    let arg = self.appendExtendedArgIfNeeded(elementCount)
    self.append(.buildTuple(elementCount: arg))
  }

  /// Append a `buildList` instruction to this code object.
  public func appendBuildList(elementCount: Int) {
    let arg = self.appendExtendedArgIfNeeded(elementCount)
    self.append(.buildList(elementCount: arg))
  }

  /// Append a `buildSet` instruction to this code object.
  public func appendBuildSet(elementCount: Int) {
    let arg = self.appendExtendedArgIfNeeded(elementCount)
    self.append(.buildSet(elementCount: arg))
  }

  /// Append a `buildMap` instruction to this code object.
  public func appendBuildMap(elementCount: Int) {
    let arg = self.appendExtendedArgIfNeeded(elementCount)
    self.append(.buildMap(elementCount: arg))
  }

  /// Append a `buildConstKeyMap` instruction to this code object.
  public func appendBuildConstKeyMap(elementCount: Int) {
    let arg = self.appendExtendedArgIfNeeded(elementCount)
    self.append(.buildConstKeyMap(elementCount: arg))
  }

  // MARK: - Append, add

  /// Append a `listAppend` instruction to this code object.
  public func appendListAppend(relativeStackIndex: Int) {
    assert(relativeStackIndex >= 0)

    // Calls `list.append(TOS[-i], TOS)`. Container object remains on the stack.
    // Used to implement list comprehensions.
    let arg = self.appendExtendedArgIfNeeded(relativeStackIndex)
    self.append(.listAppend(relativeStackIndex: arg))
  }

  /// Append a `setAdd` instruction to this code object.
  public func appendSetAdd(relativeStackIndex: Int) {
    assert(relativeStackIndex >= 0)

    // Calls `set.add(TOS1[-i], TOS)`. Container object remains on the stack.
    // Used to implement set comprehensions.
    let arg = self.appendExtendedArgIfNeeded(relativeStackIndex)
    self.append(.setAdd(relativeStackIndex: arg))
  }

  /// Append a `mapAdd` instruction to this code object.
  public func appendMapAdd(relativeStackIndex: Int) {
    assert(relativeStackIndex >= 0)

    /// Calls `dict.setItem(TOS1[-i], TOS, TOS1)`.
    /// Container object remains on the stack.
    /// Used to implement dict comprehensions.
    let arg = self.appendExtendedArgIfNeeded(relativeStackIndex)
    self.append(.mapAdd(relativeStackIndex: arg))
  }

  // MARK: - Unpack

  /// Append a `buildTupleUnpack` instruction to this code object.
  public func appendBuildTupleUnpack(elementCount: Int) {
    let arg = self.appendExtendedArgIfNeeded(elementCount)
    self.append(.buildTupleUnpack(elementCount: arg))
  }

  /// Append a `buildTupleUnpackWithCall` instruction to this code object.
  public func appendBuildTupleUnpackWithCall(elementCount: Int) {
    let arg = self.appendExtendedArgIfNeeded(elementCount)
    self.append(.buildTupleUnpackWithCall(elementCount: arg))
  }

  /// Append a `buildListUnpack` instruction to this code object.
  public func appendBuildListUnpack(elementCount: Int) {
    let arg = self.appendExtendedArgIfNeeded(elementCount)
    self.append(.buildListUnpack(elementCount: arg))
  }

  /// Append a `buildSetUnpack` instruction to this code object.
  public func appendBuildSetUnpack(elementCount: Int) {
    let arg = self.appendExtendedArgIfNeeded(elementCount)
    self.append(.buildSetUnpack(elementCount: arg))
  }

  /// Append a `buildMapUnpack` instruction to this code object.
  public func appendBuildMapUnpack(elementCount: Int) {
    let arg = self.appendExtendedArgIfNeeded(elementCount)
    self.append(.buildMapUnpack(elementCount: arg))
  }

  /// Append a `buildMapUnpackWithCall` instruction to this code object.
  public func appendBuildMapUnpackWithCall(elementCount: Int) {
    let arg = self.appendExtendedArgIfNeeded(elementCount)
    self.append(.buildMapUnpackWithCall(elementCount: arg))
  }

  /// Append an `unpackSequence` instruction to this code object.
  public func appendUnpackSequence(elementCount: Int) {
    let arg = self.appendExtendedArgIfNeeded(elementCount)
    self.append(.unpackSequence(elementCount: arg))
  }

  /// Implements assignment with a starred target.
  ///
  /// Unpacks an iterable in TOS into individual values, where the total number
  /// of values can be smaller than the number of items in the iterable:
  /// one of the new values will be a list of all leftover items.
  ///
  /// The low byte of counts is the number of values before the list value,
  /// the high byte of counts the number of values after it.
  /// The resulting values are put onto the stack right-to-left.
  public func appendUnpackEx(countBefore: Int, countAfter: Int) {
    let encoded = Instruction.UnpackExArg(countBefore: countBefore,
                                          countAfter: countAfter)

    let arg = self.appendExtendedArgIfNeeded(encoded.value)
    self.append(.unpackEx(arg: arg))
  }
}
