import VioletCore

// In CPython:
// Python -> import.c

// Docs:
// https://docs.python.org/3.7/reference/import.html
// https://docs.python.org/3.7/library/importlib.html

extension UnderscoreImp {

  // MARK: - Is builtin

  internal static var isBuiltinDoc: String {
    return """
    is_builtin($module, name, /)
    --

    Returns True if the module name corresponds to a built-in module.
    """
  }

  /// static PyObject *
  /// _imp_is_builtin_impl(PyObject *module, PyObject *name)
  public func isBuiltin(name nameObject: PyObject) -> PyResult<PyInt> {
    guard let name = PyCast.asString(nameObject) else {
      let msg = "is_builtin() argument must be str, not \(nameObject.typeName)"
      return .typeError(msg)
    }

    let builtinModuleNames: PyTuple
    switch Py.sys.getBuiltinModuleNames() {
    case let .value(t): builtinModuleNames = t
    case let .error(e): return .error(e)
    }

    switch Py.contains(iterable: builtinModuleNames, element: name) {
    case let .value(b):
      let int = Py.newInt(b ? 1 : 0)
      return .value(int)
    case let .error(e):
      return .error(e)
    }
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
  public func createBuiltin(spec: PyObject) -> PyResult<PyModule> {
    // Note that we do not have to 'create' new module here!
    // We already did that in 'Py.initialize'.

    let name: PyString
    switch self.getName(spec: spec) {
    case let .value(n): name = n
    case let .error(e): return .error(e)
    }

    // Check if we already have this module (we will not check if it is builtin).
    switch Py.sys.getModule(name: name) {
    case .module(let m):
      return .value(m)
    case .notFound,
         .notModule:
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
//    guard let mod = PyCast.asModule(module) else {
//      let msg = "exec_builtin() argument must be module, not \(module.typeName)"
//      return .typeError(msg)
//    }

    self.unimplemented()
  }
}
