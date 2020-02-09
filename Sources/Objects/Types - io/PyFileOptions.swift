import Foundation

// MARK: - File source

/// Where to find file?
internal enum FileSource {
  /// We already have it.
  case fileDescriptor(Int32)
  /// Path.
  case string(String)
  /// Encoded path.
  case bytes(Data)

  internal static func from(_ object: PyObject) -> PyResult<FileSource> {
    if let int = object as? PyInt,
       let fd = Int32(exactly: int.value) {
      return .value(.fileDescriptor(fd))
    }

    if let string = object as? PyString {
      return .value(.string(string.value))
    }

    if let bytes = object as? PyBytesType {
      return .value(.bytes(bytes.data.scalars))
    }

    let repr = Py.reprOrGeneric(object)
    return .typeError("invalid file: \(repr)")
  }
}

// MARK: - File mode, type

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

/// Binary or text.
public enum FileType {
  /// `b` - binary mode
  case binary
  /// `t` - text mode (default)
  case text

  internal static let `default` = FileType.text
}

/// Parser for `xrwa+tb` string (2nd argument of `open`).
internal struct FileModeParser {

  internal private(set) var mode: FileMode?
  internal private(set) var type: FileType?

  private init() {
    self.mode = nil
    self.type = nil
  }

  internal static func parse(_ object: PyObject?) -> PyResult<FileModeParser> {
    guard let mode = object else {
      return .value(FileModeParser())
    }

    guard let str = mode as? PyString else {
      return .typeError("mode must be str, not \(mode.typeName)")
    }

    return FileModeParser.parse(str.value)
  }

  internal static func parse(_ string: String) -> PyResult<FileModeParser> {
    var result = FileModeParser()
    var preventDuplicates = Set<UnicodeScalar>()

    for s in string.unicodeScalars {
      if preventDuplicates.contains(s) {
        return .valueError("invalid mode: '\(string)'")
      }

      preventDuplicates.insert(s)

      switch s {
      case "x": if let e = result.setMode(.create) { return .error(e) }
      case "r": if let e = result.setMode(.read) { return .error(e) }
      case "w": if let e = result.setMode(.write) { return .error(e) }
      case "a": if let e = result.setMode(.append) { return .error(e) }
      case "+": if let e = result.setMode(.update) { return .error(e) }
      case "t": if let e = result.setType(.text) { return .error(e) }
      case "b": if let e = result.setType(.binary) { return .error(e) }
      case "U": return .deprecationWarning("'U' mode is deprecated")
      default: return .valueError("invalid mode: '\(string)'")
      }
    }

    return .value(result)
  }

  private mutating func setMode(_ mode: FileMode) -> PyBaseException? {
    if self.mode == mode {
      return nil
    }

    guard self.mode == nil else {
      let msg = "must have exactly one of create/read/write/append mode"
      return Py.newValueError(msg: msg)
    }

    self.mode = mode
    return nil
  }

  private mutating func setType(_ type: FileType) -> PyBaseException? {
    if self.type == type {
      return nil
    }

    guard self.type == nil else {
      let msg = "can't have text and binary mode at once"
      return Py.newValueError(msg: msg)
    }

    self.type = type
    return nil
  }
}
