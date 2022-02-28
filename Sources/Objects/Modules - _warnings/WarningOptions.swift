/* MARKER
public enum WarningOption: Equatable, CustomStringConvertible {
  /// `-Wdefault` - Warn once per call location
  case `default`
  /// `-Werror` - Convert to exceptions
  case error
  /// `-Walways` - Warn every time
  case always
  /// `-Wmodule` - Warn once per calling module
  case module
  /// `-Wonce` - Warn once per Python process
  case once
  /// `-Wignore` - Never warn
  case ignore

  public var description: String {
    switch self {
    case .default: return "default"
    case .error: return "error"
    case .always: return "always"
    case .module: return "module"
    case .once: return "once"
    case .ignore: return "ignore"
    }
  }
}

public enum BytesWarningOption: Equatable {
  /// Ignore comparison of `bytes` or `bytearray` with `str`
  /// or `bytes` with `int` (default).
  case ignore
  /// Issue a warning when comparing `bytes` or `bytearray` with `str`
  /// or `bytes` with `int`.
  /// Command line: `-b`.
  case warning
  /// Issue a error when comparing `bytes` or `bytearray` with `str`
  /// or `bytes` with `int`.
  /// Command line: `-bb`.
  case error
}

*/