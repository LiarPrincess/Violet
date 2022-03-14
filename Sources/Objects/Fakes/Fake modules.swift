public struct Sys {
  public var flags: Flags { fatalError() }

  public func getPath() -> PyResult<PyList> { fatalError() }

  public enum GetModuleResult {
    case module(PyModule)
    /// Value was found in `modules`, but it is not an `module` object.
    case notModule(PyObject)
    case notFound(PyBaseException)
    case error(PyBaseException)
  }

  public func getModule(name: PyString) -> GetModuleResult { fatalError() }
  public func getModule(name: PyObject) -> GetModuleResult { fatalError() }

  public func addModule(module: PyModule) -> PyBaseException? { fatalError() }
}

public struct UnderscoreWarnings {

  public enum WarningRegistry {
    case dict(PyDict)
    /// Python `None`, not `nil` from `Swift.Optional`.
    case none
  }

  public func warn(message: PyString, category: PyType) -> PyBaseException? { fatalError() }
  public func getWarningRegistry(frame: PyFrame?) -> PyResult<WarningRegistry> { fatalError() }


  public func warnExplicit(message: PyObject,
                           category: PyType,
                           filename: PyString,
                           lineNo: PyInt,
                           module: PyString?,
                           source: PyObject?,
                           registry: WarningRegistry) -> PyBaseException? { fatalError() }
}
