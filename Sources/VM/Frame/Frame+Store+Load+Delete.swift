import Bytecode

extension Frame {

  /// Pushes constant pointed by `index` onto the stack.
  internal func loadConst(index: Int) throws {
    self.unimplemented()
  }

  /// Implements `name = TOS`.
  internal func storeName(nameIndex: Int) throws {
    self.unimplemented()
  }

  /// Pushes the value associated with `name` onto the stack.
  internal func loadName(nameIndex: Int) throws {
    self.unimplemented()
  }

  /// Implements `del name`.
  internal func deleteName(nameIndex: Int) throws {
    self.unimplemented()
  }

  /// Implements `TOS.name = TOS1`.
  internal func storeAttribute(nameIndex: Int) throws {
    self.unimplemented()
  }

  /// Replaces TOS with `getAttr(TOS, name)`.
  internal func loadAttribute(nameIndex: Int) throws {
    self.unimplemented()
  }

  /// Implements `del TOS.name`.
  internal func deleteAttribute(nameIndex: Int) throws {
    self.unimplemented()
  }

  /// Implements `TOS = TOS1[TOS]`.
  internal func binarySubscript() throws {
    self.unimplemented()
  }

  /// Implements `TOS1[TOS] = TOS2`.
  internal func storeSubscript() throws {
    self.unimplemented()
  }

  /// Implements `del TOS1[TOS]`.
  internal func deleteSubscript() throws {
    self.unimplemented()
  }

  /// Works as StoreName, but stores the name as a global.
  internal func storeGlobal(nameIndex: Int) throws {
    self.unimplemented()
  }

  /// Loads the global named `name` onto the stack.
  internal func loadGlobal(nameIndex: Int) throws {
    self.unimplemented()
  }

  /// Works as DeleteName, but deletes a global name.
  internal func deleteGlobal(nameIndex: Int) throws {
    self.unimplemented()
  }

  internal func loadFast(nameIndex: Int) throws {
    self.unimplemented()
  }

  internal func storeFast(nameIndex: Int) throws {
    self.unimplemented()
  }

  internal func deleteFast(nameIndex: Int) throws {
    self.unimplemented()
  }

  /// Loads the cell contained in slot i of the cell and free variable storage.
  /// Pushes a reference to the object the cell contains on the stack.
  internal func loadDeref(nameIndex: Int) throws {
    self.unimplemented()
  }

  /// Stores TOS into the cell contained in slot i of the cell and free variable storage.
  internal func storeDeref(nameIndex: Int) throws {
    self.unimplemented()
  }

  /// Empties the cell contained in slot i of the cell and free variable storage.
  /// Used by the del statement.
  internal func deleteDeref(nameIndex: Int) throws {
    self.unimplemented()
  }

  /// Much like `LoadDeref` but first checks the locals dictionary before consulting the cell.
  /// This is used for loading free variables in class bodies.
  internal func loadClassDeref(nameIndex: Int) throws {
    self.unimplemented()
  }
}
