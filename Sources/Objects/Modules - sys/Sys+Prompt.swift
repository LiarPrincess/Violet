import VioletCore

// In CPython:
// Python -> sysmodule.c
// https://docs.python.org/3.7/library/sys.html

extension Sys {

  // MARK: - PS1

  /// sys.ps1
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.ps1).
  ///
  /// String specifying the primary prompt of the interpreter.
  public func getPS1() -> PyResult {
    return self.get(.ps1)
  }

  public func setPS1(_ value: PyObject) -> PyBaseException? {
    return self.set(.ps1, value: value)
  }

  // MARK: - PS2

  /// sys.ps2
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.ps1).
  ///
  /// Strings specifying the secondary prompt of the interpreter.
  public func getPS2() -> PyResult {
    return self.get(.ps2)
  }

  public func setPS2(_ value: PyObject) -> PyBaseException? {
    return self.set(.ps2, value: value)
  }
}
