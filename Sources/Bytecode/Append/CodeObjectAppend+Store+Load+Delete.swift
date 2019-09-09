import Core

extension CodeObject {

  // MARK: - Name

  /// Append a `storeName` instruction to this code object.
  public func appendStoreName<S: ConstantString>(_ name: S,
                                                 at location: SourceLocation) throws {

    let index = try self.addNameWithExtendedArgIfNeeded(name: name, at: location)
    try self.append(.storeName(nameIndex: index), at: location)
  }

  /// Append a `loadName` instruction to this code object.
  public func appendLoadName<S: ConstantString>(_ name: S,
                                                at location: SourceLocation) throws {

    let index = try self.addNameWithExtendedArgIfNeeded(name: name, at: location)
    try self.append(.loadName(nameIndex: index), at: location)
  }

  /// Append a `deleteName` instruction to this code object.
  public func appendDeleteName<S: ConstantString>(_ name: S,
                                                  at location: SourceLocation) throws {

    let index = try self.addNameWithExtendedArgIfNeeded(name: name, at: location)
    try self.append(.deleteName(nameIndex: index), at: location)
  }

  // MARK: - Attribute

  /// Append a `storeAttr` instruction to this code object.
  public func appendStoreAttribute<S: ConstantString>(_ name: S,
                                                      at location: SourceLocation) throws {

    let index = try self.addNameWithExtendedArgIfNeeded(name: name, at: location)
    try self.append(.storeAttribute(nameIndex: index), at: location)
  }

  /// Append a `loadAttr` instruction to this code object.
  public func appendLoadAttribute<S: ConstantString>(_ name: S,
                                                     at location: SourceLocation) throws {

    let index = try self.addNameWithExtendedArgIfNeeded(name: name, at: location)
    try self.append(.loadAttribute(nameIndex: index), at: location)
  }

  /// Append a `deleteAttr` instruction to this code object.
  public func appendDeleteAttribute<S: ConstantString>(_ name: S,
                                                       at location: SourceLocation) throws {
    let index = try self.addNameWithExtendedArgIfNeeded(name: name, at: location)
    try self.append(.deleteAttribute(nameIndex: index), at: location)
  }

  // MARK: - Subscript

  /// Append a `binarySubscr` instruction to this code object.
  public func appendBinarySubscr(at location: SourceLocation) throws {
    try self.append(.binarySubscript, at: location)
  }

  /// Append a `storeSubscr` instruction to this code object.
  public func appendStoreSubscr(at location: SourceLocation) throws {
    try self.append(.storeSubscript, at: location)
  }

  /// Append a `deleteSubscr` instruction to this code object.
  public func appendDeleteSubscr(at location: SourceLocation) throws {
    try self.append(.deleteSubscript, at: location)
  }

  // MARK: - Global

  /// Append a `storeGlobal` instruction to this code object.
  public func appendStoreGlobal<S: ConstantString>(_ name: S,
                                                   at location: SourceLocation) throws {
    let index = try self.addNameWithExtendedArgIfNeeded(name: name, at: location)
    try self.append(.storeGlobal(nameIndex: index), at: location)
  }

  /// Append a `loadGlobal` instruction to this code object.
  public func appendLoadGlobal<S: ConstantString>(_ name: S,
                                                  at location: SourceLocation) throws {
    let index = try self.addNameWithExtendedArgIfNeeded(name: name, at: location)
    try self.append(.loadGlobal(nameIndex: index), at: location)
  }

  /// Append a `deleteGlobal` instruction to this code object.
  public func appendDeleteGlobal<S: ConstantString>(_ name: S,
                                                    at location: SourceLocation) throws {
    let index = try self.addNameWithExtendedArgIfNeeded(name: name, at: location)
    try self.append(.deleteGlobal(nameIndex: index), at: location)
  }
  // MARK: - Fast

  /// Append a `loadFast` instruction to this code object.
  public func appendLoadFast<S: ConstantString>(_ name: S,
                                                at location: SourceLocation) throws {
    // try self.append(.loadFast, at: location)
    throw self.unimplemented()
  }

  /// Append a `storeFast` instruction to this code object.
  public func appendStoreFast<S: ConstantString>(_ name: S,
                                                 at location: SourceLocation) throws {
    // try self.append(.storeFast, at: location)
    throw self.unimplemented()
  }

  /// Append a `deleteFast` instruction to this code object.
  public func appendDeleteFast<S: ConstantString>(_ name: S,
                                                  at location: SourceLocation) throws {
    // try self.append(.deleteFast, at: location)
    throw self.unimplemented()
  }

  // MARK: - Deref

  /// Append a `loadDeref` instruction to this code object.
  public func appendLoadDeref<S: ConstantString>(_ name: S,
                                                 at location: SourceLocation) throws {
    // try self.append(.loadDeref, at: location)
    throw self.unimplemented()
  }

  /// Append a `loadClassDeref` instruction to this code object.
  public func appendLoadClassDeref<S: ConstantString>(_ name: S,
                                                      at location: SourceLocation) throws {
    // try self.append(.loadClassDeref, at: location)
    throw self.unimplemented()
  }

  /// Append a `storeDeref` instruction to this code object.
  public func appendStoreDeref<S: ConstantString>(_ name: S,
                                                  at location: SourceLocation) throws {
    // try self.append(.storeDeref, at: location)
    throw self.unimplemented()
  }

  /// Append a `deleteDeref` instruction to this code object.
  public func appendDeleteDeref<S: ConstantString>(_ name: S,
                                                   at location: SourceLocation) throws {
    // try self.append(.deleteDeref, at: location)
    throw self.unimplemented()
  }
}
