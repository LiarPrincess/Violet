import Bytecode
import Objects

extension Frame {

  // MARK: - Constant

  /// Pushes constant pointed by `index` onto the stack.
  internal func loadConst(index: Int) throws {
    let value = self.code.constants[index]
    let object = self.toObject(value)
    self.push(object)
  }

  private func toObject(_ value: Constant) -> PyObject {
    switch value {
    case .true: return self.context.true
    case .false: return self.context.false
    case .none: return self.context.none
    case .ellipsis: return self.context.ellipsis
    case let .integer(arg): return self.context.int(value: arg)
    case let .float(arg): return self.context.float(value: arg)
    case let .complex(real, imag): return self.context.complex(real: real, imag: imag)
    case let .string(arg): return self.context.string(value: arg)
    case .bytes: // let .bytes(arg):
      fatalError()
    case .code: // let .code(arg):
      fatalError()
    case let .tuple(args):
      let elements = args.map { self.toObject($0) }
      return self.context.tuple(elements: elements)
    }
  }

  // MARK: - Name

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

  // MARK: - Attribute

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

  // MARK: - Subscript

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

  // MARK: - Global

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

  // MARK: - Fast

  internal func loadFast(nameIndex: Int) throws {
    self.unimplemented()
  }

  internal func storeFast(nameIndex: Int) throws {
    self.unimplemented()
  }

  internal func deleteFast(nameIndex: Int) throws {
    self.unimplemented()
  }

  // MARK: - Deref

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
