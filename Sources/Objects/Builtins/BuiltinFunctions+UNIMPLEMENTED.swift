import Core

// In CPython:
// Python -> builtinmodule.c
// https://docs.python.org/3/library/functions.html

extension BuiltinFunctions {

  // MARK: - Code
/*
  // sourcery: pymethod = eval
  /// eval(expression[, globals[, locals]])
  /// See [this](https://docs.python.org/3/library/functions.html#eval)
  public func eval() -> PyObject {
    return self.unimplemented
  }

   // sourcery: pymethod = breakpoint
  /// breakpoint(*args, **kws)
  /// See [this](https://docs.python.org/3/library/functions.html#breakpoint)
  public func breakpoint() -> PyObject {
    return self.unimplemented
  }
*/

  // MARK: - Locals, globals, Vars
/*
  // Put this into 'BuiltinFunctions+Locals+Globals+Vars' file.

  // sourcery: pymethod = vars
  /// vars([object])
  /// See [this](https://docs.python.org/3/library/functions.html#vars)
  public func vars() -> PyObject {
    return self.unimplemented
  }
*/

  // MARK: - IO
/*
  // sourcery: pymethod = input
  /// input([prompt])
  /// See [this](https://docs.python.org/3/library/functions.html#input)
  public func input() -> PyObject {
    return self.unimplemented
  }
*/

  // MARK: - Other
/*
  // sourcery: pymethod = format
  /// format(value[, format_spec])
  /// See [this](https://docs.python.org/3/library/functions.html#format)
  public func format() -> PyObject {
    return self.unimplemented
  }

  // sourcery: pymethod = help
  /// help([object])
  /// See [this](https://docs.python.org/3/library/functions.html#help)
  public func help() -> PyObject {
    return self.unimplemented
  }

  // sourcery: pymethod = memoryview
  /// memoryview(obj)
  /// See [this](https://docs.python.org/3/library/functions.html)
  public func memoryview() -> PyObject {
    return self.unimplemented
  }
*/

  // MARK: - Other

  internal func callDir(_ fn: PyObject, args: [PyObject?]) -> DirResult {
    self.unimplemented()
  }

  public func PyObject_Format(value: PyObject, format: PyObject?) -> PyObject {
    self.unimplemented()
  }

  // MARK: - Unimplemented

  private func unimplemented(fn: StaticString = #function) -> Never {
    trap("'\(fn)' is not implemented")
  }
}
