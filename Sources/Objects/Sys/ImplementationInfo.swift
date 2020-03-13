import Core

/// Internal helper for `sys.implementation`.
public final class ImplementationInfo {

  public let name: String
  public let version: VersionInfo
  public let cacheTag: String?

  public lazy var object: PyNamespace = {
    let dict = PyDict()

    func set(name: String, value: PyObject) {
      let interned = Py.getInterned(name)
      switch dict.set(key: interned, to: value) {
      case .ok:
        break
      case .error(let e):
        trap("Error when creating 'implementation' namespace: \(e)")
      }
    }

    let cacheTag: PyObject = self.cacheTag.map(Py.newString(_:)) ?? Py.none

    set(name: "name", value: Py.newString(self.name))
    set(name: "version", value: self.version.object)
    set(name: "hexversion", value: self.version.hexVersionObject)
    set(name: "cache_tag", value: cacheTag)

    return Py.newNamespace(dict: dict)
  }()

  internal init(name: String, version: VersionInfo, cacheTag: String?) {
    self.name = name
    self.version = version
    self.cacheTag = cacheTag
  }
}
