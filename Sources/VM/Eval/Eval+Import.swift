import Objects

extension Eval {

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

  private func import_name(name: PyString,
                           fromList: PyObject,
                           level: PyObject) -> PyResult<PyObject> {
    guard let importFn = self.builtinSymbols.get(id: .__import__) else {
      return .error(Py.newPyImportError(msg: "__import__ not found"))
    }

    let globals = self.globalSymbols
    let locals = self.localSymbols

    let args = [name, globals, locals, fromList, level]
    let result = Py.call(callable: importFn, args: args, kwargs: nil)
    return result.asResult
  }
}
