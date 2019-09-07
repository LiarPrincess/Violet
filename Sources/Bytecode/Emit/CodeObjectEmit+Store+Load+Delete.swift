import Core

extension CodeObject {

  // MARK: - Name

  /// Append a `storeName` instruction to code object.
  public func emitStoreName<S: ConstantString>(_ name: S,
                                               location: SourceLocation) throws {
    let index = try self.addNameWithExtendedArgIfNeeded(name: name, location: location)
    try self.emit(.storeName(nameIndex: index), location: location)
  }

  /// Append a `loadName` instruction to code object.
  public func emitLoadName<S: ConstantString>(_ name: S,
                                              location: SourceLocation) throws {
    let index = try self.addNameWithExtendedArgIfNeeded(name: name, location: location)
    try self.emit(.loadName(nameIndex: index), location: location)
  }

  /// Append a `deleteName` instruction to code object.
  public func emitDeleteName<S: ConstantString>(_ name: S,
                                                location: SourceLocation) throws {
    let index = try self.addNameWithExtendedArgIfNeeded(name: name, location: location)
    try self.emit(.deleteName(nameIndex: index), location: location)
  }

  // MARK: - Attribute

  /// Append a `storeAttr` instruction to code object.
  public func emitStoreAttribute<S: ConstantString>(_ name: S,
                                                    location: SourceLocation) throws {
    let index = try self.addNameWithExtendedArgIfNeeded(name: name, location: location)
    try self.emit(.storeAttribute(nameIndex: index), location: location)
  }

  /// Append a `loadAttr` instruction to code object.
  public func emitLoadAttribute<S: ConstantString>(_ name: S,
                                                   location: SourceLocation) throws {
    let index = try self.addNameWithExtendedArgIfNeeded(name: name, location: location)
    try self.emit(.loadAttribute(nameIndex: index), location: location)
  }

  /// Append a `deleteAttr` instruction to code object.
  public func emitDeleteAttribute<S: ConstantString>(_ name: S,
                                                     location: SourceLocation) throws {
    let index = try self.addNameWithExtendedArgIfNeeded(name: name, location: location)
    try self.emit(.deleteAttribute(nameIndex: index), location: location)
  }

  // MARK: - Subscript

  /// Append a `binarySubscr` instruction to code object.
  public func emitBinarySubscr(location: SourceLocation) throws {
    try self.emit(.binarySubscript, location: location)
  }

  /// Append a `storeSubscr` instruction to code object.
  public func emitStoreSubscr(location: SourceLocation) throws {
    try self.emit(.storeSubscript, location: location)
  }

  /// Append a `deleteSubscr` instruction to code object.
  public func emitDeleteSubscr(location: SourceLocation) throws {
    try self.emit(.deleteSubscript, location: location)
  }

  // MARK: - Global

  /// Append a `storeGlobal` instruction to code object.
  public func emitStoreGlobal<S: ConstantString>(_ name: S,
                                                 location: SourceLocation) throws {
    let index = try self.addNameWithExtendedArgIfNeeded(name: name, location: location)
    try self.emit(.storeGlobal(nameIndex: index), location: location)
  }

  /// Append a `loadGlobal` instruction to code object.
  public func emitLoadGlobal<S: ConstantString>(_ name: S,
                                                location: SourceLocation) throws {
    let index = try self.addNameWithExtendedArgIfNeeded(name: name, location: location)
    try self.emit(.loadGlobal(nameIndex: index), location: location)
  }

  /// Append a `deleteGlobal` instruction to code object.
  public func emitDeleteGlobal<S: ConstantString>(_ name: S,
                                                  location: SourceLocation) throws {
    let index = try self.addNameWithExtendedArgIfNeeded(name: name, location: location)
    try self.emit(.deleteGlobal(nameIndex: index), location: location)
  }
  // MARK: - Fast

  /// Append a `loadFast` instruction to code object.
  public func emitLoadFast<S: ConstantString>(_ name: S,
                                              location: SourceLocation) throws {
    // try self.emit(.loadFast, location: location)
    throw self.unimplemented()
  }

  /// Append a `storeFast` instruction to code object.
  public func emitStoreFast<S: ConstantString>(_ name: S,
                                               location: SourceLocation) throws {
    // try self.emit(.storeFast, location: location)
    throw self.unimplemented()
  }

  /// Append a `deleteFast` instruction to code object.
  public func emitDeleteFast<S: ConstantString>(_ name: S,
                                                location: SourceLocation) throws {
    // try self.emit(.deleteFast, location: location)
    throw self.unimplemented()
  }

  // MARK: - Deref

  /// Append a `loadDeref` instruction to code object.
  public func emitLoadDeref<S: ConstantString>(_ name: S,
                                               location: SourceLocation) throws {
    // try self.emit(.loadDeref, location: location)
    throw self.unimplemented()
  }

  /// Append a `loadClassDeref` instruction to code object.
  public func emitLoadClassDeref<S: ConstantString>(_ name: S,
                                                    location: SourceLocation) throws {
    // try self.emit(.loadClassDeref, location: location)
    throw self.unimplemented()
  }

  /// Append a `storeDeref` instruction to code object.
  public func emitStoreDeref<S: ConstantString>(_ name: S,
                                                location: SourceLocation) throws {
    // try self.emit(.storeDeref, location: location)
    throw self.unimplemented()
  }

  /// Append a `deleteDeref` instruction to code object.
  public func emitDeleteDeref<S: ConstantString>(_ name: S,
                                                 location: SourceLocation) throws {
    // try self.emit(.deleteDeref, location: location)
    throw self.unimplemented()
  }
}
