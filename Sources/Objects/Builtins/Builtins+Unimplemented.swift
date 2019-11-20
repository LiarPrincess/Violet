// In CPython:
// Python -> builtinmodule.c
// https://docs.python.org/3/library/functions.html

extension Builtins {

  public func getDict(_ module: PyModule) -> Attributes {
    return module._attributes
  }

  // MARK: - Other

  internal func call(_ fn: PyObject, args: [PyObject]) -> PyResult<PyObject> {
    return .value(self.unimplemented)
  }

  // MARK: - Helpers

  internal var unimplemented: PyObject {
    return self.none
  }
}
