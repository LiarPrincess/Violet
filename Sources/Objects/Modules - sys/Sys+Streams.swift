import Core

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

  public enum GetStderrOrNoneResult {
    case none
    case file(PyTextFile)
    case error(PyBaseException)
  }

  public func getStderrOrNone() -> GetStderrOrNoneResult {
    switch self.get(.stderr) {
    case .value(let object):
      if object.isNone {
        return .none
      }

      if let file = object as? PyTextFile {
        return .file(file)
      }

      let msg = self.createPropertyTypeError(
        .stderr,
        got: object,
        expectedType: "textFile"
      )

      return .error(Py.newTypeError(msg: msg))

    case let .error(e):
      return .error(e)
    }
  }

  // MARK: - Initial

  internal func createInitialStdin() -> PyTextFile {
    return self.createStdio(
      name: "<stdin>",
      fd: Py.config.standardInput,
      mode: .read
    )
  }

  internal func createInitialStdout() -> PyTextFile {
    return self.createStdio(
      name: "<stdout>",
      fd: Py.config.standardOutput,
      mode: .write
    )
  }

  internal func createInitialStderr() -> PyTextFile {
    return self.createStdio(
      name: "<stderr>",
      fd: Py.config.standardError,
      mode: .write
    )
  }

  /// static PyObject*
  /// create_stdio(PyObject* io,
  private func createStdio(name: String,
                           fd: FileDescriptorType,
                           mode: FileMode) -> PyTextFile {
    return PyTextFile(
      name: name,
      fd: fd,
      mode: mode,
      encoding: Unimplemented.stdioEncoding,
      errors: Unimplemented.stdioErrors,
      closeOnDealloc: false
    )
  }
}
