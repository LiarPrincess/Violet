/// Internal helper for `sys.implementation`.
public struct ImplementationInfo {

  public let name: String
  public let version: VersionInfo
  public let cacheTag: String?

  public lazy var object: PyNamespace = {
    let cacheTag: PyObject =
      self.cacheTag.map(Py.builtins.newString(_:)) ?? Py.builtins.none

    let attributes = Attributes()
    attributes.set(key: "name", to: Py.builtins.newString(name))
    attributes.set(key: "version", to: version.object)
    attributes.set(key: "hexversion", to: version.hexVersionObject)
    attributes.set(key: "cache_tag", to: cacheTag)
    return Py.builtins.newNamespace(attributes: attributes)
  }()

  internal init(name: String, version: VersionInfo, cacheTag: String?) {
    self.name = name
    self.version = version
    self.cacheTag = cacheTag
  }
}
