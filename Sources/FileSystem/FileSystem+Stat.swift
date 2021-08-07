import Foundation
import VioletCore

// This code was based on:
// https://github.com/apple/swift-corelibs-foundation/blob/master/Sources/
// Foundation/FileManager.swift

// MARK: - Struct

public struct Stat {

  public enum EntryType: Equatable {
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
    self.st_mtimespec = stat.st_mtimespec
  }
}

extension FileSystem {

  // MARK: - Func

  public enum StatResult {
    case value(Stat)
    case enoent
    case error(errno: Int32)

    fileprivate init(stat: stat, returnValue: Int32) {
      // On success, zero is returned.
      // On error, -1 is returned, and errno is set appropriately.

      if returnValue == 0 {
        self = .value(Stat(stat: stat))
        return
      }

      assert(returnValue == -1)

      let err = errno
      errno = 0

      switch err {
      case ENOENT:
        self = .enoent
      default:
        self = .error(errno: err)
      }
    }
  }

  public func stat(fd: Int32) -> StatResult {
    // https://linux.die.net/man/2/fstat
    var data = Foundation.stat()
    let returnValue = Foundation.fstat(fd, &data)
    return StatResult(stat: data, returnValue: returnValue)
   }

  /// https://man7.org/linux/man-pages/man2/stat.2.html
  public func stat(path: Path) -> StatResult {
    guard let nonEmpty = NonEmptyPath(from: path) else {
      // $ stat ""
      return .enoent
    }

    var data = Foundation.stat()
    let returnValue = self.withFileSystemRepresentation(path: nonEmpty) {
      // https://linux.die.net/man/2/lstat
      return Foundation.lstat($0, &data)
    }

    return StatResult(stat: data, returnValue: returnValue)
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
