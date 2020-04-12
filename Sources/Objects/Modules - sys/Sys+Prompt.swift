import Core

// In CPython:
// Python -> sysmodule.c
// https://docs.python.org/3.7/library/sys.html

extension Sys {

  // MARK: - PS1

  /// sys.ps1
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.ps1).
  ///
  /// String specifying the primary prompt of the interpreter.
  public func getPS1() -> PyResult<PyObject> {
    return self.get(.ps1)
  }

  public func getPS1ToDisplayInInteractive() -> String {
    let ps1 = self.getPS1()
    return self.asStringToDisplayInInteractive(value: ps1)
  }

  public func setPS1(to value: PyObject) -> PyBaseException? {
    return self.set(.ps1, to: value)
  }

  // MARK: - PS2

  /// sys.ps2
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.ps1).
  ///
  /// Strings specifying the secondary prompt of the interpreter.
  public func getPS2() -> PyResult<PyObject> {
    return self.get(.ps2)
  }

  /// String that should be printed in interactive mode.
  public func getPS2ToDisplayInInteractive() -> String {
    let ps2 = self.getPS2()
    return self.asStringToDisplayInInteractive(value: ps2)
  }

  public func setPS2(to value: PyObject) -> PyBaseException? {
    return self.set(.ps2, to: value)
  }

  // MARK: - Helpers

  private func asStringToDisplayInInteractive(
    value: PyResult<PyObject>
  ) -> String {
    let string = value.flatMap(Py.strValue)

    switch string {
    case .value(let s):
      return s
    case .error:
      return ""
    }
  }
}
