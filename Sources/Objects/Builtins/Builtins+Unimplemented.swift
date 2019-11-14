// In CPython:
// Python -> builtinmodule.c
// https://docs.python.org/3/library/functions.html

internal enum CallResult {
  case value(PyObject)
  case noSuchMethod
  case methodIsNotCallable(PyErrorEnum)
}

extension Builtins {

  public func getDict(_ module: PyModule) -> Attributes {
    return module._attributes
  }

  // MARK: - Other

  /// Internal API to look for a name through the MRO.
  internal func lookup(_ object: PyObject, name: String) -> PyObject? {
    return object.type.lookup(name: name)
  }

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
