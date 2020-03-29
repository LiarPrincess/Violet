import Core

/// Internal helper for `sys.implementation`.
public struct ImplementationInfo {

  public let name: String
  public let version: VersionInfo
  public let cacheTag: String?

  internal init(name: String, version: VersionInfo, cacheTag: String?) {
    self.name = name
    self.version = version
    self.cacheTag = cacheTag
  }
}
