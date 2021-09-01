import Foundation
import VioletCore

extension FileSystem {

  // MARK: - Mkdir

  public enum MkdirResult {
    case emptyPath
    case ok
    /// Parent directory does not exist.
    case enoent
    /// Directory already exists.
    case eexist
    case error(errno: Int32)

    fileprivate init(errno: Int32) {
      assert(errno != 0)
      switch errno {
      case ENOENT: self = .enoent
      case EEXIST: self = .eexist
      default: self = .error(errno: errno)
      }
    }
  }

  /// Create a directory.
  public func mkdir(path: Path, mode: mode_t? = nil) -> MkdirResult {
    return self.mkdir(string: path.string, mode: mode)
  }

  /// Create a directory.
  public func mkdir<S: StringProtocol>(string: S, mode: mode_t?) -> MkdirResult {
    // We could make some fancy wrapper for 'mode',
    // but you are going to use '0o666' anyway.
    guard let nonEmpty = NonEmptyPath(from: string) else {
      return .emptyPath
    }

    let modeToUse = mode ?? (S_IRWXU | S_IRWXG | S_IRWXO)
    return self.withFileSystemRepresentation(path: nonEmpty) { fsRep in
      switch LibC.mkdir(path: fsRep, mode: modeToUse) {
      case .ok: return .ok
      case .errno(let err): return MkdirResult(errno: err)
      }
    }
  }

  // MARK: - Mkdir rec

  public enum MkdirpResult {
    case ok
    /// Directory already exists.
    case eexist
    /// We created parent, but it was removed when we tried to create child.
    case parentRemovedAfterCreation(Path)
    case error(Path, errno: Int32)
  }

  /// Create a directory (along with all parents).
  public func mkdirp(path: Path, mode: mode_t? = nil) -> MkdirpResult {
    enum LastMkdirResult {
      case ok
      case eexist
    }

    // We need this to create last directory
    var s = path.string
    if !s.hasSuffix("/") {
      s.append("/")
    }

    var lastMkdirResult = LastMkdirResult.ok

    var index = s.startIndex
    while index != s.endIndex {
      let ch = s[index]
      guard self.isPathSeparator(char: ch) else {
        s.formIndex(after: &index)
        continue
      }

      let subPath = s[..<index]
      switch self.mkdir(string: subPath, mode: mode) {
      case .emptyPath: break // 'path' starts with '/'
      case .ok: lastMkdirResult = .ok // Directory created
      case .enoent: return .parentRemovedAfterCreation(Path(string: subPath))
      case .eexist: lastMkdirResult = .eexist // Already exists
      case .error(errno: let e): return .error(Path(string: subPath), errno: e)
      }

      s.formIndex(after: &index)
    }

    switch lastMkdirResult {
    case .ok: return .ok
    case .eexist: return .eexist
    }
  }

  public enum MkdirpOrTrapResult {
    case ok
    case eexist
  }

  /// Create a directory (along with all parents).
  public func mkdirpOrTrap(path: Path, mode: mode_t? = nil) -> MkdirpOrTrapResult {
    switch self.mkdirp(path: path, mode: mode) {
    case .ok:
      return .ok
    case .eexist:
      return .eexist
    case let .parentRemovedAfterCreation(p):
      trap("Unable to mkdirp: Parent was removed after creating: \(p)")
    case let .error(p, errno: err):
      let msg = String(errno: err) ?? "Unknown error"
      trap("Unable to mkdirp: \(msg): \(p)")
    }
  }
}
