import Foundation
import FileSystem

/// In CPython some values are configured in 'repo_root/configure' script.
/// We don't have that, and it would be weird to just hard-code on by-need basis.
///
/// So… we will move them to separate file.
internal enum Configure {

  internal static var pythonPath: [Path] {
    return []
  }

  internal static func createPrefix(_ py: Py) -> Path {
    let executable = py.config.executablePath
    let dirname = py.fileSystem.dirname(path: executable)
    return dirname.path
  }

  internal static func createExecPrefix(_ py: Py) -> Path {
    return Self.createPrefix(py)
  }

  internal static let pythonVersion = Sys.VersionInfo(
    major: 3,
    minor: 7,
    micro: 2,
    releaseLevel: .final,
    serial: 0
  )

  internal static let implementation = Sys.ImplementationInfo(
    name: "Violet",
    abstract: "Violet - Python VM written in Swift",
    discussion: """
If a client requests it, we shall go anywhere.
Representing the Auto Memoir Doll service,
I am Violet Evergarden.
""",
    version: Sys.VersionInfo(
      major: 0,
      minor: 0,
      micro: 1,
      releaseLevel: .beta,
      serial: 0
    ),
    cacheTag: nil
  )
}
