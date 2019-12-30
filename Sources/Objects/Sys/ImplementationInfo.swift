/// Internal helper for `sys.implementation`.
public struct ImplementationInfo {

  public let name: String
  public let version: VersionInfo
  public let cacheTag: String?

  public let object: PyNamespace

  public init(context: PyContext,
              name: String,
              version: VersionInfo,
              cacheTag: String?) {
    self.name = name
    self.version = version
    self.cacheTag = cacheTag

    let builtins = context.builtins
    let cacheTagObject: PyObject = cacheTag.map(context.intern) ?? builtins.none

    let attributes = Attributes()
    attributes.set(key: "name", to: context.intern(name))
    attributes.set(key: "version", to: version.object)
    attributes.set(key: "hexversion", to: version.hexVersionObject)
    attributes.set(key: "cache_tag", to: cacheTagObject)
    self.object = builtins.newNamespace(attributes: attributes)
  }
}
