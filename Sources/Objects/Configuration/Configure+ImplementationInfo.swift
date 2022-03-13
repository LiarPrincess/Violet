import VioletCore

extension Configure {

  /// Internal helper for `sys.implementation`.
  internal struct ImplementationInfo {

    /// Program name to use on the command line.
    internal let name: String
    /// A one-line description of this command.
    internal let abstract: String
    /// A longer description of this program,
    /// to be shown in the extended help display.
    internal let discussion: String
    internal let version: VersionInfo
    internal let cacheTag: String?

    internal init(name: String,
                  abstract: String,
                  discussion: String,
                  version: VersionInfo,
                  cacheTag: String?) {
      self.name = name
      self.abstract = abstract
      self.discussion = discussion
      self.version = version
      self.cacheTag = cacheTag
    }
  }
}
