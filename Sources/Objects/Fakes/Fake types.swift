public struct PyBaseException {}

extension PyType {
  public struct MemoryLayout {}
}

extension PyList {
  public func sort(key: Int?, isReverse: Bool?) -> PyResult<PyObject> { fatalError() }
}
