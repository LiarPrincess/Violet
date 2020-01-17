/// Internal helper for `sys.implementation`.
public class ImplementationInfo {

  public let name: String
  public let version: VersionInfo
  public let cacheTag: String?

  public lazy var object: PyNamespace = {
    let cacheTag: PyObject =
      self.cacheTag.map(Py.newString(_:)) ?? Py.none

    let attributes = Attributes()
    attributes.set(key: "name", to: Py.newString(self.name))
    attributes.set(key: "version", to: self.version.object)
    attributes.set(key: "hexversion", to: self.version.hexVersionObject)
    attributes.set(key: "cache_tag", to: cacheTag)
    return Py.newNamespace(attributes: attributes)
  }()

  internal init(name: String, version: VersionInfo, cacheTag: String?) {
    self.name = name
    self.version = version
    self.cacheTag = cacheTag
  }
}
