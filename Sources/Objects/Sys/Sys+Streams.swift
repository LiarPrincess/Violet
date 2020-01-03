// In CPython:
// Python -> sysmodule.c
// https://docs.python.org/3.7/library/sys.html

extension Sys {

  // MARK: - Stdin

  // sourcery: pyproperty: stdin, setter = setStdin
  /// sys.stdin
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.stdin).
  internal func getStdin() -> PyObject {
    return self.stdin
  }

  internal func setStdin(to value: PyObject) -> PyResult<()> {
    guard let file = value as? PyTextFile else {
      return .typeError("'stdin' has to be 'TextFile', not '\(value.typeName)'")
    }

    self.stdin = file
    return .value()
  }

  // sourcery: pyproperty: __stdin__
  /// sys.__stdin__
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.__stdin__).
  internal func get__stdin__() -> PyObject {
    return self.__stdin__
  }

  // MARK: - Stdout

  // sourcery: pyproperty: stdout, setter = setStdout
  /// sys.stdout
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.stdin).
  internal func getStdout() -> PyObject {
    return self.stdout
  }

  // sourcery: pyproperty: __stdout__
  /// sys.__stdout__
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.__stdin__).
  internal func get__stdout__() -> PyObject {
    return self.__stdout__
  }

  internal func setStdout(to value: PyObject) -> PyResult<()> {
    guard let file = value as? PyTextFile else {
      return .typeError("'stdout' has to be 'TextFile', not '\(value.typeName)'")
    }

    self.stdout = file
    return .value()
  }

  // MARK: - Stderr

  // sourcery: pyproperty: stderr, setter = setStderr
  /// sys.stderr
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.stdin).
  internal func getStderr() -> PyObject {
    return self.stderr
  }

  internal func setStderr(to value: PyObject) -> PyResult<()> {
    guard let file = value as? PyTextFile else {
      return .typeError("'stderr' has to be 'TextFile', not '\(value.typeName)'")
    }

    self.stderr = file
    return .value()
  }

  // sourcery: pyproperty: __stderr__
  /// sys.__stderr__
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.__stdin__).
  internal func get__stderr__() -> PyObject {
    return self.__stderr__
  }
}
