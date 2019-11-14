import Core

extension PyContext {

  // MARK: - Shared

  public func contains(sequence: PyObject, value: PyObject) -> PyResult<Bool> {
    return .value(false)
  }
}
