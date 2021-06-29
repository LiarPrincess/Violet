import VioletCore

// In CPython:
// Python -> sysmodule.c
// https://docs.python.org/3.7/library/sys.html

// MARK: - Builtin module names

extension Sys {

  /// sys.builtin_module_names
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.builtin_module_names).
  ///
  /// A tuple of strings giving the names of all modules that are compiled
  /// into this Python interpreter.
  public func getBuiltinModuleNames() -> PyResult<PyTuple> {
    return self.getTuple(.builtin_module_names)
  }

  public func setBuiltinModuleNames(to value: PyObject) -> PyBaseException? {
    return self.set(.builtin_module_names, to: value)
  }
}

// MARK: - Modules

extension Sys {

  /// sys.modules
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.modules).
  ///
  /// This is a dictionary that maps module names to modules
  /// which have already been loaded.
  public func getModules() -> PyResult<PyDict> {
    return self.getDict(.modules)
  }

  public func setModules(to value: PyObject) -> PyBaseException? {
    return self.set(.modules, to: value)
  }

  public enum GetModuleResult {
    case module(PyModule)
    /// Value was found in `modules`, but it is not an `module` object.
    case notModule(PyObject)
    case notFound(PyBaseException)
    case error(PyBaseException)
  }

  public func getModule(name: PyObject) -> GetModuleResult {
    let modules: PyDict
    switch self.getModules() {
    case let .value(d): modules = d
    case let .error(e): return .error(e)
    }

    switch modules.get(key: name) {
    case .value(let o):
      if let m = PyCast.asModule(o) {
        return .module(m)
      }

      return .notModule(o)

    case .notFound:
      let e = Py.newKeyError(key: name)
      return .notFound(e)

    case .error(let e):
      return .error(e)
    }
  }

  public func addModule(module: PyModule) -> PyBaseException? {
    let name: String
    switch module.getName() {
    case let .value(n): name = n
    case let .error(e): return e
    }

    let interned = Py.intern(string: name)

    let modulesDict: PyDict
    switch self.getModules() {
    case let .value(d): modulesDict = d
    case let .error(e): return e
    }

    switch modulesDict.set(key: interned, to: module) {
    case .ok: return nil
    case .error(let e): return e
    }
  }

  // MARK: - Builtin modules

  internal func setBuiltinModules(modules: [PyModule]) {
    assert(!self.hasAlreadyCalled_setBuiltinModules)

    for module in modules {
      let name: String = {
        switch module.getName() {
        case .value(let s):
          return s
        case .error(let e):
          trap("Error when inserting '\(module)' to 'sys.builtin_module_names': " +
            "unable to extract module name: \(e).")
        }
      }()

      let interned = Py.intern(string: name)
      self.builtinModuleNames.append(interned)

      // sys.modules
      if let e = self.addModule(module: module) {
        trap("Error when inserting '\(name)' module to 'sys.modules': \(e)")
      }
    }

    let tuple = Py.newTuple(elements: self.builtinModuleNames)
    if let e = self.setBuiltinModuleNames(to: tuple) {
      trap("Error when setting 'sys.builtin_module_names': \(e)")
    }
  }

  private var hasAlreadyCalled_setBuiltinModules: Bool {
    switch self.getBuiltinModuleNames() {
    case let .value(t):
      // If we have any elements -> we called it before.
      return t.elements.any
    case let .error(e):
      trap("Error when checking if 'builtin_module_names' was already filled: \(e)")
    }
  }
}
