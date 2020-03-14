extension UnderscoreImp {

  // MARK: - Is

  internal static var isFrozenDoc: String {
    return """
    is_frozen($module, name, /)
    --

    Returns True if the module name corresponds to a frozen module.
    """
  }

  // sourcery: pymethod = is_frozen, doc = isFrozenDoc
  /// static PyObject *
  /// _imp_is_frozen_impl(PyObject *module, PyObject *name)
  public func isFrozen() -> PyBool {
    // We currently do not support frozen modules.
    return Py.false
  }

  // MARK: - Is package

  internal static var isFrozenPackageDoc: String {
    return """
    is_frozen_package($module, name, /)
    --

    Returns True if the module name is of a frozen package.
    """
  }

  // sourcery: pymethod = is_frozen_package, doc = isFrozenPackageDoc
  /// static PyObject *
  /// _imp_is_frozen_package_impl(PyObject *module, PyObject *name)
  public func isFrozenPackage() -> PyBool {
    // We currently do not support frozen modules.
    return Py.false
  }

  // MARK: - Get object

  internal static var getFrozenObjectDoc: String {
    return """
    get_frozen_object($module, name, /)
    --

    Create a code object for a frozen module.
    """
  }

  // sourcery: pymethod = get_frozen_object, doc = getFrozenObjectDoc
  /// static PyObject *
  /// _imp_get_frozen_object_impl(PyObject *module, PyObject *name)
  public func getFrozenObject() -> PyObject {
    // We currently do not support frozen modules.
    self.unimplemented()
  }

  // MARK: - Init

  internal static var initFrozenDoc: String {
    return """
    init_frozen($module, name, /)
    --

    Initializes a frozen module.
    """
  }

  // sourcery: pymethod = init_frozen, doc = initFrozenDoc
  /// static PyObject *
  /// _imp_init_frozen_impl(PyObject *module, PyObject *name)
  public func initFrozen() -> PyObject {
    // We currently do not support frozen modules.
    self.unimplemented()
  }
}
