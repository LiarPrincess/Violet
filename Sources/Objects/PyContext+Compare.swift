extension PyContext {

  /// PyObject * PyObject_RichCompare(PyObject *v, PyObject *w, int op)
  public func richCompare(left:  PyObject,
                          right: PyObject,
                          mode: CompareMode) -> PyObject {
    return left
  }

  /// int PyObject_RichCompareBool(PyObject *v, PyObject *w, int op)
  internal func richCompareBool(left:  PyObject,
                                right: PyObject,
                                mode:  CompareMode) -> Bool {
    return false
  }

  /// Source: Py_RETURN_RICHCOMPARE
  internal func richCompare(lhs: Int, rhs: Int, mode: CompareMode) -> PyBool {
    switch mode {
    case .equal:    return self.types.bool.new(lhs == rhs)
    case .notEqual: return self.types.bool.new(lhs != rhs)
    case .less:      return self.types.bool.new(lhs < rhs)
    case .lessEqual: return self.types.bool.new(lhs <= rhs)
    case .greater:      return self.types.bool.new(lhs > rhs)
    case .greaterEqual: return self.types.bool.new(lhs >= rhs)
    }
  }

  /// Source: Py_RETURN_RICHCOMPARE
  internal func richCompare(lhs: Double, rhs: Double, mode: CompareMode) -> PyBool {
    switch mode {
    case .equal:    return self.types.bool.new(lhs == rhs)
    case .notEqual: return self.types.bool.new(lhs != rhs)
    case .less:      return self.types.bool.new(lhs < rhs)
    case .lessEqual: return self.types.bool.new(lhs <= rhs)
    case .greater:      return self.types.bool.new(lhs > rhs)
    case .greaterEqual: return self.types.bool.new(lhs >= rhs)
    }
  }
}
