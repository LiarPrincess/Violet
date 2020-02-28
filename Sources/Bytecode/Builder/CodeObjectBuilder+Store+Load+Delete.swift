import Core

public enum ClosureType {
  /// Captured variable
  case cell
  /// Closure over 'name'
  case free
}

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

  /// Append a `binarySubscr` instruction to this code object.
  public func appendBinarySubscr() {
    self.append(.binarySubscript)
  }

  /// Append a `storeSubscr` instruction to this code object.
  public func appendStoreSubscr() {
    self.append(.storeSubscript)
  }

  /// Append a `deleteSubscr` instruction to this code object.
  public func appendDeleteSubscr() {
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
    let index = self.addVarNameWithExtendedArgIfNeeded(name: name)
    self.append(.loadFast(nameIndex: index))
  }

  /// Append a `storeFast` instruction to this code object.
  public func appendStoreFast(_ name: MangledName) {
    let index = self.addVarNameWithExtendedArgIfNeeded(name: name)
    self.append(.storeFast(nameIndex: index))
  }

  /// Append a `deleteFast` instruction to this code object.
  public func appendDeleteFast(_ name: MangledName) {
    let index = self.addVarNameWithExtendedArgIfNeeded(name: name)
    self.append(.deleteFast(nameIndex: index))
  }

  // MARK: - Deref

  /// Append a `loadDeref` instruction to this code object.
  public func appendLoadDeref<S: ConstantString>(_ name: S) {
    let index = self.addNameWithExtendedArgIfNeeded(name: name)
    self.append(.loadDeref(nameIndex: index))
  }

  /// Append a `loadClassDeref` instruction to this code object.
  public func appendLoadClassDeref<S: ConstantString>(_ name: S) {
    let index = self.addNameWithExtendedArgIfNeeded(name: name)
    self.append(.loadClassDeref(nameIndex: index))
  }

  /// Append a `storeDeref` instruction to this code object.
  public func appendStoreDeref<S: ConstantString>(_ name: S) {
    let index = self.addNameWithExtendedArgIfNeeded(name: name)
    self.append(.storeDeref(nameIndex: index))
  }

  /// Append a `deleteDeref` instruction to this code object.
  public func appendDeleteDeref<S: ConstantString>(_ name: S) {
    let index = self.addNameWithExtendedArgIfNeeded(name: name)
    self.append(.deleteDeref(nameIndex: index))
  }

  // MARK: - Load closure

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
      let names = self.codeObject.cellVariableNames
      guard let index = names.firstIndex(of: name) else {
        trap("[LoadClosure] Name '\(name.value)' was not found in cell variables.")
      }

      return index

    case .free:
      let names = self.codeObject.freeVariableNames
      guard let index = names.firstIndex(of: name) else {
        trap("[LoadClosure] Name '\(name.value)' was not found in free variables.")
      }

      let offset = self.codeObject.cellVariableNames.count
      return offset + index
    }
  }
}
