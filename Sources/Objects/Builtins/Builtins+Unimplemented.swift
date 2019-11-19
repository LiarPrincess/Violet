// In CPython:
// Python -> builtinmodule.c
// https://docs.python.org/3/library/functions.html

internal enum CallResult {
  case value(PyObject)
  // return .attributeError("'\(value.typeName)' object has no attribute 'abc'")
  case noSuchMethod(PyErrorEnum)
  case methodIsNotCallable(PyErrorEnum)
}

extension Builtins {

  public func getDict(_ module: PyModule) -> Attributes {
    return module._attributes
  }

  // MARK: - Other

  internal func call(_ fn: PyObject, args: [PyObject]) -> PyResult<PyObject> {
    return .value(self.unimplemented)
  }

  internal func callMethod(on zelf: PyObject, selector: String) -> CallResult {
    return .value(self.unimplemented)
  }

  internal func callMethod(on zelf: PyObject,
                           selector: String,
                           arg: PyObject) -> CallResult {
    return .value(self.unimplemented)
  }

  internal func callMethod(on zelf: PyObject,
                           selector: String,
                           args: [PyObject]) -> CallResult {
    return .value(self.unimplemented)
  }

  // MARK: - Helpers

  internal var unimplemented: PyObject {
    return self.none
  }
}
