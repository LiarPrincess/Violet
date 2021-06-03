import VioletCore

extension CodeObjectBuilder {

  // MARK: - Name

  /// Append a `storeName` instruction to this code object.
  public func appendStoreName<S: ConstantString>(_ name: S) {
    let index = self.addNameWithExtendedArgIfNeeded(name: name)
    self.append(.storeName(nameIndex: index))
  }

  /// Append a `loadName` instruction to this code object.
  public func appendLoadName<S: ConstantString>(_ name: S) {
    let index = self.addNameWithExtendedArgIfNeeded(name: name)
    self.append(.loadName(nameIndex: index))
  }

  /// Append a `deleteName` instruction to this code object.
  public func appendDeleteName<S: ConstantString>(_ name: S) {
    let index = self.addNameWithExtendedArgIfNeeded(name: name)
    self.append(.deleteName(nameIndex: index))
  }

  // MARK: - Attribute

  /// Append a `storeAttr` instruction to this code object.
  public func appendStoreAttribute<S: ConstantString>(_ name: S) {
    let index = self.addNameWithExtendedArgIfNeeded(name: name)
    self.append(.storeAttribute(nameIndex: index))
  }

  /// Append a `loadAttr` instruction to this code object.
  public func appendLoadAttribute<S: ConstantString>(_ name: S) {
    let index = self.addNameWithExtendedArgIfNeeded(name: name)
    self.append(.loadAttribute(nameIndex: index))
  }

  /// Append a `deleteAttr` instruction to this code object.
  public func appendDeleteAttribute<S: ConstantString>(_ name: S) {
    let index = self.addNameWithExtendedArgIfNeeded(name: name)
    self.append(.deleteAttribute(nameIndex: index))
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
  public func appendStoreGlobal<S: ConstantString>(_ name: S) {
    let index = self.addNameWithExtendedArgIfNeeded(name: name)
    self.append(.storeGlobal(nameIndex: index))
  }

  /// Append a `loadGlobal` instruction to this code object.
  public func appendLoadGlobal<S: ConstantString>(_ name: S) {
    let index = self.addNameWithExtendedArgIfNeeded(name: name)
    self.append(.loadGlobal(nameIndex: index))
  }

  /// Append a `deleteGlobal` instruction to this code object.
  public func appendDeleteGlobal<S: ConstantString>(_ name: S) {
    let index = self.addNameWithExtendedArgIfNeeded(name: name)
    self.append(.deleteGlobal(nameIndex: index))
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

  // MARK: - Cell or free

  public enum CellOrFree {
    case cell
    case free
  }

  /// Append a `loadCellOrFree` instruction to this code object.
  public func appendLoadCellOrFree(_ name: MangledName, type: CellOrFree) {
    let index = self.addCellOrFreeVariableName(name, type: type)
    self.append(.loadCellOrFree(cellOrFreeIndex: index))
  }

  /// Append a `loadClassCell` instruction to this code object.
  public func appendLoadClassCell(_ name: MangledName, type: CellOrFree) {
    let index = self.addCellOrFreeVariableName(name, type: type)
    self.append(.loadClassCell(cellOrFreeIndex: index))
  }

  /// Append a `storeCellOrFree` instruction to this code object.
  public func appendStoreCellOrFree(_ name: MangledName, type: CellOrFree) {
    let index = self.addCellOrFreeVariableName(name, type: type)
    self.append(.storeCellOrFree(cellOrFreeIndex: index))
  }

  /// Append a `deleteCellOrFree` instruction to this code object.
  public func appendDeleteCellOrFree(_ name: MangledName, type: CellOrFree) {
    let index = self.addCellOrFreeVariableName(name, type: type)
    self.append(.deleteCellOrFree(cellOrFreeIndex: index))
  }

  private func addCellOrFreeVariableName(_ name: MangledName,
                                         type: CellOrFree) -> UInt8 {
    switch type {
    case .cell:
      return self.addCellVariableNameWithExtendedArgIfNeeded(name: name)
    case .free:
      return self.addFreeVariableNameWithExtendedArgIfNeeded(name: name)
    }
  }

  // MARK: - Load closure

  public enum ClosureType {
    case cell
    case free
  }

  /// Append a `loadClosure` instruction to this code object.
  ///
  /// Pushes a reference to the cell contained in slot 'i'
  /// of the 'cell' or 'free' variable storage.
  /// If 'i' < cellVars.count: name of the variable is cellVars[i].
  /// otherwise:               name is freeVars[i - cellVars.count].
  public func appendLoadClosure(name: MangledName, type: ClosureType) {
    let index = self.getLoadClosureArg(name: name, type: type)
    let arg = self.appendExtendedArgIfNeeded(index)
    self.append(.loadClosure(cellOrFreeIndex: arg))
  }

  // static int
  // compiler_lookup_arg(PyObject *dict, PyObject *name)
  private func getLoadClosureArg(name: MangledName, type: ClosureType) -> Int {
    switch type {
    case .cell:
      let names = self.cellVariableNames
      guard let index = names.firstIndex(of: name) else {
        trap("[LoadClosure] Name '\(name.value)' was not found in cell variables.")
      }

      return index

    case .free:
      let names = self.freeVariableNames
      guard let index = names.firstIndex(of: name) else {
        trap("[LoadClosure] Name '\(name.value)' was not found in free variables.")
      }

      return self.offsetFreeVariable(index: index)
    }
  }
}
