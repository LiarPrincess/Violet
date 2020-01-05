import Core

extension CodeObjectBuilder {

  // MARK: - Build collection

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

  // MARK: - Tuple unpack

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

  // MARK: - List unpack

  /// Append a `buildListUnpack` instruction to this code object.
  public func appendBuildListUnpack(elementCount: Int) {
    let arg = self.appendExtendedArgIfNeeded(elementCount)
    self.append(.buildListUnpack(elementCount: arg))
  }

  // MARK: - Set unpack

  /// Append a `buildSetUnpack` instruction to this code object.
  public func appendBuildSetUnpack(elementCount: Int) {
    let arg = self.appendExtendedArgIfNeeded(elementCount)
    self.append(.buildSetUnpack(elementCount: arg))
  }

  // MARK: - Map unpack

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

  // MARK: - Other unpack

  /// Append an `unpackSequence` instruction to this code object.
  public func appendUnpackSequence(elementCount: Int) {
    let arg = self.appendExtendedArgIfNeeded(elementCount)
    self.append(.unpackSequence(elementCount: arg))
  }
}
