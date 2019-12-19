// In CPython:
// Python -> builtinmodule.c
// https://docs.python.org/3/library/functions.html

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

  // MARK: - Helpers

  internal var unimplemented: PyObject {
    return self.none
  }
}
