// In CPython:
// Python -> builtinmodule.c
// https://docs.python.org/3/library/functions.html

extension Builtins {

  // sourcery: pymethod = hash
  /// hash(object)
  /// See [this](https://docs.python.org/3/library/functions.html#hash)
  ///
  /// Py_hash_t PyObject_Hash(PyObject *v)
  /// slot_tp_hash(PyObject *self)
  public func hash(_ object: PyObject) -> PyResult<PyHash> {
    if let hashOwner = object as? __hash__Owner {
      switch hashOwner.hash() {
      case .value(let hash): return .value(hash)
      case .notImplemented: return .error(self.hashNotImplemented(object))
      case .error(let e): return .error(e)
      }
    }

    let result: PyObject
    switch self.callMethod(on: object, selector: "__hash__") {
    case .value(let o):
      result = o
    case .missingMethod:
      return .error(self.hashNotImplemented(object))
    case .error(let e), .notCallable(let e):
      return .error(e)
    }

    guard let pyint = result as? PyInt else {
      return .typeError(
        "__hash__ method should return an integer, not \(result.typeName)"
      )
    }

    if let hash = PyHash(exactly: pyint.value) {
      return .value(hash)
    }

    // `result` was not within the range of a Py_hash_t, so we're free to
    // use any sufficiently bit-mixing transformation;
    // long.__hash__ will do nicely.
    return .value(pyint.hashRaw())
  }

  /// Py_hash_t PyObject_HashNotImplemented(PyObject *v)
  public func hashNotImplemented(_ object: PyObject) -> PyErrorEnum {
    return .typeError("unhashable type: '\(object.typeName)'")
  }
}
