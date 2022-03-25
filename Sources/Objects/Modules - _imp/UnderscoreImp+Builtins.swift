import VioletCore

// In CPython:
// Python -> import.c

// Docs:
// https://docs.python.org/3.7/reference/import.html
// https://docs.python.org/3.7/library/importlib.html

extension UnderscoreImp {

  // MARK: - Is builtin

  internal static let isBuiltinDoc = """
    is_builtin($module, name, /)
    --

    Returns True if the module name corresponds to a built-in module.
    """

  internal static func is_builtin(_ py: Py, name: PyObject) -> PyResult {
    let result = py._imp.isBuiltin(name: name)
    return PyResult(py, result)
  }

  /// static PyObject *
  /// _imp_is_builtin_impl(PyObject *module, PyObject *name)
  public func isBuiltin(name: PyObject) -> PyResultGen<Int> {
    guard self.py.cast.isString(name) else {
      let message = "is_builtin() argument must be str, not \(name.typeName)"
      return .typeError(self.py, message: message)
    }

    let builtinModuleNames: PyTuple
    switch self.py.sys.getBuiltinModuleNames() {
    case let .value(t): builtinModuleNames = t
    case let .error(e): return .error(e)
    }

    let builtinModuleNamesObject = builtinModuleNames.asObject
    switch self.py.contains(iterable: builtinModuleNamesObject, object: name) {
    case let .value(o):
      switch self.py.isTrueBool(object: o) {
      case let .value(b): return .value(b ? 1 : 0)
      case let .error(e): return .error(e)
      }
    case let .error(e):
      return .error(e)
    }
  }

  // MARK: - Create

  internal static let createBuiltinDoc = """
    create_builtin($module, spec, /)
    --

    Create an extension module.
    """

  internal static func create_builtin(_ py: Py, spec: PyObject) -> PyResult {
    let result = py._imp.createBuiltin(spec: spec)
    return PyResult(result)
  }

  /// static PyObject *
  /// _imp_create_builtin(PyObject *module, PyObject *spec)
  public func createBuiltin(spec: PyObject) -> PyResultGen<PyModule> {
    // Note that we do not have to 'create' new module here!
    // We already did that in 'self.py.initialize'.

    let name: PyString
    switch self.getName(spec: spec) {
    case let .value(n): name = n
    case let .error(e): return .error(e)
    }

    // Check if we already have this module (we will not check if it is builtin).
    switch self.py.sys.getModule(name: name) {
    case .module(let m):
      return .value(m)
    case .notFound,
         .notModule:
      let message = "'\(name.value)' module is not a correct builtin module."
      let error = self.py.newRuntimeError(message: message)
      return .error(error.asBaseException)
    case .error(let e):
      return .error(e)
    }
  }

  // MARK: - Exec

  internal static let execBuiltinDoc = """
    exec_builtin($module, mod, /)
    --

    Initialize a built-in module.
    """

  internal static func exec_builtin(_ py: Py, mod: PyObject) -> PyResult {
    if let error = py._imp.execBuiltin(module: mod) {
      return .error(error)
    }

    return .none(py)
  }

  /// static int
  /// _imp_exec_builtin_impl(PyObject *module, PyObject *mod)
  public func execBuiltin(module: PyObject) -> PyBaseException? {
    Self.unimplemented()
  }
}
