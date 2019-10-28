// In CPython:
// Python -> builtinmodule.c
// https://docs.python.org/3/library/functions.html

public enum CompareMode {
  case equal
  case notEqual
  case less
  case lessEqual
  case greater
  case greaterEqual

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

extension Builtins {

  public func isEqual(left: PyObject, right: PyObject) -> PyResultOrNot<Bool> {
    return self.richCompare(left: left, right: right, mode: .equal)
  }

  public func isNotEqual(left: PyObject, right: PyObject) -> PyResultOrNot<Bool> {
    return self.richCompare(left: left, right: right, mode: .notEqual)
  }

  public func isLess(left: PyObject, right: PyObject) -> PyResultOrNot<Bool> {
    return self.richCompare(left: left, right: right, mode: .less)
  }

  public func isLessEqual(left: PyObject, right: PyObject) -> PyResultOrNot<Bool> {
    return self.richCompare(left: left, right: right, mode: .lessEqual)
  }

  public func isGreater(left: PyObject, right: PyObject) -> PyResultOrNot<Bool> {
    return self.richCompare(left: left, right: right, mode: .greater)
  }

  public func isGreaterEqual(left: PyObject, right: PyObject) -> PyResultOrNot<Bool> {
    return self.richCompare(left: left, right: right, mode: .greaterEqual)
  }

  /// PyObject * PyObject_RichCompare(PyObject *v, PyObject *w, int op)
  public func richCompare(left: PyObject,
                          right: PyObject,
                          mode: CompareMode) -> PyResultOrNot<Bool> {
    // TODO: Finish this
//    var checkedReverse = false

// Check if right is subtype of left, if so then use right overload
//    if left.type !== right.type &&
//      self.PyType_IsSubtype(parent: right.type, subtype: left.type) {
//
//      if let cmpType = right.type as? ComparableTypeClass {
//        do {
//          checkedReverse = true
//          return try cmpType.compare(left: right, right: left, mode: mode.reverse)
//        } catch is ComparableNotImplemented { }
//      }
//    }
//
//    // Check if left is comparable (default path)
//    if let cmpType = left.type as? ComparableTypeClass {
//      do {
//        return try cmpType.compare(left: left, right: right, mode: mode)
//      } catch is ComparableNotImplemented { }
//    }
//
//    // Check if right is comparable
//    if let cmpType = right.type as? ComparableTypeClass, !checkedReverse {
//      do {
//        return try cmpType.compare(left: right, right: left, mode: mode.reverse)
//      } catch is ComparableNotImplemented { }
//    }

//    switch mode {
//    case .equal:
//      return left === right
//    case .notEqual:
//      return left !== right
//    case .less,
//         .lessEqual,
//         .greater,
//         .greaterEqual:
//      // PyErr_Format(PyExc_TypeError,
//      //              "'%s' not supported between instances of '%.100s' and '%.100s'",
//      //              opstrings[op],
//      //              v->ob_type->tp_name,
//      //              w->ob_type->tp_name);
//      fatalError()
//    }
    return .value(false)
  }
}
