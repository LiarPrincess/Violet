import Core

// In CPython:
// Python -> builtinmodule.c
// https://docs.python.org/3/library/functions.html

// swiftlint:disable file_length

// MARK: - any, all, sum

// CPython does this differently.
private let sumArguments = ArgumentParser.createOrTrap(
  arguments: ["", "start"],
  format: "O|O:sum"
)

extension Builtins {

  /// any(iterable)
  /// See [this](https://docs.python.org/3/library/functions.html#any)
  internal static func any(iterable: PyObject) -> PyResult<Bool> {
    return Py.any(iterable: iterable)
  }

  /// all(iterable)
  /// See [this](https://docs.python.org/3/library/functions.html#all)
  internal static func all(iterable: PyObject) -> PyResult<Bool> {
    return Py.all(iterable: iterable)
  }

  /// sum(iterable, /, start=0)
  /// See [this](https://docs.python.org/3/library/functions.html#sum)
  internal static func sum(args: [PyObject], kwargs: PyDict?) -> PyResult<PyObject> {
    switch sumArguments.bind(args: args, kwargs: kwargs) {
    case let .value(binding):
      assert(binding.requiredCount == 1, "Invalid required argument count.")
      assert(binding.optionalCount == 1, "Invalid optional argument count.")

      let iterable = binding.required(at: 0)
      let start = binding.optional(at: 1)
      return Py.sum(iterable: iterable, start: start)
    case let .error(e):
      return .error(e)
    }
  }
}

// MARK: - getattr, hasattr, setattr, delattr

extension Builtins {

  internal static var getAttributeDoc: String {
    return """
    getattr(object, name[, default]) -> value

    Get a named attribute from an object; getattr(x, 'y') is equivalent to x.y.
    When a default argument is given, it is returned when the attribute doesn't
    exist; without it, an exception is raised in that case.
    """
  }

  /// getattr(object, name[, default])
  /// See [this](https://docs.python.org/3/library/functions.html#getattr)
  internal static func getattr(object: PyObject,
                               name: PyObject,
                               default: PyObject? = nil) -> PyResult<PyObject> {
    return Py.getAttribute(object: object,
                           name: name,
                           default: `default`)
  }

  /// hasattr(object, name)
  /// See [this](https://docs.python.org/3/library/functions.html#hasattr)
  internal static func hasattr(object: PyObject,
                               name: PyObject) -> PyResult<Bool> {
    return Py.hasAttribute(object: object, name: name)
  }

  /// setattr(object, name, value)
  /// See [this](https://docs.python.org/3/library/functions.html#setattr)
  internal static func setattr(object: PyObject,
                               name: PyObject,
                               value: PyObject) -> PyResult<PyNone> {
    return Py.setAttribute(object: object, name: name, value: value)
  }

  /// delattr(object, name)
  /// See [this](https://docs.python.org/3/library/functions.html#delattr)
  internal static func delattr(object: PyObject,
                               name: PyObject) -> PyResult<PyNone> {
    return Py.deleteAttribute(object: object, name: name)
  }
}

// MARK: - id

extension Builtins {

  /// id(object)
  /// See [this](https://docs.python.org/3/library/functions.html#id)
  internal static func id(object: PyObject) -> PyInt {
    return Py.getId(object: object)
  }
}

// MARK: - dir

extension Builtins {

  /// dir([object])
  /// See [this](https://docs.python.org/3/library/functions.html#dir)
  internal static func dir(object: PyObject?) -> PyResult<PyObject> {
    return Py.dir(object: object)
  }
}

// MARK: - bin, hex, oct

extension Builtins {

  /// bin(x)
  /// See [this](https://docs.python.org/3/library/functions.html#bin)
  internal static func bin(object: PyObject) -> PyResult<PyObject> {
    return Py.bin(object: object)
  }

  /// oct(x)
  /// See [this](https://docs.python.org/3/library/functions.html#oct)
  internal static func oct(object: PyObject) -> PyResult<PyObject> {
    return Py.oct(object: object)
  }

  /// hex(x)
  /// See [this](https://docs.python.org/3/library/functions.html#hex)
  internal static func hex(object: PyObject) -> PyResult<PyObject> {
    return Py.hex(object: object)
  }
}

// MARK: - chr, ord

extension Builtins {

  /// chr(i)
  /// See [this](https://docs.python.org/3/library/functions.html#chr)
  internal static func chr(object: PyObject) -> PyResult<PyString> {
    return Py.chr(object: object)
  }

  /// ord(c)
  /// See [this](https://docs.python.org/3/library/functions.html#ord)
  internal static func ord(object: PyObject) -> PyResult<PyInt> {
    return Py.ord(object: object)
  }
}

// MARK: - callable

extension Builtins {

  /// callable(object)
  /// See [this](https://docs.python.org/3/library/functions.html#callable)
  internal static func callable(object: PyObject) -> PyResult<Bool> {
    return Py.isCallable(object: object)
  }
}

// MARK: - len, sorted

extension Builtins {

  /// len(s)
  /// See [this](https://docs.python.org/3/library/functions.html#len)
  internal static func length(iterable: PyObject) -> PyResult<PyObject> {
    return Py.length(iterable: iterable)
  }

  internal static var sortedDoc: String {
    return """
    sorted($module, iterable, /, *, key=None, reverse=False)
    --

    Return a new list containing all items from the iterable in ascending order.

    A custom key function can be supplied to customize the sort order, and the
    reverse flag can be set to request the result in descending order.
    """
  }

  /// sorted(iterable, *, key=None, reverse=False)
  /// See [this](https://docs.python.org/3/library/functions.html#sorted)
  internal static func sorted(args: [PyObject],
                              kwargs: PyDict?) -> PyResult<PyList> {
    // TODO: This
    return Py.sorted(args: args, kwargs: kwargs)
  }
}

// MARK: - hash

extension Builtins {

  /// hash(object)
  /// See [this](https://docs.python.org/3/library/functions.html#hash)
  internal static func hash(object: PyObject) -> PyResult<PyHash> {
    return Py.hash(object: object)
  }
}

// MARK: - print

private let printArguments = ArgumentParser.createOrTrap(
  arguments: ["sep", "end", "file", "flush"],
  format: "|OOOO:print"
)

extension Builtins {

  /// print(*objects, sep=' ', end='\n', file=sys.stdout, flush=False)
  /// See [this](https://docs.python.org/3/library/functions.html#print)
  ///
  /// - Parameters:
  ///   - args: Objects to print
  ///   - kwargs: Options
  internal static func print(args: [PyObject],
                             kwargs: PyDict?) -> PyResult<PyNone> {
    switch printArguments.bind(args: [], kwargs: kwargs) {
    case let .value(binding):
      assert(binding.requiredCount == 0, "Invalid required argument count.")
      assert(binding.optionalCount == 4, "Invalid optional argument count.")

      let sep = binding.optional(at: 0)
      let end = binding.optional(at: 1)
      let file = binding.optional(at: 2)
      let flush = binding.optional(at: 3)
      return Py.print(args: args, sep: sep, end: end, file: file, flush: flush)

    case let .error(e):
      return .error(e)
    }
  }
}

// MARK: - open

private let openArguments = ArgumentParser.createOrTrap(
  arguments: [
    "file", "mode", "buffering",
    "encoding", "errors", "newline",
    "closefd", "opener"
  ],
  format: "O|sizzziO:open"
)

extension Builtins {

  /// open(file, mode='r', buffering=-1, encoding=None, errors=None, newline=None,
  ///            closefd=True, opener=None)
  /// See [this](https://docs.python.org/3/library/functions.html#open)
  internal static func open(args: [PyObject],
                            kwargs: PyDict?) -> PyResult<PyObject> {
    switch openArguments.bind(args: args, kwargs: kwargs) {
    case let .value(binding):
      assert(binding.requiredCount == 1, "Invalid required argument count.")
      assert(binding.optionalCount == 7, "Invalid optional argument count.")

      let file = binding.required(at: 0)
      let mode = binding.optional(at: 1)
      let buffering = binding.optional(at: 2)
      let encoding = binding.optional(at: 3)
      let errors = binding.optional(at: 4)
      let newline = binding.optional(at: 5)
      let closefd = binding.optional(at: 6)
      let opener = binding.optional(at: 7)

      return Py.open(file: file,
                     mode: mode,
                     buffering: buffering,
                     encoding: encoding,
                     errors: errors,
                     newline: newline,
                     closefd: closefd,
                     opener: opener)
    case let .error(e):
      return .error(e)
    }
  }
}

// MARK: - __build_class__

extension Builtins {

  internal static var buildClassDoc: String {
    return """
    __build_class__(func, name, *bases, metaclass=None, **kwds) -> class

    Internal helper function used by the class statement.
    """
  }

  internal static func buildClass(args: [PyObject],
                                  kwargs: PyDict?) -> PyResult<PyObject> {
    if args.count < 2 {
      return .typeError("__build_class__: not enough arguments")
    }

    guard let fn = args[0] as? PyFunction else {
      return .typeError("__build_class__: func must be a function")
    }

    guard let name = args[1] as? PyString else {
      return .typeError("__build_class__: name is not a string")
    }

    let bases = Py.newTuple(Array(args[2...]))
    return Py.buildClass(fn: fn, name: name, bases: bases, kwargs: kwargs)
  }
}

// MARK: - __import__

private let importArguments = ArgumentParser.createOrTrap(
  arguments: ["name", "globals", "locals", "fromlist", "level"],
  format: "U|OOOi:__import__"
)

extension Builtins {

  internal static var importDoc: String {
    return """
    __import__(name, globals=None, locals=None, fromlist=(), level=0) -> module

    Import a module. Because this function is meant for use by the Python
    interpreter and not for general use, it is better to use
    importlib.import_module() to programmatically import a module.

    The globals argument is only used to determine the context;
    they are not modified.  The locals argument is unused.  The fromlist
    should be a list of names to emulate ``from name import ...'', or an
    empty list to emulate ``import name''.
    When importing a module from a package, note that __import__('A.B', ...)
    returns package A when fromlist is empty, but its submodule B when
    fromlist is not empty.  The level argument is used to determine whether to
    perform absolute or relative imports: 0 is absolute, while a positive number
    is the number of parent directories to search relative to the current module.
    """
  }

  /// __import__(name, globals=None, locals=None, fromlist=(), level=0)
  /// See [this](https://docs.python.org/3/library/functions.html#__import__)
  internal static func __import__(args: [PyObject],
                                  kwargs: PyDict?) -> PyResult<PyObject> {
    switch importArguments.bind(args: args, kwargs: kwargs) {
    case let .value(binding):
      assert(binding.requiredCount == 1, "Invalid required argument count.")
      assert(binding.optionalCount == 4, "Invalid optional argument count.")

      let name = binding.required(at: 0)
      let globals = binding.optional(at: 1)
      let locals = binding.optional(at: 2)
      let fromList = binding.optional(at: 3)
      let level = binding.optional(at: 4)

      return Py.__import__(name: name,
                           globals: globals,
                           locals: locals,
                           fromList: fromList,
                           level: level)

    case let .error(e):
      return .error(e)
    }
  }
}

// MARK: - globals, locals

extension Builtins {

  /// globals()
  /// See [this](https://docs.python.org/3/library/functions.html#globals)
  internal static func globals() -> PyResult<PyDict> {
    return Py.getGlobals()
  }

  /// locals()
  /// See [this](https://docs.python.org/3/library/functions.html#locals)
  internal static func locals() -> PyResult<PyDict> {
    return Py.getLocals()
  }
}

// MARK: - min, max

extension Builtins {

  internal static var minDoc: String {
    return """
    min(iterable, *[, default=obj, key=func]) -> value
    min(arg1, arg2, *args, *[, key=func]) -> value

    With a single iterable argument, return its smallest item. The
    default keyword-only argument specifies an object to return if
    the provided iterable is empty.
    With two or more arguments, return the smallest argument.
    """
  }

  /// min(iterable, *[, key, default])
  /// See [this](https://docs.python.org/3/library/functions.html#min)
  internal static func min(args: [PyObject],
                           kwargs: PyDict?) -> PyResult<PyObject> {
    return Py.min(args: args, kwargs: kwargs)
  }

  internal static var maxDoc: String {
    return """
    max(iterable, *[, default=obj, key=func]) -> value
    max(arg1, arg2, *args, *[, key=func]) -> value

    With a single iterable argument, return its biggest item. The
    default keyword-only argument specifies an object to return if
    the provided iterable is empty.
    With two or more arguments, return the largest argument.
    """
  }

  /// max(iterable, *[, key, default])
  /// See [this](https://docs.python.org/3/library/functions.html#max)
  internal static func max(args: [PyObject],
                           kwargs: PyDict?) -> PyResult<PyObject> {
    return Py.max(args: args, kwargs: kwargs)
  }
}

// MARK: - next, iter

extension Builtins {

  internal static var nextDoc: String {
    return """
    next(iterator[, default])

    Return the next item from the iterator. If default is given and the iterator
    is exhausted, it is returned instead of raising StopIteration.
    """
  }

  /// next(iterator[, default])
  /// See [this](https://docs.python.org/3/library/functions.html#next)
  internal static func next(iterator: PyObject,
                            default: PyObject?) -> PyResult<PyObject> {
    return Py.next(iterator: iterator, default: `default`)
  }

  internal static var iterDoc: String {
    return """
    iter(iterable) -> iterator
    iter(callable, sentinel) -> iterator

    Get an iterator from an object.  In the first form, the argument must
    supply its own iterator, or be a sequence.
    In the second form, the callable is called until it returns the sentinel.
    """
  }

  /// iter(object[, sentinel])
  /// See [this](https://docs.python.org/3/library/functions.html#iter)
  internal static func iter(from object: PyObject,
                            sentinel: PyObject?) -> PyResult<PyObject> {
    return Py.iter(from: object, sentinel: sentinel)
  }
}

// MARK: - round, divmod, abs

extension Builtins {

  /// round(number[, ndigits])
  /// See [this](https://docs.python.org/3/library/functions.html#round)
  internal static func round(number: PyObject,
                             nDigits: PyObject?) -> PyResult<PyObject> {
    return Py.round(number: number, nDigits: nDigits)
  }

  /// divmod(a, b)
  /// See [this](https://docs.python.org/3/library/functions.html#divmod)
  internal static func divmod(left: PyObject,
                              right: PyObject) -> PyResult<PyObject> {
    return Py.divmod(left: left, right: right)
  }

  /// abs(x)
  /// See [this](https://docs.python.org/3/library/functions.html#abs)
  internal static func abs(object: PyObject) -> PyResult<PyObject> {
    return Py.abs(object: object)
  }

  /// pow(base, exp[, mod])
  /// See [this](https://docs.python.org/3/library/functions.html#pow)
  internal static func pow(base: PyObject,
                           exp: PyObject,
                           mod: PyObject?) -> PyResult<PyObject> {
    return Py.pow(base: base, exp: exp, mod: mod)
  }
}

// MARK: - repr, ascii

extension Builtins {

  /// repr(object)
  /// See [this](https://docs.python.org/3/library/functions.html#repr)
  internal static func repr(object: PyObject) -> PyResult<String> {
    // TODO: This
    return Py.repr(object)
  }

  /// ascii(object)
  /// See [this](https://docs.python.org/3/library/functions.html#ascii)
  internal static func ascii(object: PyObject) -> PyResult<String> {
    // TODO: This
    return Py.ascii(object)
  }
}

// MARK: - isinstance

extension Builtins {

  internal static var isInstanceDoc: String {
    return """
    isinstance($module, obj, class_or_tuple, /)
    --

    Return whether an object is an instance of a class or of a subclass thereof.

    A tuple, as in ``isinstance(x, (A, B, ...))``, may be given as the target to
    check against. This is equivalent to ``isinstance(x, A) or isinstance(x, B)
    or ...`` etc.
    """
  }

  /// isinstance(object, classinfo)
  /// See [this](https://docs.python.org/3/library/functions.html#isinstance)
  internal static func isinstance(object: PyObject,
                                  of typeOrTuple: PyObject) -> PyResult<Bool> {
    return Py.isInstance(object: object, of: typeOrTuple)
  }

  internal static var isSubclassDoc: String {
    return """
    issubclass($module, cls, class_or_tuple, /)
    --

    Return whether \'cls\' is a derived from another class or is the same class.

    A tuple, as in ``issubclass(x, (A, B, ...))``, may be given as the target to
    check against. This is equivalent to ``issubclass(x, A) or issubclass(x, B)
    or ...`` etc.
    """
  }

  /// issubclass(class, classinfo)
  /// See [this](https://docs.python.org/3/library/functions.html#issubclass)
  internal static func issubclass(object: PyObject,
                                  of typeOrTuple: PyObject) -> PyResult<Bool> {
    return Py.isSubclass(object: object, of: typeOrTuple)
  }
}

// MARK: - compile

private let compileArguments = ArgumentParser.createOrTrap(
  arguments: ["source", "filename", "mode", "flags", "dont_inherit", "optimize"],
  format: "OOO|OOO:compile"
)

extension Builtins {

  /// compile(source, filename, mode, flags=0, dont_inherit=False, optimize=-1)
  /// See [this](https://docs.python.org/3/library/functions.html#compile)
  internal static func compile(args: [PyObject],
                               kwargs: PyDict?) -> PyResult<PyCode> {
    switch compileArguments.bind(args: args, kwargs: kwargs) {
    case let .value(binding):
      assert(binding.requiredCount == 3, "Invalid required argument count.")
      assert(binding.optionalCount == 3, "Invalid optional argument count.")

      let source = binding.required(at: 0)
      let filename = binding.required(at: 1)
      let mode = binding.required(at: 2)
      let flags = binding.optional(at: 3)
      let dontInherit = binding.optional(at: 4)
      let optimize = binding.optional(at: 5)
      return Py.compile(source: source,
                        filename: filename,
                        mode: mode,
                        flags: flags,
                        dontInherit: dontInherit,
                        optimize: optimize)

    case let .error(e):
      return .error(e)
    }
  }
}

// MARK: - exec, eval

private let execArguments = ArgumentParser.createOrTrap(
  arguments: ["source", "globals", "locals"],
  format: "O|OO:exec"
)

private let evalArguments = ArgumentParser.createOrTrap(
  arguments: ["source", "globals", "locals"],
  format: "O|OO:exec"
)

extension Builtins {

  /// exec(object[, globals[, locals]])
  /// See [this](https://docs.python.org/3/library/functions.html#exec)
  internal static func exec(args: [PyObject],
                            kwargs: PyDict?) -> PyResult<PyNone> {
    switch execArguments.bind(args: args, kwargs: kwargs) {
    case let .value(binding):
      assert(binding.requiredCount == 1, "Invalid required argument count.")
      assert(binding.optionalCount == 2, "Invalid optional argument count.")

      let source = binding.required(at: 0)
      let globals = binding.optional(at: 1)
      let locals = binding.optional(at: 2)
      return Py.exec(source: source, globals: globals, locals: locals)

    case let .error(e):
      return .error(e)
    }
  }

  /// eval(expression[, globals[, locals]])
  /// See [this](https://docs.python.org/3/library/functions.html#eval)
  internal static func eval(args: [PyObject],
                            kwargs: PyDict?) -> PyResult<PyObject> {
    switch execArguments.bind(args: args, kwargs: kwargs) {
    case let .value(binding):
      assert(binding.requiredCount == 1, "Invalid required argument count.")
      assert(binding.optionalCount == 2, "Invalid optional argument count.")

      let source = binding.required(at: 0)
      let globals = binding.optional(at: 1)
      let locals = binding.optional(at: 2)
      return Py.eval(source: source, globals: globals, locals: locals)

    case let .error(e):
      return .error(e)
    }
  }
}
