import Core

// In CPython:
// Python -> builtinmodule.c
// https://docs.python.org/3/library/functions.html

extension Builtins {

  // MARK: - Not

  /// Equivalent of 'not v'.
  ///
  /// int PyObject_Not(PyObject *v)
  public func not(_ object: PyObject) -> PyObject {
    switch self.isTrueRaw(object) {
    case let .value(isTrue):
      return self.newBool(!isTrue)
    case let .error(e):
      return e.toPyObject(in: self.context)
    }
  }

  public func notBool(_ object: PyObject) -> Bool {
    return !self.isTrueBool(object)
  }

  // MARK: - Is true

  /// Test a value used as condition, e.g.,  `if`  or `in` statement.
  public func isTrue(_ object: PyObject) -> PyObject {
    switch self.isTrueRaw(object) {
    case let .value(isTrue):
      return self.newBool(isTrue)
    case let .error(e):
      return e.toPyObject(in: self.context)
    }
  }

  public func isTrueBool(_ object: PyObject) -> Bool {
    switch self.isTrueRaw(object) {
    case .value(let result):
      return result
    case .error:
      // All builtin errors are always `True`
      return true
    }
  }

  /// PyObject_IsTrue(PyObject *v)
  /// slot_nb_bool(PyObject *self)
  private func isTrueRaw(_ object: PyObject) -> PyResult<Bool> {
    if object is PyNone {
      return .value(false)
    }

    // Try __bool__
    if let boolOwner = object as? __bool__Owner {
      return .value(boolOwner.asBool())
    }

    let boolResult = self.callMethod(on: object, selector: "__bool__", args: [])
    if case let CallResult.value(object) = boolResult {
      if object.type.isSubtype(of: self.bool) {
        return .value(self.isTrueBool(object))
      }

      let typeName = object.typeName
      return .typeError("__bool__ should return bool, returned '\(typeName)'")
    }

    // Try __len__
    if let lenOwner = object as? __len__Owner {
      let len = lenOwner.getLength()
      return .value(len.isTrue)
    }

    let lenResult = self.callMethod(on: object, selector: "__len__", args: [])
    if case let CallResult.value(object) = lenResult {
      return .value(self.isTrueBool(object))
    }

    return .value(true)
  }

  // MARK: - Is

  /// `is` will return `True` if two variables point to the same object.
  public func `is`(left: PyObject, right: PyObject) -> Bool {
    return left === right
  }
}
