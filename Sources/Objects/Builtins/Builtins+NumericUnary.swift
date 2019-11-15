extension Builtins {

  // MARK: - Pos

  /// PyObject * PyNumber_Positive(PyObject *o)
  public func pos(_ value: PyObject) -> PyResult<PyObject> {
    if let owner = value as? __pos__Owner {
      return .value(owner.positive())
    }

    return self.callUnaryMethod(on: value,
                                selector: "__pos__",
                                op: "unary +")
  }

  // MARK: - Neg

  /// PyObject * PyNumber_Negative(PyObject *o)
  public func neg(_ value: PyObject) -> PyResult<PyObject> {
    if let owner = value as? __neg__Owner {
      return .value(owner.negative())
    }

    return self.callUnaryMethod(on: value,
                                selector: "__neg__",
                                op: "unary -")
  }

  // MARK: - Invert

  /// PyObject * PyNumber_Invert(PyObject *o)
  public func invert(_ value: PyObject) -> PyResult<PyObject> {
    if let owner = value as? __invert__Owner {
      return .value(owner.invert())
    }

    return self.callUnaryMethod(on: value,
                                selector: "__invert__",
                                op: "unary ~")
  }

  // MARK: - Abs

  // sourcery: pymethod: abs
  /// abs(x)
  /// See [this](https://docs.python.org/3/library/functions.html#abs)
  ///
  /// PyObject * PyNumber_Absolute(PyObject *o)
  public func abs(_ value: PyObject) -> PyResult<PyObject> {
    if let owner = value as? __abs__Owner {
      return .value(owner.abs())
    }

    return self.callUnaryMethod(on: value,
                                selector: "__abs__",
                                op: "abs()")
  }

  // MARK: - Helpers

  private func callUnaryMethod(on value: PyObject,
                               selector: String,
                               op: String) -> PyResult<PyObject> {
    switch self.callMethod(on: value, selector: selector) {
    case .value(let result):
      return .value(result)
    case .noSuchMethod:
      return .typeError("bad operand type for \(op): '\(value.typeName)'")
    case .methodIsNotCallable(let e):
      return .error(e)
    }
  }
}
