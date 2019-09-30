extension PyContext {

  public func richCompare(left:  PyObject,
                          right: PyObject,
                          mode: CompareMode) -> PyObject {
    return left
  }

  internal func richCompareBool(left:  PyObject,
                                right: PyObject,
                                mode:  CompareMode) -> Bool {
    return false
  }

  internal func richCompare(lhs: Int, rhs: Int, mode: CompareMode) -> PyBool {
    // Py_RETURN_RICHCOMPARE
    switch mode {
    case .equal:    return self.types.bool.new(lhs == rhs)
    case .notEqual: return self.types.bool.new(lhs != rhs)
    case .less:      return self.types.bool.new(lhs < rhs)
    case .lessEqual: return self.types.bool.new(lhs <= rhs)
    case .greater:      return self.types.bool.new(lhs > rhs)
    case .greaterEqual: return self.types.bool.new(lhs >= rhs)
    }
  }

  internal func richCompare(lhs: Double, rhs: Double, mode: CompareMode) -> PyBool {
    // Py_RETURN_RICHCOMPARE
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
