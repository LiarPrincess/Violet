import VioletCore
import VioletObjects

extension VM {

  /// static int
  /// pymain_run_command(wchar_t *command, PyCompilerFlags *cf)
  internal func run(command: String) -> PyResult {
    // From: https://docs.python.org/3.7/using/cmdline.html#cmdoption-c
    // Execute the Python code in 'command'.
    // 'command' can be one or more statements separated by newlines
    // - 1st element of sys.argv will be "-c"
    // - current directory will be added to the start of sys.path
    //   (allowing modules in that directory to be imported as top level modules).
    VM.unimplemented()
  }

  /// static int
  /// pymain_run_module(const wchar_t *modname, int set_argv0)
  internal func run(modulePath: String) -> PyResult {
    // From: https://docs.python.org/3.7/using/cmdline.html#cmdoption-m
    // Search sys.path for the named module and execute its contents
    // as the __main__ module.
    // - 1st element of sys.argv will be the full path to the module file
    //   (while the module file is being located, it will be set to "-m")
    // - As with the -c option, the current directory will be added
    //   to the start of sys.path.
    VM.unimplemented()
  }

  /// Call this method if given functionality is not implemented.
  internal static func unimplemented(fn: StaticString = #function) -> Never {
    trap("Unimplemented '\(fn)'.")
  }
}
