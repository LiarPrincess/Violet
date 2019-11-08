// In CPython:
// Python -> builtinmodule.c
// https://docs.python.org/3/library/functions.html

/// Comparison type.
/// In the future it may be better to rewite this as a protocol
/// (for static dispatch instead of thousands of switches).
private enum CompareMode {
  case equal
  case notEqual
  case less
  case lessEqual
  case greater
  case greaterEqual

  fileprivate var op: String {
    switch self {
    case .equal:    return "=="
    case .notEqual: return "!="
    case .less:      return "<"
    case .lessEqual: return "<="
    case .greater:      return ">"
    case .greaterEqual: return ">="
    }
  }

  fileprivate var selector: String {
    switch self {
    case .equal:    return "__eq__"
    case .notEqual: return "__ne__"
    case .less:      return "__lt__"
    case .lessEqual: return "__le__"
    case .greater:      return "__gt__"
    case .greaterEqual: return "__ge__"
    }
  }

  fileprivate var reverse: CompareMode {
    switch self {
    case .equal:    return .notEqual
    case .notEqual: return .equal
    case .less:      return .greaterEqual
    case .lessEqual: return .greater
    case .greater:      return .lessEqual
    case .greaterEqual: return .less
    }
  }
}

private enum CompareResult {
  case value(PyObject)
  case notImplemented
}

extension Builtins {

  public func isEqual(left: PyObject, right: PyObject) -> PyObject {
    switch self.compare(left: left, right: right, mode: .equal) {
    case .value(let result):
      return result
    case .notImplemented:
      return left === right ? self.true : self.false
    }
  }

  public func isNotEqual(left: PyObject, right: PyObject) -> PyObject {
    switch self.compare(left: left, right: right, mode: .equal) {
    case .value(let result):
      return result
    case .notImplemented:
      return left !== right ? self.true : self.false
    }
  }

  public func isLess(left: PyObject, right: PyObject) -> PyObject {
    return self.lessGreaterCompare(left: left, right: right, mode: .less)
  }

  public func isLessEqual(left: PyObject, right: PyObject) -> PyObject {
    return self.lessGreaterCompare(left: left, right: right, mode: .lessEqual)
  }

  public func isGreater(left: PyObject, right: PyObject) -> PyObject {
    return self.lessGreaterCompare(left: left, right: right, mode: .greater)
  }

  public func isGreaterEqual(left: PyObject, right: PyObject) -> PyObject {
    return self.lessGreaterCompare(left: left, right: right, mode: .greaterEqual)
  }

  private func lessGreaterCompare(left: PyObject,
                                  right: PyObject,
                                  mode: CompareMode) -> PyObject {
    switch self.compare(left: left, right: right, mode: mode) {
    case .value(let result):
      return result
    case .notImplemented:
      let op = mode.op
      let lt = left.typeName
      let rt = right.typeName
      let msg = "'\(op)' not supported between instances of '\(lt)' and '\(rt)'"
      let error = PyErrorEnum.typeError(msg)
      return error.toPyObject(in: self.context)
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

  // MARK: - Actual implementation

  /// PyObject *
  /// PyObject_RichCompare(PyObject *v, PyObject *w, int op)
  private func compare(left: PyObject,
                       right: PyObject,
                       mode: CompareMode) -> CompareResult {
    var checkedReverse = false

    // Check if right is subtype of left, if so then use right.
    if left.type !== right.type && right.type.isSubtype(of: left.type) {
      checkedReverse = true

      let result = self.callCompare(left: right, right: left, mode: mode.reverse)
      if case CompareResult.value = result {
        return result
      }
    }

    // Try left compare (default path)
    let result = self.callCompare(left: left, right: right, mode: mode)
    if case CompareResult.value = result {
      return result
    }

    // Try reverse on right
    if !checkedReverse {
      let result = self.callCompare(left: right, right: left, mode: mode.reverse)
      if case CompareResult.value = result {
        return result
      }
    }

    // Not hope left! We are doomed!
    return .notImplemented
  }

  private func callCompare(left: PyObject,
                           right: PyObject,
                           mode: CompareMode) -> CompareResult {
    // Try fast protocol-based dispach
    let fastResult = self.callFastCompare(left: left, right: right, mode: mode)
    let fastResultAsCompareResult = self.toCompareResult(fastResult)

    if case CompareResult.value = fastResultAsCompareResult {
      return fastResultAsCompareResult
    }

    // Try standard Python dispatch
    let selector = mode.selector
    let pythonResult = self.callMethod(on: left, selector: selector, args: [right])

    if case let CallResult.value(result) = pythonResult {
      return result is PyNotImplemented ? .notImplemented : .value(result)
    }

    // Use base object implementation
    // (all objects derieve from Object to this is probably a dead code)
    let baseResult = self.callObjectCompare(left: left, right: right, mode: mode)
    return self.toCompareResult(baseResult)
  }

  /// Call compare with fast protocol dispatch
  private func callFastCompare(left: PyObject,
                               right: PyObject,
                               mode: CompareMode) -> PyResultOrNot<Bool> {
    switch mode {
    case .equal:
      if let left = left as? __eq__Owner {
        return left.isEqual(right)
      }
    case .notEqual:
      if let left = left as? __ne__Owner {
        return left.isNotEqual(right)
      }
    case .less:
      if let left = left as? __lt__Owner {
        return left.isLess(right)
      }
    case .lessEqual:
      if let left = left as? __le__Owner {
        return left.isLessEqual(right)
      }
    case .greater:
      if let left = left as? __gt__Owner {
        return left.isGreater(right)
      }
    case .greaterEqual:
      if let left = left as? __ge__Owner {
        return left.isGreaterEqual(right)
      }
    }

    return .notImplemented
  }

  /// Call compare from PyBaseObject
  private func callObjectCompare(left: PyObject,
                                 right: PyObject,
                                 mode: CompareMode) -> PyResultOrNot<Bool> {
    switch mode {
    case .equal:
      return PyBaseObject.isEqual(zelf: left, other: right)
    case .notEqual:
      return PyBaseObject.isNotEqual(zelf: left, other: right)
    case .less:
      return PyBaseObject.isLess(zelf: left, other: right)
    case .lessEqual:
      return PyBaseObject.isLessEqual(zelf: left, other: right)
    case .greater:
      return PyBaseObject.isGreater(zelf: left, other: right)
    case .greaterEqual:
      return PyBaseObject.isGreaterEqual(zelf: left, other: right)
    }
  }

  private func toCompareResult(_ result: PyResultOrNot<Bool>) -> CompareResult {
    switch result {
    case let .value(result):
      return .value(result ? self.true : self.false)
    case .notImplemented:
      return .notImplemented
    case let .error(e):
      return .value(e.toPyObject(in: self.context))
    }
  }
}
