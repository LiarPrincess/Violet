// swiftlint:disable fatal_error_message
// swiftlint:disable unavailable_function

extension PyType {
  public struct MemoryLayout {}

  public func getNameString() -> String { return "" }
  public func setBuiltinTypeDoc(_ s: String?) {}
  public func isSubtype(of: PyType) -> Bool { return false }

  internal func dir() -> PyResult<DirResult> { fatalError() }

  internal enum ModuleAsString {
    case builtins
    case string(String)
    case error(PyBaseException)
  }

  internal func getModuleString() -> ModuleAsString { fatalError() }

  internal struct MroLookupResult {
    internal let object: PyObject
    /// Type on which `self.object` was found.
    internal let type: PyType
  }

  internal func mroLookup(name: IdString) -> MroLookupResult? { fatalError() }

  internal enum MroLookupByStringResult {
    case value(MroLookupResult)
    case notFound
    case error(PyBaseException)
  }

  internal func mroLookup(name: PyString) -> MroLookupByStringResult { fatalError() }
}

extension PyDict {

  public enum GetResult {
    case value(PyObject)
    case notFound
    case error(PyBaseException)
  }

  public func get(id: IdString) -> PyObject? { fatalError() }
  public func get(key: PyObject) -> GetResult { fatalError() }

  public enum SetResult {
    case ok
    case error(PyBaseException)
  }

  public func set(key: PyString, to value: PyObject) -> SetResult { fatalError() }

  public enum DelResult {
    case value(PyObject)
    case notFound
    case error(PyBaseException)
  }

  public func del(key: PyObject) -> DelResult { fatalError() }
}

extension PyList {
  public func sort(key: Int?, isReverse: Bool?) -> PyResult<PyObject> { fatalError() }
}
