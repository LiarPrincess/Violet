import VioletCore

// In CPython:
// Python -> import.c

// Docs:
// https://docs.python.org/3.7/reference/import.html
// https://docs.python.org/3.7/library/importlib.html

extension UnderscoreImp {

  // MARK: - Frozen

  internal static var isFrozenDoc: String {
    return """
    is_frozen($module, name, /)
    --

    Returns True if the module name corresponds to a frozen module.
    """
  }

  /// static PyObject *
  /// _imp_is_frozen_impl(PyObject *module, PyObject *name)
  public func isFrozen() -> PyObject {
    self.unimplemented()
  }

  internal static var isFrozenPackageDoc: String {
    return """
    is_frozen_package($module, name, /)
    --

    Returns True if the module name is of a frozen package.
    """
  }

  /// static PyObject *
  /// _imp_is_frozen_package_impl(PyObject *module, PyObject *name)
  public func isFrozenPackage() -> PyObject {
    self.unimplemented()
  }

  internal static var getFrozenObjectDoc: String {
    return """
    get_frozen_object($module, name, /)
    --

    Create a code object for a frozen module.
    """
  }

  /// static PyObject *
  /// _imp_get_frozen_object_impl(PyObject *module, PyObject *name)
  public func getFrozenObject() -> PyObject {
    self.unimplemented()
  }

  internal static var initFrozenDoc: String {
    return """
    init_frozen($module, name, /)
    --

    Initializes a frozen module.
    """
  }

  /// static PyObject *
  /// _imp_init_frozen_impl(PyObject *module, PyObject *name)
  public func initFrozen() -> PyObject {
    // We currently do not support frozen modules.
    self.unimplemented()
  }

  // MARK: - Dynamic

  internal static var createDynamicDoc: String {
    return """
    create_dynamic($module, spec, file=None, /)
    --

    Create an extension module.
    """
  }

  /// static PyObject *
  /// _imp_create_dynamic_impl(PyObject *module, PyObject *spec, PyObject *file)
  public func createDynamic(spec: PyObject, file: PyObject) -> PyResult<PyObject> {
    self.unimplemented()
  }

  internal static var execDynamicDoc: String {
    return """
    exec_dynamic($module, mod, /)
    --

    Initialize an extension module.
    """
  }

  /// static int
  /// _imp_exec_dynamic_impl(PyObject *module, PyObject *mod)
  public func execDynamic(module: PyObject) -> PyResult<PyNone> {
    //    guard let mod = module as? PyModule else {
    //      let msg = "exec_dynamic() argument must be module, not \(module.typeName)"
    //      return .typeError(msg)
    //    }

    self.unimplemented()
  }

  // MARK: - Hash

  internal static var sourceHashDoc: String {
    return """
    source_hash($module, /, key, source)
    --
    """
  }

  /// static PyObject *
  /// _imp_source_hash_impl(PyObject *module, long key, Py_buffer *source)
  public func sourceHash() -> PyObject {
    // Used for frozen modules, see:
    // https://docs.python.org/3.7/reference/import.html#cached-bytecode-invalidation
    self.unimplemented()
  }

  internal static var checkHashBasedPycsDoc: String {
    return ""
  }

  public func checkHashBasedPycs() -> PyObject {
    // Used for frozen modules, see:
    // https://docs.python.org/3.7/reference/import.html#cached-bytecode-invalidation
    self.unimplemented()
  }

  // MARK: - Other

  internal static var fixCoFilenameDoc: String {
    return """
    _fix_co_filename($module, code, path, /)
    --

    Changes code.co_filename to specify the passed-in file path.

    code
    Code object to change.
    path
    File path to use.
    """
  }

  public func fixCoFilename() -> PyObject {
    self.unimplemented()
  }

  internal static var extensionSuffixesDoc: String {
    return """
    extension_suffixes($module, /)
    --

    Returns the list of file suffixes used to identify extension modules.
    """
  }

  /// static PyObject *
  /// _imp_extension_suffixes_impl(PyObject *module)
  public func extensionSuffixes() -> PyObject {
    self.unimplemented()
  }

  // MARK: - Unimplemented

  /// Some methods are implemented partially
  /// In such cases they will call this method.
  internal func unimplemented(fn: String = #function) -> Never {
    trap("'\(fn)' is not implemented")
  }
}
