// In CPython:
// Python -> sysmodule.c
// https://docs.python.org/3.7/library/sys.html

extension Sys {

  // MARK: - Prompts

  // sourcery: pyproperty: ps1, setter = setPS1
  /// sys.ps1
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.ps1).
  internal func getPS1() -> PyObject {
    return self.ps1
  }

  internal func setPS1(to value: PyObject) {
    self.ps1 = value
  }

  // sourcery: pyproperty: ps2, setter = setPS2
  /// sys.ps2
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.ps1).
  internal func getPS2() -> PyObject {
    return self.ps2
  }

  internal func setPS2(to value: PyObject) {
    self.ps2 = value
  }

  // MARK: - Platform

  // sourcery: pyproperty: platform, setter = setPlatform
  /// sys.platform
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.platform).
  internal func getPlatform() -> PyObject {
    return self.platform
  }

  internal func setPlatform(to value: PyObject) {
    self.platform = value
  }
}
