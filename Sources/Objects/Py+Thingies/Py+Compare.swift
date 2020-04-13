// In CPython:
// Python -> builtinmodule.c
// https://docs.python.org/3/library/functions.html

// swiftlint:disable type_name
// swiftlint:disable file_length

// MARK: - Abstract

private enum FastCallResult {
  case value(Bool)
  case error(PyBaseException)
  case notImplemented
  /// Fast call is not available
  case unavailable

  fileprivate init(_ value: CompareResult) {
    switch value {
    case .value(let o):
      self = .value(o)
    case .error(let e):
      self = .error(e)
    case .notImplemented:
      self = .notImplemented
    }
  }
}

/// Basically a template for compare operations.
/// This may not be the cleanest/most idiomatic Swift, but it gets the job done.
/// Alternatives:
/// - function with CompareMode enum (equal, left etc...) argument and then
///   switch on it. But then our performance heavly depends on Swift compiler,
///   (can it inline this and then eliminate dead code?) otherwise we pay
///   for each switch.
/// - C#-style abstract class with `final` subclass for every compare operation.
///   In **best** case compiler will (maybe) skip vtable (because of `final`),
///   so we would get static dispatch. But this type of programming
///   (abstract classes) is truly non-idiomatic in Swift.
///
/// Or we could use templates.
private protocol CompareOp {
  /// Python selector, for example `__eq__`.
  static var selector: IdString { get }
  /// Call compare from PyObjectType.
  static var baseCompare: (PyObject, PyObject) -> CompareResult { get }
  /// Reflected compare operation, for example 'less' -> 'greater'.
  associatedtype reflected: CompareOp
  /// Call compare with fast protocol dispatch.
  static func callFastCompare(left: PyObject, right: PyObject) -> FastCallResult
}

extension CompareOp {

  /// PyObject *
  /// PyObject_RichCompare(PyObject *v, PyObject *w, int op)
  fileprivate static func compare(left: PyObject,
                                  right: PyObject) -> PyResult<PyObject> {
    var checkedReflected = false

    // Check if right is subtype of left, if so then use right.
    if left.type !== right.type && right.type.isSubtype(of: left.type) {
      checkedReflected = true

      switch reflected.callCompare(left: right, right: left) {
      case .value(let result):
        if result.isNotImplemented {
          break // try other options
        }
        return .value(result)
      case .error(let e):
        return .error(e)
      }
    }

    // Try left compare (default path)
    switch callCompare(left: left, right: right) {
    case .value(let result):
      if result.isNotImplemented {
        break // try other options
      }
      return .value(result)
    case .error(let e):
      return .error(e)
    }

    // Try reflected on right
    if !checkedReflected {
      switch reflected.callCompare(left: right, right: left) {
      case .value(let result):
        if result.isNotImplemented {
          break // try other options
        }
        return .value(result)
      case .error(let e):
        return .error(e)
      }
    }

    // No hope left! We are doomed!
    return .value(Py.notImplemented)
  }

  private static func callCompare(left: PyObject,
                                  right: PyObject) -> PyResult<PyObject> {
    // Try fast protocol-based dispach
    switch callFastCompare(left: left, right: right) {
    case .value(let bool): return .value(Py.newBool(bool))
    case .error(let e): return .error(e)
    case .notImplemented: return .value(Py.notImplemented)
    case .unavailable: break // Try other options...
    }

    // Try standard Python dispatch
    switch Py.callMethod(object: left, selector: selector, arg: right) {
    case .value(let result):
      return .value(result)
    case .missingMethod:
      break // Try other options...
    case .error(let e), .notCallable(let e):
      return .error(e)
    }

    // Use base object implementation
    // (all objects derieve from Object to this is probably a dead code)
    switch baseCompare(left, right) {
    case .value(let bool): return .value(Py.newBool(bool))
    case .error(let e): return .error(e)
    case .notImplemented: return .value(Py.notImplemented)
    }
  }
}

// MARK: - Equal

private enum EqualCompare: CompareOp {

  typealias reflected = EqualCompare
  fileprivate static let selector = IdString.__eq__
  fileprivate static let baseCompare = PyObjectType.isEqual

  fileprivate static func callFastCompare(left: PyObject,
                                          right: PyObject) -> FastCallResult {
    if let left = left as? __eq__Owner {
      return FastCallResult(left.isEqual(right))
    }
    return .unavailable
  }
}

extension PyInstance {

  public func isEqual(left: PyObject, right: PyObject) -> PyResult<PyObject> {
    // Quick result when objects are the same.
    // Guarantees that identity implies equality.
    if  left === right {
      return .value(Py.true)
    }

    switch EqualCompare.compare(left: left, right: right) {
    case .value(let result):
      if result.isNotImplemented {
        return .value(self.newBool(left === right)) // always false
      }
      return .value(result)

    case .error(let e):
      return  .error(e)
    }
  }

  public func isEqualBool(left: PyObject, right: PyObject) -> PyResult<Bool> {
    return self.asBool(self.isEqual(left: left, right: right))
  }
}

  // MARK: - Not Equal

private enum NotEqualCompare: CompareOp {

  typealias reflected = NotEqualCompare
  fileprivate static let selector = IdString.__ne__
  fileprivate static let baseCompare = PyObjectType.isNotEqual

  fileprivate static func callFastCompare(left: PyObject,
                                          right: PyObject) -> FastCallResult {
    if let left = left as? __ne__Owner {
      return FastCallResult(left.isNotEqual(right))
    }
    return .unavailable
  }
}

extension PyInstance {

  public func isNotEqual(left: PyObject, right: PyObject) -> PyResult<PyObject> {
    // Quick result when objects are the same.
    if left === right {
      return .value(Py.false)
    }

    switch NotEqualCompare.compare(left: left, right: right) {
    case .value(let result):
      if result.isNotImplemented {
        return .value(Py.newBool(left !== right))
      }
      return .value(result)

    case .error(let e):
      return  .error(e)
    }
  }

  public func isNotEqualBool(left: PyObject, right: PyObject) -> PyResult<Bool> {
    return self.asBool(self.isNotEqual(left: left, right: right))
  }
}

// MARK: - Less

private enum LessCompare: CompareOp {

  typealias reflected = GreaterCompare
  fileprivate static let selector = IdString.__lt__
  fileprivate static let baseCompare = PyObjectType.isLess

  fileprivate static func callFastCompare(left: PyObject,
                                          right: PyObject) -> FastCallResult {
    if let left = left as? __lt__Owner {
      return FastCallResult(left.isLess(right))
    }
    return .unavailable
  }
}

extension PyInstance {

  public func isLess(left: PyObject, right: PyObject) -> PyResult<PyObject> {
    switch LessCompare.compare(left: left, right: right) {
    case .value(let result):
      if result.isNotImplemented {
        return self.notSupported("<", left: left, right: right)
      }
      return .value(result)

    case .error(let e):
      return  .error(e)
    }
  }

  public func isLessBool(left: PyObject, right: PyObject) -> PyResult<Bool> {
    return self.asBool(self.isLess(left: left, right: right))
  }
}

// MARK: - Less equal

private enum LessEqualCompare: CompareOp {

  typealias reflected = GreaterEqualCompare
  fileprivate static let selector = IdString.__le__
  fileprivate static let baseCompare = PyObjectType.isLessEqual

  fileprivate static func callFastCompare(left: PyObject,
                                          right: PyObject) -> FastCallResult {
    if let left = left as? __le__Owner {
      return FastCallResult(left.isLessEqual(right))
    }
    return .unavailable
  }
}

extension PyInstance {

  public func isLessEqual(left: PyObject, right: PyObject) -> PyResult<PyObject> {
    switch LessEqualCompare.compare(left: left, right: right) {
    case .value(let result):
      if result.isNotImplemented {
        return self.notSupported("<=", left: left, right: right)
      }
      return .value(result)

    case .error(let e):
      return  .error(e)
    }
  }

  public func isLessEqualBool(left: PyObject, right: PyObject) -> PyResult<Bool> {
    return self.asBool(self.isLessEqual(left: left, right: right))
  }
}

  // MARK: - Greater

private enum GreaterCompare: CompareOp {

  typealias reflected = LessCompare
  fileprivate static let selector = IdString.__gt__
  fileprivate static let baseCompare = PyObjectType.isGreater

  fileprivate static func callFastCompare(left: PyObject,
                                          right: PyObject) -> FastCallResult {
    if let left = left as? __gt__Owner {
      return FastCallResult(left.isGreater(right))
    }
    return .unavailable
  }
}

extension PyInstance {

  public func isGreater(left: PyObject, right: PyObject) -> PyResult<PyObject> {
    switch GreaterCompare.compare(left: left, right: right) {
    case .value(let result):
      if result.isNotImplemented {
        return self.notSupported(">", left: left, right: right)
      }
      return .value(result)

    case .error(let e):
      return  .error(e)
    }
  }

  public func isGreaterBool(left: PyObject, right: PyObject) -> PyResult<Bool> {
    return self.asBool(self.isGreater(left: left, right: right))
  }
}

// MARK: - Greater equal

private enum GreaterEqualCompare: CompareOp {

  typealias reflected = LessEqualCompare
  fileprivate static let selector = IdString.__ge__
  fileprivate static let baseCompare = PyObjectType.isGreaterEqual

  fileprivate static func callFastCompare(left: PyObject,
                                          right: PyObject) -> FastCallResult {
    if let left = left as? __ge__Owner {
      return FastCallResult(left.isGreaterEqual(right))
    }
    return .unavailable
  }
}

extension PyInstance {

  public func isGreaterEqual(left: PyObject, right: PyObject) -> PyResult<PyObject> {
    switch GreaterEqualCompare.compare(left: left, right: right) {
    case .value(let result):
      if result.isNotImplemented {
        return self.notSupported(">=", left: left, right: right)
      }
      return .value(result)

    case .error(let e):
      return  .error(e)
    }
  }

  public func isGreaterEqualBool(left: PyObject, right: PyObject) -> PyResult<Bool> {
    return self.asBool(self.isGreaterEqual(left: left, right: right))
  }
}

// MARK: - Helpers

extension PyInstance {

  private func notSupported(_ op: String,
                            left: PyObject,
                            right: PyObject) -> PyResult<PyObject> {
    let l = left.typeName
    let r = right.typeName
    let msg = "'\(op)' not supported between instances of '\(l)' and '\(r)'"
    return .typeError(msg)
  }

  private func asBool(_ result: PyResult<PyObject>) -> PyResult<Bool> {
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
