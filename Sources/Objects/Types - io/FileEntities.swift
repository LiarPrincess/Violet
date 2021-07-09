import Foundation

// cSpell:ignore xrwa

// MARK: - Stat

/// Basically a `stat`, but with only the stuff we need.
public struct FileStat {

  /// File type & permissions.
  ///
  /// https://www.gnu.org/software/libc/manual/html_node/Testing-File-Type.html
  public let st_mode: mode_t
  /// Modification time.
  public let st_mtimespec: timespec

  public var isRegularFile: Bool {
    return (self.st_mode & S_IFMT) == S_IFREG
  }

  public var isDirectory: Bool {
    return (self.st_mode & S_IFMT) == S_IFDIR
  }

  public init(st_mode: mode_t, st_mtime: timespec) {
    self.st_mode = st_mode
    self.st_mtimespec = st_mtime
  }
}

// MARK: - File mode

/// What are we going to do with file?
public enum FileMode: CustomStringConvertible {
  /// `r` - open for reading (default)
  case read
  /// `w` - open for writing, truncating the file first
  case write
  /// `x` - create a new file and open it for writing
  case create
  /// `a` - open for writing, appending to the end of the file if it exists
  case append
  /// `+`  - open a disk file for updating (reading and writing)
  case update

  internal static let `default` = FileMode.read

  public var description: String {
    switch self {
    case .read: return "read"
    case .write: return "write"
    case .create: return "create"
    case .append: return "append"
    case .update: return "update"
    }
  }

  internal var flag: String {
    switch self {
    case .read: return "r"
    case .write: return "w"
    case .create: return "x"
    case .append: return "a"
    case .update: return "+"
    }
  }
}
