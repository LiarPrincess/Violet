import Objects

extension Eval {

  // MARK: - Import

  /// Imports the module `name`.
  ///
  /// TOS and TOS1 are popped and provide the `fromlist` and `level`
  /// arguments of `Import()`.
  /// The module object is pushed onto the stack.
  /// The current namespace is not affected: for a proper import statement,
  /// a subsequent StoreFast instruction modifies the namespace.
  internal func importName(nameIndex: Int) -> InstructionResult {
    let name = self.getName(index: nameIndex)
    let fromList = self.stack.pop()
    let level = self.stack.top

    switch self.importName(name: name, fromList: fromList, level: level) {
    case let .value(module):
      self.stack.top = module
      return .ok
    case let .error(e):
      return .exception(e)
    }
  }

  /// static PyObject *
  /// import_name(PyFrameObject *f, PyObject *name, PyObject *fromlist, PyObject *level)
  private func importName(name: PyString,
                          fromList: PyObject,
                          level: PyObject) -> PyResult<PyObject> {
    let globals = self.globalSymbols
    let locals = self.localSymbols

    let result = Py.__import__(
      name: name,
      globals: globals,
      locals: locals,
      fromList: fromList,
      level: level
    )

    return result
  }

  // MARK: - Import star

  /// Loads all symbols not starting with '_' directly from the module TOS
  /// to the local namespace.
  ///
  /// The module is popped after loading all names.
  /// This opcode implements `from module import *`.
  internal func importStar() -> InstructionResult {
    let module = self.stack.pop()
    // TODO: PyFrame_FastToLocalsWithError(f)

    switch self.importAllFrom(module: module, locals: self.localSymbols) {
    case .value:
      // TODO: PyFrame_LocalsToFast(f, 0);
      return .ok
    case .error(let e):
      return .exception(e)
    }
  }

  private func importAllFrom(module: PyObject,
                             locals: PyDict) -> PyResult<()> {
    // Names can come from:
    // - '__all__' - user decides which names are exported
    // - '__dict__' - ignore the ones that start with undercore

    let namesObject: PyObject
    let skipLeadingUnderscores: Bool

    switch self.getExportedNames(module: module) {
    case let .all(o):
      namesObject = o
      skipLeadingUnderscores = false
    case let .dict(o):
      namesObject = o
      skipLeadingUnderscores = true
    case let .error(e):
      return .error(e)
    }

    let names: [PyObject]
    switch Py.toArray(iterable: namesObject) {
    case let .value(n): names = n
    case let .error(e): return .error(e)
    }

    for name in names {
      if skipLeadingUnderscores && self.startsWithUnderscore(name: name) {
        continue
      }

      switch Py.getattr(object: module, name: name) {
      case let .value(value):
        switch locals.setItem(at: name, to: value) {
        case .value: break
        case .error(let e):return .error(e)
        }
      case let .error(e):
        return .error(e)
      }
    }

    return .value()
  }

  private func startsWithUnderscore(name: PyObject) -> Bool {
    guard let str = name as? PyString else {
      return false
    }

    return str.value.starts(with: "_")
  }

  private enum ExportedNames {
    case all(PyObject)
    case dict(PyObject)
    case error(PyBaseException)
  }

  private func getExportedNames(module: PyObject) -> ExportedNames {
    switch self.getAttribute(module: module, name: .__all__) {
    case .value(let o):
      return .all(o)

    case .notFound:
      switch self.getAttribute(module: module, name: .__dict__) {
      case .value(let o):
        switch Py.getKeys(dict: o) {
        case let .value(keys): return .dict(keys)
        case let .error(e): return .error(e)
        }
      case .notFound:
        let msg = "from-import-* object has no __dict__ and no __all__"
        return .error(Py.newPyImportError(msg: msg))
      case .error(let e):
         return .error(e)
      }

    case .error(let e):
      return .error(e)
    }
  }

  private enum GetAttribute {
    case value(PyObject)
    case notFound
    case error(PyBaseException)
  }

  private func getAttribute(module: PyObject, name: IdString) -> GetAttribute {
    switch Py.getattr(object: module, name: name) {
    case let .value(o):
      if o.isNone {
        return .notFound
      }
      return .value(o)

    case let .error(e):
      if e.isAttributeError {
        return .notFound
      }

      return .error(e)
    }
  }

  // MARK: - Import from

  /// Loads the attribute `name` from the module found in TOS.
  ///
  /// The resulting object is pushed onto the stack,
  /// to be subsequently stored by a `StoreFast` instruction.
  internal func importFrom(nameIndex: Int) -> InstructionResult {
    let name = self.getName(index: nameIndex)
    let module = self.stack.top // Leave it at top

    // CPython does this differently, but we are going for 'close enough'.
    switch Py.getattr(object: module, name: name) {
    case let .value(o):
      self.stack.push(o)
      return .ok
    case let .error(e):
      return .exception(e)
    }
  }
}
