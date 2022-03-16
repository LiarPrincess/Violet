public struct Builtins {
  internal var __dict__: PyDict { fatalError() }
}

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

  public var defaultEncoding: PyString.Encoding {
    fatalError()
  }

  public func getArgv0() -> PyResult<PyString> { fatalError() }

  public func getModule(name: PyString) -> GetModuleResult { fatalError() }
  public func getModule(name: PyObject) -> GetModuleResult { fatalError() }

  public func getStderr() -> PyResult<PyTextFile> { fatalError() }
  public func addModule(module: PyModule) -> PyBaseException? { fatalError() }

  public func getBuiltinModuleNames() -> PyResult<PyTuple> { fatalError() }

  public enum OutputStream {
    /// `sys.__stdout__`
    case __stdout__
    /// `sys.stdout`
    case stdout
    /// `sys.__stderr__`
    case __stderr__
    /// `sys.stderr`
    case stderr

    public func getFile() -> PyResult<PyTextFile> { fatalError() }
  }

  public func getTracebackLimit() -> PyResult<PyInt> { fatalError() }
}
