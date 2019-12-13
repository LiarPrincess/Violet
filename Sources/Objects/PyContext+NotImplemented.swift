import Core

extension PyContext {

  internal func callDir(_ fn: PyObject, args: [PyObject?]) -> DirResult {
    return DirResult()
  }

  public func PyObject_Format(value: PyObject, format: PyObject) -> PyObject {
    return self.builtins.none
  }

  internal func getGlobals() -> [String: PyObject] {
    return [:]
  }
}
