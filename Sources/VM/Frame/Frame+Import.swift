import Objects

extension Frame {

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

    switch self.import_name(name: name, fromList: fromList, level: level) {
    case let .value(module):
      self.stack.top = module
      return .ok
    case let .error(e):
      return .unwind(.exception(e))
    }
  }

  private func import_name(name: String,
                           fromList: PyObject,
                           level: PyObject) -> PyResult<PyObject> {
    guard let importFn = self.builtinSymbols["__import__"] else {
      return .error(Py.newPyImportError(msg: "__import__ not found"))
    }

    let nameObject = Py.getInterned(name)

    let globals: PyDict
    switch self.toDict(attributes: self.globalSymbols) {
    case let .value(d): globals = d
    case let .error(e): return .error(e)
    }

    let locals: PyDict
    switch self.toDict(attributes: self.localSymbols) {
    case let .value(d): locals = d
    case let .error(e): return .error(e)
    }

    let args = [nameObject, globals, locals, fromList, level]
    let result = Py.call(callable: importFn, args: args, kwargs: nil)
    return result.asResult
  }

  private func toDict(attributes: Attributes) -> PyResult<PyDict> {
    let result = Py.newDict()

    for entry in attributes {
      let key = Py.getInterned(entry.key)
      switch result.setItem(at: key, to: entry.value) {
      case .value: break
      case .error(let e): return .error(e)
      }
    }

    return .value(result)
  }
}
