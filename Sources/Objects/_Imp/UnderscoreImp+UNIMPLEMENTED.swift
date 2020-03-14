import Core

// In CPython:
// Python -> import.c

extension UnderscoreImp {

  // MARK: - Hash

  internal static var sourceHashDoc: String {
    return """
    source_hash($module, /, key, source)
    --
    """
  }

  // sourcery: pymethod = source_hash, doc = sourceHashDoc
  /// static PyObject *
  /// _imp_source_hash_impl(PyObject *module, long key, Py_buffer *source)
  public func sourceHash() -> PyObject {
    self.unimplemented()
  }

  internal static var checkHashBasedPycsDoc: String {
    return ""
  }

  // sourcery: pymethod = check_hash_based_pycs, doc = checkHashBasedPycsDoc
  public func checkHashBasedPycs() -> PyObject {
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

  // sourcery: pymethod = _fix_co_filename, doc = fixCoFilenameDoc
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

  // sourcery: pymethod = extension_suffixes, doc = extensionSuffixesDoc
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
