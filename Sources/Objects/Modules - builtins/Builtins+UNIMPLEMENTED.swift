import Core

// In CPython:
// Python -> builtinmodule.c
// https://docs.python.org/3/library/functions.html

extension Builtins {

  // MARK: - Code

  // sourcery: pymethod = breakpoint
  /// breakpoint(*args, **kws)
  /// See [this](https://docs.python.org/3/library/functions.html#breakpoint)
  public func breakpoint() -> PyObject {
    self.unimplemented(name: "breakpoint")
  }

  // MARK: - Locals, globals, Vars

  // Put this into 'BuiltinFunctions+Locals+Globals+Vars' file.

  // sourcery: pymethod = vars
  /// vars([object])
  /// See [this](https://docs.python.org/3/library/functions.html#vars)
  public func vars() -> PyObject {
    self.unimplemented(name: "vars")
  }

  // MARK: - IO

  // sourcery: pymethod = input
  /// input([prompt])
  /// See [this](https://docs.python.org/3/library/functions.html#input)
  public func input() -> PyObject {
    self.unimplemented(name: "input")
  }

  // MARK: - Other

  // sourcery: pymethod = format
  /// format(value[, format_spec])
  /// See [this](https://docs.python.org/3/library/functions.html#format)
  public func format(value: PyObject, format: PyObject?) -> PyObject {
    self.unimplemented(name: "format")
  }

  // sourcery: pymethod = help
  /// help([object])
  /// See [this](https://docs.python.org/3/library/functions.html#help)
  public func help() -> PyObject {
    self.unimplemented(name: "help")
  }

  // sourcery: pymethod = memoryview
  /// memoryview(obj)
  /// See [this](https://docs.python.org/3/library/functions.html)
  public func memoryview() -> PyObject {
    self.unimplemented(name: "memoryview")
  }

  // MARK: - Unimplemented

  private func unimplemented(name: String) -> Never {
    trap("'builtins.\(name)' is not implemented")
  }
}
