// In CPython:
// Python -> builtinmodule.c
// https://docs.python.org/3/library/functions.html

internal enum CallResult2 {
  case value(PyObject)
  case notImplemented
  case methodIsNotCallable(PyErrorEnum)
  case error(PyErrorEnum)
}

extension Builtins {

  internal func callDir(_ fn: PyObject, args: [PyObject?]) -> DirResult {
    return DirResult()
  }

  public func PyObject_Format(value: PyObject, format: PyObject) -> PyObject {
    return self.none
  }

  internal func getGlobals() -> [String: PyObject] {
    return [:]
  }

  public func getDict(_ module: PyModule) -> Attributes {
    return module.attributes
  }

  internal func call(_ fn: PyObject, args: [PyObject?]) -> PyResult<PyObject> {
    return .value(self.unimplemented)
  }

  internal func call2(_ fn: PyObject, arg: PyObject) -> CallResult2 {
    return .notImplemented
  }

  internal func call2(_ fn: PyObject, args: [PyObject?]) -> CallResult2 {
    return .notImplemented
  }

  // MARK: - Helpers

  internal var unimplemented: PyObject {
    return self.none
  }
}
