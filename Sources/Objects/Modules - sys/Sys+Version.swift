import VioletCore

// In CPython:
// Python -> sysmodule.c
// https://docs.python.org/3.7/library/sys.html

extension Sys {

  // MARK: - Version

  /// sys.version
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.version).
  public func getVersion() -> PyResultGen<PyObject> {
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
  public func getVersionInfo() -> PyResultGen<PyObject> {
    return self.get(.version_info)
  }

  internal func createInitialVersionInfo() -> PyNamespace {
    return self.createVersionObject(
      property: "version_info",
      versionInfo: self.pythonVersion
    )
  }

  // MARK: - Implementation

  /// sys.implementation
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.implementation).
  public func getImplementation() -> PyResultGen<PyObject> {
    return self.get(.implementation)
  }

  internal func createInitialImplementation() -> PyNamespace {
    return self.createImplementationObject(
      property: "implementation",
      implementation: self.implementation
    )
  }

  // MARK: - Hex version

  /// sys.hexversion
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.hexversion).
  public func getHexVersion() -> PyResultGen<PyObject> {
    return self.get(.hexversion)
  }

  internal func createInitialHexVersion() -> PyInt {
    let hexVersion = self.pythonVersion.hexVersion
    return self.py.newInt(hexVersion)
  }

  // MARK: - Create object

  private func createVersionObject(property: String,
                                   versionInfo: VersionInfo) -> PyNamespace {
    let dict = self.py.newDict()

    func insertOrTrap<T: PyObjectMixin>(name: String, value: T) {
      self.insertOrTrap(dict: dict, name: name, value: value, for: property)
    }

    let releaseLevel = versionInfo.releaseLevel.description

    insertOrTrap(name: "major", value: self.py.newInt(versionInfo.major))
    insertOrTrap(name: "minor", value: self.py.newInt(versionInfo.minor))
    insertOrTrap(name: "micro", value: self.py.newInt(versionInfo.micro))
    insertOrTrap(name: "releaseLevel", value: self.py.newString(releaseLevel))
    insertOrTrap(name: "serial", value: self.py.newInt(versionInfo.serial))

    return self.py.newNamespace(dict: dict)
  }

  private func createImplementationObject(property: String,
                                          implementation: ImplementationInfo) -> PyNamespace {
    let dict = self.py.newDict()

    func insertOrTrap<T: PyObjectMixin>(name: String, value: T) {
      self.insertOrTrap(dict: dict, name: name, value: value, for: property)
    }

    let name = self.py.intern(string: implementation.name)
    let hexversion = self.py.newInt(implementation.version.hexVersion)

    let version = self.createVersionObject(
      property: property,
      versionInfo: implementation.version
    )

    let cacheTag: PyObject
    if let c = implementation.cacheTag {
      let string = self.py.newString(c)
      cacheTag = string.asObject
    } else {
      cacheTag = self.py.none.asObject
    }

    insertOrTrap(name: "name", value: name)
    insertOrTrap(name: "version", value: version)
    insertOrTrap(name: "hexversion", value: hexversion)
    insertOrTrap(name: "cache_tag", value: cacheTag)

    return self.py.newNamespace(dict: dict)
  }

  private func insertOrTrap<T: PyObjectMixin>(dict: PyDict,
                                              name: String,
                                              value: T,
                                              for property: String) {
    let key = self.py.newString(name)
    switch dict.set(self.py, key: key, value: value.asObject) {
    case .ok:
      break
    case .error(let e):
      trap("Error when inserting '\(name)' to 'sys.\(property)': \(e)")
    }
  }
}
