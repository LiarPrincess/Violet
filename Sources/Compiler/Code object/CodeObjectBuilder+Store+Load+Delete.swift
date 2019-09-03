import Core
import Parser
import Bytecode

extension CodeObjectBuilder {

  // MARK: - Constants

  /// Append a `loadConst` instruction to currently filled code object.
  public func emitLoadConst(index: UInt8, location: SourceLocation) throws {
    // try self.emit(.loadConst, location: location)
    throw self.unimplemented()
  }

  // MARK: - Name

  /// Append a `storeName` instruction to currently filled code object.
  public func emitStoreName(nameIndex: UInt8, location: SourceLocation) throws {
    // try self.emit(.storeName, location: location)
    throw self.unimplemented()
  }

  /// Append a `loadName` instruction to currently filled code object.
  public func emitLoadName(nameIndex: UInt8, location: SourceLocation) throws {
    // try self.emit(.loadName, location: location)
    throw self.unimplemented()
  }

  /// Append a `deleteName` instruction to currently filled code object.
  public func emitDeleteName(nameIndex: UInt8, location: SourceLocation) throws {
    // try self.emit(.deleteName, location: location)
    throw self.unimplemented()
  }

  // MARK: - Attribute

  /// Append a `storeAttr` instruction to currently filled code object.
  public func emitStoreAttr(nameIndex: UInt8, location: SourceLocation) throws {
    // try self.emit(.storeAttr, location: location)
    throw self.unimplemented()
  }

  /// Append a `loadAttr` instruction to currently filled code object.
  public func emitLoadAttr(nameIndex: UInt8, location: SourceLocation) throws {
    // try self.emit(.loadAttr, location: location)
    throw self.unimplemented()
  }

  /// Append a `deleteAttr` instruction to currently filled code object.
  public func emitDeleteAttr(nameIndex: UInt8, location: SourceLocation) throws {
    // try self.emit(.deleteAttr, location: location)
    throw self.unimplemented()
  }

  // MARK: - Subscript

  /// Append a `binarySubscr` instruction to currently filled code object.
  public func emitBinarySubscr(location: SourceLocation) throws {
    try self.emit(.binarySubscr, location: location)
  }

  /// Append a `storeSubscr` instruction to currently filled code object.
  public func emitStoreSubscr(location: SourceLocation) throws {
    try self.emit(.storeSubscr, location: location)
  }

  /// Append a `deleteSubscr` instruction to currently filled code object.
  public func emitDeleteSubscr(location: SourceLocation) throws {
    try self.emit(.deleteSubscr, location: location)
  }

  // MARK: - Global

  /// Append a `storeGlobal` instruction to currently filled code object.
  public func emitStoreGlobal(nameIndex: UInt8, location: SourceLocation) throws {
    // try self.emit(.storeGlobal, location: location)
    throw self.unimplemented()
  }

  /// Append a `loadGlobal` instruction to currently filled code object.
  public func emitLoadGlobal(nameIndex: UInt8, location: SourceLocation) throws {
    // try self.emit(.loadGlobal, location: location)
    throw self.unimplemented()
  }

  /// Append a `deleteGlobal` instruction to currently filled code object.
  public func emitDeleteGlobal(nameIndex: UInt8, location: SourceLocation) throws {
    // try self.emit(.deleteGlobal, location: location)
    throw self.unimplemented()
  }
  // MARK: - Fast

  /// Append a `loadFast` instruction to currently filled code object.
  public func emitLoadFast(value: VarNum, location: SourceLocation) throws {
    // try self.emit(.loadFast, location: location)
    throw self.unimplemented()
  }

  /// Append a `storeFast` instruction to currently filled code object.
  public func emitStoreFast(value: VarNum, location: SourceLocation) throws {
    // try self.emit(.storeFast, location: location)
    throw self.unimplemented()
  }

  /// Append a `deleteFast` instruction to currently filled code object.
  public func emitDeleteFast(value: VarNum, location: SourceLocation) throws {
    // try self.emit(.deleteFast, location: location)
    throw self.unimplemented()
  }

  // MARK: - Deref

  /// Append a `loadDeref` instruction to currently filled code object.
  public func emitLoadDeref(value: I, location: SourceLocation) throws {
    // try self.emit(.loadDeref, location: location)
    throw self.unimplemented()
  }

  /// Append a `storeDeref` instruction to currently filled code object.
  public func emitStoreDeref(value: I, location: SourceLocation) throws {
    // try self.emit(.storeDeref, location: location)
    throw self.unimplemented()
  }

  /// Append a `deleteDeref` instruction to currently filled code object.
  public func emitDeleteDeref(value: I, location: SourceLocation) throws {
    // try self.emit(.deleteDeref, location: location)
    throw self.unimplemented()
  }

  /// Append a `loadClassDeref` instruction to currently filled code object.
  public func emitLoadClassDeref(value: I, location: SourceLocation) throws {
    // try self.emit(.loadClassDeref, location: location)
    throw self.unimplemented()
  }
}
