import VioletObjects

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
    let name = self.code.names[nameIndex]
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
                          level: PyObject) -> PyResult {
    let globals = self.globals
    let locals = self.locals

    let __import__: PyObject
    switch self.py.get__import__() {
    case let .value(i): __import__ = i
    case let .error(e): return .error(e)
    }

    let args = [name.asObject, globals.asObject, locals.asObject, fromList, level]
    let callResult = self.py.call(callable: __import__, args: args, kwargs: nil)
    return callResult.asResult
  }

  // MARK: - Import star

  /// Loads all symbols not starting with '_' directly from the module TOS
  /// to the local namespace.
  ///
  /// The module is popped after loading all names.
  /// This opcode implements `from module import *`.
  internal func importStar() -> InstructionResult {
    let module = self.stack.pop()

    if let e = self.frame.copyFastToLocals(self.py) {
      return .exception(e)
    }

    if let e = self.importAllFrom(module: module) {
      // Ignore errors from 'copyLocalsToFast', import error is more important
      _ = self.frame.copyLocalsToFast(self.py, onLocalMissing: .ignore)
      return .exception(e)
    }

    if let e = self.frame.copyLocalsToFast(self.py, onLocalMissing: .ignore) {
      return .exception(e)
    }

    return .ok
  }

  private func importAllFrom(module: PyObject) -> PyBaseException? {
    // Names can come from:
    // - '__all__' - user decides which names are exported
    // - '__dict__' - ignore the ones that start with underscore

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
      return e
    }

    let e = self.py.forEach(iterable: namesObject) { name in
      if skipLeadingUnderscores && self.startsWithUnderscore(name: name) {
        return .goToNextElement
      }

      switch self.py.getAttribute(object: module, name: name) {
      case let .value(value):
        switch self.locals.set(self.py, key: name, value: value) {
        case .ok: return .goToNextElement
        case .error(let e): return .error(e)
        }
      case let .error(e):
        return .error(e)
      }
    }

    // We could 'return self.py.forEach' but this is better for debugging.
    return e
  }

  private func startsWithUnderscore(name: PyObject) -> Bool {
    guard let pyString = self.py.cast.asString(name) else {
      return false
    }

    let string = self.py.strString(pyString)
    return string.starts(with: "_")
  }

  private enum ExportedNames {
    case all(PyObject)
    case dict(PyObject)
    case error(PyBaseException)
  }

  private func getExportedNames(module: PyObject) -> ExportedNames {
    // Try '__all__'
    switch self.getAttribute(module: module, name: .__all__) {
    case .value(let o):
      return .all(o)
    case .notFound:
      break
    case .error(let e):
      return .error(e)
    }

    // Try '__dict__'
    switch self.getAttribute(module: module, name: .__dict__) {
    case .value(let o):
      switch self.py.getKeys(object: o) {
      case let .value(keys):
        return .dict(keys)
      case let .missingMethod(e),
           let .error(e):
        return .error(e)
      }

    case .notFound:
      let message = "from-import-* object has no __dict__ and no __all__"
      let moduleNameOrNil = self.getModuleName(module)
      let e = self.py.newImportError(message: message, moduleName: moduleNameOrNil)
      return .error(e.asBaseException)

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
    switch self.py.getAttribute(object: module, name: name) {
    case let .value(o):
      if self.py.cast.isNone(o) {
        return .notFound
      }
      return .value(o)

    case let .error(e):
      if self.py.cast.isAttributeError(e.asObject) {
        return .notFound
      }

      return .error(e)
    }
  }

  private func getModuleName(_ module: PyObject) -> String? {
    switch self.py.getName(module: module) {
    case let .string(s):
      return s
    case .notModule,
         .stringConversionFailed,
         .namelessModule:
      return nil
    }
  }

  // MARK: - Import from

  /// Loads the attribute `name` from the module found in TOS.
  ///
  /// The resulting object is pushed onto the stack,
  /// to be subsequently stored by a `StoreFast` instruction.
  internal func importFrom(nameIndex: Int) -> InstructionResult {
    let name = self.code.names[nameIndex]
    let module = self.stack.top // Leave it at top

    switch self.py.getAttribute(object: module, name: name) {
    case .value(let o):
      self.stack.push(o)
      return .ok

    case .error:
      // Try to fallback on reading the module directly from 'sys.modules'
      switch self.importFromSys(name: name, module: module) {
      case let .value(o):
        self.stack.push(o)
        return .ok
      case let .error(e):
        return .exception(e)
      }
    }
  }

  private func importFromSys(name: PyString, module: PyObject) -> PyResult {
    let package: PyString
    switch self.getString(module: module, name: .__name__) {
    case .value(let p):
      package = p
    case .notString,
         .error:
      return self.createImportFromError(name: name, module: module, package: nil)
    }

    let packageString = self.py.strString(package)
    let nameString = self.py.strString(name)
    let fullName = self.py.newString("\(packageString).\(nameString)")

    switch self.py.sys.getModule(name: fullName) {
    case .module(let module):
      return .value(module.asObject)
    case .notModule(let object):
      // This is an interesting case, but we will trust that import knows its stuff.
      return .value(object)
    case .notFound,
         .error:
      return self.createImportFromError(name: name, module: module, package: package)
    }
  }

  private func createImportFromError(name: PyString,
                                     module: PyObject,
                                     package: PyString?) -> PyResult {
    let name = self.py.strString(name)
    let package = package.map(self.py.strString(_:)) ?? "<unknown module name>"

    let path: String
    switch self.getString(module: module, name: .__file__) {
    case .value(let pyString):
      path = self.py.strString(pyString)
    case .notString,
        .error:
      path = "unknown location"
    }

    let message = "cannot import name \(name) from \(package) (\(path))"
    let error = self.py.newImportError(message: message, moduleName: name, modulePath: path)
    return .error(error.asBaseException)
  }

  private enum GetString {
    case value(PyString)
    case notString
    case error(PyBaseException)
  }

  private func getString(module: PyObject, name: IdString) -> GetString {
    let object: PyObject
    switch self.py.getAttribute(object: module, name: .__name__) {
    case let .value(o): object = o
    case let .error(e): return .error(e)
    }

    guard let str = self.py.cast.asString(object) else {
      return .notString
    }

    return .value(str)
  }
}
