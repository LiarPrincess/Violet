extension Builtins {

  // sourcery: pymethod: hash
  /// hash(object)
  /// See [this](https://docs.python.org/3/library/functions.html#hash)
  ///
  /// Py_hash_t PyObject_Hash(PyObject *v)
  public func hash(_ object: PyObject) -> PyResultOrNot<PyHash> {
    if let hashOwner = object as? __hash__Owner {
      return hashOwner.hash()
    }

    // TODO: Call user `__hash__`
    return .notImplemented
  }

  /// Py_hash_t PyObject_HashNotImplemented(PyObject *v)
  public func hashNotImplemented(_ object: PyObject) -> PyResultOrNot<PyHash> {
    return .error(.typeError("unhashable type: '\(object.typeName)'"))
  }
}
