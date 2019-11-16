// In CPython:
// Python -> builtinmodule.c
// https://docs.python.org/3/library/functions.html

// swiftlint:disable nesting
// swiftlint:disable type_name
// swiftlint:disable file_length

// MARK: - Abstract

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
  static var selector: String { get }
  /// Call compare from PyBaseObject.
  static var baseCompare: (PyObject, PyObject) -> PyResultOrNot<Bool> { get }
  /// Reverse compare operation, for example 'equal' -> 'not equal'.
  /// Lazy, otherwise we would get infinite mutual recursion.
  associatedtype reverse: CompareOp
  /// Call compare with fast protocol dispatch.
  static func callFastCompare(left: PyObject,
                              right: PyObject) -> PyResultOrNot<Bool>
}

extension CompareOp {

  /// PyObject *
  /// PyObject_RichCompare(PyObject *v, PyObject *w, int op)
  fileprivate static func compare(left: PyObject,
                                  right: PyObject) -> PyResultOrNot<PyObject> {
    var checkedReverse = false

    // Check if right is subtype of left, if so then use right.
    if left.type !== right.type && right.type.isSubtype(of: left.type) {
      checkedReverse = true

      switch reverse.callCompare(left: right, right: left) {
      case .value(let result): return .value(result)
      case .error(let e): return .error(e)
      case .notImplemented: break
      }
    }

    // Try left compare (default path)
    switch callCompare(left: left, right: right) {
    case .value(let result): return .value(result)
    case .error(let e): return .error(e)
    case .notImplemented: break
    }

    // Try reverse on right
    if !checkedReverse {
      switch reverse.callCompare(left: right, right: left) {
      case .value(let result): return .value(result)
      case .error(let e): return .error(e)
      case .notImplemented: break
      }
    }

    // No hope left! We are doomed!
    return .notImplemented
  }

  private static func callCompare(left: PyObject,
                                  right: PyObject) -> PyResultOrNot<PyObject> {
    let context = left.context
    let builtins = context.builtins

    // Try fast protocol-based dispach
    switch callFastCompare(left: left, right: right) {
    case .value(let result): return .value(builtins.newBool(result))
    case .notImplemented: break // Try other options...
    case .error(let e): return .error(e)
    }

    // Try standard Python dispatch
    let pythonResult = builtins.callMethod(on: left,
                                           selector: selector,
                                           arg: right)

    switch pythonResult {
    case .value(let result):
      return result is PyNotImplemented ? .notImplemented : .value(result)
    case .noSuchMethod:
      break // Try other options...
    case .methodIsNotCallable(let e):
      return .error(e)
    }

    // Use base object implementation
    // (all objects derieve from Object to this is probably a dead code)
    return baseCompare(left, right).map { $0 ? builtins.true : builtins.false }
  }
}

// MARK: - Builtins

extension Builtins {

  // MARK: - Equal

  private enum EqualCompare: CompareOp {

    typealias reverse = NotEqualCompare
    fileprivate static let selector = "__eq__"
    fileprivate static let baseCompare = PyBaseObject.isEqual

    fileprivate static func callFastCompare(left: PyObject,
                                            right: PyObject) -> PyResultOrNot<Bool> {
      if let left = left as? __eq__Owner {
        return left.isEqual(right)
      }
      return .notImplemented
    }
  }

  public func isEqual(left: PyObject, right: PyObject) -> PyResult<PyObject> {
    switch EqualCompare.compare(left: left, right: right) {
    case .value(let result):
      return .value(result)
    case .notImplemented:
      return .value(left === right ? self.true : self.false)
    case .error(let e):
      return  .error(e)
    }
  }

  public func isEqualBool(left: PyObject, right: PyObject) -> PyResult<Bool> {
    return self.compareResultAsBool(self.isEqual(left: left, right: right))
  }

  // MARK: - Not Equal

  private enum NotEqualCompare: CompareOp {

    typealias reverse = EqualCompare
    fileprivate static let selector = "__ne__"
    fileprivate static let baseCompare = PyBaseObject.isNotEqual

    fileprivate static func callFastCompare(left: PyObject,
                                            right: PyObject) -> PyResultOrNot<Bool> {
      if let left = left as? __ne__Owner {
        return left.isNotEqual(right)
      }
      return .notImplemented
    }
  }

  public func isNotEqual(left: PyObject, right: PyObject) -> PyResult<PyObject> {
    switch NotEqualCompare.compare(left: left, right: right) {
    case .value(let result):
      return .value(result)
    case .notImplemented:
      return .value(left !== right ? self.true : self.false)
    case .error(let e):
      return  .error(e)
    }
  }

  public func isNotEqualBool(left: PyObject, right: PyObject) -> PyResult<Bool> {
    return self.compareResultAsBool(self.isNotEqual(left: left, right: right))
  }

  // MARK: - Less

  private enum LessCompare: CompareOp {

    typealias reverse = GreaterEqualCompare
    fileprivate static let selector = "__lt__"
    fileprivate static let baseCompare = PyBaseObject.isLess

    fileprivate static func callFastCompare(left: PyObject,
                                            right: PyObject) -> PyResultOrNot<Bool> {
      if let left = left as? __lt__Owner {
        return left.isLess(right)
      }
      return .notImplemented
    }
  }

  public func isLess(left: PyObject, right: PyObject) -> PyResult<PyObject> {
    switch LessCompare.compare(left: left, right: right) {
    case .value(let result):
      return .value(result)
    case .notImplemented:
      return self.notSupported("<", left: left, right: right)
    case .error(let e):
      return  .error(e)
    }
  }

  public func isLessBool(left: PyObject, right: PyObject) -> PyResult<Bool> {
    return self.compareResultAsBool(self.isLess(left: left, right: right))
  }

  // MARK: - Less equal

  private enum LessEqualCompare: CompareOp {

    typealias reverse = GreaterCompare
    fileprivate static let selector = "__le__"
    fileprivate static let baseCompare = PyBaseObject.isLessEqual

    fileprivate static func callFastCompare(left: PyObject,
                                            right: PyObject) -> PyResultOrNot<Bool> {
      if let left = left as? __le__Owner {
        return left.isLessEqual(right)
      }
      return .notImplemented
    }
  }

  public func isLessEqual(left: PyObject, right: PyObject) -> PyResult<PyObject> {
    switch LessEqualCompare.compare(left: left, right: right) {
    case .value(let result):
      return .value(result)
    case .notImplemented:
      return self.notSupported("<=", left: left, right: right)
    case .error(let e):
      return  .error(e)
    }
  }

  public func isLessEqualBool(left: PyObject, right: PyObject) -> PyResult<Bool> {
    return self.compareResultAsBool(self.isLessEqual(left: left, right: right))
  }

  // MARK: - Greater

  private enum GreaterCompare: CompareOp {

    typealias reverse = LessEqualCompare
    fileprivate static let selector = "__gt__"
    fileprivate static let baseCompare = PyBaseObject.isGreater

    fileprivate static func callFastCompare(left: PyObject,
                                            right: PyObject) -> PyResultOrNot<Bool> {
      if let left = left as? __gt__Owner {
        return left.isGreater(right)
      }
      return .notImplemented
    }
  }

  public func isGreater(left: PyObject, right: PyObject) -> PyResult<PyObject> {
    switch GreaterCompare.compare(left: left, right: right) {
    case .value(let result):
      return .value(result)
    case .notImplemented:
      return self.notSupported(">", left: left, right: right)
    case .error(let e):
      return  .error(e)
    }
  }

  public func isGreaterBool(left: PyObject, right: PyObject) -> PyResult<Bool> {
    return self.compareResultAsBool(self.isGreater(left: left, right: right))
  }

  // MARK: - Greater equal

  private enum GreaterEqualCompare: CompareOp {

    typealias reverse = LessCompare
    fileprivate static let selector = "__ge__"
    fileprivate static let baseCompare = PyBaseObject.isGreaterEqual

    fileprivate static func callFastCompare(left: PyObject,
                                            right: PyObject) -> PyResultOrNot<Bool> {
      if let left = left as? __ge__Owner {
        return left.isGreaterEqual(right)
      }
      return .notImplemented
    }
  }

  public func isGreaterEqual(left: PyObject, right: PyObject) -> PyResult<PyObject> {
    switch GreaterEqualCompare.compare(left: left, right: right) {
    case .value(let result):
      return .value(result)
    case .notImplemented:
      return self.notSupported(">=", left: left, right: right)
    case .error(let e):
      return  .error(e)
    }
  }

  public func isGreaterEqualBool(left: PyObject, right: PyObject) -> PyResult<Bool> {
    return self.compareResultAsBool(self.isGreaterEqual(left: left, right: right))
  }

  // MARK: - Helpers

  private func notSupported(_ op: String,
                            left: PyObject,
                            right: PyObject) -> PyResult<PyObject> {
    let l = left.typeName
    let r = right.typeName
    return .typeError("'\(op)' not supported between instances of '\(l)' and '\(r)'")
  }

  private func compareResultAsBool(_ result: PyResult<PyObject>) -> PyResult<Bool> {
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
    switch result {
    case let .value(object):
      return .value(self.isTrueBool(object))
    case let .error(e):
      return .error(e)
    }
  }
}
