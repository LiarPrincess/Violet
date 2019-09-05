import Core
import Bytecode

extension CodeObjectBuilder {

  // MARK: - Collections

  /// Append a `buildTuple` instruction to code object.
  public func emitBuildTuple(elementCount: Int,
                             location: SourceLocation) throws {
    // try self.emit(.buildTuple, location: location)
    throw self.unimplemented()
  }

  /// Append a `buildList` instruction to code object.
  public func emitBuildList(elementCount: Int,
                            location: SourceLocation) throws {
    // try self.emit(.buildList, location: location)
    throw self.unimplemented()
  }

  /// Append a `buildSet` instruction to code object.
  public func emitBuildSet(elementCount: Int,
                           location: SourceLocation) throws {
    // try self.emit(.buildSet, location: location)
    throw self.unimplemented()
  }

  /// Append a `buildMap` instruction to code object.
  public func emitBuildMap(elementCount: Int,
                           location: SourceLocation) throws {
    // try self.emit(.buildMap, location: location)
    throw self.unimplemented()
  }

  /// Append a `buildConstKeyMap` instruction to code object.
  public func emitBuildConstKeyMap(elementCount: Int,
                                   location: SourceLocation) throws {
    // try self.emit(.buildConstKeyMap, location: location)
    throw self.unimplemented()
  }

  // MARK: - Add

  /// Append a `setAdd` instruction to code object.
  public func emitSetAdd(value: Any, location: SourceLocation) throws {
    // try self.emit(.setAdd, location: location)
    throw self.unimplemented()
  }

  /// Append a `listAppend` instruction to code object.
  public func emitListAppend(value: Any, location: SourceLocation) throws {
    // try self.emit(.listAppend, location: location)
    throw self.unimplemented()
  }

  /// Append a `mapAdd` instruction to code object.
  public func emitMapAdd(value: Any, location: SourceLocation) throws {
    // try self.emit(.mapAdd, location: location)
    throw self.unimplemented()
  }

  // MARK: - Unpack

  /// Append a `buildTupleUnpack` instruction to code object.
  public func emitBuildTupleUnpack(elementCount: Int,
                                   location: SourceLocation) throws {
    // try self.emit(.buildTupleUnpack, location: location)
    throw self.unimplemented()
  }

  /// Append a `buildTupleUnpackWithCall` instruction to code object.
  public func emitBuildTupleUnpackWithCall(elementCount: Int,
                                           location: SourceLocation) throws {
    // try self.emit(.buildTupleUnpackWithCall, location: location)
    throw self.unimplemented()
  }

  /// Append a `buildListUnpack` instruction to code object.
  public func emitBuildListUnpack(elementCount: Int,
                                  location: SourceLocation) throws {
    // try self.emit(.buildListUnpack, location: location)
    throw self.unimplemented()
  }

  /// Append a `buildSetUnpack` instruction to code object.
  public func emitBuildSetUnpack(elementCount: Int,
                                 location: SourceLocation) throws {
    // try self.emit(.buildSetUnpack, location: location)
    throw self.unimplemented()
  }

  /// Append a `buildMapUnpack` instruction to code object.
  public func emitBuildMapUnpack(elementCount: Int,
                                 location: SourceLocation) throws {
    // try self.emit(.buildMapUnpack, location: location)
    throw self.unimplemented()
  }

  /// Append a `buildMapUnpackWithCall` instruction to code object.
  public func emitBuildMapUnpackWithCall(elementCount: Int,
                                         location: SourceLocation) throws {
    // try self.emit(.buildMapUnpackWithCall, location: location)
    throw self.unimplemented()
  }

  /// Append an `unpackSequence` instruction to code object.
  public func emitUnpackSequence(elementCount: Int,
                                 location: SourceLocation) throws {
    // try self.emit(.unpackSequence, location: location)
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
  public func emitUnpackEx(countBefore: Int,
                           countAfter:  Int,
                           location:    SourceLocation) throws {
    precondition(countBefore <= 0xff)
    precondition(countAfter  <= 0xffff_ff)

    //    let rawValue = countAfter << 8 | countBefore
    throw self.unimplemented()
  }
}
