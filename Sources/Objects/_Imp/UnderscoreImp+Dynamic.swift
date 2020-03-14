// In CPython:
// Python -> import.c

extension UnderscoreImp {

  // MARK: - Create

  internal static var createDynamicDoc: String {
    return """
    create_dynamic($module, spec, file=None, /)
    --

    Create an extension module.
    """
  }

  // sourcery: pymethod = create_dynamic, doc = createDynamicDoc
  /// static PyObject *
  /// _imp_create_dynamic_impl(PyObject *module, PyObject *spec, PyObject *file)
  public func createDynamic(spec: PyObject, file: PyObject) -> PyResult<PyObject> {
    self.unimplemented()
  }

  // MARK: - Exec

  internal static var execDynamicDoc: String {
    return """
    exec_dynamic($module, mod, /)
    --

    Initialize an extension module.
    """
  }

  // sourcery: pymethod = exec_dynamic, doc = execDynamicDoc
  /// static int
  /// _imp_exec_dynamic_impl(PyObject *module, PyObject *mod)
  public func execDynamic(module: PyObject) -> PyResult<PyNone> {
    guard let mod = module as? PyModule else {
      let msg = "exec_dynamic() argument must be module, not \(module.typeName)"
      return .typeError(msg)
    }

    self.unimplemented()
  }
}
