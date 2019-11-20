import Core

// In CPython:
// Python -> builtinmodule.c
// https://docs.python.org/3/library/functions.html

extension Builtins {

  // MARK: - Not

  /// Equivalent of 'not v'.
  ///
  /// int PyObject_Not(PyObject *v)
  public func not(_ object: PyObject) -> PyResult<PyBool> {
    return self.isTrueBool(object)
      .map { !$0 }
      .map(self.newBool)
  }

  public func notBool(_ object: PyObject) -> PyResult<Bool> {
    return self.isTrueBool(object).map { !$0 }
  }

  // MARK: - Is true

  /// Test a value used as condition, e.g.,  `if`  or `in` statement.
  public func isTrue(_ object: PyObject) -> PyResult<PyBool> {
    return self.isTrueBool(object).map(self.newBool)
  }

  /// PyObject_IsTrue(PyObject *v)
  /// slot_nb_bool(PyObject *self)
  public func isTrueBool(_ object: PyObject) -> PyResult<Bool> {
    if object is PyNone {
      return .value(false)
    }

    // Try __bool__
    if let boolOwner = object as? __bool__Owner {
      return .value(boolOwner.asBool())
    }

    switch self.callMethod(on: object, selector: "__bool__") {
    case .value(let result):
      if result.type.isSubtype(of: self.bool) {
        return self.isTrueBool(result)
      }

      let typeName = result.typeName
      return .typeError("__bool__ should return bool, returned '\(typeName)'")
    case .notImplemented,
         .noSuchMethod:
      break // Try other methods
    case .methodIsNotCallable(let e),
         .error(let e):
      return .error(e)
    }

    // Try __len__
    if let lenOwner = object as? __len__Owner {
      let len = lenOwner.getLength()
      return .value(len.isTrue)
    }

    switch self.callMethod(on: object, selector: "__len__") {
    case .value(let result):
      return self.isTrueBool(result)
    case .notImplemented,
         .noSuchMethod:
      return .value(true)
    case .methodIsNotCallable(let e),
         .error(let e):
      return .error(e)
    }
  }

  // MARK: - Is

  /// `is` will return `True` if two variables point to the same object.
  public func `is`(left: PyObject, right: PyObject) -> Bool {
    return left === right
  }
}
