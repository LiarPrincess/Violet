/* MARKER
import VioletCore

/// Internal helper for `sys.implementation`.
public struct ImplementationInfo {

  /// Program name to use on the command line.
  public let name: String
  /// A one-line description of this command.
  public let abstract: String
  /// A longer description of this program,
  /// to be shown in the extended help display.
  public let discussion: String
  public let version: VersionInfo
  public let cacheTag: String?

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

*/