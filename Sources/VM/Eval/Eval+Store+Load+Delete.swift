/* MARKER
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
    self.stack.push(constant)
    return .ok
  }

  // MARK: - Name

  /// Implements `name = TOS`.
  internal func storeName(nameIndex: Int) -> InstructionResult {
    let name = self.getName(index: nameIndex)
    let value = self.stack.pop()
    return self.store(dict: self.locals, name: name, value: value)
  }

  /// Pushes the value associated with `name` onto the stack.
  internal func loadName(nameIndex: Int) -> InstructionResult {
    let name = self.getName(index: nameIndex)
    let dicts = [self.locals, self.globals, self.builtins]
    return self.load(dicts: dicts, name: name)
  }

  /// Implements `del name`.
  internal func deleteName(nameIndex: Int) -> InstructionResult {
    let name = self.getName(index: nameIndex)
    return self.del(dict: self.locals, name: name)
  }

  // MARK: - Attribute

  /// Implements `TOS.name = TOS1`.
  internal func storeAttribute(nameIndex: Int) -> InstructionResult {
    let name = self.getName(index: nameIndex)
    let object = self.stack.pop()
    let value = self.stack.pop()

    switch Py.setAttribute(object: object, name: name, value: value) {
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

    switch Py.getAttribute(object: object, name: name) {
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

    switch Py.delAttribute(object: object, name: name) {
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
    return self.store(dict: self.globals, name: name, value: value)
  }

  /// Loads the global named `name` onto the stack.
  internal func loadGlobal(nameIndex: Int) -> InstructionResult {
    let name = self.getName(index: nameIndex)
    let dicts = [self.globals, self.builtins]
    return self.load(dicts: dicts, name: name)
  }

  /// Works as DeleteName, but deletes a global name.
  internal func deleteGlobal(nameIndex: Int) -> InstructionResult {
    let name = self.getName(index: nameIndex)
    return self.del(dict: self.globals, name: name)
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

  // MARK: - Cell

  /// Loads the cell contained in slot i of the cell storage.
  /// Pushes a reference to the object the cell contains on the stack.
  internal func loadCell(index: Int) -> InstructionResult {
    let cell = self.getCell(index: index)

    if let content = cell.content {
      self.stack.push(content)
      return .ok
    }

    return self.unboundCellError(index: index)
  }

  /// Stores TOS into the cell contained in slot i of the cell storage.
  internal func storeCell(index: Int) -> InstructionResult {
    let cell = self.getCell(index: index)
    let value = self.stack.pop()
    cell.content = value
    return .ok
  }

  /// Empties the cell contained in slot i of the cell storage.
  /// Used by the `del` statement.
  internal func deleteCell(index: Int) -> InstructionResult {
    let cell = self.getCell(index: index)

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
    let msg = "cell/free variable '\(name)' referenced before assignment " +
              "in enclosing scope"

    let e = Py.newNameError(msg: msg)
    return .exception(e)
  }

  // MARK: - Free

  /// Loads the cell contained in slot i of the cell and free variable storage.
  /// Pushes a reference to the object the cell contains on the stack.
  internal func loadFree(index: Int) -> InstructionResult {
    let cell = self.getFree(index: index)

    if let content = cell.content {
      self.stack.push(content)
      return .ok
    }

    return self.unboundFreeError(index: index)
  }

  /// Stores TOS into the cell contained in slot i of the cell
  /// and free variable storage.
  internal func storeFree(index: Int) -> InstructionResult {
    let cell = self.getFree(index: index)

    let value = self.stack.pop()
    cell.content = value
    return .ok
  }

  /// Empties the cell contained in slot i of the cell and free variable storage.
  /// Used by the del statement.
  internal func deleteFree(index: Int) -> InstructionResult {
    let cell = self.getFree(index: index)

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
    let name = Py.intern(string: mangled.value)

    let value: PyObject
    switch self.load(dict: self.locals, name: name) {
    case .value(let o):
      value = o
    case .notFound:
      let cell = self.self.freeVariables[index]
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
      cell = self.getCell(index: cellOrFreeIndex)
    } else {
      let freeIndex = cellOrFreeIndex - cellCount
      cell = self.getFree(index: freeIndex)
    }

    self.stack.push(cell)
    return .ok
  }

  // MARK: - Helpers

  private func store(dict: PyDict,
                     name: PyString,
                     value: PyObject) -> InstructionResult {
    let isExactlyDictNotSubclass = self.py.cast.isExactlyDict(dict)
    if isExactlyDictNotSubclass {
      switch dict.set(key: name, to: value) {
      case .ok:
        return .ok
      case .error(let e):
        return .exception(e)
      }
    }

    switch Py.setItem(object: dict, index: name, value: value) {
    case .value:
      return .ok
    case .error(let e):
      return .exception(e)
    }
  }

  private func load(dict: PyDict, name: PyString) -> PyDict.GetResult {
    let isExactlyDictNotSubclass = self.py.cast.isExactlyDict(dict)
    if isExactlyDictNotSubclass {
      return dict.get(key: name)
    }

    switch Py.callMethod(object: dict, selector: .__getitem__, arg: name) {
    case let .value(o):
      return .value(o)
    case let .missingMethod(e),
         let .notCallable(e):
      return .error(e)
    case let .error(e):
      if self.py.cast.isKeyError(e) {
        return .notFound
      }

      return .error(e)
    }
  }

  private func load(dicts: [PyDict], name: PyString) -> InstructionResult {
    for dict in dicts {
      switch self.load(dict: dict, name: name) {
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

  private func del(dict: PyDict, name: PyString) -> InstructionResult {
    let isExactlyDictNotSubclass = self.py.cast.isExactlyDict(dict)
    if isExactlyDictNotSubclass {
      switch dict.del(key: name) {
      case .value:
        return .ok
      case .notFound:
        return self.nameError(name)
      case .error(let e):
        return .exception(e)
      }
    }

    switch Py.deleteItem(object: dict, index: name) {
    case .value:
      return .ok
    case .error(let e):
      return .exception(e)
    }
  }

  private func nameError(_ name: PyString) -> InstructionResult {
    let repr = Py.reprOrGenericString(object: name)
    let e = Py.newNameError(msg: "name \(repr) is not defined")
    return .exception(e)
  }
}

*/
