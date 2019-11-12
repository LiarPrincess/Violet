import Bytecode
import Objects

extension Frame {

  // MARK: - Constant

  /// Pushes constant pointed by `index` onto the stack.
  internal func loadConst(index: Int) throws {
    let value = self.code.constants[index]
    let object = self.toObject(value)
    self.stack.push(object)
  }

  private func toObject(_ value: Constant) -> PyObject {
    switch value {
    case .true: return self.context.true
    case .false: return self.context.false
    case .none: return self.context.none
    case .ellipsis: return self.context.ellipsis
    case let .integer(arg): return self.builtins.newInt(arg)
    case let .float(arg): return self.builtins.newFloat(arg)
    case let .complex(real, imag): return self.builtins.newComplex(real: real, imag: imag)
    case let .string(arg): return self.builtins.newString(arg)
    case .bytes: // let .bytes(arg):
      fatalError()
    case .code: // let .code(arg):
      fatalError()
    case let .tuple(args):
      let elements = args.map(self.toObject)
      return self.builtins.newTuple(elements)
    }
  }

  // MARK: - Name

  /// Implements `name = TOS`.
  internal func storeName(nameIndex: Int) throws {
    let name = self.code.names[nameIndex]
    let value = self.stack.pop()
    self.localSymbols[name] = value
  }

  /// Pushes the value associated with `name` onto the stack.
  internal func loadName(nameIndex: Int) throws {
    let name = self.code.names[nameIndex]

    if let local = self.localSymbols[name] {
      self.stack.push(local)
      return
    }

    if let global = self.globalSymbols[name] {
      self.stack.push(global)
      return
    }

    if let builtin = self.builtinSymbols[name] {
      self.stack.push(builtin)
      return
    }

    // format_exc_check_arg(PyExc_NameError, NAME_ERROR_MSG, name);
    fatalError()
  }

  /// Implements `del name`.
  internal func deleteName(nameIndex: Int) throws {
    let name = self.code.names[nameIndex]
    let value = self.localSymbols.removeValue(forKey: name)

    if value == nil {
      // format_exc_check_arg(PyExc_NameError, NAME_ERROR_MSG, name);
      fatalError()
    }
  }

  // MARK: - Attribute

  /// Implements `TOS.name = TOS1`.
  internal func storeAttribute(nameIndex: Int) throws {
    let name = self.code.names[nameIndex]
    let object = self.stack.pop()
    let value = self.stack.pop()
    try self.context.setAttribute(object: object, name: name, value: value)
  }

  /// Replaces TOS with `getAttr(TOS, name)`.
  internal func loadAttribute(nameIndex: Int) throws {
    let name = self.code.names[nameIndex]
    let object = self.stack.top
    let result = try self.context.getAttribute(object: object, name: name)
    self.stack.top = result
  }

  /// Implements `del TOS.name`.
  internal func deleteAttribute(nameIndex: Int) throws {
    let name = self.code.names[nameIndex]
    let object = self.stack.pop()
    try self.context.deleteAttribute(object: object, name: name)
  }

  // MARK: - Subscript

  /// Implements `TOS = TOS1[TOS]`.
  internal func binarySubscript() throws {
    let index = self.stack.pop()
    let object = self.stack.top
    let result = try self.context.getItem(object: object, index: index)
    self.stack.top = result
  }

  /// Implements `TOS1[TOS] = TOS2`.
  internal func storeSubscript() throws {
    let index = self.stack.pop()
    let object = self.stack.pop()
    let value = self.stack.pop()
    try self.context.setItem(object: object, index: index, value: value)
  }

  /// Implements `del TOS1[TOS]`.
  internal func deleteSubscript() throws {
    let index = self.stack.pop()
    let object = self.stack.pop()
    try self.context.deleteItem(object: object, index: index)
  }

  // MARK: - Global

  /// Works as StoreName, but stores the name as a global.
  internal func storeGlobal(nameIndex: Int) throws {
    let name = self.code.names[nameIndex]
    let value = self.stack.pop()
    self.globalSymbols[name] = value
  }

  /// Loads the global named `name` onto the stack.
  internal func loadGlobal(nameIndex: Int) throws {
    let name = self.code.names[nameIndex]

    if let global = self.globalSymbols[name] {
      self.stack.push(global)
      return
    }

    if let builtin = self.builtinSymbols[name] {
      self.stack.push(builtin)
      return
    }

    // format_exc_check_arg(PyExc_NameError, NAME_ERROR_MSG, name);
    fatalError()
  }

  /// Works as DeleteName, but deletes a global name.
  internal func deleteGlobal(nameIndex: Int) throws {
    let name = self.code.names[nameIndex]
    let value = self.globalSymbols.removeValue(forKey: name)

    if value == nil {
      // format_exc_check_arg(PyExc_NameError, NAME_ERROR_MSG, name);
      fatalError()
    }
  }

  // MARK: - Fast

  internal func loadFast(nameIndex: Int) throws {
    let name = self.code.names[nameIndex]

    if let local = self.localSymbols[name] {
      self.stack.push(local)
      return
    }

    // format_exc_check_arg(PyExc_UnboundLocalError,
    //                      UNBOUNDLOCAL_ERROR_MSG,
    //                      PyTuple_GetItem(co->co_varnames, oparg));
    fatalError()
  }

  internal func storeFast(nameIndex: Int) throws {
    let name = self.code.names[nameIndex]
    let value = self.stack.pop()
    self.localSymbols[name] = value
  }

  internal func deleteFast(nameIndex: Int) throws {
    let name = self.code.names[nameIndex]
    let value = self.localSymbols.removeValue(forKey: name)

    if value == nil {
      // format_exc_check_arg(PyExc_UnboundLocalError,
      //                      UNBOUNDLOCAL_ERROR_MSG,
      //                      PyTuple_GetItem(co->co_varnames, oparg));
      fatalError()
    }
  }

  // MARK: - Deref

  /// Loads the cell contained in slot i of the cell and free variable storage.
  /// Pushes a reference to the object the cell contains on the stack.
  internal func loadDeref(nameIndex: Int) throws {
    let name = self.code.names[nameIndex]
    if let value = self.freeVariables[name] {
      self.stack.push(value)
      return
    }

    // format_exc_unbound(co, oparg);
    fatalError()
  }

  /// Stores TOS into the cell contained in slot i of the cell
  /// and free variable storage.
  internal func storeDeref(nameIndex: Int) throws {
    let name = self.code.names[nameIndex]
    let value = self.stack.pop()
    self.freeVariables[name] = value
  }

  /// Empties the cell contained in slot i of the cell and free variable storage.
  /// Used by the del statement.
  internal func deleteDeref(nameIndex: Int) throws {
    let name = self.code.names[nameIndex]
    let value = self.freeVariables.removeValue(forKey: name)

    if value == nil {
      // format_exc_unbound(co, oparg);
      fatalError()
    }
  }

  /// Much like `LoadDeref` but first checks the locals dictionary before
  /// consulting the cell.
  /// This is used for loading free variables in class bodies.
  internal func loadClassDeref(nameIndex: Int) throws {
    self.unimplemented()
  }
}
