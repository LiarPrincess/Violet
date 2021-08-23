import VioletCore

extension CodeObjectBuilder {

  // MARK: - Name

  /// Append a `storeName` instruction to this code object.
  public func appendStoreName(_ name: String) {
    let arg = self.appendExtendedArgsForNameIndex(name: name)
    self.append(.storeName(nameIndex: arg))
  }

  /// Append a `storeName` instruction to this code object.
  public func appendStoreName(_ name: MangledName) {
    self.appendStoreName(name.value)
  }

  /// Append a `loadName` instruction to this code object.
  public func appendLoadName(_ name: String) {
    let arg = self.appendExtendedArgsForNameIndex(name: name)
    self.append(.loadName(nameIndex: arg))
  }

  /// Append a `loadName` instruction to this code object.
  public func appendLoadName(_ name: MangledName) {
    self.appendLoadName(name.value)
  }

  /// Append a `deleteName` instruction to this code object.
  public func appendDeleteName(_ name: String) {
    let arg = self.appendExtendedArgsForNameIndex(name: name)
    self.append(.deleteName(nameIndex: arg))
  }

  /// Append a `deleteName` instruction to this code object.
  public func appendDeleteName(_ name: MangledName) {
    self.appendDeleteName(name.value)
  }

  // MARK: - Attribute

  /// Append a `storeAttr` instruction to this code object.
  public func appendStoreAttribute(_ name: String) {
    let arg = self.appendExtendedArgsForNameIndex(name: name)
    self.append(.storeAttribute(nameIndex: arg))
  }

  /// Append a `storeAttr` instruction to this code object.
  public func appendStoreAttribute(_ name: MangledName) {
    self.appendStoreAttribute(name.value)
  }

  /// Append a `loadAttr` instruction to this code object.
  public func appendLoadAttribute(_ name: String) {
    let arg = self.appendExtendedArgsForNameIndex(name: name)
    self.append(.loadAttribute(nameIndex: arg))
  }

  /// Append a `loadAttr` instruction to this code object.
  public func appendLoadAttribute(_ name: MangledName) {
    self.appendLoadAttribute(name.value)
  }

  /// Append a `deleteAttr` instruction to this code object.
  public func appendDeleteAttribute(_ name: String) {
    let arg = self.appendExtendedArgsForNameIndex(name: name)
    self.append(.deleteAttribute(nameIndex: arg))
  }

  /// Append a `deleteAttr` instruction to this code object.
  public func appendDeleteAttribute(_ name: MangledName) {
    self.appendDeleteAttribute(name.value)
  }

  // MARK: - Subscript

  /// Append a `binarySubscript` instruction to this code object.
  public func appendBinarySubscript() {
    self.append(.binarySubscript)
  }

  /// Append a `storeSubscript` instruction to this code object.
  public func appendStoreSubscript() {
    self.append(.storeSubscript)
  }

  /// Append a `deleteSubscript` instruction to this code object.
  public func appendDeleteSubscript() {
    self.append(.deleteSubscript)
  }

  // MARK: - Global

  /// Append a `storeGlobal` instruction to this code object.
  public func appendStoreGlobal(_ name: String) {
    let arg = self.appendExtendedArgsForNameIndex(name: name)
    self.append(.storeGlobal(nameIndex: arg))
  }

  /// Append a `storeGlobal` instruction to this code object.
  public func appendStoreGlobal(_ name: MangledName) {
    self.appendStoreGlobal(name.value)
  }

  /// Append a `loadGlobal` instruction to this code object.
  public func appendLoadGlobal(_ name: String) {
    let arg = self.appendExtendedArgsForNameIndex(name: name)
    self.append(.loadGlobal(nameIndex: arg))
  }

  /// Append a `loadGlobal` instruction to this code object.
  public func appendLoadGlobal(_ name: MangledName) {
    self.appendLoadGlobal(name.value)
  }

  /// Append a `deleteGlobal` instruction to this code object.
  public func appendDeleteGlobal(_ name: String) {
    let arg = self.appendExtendedArgsForNameIndex(name: name)
    self.append(.deleteGlobal(nameIndex: arg))
  }

  /// Append a `deleteGlobal` instruction to this code object.
  public func appendDeleteGlobal(_ name: MangledName) {
    self.appendDeleteGlobal(name.value)
  }

  // MARK: - Fast

  /// Append a `loadFast` instruction to this code object.
  public func appendLoadFast(_ name: MangledName) {
    let arg = self.appendExtendedArgsForVariableNameIndex(name: name)
    self.append(.loadFast(variableIndex: arg))
  }

  /// Append a `storeFast` instruction to this code object.
  public func appendStoreFast(_ name: MangledName) {
    let arg = self.appendExtendedArgsForVariableNameIndex(name: name)
    self.append(.storeFast(variableIndex: arg))
  }

  /// Append a `deleteFast` instruction to this code object.
  public func appendDeleteFast(_ name: MangledName) {
    let arg = self.appendExtendedArgsForVariableNameIndex(name: name)
    self.append(.deleteFast(variableIndex: arg))
  }

  // MARK: - Cell

  /// Append a `loadCell` instruction to this code object.
  public func appendLoadCell(_ name: MangledName) {
    let arg = self.appendExtendedArgsForCellVariableNameIndex(name: name)
    self.append(.loadCell(cellIndex: arg))
  }

  /// Append a `storeCell` instruction to this code object.
  public func appendStoreCell(_ name: MangledName) {
    let arg = self.appendExtendedArgsForCellVariableNameIndex(name: name)
    self.append(.storeCell(cellIndex: arg))
  }

  /// Append a `deleteCell` instruction to this code object.
  public func appendDeleteCell(_ name: MangledName) {
    let arg = self.appendExtendedArgsForCellVariableNameIndex(name: name)
    self.append(.deleteCell(cellIndex: arg))
  }

  // MARK: - Free

  /// Append a `loadFree` instruction to this code object.
  public func appendLoadFree(_ name: MangledName) {
    let arg = self.appendExtendedArgsForFreeVariableNameIndex(name: name)
    self.append(.loadFree(freeIndex: arg))
  }

  /// Append a `loadClassFree` instruction to this code object.
  public func appendLoadClassFree(_ name: MangledName) {
    let arg = self.appendExtendedArgsForFreeVariableNameIndex(name: name)
    self.append(.loadClassFree(freeIndex: arg))
  }

  /// Append a `storeFree` instruction to this code object.
  public func appendStoreFree(_ name: MangledName) {
    let arg = self.appendExtendedArgsForFreeVariableNameIndex(name: name)
    self.append(.storeFree(freeIndex: arg))
  }

  /// Append a `deleteFree` instruction to this code object.
  public func appendDeleteFree(_ name: MangledName) {
    let arg = self.appendExtendedArgsForFreeVariableNameIndex(name: name)
    self.append(.deleteFree(freeIndex: arg))
  }

  // MARK: - Load closure

  /// Append a `loadClosure` instruction to this code object.
  ///
  /// Pushes a reference to the cell contained in slot 'i'
  /// of the 'cell' or 'free' variable storage.
  /// If 'i' < cellVars.count: name of the variable is cellVars[i].
  /// otherwise:               name is freeVars[i - cellVars.count].
  public func appendLoadClosureCell(name: MangledName) {
    // static int
    // compiler_lookup_arg(PyObject *dict, PyObject *name)
    let arg = self.appendExtendedArgsForCellVariableNameIndex(name: name)
    self.append(.loadClosure(cellOrFreeIndex: arg))
  }

  /// Append a `loadClosure` instruction to this code object.
  ///
  /// Pushes a reference to the cell contained in slot 'i'
  /// of the 'cell' or 'free' variable storage.
  /// If 'i' < cellVars.count: name of the variable is cellVars[i].
  /// otherwise:               name is freeVars[i - cellVars.count].
  public func appendLoadClosureFree(name: MangledName) {
    // static int
    // compiler_lookup_arg(PyObject *dict, PyObject *name)
    let arg = self.appendExtendedArgsForFreeVariableNameIndex(name: name)
    self.append(.loadClosure(cellOrFreeIndex: arg))
  }
}
