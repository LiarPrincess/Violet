import Foundation
import Compiler
import Objects

// In CPython:
// Python -> pystate.h
// Modules -> main.c
//   config_init_program_name(_PyCoreConfig *config) <- program name
//   config_read_env_vars(_PyCoreConfig *config) <- env path
//   config_init_path_config(_PyCoreConfig *config) <- path
//   config_init_warnoptions(_PyCoreConfig *config, ...) <- warnings
//   pymain_init_core_argv(_PyMain *pymain, _PyCoreConfig *config, ...) <- arg0
// Modules -> getpath.c
//   calculate_program_full_path(const _PyCoreConfig *core_config, ...)  <- executable

internal protocol CoreConfigurationDeps {
  var bundleURL: URL { get }
  var executablePath: String? { get }
  func fileExists(atPath path: String) -> Bool
}

private final class CoreConfigurationDepsImpl: CoreConfigurationDeps {

  fileprivate var bundleURL: URL {
    return Bundle.main.bundleURL
  }

  fileprivate var executablePath: String? {
    return Bundle.main.executablePath
  }

  fileprivate func fileExists(atPath path: String) -> Bool {
    return FileManager.default.fileExists(atPath: path)
  }
}

internal final class CoreConfiguration {

  /// `argv[0]` or ""
  internal var programName: String

  /// `sys.executable`
  ///
  /// A string giving the absolute path of the executable binary for the Python
  /// interpreter.
  internal var executable: String

  /// A list of strings that specifies the search path for modules.
  /// Initialized from the environment variables `VIOLETPATH`,
  /// plus an installation-dependent default.
  ///
  /// As initialized upon program startup, the first item of this list,
  /// `path[0]`, is the directory containing the script that was used to invoke
  /// the Python interpreter.
  /// If the script directory is not available (e.g. if the interpreter
  /// is invoked interactively or if the script is read from standard input),
  /// `path[0]` is the empty string, which directs Python to search modules
  /// in the current directory first.
  /// Notice that the script directory is inserted before the entries inserted
  /// as a result of PYTHONPATH.
  internal var moduleSearchPaths: [String]
  /// `PYTHONPATH` environment variable
  ///
  /// Augment the default search path for module files.
  ///
  /// The format is the same as the shell’s PATH:
  /// one or more directory pathnames separated by `os.pathsep`
  /// (e.g. colons on Unix or semicolons on Windows).
  /// Non-existent directories are silently ignored.
  /// The search path can be manipulated from within a Python program
  /// as the variable `sys.path`.
  internal var moduleSearchPathsEnv: [String]

  /// `-Wdefault -Werror -Walways -Wmodule -Wonce -Wignore` command line arguments
  /// and also `PYTHONWARNINGS=arg` environment variable.
  ///
  /// Warnings are stored in reverse priority order which means
  /// that highest priority warning is placed last in the array.
  internal var warnings: [WarningOption]
  /// `-b -bb` command line arguments.
  ///
  /// Issue a warning when comparing `bytes` or `bytearray` with `str`
  /// or bytes with int.
  /// Issue an error when the option is given twice (`-bb`).
  internal var bytesWarning: BytesWarningOption

  /// `-O -OO` command line argument and `PYTHONOPTIMIZE` environment variable.
  internal var optimize: OptimizationLevel = .none

  /// `sys.argv`
  internal var arguments: Arguments

  /// `-d` command line argument and `PYTHONDEBUG` environment variable.
  ///
  ///  Turn on debugging output.
  internal var debug: Bool

  /// `-q` command line argument
  ///
  ///  Don’t display the copyright and version messages even in interactive mode.
  internal var quiet: Bool

  /// `-i` command line argument and `PYTHONINSPECT` environment variable.
  ///
  /// When a script is passed as first argument or the `-c` option is used,
  /// enter interactive mode after executing the script or the command,
  /// even when `sys.stdin` does not appear to be a terminal.
  internal var inspectInteractively: Bool

  /// `-E` command line argument.
  ///
  /// Ignore all `PYTHON*` environment variables,
  /// e.g. `PYTHONPATH` and `PYTHONHOME`, that might be set.
  internal var ignoreEnvironment: Bool

  /// `-I` command line argument.
  ///
  /// Run Python in isolated mode. This also implies `-E` and `-s`.
  /// In isolated mode `sys.path` contains neither the script’s directory
  /// nor the user’s site-packages directory.
  /// All `PYTHON*` environment variables are ignored, too.
  internal var isolated: Bool

  // TODO: Verbose

  internal init(
    arguments: Arguments,
    environment: Environment,
    dependencies: CoreConfigurationDeps = CoreConfigurationDepsImpl()
  ) {
    let env: Environment? = arguments.ignoreEnvironment ? nil : environment

    let programName = arguments.raw.first ?? ""
    self.arguments = arguments
    self.programName = programName
    self.executable = dependencies.executablePath ?? programName

    self.moduleSearchPathsEnv = env?.violetPath ?? []
    self.moduleSearchPaths = getModuleSearchPaths(
      environment: env,
      dependencies: dependencies
    )

    // The priority order for warnings configuration is (highest first):
    // - the BytesWarning filter, if needed ('-b', '-bb')
    // - any '-W' command line options; then
    // - the 'PYTHONWARNINGS' environment variable;
    self.bytesWarning = arguments.bytesWarning
    self.warnings = arguments.warnings + (env?.warnings ?? [])

    self.debug = arguments.debug || (env?.debug ?? false)
    self.quiet = arguments.quiet
    self.inspectInteractively = arguments.inspectInteractively
                             || (env?.inspectInteractively ?? false)
    self.ignoreEnvironment = arguments.ignoreEnvironment
    self.isolated = arguments.isolated

    self.optimize = Swift.max(arguments.optimize, env?.optimize ?? .none)
  }
}

private func getModuleSearchPaths(
  environment: Environment?,
  dependencies: CoreConfigurationDeps
) -> [String] {
  var result = [String]()

  if let env = environment {
    result.append(contentsOf: env.violetPath)
  }

  // Search from bundleURL (this will add 'Lib' directory in our repository
  // root, it is more similiar to how PyPy locates stdlib, but whatever...).
  var url = dependencies.bundleURL

  var depth = 0
  let maxDepth = url.pathComponents.count

  while depth < maxDepth {
    result.append(url.path)
    url.deleteLastPathComponent()
    depth += 1
  }

  return result
}
