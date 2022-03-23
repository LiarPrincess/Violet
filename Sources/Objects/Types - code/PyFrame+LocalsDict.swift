import VioletCore
import VioletBytecode

// This functions are used in 'builtin.locals()' function.

extension PyFrame {

  // MARK: - Fast to locals

  /// Merge fast locals (arguments, local variables etc.) into 'self.locals'.
  ///
  /// We store function arguments and locals in `self.fastLocals`.
  /// In some cases (for example `__builtins__.locals()`) we need a proper
  /// `locals` dict.
  /// This method will copy values from `self.fastLocals` to `self.locals`.
  ///
  /// We will also do the same for `cells` and `frees`.
  ///
  /// CPython:
  /// int
  /// PyFrame_FastToLocalsWithError(PyFrameObject *f)
  public func copyFastToLocals(_ py: Py) -> PyBaseException? {
    let fastLocals = self.fastLocals
    assert(fastLocals.count == self.code.variableCount)

    for index in 0..<fastLocals.count {
      let name = self.code.variableNames[index]
      let value = fastLocals[index]

      if self.isCellOrFree(name: name) {
        continue
      }

      // TODO: 'PyFrame.updateLocals' for fast: 'allowDelete: false'
      if let e = self.updateLocals(py, name: name, value: value, allowDelete: false) {
        return e
      }
    }

    let cellVariables = self.cellVariables
    assert(cellVariables.count == self.code.cellVariableCount)

    for index in 0..<cellVariables.count {
      let name = self.code.cellVariableNames[index]
      let cell = cellVariables[index]

      if let e = self.updateLocals(py, name: name, value: cell.content, allowDelete: false) {
        return e
      }
    }

    let freeVariables = self.freeVariables
    assert(freeVariables.count == self.code.freeVariableCount)

    for index in 0..<freeVariables.count {
      let name = self.code.freeVariableNames[index]
      let cell = freeVariables[index]

      if let e = self.updateLocals(py, name: name, value: cell.content, allowDelete: false) {
        return e
      }
    }

    return nil
  }

  /// `O(n)`, but we do not expect a lot of 'cells' and 'frees'.
  private func isCellOrFree(name: MangledName) -> Bool {
    let cellNames = self.code.cellVariableNames
    let freeNames = self.code.freeVariableNames
    return cellNames.contains(name) || freeNames.contains(name)
  }

  private func updateLocals(_ py: Py,
                            name: MangledName,
                            value: PyObject?,
                            allowDelete: Bool) -> PyBaseException? {
    let locals = self.locals
    let key = self.createLocalsKey(py, name: name)

    // If we have value -> add it to locals
    if let value = value {
      switch locals.set(py, key: key, value: value) {
      case .ok:
        return nil
      case .error(let e):
        return e
      }
    }

    guard allowDelete else {
      return nil
    }

    // If we don't have value -> remove name from locals
    switch locals.del(py, key: key) {
    case .value,
         .notFound:
      return nil
    case .error(let e):
      return e
    }
  }

  private func createLocalsKey(_ py: Py, name: MangledName) -> PyString {
    return py.intern(string: name.value)
  }

  // MARK: - Locals to fast

  /// What should `PyFrame.copyLocalsToFast` do when the value is missing from
  /// `self.locals`?
  public enum LocalMissingStrategy {
    /// Leave the current value.
    case ignore
    /// Remove value (set to `nil`).
    case remove
  }

  /// Reversal of `self.copyFastToLocals` (<-- go there for documentation).
  public func copyLocalsToFast(_ py: Py,
                               onLocalMissing: LocalMissingStrategy) -> PyBaseException? {
    let variableNames = self.code.variableNames
    for (index, name) in variableNames.enumerated() {
      if self.isCellOrFree(name: name) {
        continue
      }

      if let e = self.updateFastFromLocal(py,
                                          index: index,
                                          name: name,
                                          onMissing: onLocalMissing) {
        return e
      }
    }

    let cellNames = self.code.cellVariableNames
    for (index, name) in cellNames.enumerated() {
      if let e = self.updateCellFromLocal(py,
                                          index: index,
                                          name: name,
                                          onMissing: onLocalMissing) {
        return e
      }
    }

    let freeNames = self.code.freeVariableNames
    for (index, name) in freeNames.enumerated() {
      if let e = self.updateFreeFromLocal(py,
                                          index: index,
                                          name: name,
                                          onMissing: onLocalMissing) {
        return e
      }
    }

    return nil
  }

  private func updateFastFromLocal(
    _ py: Py,
    index: Int,
    name: MangledName,
    onMissing: LocalMissingStrategy
  ) -> PyBaseException? {
    assert(0 <= index && index < self.fastLocals.count)

    switch self.getLocal(py, name: name, onMissing: onMissing) {
    case .value(let value):
      self.fastLocals[index] = value
    case .ignore:
      break
    case .removed:
      self.fastLocals[index] = nil
    case .error(let e):
      return e
    }

    return nil
  }

  private func updateCellFromLocal(
    _ py: Py,
    index: Int,
    name: MangledName,
    onMissing: LocalMissingStrategy
  ) -> PyBaseException? {
    assert(0 <= index && index < self.cellVariables.count)

    switch self.getLocal(py, name: name, onMissing: onMissing) {
    case .value(let value):
      let cell = self.cellVariables[index]
      cell.content = value
    case .ignore:
      break
    case .removed:
      let cell = self.cellVariables[index]
      cell.content = nil
    case .error(let e):
      return e
    }

    return nil
  }

  private func updateFreeFromLocal(
    _ py: Py,
    index: Int,
    name: MangledName,
    onMissing: LocalMissingStrategy
  ) -> PyBaseException? {
    assert(0 <= index && index < self.freeVariables.count)

    switch self.getLocal(py, name: name, onMissing: onMissing) {
    case .value(let value):
      let cell = self.freeVariables[index]
      cell.content = value
    case .ignore:
      break
    case .removed:
      let cell = self.freeVariables[index]
      cell.content = nil
    case .error(let e):
      return e
    }

    return nil
  }

  private enum GetLocalResult {
    case value(PyObject)
    case ignore
    case removed
    case error(PyBaseException)
  }

  private func getLocal(_ py: Py,
                        name: MangledName,
                        onMissing: LocalMissingStrategy) -> GetLocalResult {
    let key = self.createLocalsKey(py, name: name)
    switch self.locals.get(py, key: key) {
    case .value(let object):
      return .value(object)

    case .notFound:
      switch onMissing {
      case .ignore:
        return .ignore
      case .remove:
        return .removed
      }

    case .error(let e):
      return .error(e)
    }
  }
}
