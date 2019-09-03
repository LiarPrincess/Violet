import Core
import Parser
import Bytecode

extension CodeObjectBuilder {

  // MARK: - Collections

  /// Append a `buildTuple` instruction to currently filled code object.
  public func emitBuildTuple(elementCount: UInt8, location: SourceLocation) throws {
    // try self.emit(.buildTuple, location: location)
    throw self.unimplemented()
  }

  /// Append a `buildList` instruction to currently filled code object.
  public func emitBuildList(elementCount: UInt8, location: SourceLocation) throws {
    // try self.emit(.buildList, location: location)
    throw self.unimplemented()
  }

  /// Append a `buildSet` instruction to currently filled code object.
  public func emitBuildSet(elementCount: UInt8, location: SourceLocation) throws {
    // try self.emit(.buildSet, location: location)
    throw self.unimplemented()
  }

  /// Append a `buildMap` instruction to currently filled code object.
  public func emitBuildMap(elementCount: UInt8, location: SourceLocation) throws {
    // try self.emit(.buildMap, location: location)
    throw self.unimplemented()
  }

  /// Append a `setAdd` instruction to currently filled code object.
  public func emitSetAdd(value: I, location: SourceLocation) throws {
    // try self.emit(.setAdd, location: location)
    throw self.unimplemented()
  }

  /// Append a `listAppend` instruction to currently filled code object.
  public func emitListAppend(value: I, location: SourceLocation) throws {
    // try self.emit(.listAppend, location: location)
    throw self.unimplemented()
  }

  /// Append a `mapAdd` instruction to currently filled code object.
  public func emitMapAdd(value: I, location: SourceLocation) throws {
    // try self.emit(.mapAdd, location: location)
    throw self.unimplemented()
  }

  // MARK: - Unpack

  /// Append a `buildTupleUnpack` instruction to currently filled code object.
  public func emitBuildTupleUnpack(elementCount: UInt8, location: SourceLocation) throws {
    // try self.emit(.buildTupleUnpack, location: location)
    throw self.unimplemented()
  }

  /// Append a `buildTupleUnpackWithCall` instruction to currently filled code object.
  public func emitBuildTupleUnpackWithCall(elementCount: UInt8, location: SourceLocation) throws {
    // try self.emit(.buildTupleUnpackWithCall, location: location)
    throw self.unimplemented()
  }

  /// Append a `buildListUnpack` instruction to currently filled code object.
  public func emitBuildListUnpack(elementCount: UInt8, location: SourceLocation) throws {
    // try self.emit(.buildListUnpack, location: location)
    throw self.unimplemented()
  }

  /// Append a `buildSetUnpack` instruction to currently filled code object.
  public func emitBuildSetUnpack(elementCount: UInt8, location: SourceLocation) throws {
    // try self.emit(.buildSetUnpack, location: location)
    throw self.unimplemented()
  }

  /// Append a `buildMapUnpack` instruction to currently filled code object.
  public func emitBuildMapUnpack(elementCount: UInt8, location: SourceLocation) throws {
    // try self.emit(.buildMapUnpack, location: location)
    throw self.unimplemented()
  }

  /// Append a `buildMapUnpackWithCall` instruction to currently filled code object.
  public func emitBuildMapUnpackWithCall(elementCount: UInt8, location: SourceLocation) throws {
    // try self.emit(.buildMapUnpackWithCall, location: location)
    throw self.unimplemented()
  }

  /// Append an `unpackSequence` instruction to currently filled code object.
  public func emitUnpackSequence(elementCount: UInt8, location: SourceLocation) throws {
    // try self.emit(.unpackSequence, location: location)
    throw self.unimplemented()
  }

  /// Append an `unpackEx` instruction to currently filled code object.
  public func emitUnpackEx(elementCountBefore: UInt8, location: SourceLocation) throws {
    // try self.emit(.unpackEx, location: location)
    throw self.unimplemented()
  }
}
