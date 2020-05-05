import VioletCore

// In CPython:
// Python -> builtinmodule.c
// https://docs.python.org/3/library/functions.html

extension PyInstance {

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
    if let result = Fast.__bool__(object) {
      return .value(result)
    }

    switch self.callMethod(object: object, selector: .__bool__) {
    case .value(let result):
      if let pyBool = result as? PyBool {
        return .value(pyBool.value.isTrue)
      }

      let typeName = result.typeName
      return .typeError("__bool__ should return bool, returned '\(typeName)'")
    case .missingMethod:
      break // Try other methods
    case .error(let e), .notCallable(let e):
      return .error(e)
    }

    // Try __len__
    if let len = Fast.__len__(object) {
      return .value(len.isTrue)
    }

    switch self.callMethod(object: object, selector: .__len__) {
    case .value(let len):
      return self.interpret__len__asBool(len: len)
    case .missingMethod:
      return .value(true) // If we don't have '__bool__' or '__len__' -> True
    case .error(let e),
         .notCallable(let e):
      return .error(e)
    }
  }

  private func interpret__len__asBool(len: PyObject) -> PyResult<Bool> {
    // Do you even 'int', bro?
    let bigInt: BigInt
    switch IndexHelper.bigInt(len) {
    case let .value(b):
      bigInt = b
    case let .error(e):
      return .error(e)
    }

    guard bigInt.hashValue >= 0 else {
      return .valueError("__len__() should return >= 0")
    }

    return .value(bigInt.isTrue)
  }

  // MARK: - Is

  /// `is` will return `True` if two variables point to the same object.
  public func `is`(left: PyObject, right: PyObject) -> Bool {
    return left === right
  }
}
