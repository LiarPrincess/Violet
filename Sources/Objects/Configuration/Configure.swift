import Foundation

/// In CPython some values are configured in 'repo_root/configure' script.
/// We don't have that, and it would be weird to just hard-code on by-need basis.
///
/// So... we will move them to separate file.
internal enum Configure {

  internal static var pythonPath: [String] {
    return []
  }

  internal static var prefix: String {
    let executable = Py.config.executablePath
    let dirname = Py.fileSystem.dirname(path: executable)
    return dirname.path
  }

  internal static var execPrefix: String {
    return Configure.prefix
  }

  internal static var versionInfo = VersionInfo(
    major: 3,
    minor: 7,
    micro: 2,
    releaseLevel: .final,
    serial: 0
  )

  internal static var implementationInfo = ImplementationInfo(
    name: "Violet",
    version: VersionInfo(
      major: 0,
      minor: 0,
      micro: 1,
      releaseLevel: .beta,
      serial: 0
    ),
    cacheTag: nil
  )
}
