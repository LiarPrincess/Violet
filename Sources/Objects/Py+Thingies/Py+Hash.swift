/* MARKER
// In CPython:
// Python -> builtinmodule.c
// https://docs.python.org/3/library/functions.html

// cSpell:ignore unhashable

extension PyInstance {

  /// hash(object)
  /// See [this](https://docs.python.org/3/library/functions.html#hash)
  ///
  /// Py_hash_t PyObject_Hash(PyObject *v)
  /// slot_tp_hash(PyObject *self)
  public func hash(object: PyObject) -> PyResult<PyHash> {
    if let result = PyStaticCall.__hash__(object) {
      switch result {
      case let .value(hash):
        return .value(hash)
      case let .unhashable(object):
        let e = self.hashNotAvailable(object)
        return .error(e)
      case let .error(e):
        return .error(e)
      }
    }

    let result: PyObject
    switch self.callMethod(object: object, selector: .__hash__) {
    case .value(let o):
      result = o
    case .missingMethod:
      let e = self.hashNotAvailable(object)
      return .error(e)
    case .error(let e),
         .notCallable(let e):
      return .error(e)
    }

    guard let pyInt = PyCast.asInt(result) else {
      let t = result.typeName
      return .typeError("__hash__ method should return an integer, not \(t)")
    }

    if let hash = PyHash(exactly: pyInt.value) {
      return .value(hash)
    }

    // `result` was not within the range of a Py_hash_t, so we're free to
    // use any sufficiently bit-mixing transformation;
    // long.__hash__ will do nicely.
    let pyIntHash = pyInt.hash()
    return .value(pyIntHash)
  }

  /// Py_hash_t PyObject_HashNotImplemented(PyObject *v)
  internal func hashNotAvailable(_ object: PyObject) -> PyBaseException {
    let msg = "unhashable type: '\(object.typeName)'"
    return self.newTypeError(msg: msg)
  }
}

*/