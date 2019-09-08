import Core

extension CodeObject {

  // MARK: - Collections

  /// Append a `buildTuple` instruction to code object.
  public func appendBuildTuple(elementCount: Int,
                               at location: SourceLocation) throws {
    let arg = try self.appendExtendedArgIfNeeded(elementCount, at: location)
    try self.append(.buildTuple(elementCount: arg), at: location)
  }

  /// Append a `buildList` instruction to code object.
  public func appendBuildList(elementCount: Int,
                              at location: SourceLocation) throws {
    let arg = try self.appendExtendedArgIfNeeded(elementCount, at: location)
    try self.append(.buildList(elementCount: arg), at: location)
  }

  /// Append a `buildSet` instruction to code object.
  public func appendBuildSet(elementCount: Int,
                             at location: SourceLocation) throws {
    let arg = try self.appendExtendedArgIfNeeded(elementCount, at: location)
    try self.append(.buildSet(elementCount: arg), at: location)
  }

  /// Append a `buildMap` instruction to code object.
  public func appendBuildMap(elementCount: Int,
                             at location: SourceLocation) throws {
    let arg = try self.appendExtendedArgIfNeeded(elementCount, at: location)
    try self.append(.buildMap(elementCount: arg), at: location)
  }

  /// Append a `buildConstKeyMap` instruction to code object.
  public func appendBuildConstKeyMap(elementCount: Int,
                                     at location: SourceLocation) throws {
    // try self.append(.buildConstKeyMap, at: location)
    throw self.unimplemented()
  }

  // MARK: - Add

  /// Append a `setAdd` instruction to code object.
  public func appendSetAdd(value: Any, at location: SourceLocation) throws {
    // try self.append(.setAdd, at: location)
    throw self.unimplemented()
  }

  /// Append a `listAppend` instruction to code object.
  public func appendListAppend(value: Any, at location: SourceLocation) throws {
    // try self.append(.listAppend, at: location)
    throw self.unimplemented()
  }

  /// Append a `mapAdd` instruction to code object.
  public func appendMapAdd(value: Any, at location: SourceLocation) throws {
    // try self.append(.mapAdd, at: location)
    throw self.unimplemented()
  }

  // MARK: - Unpack

  /// Append a `buildTupleUnpack` instruction to code object.
  public func appendBuildTupleUnpack(elementCount: Int,
                                     at location: SourceLocation) throws {
    // try self.append(.buildTupleUnpack, at: location)
    throw self.unimplemented()
  }

  /// Append a `buildTupleUnpackWithCall` instruction to code object.
  public func appendBuildTupleUnpackWithCall(elementCount: Int,
                                             at location: SourceLocation) throws {
    // try self.append(.buildTupleUnpackWithCall, at: location)
    throw self.unimplemented()
  }

  /// Append a `buildListUnpack` instruction to code object.
  public func appendBuildListUnpack(elementCount: Int,
                                    at location: SourceLocation) throws {
    // try self.append(.buildListUnpack, at: location)
    throw self.unimplemented()
  }

  /// Append a `buildSetUnpack` instruction to code object.
  public func appendBuildSetUnpack(elementCount: Int,
                                   at location: SourceLocation) throws {
    // try self.append(.buildSetUnpack, at: location)
    throw self.unimplemented()
  }

  /// Append a `buildMapUnpack` instruction to code object.
  public func appendBuildMapUnpack(elementCount: Int,
                                   at location: SourceLocation) throws {
    // try self.append(.buildMapUnpack, at: location)
    throw self.unimplemented()
  }

  /// Append a `buildMapUnpackWithCall` instruction to code object.
  public func appendBuildMapUnpackWithCall(elementCount: Int,
                                           at location: SourceLocation) throws {
    // try self.append(.buildMapUnpackWithCall, at: location)
    throw self.unimplemented()
  }

  /// Append an `unpackSequence` instruction to code object.
  public func appendUnpackSequence(elementCount: Int,
                                   at location: SourceLocation) throws {
    // try self.append(.unpackSequence, at: location)
    throw self.unimplemented()
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
  public func appendUnpackEx(countBefore: Int,
                             countAfter:  Int,
                             location:    SourceLocation) throws {
    precondition(countBefore <= 0xff)
    precondition(countAfter  <= 0xffff_ff)

    //    let rawValue = countAfter << 8 | countBefore
    throw self.unimplemented()
  }
}
