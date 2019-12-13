import Bytecode
import Objects

extension Frame {

  // MARK: - Constant

  /// Pushes constant pointed by `index` onto the stack.
  internal func loadConst(index: Int) -> InstructionResult {
    let value = self.code.constants[index]
    let object = self.toObject(value)
    self.stack.push(object)
    return .ok
  }

  private func toObject(_ value: Constant) -> PyObject {
    switch value {
    case .true: return self.builtins.true
    case .false: return self.builtins.false
    case .none: return self.builtins.none
    case .ellipsis: return self.builtins.ellipsis
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
  internal func storeName(nameIndex: Int) -> InstructionResult {
    let name = self.code.names[nameIndex]
    let value = self.stack.pop()
    self.localSymbols[name] = value
    return .ok
  }

  /// Pushes the value associated with `name` onto the stack.
  internal func loadName(nameIndex: Int) -> InstructionResult {
    let name = self.code.names[nameIndex]

    if let local = self.localSymbols[name] {
      self.stack.push(local)
      return .ok
    }

    if let global = self.globalSymbols[name] {
      self.stack.push(global)
      return .ok
    }

    if let builtin = self.builtinSymbols[name] {
      self.stack.push(builtin)
      return .ok
    }

    return self.nameError(name)
  }

  /// Implements `del name`.
  internal func deleteName(nameIndex: Int) -> InstructionResult {
    let name = self.code.names[nameIndex]
    let value = self.localSymbols.removeValue(forKey: name)

    if value == nil {
      return self.nameError(name)
    }

    return.unimplemented
  }

  // MARK: - Attribute

  /// Implements `TOS.name = TOS1`.
  internal func storeAttribute(nameIndex: Int) -> InstructionResult {
    let name = self.code.names[nameIndex]
    let object = self.stack.pop()
    let value = self.stack.pop()

    switch self.builtins.setAttribute(object, name: name, value: value) {
    case .value:
      return .ok
    case .error(let e):
      return .builtinError(e)
    }
  }

  /// Replaces TOS with `getAttr(TOS, name)`.
  internal func loadAttribute(nameIndex: Int) -> InstructionResult {
    let name = self.code.names[nameIndex]
    let object = self.stack.top

    switch self.builtins.getAttribute(object, name: name) {
    case let .value(r):
      self.stack.top = r
      return .ok
    case let .error(e):
      return .builtinError(e)
    }
  }

  /// Implements `del TOS.name`.
  internal func deleteAttribute(nameIndex: Int) -> InstructionResult {
    let name = self.code.names[nameIndex]
    let object = self.stack.pop()

    switch self.builtins.deleteAttribute(object, name: name) {
    case .value:
      return .ok
    case .error(let e):
      return .builtinError(e)
    }
  }

  // MARK: - Subscript

  /// Implements `TOS = TOS1[TOS]`.
  internal func binarySubscript() -> InstructionResult {
    let index = self.stack.pop()
    let object = self.stack.top

    switch self.builtins.getItem(object, at: index) {
    case let .value(r):
      self.stack.top = r
      return .ok
    case let .error(e):
      return .builtinError(e)
    }
  }

  /// Implements `TOS1[TOS] = TOS2`.
  internal func storeSubscript() -> InstructionResult {
    let index = self.stack.pop()
    let object = self.stack.pop()
    let value = self.stack.pop()

    switch self.builtins.setItem(object, at: index, value: value) {
    case .value:
      return .ok
    case .error(let e):
      return .builtinError(e)
    }
  }

  /// Implements `del TOS1[TOS]`.
  internal func deleteSubscript() -> InstructionResult {
    let index = self.stack.pop()
    let object = self.stack.pop()

    switch self.builtins.deleteItem(object, at: index) {
    case .value:
      return .ok
    case .error(let e):
      return .builtinError(e)
    }
  }

  // MARK: - Global

  /// Works as StoreName, but stores the name as a global.
  internal func storeGlobal(nameIndex: Int) -> InstructionResult {
    let name = self.code.names[nameIndex]
    let value = self.stack.pop()
    self.globalSymbols[name] = value
    return .ok
  }

  /// Loads the global named `name` onto the stack.
  internal func loadGlobal(nameIndex: Int) -> InstructionResult {
    let name = self.code.names[nameIndex]

    if let global = self.globalSymbols[name] {
      self.stack.push(global)
      return .ok
    }

    if let builtin = self.builtinSymbols[name] {
      self.stack.push(builtin)
      return .ok
    }

    return self.nameError(name)
  }

  /// Works as DeleteName, but deletes a global name.
  internal func deleteGlobal(nameIndex: Int) -> InstructionResult {
    let name = self.code.names[nameIndex]
    let value = self.globalSymbols.removeValue(forKey: name)

    if value == nil {
      return self.nameError(name)
    }

    return.unimplemented
  }

  // MARK: - Fast

  internal func loadFast(nameIndex: Int) -> InstructionResult {
    let name = self.code.names[nameIndex]

    if let local = self.localSymbols[name] {
      self.stack.push(local)
      return .ok
    }

    // format_exc_check_arg(PyExc_UnboundLocalError,
    //                      UNBOUNDLOCAL_ERROR_MSG,
    //                      PyTuple_GetItem(co->co_varnames, oparg));
    fatalError()
  }

  internal func storeFast(nameIndex: Int) -> InstructionResult {
    let name = self.code.names[nameIndex]
    let value = self.stack.pop()
    self.localSymbols[name] = value
    return .unimplemented
  }

  internal func deleteFast(nameIndex: Int) -> InstructionResult {
    let name = self.code.names[nameIndex]
    let value = self.localSymbols.removeValue(forKey: name)

    if value == nil {
      // format_exc_check_arg(PyExc_UnboundLocalError,
      //                      UNBOUNDLOCAL_ERROR_MSG,
      //                      PyTuple_GetItem(co->co_varnames, oparg));
      fatalError()
    }

    return.unimplemented
  }

  // MARK: - Deref

  /// Loads the cell contained in slot i of the cell and free variable storage.
  /// Pushes a reference to the object the cell contains on the stack.
  internal func loadDeref(nameIndex: Int) -> InstructionResult {
    let name = self.code.names[nameIndex]
    if let value = self.freeVariables[name] {
      self.stack.push(value)
      return .ok
    }

    // format_exc_unbound(co, oparg);
    fatalError()
  }

  /// Stores TOS into the cell contained in slot i of the cell
  /// and free variable storage.
  internal func storeDeref(nameIndex: Int) -> InstructionResult {
    let name = self.code.names[nameIndex]
    let value = self.stack.pop()
    self.freeVariables[name] = value
    return.unimplemented
  }

  /// Empties the cell contained in slot i of the cell and free variable storage.
  /// Used by the del statement.
  internal func deleteDeref(nameIndex: Int) -> InstructionResult {
    let name = self.code.names[nameIndex]
    let value = self.freeVariables.removeValue(forKey: name)

    if value == nil {
      // format_exc_unbound(co, oparg);
      fatalError()
    }

    return .unimplemented
  }

  /// Much like `LoadDeref` but first checks the locals dictionary before
  /// consulting the cell.
  /// This is used for loading free variables in class bodies.
  internal func loadClassDeref(nameIndex: Int) -> InstructionResult {
    return .unimplemented
  }

  // MARK: - Helpers

  private func nameError(_ name: String) -> InstructionResult {
    return .builtinError(.nameError("name '\(name)' is not defined"))
  }
}
