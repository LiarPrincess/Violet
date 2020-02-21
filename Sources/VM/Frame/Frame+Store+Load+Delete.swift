import Bytecode
import Objects

extension Frame {

  // MARK: - Constant

  /// Pushes constant pointed by `index` onto the stack.
  internal func loadConst(index: Int) -> InstructionResult {
    let value = self.getConstant(index: index)
    let object = self.toObject(value)
    self.stack.push(object)
    return .ok
  }

  private func toObject(_ value: Constant) -> PyObject {
    switch value {
    case .true: return Py.true
    case .false: return Py.false
    case .none: return Py.none
    case .ellipsis: return Py.ellipsis
    case let .integer(arg): return Py.newInt(arg)
    case let .float(arg): return Py.newFloat(arg)
    case let .complex(real, imag): return Py.newComplex(real: real, imag: imag)
    case let .string(arg): return Py.newString(arg)
    case let .bytes(arg): return Py.newBytes(arg)
    case let .code(arg): return Py.newCode(code: arg)
    case let .tuple(args):
      let elements = args.map(self.toObject)
      return Py.newTuple(elements)
    }
  }

  // MARK: - Name

  /// Implements `name = TOS`.
  internal func storeName(nameIndex: Int) -> InstructionResult {
    let name = self.getName(index: nameIndex)
    let value = self.stack.pop()
    self.localSymbols[name] = value
    return .ok
  }

  /// Pushes the value associated with `name` onto the stack.
  internal func loadName(nameIndex: Int) -> InstructionResult {
    let name = self.getName(index: nameIndex)

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
    let name = self.getName(index: nameIndex)
    let value = self.localSymbols.del(key: name)

    switch value {
    case .some:
      return .ok
    case .none:
      return self.nameError(name)
    }
  }

  // MARK: - Attribute

  /// Implements `TOS.name = TOS1`.
  internal func storeAttribute(nameIndex: Int) -> InstructionResult {
    let name = self.getName(index: nameIndex)
    let object = self.stack.pop()
    let value = self.stack.pop()

    switch Py.setAttribute(object, name: name, value: value) {
    case .value:
      return .ok
    case .error(let e):
      return .unwind(.exception(e))
    }
  }

  /// Replaces TOS with `getAttr(TOS, name)`.
  internal func loadAttribute(nameIndex: Int) -> InstructionResult {
    let name = self.getName(index: nameIndex)
    let object = self.stack.top

    switch Py.getAttribute(object, name: name) {
    case let .value(r):
      self.stack.top = r
      return .ok
    case let .error(e):
      return .unwind(.exception(e))
    }
  }

  /// Implements `del TOS.name`.
  internal func deleteAttribute(nameIndex: Int) -> InstructionResult {
    let name = self.getName(index: nameIndex)
    let object = self.stack.pop()

    switch Py.deleteAttribute(object, name: name) {
    case .value:
      return .ok
    case .error(let e):
      return .unwind(.exception(e))
    }
  }

  // MARK: - Subscript

  /// Implements `TOS = TOS1[TOS]`.
  internal func binarySubscript() -> InstructionResult {
    let index = self.stack.pop()
    let object = self.stack.top

    switch Py.getItem(object, at: index) {
    case let .value(r):
      self.stack.top = r
      return .ok
    case let .error(e):
      return .unwind(.exception(e))
    }
  }

  /// Implements `TOS1[TOS] = TOS2`.
  internal func storeSubscript() -> InstructionResult {
    let index = self.stack.pop()
    let object = self.stack.pop()
    let value = self.stack.pop()

    switch Py.setItem(object, at: index, value: value) {
    case .value:
      return .ok
    case .error(let e):
      return .unwind(.exception(e))
    }
  }

  /// Implements `del TOS1[TOS]`.
  internal func deleteSubscript() -> InstructionResult {
    let index = self.stack.pop()
    let object = self.stack.pop()

    switch Py.deleteItem(object, at: index) {
    case .value:
      return .ok
    case .error(let e):
      return .unwind(.exception(e))
    }
  }

  // MARK: - Global

  /// Works as StoreName, but stores the name as a global.
  internal func storeGlobal(nameIndex: Int) -> InstructionResult {
    let name = self.getName(index: nameIndex)
    let value = self.stack.pop()
    self.globalSymbols[name] = value
    return .ok
  }

  /// Loads the global named `name` onto the stack.
  internal func loadGlobal(nameIndex: Int) -> InstructionResult {
    let name = self.getName(index: nameIndex)

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
    let name = self.getName(index: nameIndex)
    let value = self.globalSymbols.del(key: name)

    switch value {
    case .some:
      return .ok
    case .none:
      return self.nameError(name)
    }
  }

  // MARK: - Fast

  internal func loadFast(index: Int) -> InstructionResult {
    assert(0 <= index && index < self.fastLocals.count)

    if let object = self.fastLocals[index] {
      self.stack.push(object)
      return .ok
    }

    return self.unboundFast(index: index)
  }

  internal func storeFast(index: Int) -> InstructionResult {
    assert(0 <= index && index < self.fastLocals.count)

    let value = self.stack.pop()
    self.fastLocals[index] = value
    return .ok
  }

  internal func deleteFast(index: Int) -> InstructionResult {
    assert(0 <= index && index < self.fastLocals.count)

    if self.fastLocals[index] != nil {
      self.fastLocals[index] = nil
      return .ok
    }

    return self.unboundFast(index: index)
  }

  private func unboundFast(index: Int) -> InstructionResult {
    assert(0 <= index && index < self.code.variableNames.count)

    let mangled = self.code.variableNames[index]
    let e = Py.newUnboundLocalError(variableName: mangled.value)
    return .unwind(.exception(e))
  }

  // MARK: - Helpers

  private func nameError(_ name: String) -> InstructionResult {
    let e = Py.newNameError(msg: "name '\(name)' is not defined")
    return .unwind(.exception(e))
  }
}
