import VioletCore

// In CPython:
// Python -> builtinmodule.c
// https://docs.python.org/3/library/functions.html

// swiftlint:disable type_name

// MARK: - Abstract

private enum StaticCallResult {
  case value(Bool)
  case error(PyBaseException)
  case notImplemented
  /// Static call is not available
  case unavailable

  fileprivate init(_ py: Py, value: CompareResult?) {
    guard let v = value else {
      self = .unavailable
      return
    }

    switch v {
    case .value(let o):
      self = .value(o)
    case .notImplemented:
      self = .notImplemented
    case let .invalidSelfArgument(object, expectedType, operation):
      let error = CompareResult.createInvalidSelfArgumentError(
        py,
        object: object,
        expectedType: expectedType,
        operation: operation
      )

      self = .error(error.asBaseException)
    case .error(let e):
      self = .error(e)
    }
  }
}

/// Basically a template for compare operations.
///
/// This may not be the cleanest/most idiomatic Swift, but it gets the job done.
/// Alternatives:
/// - function with CompareMode enum (equal, left etc…) argument and then
///   switch on it. But then our performance heavily depends on Swift compiler,
///   (can it inline this and then eliminate dead code?) otherwise we pay
///   for each switch.
/// - Java-style abstract class with `final` subclass for every compare operation.
///   In **best** case compiler will (maybe) skip vtable (because of `final`),
///   so we would get static dispatch. But this type of programming
///   (abstract classes) is truly non-idiomatic in Swift.
///
/// Or we could use protocol which will guarantee us static dispatch
/// (btw. everything is on static/type-level, we do not need instances):
private protocol CompareOp {
  /// Python selector, for example `__eq__`.
  static var selector: IdString { get }
  /// Call compare from PyObject.__
  static var baseCompare: (Py, PyObject, PyObject) -> CompareResult { get }
  /// Reflected compare operation, for example 'less' -> 'greater'.
  associatedtype reflected: CompareOp
  /// Fast path: we know the method at compile time
  static func callStatic(_ py: Py, left: PyObject, right: PyObject) -> StaticCallResult
}

extension CompareOp {

  /// PyObject *
  /// PyObject_RichCompare(PyObject *v, PyObject *w, int op)
  fileprivate static func compare(_ py: Py, left: PyObject, right: PyObject) -> PyResult {
    var checkedReflected = false

    // Check if right is subtype of left, if so then use right.
    if left.type !== right.type && right.type.isSubtype(of: left.type) {
      checkedReflected = true

      switch reflected.callCompare(py, left: right, right: left) {
      case .value(let result):
        if py.cast.isNotImplemented(result) {
          break // try other options
        }
        return .value(result)
      case .error(let e):
        return .error(e)
      }
    }

    // Try left compare (default path)
    switch self.callCompare(py, left: left, right: right) {
    case .value(let result):
      if py.cast.isNotImplemented(result) {
        break // try other options
      }
      return .value(result)
    case .error(let e):
      return .error(e)
    }

    // Try reflected on right
    if !checkedReflected {
      switch reflected.callCompare(py, left: right, right: left) {
      case .value(let result):
        if py.cast.isNotImplemented(result) {
          break // try other options
        }
        return .value(result)
      case .error(let e):
        return .error(e)
      }
    }

    // No hope left! We are doomed!
    return .notImplemented(py)
  }

  private static func callCompare(_ py: Py, left: PyObject, right: PyObject) -> PyResult {
    // Fast path: we know the method at compile time
    switch self.callStatic(py, left: left, right: right) {
    case .value(let bool):
      let result = py.newBool(bool)
      return .value(result.asObject)
    case .error(let e):
      return .error(e)
    case .notImplemented:
      return .notImplemented(py)
    case .unavailable:
      break // Try other options…
    }

    // Try standard Python dispatch
    switch py.callMethod(object: left, selector: self.selector, arg: right) {
    case .value(let result):
      return .value(result)
    case .missingMethod:
      break // Try other options…
    case .error(let e),
         .notCallable(let e):
      return .error(e)
    }

    // Use base object implementation
    // (all objects derive from Object to this is probably a dead code)
    switch self.baseCompare(py, left, right) {
    case .value(let bool):
      let result = py.newBool(bool)
      return .value(result.asObject)
    case .notImplemented:
      return .notImplemented(py)
    case .invalidSelfArgument:
      trap("Compare inside 'PyObject' should accept all objects?")
    case .error(let e):
      return .error(e)
    }
  }
}

// MARK: - Equal

private enum EqualCompare: CompareOp {

  fileprivate typealias reflected = EqualCompare

  fileprivate static let selector = IdString.__eq__
  fileprivate static let baseCompare = PyObject.__eq__(_:zelf:other:)

  fileprivate static func callStatic(_ py: Py,
                                     left: PyObject,
                                     right: PyObject) -> StaticCallResult {
    let result = PyStaticCall.__eq__(py, left: left, right: right)
    return StaticCallResult(py, value: result)
  }
}

extension Py {

  public func isEqual(left: PyObject, right: PyObject) -> PyResult {
    // Quick result when objects are the same.
    // Guarantees that identity implies equality.
    if left.ptr === right.ptr {
      return PyResult(self.true)
    }

    switch EqualCompare.compare(self, left: left, right: right) {
    case .value(let result):
      if self.cast.isNotImplemented(result) {
        return PyResult(self.false)
      }

      return .value(result)

    case .error(let e):
      return .error(e)
    }
  }

  /// `self.isEqual` + `self.asBool`
  public func isEqualBool(left: PyObject, right: PyObject) -> PyResultGen<Bool> {
    let result = self.isEqual(left: left, right: right)
    return self.asBool(result)
  }
}

// MARK: - Not Equal

private enum NotEqualCompare: CompareOp {

  fileprivate typealias reflected = NotEqualCompare

  fileprivate static let selector = IdString.__ne__
  fileprivate static let baseCompare = PyObject.__ne__(_:zelf:other:)

  fileprivate static func callStatic(_ py: Py,
                                     left: PyObject,
                                     right: PyObject) -> StaticCallResult {
    let result = PyStaticCall.__ne__(py, left: left, right: right)
    return StaticCallResult(py, value: result)
  }
}

extension Py {

  public func isNotEqual(left: PyObject, right: PyObject) -> PyResult {
    // Quick result when objects are the same.
    if left.ptr === right.ptr {
      return PyResult(self.false)
    }

    switch NotEqualCompare.compare(self, left: left, right: right) {
    case .value(let result):
      if self.cast.isNotImplemented(result) {
        return PyResult(self.true)
      }

      return .value(result)

    case .error(let e):
      return .error(e)
    }
  }

  public func isNotEqualBool(left: PyObject, right: PyObject) -> PyResultGen<Bool> {
    return self.asBool(self.isNotEqual(left: left, right: right))
  }
}

// MARK: - Less

private enum LessCompare: CompareOp {

  fileprivate typealias reflected = GreaterCompare

  fileprivate static let selector = IdString.__lt__
  fileprivate static let baseCompare = PyObject.__lt__(_:zelf:other:)

  fileprivate static func callStatic(_ py: Py,
                                     left: PyObject,
                                     right: PyObject) -> StaticCallResult {
    let result = PyStaticCall.__lt__(py, left: left, right: right)
    return StaticCallResult(py, value: result)
  }
}

extension Py {

  public func isLess(left: PyObject, right: PyObject) -> PyResult {
    switch LessCompare.compare(self, left: left, right: right) {
    case .value(let result):
      if self.cast.isNotImplemented(result) {
        return self.notSupported("<", left: left, right: right)
      }
      return .value(result)

    case .error(let e):
      return .error(e)
    }
  }

  public func isLessBool(left: PyObject, right: PyObject) -> PyResultGen<Bool> {
    return self.asBool(self.isLess(left: left, right: right))
  }
}

// MARK: - Less equal

private enum LessEqualCompare: CompareOp {

  fileprivate typealias reflected = GreaterEqualCompare

  fileprivate static let selector = IdString.__le__
  fileprivate static let baseCompare = PyObject.__le__(_:zelf:other:)

  fileprivate static func callStatic(_ py: Py,
                                     left: PyObject,
                                     right: PyObject) -> StaticCallResult {
    let result = PyStaticCall.__le__(py, left: left, right: right)
    return StaticCallResult(py, value: result)
  }
}

extension Py {

  public func isLessEqual(left: PyObject, right: PyObject) -> PyResult {
    switch LessEqualCompare.compare(self, left: left, right: right) {
    case .value(let result):
      if self.cast.isNotImplemented(result) {
        return self.notSupported("<=", left: left, right: right)
      }
      return .value(result)

    case .error(let e):
      return .error(e)
    }
  }

  public func isLessEqualBool(left: PyObject, right: PyObject) -> PyResultGen<Bool> {
    return self.asBool(self.isLessEqual(left: left, right: right))
  }
}

// MARK: - Greater

private enum GreaterCompare: CompareOp {

  fileprivate typealias reflected = LessCompare

  fileprivate static let selector = IdString.__gt__
  fileprivate static let baseCompare = PyObject.__gt__(_:zelf:other:)

  fileprivate static func callStatic(_ py: Py,
                                     left: PyObject,
                                     right: PyObject) -> StaticCallResult {
    let result = PyStaticCall.__gt__(py, left: left, right: right)
    return StaticCallResult(py, value: result)
  }
}

extension Py {

  public func isGreater(left: PyObject, right: PyObject) -> PyResult {
    switch GreaterCompare.compare(self, left: left, right: right) {
    case .value(let result):
      if self.cast.isNotImplemented(result) {
        return self.notSupported(">", left: left, right: right)
      }
      return .value(result)

    case .error(let e):
      return .error(e)
    }
  }

  public func isGreaterBool(left: PyObject, right: PyObject) -> PyResultGen<Bool> {
    return self.asBool(self.isGreater(left: left, right: right))
  }
}

// MARK: - Greater equal

private enum GreaterEqualCompare: CompareOp {

  fileprivate typealias reflected = LessEqualCompare

  fileprivate static let selector = IdString.__ge__
  fileprivate static let baseCompare = PyObject.__ge__(_:zelf:other:)

  fileprivate static func callStatic(_ py: Py,
                                     left: PyObject,
                                     right: PyObject) -> StaticCallResult {
    let result = PyStaticCall.__ge__(py, left: left, right: right)
    return StaticCallResult(py, value: result)
  }
}

extension Py {

  public func isGreaterEqual(left: PyObject, right: PyObject) -> PyResult {
    switch GreaterEqualCompare.compare(self, left: left, right: right) {
    case .value(let result):
      if self.cast.isNotImplemented(result) {
        return self.notSupported(">=", left: left, right: right)
      }
      return .value(result)

    case .error(let e):
      return .error(e)
    }
  }

  public func isGreaterEqualBool(left: PyObject, right: PyObject) -> PyResultGen<Bool> {
    return self.asBool(self.isGreaterEqual(left: left, right: right))
  }
}

// MARK: - Helpers

extension Py {

  private func notSupported(_ op: String,
                            left: PyObject,
                            right: PyObject) -> PyResult {
    let l = left.typeName
    let r = right.typeName
    let message = "'\(op)' not supported between instances of '\(l)' and '\(r)'"
    return .typeError(self, message: message)
  }

  private func asBool(_ result: PyResult) -> PyResultGen<Bool> {
    // Try this:
    //
    // >>> class C():
    // ...     def __eq__(self, other):
    // ...             if isinstance(other, str):
    // ...                     return False
    // ...             else:
    // ...                     return 'Elsa' <- or any other 'True' nonsense
    // ...
    // >>> c = C()
    // >>> [c] == [''] <-  compare with 'str' returns False
    // False
    // >>> [c] == [1] <- element compare returns 'Elsa' which is True
    // True
    return result.flatMap(self.isTrueBool)
  }
}
