import VioletCore
import VioletBytecode
import VioletObjects

// Docs:
// https://tech.blog.aknin.name/2010/06/05/pythons-innards-naming/

// swiftlint:disable file_length

extension Eval {

  // MARK: - Constant

  /// Pushes constant pointed by `index` onto the stack.
  internal func loadConst(index: Int) -> InstructionResult {
    let constant = self.getConstant(index: index)
    let object = constant.asObject
    self.stack.push(object)
    return .ok
  }

  // MARK: - Name

  /// Implements `name = TOS`.
  internal func storeName(nameIndex: Int) -> InstructionResult {
    let name = self.getName(index: nameIndex)
    let value = self.stack.pop()
    return self.store(name: name, value: value, dict: self.localSymbols)
  }

  /// Pushes the value associated with `name` onto the stack.
  internal func loadName(nameIndex: Int) -> InstructionResult {
    let name = self.getName(index: nameIndex)
    let dicts = [self.localSymbols, self.globalSymbols, self.builtinSymbols]
    return self.load(dicts: dicts, name: name)
  }

  /// Implements `del name`.
  internal func deleteName(nameIndex: Int) -> InstructionResult {
    let name = self.getName(index: nameIndex)
    return self.del(name: name, from: self.localSymbols)
  }

  // MARK: - Attribute

  /// Implements `TOS.name = TOS1`.
  internal func storeAttribute(nameIndex: Int) -> InstructionResult {
    let name = self.getName(index: nameIndex)
    let object = self.stack.pop()
    let value = self.stack.pop()

    switch Py.setattr(object: object, name: name, value: value) {
    case .value:
      return .ok
    case .error(let e):
      return .exception(e)
    }
  }

  /// Replaces TOS with `getAttr(TOS, name)`.
  internal func loadAttribute(nameIndex: Int) -> InstructionResult {
    let name = self.getName(index: nameIndex)
    let object = self.stack.top

    switch Py.getattr(object: object, name: name) {
    case let .value(r):
      self.stack.top = r
      return .ok
    case let .error(e):
      return .exception(e)
    }
  }

  /// Implements `del TOS.name`.
  internal func deleteAttribute(nameIndex: Int) -> InstructionResult {
    let name = self.getName(index: nameIndex)
    let object = self.stack.pop()

    switch Py.delattr(object: object, name: name) {
    case .value:
      return .ok
    case .error(let e):
      return .exception(e)
    }
  }

  // MARK: - Subscript

  /// Implements `TOS = TOS1[TOS]`.
  internal func binarySubscript() -> InstructionResult {
    let index = self.stack.pop()
    let object = self.stack.top

    switch Py.getItem(object: object, index: index) {
    case let .value(r):
      self.stack.top = r
      return .ok
    case let .error(e):
      return .exception(e)
    }
  }

  /// Implements `TOS1[TOS] = TOS2`.
  internal func storeSubscript() -> InstructionResult {
    let index = self.stack.pop()
    let object = self.stack.pop()
    let value = self.stack.pop()

    switch Py.setItem(object: object, index: index, value: value) {
    case .value:
      return .ok
    case .error(let e):
      return .exception(e)
    }
  }

  /// Implements `del TOS1[TOS]`.
  internal func deleteSubscript() -> InstructionResult {
    let index = self.stack.pop()
    let object = self.stack.pop()

    switch Py.deleteItem(object: object, index: index) {
    case .value:
      return .ok
    case .error(let e):
      return .exception(e)
    }
  }

  // MARK: - Global

  /// Works as StoreName, but stores the name as a global.
  internal func storeGlobal(nameIndex: Int) -> InstructionResult {
    let name = self.getName(index: nameIndex)
    let value = self.stack.pop()
    return self.store(name: name, value: value, dict: self.globalSymbols)
  }

  /// Loads the global named `name` onto the stack.
  internal func loadGlobal(nameIndex: Int) -> InstructionResult {
    let name = self.getName(index: nameIndex)
    let dicts = [self.globalSymbols, self.builtinSymbols]
    return self.load(dicts: dicts, name: name)
  }

  /// Works as DeleteName, but deletes a global name.
  internal func deleteGlobal(nameIndex: Int) -> InstructionResult {
    let name = self.getName(index: nameIndex)
    return self.del(name: name, from: self.globalSymbols)
  }

  // MARK: - Fast

  internal func loadFast(index: Int) -> InstructionResult {
    assert(0 <= index && index < self.fastLocals.count)

    if let object = self.fastLocals[index] {
      self.stack.push(object)
      return .ok
    }

    return self.unboundFastError(index: index)
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

    return self.unboundFastError(index: index)
  }

  private func unboundFastError(index: Int) -> InstructionResult {
    assert(0 <= index && index < self.code.variableCount)

    let mangled = self.code.variableNames[index]
    let e = Py.newUnboundLocalError(variableName: mangled.value)
    return .exception(e)
  }

  // MARK: - Deref

  /// Loads the cell contained in slot i of the cell and free variable storage.
  /// Pushes a reference to the object the cell contains on the stack.
  internal func loadDeref(cellOrFreeIndex index: Int) -> InstructionResult {
    let cell = self.getCellOrFree(at: index)

    if let content = cell.content {
      self.stack.push(content)
      return .ok
    }

    return self.unboundDerefError(index: index)
  }

  /// Stores TOS into the cell contained in slot i of the cell
  /// and free variable storage.
  internal func storeDeref(cellOrFreeIndex index: Int) -> InstructionResult {
    let cell = self.getCellOrFree(at: index)

    let value = self.stack.pop()
    cell.content = value
    return .ok
  }

  /// Empties the cell contained in slot i of the cell and free variable storage.
  /// Used by the del statement.
  internal func deleteDeref(cellOrFreeIndex index: Int) -> InstructionResult {
    let cell = self.getCellOrFree(at: index)

    let isEmpty = cell.content == nil
    if isEmpty {
      return self.unboundDerefError(index: index)
    }

    cell.content = nil
    return .ok
  }

  /// Much like `LoadDeref` but first checks the locals dictionary before
  /// consulting the cell.
  /// This is used for loading free variables in class bodies.
  internal func loadClassDeref(cellOrFreeIndex: Int) -> InstructionResult {
    assert(cellOrFreeIndex >= self.code.cellVariableCount)

    let freeIndex = cellOrFreeIndex - self.code.cellVariableCount
    assert(0 <= freeIndex && freeIndex < self.code.freeVariableCount)

    let mangled = self.code.freeVariableNames[freeIndex]
    let name = Py.intern(mangled.value)

    let value: PyObject
    switch self.localSymbols.get(key: name) {
    case .value(let o):
      value = o
    case .notFound:
      let cell = self.cellsAndFreeVariables[cellOrFreeIndex]
      switch cell.content {
      case .some(let o): value = o
      case .none: return self.unboundDerefError(index: cellOrFreeIndex)
      }
    case .error(let e):
      return .exception(e)
    }

    self.stack.push(value)
    return .ok
  }

  private func getCellOrFree(at index: Int) -> PyCell {
    assert(0 <= index && index < self.cellsAndFreeVariables.count)
    return self.cellsAndFreeVariables[index]
  }

  private func unboundDerefError(index: Int) -> InstructionResult {
    assert(0 <= index && index < self.code.cellVariableCount)

    let mangled = self.getDerefName(index: index)
    let msg = "cell/free variable '\(mangled)' referenced before assignment " +
              "in enclosing scope"

    let e = Py.newNameError(msg: msg)
    return .exception(e)
  }

  private func getDerefName(index: Int) -> MangledName {
    let cellCount = self.code.cellVariableCount
    return index < cellCount ?
      self.code.cellVariableNames[index] :
      self.code.freeVariableNames[index - cellCount]
  }

  // MARK: - Load closure

  /// Pushes a reference to the cell contained in slot 'i'
  /// of the 'cell' or 'free' variable storage.
  /// If 'i' < cellVars.count: name of the variable is cellVars[i].
  /// otherwise:               name is freeVars[i - cellVars.count].
  internal func loadClosure(cellOrFreeIndex: Int) -> InstructionResult {
    let cell = self.cellsAndFreeVariables[cellOrFreeIndex]
    self.stack.push(cell)
    return .ok
  }

  // MARK: - Helpers

  private func store(name: PyString,
                     value: PyObject,
                     dict: PyDict) -> InstructionResult {
    switch dict.set(key: name, to: value) {
    case .ok:
      return .ok
    case .error(let e):
      return .exception(e)
    }
  }

  private func load(dicts: [PyDict], name: PyString) -> InstructionResult {
    for dict in dicts {
      switch dict.get(key: name) {
      case .value(let o):
        self.stack.push(o)
        return .ok
      case .notFound:
        break // try in the next 'dict'
      case .error(let e):
        return .exception(e)
      }
    }

    return self.nameError(name)
  }

  private func del(name: PyString, from dict: PyDict) -> InstructionResult {
    switch dict.del(key: name) {
    case .value:
      return .ok
    case .notFound:
      return self.nameError(name)
    case .error(let e):
      return .exception(e)
    }
  }

  private func nameError(_ name: PyString) -> InstructionResult {
    let repr = Py.reprOrGeneric(object: name)
    let e = Py.newNameError(msg: "name '\(repr)' is not defined")
    return .exception(e)
  }
}
