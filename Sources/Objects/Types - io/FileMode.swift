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
