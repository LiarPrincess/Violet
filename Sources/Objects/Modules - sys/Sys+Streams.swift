import VioletCore

// In CPython:
// Python -> sysmodule.c
// https://docs.python.org/3.7/library/sys.html

extension Sys {

  // MARK: - Stdin

  /// `sys.__stdin__`
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.__stdin__).
  public func get__stdin__() -> PyResultGen<PyTextFile> {
    return self.getTextFile(.__stdin__)
  }

  /// `sys.stdin`
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.stdin).
  public func getStdin() -> PyResultGen<PyTextFile> {
    return self.getTextFile(.stdin)
  }

  public func setStdin(fd: PyFileDescriptorType?) -> PyBaseException? {
    let value = self.createStdio(kind: .stdin, fd: fd)
    return self.set(.stdin, value: value)
  }

  // MARK: - Stdout

  /// sys.__stdout__
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.__stdin__).
  public func get__stdout__() -> PyResultGen<PyTextFile> {
    return self.getTextFile(.__stdout__)
  }

  /// sys.stdout
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.stdin).
  public func getStdout() -> PyResultGen<PyTextFile> {
    return self.getTextFile(.stdout)
  }

  public func setStdout(fd: PyFileDescriptorType?) -> PyBaseException? {
    let value = self.createStdio(kind: .stdout, fd: fd)
    return self.set(.stdout, value: value)
  }

  // MARK: - Stderr

  /// sys.__stderr__
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.__stdin__).
  public func get__stderr__() -> PyResultGen<PyTextFile> {
    return self.getTextFile(.__stderr__)
  }

  /// sys.stderr
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.stdin).
  public func getStderr() -> PyResultGen<PyTextFile> {
    return self.getTextFile(.stderr)
  }

  public func setStderr(fd: PyFileDescriptorType?) -> PyBaseException? {
    let value = self.createStdio(kind: .stderr, fd: fd)
    return self.set(.stderr, value: value)
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
      if self.py.cast.isNone(object) {
        return .none
      }

      if let file = self.py.cast.asTextFile(object) {
        return .value(file)
      }

      let error: PyTypeError = self.createPropertyTypeError(
        property,
        got: object,
        expectedType: "textFile"
      )

      return .error(error.asBaseException)

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
  }

  public func getFile(stream: InputStream) -> PyResultGen<PyTextFile> {
    switch stream {
    case .__stdin__:
      return self.get__stdin__()
    case .stdin:
      return self.getStdin()
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
  }

  public func getFile(stream: OutputStream) -> PyResultGen<PyTextFile> {
    switch stream {
    case .__stdout__:
      return self.get__stdout__()
    case .stdout:
      return self.getStdout()
    case .__stderr__:
      return self.get__stderr__()
    case .stderr:
      return self.getStderr()
    }
  }

  // MARK: - Initial

  internal func createInitialStdin() -> PyObject {
    let fd = self.py.config.standardInput
    return self.createStdio(kind: .stdin, fd: fd)
  }

  internal func createInitialStdout() -> PyObject {
    let fd = self.py.config.standardOutput
    return self.createStdio(kind: .stdout, fd: fd)
  }

  internal func createInitialStderr() -> PyObject {
    let fd = self.py.config.standardError
    return self.createStdio(kind: .stderr, fd: fd)
  }

  private struct StdioKind {
    fileprivate static let stdin = StdioKind(name: "<stdin>", mode: .read)
    fileprivate static let stdout = StdioKind(name: "<stdout>", mode: .write)
    fileprivate static let stderr = StdioKind(name: "<stderr>", mode: .write)

    fileprivate let name: String
    fileprivate let mode: FileMode
  }

  /// static PyObject*
  /// create_stdio(PyObject* io,
  private func createStdio(kind: StdioKind, fd: PyFileDescriptorType?) -> PyObject {
    guard let fd = fd else {
      return self.py.none.asObject
    }

    let result = self.py.newTextFile(name: kind.name,
                                     fd: fd,
                                     mode: kind.mode,
                                     encoding: Unimplemented.stdioEncoding,
                                     errorHandling: Unimplemented.stdioErrors,
                                     closeOnDealloc: false)

    return result.asObject
  }
}
