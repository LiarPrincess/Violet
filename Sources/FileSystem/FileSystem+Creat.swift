import Foundation
import VioletCore

extension FileSystem {

  public enum CreatResult {
    case emptyPath
    /// File descriptor.
    case fd(Int32)
    /// Path already exists.
    case eexist
    case error(errno: Int32)

    fileprivate init(errno: Int32) {
      assert(errno != 0)
      switch errno {
      case EEXIST: self = .eexist
      default: self = .error(errno: errno)
      }
    }
  }

  /// The same as `open()` with flags equal to `O_CREAT | O_WRONLY | O_TRUNC`.
  public func creat(path: Path, mode: mode_t? = nil) -> CreatResult {
    guard let nonEmpty = NonEmptyPath(from: path) else {
      return .emptyPath
    }

    let modeToUse = mode ?? (S_IRWXU | S_IRWXG | S_IRWXO)
    return self.withFileSystemRepresentation(path: nonEmpty) { fsRep in
      switch LibC.creat(path: fsRep, mode: modeToUse) {
      case let .value(fd):
        return .fd(fd)
      case let .errno(e):
        return CreatResult(errno: e)
      }
    }
  }
}
