import Foundation
import VioletCore

// This code was based on:
// https://github.com/apple/swift-corelibs-foundation/blob/master/Sources/
// Foundation/FileManager.swift

// MARK: - Struct

public struct Stat {

  public enum EntryType: Equatable, CustomStringConvertible {
    case directory
    case regularFile
    case symbolicLink
    case socket
    /// Character special file (a device like a terminal).
    case characterSpecial
    /// Block special file (a device like a disk).
    case blockSpecial
    /// FIFO or pipe
    case fifo
    case unknown

    public var description: String {
      switch self {
      case .directory: return "Directory"
      case .regularFile: return "Regular file"
      case .symbolicLink: return "Symbolic link"
      case .socket: return "Socket"
      case .characterSpecial: return "Character special file"
      case .blockSpecial: return "Block special file"
      case .fifo: return "FIFO"
      case .unknown: return "unknown"
      }
    }
  }

  /// File type and mode.
  public let st_mode: mode_t
  /// Time of last modification.
  public let st_mtimespec: timespec

  public var type: EntryType {
    // https://www.gnu.org/software/libc/manual/html_node/Testing-File-Type.html
    switch self.st_mode & S_IFMT {
    case S_IFREG: return .regularFile
    case S_IFDIR: return .directory
    case S_IFCHR: return .characterSpecial
    case S_IFBLK: return .blockSpecial
    case S_IFIFO: return .fifo
    case S_IFLNK: return .symbolicLink
    case S_IFSOCK: return .socket
    default: return .unknown
    }
  }

  public init(st_mode: mode_t, st_mtimespec: timespec) {
    self.st_mode = st_mode
    self.st_mtimespec = st_mtimespec
  }

  public init(stat: Foundation.stat) {
    self.st_mode = stat.st_mode

    #if canImport(Darwin)
    self.st_mtimespec = stat.st_mtimespec
    #elseif canImport(Glibc)
    self.st_mtimespec = stat.st_mtim
    #endif
  }
}

extension FileSystem {

  // MARK: - Func

  public enum StatResult {
    case value(Stat)
    case enoent
    case error(errno: Int32)

    fileprivate init(result: LibC.StatResult, data: stat) {
      switch result {
      case .ok:
        let s = Stat(stat: data)
        self = .value(s)
      case .errno(let err):
        switch err {
        case ENOENT:
          self = .enoent
        default:
          self = .error(errno: err)
        }
      }
    }
  }

  public func stat(fd: Int32) -> StatResult {
    var data = LibC.createStat()
    let result = LibC.fstat(fd: fd, buf: &data)
    return StatResult(result: result, data: data)
  }

  public func stat(path: Path) -> StatResult {
    guard let nonEmpty = NonEmptyPath(from: path) else {
      // $ stat ""
      return .enoent
    }

    var data = LibC.createStat()
    let result = self.withFileSystemRepresentation(path: nonEmpty) {
      return LibC.lstat(path: $0, buf: &data)
    }

    return StatResult(result: result, data: data)
  }

  public func statOrTrap(path: Path) -> Stat {
    switch self.stat(path: path) {
    case .value(let s):
      return s
    case .enoent:
      trap("Unable to stat: No such file or directory: \(path)")
    case .error(let err):
      let msg = String(errno: err) ?? "Unknown error"
      trap("Unable to stat: \(msg): \(path)")
    }
  }

  // MARK: - Exists

  /// The following method has limited utility.
  ///
  /// Attempting to predicate behavior based on the current state of the filesystem
  /// or a particular file on the filesystem is encouraging odd behavior in the face
  /// of filesystem race conditions.
  ///
  /// It's far better to attempt an operation (like loading a file or creating a
  /// directory) and handle the error gracefully than it is to try to figure out
  /// ahead of time whether the operation will succeed.
  public func exists(path: Path) -> Bool {
    return self.fileManager.fileExists(atPath: path.string)
  }
}
