import Foundation
import Compiler

// Descriptions taken from: https://docs.python.org/3.7/using/cmdline.html

// In CPython:
// Modules -> main.c
//  cmdline_get_env_flags(_PyCmdline *cmdline)

public struct Environment {

  /// `PATH`
  public var PATH: [String] = []

  /// VIOLETPATH (has precedence over `PYTHONPATH`)
  ///
  /// Augment the default search path for module files.
  ///
  /// The format is the same as the shell’s PATH: one or more directory
  /// pathnames separated by `os.pathsep` (e.g. colons on Unix or semicolons on Windows).
  ///
  /// Non-existent directories are silently ignored.
  /// The search path can be manipulated from within a Python program
  /// as the variable `sys.path`.
  public var violetPath: [String] = []

  /// PYTHONPATH
  ///
  /// Augment the default search path for module files.
  ///
  /// The format is the same as the shell’s PATH: one or more directory
  /// pathnames separated by `os.pathsep` (e.g. colons on Unix or semicolons on Windows).
  ///
  /// Non-existent directories are silently ignored.
  /// The search path can be manipulated from within a Python program
  /// as the variable `sys.path`.
  public var pythonPath: [String] = []

  /// PYTHONOPTIMIZE
  ///
  /// If this is set to a non-empty string it is equivalent to specifying
  /// the `-O` option.
  /// If set to an integer, it is equivalent to specifying `-O` multiple times.
  public var pythonOptimize: OptimizationLevel = .none

  /// PYTHONWARNINGS
  ///
  /// This is equivalent to the `-W` option.
  ///
  /// If set to a comma separated string, it is equivalent to specifying `-W`
  /// multiple times, with filters later in the list taking precedence over
  /// those earlier in the list.
  public var pythonWarnings: [WarningOption] = []

  /// PYTHONNOUSERSITE
  ///
  /// Don’t add the user site-packages directory to `sys.path`.
  /// See also 'PEP 370 – Per user site-packages directory'.
  public var pythonNoUserSite: Bool = false

  /// PYTHONDEBUG
  ///
  /// If this is set to a non-empty string it is equivalent to specifying
  /// the `-d` option.
  public var pythonDebug: Bool = false

  /// PYTHONINSPECT
  ///
  /// If this is set to a non-empty string it is equivalent to specifying
  /// the `-i` option.
  ///
  /// This variable can also be modified by Python code using `os.environ` to
  /// force inspect mode on program termination.
  public var pythonInspectInteractively: Bool = false

  /// Use default environment.
  public init() { }

  /// Create environment parsed from given dictionary.
  public init(from environment: [String: String]) {
    for (key, value) in environment {
      if value.isEmpty {
        continue
      }

      switch key {
      case "PATH":
        self.PATH = splitPATH(value)
      case "VIOLETPATH":
        self.violetPath = splitPATH(value)
      case "PYTHONPATH":
        self.pythonPath = splitPATH(value)
      case "PYTHONOPTIMIZE":
        let isInt = Int(value) != nil
        self.pythonOptimize = isInt ? .OO : .O
      case "PYTHONWARNINGS":
        self.pythonWarnings = parseWarnings(value)
      case "PYTHONDEBUG":
        self.pythonDebug = true
      case "PYTHONINSPECT":
        self.pythonInspectInteractively = true
      case "PYTHONNOUSERSITE":
        self.pythonNoUserSite = true
      default:
        break
      }
    }
  }
}

private func splitPATH(_ path: String) -> [String] {
  return path
    .split(separator: Constants.PATHSep)
    .map { String($0) }
}

private func parseWarnings(_ arg: String) -> [WarningOption] {
  return arg
    .split(separator: ",")
    .compactMap { split in
      switch split {
      case "default":  return .default
      case "error":    return .error
      case "always":   return .always
      case "module":   return .module
      case "once":     return .once
      case "ignore":   return .ignore
      default: return nil
      }
    }
}
