// In CPython:
// Python -> builtinmodule.c
// https://docs.python.org/3/library/functions.html

extension Builtins {
/*
  // MARK: - Code

  // sourcery: pymethod = __import__
  /// __import__(name, globals=None, locals=None, fromlist=(), level=0)
  /// See [this](https://docs.python.org/3/library/functions.html#__import__)
  public func __import__() -> PyObject {
    return self.unimplemented
  }

  // sourcery: pymethod = compile
  /// compile(source, filename, mode, flags=0, dont_inherit=False, optimize=-1)
  /// See [this](https://docs.python.org/3/library/functions.html#compile)
  public func compile() -> PyObject {
    return self.unimplemented
  }

  // sourcery: pymethod = eval
  /// eval(expression[, globals[, locals]])
  /// See [this](https://docs.python.org/3/library/functions.html#eval)
  public func eval() -> PyObject {
    return self.unimplemented
  }

  // sourcery: pymethod = exec
  /// exec(object[, globals[, locals]])
  /// See [this](https://docs.python.org/3/library/functions.html#exec)
  public func exec() -> PyObject {
    return self.unimplemented
  }

  // sourcery: pymethod = breakpoint
  /// breakpoint(*args, **kws)
  /// See [this](https://docs.python.org/3/library/functions.html#breakpoint)
  public func breakpoint() -> PyObject {
    return self.unimplemented
  }

  // MARK: - Static, class method

  // sourcery: pymethod = @staticmethod
  /// @staticmethod
  /// See [this](https://docs.python.org/3/library/functions.html#staticmethod)
  public func staticmethod() -> PyObject {
    return self.unimplemented
  }

  // sourcery: pymethod = @classmethod
  /// @classmethod
  /// See [this](https://docs.python.org/3/library/functions.html#classmethod)
  public func classmethod() -> PyObject {
    return self.unimplemented
  }

  // MARK: - Locals, globals

  // sourcery: pymethod = locals
  /// locals()
  /// See [this](https://docs.python.org/3/library/functions.html#locals)
  public func locals() -> PyObject {
    return self.unimplemented
  }

  // sourcery: pymethod = globals
  /// globals()
  /// See [this](https://docs.python.org/3/library/functions.html#globals)
  public func globals() -> PyObject {
    return self.unimplemented
  }

  // sourcery: pymethod = vars
  /// vars([object])
  /// See [this](https://docs.python.org/3/library/functions.html#vars)
  public func vars() -> PyObject {
    return self.unimplemented
  }

  // MARK: - IO

  // sourcery: pymethod = input
  /// input([prompt])
  /// See [this](https://docs.python.org/3/library/functions.html#input)
  public func input() -> PyObject {
    return self.unimplemented
  }

  // sourcery: pymethod = print
  /// print(*objects, sep=' ', end='\n', file=sys.stdout, flush=False)
  /// See [this](https://docs.python.org/3/library/functions.html#print)
  internal func print(args: PyObject, kwargs: PyObject) -> PyResult<PyNone> {
    return .value(self.none)
  }

  // MARK: - Other

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

  // sourcery: pymethod = round
  /// round(number[, ndigits])
  /// See [this](https://docs.python.org/3/library/functions.html#round)
  public func round() -> PyObject {
    return self.unimplemented
  }

  // sourcery: pymethod = super
  /// super([type[, object-or-type]])
  /// See [this](https://docs.python.org/3/library/functions.html#super)
  public func `super`() -> PyObject {
    return self.unimplemented
  }
*/
  // MARK: - Other

  internal func callDir(_ fn: PyObject, args: [PyObject?]) -> DirResult {
    return DirResult()
  }

  public func PyObject_Format(value: PyObject, format: PyObject?) -> PyObject {
    return self.none
  }

  internal func getGlobals() -> [String: PyObject] {
    return [:]
  }

  public func getDict(_ module: PyModule) -> Attributes {
    return module.attributes
  }

  // MARK: - Helpers

  internal var unimplemented: PyObject {
    return self.none
  }
}
