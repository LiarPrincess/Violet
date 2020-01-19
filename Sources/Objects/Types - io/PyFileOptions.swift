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

// MARK: - Encoding

/// https://docs.python.org/3.7/library/codecs.html#standard-encodings
public enum FileEncoding: CustomStringConvertible {
  /// ascii, 646, us-ascii; English
  case ascii
  /// latin_1, iso-8859-1, iso8859-1, 8859, cp819, latin, latin1, L1; Western Europe
  case isoLatin1
  /// utf_8, U8, UTF, utf8; all languages
  case utf8
  /// utf_16, U16, utf16; all languages
  case utf16
  /// utf_16_be, UTF-16BE; all languages
  case utf16BigEndian
  /// utf_16_le, UTF-16LE; all languages
  case utf16LittleEndian
  /// utf_32, U32, utf32; all languages
  case utf32
  /// utf_32_be, UTF-32BE; all languages
  case utf32BigEndian
  /// utf_32_le, UTF-32LE; all languages
  case utf32LittleEndian

  internal static let `default` = Unimplemented.locale.getpreferredencoding

  internal var swift: String.Encoding {
    switch self {
    case .ascii: return .ascii
    case .isoLatin1: return .isoLatin1
    case .utf8: return .utf8
    case .utf16: return .utf16
    case .utf16BigEndian: return .utf16BigEndian
    case .utf16LittleEndian: return .utf16LittleEndian
    case .utf32: return .utf32
    case .utf32BigEndian: return .utf32BigEndian
    case .utf32LittleEndian: return .utf32LittleEndian
    }
  }

  public var description: String {
    switch self {
    case .ascii: return "ascii"
    case .isoLatin1: return "latin-1"
    case .utf8: return "utf-8"
    case .utf16: return "utf-16"
    case .utf16BigEndian: return "utf-16-be"
    case .utf16LittleEndian: return "utf-16-le"
    case .utf32: return "utf-32"
    case .utf32BigEndian: return "utf-32-be"
    case .utf32LittleEndian: return "utf-32-le"
    }
  }

  internal static func from(_ object: PyObject?) -> PyResult<FileEncoding> {
    guard let object = object else {
      return .value(.default)
    }

    guard let str = object as? PyString else {
      return .typeError("encoding must be str, not \(object.typeName)")
    }

    return FileEncoding.from(str.value)
  }

  internal static func from(_ value: String) -> PyResult<FileEncoding> {
    switch value {
    case "ascii", "646", "us-ascii":
      return .value(.ascii)
    case "latin_1", "iso-8859-1", "iso8859-1", "8859", "cp819", "latin", "latin1", "L1":
      return .value(.isoLatin1)
    case "utf_8", "U8", "UTF", "utf8":
      return .value(.utf8)
    case "utf_16", "U16", "utf16":
      return .value(.utf16)
    case "utf_16_be", "UTF-16BE":
      return .value(.utf16BigEndian)
    case "utf_16_le", "UTF-16LE":
      return .value(.utf16LittleEndian)
    case "utf_32", "U32", "utf32":
      return .value(.utf32)
    case "utf_32_be", "UTF-32BE":
      return .value(.utf32BigEndian)
    case "utf_32_le", "UTF-32LE":
      return .value(.utf32LittleEndian)
    default:
      return .unboundLocalError(variableName: "unknown encoding: \(value)")
    }
  }
}

// MARK: - Errors

/// What are we going to do when error happen?
internal enum FileErrorHandler {
  /// Raise UnicodeError (or a subclass); this is the default.
  case strict
  /// Ignore the malformed data and continue without further notice.
  case ignore

  internal static let `default` = FileErrorHandler.strict

  internal static func from(_ object: PyObject?) -> PyResult<FileErrorHandler> {
    guard let object = object else {
      return .value(.default)
    }

    guard let str = object as? PyString else {
      return .typeError("errors have to be str, not \(object.typeName)")
    }

    return FileErrorHandler.from(str.value)
  }

  internal static func from(_ value: String) -> PyResult<FileErrorHandler> {
    switch value {
    case "strict":
      return .value(.strict)
    case "ignore":
      return .value(.ignore)
    default:
      return .lookupError("unknown error handler name '\(value)'")
    }
  }
}
