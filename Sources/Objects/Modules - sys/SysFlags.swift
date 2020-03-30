import Compiler

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

public struct SysFlags {

  private var arguments: Arguments {
    return Py.config.arguments
  }

  private var environment: Environment? {
    if self.ignoreEnvironment {
      return nil
    }

    return Py.config.environment
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

  public var optimize: OptimizationLevel {
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

  // MARK: - Bytes warning

  public var bytesWarning: BytesWarningOption {
    return self.arguments.bytesWarning
  }

  // MARK: - Quiet

  public var quiet: Bool {
    return false
  }

  // MARK: - Isolated

  public var isolated: Bool {
    return self.arguments.quiet
  }
}
