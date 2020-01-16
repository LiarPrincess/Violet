// In CPython:
// Python -> sysmodule.c
// https://docs.python.org/3.7/library/sys.html

extension Sys {

  // MARK: - Prompts

  // sourcery: pyproperty = ps1, setter = setPS1
  /// sys.ps1
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.ps1).
  ///
  /// Strings specifying the primary and secondary prompt of the interpreter.
  /// These are only defined if the interpreter is in interactive mode.
  internal func getPS1() -> PyObject {
    return self.ps1
  }

  internal func setPS1(to value: PyObject) -> PyResult<()> {
    self.ps1 = value
    return .value()
  }

  // sourcery: pyproperty = ps2, setter = setPS2
  /// sys.ps2
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.ps1).
  ///
  /// Strings specifying the primary and secondary prompt of the interpreter.
  /// These are only defined if the interpreter is in interactive mode.
  internal func getPS2() -> PyObject {
    return self.ps2
  }

  internal func setPS2(to value: PyObject) -> PyResult<()> {
    self.ps2 = value
    return .value()
  }

  // MARK: - Platform

  // sourcery: pyproperty = platform
  /// sys.platform
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.platform).
  ///
  /// This string contains a platform identifier that can be used to append
  /// platform-specific components to `sys.path`, for instance.
  internal func getPlatform() -> PyString {
    return self.platformObject
  }

  // MARK: - Copyright

  // sourcery: pyproperty = copyright
  /// sys.copyright
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.copyright).
  ///
  /// A string containing the copyright pertaining to the Python interpreter.
  internal func getCopyright() -> PyString {
    return self.copyrightObject
  }

  // MARK: - Version

  // sourcery: pyproperty = version
  /// sys.version
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.version).
  internal func getVersion() -> PyString {
    return self.versionObject
  }

  // sourcery: pyproperty = version_info
  /// sys.version_info
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.version_info).
  ///
  /// A tuple containing the five components of the version number:
  /// major, minor, micro, releaselevel, and serial.
  /// All values except releaselevel are integers;
  /// the release level is 'alpha', 'beta', 'candidate', or 'final'.
  internal func getVersionInfo() -> PyObject {
    return self.versionInfo.object
  }

  // sourcery: pyproperty = implementation
  /// sys.implementation
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.implementation).
  internal func getImplementation() -> PyObject {
    return self.implementationInfo.object
  }

  // MARK: - Hash

  // sourcery: pyproperty = hash_info
  /// sys.hash_info
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.hash_info).
  internal func getHashInfo() -> PyObject {
    return self.hashInfo.object
  }
}
