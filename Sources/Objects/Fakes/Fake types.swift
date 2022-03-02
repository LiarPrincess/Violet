extension PyType {
  public struct MemoryLayout {}

  public func getNameString() -> String { return "" }
  public func setBuiltinTypeDoc(_ s: String?) {}
}

extension PyDict {

  public enum SetResult {
    case ok
    case error(PyBaseException)
  }

  public func set(key: PyString, to value: PyObject) -> SetResult {
    return .ok
  }
}

extension PyList {
  public func sort(key: Int?, isReverse: Bool?) -> PyResult<PyObject> { fatalError() }
}
