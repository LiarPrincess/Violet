import Core

// In CPython:
// Python -> sysmodule.c
// https://docs.python.org/3.7/library/sys.html

extension Sys {

  // MARK: - Version

  public var version: String {
    let v = self.versionInfo
    let i = self.implementation.version
    return "Python \(v.major).\(v.minor).\(v.micro) " +
    "(Violet \(i.major).\(i.minor).\(i.micro))"
  }

  // sourcery: pyproperty = version
  /// sys.version
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.version).
  internal var versionObject: PyString {
    return Py.intern(self.version)
  }

  // MARK: - Version info

  /// `sys.version_info`
  ///
  /// ```
  /// >>> sys.version_info
  /// sys.version_info(major=3, minor=7, micro=2, releaselevel='final', serial=0)
  /// ```
  public var versionInfo: VersionInfo {
    return Configure.versionInfo
  }

  // sourcery: pyproperty = version_info
  /// sys.version_info
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.version_info).
  ///
  /// A tuple containing the five components of the version number:
  /// major, minor, micro, releaselevel, and serial.
  /// All values except releaselevel are integers;
  /// the release level is 'alpha', 'beta', 'candidate', or 'final'.
  internal var versionInfoObject: PyObject {
    if let value = self.get(key: .version_info) {
      return value
    }

    return self.createObject(
      versionInfo: self.versionInfo,
      property: "version_info"
    )
  }

  private func createObject(
    versionInfo: VersionInfo,
    property: String
  ) -> PyNamespace {
    let dict = PyDict()

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

  // MARK: - Implementation

  public var implementation: ImplementationInfo {
    return Configure.implementationInfo
  }

  // sourcery: pyproperty = implementation
  /// sys.implementation
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.implementation).
  internal var implementationObject: PyObject {
    if let value = self.get(key: .implementation) {
      return value
    }

    return self.createObject(
      implementation: self.implementation,
      property: "implementation"
    )
  }

  private func createObject(
    implementation: ImplementationInfo,
    property: String
  ) -> PyNamespace {
    let dict = PyDict()

    func insertOrTrap(name: String, value: PyObject) {
      self.insertOrTrap(dict: dict, name: name, value: value, for: property)
    }

    let name = Py.intern(implementation.name)
    let hexversion = Py.newInt(implementation.version.hexVersion)

    let version = self.createObject(
      versionInfo: implementation.version,
      property: property
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

  // MARK: - Helpers

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
