import VioletCore

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

  /// static PyObject *
  /// _imp_is_builtin_impl(PyObject *module, PyObject *name)
  public func isBuiltin(name nameRaw: PyObject) -> PyResult<PyInt> {
    guard let name = nameRaw as? PyString else {
      let msg = "is_builtin() argument must be str, not \(nameRaw.typeName)"
      return .typeError(msg)
    }

    let builtinNames = Py.sys.builtinModuleNames
    let result = builtinNames.contains(name.value)

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

  /// static PyObject *
  /// _imp_create_builtin(PyObject *module, PyObject *spec)
  public func createBuiltin(spec: PyObject) -> PyResult<PyObject> {
    // Note that we do not have to 'create' new module here!
    // We already did that in 'Py.initialize'.

    let name: PyString
    switch self.getName(spec: spec) {
    case let .value(n): name = n
    case let .error(e): return .error(e)
    }

    // Check if we already have this module (we will not check if it is builtin).
    switch Py.sys.getModule(name: name) {
    case .value(let m):
      return .value(m)
    case .notFound:
      let msg = "'\(name.value)' module is not a correct builtin module."
      return .error(Py.newRuntimeError(msg: msg))
    case .error(let e):
      return .error(e)
    }
  }

  // MARK: - Exec

  internal static var execBuiltinDoc: String {
    return """
    exec_builtin($module, mod, /)
    --

    Initialize a built-in module.
    """
  }

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
