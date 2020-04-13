// In CPython:
// Python -> builtinmodule.c
// https://docs.python.org/3/library/functions.html

extension PyInstance {

  // MARK: - Pos

  /// PyObject * PyNumber_Positive(PyObject *o)
  public func pos(_ value: PyObject) -> PyResult<PyObject> {
    if let owner = value as? __pos__Owner {
      return .value(owner.positive())
    }

    return self.callUnaryMethod(object: value,
                                selector: .__pos__,
                                operation: "unary +")
  }

  // MARK: - Neg

  /// PyObject * PyNumber_Negative(PyObject *o)
  public func neg(_ value: PyObject) -> PyResult<PyObject> {
    if let owner = value as? __neg__Owner {
      return .value(owner.negative())
    }

    return self.callUnaryMethod(object: value,
                                selector: .__neg__,
                                operation: "unary -")
  }

  // MARK: - Invert

  /// PyObject * PyNumber_Invert(PyObject *o)
  public func invert(_ value: PyObject) -> PyResult<PyObject> {
    if let owner = value as? __invert__Owner {
      return .value(owner.invert())
    }

    return self.callUnaryMethod(object: value,
                                selector: .__invert__,
                                operation: "unary ~")
  }

  // MARK: - Abs

  /// abs(x)
  /// See [this](https://docs.python.org/3/library/functions.html#abs)
  ///
  /// PyObject * PyNumber_Absolute(PyObject *o)
  public func abs(object: PyObject) -> PyResult<PyObject> {
    if let owner = object as? __abs__Owner {
      return .value(owner.abs())
    }

    return self.callUnaryMethod(object: object,
                                selector: .__abs__,
                                operation: "abs()")
  }

  // MARK: - Helpers

  private func callUnaryMethod(object: PyObject,
                               selector: IdString,
                               operation: String) -> PyResult<PyObject> {
    switch self.callMethod(object: object, selector: selector) {
    case .value(let result):
      return .value(result)
    case .missingMethod:
      return .typeError("bad operand type for \(operation): '\(object.typeName)'")
    case .error(let e), .notCallable(let e):
      return .error(e)
    }
  }
}
