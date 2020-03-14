// In CPython:
// Python -> import.c

// Docs:
// https://docs.python.org/3.7/reference/import.html
// https://docs.python.org/3.7/library/importlib.html

extension UnderscoreImp {

  // MARK: - Is

  internal static var isBuiltinDoc: String {
    return """
    is_builtin($module, name, /)
    --

    Returns True if the module name corresponds to a built-in module.
    """
  }

  // sourcery: pymethod = is_builtin, doc = isBuiltinDoc
  /// static PyObject *
  /// _imp_is_builtin_impl(PyObject *module, PyObject *name)
  public func isBuiltin(name nameRaw: PyObject) -> PyResult<PyInt> {
    guard let name = nameRaw as? PyString else {
      let msg = "is_builtin() argument must be str, not \(nameRaw.typeName)"
      return .typeError(msg)
    }

    let modules = Py.sys.builtinModules
    let result = modules.names.contains(name.value)

    let int = Py.newInt(result ? 1 : 0)
    return .value(int)
  }

  // MARK: - Create

  internal static var createBuiltinDoc: String {
    return """
    create_builtin($module, spec, /)
    --

    Create an extension module.
    """
  }

  // sourcery: pymethod = create_builtin, doc = createBuiltinDoc
  /// static PyObject *
  /// _imp_create_builtin(PyObject *module, PyObject *spec)
  public func createBuiltin(spec: PyObject) -> PyResult<PyObject> {
    let name: PyString
    switch self.getName(spec: spec) {
    case let .value(n): name = n
    case let .error(e): return .error(e)
    }

    // Check if we already have this module.
    switch Py.sys.modules.get(name: name) {
    case .value(let m): return .value(m)
    case .notFound: break // Try other
    case .error(let e): return .error(e)
    }

    // Get builtin definition.
    // Note that we do not have to 'create' new module here,
    // because we initialized all of builtin modules (all 3 of them: builtins,
    // sys and _imp) in 'Py.initialize'.
    let builtinModules = Py.sys.builtinModules
    assert(builtinModules.names.count == builtinModules.modules.count)

    let moduleIndexOrNil = builtinModules.names.firstIndex { $0 == name.value }
    guard let moduleIndex = moduleIndexOrNil else {
      return .value(Py.none)
    }

    let module = builtinModules.modules[moduleIndex]
    return .value(module)
  }

  // MARK: - Exec

  internal static var execBuiltinDoc: String {
    return """
    exec_builtin($module, mod, /)
    --

    Initialize a built-in module.
    """
  }

  // sourcery: pymethod = exec_builtin, doc = execBuiltinDoc
  /// static int
  /// _imp_exec_builtin_impl(PyObject *module, PyObject *mod)
  public func execBuiltin(module: PyObject) -> PyResult<PyNone> {
//    guard let mod = module as? PyModule else {
//      let msg = "exec_builtin() argument must be module, not \(module.typeName)"
//      return .typeError(msg)
//    }

    self.unimplemented()
  }
}
