import Foundation
import FileSystem

// Descriptions taken from: https://docs.python.org/3.7/using/cmdline.html

// In CPython:
// Modules -> main.c
//  cmdline_get_env_flags(_PyCmdline *cmdline)

public struct Environment {

  /// Separator for PATH environment variable.
  /// CPython: `DELIM`
  internal static var pathSeparator: Character {
    #if os(Windows)
    return ";"
    #else
    return ":"
    #endif
  }

  /// VIOLETHOME
  ///
  /// Change the location of the standard Python libraries.
  /// By default (when `violetHome` is empty), Violet will traverse from
  /// `currentWorkingDirectory` to file system root looking for `lib` directory.
  public var violetHome: Path?

  /// VIOLETPATH
  ///
  /// Augment the default search path for module files.
  ///
  /// The format is the same as the shell’s `PATH`: one or more directory
  /// pathnames separated by `os.pathsep` (e.g. colons on Unix or semicolons on Windows).
  ///
  /// Non-existent directories are silently ignored.
  /// The search path can be manipulated from within a Python program
  /// as the variable `sys.path`.
  public var violetPath = Configure.pythonPath

  /// PYTHONOPTIMIZE
  ///
  /// If this is set to a non-empty string it is equivalent to specifying
  /// the `-O` option.
  /// If set to an integer, it is equivalent to specifying `-O` multiple times.
  public var optimize = Py.OptimizationLevel.none

  /// PYTHONWARNINGS
  ///
  /// This is equivalent to the `-W` option.
  ///
  /// If set to a comma separated string, it is equivalent to specifying `-W`
  /// multiple times, with filters later in the list taking precedence over
  /// those earlier in the list.
  public var warnings = [Arguments.WarningOption]()

  /// PYTHONDEBUG
  ///
  /// If this is set to a non-empty string it is equivalent to specifying
  /// the `-d` option.
  public var debug = false

  /// PYTHONINSPECT
  ///
  /// If this is set to a non-empty string it is equivalent to specifying
  /// the `-i` option.
  ///
  /// This variable can also be modified by Python code using `os.environ` to
  /// force inspect mode on program termination.
  public var inspectInteractively = false

  /// PYTHONVERBOSE
  ///
  /// If this is set to a non-empty string it is equivalent to specifying
  /// the `-v` option.
  /// If set to an integer, it is equivalent to specifying -v multiple times.
  public var verbose = 0

  /// Use default environment.
  public init() {}

  /// Create environment parsed from given dictionary.
  ///
  /// - Parameter pathSeparator: Separator used for `PATH`.
  ///   By default colon on Unix and semicolon on Windows.
  public init(from environment: [String: String]) {
    for (key, value) in environment {
      switch key {
      case "VIOLETHOME":
        // We don't support 'prefix:exec_prefix' notation, we only have prefix.
        self.violetHome = splitPath(value).first
      case "VIOLETPATH":
        self.violetPath = splitPath(value)
      case "PYTHONOPTIMIZE":
        let isInt = asInt(value) != nil
        self.optimize = isInt ? .OO : .O
      case "PYTHONWARNINGS":
        self.warnings = parseWarnings(value)
      case "PYTHONDEBUG":
        self.debug = true
      case "PYTHONINSPECT":
        self.inspectInteractively = true
      case "PYTHONVERBOSE":
        let int = asInt(value) ?? 1
        self.verbose = Swift.max(int, 1)
      default:
        break
      }
    }
  }
}

private func splitPath(_ path: String) -> [Path] {
  var result = [Path]()

  let values = path.split(separator: Environment.pathSeparator)
  for substring in values {
    let string = String(substring)
    result.append(Path(string: string))
  }

  return result
}

private func parseWarnings(_ value: String) -> [Arguments.WarningOption] {
  return value
    .split(separator: ",")
    .compactMap { split in
      switch split {
      case "default": return .default
      case "error": return .error
      case "always": return .always
      case "module": return .module
      case "once": return .once
      case "ignore": return .ignore
      default: return nil
      }
    }
}

private func asInt(_ value: String) -> Int? {
  return Int(value)
}
