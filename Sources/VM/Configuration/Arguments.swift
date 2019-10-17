import SPMUtility
import Compiler

// Descriptions taken from: https://docs.python.org/3.7/using/cmdline.html

public struct Arguments: Equatable {

  /// `-h -help --help`
  ///
  /// Display available options.
  public var printHelp: Bool = false

  /// `-v --version`
  ///
  /// Print the `Violet` version number and exit.
  /// Example output could be: `Violet 1.0`.
  public var printVersion: Bool = false

  /// `-d`
  ///
  ///  Turn on debugging output.
  public var debug: Bool = false

  /// `-q`
  ///
  ///  Don’t display the copyright and version messages even in interactive mode.
  public var quiet: Bool = false

  /// -i
  ///
  /// When a script is passed as first argument or the `-c` option is used,
  /// enter interactive mode after executing the script or the command,
  /// even when `sys.stdin` does not appear to be a terminal.
  public var inspectInteractively: Bool = false

  /// `-E`
  ///
  /// Ignore all `PYTHON*` environment variables,
  /// e.g. `PYTHONPATH` and `PYTHONHOME`, that might be set.
  public var ignoreEnvironment: Bool = false

  /// `-I`
  ///
  /// Run Python in isolated mode. This also implies `-E` and `-s`.
  /// In isolated mode `sys.path` contains neither the script’s directory
  /// nor the user’s site-packages directory.
  /// All `PYTHON*` environment variables are ignored, too.
  public var isolated: Bool = false

  /// `-S`
  ///
  /// Disable the import of the module site and the site-dependent manipulations
  /// of `sys.path` that it entails.
  /// Also disable these manipulations if site is explicitly imported later
  /// (call `site.main()` if you want them to be triggered).
  public var noSite: Bool = false

  /// `-s`
  ///
  /// Don’t add the user site-packages directory to `sys.path`.
  /// See also 'PEP 370 – Per user site-packages directory'.
  public var noUserSite: Bool = false

  /// `-O -OO`
  public var optimization: OptimizationLevel = .none

  /// `-Werror -Wignore etc.`
  ///
  /// Warning control.
  /// By default prints warning messages to `sys.stderr`.
  public var warnings: [WarningOption] = []

  /// `-b -bb`
  ///
  /// Issue a warning when comparing `bytes` or `bytearray` with `str`
  /// or bytes with int.
  /// Issue an error when the option is given twice (`-bb`).
  public var bytesWarning: BytesWarningOption = .ignore

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

  /// Arguments just as entered in command line (used for `sys.argv`).
  public var raw: [String] = []

  /// Use arguments with predefined values.
  public init() { }

  /// Parse specified command line arguments.
  public init(from arguments: [String]) throws {
    let parser = ArgumentParser()
    self = try parser.parse(arguments: arguments)
  }

  internal func getUsage() -> String {
    let parser = ArgumentParser()
    return parser.getUsage()
  }
}
