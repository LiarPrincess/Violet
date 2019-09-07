import Core

extension CodeObject {

  // MARK: - Name

  /// Append a `storeName` instruction to code object.
  public func appendStoreName<S: ConstantString>(_ name: S,
                                                 at location: SourceLocation) throws {

    let index = try self.addNameWithExtendedArgIfNeeded(name: name, at: location)
    try self.append(.storeName(nameIndex: index), at: location)
  }

  /// Append a `loadName` instruction to code object.
  public func appendLoadName<S: ConstantString>(_ name: S,
                                                at location: SourceLocation) throws {

    let index = try self.addNameWithExtendedArgIfNeeded(name: name, at: location)
    try self.append(.loadName(nameIndex: index), at: location)
  }

  /// Append a `deleteName` instruction to code object.
  public func appendDeleteName<S: ConstantString>(_ name: S,
                                                  at location: SourceLocation) throws {

    let index = try self.addNameWithExtendedArgIfNeeded(name: name, at: location)
    try self.append(.deleteName(nameIndex: index), at: location)
  }

  // MARK: - Attribute

  /// Append a `storeAttr` instruction to code object.
  public func appendStoreAttribute<S: ConstantString>(_ name: S,
                                                      at location: SourceLocation) throws {

    let index = try self.addNameWithExtendedArgIfNeeded(name: name, at: location)
    try self.append(.storeAttribute(nameIndex: index), at: location)
  }

  /// Append a `loadAttr` instruction to code object.
  public func appendLoadAttribute<S: ConstantString>(_ name: S,
                                                     at location: SourceLocation) throws {

    let index = try self.addNameWithExtendedArgIfNeeded(name: name, at: location)
    try self.append(.loadAttribute(nameIndex: index), at: location)
  }

  /// Append a `deleteAttr` instruction to code object.
  public func appendDeleteAttribute<S: ConstantString>(_ name: S,
                                                       at location: SourceLocation) throws {
    let index = try self.addNameWithExtendedArgIfNeeded(name: name, at: location)
    try self.append(.deleteAttribute(nameIndex: index), at: location)
  }

  // MARK: - Subscript

  /// Append a `binarySubscr` instruction to code object.
  public func appendBinarySubscr(at location: SourceLocation) throws {
    try self.append(.binarySubscript, at: location)
  }

  /// Append a `storeSubscr` instruction to code object.
  public func appendStoreSubscr(at location: SourceLocation) throws {
    try self.append(.storeSubscript, at: location)
  }

  /// Append a `deleteSubscr` instruction to code object.
  public func appendDeleteSubscr(at location: SourceLocation) throws {
    try self.append(.deleteSubscript, at: location)
  }

  // MARK: - Global

  /// Append a `storeGlobal` instruction to code object.
  public func appendStoreGlobal<S: ConstantString>(_ name: S,
                                                   at location: SourceLocation) throws {
    let index = try self.addNameWithExtendedArgIfNeeded(name: name, at: location)
    try self.append(.storeGlobal(nameIndex: index), at: location)
  }

  /// Append a `loadGlobal` instruction to code object.
  public func appendLoadGlobal<S: ConstantString>(_ name: S,
                                                  at location: SourceLocation) throws {
    let index = try self.addNameWithExtendedArgIfNeeded(name: name, at: location)
    try self.append(.loadGlobal(nameIndex: index), at: location)
  }

  /// Append a `deleteGlobal` instruction to code object.
  public func appendDeleteGlobal<S: ConstantString>(_ name: S,
                                                    at location: SourceLocation) throws {
    let index = try self.addNameWithExtendedArgIfNeeded(name: name, at: location)
    try self.append(.deleteGlobal(nameIndex: index), at: location)
  }
  // MARK: - Fast

  /// Append a `loadFast` instruction to code object.
  public func appendLoadFast<S: ConstantString>(_ name: S,
                                                at location: SourceLocation) throws {
    // try self.append(.loadFast, at: location)
    throw self.unimplemented()
  }

  /// Append a `storeFast` instruction to code object.
  public func appendStoreFast<S: ConstantString>(_ name: S,
                                                 at location: SourceLocation) throws {
    // try self.append(.storeFast, at: location)
    throw self.unimplemented()
  }

  /// Append a `deleteFast` instruction to code object.
  public func appendDeleteFast<S: ConstantString>(_ name: S,
                                                  at location: SourceLocation) throws {
    // try self.append(.deleteFast, at: location)
    throw self.unimplemented()
  }

  // MARK: - Deref

  /// Append a `loadDeref` instruction to code object.
  public func appendLoadDeref<S: ConstantString>(_ name: S,
                                                 at location: SourceLocation) throws {
    // try self.append(.loadDeref, at: location)
    throw self.unimplemented()
  }

  /// Append a `loadClassDeref` instruction to code object.
  public func appendLoadClassDeref<S: ConstantString>(_ name: S,
                                                      at location: SourceLocation) throws {
    // try self.append(.loadClassDeref, at: location)
    throw self.unimplemented()
  }

  /// Append a `storeDeref` instruction to code object.
  public func appendStoreDeref<S: ConstantString>(_ name: S,
                                                  at location: SourceLocation) throws {
    // try self.append(.storeDeref, at: location)
    throw self.unimplemented()
  }

  /// Append a `deleteDeref` instruction to code object.
  public func appendDeleteDeref<S: ConstantString>(_ name: S,
                                                   at location: SourceLocation) throws {
    // try self.append(.deleteDeref, at: location)
    throw self.unimplemented()
  }
}
