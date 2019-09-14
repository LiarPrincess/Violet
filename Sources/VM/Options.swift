import SPMUtility

// Descriptions taken from: https://docs.python.org/3.7/using/cmdline.html

public enum OptimizationLevel: Equatable {
  /// No optimizations.
  case none
  /// Remove assert statements and any code conditional on the value of `__debug__`.
  /// Command line: `-O`.
  case O
  /// Do `-O` and also discard `docstrings`.
  /// Command line: `-OO`.
  case OO
}

public enum WarningOptions: Equatable, ArgumentKind {
  /// `-Wignore` - Never warn
  case ignore
  /// Print to `sys.stderr` (default).
  case print
  /// `-Werror` - Convert every warning an error
  case error

  public static var completion: ShellCompletion {
    return .values([
      ("ignore", "Never warn"),
      ("print", "Print to `sys.stderr` (default)."),
      ("error", "Convert every warning an error")
    ])
  }

  public init(argument: String) throws {
    switch argument {
    case "ignore": self = .ignore
    case "print": self = .print
    case "error": self = .error
    default:
      throw ArgumentConversionError
        .typeMismatch(value: argument, expectedType: WarningOptions.self)
    }
  }
}

public enum ByteCompareOptions: Equatable {
  /// Ignore comparison of `bytes` or `bytearray` with `str` or `bytes` with `int`.
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

public struct Options: Equatable {

  /// `-c <command>`
  ///
  /// Execute the Python code in `command`.
  /// `command` can be one or more statements separated by newlines,
  /// with significant leading whitespace as in normal module code.
  public var command: String?

  /// `-m <module-name>`
  ///
  /// Search sys.path for the named module and execute its contents
  /// as the `__main__` module.
  public var module: String?

  /// `<script>`
  ///
  /// Execute the Python code contained in `script`,
  /// which must be a filesystem path (absolute or relative)
  /// referring to either a Python file,
  /// or a directory containing a `__main__.py` file.
  public var script: String?

  /// `-v --version`
  ///
  /// Print the `Violet` version number and exit.
  /// Example output could be: `Violet 1.0`.
  public var version: Bool = false

  /// `-d`
  ///
  ///  Turn on debugging output.
  public var debug: Bool = false

  /// `-b -bb`
  ///
  /// Issue a warning when comparing `bytes` or `bytearray` with `str`
  /// or bytes with int.
  /// Issue an error when the option is given twice (`-bb`).
  public var byteCompare: ByteCompareOptions = .ignore

  /// -i
  ///
  /// When a script is passed as first argument or the `-c` option is used,
  /// enter interactive mode after executing the script or the command,
  /// even when `sys.stdin` does not appear to be a terminal.
  public var enterInteractiveAfterExecuting: Bool = false

  /// `-O -OO`
  public var optimization: OptimizationLevel = .none

  /// `-q`
  ///
  ///  Don’t display the copyright and version messages even in interactive mode.
  public var quiet: Bool = false

  /// `-h -help --help`
  ///
  /// Display available options.
  public var help: Bool = false

  /// `-Werror -Wignore`
  ///
  /// Warning control.
  /// By default prints warning messages to `sys.stderr`.
  public var warnings: WarningOptions = .print
}
