import VioletCore
import VioletBytecode
import VioletObjects

// Docs:
// https://tech.blog.aknin.name/2010/06/05/pythons-innards-naming/

extension Eval {

  // MARK: - Constant

  /// Pushes constant pointed by `index` onto the stack.
  internal func loadConst(index: Int) -> InstructionResult {
    let constant = self.code.constants[index]
    self.stack.push(constant)
    return .ok
  }

  // MARK: - Name

  /// Implements `name = TOS`.
  internal func storeName(nameIndex: Int) -> InstructionResult {
    let name = self.code.names[nameIndex]
    let value = self.stack.pop()
    return self.store(self.locals, name: name, value: value)
  }

  /// Pushes the value associated with `name` onto the stack.
  internal func loadName(nameIndex: Int) -> InstructionResult {
    let name = self.code.names[nameIndex]

    switch self.load(self.locals, name: name) {
    case .value(let o):
      self.stack.push(o)
      return .ok
    case .notFound:
      break // try in the next 'dict'
    case .error(let e):
      return .exception(e)
    }

    switch self.load(self.globals, name: name) {
    case .value(let o):
      self.stack.push(o)
      return .ok
    case .notFound:
      break // try in the next 'dict'
    case .error(let e):
      return .exception(e)
    }

    switch self.load(self.builtins, name: name) {
    case .value(let o):
      self.stack.push(o)
      return .ok
    case .notFound:
      return self.nameError(name)
    case .error(let e):
      return .exception(e)
    }
  }

  /// Implements `del name`.
  internal func deleteName(nameIndex: Int) -> InstructionResult {
    let name = self.code.names[nameIndex]
    return self.del(self.locals, name: name)
  }

  // MARK: - Attribute

  /// Implements `TOS.name = TOS1`.
  internal func storeAttribute(nameIndex: Int) -> InstructionResult {
    let name = self.code.names[nameIndex]
    let object = self.stack.pop()
    let value = self.stack.pop()

    switch self.py.setAttribute(object: object, name: name, value: value) {
    case .value:
      return .ok
    case .error(let e):
      return .exception(e)
    }
  }

  /// Replaces TOS with `getAttr(TOS, name)`.
  internal func loadAttribute(nameIndex: Int) -> InstructionResult {
    let name = self.code.names[nameIndex]
    let object = self.stack.top

    switch self.py.getAttribute(object: object, name: name) {
    case let .value(r):
      self.stack.top = r
      return .ok
    case let .error(e):
      return .exception(e)
    }
  }

  /// Implements `del TOS.name`.
  internal func deleteAttribute(nameIndex: Int) -> InstructionResult {
    let name = self.code.names[nameIndex]
    let object = self.stack.pop()

    switch self.py.delAttribute(object: object, name: name) {
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

    switch self.py.getItem(object: object, index: index) {
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

    switch self.py.setItem(object: object, index: index, value: value) {
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

    switch self.py.deleteItem(object: object, index: index) {
    case .value:
      return .ok
    case .error(let e):
      return .exception(e)
    }
  }

  // MARK: - Global

  /// Works as StoreName, but stores the name as a global.
  internal func storeGlobal(nameIndex: Int) -> InstructionResult {
    let name = self.code.names[nameIndex]
    let value = self.stack.pop()
    return self.store(self.globals, name: name, value: value)
  }

  /// Loads the global named `name` onto the stack.
  internal func loadGlobal(nameIndex: Int) -> InstructionResult {
    let name = self.code.names[nameIndex]

    switch self.load(self.globals, name: name) {
    case .value(let o):
      self.stack.push(o)
      return .ok
    case .notFound:
      break // try in the next 'dict'
    case .error(let e):
      return .exception(e)
    }

    switch self.load(self.builtins, name: name) {
    case .value(let o):
      self.stack.push(o)
      return .ok
    case .notFound:
      return self.nameError(name)
    case .error(let e):
      return .exception(e)
    }
  }

  /// Works as DeleteName, but deletes a global name.
  internal func deleteGlobal(nameIndex: Int) -> InstructionResult {
    let name = self.code.names[nameIndex]
    return self.del(self.globals, name: name)
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
    let error = self.py.newUnboundLocalError(variableName: mangled.value)
    return .exception(error.asBaseException)
  }

  // MARK: - Cell

  /// Loads the cell contained in slot i of the cell storage.
  /// Pushes a reference to the object the cell contains on the stack.
  internal func loadCell(index: Int) -> InstructionResult {
    let cell = self.cellVariables[index]

    if let content = cell.content {
      self.stack.push(content)
      return .ok
    }

    return self.unboundCellError(index: index)
  }

  /// Stores TOS into the cell contained in slot i of the cell storage.
  internal func storeCell(index: Int) -> InstructionResult {
    let cell = self.cellVariables[index]
    let value = self.stack.pop()
    cell.content = value
    return .ok
  }

  /// Empties the cell contained in slot i of the cell storage.
  /// Used by the `del` statement.
  internal func deleteCell(index: Int) -> InstructionResult {
    let cell = self.cellVariables[index]

    let isEmpty = cell.content == nil
    if isEmpty {
      return self.unboundCellError(index: index)
    }

    cell.content = nil
    return .ok
  }

  private func unboundCellError(index: Int) -> InstructionResult {
    assert(0 <= index && index < self.code.cellVariableCount)
    let mangled = self.code.cellVariableNames[index]
    return self.unboundCellOrFreeError(name: mangled)
  }

  private func unboundCellOrFreeError(name: MangledName) -> InstructionResult {
    let message = "cell/free variable '\(name)' referenced before assignment " +
              "in enclosing scope"

    let error = self.py.newNameError(message: message)
    return .exception(error.asBaseException)
  }

  // MARK: - Free

  /// Loads the cell contained in slot i of the cell and free variable storage.
  /// Pushes a reference to the object the cell contains on the stack.
  internal func loadFree(index: Int) -> InstructionResult {
    let cell = self.freeVariables[index]

    if let content = cell.content {
      self.stack.push(content)
      return .ok
    }

    return self.unboundFreeError(index: index)
  }

  /// Stores TOS into the cell contained in slot i of the cell
  /// and free variable storage.
  internal func storeFree(index: Int) -> InstructionResult {
    let cell = self.freeVariables[index]

    let value = self.stack.pop()
    cell.content = value
    return .ok
  }

  /// Empties the cell contained in slot i of the cell and free variable storage.
  /// Used by the del statement.
  internal func deleteFree(index: Int) -> InstructionResult {
    let cell = self.freeVariables[index]

    let isEmpty = cell.content == nil
    if isEmpty {
      return self.unboundFreeError(index: index)
    }

    cell.content = nil
    return .ok
  }

  private func unboundFreeError(index: Int) -> InstructionResult {
    assert(0 <= index && index < self.code.freeVariableCount)
    let mangled = self.code.freeVariableNames[index]
    return self.unboundCellOrFreeError(name: mangled)
  }

  /// Much like `loadFree` but first checks the locals dictionary before
  /// consulting the cell.
  /// This is used for loading free variables in class bodies.
  internal func loadClassFree(index: Int) -> InstructionResult {
    let mangled = self.code.freeVariableNames[index]
    let name = self.py.intern(string: mangled.value)

    let value: PyObject
    switch self.load(self.locals, name: name) {
    case .value(let o):
      value = o
    case .notFound:
      let cell = self.freeVariables[index]
      guard let content = cell.content else {
        return self.unboundFreeError(index: index)
      }

      value = content
    case .error(let e):
      return .exception(e)
    }

    self.stack.push(value)
    return .ok
  }

  // MARK: - Load closure

  /// Pushes a reference to the cell contained in slot 'i'
  /// of the 'cell' or 'free' variable storage.
  /// If 'i' < cellVars.count: name of the variable is cellVars[i].
  /// otherwise:               name is freeVars[i - cellVars.count].
  internal func loadClosure(cellOrFreeIndex: Int) -> InstructionResult {
    let cellCount = self.cellVariables.count

    let cell: PyCell
    if cellOrFreeIndex < cellCount {
      cell = self.cellVariables[cellOrFreeIndex]
    } else {
      let freeIndex = cellOrFreeIndex - cellCount
      cell = self.freeVariables[freeIndex]
    }

    self.stack.push(cell.asObject)
    return .ok
  }

  // MARK: - Helpers

  private func load(_ dict: PyDict, name: PyString) -> PyDict.GetResult {
    if self.isExactlyDictNotSubclass(dict) {
      return dict.get(self.py, key: name)
    }

    let dictObject = dict.asObject
    let nameObject = name.asObject
    switch self.py.callMethod(object: dictObject, selector: .__getitem__, arg: nameObject) {
    case let .value(o):
      return .value(o)
    case let .missingMethod(e),
         let .notCallable(e):
      return .error(e)
    case let .error(e):
      if self.py.cast.isKeyError(e.asObject) {
        return .notFound
      }

      return .error(e)
    }
  }

  private func store(_ dict: PyDict,
                     name: PyString,
                     value: PyObject) -> InstructionResult {
    if self.isExactlyDictNotSubclass(dict) {
      switch dict.set(self.py, key: name, value: value) {
      case .ok:
        return .ok
      case .error(let e):
        return .exception(e)
      }
    }

    let dictObject = dict.asObject
    let nameObject = name.asObject
    switch self.py.setItem(object: dictObject, index: nameObject, value: value) {
    case .value:
      return .ok
    case .error(let e):
      return .exception(e)
    }
  }

  private func del(_ dict: PyDict, name: PyString) -> InstructionResult {
    if self.isExactlyDictNotSubclass(dict) {
      switch dict.del(self.py, key: name) {
      case .value:
        return .ok
      case .notFound:
        return self.nameError(name)
      case .error(let e):
        return .exception(e)
      }
    }

    let dictObject = dict.asObject
    let nameObject = name.asObject
    switch self.py.deleteItem(object: dictObject, index: nameObject) {
    case .value:
      return .ok
    case .error(let e):
      return .exception(e)
    }
  }

  private func isExactlyDictNotSubclass(_ dict: PyDict) -> Bool {
    return self.py.cast.isExactlyDict(dict.asObject)
  }

  private func nameError(_ name: PyString) -> InstructionResult {
    let repr = self.py.reprOrGenericString(name.asObject)
    let error = self.py.newNameError(message: "name \(repr) is not defined")
    return .exception(error.asBaseException)
  }
}
