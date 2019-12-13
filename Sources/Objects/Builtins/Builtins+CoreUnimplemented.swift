// In CPython:
// Python -> builtinmodule.c
// https://docs.python.org/3/library/functions.html

// swiftlint:disable file_length

extension Builtins {

  // sourcery: pymethod: all
  /// all(iterable)
  /// See [this](https://docs.python.org/3/library/functions.html#all)
  public func all() -> PyObject {
    return self.unimplemented
  }

  // sourcery: pymethod: any
  /// any(iterable)
  /// See [this](https://docs.python.org/3/library/functions.html#any)
  public func any() -> PyObject {
    return self.unimplemented
  }

  // sourcery: pymethod: bin
  /// bin(x)
  /// See [this](https://docs.python.org/3/library/functions.html#bin)
  public func bin() -> PyObject {
    return self.unimplemented
  }

  // sourcery: pymethod: breakpoint
  /// breakpoint(*args, **kws)
  /// See [this](https://docs.python.org/3/library/functions.html#breakpoint)
  public func breakpoint() -> PyObject {
    return self.unimplemented
  }

  // sourcery: pymethod: callable
  /// callable(object)
  /// See [this](https://docs.python.org/3/library/functions.html#callable)
  public func callable() -> PyObject {
    return self.unimplemented
  }

  // sourcery: pymethod: chr
  /// chr(i)
  /// See [this](https://docs.python.org/3/library/functions.html#chr)
  public func chr() -> PyObject {
    return self.unimplemented
  }

  // sourcery: pymethod: @classmethod
  /// @classmethod
  /// See [this](https://docs.python.org/3/library/functions.html#classmethod)
  public func classmethod() -> PyObject {
    return self.unimplemented
  }

  // sourcery: pymethod: compile
  /// compile(source, filename, mode, flags=0, dont_inherit=False, optimize=-1)
  /// See [this](https://docs.python.org/3/library/functions.html#compile)
  public func compile() -> PyObject {
    return self.unimplemented
  }

  // sourcery: pymethod: dir
  /// dir([object])
  /// See [this](https://docs.python.org/3/library/functions.html#dir)
  public func dir() -> PyObject {
    return self.unimplemented
  }

  // sourcery: pymethod: divmod
  /// divmod(a, b)
  /// See [this](https://docs.python.org/3/library/functions.html#divmod)
  public func divmod() -> PyObject {
    return self.unimplemented
  }

  // sourcery: pymethod: enumerate
  /// enumerate(iterable, start=0)
  /// See [this](https://docs.python.org/3/library/functions.html#enumerate)
  public func enumerate() -> PyObject {
    return self.unimplemented
  }

  // sourcery: pymethod: eval
  /// eval(expression[, globals[, locals]])
  /// See [this](https://docs.python.org/3/library/functions.html#eval)
  public func eval() -> PyObject {
    return self.unimplemented
  }

  // sourcery: pymethod: exec
  /// exec(object[, globals[, locals]])
  /// See [this](https://docs.python.org/3/library/functions.html#exec)
  public func exec() -> PyObject {
    return self.unimplemented
  }

  // sourcery: pymethod: filter
  /// filter(function, iterable)
  /// See [this](https://docs.python.org/3/library/functions.html#filter)
  public func filter() -> PyObject {
    return self.unimplemented
  }

  // sourcery: pymethod: format
  /// format(value[, format_spec])
  /// See [this](https://docs.python.org/3/library/functions.html#format)
  public func format() -> PyObject {
    return self.unimplemented
  }

  // sourcery: pymethod: globals
  /// globals()
  /// See [this](https://docs.python.org/3/library/functions.html#globals)
  public func globals() -> PyObject {
    return self.unimplemented
  }

  // sourcery: pymethod: help
  /// help([object])
  /// See [this](https://docs.python.org/3/library/functions.html#help)
  public func help() -> PyObject {
    return self.unimplemented
  }

  // sourcery: pymethod: hex
  /// hex(x)
  /// See [this](https://docs.python.org/3/library/functions.html#hex)
  public func hex() -> PyObject {
    return self.unimplemented
  }

  // sourcery: pymethod: id
  /// id(object)
  /// See [this](https://docs.python.org/3/library/functions.html#id)
  public func id() -> PyObject {
    return self.unimplemented
  }

  // sourcery: pymethod: input
  /// input([prompt])
  /// See [this](https://docs.python.org/3/library/functions.html#input)
  public func input() -> PyObject {
    return self.unimplemented
  }

  // sourcery: pymethod: isinstance
  /// isinstance(object, classinfo)
  /// See [this](https://docs.python.org/3/library/functions.html#isinstance)
  public func isinstance() -> PyObject {
    return self.unimplemented
  }

  // sourcery: pymethod: issubclass
  /// issubclass(class, classinfo)
  /// See [this](https://docs.python.org/3/library/functions.html#issubclass)
  public func issubclass() -> PyObject {
    return self.unimplemented
  }

  // sourcery: pymethod: iter
  /// iter(object[, sentinel])
  /// See [this](https://docs.python.org/3/library/functions.html#iter)
  public func iter(object: PyObject) -> PyResult<PyObject> {
    return .value(self.unimplemented)
  }

  // sourcery: pymethod: len
  /// len(s)
  /// See [this](https://docs.python.org/3/library/functions.html#len)
  public func len() -> PyObject {
    return self.unimplemented
  }

  // sourcery: pymethod: locals
  /// locals()
  /// See [this](https://docs.python.org/3/library/functions.html#locals)
  public func locals() -> PyObject {
    return self.unimplemented
  }

  // sourcery: pymethod: map
  /// map(function, iterable, ...)
  /// See [this](https://docs.python.org/3/library/functions.html#map)
  public func map() -> PyObject {
    return self.unimplemented
  }

  // sourcery: pymethod: max
  /// max(iterable, *[, key, default])
  /// See [this](https://docs.python.org/3/library/functions.html#max)
  public func max() -> PyObject {
    return self.unimplemented
  }

  // sourcery: pymethod: memoryview
  /// memoryview(obj)
  /// See [this](https://docs.python.org/3/library/functions.html)
  public func memoryview() -> PyObject {
    return self.unimplemented
  }

  // sourcery: pymethod: min
  /// min(iterable, *[, key, default])
  /// See [this](https://docs.python.org/3/library/functions.html#min)
  public func min() -> PyObject {
    return self.unimplemented
  }

  // sourcery: pymethod: next
  /// next(iterator[, default])
  /// See [this](https://docs.python.org/3/library/functions.html#next)
  public func next(iterator: PyObject) -> PyResult<PyObject> {
    return .value(self.unimplemented)
  }

  // sourcery: pymethod: oct
  /// oct(x)
  /// See [this](https://docs.python.org/3/library/functions.html#oct)
  public func oct() -> PyObject {
    return self.unimplemented
  }

  // sourcery: pymethod: open
  /// open(file, mode='r', buffering=-1, encoding=None, errors=None, newline=None,
  ///            closefd=True, opener=None)
  /// See [this](https://docs.python.org/3/library/functions.html#open)
  public func open() -> PyObject {
    return self.unimplemented
  }

  // sourcery: pymethod: ord
  /// ord(c)
  /// See [this](https://docs.python.org/3/library/functions.html#ord)
  public func ord() -> PyObject {
    return self.unimplemented
  }

  // sourcery: pymethod: pow
  /// pow(base, exp[, mod])
  /// See [this](https://docs.python.org/3/library/functions.html#pow)
  public func pow() -> PyObject {
    return self.unimplemented
  }

  // sourcery: pymethod: print
  /// print(*objects, sep=' ', end='\n', file=sys.stdout, flush=False)
  /// See [this](https://docs.python.org/3/library/functions.html#print)
  internal func print(args: PyObject, kwargs: PyObject) -> PyResult<PyNone> {
    return .value(self.none)
  }

  // sourcery: pymethod: range
  /// range(stop)
  /// See [this](https://docs.python.org/3/library/functions.html)
  public func range() -> PyObject {
    return self.unimplemented
  }

  // sourcery: pymethod: reversed
  /// reversed(seq)
  /// See [this](https://docs.python.org/3/library/functions.html#reversed)
  public func reversed() -> PyObject {
    return self.unimplemented
  }

  // sourcery: pymethod: round
  /// round(number[, ndigits])
  /// See [this](https://docs.python.org/3/library/functions.html#round)
  public func round() -> PyObject {
    return self.unimplemented
  }

  // sourcery: pymethod: sorted
  /// sorted(iterable, *, key=None, reverse=False)
  /// See [this](https://docs.python.org/3/library/functions.html#sorted)
  public func sorted() -> PyObject {
    return self.unimplemented
  }

  // sourcery: pymethod: @staticmethod
  /// @staticmethod
  /// See [this](https://docs.python.org/3/library/functions.html#staticmethod)
  public func staticmethod() -> PyObject {
    return self.unimplemented
  }

  // sourcery: pymethod: sum
  /// sum(iterable, /, start=0)
  /// See [this](https://docs.python.org/3/library/functions.html#sum)
  public func sum() -> PyObject {
    return self.unimplemented
  }

  // sourcery: pymethod: super
  /// super([type[, object-or-type]])
  /// See [this](https://docs.python.org/3/library/functions.html#super)
  public func `super`() -> PyObject {
    return self.unimplemented
  }

  // sourcery: pymethod: tuple
  /// tuple([iterable])
  /// See [this](https://docs.python.org/3/library/functions.html)
  public func tuple() -> PyObject {
    return self.unimplemented
  }

  // sourcery: pymethod: vars
  /// vars([object])
  /// See [this](https://docs.python.org/3/library/functions.html#vars)
  public func vars() -> PyObject {
    return self.unimplemented
  }

  // sourcery: pymethod: zip
  /// zip(*iterables)
  /// See [this](https://docs.python.org/3/library/functions.html#zip)
  public func zip() -> PyObject {
    return self.unimplemented
  }

  // sourcery: pymethod: __import__
  /// __import__(name, globals=None, locals=None, fromlist=(), level=0)
  /// See [this](https://docs.python.org/3/library/functions.html#__import__)
  public func __import__() -> PyObject {
    return self.unimplemented
  }
}
