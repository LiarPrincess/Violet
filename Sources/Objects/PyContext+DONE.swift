import Core

extension PyContext {

  // MARK: - Hash

  /// Py_hash_t PyObject_Hash(PyObject *v)
  internal func hash(value: PyObject) -> PyHash {
    return 0
  }

  // MARK: - Shared

  public func contains(sequence: PyObject, value: PyObject) -> PyResult<Bool> {
    return .value(false)
  }
}
