// In CPython:
// Python -> builtinmodule.c
// https://docs.python.org/3/library/functions.html

extension Builtins {

  public func getDict(_ module: PyModule) -> Attributes {
    return module.attributes
  }

  // MARK: - Other

  internal func call(_ fn: PyObject, args: [PyObject]) -> PyResult<PyObject> {
    return .value(self.unimplemented)
  }

  // MARK: - Helpers

  internal var unimplemented: PyObject {
    return self.none
  }

  // MARK: - Get item

  /// PySequence_GetItem
  public func getItem(_ collection: PyObject,
                      at index: Int) -> PyResult<PyObject> {
    return .value(self.unimplemented)
  }
}
