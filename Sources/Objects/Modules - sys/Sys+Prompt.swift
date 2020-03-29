import Core

// In CPython:
// Python -> sysmodule.c
// https://docs.python.org/3.7/library/sys.html

extension Sys {

  // MARK: - PS1

  // sourcery: pyproperty = ps1, setter = setPS1
  /// sys.ps1
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.ps1).
  ///
  /// Strings specifying the primary and secondary prompt of the interpreter.
  /// These are only defined if the interpreter is in interactive mode.
  internal var ps1Object: PyObject {
    return self.get(key: .ps1) ?? Py.getInterned(">>> ")
  }

  internal func setPS1(to value: PyObject) -> PyResult<()> {
    self.set(key: .ps1, value: value)
    return .value()
  }

  /// String that should be printed in interactive mode.
  public var ps1: String {
    switch Py.strValue(self.ps1Object) {
    case .value(let s): return s
    case .error: return ""
    }
  }

  // MARK: - PS2

  // sourcery: pyproperty = ps2, setter = setPS2
  /// sys.ps2
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.ps1).
  ///
  /// Strings specifying the primary and secondary prompt of the interpreter.
  /// These are only defined if the interpreter is in interactive mode.
  internal var ps2Object: PyObject {
    return self.get(key: .ps2) ?? Py.getInterned("... ")
  }

  internal func setPS2(to value: PyObject) -> PyResult<()> {
    self.set(key: .ps2, value: value)
    return .value()
  }

  /// String that should be printed in interactive mode.
  public var ps2: String {
    switch Py.strValue(self.ps2Object) {
    case .value(let s): return s
    case .error: return ""
    }
  }
}
