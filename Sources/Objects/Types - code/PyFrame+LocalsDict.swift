/* MARKER
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
  public func copyFastToLocals() -> PyBaseException? {
    let variableNames = self.code.variableNames
    let fastLocals = self.fastLocals
    assert(variableNames.count == fastLocals.count)

    for (name, value) in zip(variableNames, fastLocals) {
      if self.isCellOrFree(name: name) {
        continue
      }

      // TODO: 'PyFrame.updateLocals' for fast: 'allowDelete: false'
      if let e = self.updateLocals(name: name, value: value, allowDelete: false) {
        return e
      }
    }

    let cellNames = self.code.cellVariableNames
    let cellVariables = self.cellVariables
    assert(cellNames.count == cellVariables.count)

    for (name, cell) in zip(cellNames, cellVariables) {
      if let e = self.updateLocals(name: name, value: cell.content) {
        return e
      }
    }

    let freeNames = self.code.freeVariableNames
    let freeVariables = self.freeVariables
    assert(freeNames.count == freeVariables.count)

    for (name, cell) in zip(freeNames, freeVariables) {
      if let e = self.updateLocals(name: name, value: cell.content) {
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

  private func updateLocals(name: MangledName,
                            value: PyObject?,
                            allowDelete: Bool = false) -> PyBaseException? {
    let locals = self.locals
    let key = self.createLocalsKey(name: name)

    // If we have value -> add it to locals
    if let value = value {
      switch locals.set(key: key, to: value) {
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
    switch locals.del(key: key) {
    case .value,
         .notFound:
      return nil
    case .error(let e):
      return e
    }
  }

  private func createLocalsKey(name: MangledName) -> PyString {
    return Py.intern(string: name.value)
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
  public func copyLocalsToFast(
    onLocalMissing: LocalMissingStrategy
  ) -> PyBaseException? {
    let variableNames = self.code.variableNames
    for (index, name) in variableNames.enumerated() {
      if self.isCellOrFree(name: name) {
        continue
      }

      if let e = self.updateFastFromLocal(index: index,
                                          name: name,
                                          onMissing: onLocalMissing) {
        return e
      }
    }

    let cellNames = self.code.cellVariableNames
    for (index, name) in cellNames.enumerated() {
      if let e = self.updateCellFromLocal(index: index,
                                          name: name,
                                          onMissing: onLocalMissing) {
        return e
      }
    }

    let freeNames = self.code.freeVariableNames
    for (index, name) in freeNames.enumerated() {
      if let e = self.updateFreeFromLocal(index: index,
                                          name: name,
                                          onMissing: onLocalMissing) {
        return e
      }
    }

    return nil
  }

  private func updateFastFromLocal(
    index: Int,
    name: MangledName,
    onMissing: LocalMissingStrategy
  ) -> PyBaseException? {
    assert(0 <= index && index < self.fastLocals.count)

    switch self.getLocal(name: name, onMissing: onMissing) {
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
    index: Int,
    name: MangledName,
    onMissing: LocalMissingStrategy
  ) -> PyBaseException? {
    assert(0 <= index && index < self.cellVariables.count)

    switch self.getLocal(name: name, onMissing: onMissing) {
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
    index: Int,
    name: MangledName,
    onMissing: LocalMissingStrategy
  ) -> PyBaseException? {
    assert(0 <= index && index < self.freeVariables.count)

    switch self.getLocal(name: name, onMissing: onMissing) {
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

  private func getLocal(name: MangledName,
                        onMissing: LocalMissingStrategy) -> GetLocalResult {
    let key = self.createLocalsKey(name: name)
    switch self.locals.get(key: key) {
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

*/