import VioletCore

// In CPython:
// Python -> import.c

// Docs:
// https://docs.python.org/3.7/reference/import.html
// https://docs.python.org/3.7/library/importlib.html

extension UnderscoreImp {

  // MARK: - Frozen

  internal static let isFrozenDoc = """
    is_frozen($module, name, /)
    --

    Returns True if the module name corresponds to a frozen module.
    """

  /// static PyObject *
  /// _imp_is_frozen_impl(PyObject *module, PyObject *name)
  internal static func is_frozen(_ py: Py, name: PyObject) -> PyResult {
    Self.unimplemented()
  }

  internal static let isFrozenPackageDoc = """
    is_frozen_package($module, name, /)
    --

    Returns True if the module name is of a frozen package.
    """

  /// static PyObject *
  /// _imp_is_frozen_package_impl(PyObject *module, PyObject *name)
  internal static func is_frozen_package(_ py: Py, name: PyObject) -> PyResult {
    Self.unimplemented()
  }

  internal static let getFrozenObjectDoc = """
    get_frozen_object($module, name, /)
    --

    Create a code object for a frozen module.
    """

  /// static PyObject *
  /// _imp_get_frozen_object_impl(PyObject *module, PyObject *name)
  internal static func get_frozen_object(_ py: Py, name: PyObject) -> PyResult {
    Self.unimplemented()
  }

  internal static let initFrozenDoc = """
    init_frozen($module, name, /)
    --

    Initializes a frozen module.
    """

  /// static PyObject *
  /// _imp_init_frozen_impl(PyObject *module, PyObject *name)
  internal static func init_frozen(_ py: Py, name: PyObject) -> PyResult {
    Self.unimplemented()
  }

  // MARK: - Dynamic

  internal static let createDynamicDoc = """
    create_dynamic($module, spec, file=None, /)
    --

    Create an extension module.
    """

  /// static PyObject *
  /// _imp_create_dynamic_impl(PyObject *module, PyObject *spec, PyObject *file)
  internal static func create_dynamic(_ py: Py,
                                      spec: PyObject,
                                      file: PyObject) -> PyResult {
    Self.unimplemented()
  }

  internal static let execDynamicDoc = """
    exec_dynamic($module, mod, /)
    --

    Initialize an extension module.
    """

  /// static int
  /// _imp_exec_dynamic_impl(PyObject *module, PyObject *mod)
  internal static func exec_dynamic(_ py: Py, mode: PyObject) -> PyResult {
    Self.unimplemented()
  }

  // MARK: - Hash

  internal static let sourceHashDoc = """
    source_hash($module, /, key, source)
    --
    """

  /// static PyObject *
  /// _imp_source_hash_impl(PyObject *module, long key, Py_buffer *source)
  internal static func source_hash(_ py: Py,
                                   key: PyObject,
                                   source: PyObject) -> PyResult {
    // Used for frozen modules, see:
    // https://docs.python.org/3.7/reference/import.html#cached-bytecode-invalidation
    Self.unimplemented()
  }

  internal static let checkHashBasedPycsDoc = ""

  internal static func check_hash_based_pycs(_ py: Py) -> PyResult {
    Self.unimplemented()
  }

  // MARK: - Other

  internal static let fixCoFilenameDoc = """
    _fix_co_filename($module, code, path, /)
    --

    Changes code.co_filename to specify the passed-in file path.

    code
    Code object to change.
    path
    File path to use.
    """

  internal static func _fix_co_filename(_ py: Py,
                                        code: PyObject,
                                        path: PyObject) -> PyResult {
    Self.unimplemented()
  }

  internal static let extensionSuffixesDoc = """
    extension_suffixes($module, /)
    --

    Returns the list of file suffixes used to identify extension modules.
    """

  /// static PyObject *
  /// _imp_extension_suffixes_impl(PyObject *module)
  internal static func extension_suffixes(_ py: Py) -> PyResult {
    Self.unimplemented()
  }

  // MARK: - Unimplemented

  /// Some methods are implemented partially
  /// In such cases they will call this method.
  internal static func unimplemented(fn: String = #function) -> Never {
    trap("'\(fn)' is not implemented")
  }
}
