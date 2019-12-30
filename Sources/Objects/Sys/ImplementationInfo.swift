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
    let c = cacheTag.map(context.intern) ?? builtins.none

    // Ignore errors (because namespaces are made just to hold attributes).
    self.object = PyNamespace(context)
    _ = self.object.setAttribute(name: "name", value: context.intern(name))
    _ = self.object.setAttribute(name: "version", value: version.object)
    _ = self.object.setAttribute(name: "hexversion", value: version.hexVersionObject)
    _ = self.object.setAttribute(name: "cache_tag", value: c)
  }
}
