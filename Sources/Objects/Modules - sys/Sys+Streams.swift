import Core

// In CPython:
// Python -> sysmodule.c
// https://docs.python.org/3.7/library/sys.html

extension Sys {

  // MARK: - Stdin

  // sourcery: pyproperty = __stdin__
  /// sys.__stdin__
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.__stdin__).
  public var __stdin__: PyObject {
    if let value = self.get(key: .__stdin__) {
      return value
    }

    return self.createStdio(
      name: "<stdin>",
      fd: Py.config.standardInput,
      mode: .read
    )
  }

  // sourcery: pyproperty = stdin, setter = setStdin
  /// sys.stdin
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.stdin).
  internal var stdin: PyObject {
    return self.get(key: .stdin) ?? self.__stdin__
  }

  internal func setStdin(to value: PyObject) -> PyResult<()> {
    self.set(key: .stdin, value: value)
    return .value()
  }

  // MARK: - Stdout

  // sourcery: pyproperty = __stdout__
  /// sys.__stdout__
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.__stdin__).
  public var __stdout__: PyObject {
    if let value = self.get(key: .__stdout__) {
      return value
    }

    return self.createStdio(
      name: "<stdout>",
      fd: Py.config.standardOutput,
      mode: .write
    )
  }

  // sourcery: pyproperty = stdout, setter = setStdout
  /// sys.stdout
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.stdin).
  internal var stdout: PyObject {
    return self.get(key: .stdout) ?? self.__stdout__
  }

  internal func setStdout(to value: PyObject) -> PyResult<()> {
    self.set(key: .stdout, value: value)
    return .value()
  }

  // MARK: - Stderr

  // sourcery: pyproperty = __stderr__
  /// sys.__stderr__
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.__stdin__).
  public var __stderr__: PyObject {
    if let value = self.get(key: .__stderr__) {
      return value
    }

    return self.createStdio(
      name: "<stderr>",
      fd: Py.config.standardError,
      mode: .write
    )
  }

  // sourcery: pyproperty = stderr, setter = setStderr
  /// sys.stderr
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.stdin).
  internal var stderr: PyObject {
    return self.get(key: .stderr) ?? self.__stderr__
  }

  internal func setStderr(to value: PyObject) -> PyResult<()> {
    self.set(key: .stderr, value: value)
    return .value()
  }

  // MARK: - Helpers

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
