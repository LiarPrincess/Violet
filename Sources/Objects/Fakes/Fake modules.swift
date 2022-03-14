public struct Sys {
  public var flags: Flags { fatalError() }
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
