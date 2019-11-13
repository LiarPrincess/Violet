// In CPython:
// Python -> builtinmodule.c
// https://docs.python.org/3/library/functions.html

// swiftlint:disable type_name
// swiftlint:disable file_length

// MARK: - Template

private enum CompareResult {
  case value(PyObject)
  case notImplemented
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
  /// Python selector, for example '__eq__'.
  static var selector: String { get }
  /// Reverse compare operation, for example 'equal' -> 'not equal'.
  /// Lazy, otherwise we would get infinite mutual recursion.
  associatedtype reverse: CompareOp
  /// Call compare with fast protocol dispatch
  static func callFastCompare(left: PyObject,
                              right: PyObject) -> PyResultOrNot<Bool>
  /// Call compare from PyBaseObject
  static func callObjectCompare(left: PyObject,
                                right: PyObject) -> PyResultOrNot<Bool>
}

extension CompareOp {

  /// PyObject *
  /// PyObject_RichCompare(PyObject *v, PyObject *w, int op)
  fileprivate static func compare(left: PyObject,
                                  right: PyObject) -> CompareResult {
    var checkedReverse = false

    // Check if right is subtype of left, if so then use right.
    if left.type !== right.type && right.type.isSubtype(of: left.type) {
      checkedReverse = true

      let result = reverse.callCompare(left: right, right: left)
      if case CompareResult.value = result {
        return result
      }
    }

    // Try left compare (default path)
    let result = callCompare(left: left, right: right)
    if case CompareResult.value = result {
      return result
    }

    // Try reverse on right
    if !checkedReverse {
      let result = reverse.callCompare(left: right, right: left)
      if case CompareResult.value = result {
        return result
      }
    }

    // Not hope left! We are doomed!
    return .notImplemented
  }

  private static func callCompare(left: PyObject,
                                  right: PyObject) -> CompareResult {
    let context = left.context

    // Try fast protocol-based dispach
    let fastResult = callFastCompare(left: left, right: right)
    let fastResultAsCompareResult = toCompareResult(fastResult, in: context)

    if case CompareResult.value = fastResultAsCompareResult {
      return fastResultAsCompareResult
    }

    // Try standard Python dispatch
    let pythonResult = left.builtins.callMethod(on: left,
                                                selector: selector,
                                                arg: right)

    if case let CallResult.value(result) = pythonResult {
      return result is PyNotImplemented ? .notImplemented : .value(result)
    }

    // Use base object implementation
    // (all objects derieve from Object to this is probably a dead code)
    let baseResult = callObjectCompare(left: left, right: right)
    return toCompareResult(baseResult, in: context)
  }

  private static func toCompareResult(_ result: PyResultOrNot<Bool>,
                                      in context: PyContext) -> CompareResult {
    switch result {
    case let .value(result):
      return .value(result ? context.builtins.true : context.builtins.false)
    case .notImplemented:
      return .notImplemented
    case let .error(e):
      return .value(e.toPyObject(in: context))
    }
  }
}

// MARK: - Implementations

private enum EqualCompare: CompareOp {

  typealias reverse = NotEqualCompare
  fileprivate static let selector = "__eq__"

  fileprivate static func callFastCompare(left: PyObject,
                                          right: PyObject) -> PyResultOrNot<Bool> {
    if let left = left as? __eq__Owner {
      return left.isEqual(right)
    }
    return .notImplemented
  }

  fileprivate static func callObjectCompare(left: PyObject,
                                            right: PyObject) -> PyResultOrNot<Bool> {
    return PyBaseObject.isEqual(zelf: left, other: right)
  }
}

private enum NotEqualCompare: CompareOp {

  typealias reverse = EqualCompare
  fileprivate static let selector = "__ne__"

  fileprivate static func callFastCompare(left: PyObject,
                                          right: PyObject) -> PyResultOrNot<Bool> {
    if let left = left as? __ne__Owner {
      return left.isNotEqual(right)
    }
    return .notImplemented
  }

  fileprivate static func callObjectCompare(left: PyObject,
                                            right: PyObject) -> PyResultOrNot<Bool> {
    return PyBaseObject.isNotEqual(zelf: left, other: right)
  }
}

private enum LessCompare: CompareOp {

  typealias reverse = GreaterEqualCompare
  fileprivate static let selector = "__lt__"

  fileprivate static func callFastCompare(left: PyObject,
                                          right: PyObject) -> PyResultOrNot<Bool> {
    if let left = left as? __lt__Owner {
      return left.isLess(right)
    }
    return .notImplemented
  }

  fileprivate static func callObjectCompare(left: PyObject,
                                            right: PyObject) -> PyResultOrNot<Bool> {
    return PyBaseObject.isLess(zelf: left, other: right)
  }
}

private enum LessEqualCompare: CompareOp {

  typealias reverse = GreaterCompare
  fileprivate static let selector = "__le__"

  fileprivate static func callFastCompare(left: PyObject,
                                          right: PyObject) -> PyResultOrNot<Bool> {
    if let left = left as? __le__Owner {
      return left.isLessEqual(right)
    }
    return .notImplemented
  }

  fileprivate static func callObjectCompare(left: PyObject,
                                            right: PyObject) -> PyResultOrNot<Bool> {
    return PyBaseObject.isLessEqual(zelf: left, other: right)
  }
}

private enum GreaterCompare: CompareOp {

  typealias reverse = LessEqualCompare
  fileprivate static let selector = "__gt__"

  fileprivate static func callFastCompare(left: PyObject,
                                          right: PyObject) -> PyResultOrNot<Bool> {
    if let left = left as? __gt__Owner {
      return left.isGreater(right)
    }
    return .notImplemented
  }

  fileprivate static func callObjectCompare(left: PyObject,
                                            right: PyObject) -> PyResultOrNot<Bool> {
    return PyBaseObject.isGreater(zelf: left, other: right)
  }
}

private enum GreaterEqualCompare: CompareOp {

  typealias reverse = LessCompare
  fileprivate static let selector = "__ge__"

  fileprivate static func callFastCompare(left: PyObject,
                                          right: PyObject) -> PyResultOrNot<Bool> {
    if let left = left as? __ge__Owner {
      return left.isGreaterEqual(right)
    }
    return .notImplemented
  }

  fileprivate static func callObjectCompare(left: PyObject,
                                            right: PyObject) -> PyResultOrNot<Bool> {
    return PyBaseObject.isGreaterEqual(zelf: left, other: right)
  }
}

// MARK: - Builtins

extension Builtins {

  public func isEqual(left: PyObject, right: PyObject) -> PyObject {
    switch EqualCompare.compare(left: left, right: right) {
    case .value(let result):
      return result
    case .notImplemented:
      return left === right ? self.true : self.false
    }
  }

  public func isNotEqual(left: PyObject, right: PyObject) -> PyObject {
    switch NotEqualCompare.compare(left: left, right: right) {
    case .value(let result):
      return result
    case .notImplemented:
      return left !== right ? self.true : self.false
    }
  }

  public func isLess(left: PyObject, right: PyObject) -> PyObject {
    switch LessCompare.compare(left: left, right: right) {
    case .value(let result):
      return result
    case .notImplemented:
      return self.notSupported("<", left: left, right: right)
    }
  }

  public func isLessEqual(left: PyObject, right: PyObject) -> PyObject {
    switch LessEqualCompare.compare(left: left, right: right) {
    case .value(let result):
      return result
    case .notImplemented:
      return self.notSupported("<=", left: left, right: right)
    }
  }

  public func isGreater(left: PyObject, right: PyObject) -> PyObject {
    switch GreaterCompare.compare(left: left, right: right) {
    case .value(let result):
      return result
    case .notImplemented:
      return self.notSupported(">", left: left, right: right)
    }
  }

  public func isGreaterEqual(left: PyObject, right: PyObject) -> PyObject {
    switch GreaterEqualCompare.compare(left: left, right: right) {
    case .value(let result):
      return result
    case .notImplemented:
      return self.notSupported(">=", left: left, right: right)
    }
  }

  // MARK: - Bool

  public func isEqualBool(left: PyObject, right: PyObject) -> Bool {
    return self.compareResultAsBool(self.isEqual(left: left, right: right))
  }

  public func isNotEqualBool(left: PyObject, right: PyObject) -> Bool {
    return self.compareResultAsBool(self.isNotEqual(left: left, right: right))
  }

  public func isLessBool(left: PyObject, right: PyObject) -> Bool {
    return self.compareResultAsBool(self.isLess(left: left, right: right))
  }

  public func isLessEqualBool(left: PyObject, right: PyObject) -> Bool {
    return self.compareResultAsBool(self.isLessEqual(left: left, right: right))
  }

  public func isGreaterBool(left: PyObject, right: PyObject) -> Bool {
    return self.compareResultAsBool(self.isGreater(left: left, right: right))
  }

  public func isGreaterEqualBool(left: PyObject, right: PyObject) -> Bool {
    return self.compareResultAsBool(self.isGreaterEqual(left: left, right: right))
  }

  // MARK: - Helpers

  private func notSupported(_ op: String,
                            left: PyObject,
                            right: PyObject) -> PyObject {
    let l = left.typeName
    let r = right.typeName
    let msg = "'\(op)' not supported between instances of '\(l)' and '\(r)'"
    let error = PyErrorEnum.typeError(msg)
    return error.toPyObject(in: self.context)
  }

  private func compareResultAsBool(_ result: PyObject) -> Bool {
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
    return self.isTrueBool(result)
  }
}
