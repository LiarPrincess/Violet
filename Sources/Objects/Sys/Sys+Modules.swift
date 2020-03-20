import Core

// In CPython:
// Python -> sysmodule.c
// https://docs.python.org/3.7/library/sys.html

// MARK: - Builtin

extension Sys {

  // sourcery: pyproperty = builtin_module_names
  /// sys.builtin_module_names
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.builtin_module_names).
  ///
  /// A tuple of strings giving the names of all modules that are compiled
  /// into this Python interpreter.
  internal var builtinModuleNamesObject: PyObject {
    return self.get(key: .builtin_module_names) ?? Py.newTuple()
  }

  internal func setBuiltinModules(to value: PyObject) -> PyResult<()> {
    self.set(key: .builtin_module_names, value: value)
    return .value()
  }

  internal func setBuiltinModules(modules: PyModule...) {
    assert(
      self.builtinModuleNames.isEmpty,
      "This function should be called in 'Py.initialize(config:delegate:)'."
    )

    var names = [PyString]()

    for module in modules {
      let name: String = {
        switch module.name {
        case .value(let s):
          return s
        case .error:
          trap("Error when inserting '\(module)' to 'sys.builtin_module_names': " +
            "unable to extract module name.")
        }
      }()

      let interned = Py.getInterned(name)
      names.append(interned)

      // sys.modules
      switch Py.add(dict: self.modules, key: interned, value: module) {
      case .value:
        break
      case .error(let e):
        trap("Error when inserting '\(name)' module to 'sys.modules': \(e)")
      }
    }

    // sys.builtin_module_names
    self.builtinModuleNames = names.map { $0.value }

    let tuple = Py.newTuple(names)
    switch self.setBuiltinModules(to: tuple) {
    case .value:
      break
    case .error(let e):
      trap("Error when setting 'sys.builtin_module_names': \(e)")
    }
  }
}

// MARK: - Modules

public enum GetModuleResult {
  case value(PyObject)
  case notFound(PyBaseException)
  case error(PyBaseException)
}

extension Sys {

  // sourcery: pyproperty = modules, setter = setModules
  /// sys.modules
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.modules).
  ///
  /// This is a dictionary that maps module names to modules
  /// which have already been loaded.
  public var modules: PyObject {
    return self.get(key: .modules) ?? PyDict()
  }

  internal func setModules(to value: PyObject) -> PyResult<()> {
    self.set(key: .modules, value: value)
    return .value()
  }

  public func getModule(name: PyObject) -> GetModuleResult {
    switch Py.getItem(self.modules, at: name) {
    case let .value(o):
      return .value(o)

    case let .error(e):
      if e.isKeyError {
        return .notFound(e)
      }

      return .error(e)
    }
  }

  /// PyObject *
  /// PyImport_AddModule(const char *name)
  public func addModule(name: String) -> PyResult<PyModule> {
    let nameObject = Py.getInterned(name)
    switch self.getModule(name: nameObject) {
    case .value(let o):
      if let m = o as? PyModule {
        return .value(m)
      }
      // else: override whatever we have there

    case .notFound:
      break // add new module

    case .error(let e):
      return .error(e)
    }

    let module = Py.newModule(name: nameObject)
    switch Py.add(dict: self.modules, key: nameObject, value: module) {
    case .value:
      return .value(module)
    case .error(let e):
      return .error(e)
    }
  }
}
