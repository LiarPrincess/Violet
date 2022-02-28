/* MARKER
import VioletCompiler

// cSpell:ignore pystate

// In CPython:
// Python -> sysmodule.c
// Python -> pystate.h
// Modules -> main.c
//   config_init_program_name(_PyCoreConfig *config) <- program name
//   config_init_warnoptions(_PyCoreConfig *config, ...) <- warnings
// Modules -> getpath.c
//   calculate_program_full_path(const _PyCoreConfig *core_config, ...)  <- executable

// Doc:
// https://docs.python.org/3/library/sys.html#sys.flags

extension Sys {

  public struct Flags {

    private let arguments: Arguments
    private let _environment: Environment

    private var environment: Environment? {
      if self.ignoreEnvironment {
        return nil
      }

      return self._environment
    }

    internal init(arguments: Arguments, environment: Environment) {
      self.arguments = arguments
      self._environment = environment
    }

    // MARK: - Debug

    public var debug: Bool {
      let env = self.environment?.debug ?? false
      return self.arguments.debug || env
    }

    // MARK: - Inspect

    public var inspect: Bool {
      let env = self.environment?.inspectInteractively ?? false
      return self.arguments.inspectInteractively || env
    }

    // MARK: - Interactive

    public var interactive: Bool {
      let env = self.environment?.inspectInteractively ?? false
      return self.arguments.inspectInteractively || env
    }

    // MARK: - Optimize

    public var optimize: Compiler.OptimizationLevel {
      let env = self.environment?.optimize ?? .none
      return Swift.max(self.arguments.optimize, env)
    }

    // MARK: - Ignore environment

    public var ignoreEnvironment: Bool {
      return self.arguments.ignoreEnvironment
    }

    // MARK: - Verbose

    public var verbose: Int {
      let env = self.environment?.verbose ?? 0
      return Swift.max(self.arguments.verbose, env)
    }

    // MARK: - Warnings

    /// Warning options.
    ///
    /// Order: the LATER in the list the bigger the priority.
    public var warnings: [WarningOption] {
      // Comment from CPython 'config_init_warnoptions':
      //
      // The priority order for warnings configuration is (highest first):
      // - any '-W' command line options; then
      // - the 'PYTHONWARNINGS' environment variable;
      //
      // Since the warnings module works on the basis of
      // "the most recently added filter will be checked first", we add
      // the lowest precedence entries first so that later entries override them.

      let env = (self.environment?.warnings ?? [])
      return env + self.arguments.warnings
    }

    public var bytesWarning: BytesWarningOption {
      return self.arguments.bytesWarning
    }

    // MARK: - Quiet

    public var quiet: Bool {
      return self.arguments.quiet
    }

    // MARK: - Isolated

    public var isolated: Bool {
      return self.arguments.isolated
    }
  }
}

*/