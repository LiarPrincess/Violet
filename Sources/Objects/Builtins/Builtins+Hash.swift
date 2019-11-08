extension Builtins {

  // sourcery: pymethod: hash
  /// hash(object)
  /// See [this](https://docs.python.org/3/library/functions.html#hash)
  ///
  /// Py_hash_t PyObject_Hash(PyObject *v)
  /// slot_tp_hash(PyObject *self)
  public func hash(_ object: PyObject) -> PyResultOrNot<PyHash> {
    if let hashOwner = object as? __hash__Owner {
      return hashOwner.hash()
    }

    let callResult = self.callMethod(on: object, selector: "__hash__", args: [])
    guard case let CallResult.value(result) = callResult else {
      return self.hashNotImplemented(object)
    }

    guard let pyint = result as? PyInt else {
      let msg = "__hash__ method should return an integer, not \(result.typeName)"
      return .typeError(msg)
    }

    if let hash = PyHash(exactly: pyint.value) {
      return .value(hash)
    }

    // `result` was not within the range of a Py_hash_t, so we're free to
    // use any sufficiently bit-mixing transformation;
    // long.__hash__ will do nicely.
    return pyint.hash()
  }

  /// Py_hash_t PyObject_HashNotImplemented(PyObject *v)
  public func hashNotImplemented(_ object: PyObject) -> PyResultOrNot<PyHash> {
    return .typeError("unhashable type: '\(object.typeName)'")
  }
}
