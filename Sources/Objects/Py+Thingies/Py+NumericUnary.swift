// In CPython:
// Python -> builtinmodule.c
// https://docs.python.org/3/library/functions.html

extension Py {

  // MARK: - Positive

  /// PyObject * PyNumber_Positive(PyObject *o)
  public func positive(object: PyObject) -> PyResult {
    if let result = PyStaticCall.__pos__(self, object: object) {
      return result
    }

    return self.callUnaryMethod(object: object,
                                selector: .__pos__,
                                operation: "unary +")
  }

  // MARK: - Negative

  /// PyObject * PyNumber_Negative(PyObject *o)
  public func negative(object: PyObject) -> PyResult {
    if let result = PyStaticCall.__neg__(self, object: object) {
      return result
    }

    return self.callUnaryMethod(object: object,
                                selector: .__neg__,
                                operation: "unary -")
  }

  // MARK: - Invert

  /// PyObject * PyNumber_Invert(PyObject *o)
  public func invert(object: PyObject) -> PyResult {
    if let result = PyStaticCall.__invert__(self, object: object) {
      return result
    }

    return self.callUnaryMethod(object: object,
                                selector: .__invert__,
                                operation: "unary ~")
  }

  // MARK: - Absolute

  /// abs(x)
  /// See [this](https://docs.python.org/3/library/functions.html#abs)
  ///
  /// PyObject * PyNumber_Absolute(PyObject *o)
  public func absolute(object: PyObject) -> PyResult {
    if let result = PyStaticCall.__abs__(self, object: object) {
      return result
    }

    return self.callUnaryMethod(object: object,
                                selector: .__abs__,
                                operation: "abs()")
  }

  // MARK: - Helpers

  private func callUnaryMethod(object: PyObject,
                               selector: IdString,
                               operation: String) -> PyResult {
    switch self.callMethod(object: object, selector: selector) {
    case .value(let result):
      return .value(result)
    case .missingMethod:
      let message = "bad operand type for \(operation): '\(object.typeName)'"
      return .typeError(self, message: message)
    case .error(let e),
        .notCallable(let e):
      return .error(e)
    }
  }
}
