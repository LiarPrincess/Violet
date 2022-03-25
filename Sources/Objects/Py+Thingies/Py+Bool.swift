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
  public func not(object: PyObject) -> PyResult {
    switch self.isTrueBool(object: object) {
    case let .value(isTrue):
      return PyResult(self, !isTrue)
    case let .error(e):
      return .error(e)
    }
  }

  public func notBool(object: PyObject) -> PyResultGen<Bool> {
    switch self.isTrueBool(object: object) {
    case let .value(isTrue):
      return .value(!isTrue)
    case let .error(e):
      return .error(e)
    }
  }

  // MARK: - Is true

  /// Test a value used as condition, e.g.,  `if`  or `in` statement.
  public func isTrue(object: PyObject) -> PyResult {
    switch self.isTrueBool(object: object) {
    case let .value(isTrue):
      return PyResult(self, isTrue)
    case let .error(e):
      return .error(e)
    }
  }

  public func isTrueBool(object: PyBool) -> Bool {
    return object.isTrue
  }

  /// PyObject_IsTrue(PyObject *v)
  /// slot_nb_bool(PyObject *self)
  public func isTrueBool(object: PyObject) -> PyResultGen<Bool> {
    if self.cast.isNone(object) {
      return .value(false)
    }

    if let bool = self.cast.asBool(object) {
      return .value(bool.isTrue)
    }

    // Try __bool__
    if let bool = PyStaticCall.__bool__(self, object: object) {
      return self.interpret__bool__(bool: bool)
    }

    switch self.callMethod(object: object, selector: .__bool__) {
    case .value(let bool):
      return self.interpret__bool__(bool: bool)
    case .missingMethod:
      break // Try other methods
    case .error(let e),
         .notCallable(let e):
      return .error(e)
    }

    // Try __len__
    if let len = PyStaticCall.__len__(self, object: object) {
      return self.interpret__len__asBool(len: len)
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

  private func interpret__bool__(bool: PyResult) -> PyResultGen<Bool> {
    switch bool {
    case let .value(b):
      return self.interpret__bool__(bool: b)
    case let .error(e):
      return .error(e)
    }
  }

  private func interpret__bool__(bool object: PyObject) -> PyResultGen<Bool> {
    if let pyBool = self.cast.asBool(object) {
      return .value(pyBool.isTrue)
    }

    let message = "__bool__ should return bool, returned '\(object.typeName)'"
    return .typeError(self, message: message)
  }

  private func interpret__len__asBool(len: PyResult) -> PyResultGen<Bool> {
    switch len {
    case let .value(l):
      return self.interpret__len__asBool(len: l)
    case let .error(e):
      return .error(e)
    }
  }

  private func interpret__len__asBool(len: PyObject) -> PyResultGen<Bool> {
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
}
