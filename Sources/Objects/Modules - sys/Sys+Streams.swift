import VioletCore

// In CPython:
// Python -> sysmodule.c
// https://docs.python.org/3.7/library/sys.html

extension Sys {

  // MARK: - Stdin

  /// sys.__stdin__
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.__stdin__).
  public func get__stdin__() -> PyResult<PyTextFile> {
    return self.getTextFile(.__stdin__)
  }

  /// sys.stdin
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.stdin).
  public func getStdin() -> PyResult<PyTextFile> {
    return self.getTextFile(.stdin)
  }

  public func setStdin(to value: PyObject) -> PyBaseException? {
    return self.set(.stdin, to: value)
  }

  // MARK: - Stdout

  /// sys.__stdout__
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.__stdin__).
  public func get__stdout__() -> PyResult<PyTextFile> {
    return self.getTextFile(.__stdout__)
  }

  /// sys.stdout
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.stdin).
  public func getStdout() -> PyResult<PyTextFile> {
    return self.getTextFile(.stdout)
  }

  public func setStdout(to value: PyObject) -> PyBaseException? {
    return self.set(.stdout, to: value)
  }

  // MARK: - Stderr

  /// sys.__stderr__
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.__stdin__).
  public func get__stderr__() -> PyResult<PyTextFile> {
    return self.getTextFile(.__stderr__)
  }

  /// sys.stderr
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.stdin).
  public func getStderr() -> PyResult<PyTextFile> {
    return self.getTextFile(.stderr)
  }

  public func setStderr(to value: PyObject) -> PyBaseException? {
    return self.set(.stderr, to: value)
  }

  // MARK: - Stream or none

  public enum StreamOrNone {
    case value(PyTextFile)
    case none
    case error(PyBaseException)
  }

  public func getStderrOrNone() -> StreamOrNone {
    return self.getStreamOrNone(property: .stderr)
  }

  public func getStdoutOrNone() -> StreamOrNone {
    return self.getStreamOrNone(property: .stdout)
  }

  private func getStreamOrNone(property: Sys.Properties) -> StreamOrNone {
    switch self.get(property) {
    case .value(let object):
      if PyCast.isNone(object) {
        return .none
      }

      if let file = PyCast.asTextFile(object) {
        return .value(file)
      }

      let msg = self.createPropertyTypeError(
        property,
        got: object,
        expectedType: "textFile"
      )

      return .error(Py.newTypeError(msg: msg))

    case let .error(e):
      return .error(e)
    }
  }

  // MARK: - Helper enums

  public enum InputStream {
    /// `sys.__stdin__`
    case __stdin__
    /// `sys.stdin`
    case stdin

    public func getFile() -> PyResult<PyTextFile> {
      switch self {
      case .__stdin__: return Py.sys.get__stdin__()
      case .stdin: return Py.sys.getStdin()
      }
    }
  }

  public enum OutputStream {
    /// `sys.__stdout__`
    case __stdout__
    /// `sys.stdout`
    case stdout
    /// `sys.__stderr__`
    case __stderr__
    /// `sys.stderr`
    case stderr

    public func getFile() -> PyResult<PyTextFile> {
      switch self {
      case .__stdout__: return Py.sys.get__stdout__()
      case .stdout: return Py.sys.getStdout()
      case .__stderr__: return Py.sys.get__stderr__()
      case .stderr: return Py.sys.getStderr()
      }
    }
  }

  // MARK: - Initial

  internal func createInitialStdin() -> PyTextFile {
    return self.createStdio(name: "<stdin>",
                            fd: Py.config.standardInput,
                            mode: .read)
  }

  internal func createInitialStdout() -> PyTextFile {
    return self.createStdio(name: "<stdout>",
                            fd: Py.config.standardOutput,
                            mode: .write)
  }

  internal func createInitialStderr() -> PyTextFile {
    return self.createStdio(name: "<stderr>",
                            fd: Py.config.standardError,
                            mode: .write)
  }

  /// static PyObject*
  /// create_stdio(PyObject* io,
  private func createStdio(name: String,
                           fd: FileDescriptorType,
                           mode: FileMode) -> PyTextFile {
    return PyMemory.newTextFile(name: name,
                                fd: fd,
                                mode: mode,
                                encoding: Unimplemented.stdioEncoding,
                                errorHandling: Unimplemented.stdioErrors,
                                closeOnDealloc: false)
  }
}
