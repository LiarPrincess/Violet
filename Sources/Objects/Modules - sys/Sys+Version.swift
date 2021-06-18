import VioletCore

// In CPython:
// Python -> sysmodule.c
// https://docs.python.org/3.7/library/sys.html

extension Sys {

  // MARK: - Version

  /// sys.version
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.version).
  public func getVersion() -> PyResult<PyObject> {
    return self.get(.version)
  }

  // MARK: - Version info

  /// sys.version_info
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.version_info).
  ///
  /// A tuple containing the five components of the version number:
  /// major, minor, micro, releaselevel, and serial.
  /// All values except releaselevel are integers;
  /// the release level is 'alpha', 'beta', 'candidate', or 'final'.
  public func getVersionInfo() -> PyResult<PyObject> {
    return self.get(.version_info)
  }

  // MARK: - Implementation

  /// sys.implementation
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.implementation).
  public func getImplementation() -> PyResult<PyObject> {
    return self.get(.implementation)
  }

  // MARK: - Hex version

  /// sys.hexversion
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.hexversion).
  public func getHexVersion() -> PyResult<PyObject> {
    return self.get(.hexversion)
  }

  // MARK: - Initial

  internal func createInitialVersionInfo() -> PyObject {
    return self.createVersionObject(
      property: "version_info",
      versionInfo: self.versionInfo
    )
  }

  internal func createInitialImplementation() -> PyObject {
    return self.createImplementationObject(
      property: "implementation",
      implementation: self.implementation
    )
  }

  private func createVersionObject(
    property: String,
    versionInfo: VersionInfo
  ) -> PyNamespace {
    let dict = Py.newDict()

    func insertOrTrap(name: String, value: PyObject) {
      self.insertOrTrap(dict: dict, name: name, value: value, for: property)
    }

    let releaseLevel = versionInfo.releaseLevel.description

    insertOrTrap(name: "major", value: Py.newInt(versionInfo.major))
    insertOrTrap(name: "minor", value: Py.newInt(versionInfo.minor))
    insertOrTrap(name: "micro", value: Py.newInt(versionInfo.micro))
    insertOrTrap(name: "releaseLevel", value: Py.newString(releaseLevel))
    insertOrTrap(name: "serial", value: Py.newInt(versionInfo.serial))

    return Py.newNamespace(dict: dict)
  }

  private func createImplementationObject(
    property: String,
    implementation: ImplementationInfo
  ) -> PyNamespace {
    let dict = Py.newDict()

    func insertOrTrap(name: String, value: PyObject) {
      self.insertOrTrap(dict: dict, name: name, value: value, for: property)
    }

    let name = Py.intern(string: implementation.name)
    let hexversion = Py.newInt(implementation.version.hexVersion)

    let version = self.createVersionObject(
      property: property,
      versionInfo: implementation.version
    )

    let cacheTag: PyObject = {
      if let c = implementation.cacheTag {
        return Py.newString(c)
      }

      return Py.none
    }()

    insertOrTrap(name: "name", value: name)
    insertOrTrap(name: "version", value: version)
    insertOrTrap(name: "hexversion", value: hexversion)
    insertOrTrap(name: "cache_tag", value: cacheTag)

    return Py.newNamespace(dict: dict)
  }

  private func insertOrTrap(
    dict: PyDict,
    name: String,
    value: PyObject,
    for property: String
  ) {
    let key = Py.newString(name)
    switch dict.set(key: key, to: value) {
    case .ok:
      break
    case .error(let e):
      trap("Error when inserting '\(name)' to 'sys.\(property)': \(e)")
    }
  }
}
