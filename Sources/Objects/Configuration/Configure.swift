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
    let url = URL(fileURLWithPath: executable)
    let dir = url.deletingLastPathComponent()
    return dir.path
  }

  internal static var execPrefix: String {
    return Configure.prefix
  }

  // Do not make it stored property!
  // It contains Python object responsible for 'sys.version'.
  // We don't want to leak memory!
  internal static var version: VersionInfo {
    return VersionInfo(
      major: 3,
      minor: 7,
      micro: 2,
      releaseLevel: .final,
      serial: 0
    )
  }
}
