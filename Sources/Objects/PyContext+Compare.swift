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

extension PyContext {

  /// PyObject * PyObject_RichCompare(PyObject *v, PyObject *w, int op)
  public func richCompare(left: PyObject,
                          right: PyObject,
                          mode: CompareMode) throws -> PyObject {
    let bool = try self.richCompareBool(left: left, right: right, mode: mode)
    return self.types.bool.new(bool)
  }

  /// int PyObject_RichCompareBool(PyObject *v, PyObject *w, int op)
  internal func richCompareBool(left: PyObject,
                                right: PyObject,
                                mode: CompareMode) throws -> Bool {

    var checkedReverse = false

    // Check if right is subtype of left, if so then use right overload
    if left.type !== right.type &&
      self.PyType_IsSubtype(parent: right.type, subtype: left.type) {

      if let cmpType = right.type as? ComparableTypeClass {
        do {
          checkedReverse = true
          return try cmpType.compare(left: right, right: left, mode: mode.reverse)
        } catch is ComparableNotImplemented { }
      }
    }

    // Check if left is comparable (default path)
    if let cmpType = left.type as? ComparableTypeClass {
      do {
        return try cmpType.compare(left: left, right: right, mode: mode)
      } catch is ComparableNotImplemented { }
    }

    // Check if right is comparable
    if let cmpType = right.type as? ComparableTypeClass, !checkedReverse {
      do {
        return try cmpType.compare(left: right, right: left, mode: mode.reverse)
      } catch is ComparableNotImplemented { }
    }

    switch mode {
    case .equal:
      return left === right
    case .notEqual:
      return left !== right
    case .less,
         .lessEqual,
         .greater,
         .greaterEqual:
      // PyErr_Format(PyExc_TypeError,
      //              "'%s' not supported between instances of '%.100s' and '%.100s'",
      //              opstrings[op],
      //              v->ob_type->tp_name,
      //              w->ob_type->tp_name);
      fatalError()
    }
  }

  /// Source: Py_RETURN_RICHCOMPARE
  internal func richCompare(left: Int, right: Int, mode: CompareMode) -> Bool {
    switch mode {
    case .equal:    return left == right
    case .notEqual: return left != right
    case .less:      return left < right
    case .lessEqual: return left <= right
    case .greater:      return left > right
    case .greaterEqual: return left >= right
    }
  }

  /// Source: Py_RETURN_RICHCOMPARE
  internal func richCompare(left: Double, right: Double, mode: CompareMode) -> Bool {
    switch mode {
    case .equal:    return left == right
    case .notEqual: return left != right
    case .less:      return left < right
    case .lessEqual: return left <= right
    case .greater:      return left > right
    case .greaterEqual: return left >= right
    }
  }
}
