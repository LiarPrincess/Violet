import VioletCore

// In CPython:
// Python -> builtinmodule.c
// https://docs.python.org/3/library/functions.html

extension Builtins {

  // MARK: - Code

  internal static var breakpointDoc: String {
    return """
    breakpoint(*args, **kws)

    Call sys.breakpointhook(*args, **kws).  sys.breakpointhook() must accept
    whatever arguments are passed.

    By default, this drops you into the pdb debugger.
    """
  }

  // sourcery: pymethod = breakpoint
  /// breakpoint(*args, **kws)
  /// See [this](https://docs.python.org/3/library/functions.html#breakpoint)
  internal static func breakpoint() -> PyObject {
    self.unimplemented(name: "breakpoint")
  }

  // MARK: - Locals, globals, Vars

  internal static var varsDoc: String {
    return """
    vars([object]) -> dictionary

    Without arguments, equivalent to locals().
    With an argument, equivalent to object.__dict__.
    """
  }

  // sourcery: pymethod = vars
  /// vars([object])
  /// See [this](https://docs.python.org/3/library/functions.html#vars)
  internal static func vars() -> PyObject {
    self.unimplemented(name: "vars")
  }

  // MARK: - IO

  internal static var inputDoc: String {
    return """
    Read a string from standard input.  The trailing newline is stripped.

    The prompt string, if given, is printed to standard output without a
    trailing newline before reading input.

    If the user hits EOF (*nix: Ctrl-D, Windows: Ctrl-Z+Return), raise EOFError.
    On *nix systems, readline is used if available.
    """
  }

  // sourcery: pymethod = input
  /// input([prompt])
  /// See [this](https://docs.python.org/3/library/functions.html#input)
  internal static func input() -> PyObject {
    self.unimplemented(name: "input")
  }

  // MARK: - Other

  internal static var formatDoc: String {
    return """
    Return value.__format__(format_spec)

    format_spec defaults to the empty string.
    See the Format Specification Mini-Language section of help('FORMATTING') for
    details.
    """
  }

  // sourcery: pymethod = format
  /// format(value[, format_spec])
  /// See [this](https://docs.python.org/3/library/functions.html#format)
  internal static func format(value: PyObject, format: PyObject?) -> PyObject {
    self.unimplemented(name: "format")
  }

  // sourcery: pymethod = help
  /// help([object])
  /// See [this](https://docs.python.org/3/library/functions.html#help)
  internal static func help() -> PyObject {
    self.unimplemented(name: "help")
  }

  // MARK: - Unimplemented

  private static func unimplemented(name: String) -> Never {
    trap("'builtins.\(name)' is not implemented")
  }
}
