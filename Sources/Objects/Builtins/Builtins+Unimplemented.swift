// In CPython:
// Python -> builtinmodule.c
// https://docs.python.org/3/library/functions.html

extension Builtins {

  // MARK: - Other

  /// Internal API to look for a name through the MRO.
  internal func lookup(_ object: PyObject, name: String) -> PyObject? {
    return object.type.lookup(name: name)
  }

  internal func call(_ fn: PyObject, args: [PyObject]) -> PyResult<PyObject> {
    return .value(self.unimplemented)
  }

  // MARK: - Helpers

  internal var unimplemented: PyObject {
    return self.context.none
  }
}
