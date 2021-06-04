import VioletCore

extension CodeObjectBuilder {

  // MARK: - Name

  /// Append a `storeName` instruction to this code object.
  public func appendStoreName(_ name: String) {
    let index = self.addNameWithExtendedArgIfNeeded(name: name)
    self.append(.storeName(nameIndex: index))
  }

  /// Append a `storeName` instruction to this code object.
  public func appendStoreName(_ name: MangledName) {
    self.appendStoreName(name.value)
  }

  /// Append a `loadName` instruction to this code object.
  public func appendLoadName(_ name: String) {
    let index = self.addNameWithExtendedArgIfNeeded(name: name)
    self.append(.loadName(nameIndex: index))
  }

  /// Append a `loadName` instruction to this code object.
  public func appendLoadName(_ name: MangledName) {
    self.appendLoadName(name.value)
  }

  /// Append a `deleteName` instruction to this code object.
  public func appendDeleteName(_ name: String) {
    let index = self.addNameWithExtendedArgIfNeeded(name: name)
    self.append(.deleteName(nameIndex: index))
  }

  /// Append a `deleteName` instruction to this code object.
  public func appendDeleteName(_ name: MangledName) {
    self.appendDeleteName(name.value)
  }

  // MARK: - Attribute

  /// Append a `storeAttr` instruction to this code object.
  public func appendStoreAttribute(_ name: String) {
    let index = self.addNameWithExtendedArgIfNeeded(name: name)
    self.append(.storeAttribute(nameIndex: index))
  }

  /// Append a `storeAttr` instruction to this code object.
  public func appendStoreAttribute(_ name: MangledName) {
    self.appendStoreAttribute(name.value)
  }

  /// Append a `loadAttr` instruction to this code object.
  public func appendLoadAttribute(_ name: String) {
    let index = self.addNameWithExtendedArgIfNeeded(name: name)
    self.append(.loadAttribute(nameIndex: index))
  }

  /// Append a `loadAttr` instruction to this code object.
  public func appendLoadAttribute(_ name: MangledName) {
    self.appendLoadAttribute(name.value)
  }

  /// Append a `deleteAttr` instruction to this code object.
  public func appendDeleteAttribute(_ name: String) {
    let index = self.addNameWithExtendedArgIfNeeded(name: name)
    self.append(.deleteAttribute(nameIndex: index))
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
    let index = self.addNameWithExtendedArgIfNeeded(name: name)
    self.append(.storeGlobal(nameIndex: index))
  }

  /// Append a `storeGlobal` instruction to this code object.
  public func appendStoreGlobal(_ name: MangledName) {
    self.appendStoreGlobal(name.value)
  }

  /// Append a `loadGlobal` instruction to this code object.
  public func appendLoadGlobal(_ name: String) {
    let index = self.addNameWithExtendedArgIfNeeded(name: name)
    self.append(.loadGlobal(nameIndex: index))
  }

  /// Append a `loadGlobal` instruction to this code object.
  public func appendLoadGlobal(_ name: MangledName) {
    self.appendLoadGlobal(name.value)
  }

  /// Append a `deleteGlobal` instruction to this code object.
  public func appendDeleteGlobal(_ name: String) {
    let index = self.addNameWithExtendedArgIfNeeded(name: name)
    self.append(.deleteGlobal(nameIndex: index))
  }

  /// Append a `deleteGlobal` instruction to this code object.
  public func appendDeleteGlobal(_ name: MangledName) {
    self.appendDeleteGlobal(name.value)
  }

  // MARK: - Fast

  /// Append a `loadFast` instruction to this code object.
  public func appendLoadFast(_ name: MangledName) {
    let index = self.addVariableNameWithExtendedArgIfNeeded(name: name)
    self.append(.loadFast(variableIndex: index))
  }

  /// Append a `storeFast` instruction to this code object.
  public func appendStoreFast(_ name: MangledName) {
    let index = self.addVariableNameWithExtendedArgIfNeeded(name: name)
    self.append(.storeFast(variableIndex: index))
  }

  /// Append a `deleteFast` instruction to this code object.
  public func appendDeleteFast(_ name: MangledName) {
    let index = self.addVariableNameWithExtendedArgIfNeeded(name: name)
    self.append(.deleteFast(variableIndex: index))
  }

  // MARK: - Cell

  /// Append a `loadCellOrFree` instruction to this code object.
  public func appendLoadCell(_ name: MangledName) {
    let index = self.addCellVariableNameWithExtendedArgIfNeeded(name: name)
    self.append(.loadCellOrFree(cellOrFreeIndex: index))
  }

  /// Append a `loadClassCell` instruction to this code object.
  public func appendLoadClassCell(_ name: MangledName) {
    let index = self.addCellVariableNameWithExtendedArgIfNeeded(name: name)
    self.append(.loadClassCell(cellOrFreeIndex: index))
  }

  /// Append a `storeCellOrFree` instruction to this code object.
  public func appendStoreCell(_ name: MangledName) {
    let index = self.addCellVariableNameWithExtendedArgIfNeeded(name: name)
    self.append(.storeCellOrFree(cellOrFreeIndex: index))
  }

  /// Append a `deleteCellOrFree` instruction to this code object.
  public func appendDeleteCell(_ name: MangledName) {
    let index = self.addCellVariableNameWithExtendedArgIfNeeded(name: name)
    self.append(.deleteCellOrFree(cellOrFreeIndex: index))
  }

  // MARK: - Free

  /// Append a `loadCellOrFree` instruction to this code object.
  public func appendLoadFree(_ name: MangledName) {
    let index = self.addFreeVariableNameWithExtendedArgIfNeeded(name: name)
    self.append(.loadCellOrFree(cellOrFreeIndex: index))
  }

  /// Append a `storeCellOrFree` instruction to this code object.
  public func appendStoreFree(_ name: MangledName) {
    let index = self.addFreeVariableNameWithExtendedArgIfNeeded(name: name)
    self.append(.storeCellOrFree(cellOrFreeIndex: index))
  }

  /// Append a `deleteCellOrFree` instruction to this code object.
  public func appendDeleteFree(_ name: MangledName) {
    let index = self.addFreeVariableNameWithExtendedArgIfNeeded(name: name)
    self.append(.deleteCellOrFree(cellOrFreeIndex: index))
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
    let names = self.cellVariableNames
    guard let index = names.firstIndex(of: name) else {
      trap("[LoadClosure] Name '\(name.value)' was not found in cell variables.")
    }

    let arg = self.appendExtendedArgIfNeeded(index)
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
    let names = self.freeVariableNames
    guard let indexInNames = names.firstIndex(of: name) else {
      trap("[LoadClosure] Name '\(name.value)' was not found in free variables.")
    }

    let index = self.offsetFreeVariable(index: indexInNames)
    let arg = self.appendExtendedArgIfNeeded(index)
    self.append(.loadClosure(cellOrFreeIndex: arg))
  }
}
