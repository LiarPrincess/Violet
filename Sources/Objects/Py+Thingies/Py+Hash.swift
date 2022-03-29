// In CPython:
// Python -> builtinmodule.c
// https://docs.python.org/3/library/functions.html

// cSpell:ignore unhashable

extension Py {

  /// hash(object)
  /// See [this](https://docs.python.org/3/library/functions.html#hash)
  ///
  /// Py_hash_t PyObject_Hash(PyObject *v)
  /// slot_tp_hash(PyObject *self)
  public func hash(object: PyObject) -> PyResultGen<PyHash> {
    if let result = PyStaticCall.__hash__(self, object: object) {
      switch result {
      case let .value(hash):
        return .value(hash)
      case let .unhashable(object):
        let error = self.newUnhashableObjectError(object: object)
        return .error(error.asBaseException)
      case let .invalidSelfArgument(object, expectedType):
        let error = HashResult.createInvalidSelfArgumentError(self,
                                                              object: object,
                                                              expectedType: expectedType)
        return .error(error.asBaseException)
      case let .error(e):
        return .error(e)
      }
    }

    let result: PyObject
    switch self.callMethod(object: object, selector: .__hash__) {
    case .value(let o):
      result = o
    case .missingMethod:
      let error = self.newUnhashableObjectError(object: object)
      return .error(error.asBaseException)
    case .error(let e),
         .notCallable(let e):
      return .error(e)
    }

    guard let pyInt = self.cast.asInt(result) else {
      let message = "__hash__ method should return an integer, not \(result.typeName)"
      return .typeError(self, message: message)
    }

    if let hash = PyHash(exactly: pyInt.value) {
      return .value(hash)
    }

    // `result` was not within the range of a Py_hash_t, so we're free to
    // use any sufficiently bit-mixing transformation;
    // long.__hash__ will do nicely.
    let pyIntHash = pyInt.hash(self)
    return .value(pyIntHash)
  }

  /// Py_hash_t PyObject_HashNotImplemented(PyObject *v)
  internal func newUnhashableObjectError(object: PyObject) -> PyTypeError {
    let message = "unhashable type: '\(object.typeName)'"
    return self.newTypeError(message: message)
  }
}
