import BigInt
import VioletCore

// In CPython:
// Python -> builtinmodule.c
// https://docs.python.org/3/library/functions.html

extension Py {

  // MARK: - New

  public func newBool(_ value: Bool) -> PyBool {
    return value ? self.true : self.false
  }

  public func newBool(_ value: BigInt) -> PyBool {
    return self.newBool(value.isTrue)
  }

  // MARK: - Not

  /// Equivalent of 'not v'.
  ///
  /// int PyObject_Not(PyObject *v)
  public func not(object: PyObject) -> PyResult<PyBool> {
    switch self.isTrueBool(object: object) {
    case let .value(b):
      let result = self.newBool(!b)
      return .value(result)
    case let .error(e):
      return .error(e)
    }
  }

  public func notBool(object: PyObject) -> PyResult<Bool> {
    switch self.isTrueBool(object: object) {
    case let .value(b):
      return .value(!b)
    case let .error(e):
      return .error(e)
    }
  }

  // MARK: - Is true

  /// Test a value used as condition, e.g.,  `if`  or `in` statement.
  public func isTrue(object: PyObject) -> PyResult<PyBool> {
    switch self.isTrueBool(object: object) {
    case let .value(b):
      let result = self.newBool(b)
      return .value(result)
    case let .error(e):
      return .error(e)
    }
  }

  public func isTrueBool(object: PyBool) -> Bool {
    return object.value.isTrue
  }

  /// PyObject_IsTrue(PyObject *v)
  /// slot_nb_bool(PyObject *self)
  public func isTrueBool(object: PyObject) -> PyResult<Bool> {
    if self.cast.isNone(object) {
      return .value(false)
    }

    if let bool = self.cast.asBool(object) {
       let result = self.isTrueBool(object: bool)
      return .value(result)
    }

    // Try __bool__
    if let result = PyStaticCall.__bool__(self, object: object) {
      return .value(result.isTrue)
    }

    switch self.callMethod(object: object, selector: .__bool__) {
    case .value(let result):
      if let pyBool = self.cast.asBool(result) {
        return .value(pyBool.value.isTrue)
      }

      let message = "__bool__ should return bool, returned '\(result.typeName)'"
      return .typeError(self, message: message)
    case .missingMethod:
      break // Try other methods
    case .error(let e),
         .notCallable(let e):
      return .error(e)
    }

    // Try __len__
    if let len = PyStaticCall.__len__(self, object: object) {
      return .value(len.value.isTrue)
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
    switch IndexHelper.pyInt(self, object: len) {
    case let .value(b):
      bigInt = b.value
    case let .notIndex(lazyError):
      let e = lazyError.create(self)
      return .error(e)
    case let .error(e):
      return .error(e)
    }

    guard bigInt >= 0 else {
      return .valueError(self, message: "__len__() should return >= 0")
    }

    return .value(bigInt.isTrue)
  }

  // MARK: - Is

  /// `is` will return `True` if two variables point to the same object.
  public func `is`(left: PyObject, right: PyObject) -> Bool {
    return left.ptr === right.ptr
  }
}
