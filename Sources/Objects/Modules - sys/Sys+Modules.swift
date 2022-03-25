import VioletCore

// In CPython:
// Python -> sysmodule.c
// https://docs.python.org/3.7/library/sys.html

extension Sys {

  /// sys.builtin_module_names
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.builtin_module_names).
  ///
  /// A tuple of strings giving the names of all modules that are compiled
  /// into this Python interpreter.
  public func getBuiltinModuleNames() -> PyResultGen<PyTuple> {
    return self.getTuple(.builtin_module_names)
  }

  public func setBuiltinModuleNames(_ value: PyObject) -> PyBaseException? {
    return self.set(.builtin_module_names, value: value)
  }

  // MARK: - Modules

  internal static func modules(_ py: Py) -> PyResult {
    let result = py.sys.getModules()
    return PyResult(result)
  }

  /// sys.modules
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.modules).
  ///
  /// This is a dictionary that maps module names to modules
  /// which have already been loaded.
  public func getModules() -> PyResultGen<PyDict> {
    return self.getDict(.modules)
  }

  public func setModules(_ value: PyObject) -> PyBaseException? {
    return self.set(.modules, value: value)
  }

  public enum GetModuleResult {
    case module(PyModule)
    /// Value was found in `modules`, but it is not an `module` object.
    case notModule(PyObject)
    case notFound(PyBaseException)
    case error(PyBaseException)
  }

  public func getModule(name: PyString) -> GetModuleResult {
    return self.getModule(name: name.asObject)
  }

  public func getModule(name: PyObject) -> GetModuleResult {
    let modules: PyDict
    switch self.getModules() {
    case let .value(d): modules = d
    case let .error(e): return .error(e)
    }

    switch modules.get(self.py, key: name) {
    case .value(let o):
      if let m = self.py.cast.asModule(o) {
        return .module(m)
      }

      return .notModule(o)

    case .notFound:
      let error = self.py.newKeyError(key: name)
      return .notFound(error.asBaseException)
    case .error(let e):
      return .error(e)
    }
  }

  public func addModule(module: PyModule) -> PyBaseException? {
    let name: PyObject
    switch module.getName(self.py) {
    case let .value(n): name = n
    case let .error(e): return e
    }

    return self.addModule(name: name, module: module)
  }

  private func addModule(name: PyObject, module: PyModule) -> PyBaseException? {
    let modulesDict: PyDict
    switch self.getModules() {
    case let .value(d): modulesDict = d
    case let .error(e): return e
    }

    let moduleObject = module.asObject
    switch modulesDict.set(self.py, key: name, value: moduleObject) {
    case .ok: return nil
    case .error(let e): return e
    }
  }

  // MARK: - Builtin modules

  internal func setBuiltinModules(modules: [PyModule]) {
    assert(!self.hasAlreadyCalled_setBuiltinModules)

    var builtinModuleNames = [PyObject]()
    for module in modules {
      let name: PyObject
      switch module.getName(self.py) {
      case let .value(n): name = n
      case let .error(e):
        trap("Error when inserting '\(module)' to 'sys.builtin_module_names': " +
              "unable to extract module name: \(e).")
      }

      builtinModuleNames.append(name)

      // sys.modules
      if let e = self.addModule(name: name, module: module) {
        trap("Error when inserting '\(name)' module to 'sys.modules': \(e)")
      }
    }

    let tuple = self.py.newTuple(elements: builtinModuleNames)
    if let e = self.setBuiltinModuleNames(tuple.asObject) {
      trap("Error when setting 'sys.builtin_module_names': \(e)")
    }
  }

  private var hasAlreadyCalled_setBuiltinModules: Bool {
    switch self.getBuiltinModuleNames() {
    case let .value(tuple):
      // If we have any elements -> we called it before.
      return tuple.elements.any
    case let .error(e):
      trap("Error when checking if 'builtin_module_names' was already filled: \(e)")
    }
  }

  // MARK: - Builtin module names

  internal static func builtin_module_names(_ py: Py) -> PyResult {
    let result = py.sys.getBuiltinModuleNames()
    return PyResult(result)
  }
}
