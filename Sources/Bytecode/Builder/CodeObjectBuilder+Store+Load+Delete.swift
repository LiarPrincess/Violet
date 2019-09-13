import Core

extension CodeObjectBuilder {

  // MARK: - Name

  /// Append a `storeName` instruction to this code object.
  public func appendStoreName<S: ConstantString>(_ name: S) throws {
    let index = try self.addNameWithExtendedArgIfNeeded(name: name)
    try self.append(.storeName(nameIndex: index))
  }

  /// Append a `loadName` instruction to this code object.
  public func appendLoadName<S: ConstantString>(_ name: S) throws {
    let index = try self.addNameWithExtendedArgIfNeeded(name: name)
    try self.append(.loadName(nameIndex: index))
  }

  /// Append a `deleteName` instruction to this code object.
  public func appendDeleteName<S: ConstantString>(_ name: S) throws {
    let index = try self.addNameWithExtendedArgIfNeeded(name: name)
    try self.append(.deleteName(nameIndex: index))
  }

  // MARK: - Attribute

  /// Append a `storeAttr` instruction to this code object.
  public func appendStoreAttribute<S: ConstantString>(_ name: S) throws {
    let index = try self.addNameWithExtendedArgIfNeeded(name: name)
    try self.append(.storeAttribute(nameIndex: index))
  }

  /// Append a `loadAttr` instruction to this code object.
  public func appendLoadAttribute<S: ConstantString>(_ name: S) throws {
    let index = try self.addNameWithExtendedArgIfNeeded(name: name)
    try self.append(.loadAttribute(nameIndex: index))
  }

  /// Append a `deleteAttr` instruction to this code object.
  public func appendDeleteAttribute<S: ConstantString>(_ name: S) throws {
    let index = try self.addNameWithExtendedArgIfNeeded(name: name)
    try self.append(.deleteAttribute(nameIndex: index))
  }

  // MARK: - Subscript

  /// Append a `binarySubscr` instruction to this code object.
  public func appendBinarySubscr() throws {
    try self.append(.binarySubscript)
  }

  /// Append a `storeSubscr` instruction to this code object.
  public func appendStoreSubscr() throws {
    try self.append(.storeSubscript)
  }

  /// Append a `deleteSubscr` instruction to this code object.
  public func appendDeleteSubscr() throws {
    try self.append(.deleteSubscript)
  }

  // MARK: - Global

  /// Append a `storeGlobal` instruction to this code object.
  public func appendStoreGlobal<S: ConstantString>(_ name: S) throws {
    let index = try self.addNameWithExtendedArgIfNeeded(name: name)
    try self.append(.storeGlobal(nameIndex: index))
  }

  /// Append a `loadGlobal` instruction to this code object.
  public func appendLoadGlobal<S: ConstantString>(_ name: S) throws {
    let index = try self.addNameWithExtendedArgIfNeeded(name: name)
    try self.append(.loadGlobal(nameIndex: index))
  }

  /// Append a `deleteGlobal` instruction to this code object.
  public func appendDeleteGlobal<S: ConstantString>(_ name: S) throws {
    let index = try self.addNameWithExtendedArgIfNeeded(name: name)
    try self.append(.deleteGlobal(nameIndex: index))
  }
  // MARK: - Fast

  /// Append a `loadFast` instruction to this code object.
  public func appendLoadFast<S: ConstantString>(_ name: S) throws {
    // try self.append(.loadFast)
    throw self.unimplemented()
  }

  /// Append a `storeFast` instruction to this code object.
  public func appendStoreFast<S: ConstantString>(_ name: S) throws {
    // try self.append(.storeFast)
    throw self.unimplemented()
  }

  /// Append a `deleteFast` instruction to this code object.
  public func appendDeleteFast<S: ConstantString>(_ name: S) throws {
    // try self.append(.deleteFast)
    throw self.unimplemented()
  }

  // MARK: - Deref

  /// Append a `loadDeref` instruction to this code object.
  public func appendLoadDeref<S: ConstantString>(_ name: S) throws {
    // try self.append(.loadDeref)
    throw self.unimplemented()
  }

  /// Append a `loadClassDeref` instruction to this code object.
  public func appendLoadClassDeref<S: ConstantString>(_ name: S) throws {
    // try self.append(.loadClassDeref)
    throw self.unimplemented()
  }

  /// Append a `storeDeref` instruction to this code object.
  public func appendStoreDeref<S: ConstantString>(_ name: S) throws {
    // try self.append(.storeDeref)
    throw self.unimplemented()
  }

  /// Append a `deleteDeref` instruction to this code object.
  public func appendDeleteDeref<S: ConstantString>(_ name: S) throws {
    // try self.append(.deleteDeref)
    throw self.unimplemented()
  }
}
