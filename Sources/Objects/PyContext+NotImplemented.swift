import Core

extension PyContext {

  internal func call(_ fn: PyObject, args: [PyObject?]) -> PyResult<PyObject> {
    return .value(self.builtins.none)
  }

  internal func callDir(_ fn: PyObject, args: [PyObject?]) -> DirResult {
    return DirResult()
  }

  public func _PyUnicode_JoinArray(elements: [PyObject]) -> PyObject {
    return self.builtins.none
  }

  public func getSizeInt(value: PyObject) -> Int {
    return 0
  }

  public func PyObject_Format(value: PyObject, format: PyObject) -> PyObject {
    return self.builtins.none
  }

  public func pySlice_New(start: PyObject,
                          stop: PyObject,
                          step: PyObject?) -> PyObject {
    return start
  }

  internal func getGlobals() -> [String: PyObject] {
    return [:]
  }
}
