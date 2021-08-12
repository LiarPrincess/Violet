import VioletCore

// swiftlint:disable file_length
// cSpell:ignore submodule

// In CPython:
// Python -> builtinmodule.c
// https://docs.python.org/3/library/functions.html

// Use this to generate docs:
//   import builtins
//   import types
//
//   for name in dir(builtins):
//     value = builtins.__dict__[name]
//
//     if type(value) is not types.BuiltinFunctionType:
//       continue
//
//     doc = value.__doc__
//
//     print thingies

// MARK: - any, all, sum

// CPython does this differently.
private let sumArguments = ArgumentParser.createOrTrap(
  arguments: ["", "start"],
  format: "O|O:sum"
)

extension Builtins {

  internal static var anyDoc: String {
    return """
    Return True if bool(x) is True for any x in the iterable.

    If the iterable is empty, return False.
    """
  }

  /// any(iterable)
  /// See [this](https://docs.python.org/3/library/functions.html#any)
  internal static func any(iterable: PyObject) -> PyResult<Bool> {
    return Py.any(iterable: iterable)
  }

  internal static var allDoc: String {
    return """
    Return True if bool(x) is True for all values x in the iterable.

    If the iterable is empty, return True.
    """
  }

  /// all(iterable)
  /// See [this](https://docs.python.org/3/library/functions.html#all)
  internal static func all(iterable: PyObject) -> PyResult<Bool> {
    return Py.all(iterable: iterable)
  }

  internal static var sumDoc: String {
    return """
    Return the sum of a 'start' value (default: 0) plus an iterable of numbers

    When the iterable is empty, return the start value.
    This function is intended specifically for use with numeric values and may
    reject non-numeric types.
    """
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

  internal static var getattrDoc: String {
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

  internal static var hasattrDoc: String {
    return """
    Return whether the object has an attribute with the given name.

    This is done by calling getattr(obj, name) and catching AttributeError.
    """
  }

  /// hasattr(object, name)
  /// See [this](https://docs.python.org/3/library/functions.html#hasattr)
  internal static func hasattr(object: PyObject,
                               name: PyObject) -> PyResult<Bool> {
    return Py.hasAttribute(object: object, name: name)
  }

  internal static var setattrDoc: String {
    return """
    Sets the named attribute on the given object to the specified value.

    setattr(x, 'y', v) is equivalent to ``x.y = v''
    """
  }

  /// setattr(object, name, value)
  /// See [this](https://docs.python.org/3/library/functions.html#setattr)
  internal static func setattr(object: PyObject,
                               name: PyObject,
                               value: PyObject) -> PyResult<PyNone> {
    return Py.setAttribute(object: object, name: name, value: value)
  }

  internal static var delattrDoc: String {
    return """
    Deletes the named attribute from the given object.

    delattr(x, 'y') is equivalent to ``del x.y''
    """
  }

  /// delattr(object, name)
  /// See [this](https://docs.python.org/3/library/functions.html#delattr)
  internal static func delattr(object: PyObject,
                               name: PyObject) -> PyResult<PyNone> {
    return Py.delAttribute(object: object, name: name)
  }
}

// MARK: - id

extension Builtins {

  internal static var idDoc: String {
    return """
    Return the identity of an object.

    This is guaranteed to be unique among simultaneously existing objects.
    (CPython uses the object's memory address.)
    """
  }

  /// id(object)
  /// See [this](https://docs.python.org/3/library/functions.html#id)
  internal static func id(object: PyObject) -> PyInt {
    return Py.id(object: object)
  }
}

// MARK: - dir

extension Builtins {

  internal static var dirDoc: String {
    return """
    dir([object]) -> list of strings

    If called without an argument, return the names in the current scope.
    Else, return an alphabetized list of names comprising (some of) the attributes
    of the given object, and of attributes reachable from it.
    If the object supplies a method named __dir__, it will be used; otherwise
    the default dir() logic is used and returns:
    for a module object: the module's attributes.
    for a class object:  its attributes, and recursively the attributes
    of its bases.
    for any other object: its attributes, its class's attributes, and
    recursively the attributes of its class's base classes.
    """
  }

  /// dir([object])
  /// See [this](https://docs.python.org/3/library/functions.html#dir)
  internal static func dir(object: PyObject?) -> PyResult<PyObject> {
    return Py.dir(object: object)
  }
}

// MARK: - bin, hex, oct

extension Builtins {

  internal static var binDoc: String {
    return """
    Return the binary representation of an integer.

    >>> bin(2796202)
    '0b1010101010101010101010'
    """
  }

  /// bin(x)
  /// See [this](https://docs.python.org/3/library/functions.html#bin)
  internal static func bin(object: PyObject) -> PyResult<PyObject> {
    return Py.bin(object: object)
  }

  internal static var octDoc: String {
    return """
    Return the octal representation of an integer.

    >>> oct(342391)
    '0o1234567'
    """
  }

  /// oct(x)
  /// See [this](https://docs.python.org/3/library/functions.html#oct)
  internal static func oct(object: PyObject) -> PyResult<PyObject> {
    return Py.oct(object: object)
  }

  internal static var hexDoc: String {
    return """
    Return the hexadecimal representation of an integer.

    >>> hex(12648430)
    '0xc0ffee'
    """
  }

  /// hex(x)
  /// See [this](https://docs.python.org/3/library/functions.html#hex)
  internal static func hex(object: PyObject) -> PyResult<PyObject> {
    return Py.hex(object: object)
  }
}

// MARK: - chr, ord

extension Builtins {

  internal static var chrDoc: String {
    return """
    Return a Unicode string of one character with ordinal i; 0 <= i <= 0x10ffff.
    """
  }

  /// chr(i)
  /// See [this](https://docs.python.org/3/library/functions.html#chr)
  internal static func chr(object: PyObject) -> PyResult<PyString> {
    return Py.chr(object: object)
  }

  internal static var ordDoc: String {
    return """
    Return the Unicode code point for a one-character string.
    """
  }

  /// ord(c)
  /// See [this](https://docs.python.org/3/library/functions.html#ord)
  internal static func ord(object: PyObject) -> PyResult<PyInt> {
    return Py.ord(object: object)
  }
}

// MARK: - callable

extension Builtins {

  internal static var callableDoc: String {
    return """
    Return whether the object is callable (i.e., some kind of function).

    Note that classes are callable, as are instances of classes with a
    __call__() method.
    """
  }

  /// callable(object)
  /// See [this](https://docs.python.org/3/library/functions.html#callable)
  internal static func callable(object: PyObject) -> Bool {
    return Py.callable(object: object)
  }
}

// MARK: - len, sorted

extension Builtins {

  internal static var lenDoc: String {
    return """
    Return the number of items in a container.
    """
  }

  /// len(s)
  /// See [this](https://docs.python.org/3/library/functions.html#len)
  internal static func len(iterable: PyObject) -> PyResult<PyObject> {
    return Py.len(iterable: iterable)
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
    if let e = ArgumentParser.guaranteeArgsCountOrError(fnName: "sorted",
                                                        args: args,
                                                        min: 1,
                                                        max: 1) {
      return .error(e)
    }

    let iterable = args[0]
    return Py.sorted(iterable: iterable, kwargs: kwargs)
  }
}

// MARK: - hash

extension Builtins {

  internal static var hashDoc: String {
    return """
    Return the hash value for the given object.

    Two objects that compare equal must also have the same hash value, but the
    reverse is not necessarily true.
    """
  }

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

  internal static var printDoc: String {
    return """
    print(value, ..., sep=' ', end='\n', file=sys.stdout, flush=False)

    Prints the values to a stream, or to sys.stdout by default.
    Optional keyword arguments:
    file:  a file-like object (stream); defaults to the current sys.stdout.
    sep:   string inserted between values, default a space.
    end:   string appended after the last value, default a newline.
    flush: whether to forcibly flush the stream.
    """
  }

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
      return Py.print(args: args, file: file, sep: sep, end: end, flush: flush)

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
  format: "O|sizzziO:open" // cSpell:disable-line
)

extension Builtins {

  internal static var openDoc: String {
    return """
    Open file and return a stream.  Raise OSError upon failure.

    file is either a text or byte string giving the name (and the path
    if the file isn't in the current working directory) of the file to
    be opened or an integer file descriptor of the file to be
    wrapped. (If a file descriptor is given, it is closed when the
    returned I/O object is closed, unless closefd is set to False.)

    mode is an optional string that specifies the mode in which the file
    is opened. It defaults to 'r' which means open for reading in text
    mode.  Other common values are 'w' for writing (truncating the file if
    it already exists), 'x' for creating and writing to a new file, and
    'a' for appending (which on some Unix systems, means that all writes
    append to the end of the file regardless of the current seek position).
    In text mode, if encoding is not specified the encoding used is platform
    dependent: locale.getpreferredencoding(False) is called to get the
    current locale encoding. (For reading and writing raw bytes use binary
    mode and leave encoding unspecified.) The available modes are:

    ========= ===============================================================
    Character Meaning
    --------- ---------------------------------------------------------------
    'r'       open for reading (default)
    'w'       open for writing, truncating the file first
    'x'       create a new file and open it for writing
    'a'       open for writing, appending to the end of the file if it exists
    'b'       binary mode
    't'       text mode (default)
    '+'       open a disk file for updating (reading and writing)
    'U'       universal newline mode (deprecated)
    ========= ===============================================================

    The default mode is 'rt' (open for reading text). For binary random
    access, the mode 'w+b' opens and truncates the file to 0 bytes, while
    'r+b' opens the file without truncation. The 'x' mode implies 'w' and
    raises an `FileExistsError` if the file already exists.

    Python distinguishes between files opened in binary and text modes,
    even when the underlying operating system doesn't. Files opened in
    binary mode (appending 'b' to the mode argument) return contents as
    bytes objects without any decoding. In text mode (the default, or when
    't' is appended to the mode argument), the contents of the file are
    returned as strings, the bytes having been first decoded using a
    platform-dependent encoding or using the specified encoding if given.

    'U' mode is deprecated and will raise an exception in future versions
    of Python.  It has no effect in Python 3.  Use newline to control
    universal newlines mode.

    buffering is an optional integer used to set the buffering policy.
    Pass 0 to switch buffering off (only allowed in binary mode), 1 to select
    line buffering (only usable in text mode), and an integer > 1 to indicate
    the size of a fixed-size chunk buffer.  When no buffering argument is
    given, the default buffering policy works as follows:

    * Binary files are buffered in fixed-size chunks; the size of the buffer
    is chosen using a heuristic trying to determine the underlying device's
    "block size" and falling back on `io.DEFAULT_BUFFER_SIZE`.
    On many systems, the buffer will typically be 4096 or 8192 bytes long.

    * "Interactive" text files (files for which isatty() returns True)
    use line buffering.  Other text files use the policy described above
    for binary files.

    encoding is the name of the encoding used to decode or encode the
    file. This should only be used in text mode. The default encoding is
    platform dependent, but any encoding supported by Python can be
    passed.  See the codecs module for the list of supported encodings.

    errors is an optional string that specifies how encoding errors are to
    be handled---this argument should not be used in binary mode. Pass
    'strict' to raise a ValueError exception if there is an encoding error
    (the default of None has the same effect), or pass 'ignore' to ignore
    errors. (Note that ignoring encoding errors can lead to data loss.)
    See the documentation for codecs.register or run 'help(codecs.Codec)'
    for a list of the permitted encoding error strings.

    newline controls how universal newlines works (it only applies to text
    mode). It can be None, '', '\n', '\r', and '\r\n'.  It works as
    follows:

    * On input, if newline is None, universal newlines mode is
    enabled. Lines in the input can end in '\n', '\r', or '\r\n', and
    these are translated into '\n' before being returned to the
    caller. If it is '', universal newline mode is enabled, but line
    endings are returned to the caller untranslated. If it has any of
    the other legal values, input lines are only terminated by the given
    string, and the line ending is returned to the caller untranslated.

    * On output, if newline is None, any '\n' characters written are
    translated to the system default line separator, os.linesep. If
    newline is '' or '\n', no translation takes place. If newline is any
    of the other legal values, any '\n' characters written are translated
    to the given string.

    If closefd is False, the underlying file descriptor will be kept open
    when the file is closed. This does not work when a file name is given
    and must be True in that case.

    A custom opener can be used by passing a callable as *opener*. The
    underlying file descriptor for the file object is then obtained by
    calling *opener* with (*file*, *flags*). *opener* must return an open
    file descriptor (passing os.open as *opener* results in functionality
    similar to passing None).

    open() returns a file object whose type depends on the mode, and
    through which the standard file operations such as reading and writing
    are performed. When open() is used to open a file in a text mode ('w',
    'r', 'wt', 'rt', etc.), it returns a TextIOWrapper. When used to open
    a file in a binary mode, the returned class varies: in read binary
    mode, it returns a BufferedReader; in write binary and append binary
    modes, it returns a BufferedWriter, and in read/write mode, it returns
    a BufferedRandom.

    It is also possible to use a string or bytearray as a file for both
    reading and writing. For strings StringIO can be used like a file
    opened in a text mode, and for bytes a BytesIO can be used like a file
    opened in a binary mode.
    """
  }

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

  internal static var __build_class__Doc: String {
    return """
    __build_class__(func, name, *bases, metaclass=None, **kwds) -> class

    Internal helper function used by the class statement.
    """
  }

  internal static func __build_class__(args: [PyObject],
                                       kwargs: PyDict?) -> PyResult<PyObject> {
    if args.count < 2 {
      return .typeError("__build_class__: not enough arguments")
    }

    guard let fn = PyCast.asFunction(args[0]) else {
      return .typeError("__build_class__: func must be a function")
    }

    guard let name = PyCast.asString(args[1]) else {
      return .typeError("__build_class__: name is not a string")
    }

    let bases = Py.newTuple(elements: Array(args[2...]))
    return Py.__build_class__(name: name,
                              bases: bases,
                              bodyFn: fn,
                              kwargs: kwargs)
  }
}

// MARK: - __import__

private let importArguments = ArgumentParser.createOrTrap(
  arguments: ["name", "globals", "locals", "fromlist", "level"],
  format: "U|OOOi:__import__"
)

extension Builtins {

  internal static var __import__Doc: String {
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

  internal static var globalsDoc: String {
    return """
    Return the dictionary containing the current scope's global variables.

    NOTE: Updates to this dictionary *will* affect name lookups in the current
    global scope and vice-versa.
    """
  }

  /// globals()
  /// See [this](https://docs.python.org/3/library/functions.html#globals)
  internal static func globals() -> PyResult<PyDict> {
    return Py.globals()
  }

  internal static var localsDoc: String {
    return """
    Return a dictionary containing the current scope's local variables.

    NOTE: Whether or not updates to this dictionary will affect name lookups in
    the local scope and vice-versa is *implementation dependent* and not
    covered by any backwards compatibility guarantees.
    """
  }

  /// locals()
  /// See [this](https://docs.python.org/3/library/functions.html#locals)
  internal static func locals() -> PyResult<PyDict> {
    return Py.locals()
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
  internal static func iter(object: PyObject,
                            sentinel: PyObject?) -> PyResult<PyObject> {
    return Py.iter(object: object, sentinel: sentinel)
  }
}

// MARK: - round, divmod, abs

extension Builtins {

  internal static var roundDoc: String {
    return """
    Round a number to a given precision in decimal digits.

    The return value is an integer if ndigits is omitted or None.  Otherwise
    the return value has the same type as the number.  ndigits may be negative.
    """
  }

  /// round(number[, ndigits])
  /// See [this](https://docs.python.org/3/library/functions.html#round)
  internal static func round(number: PyObject,
                             nDigits: PyObject?) -> PyResult<PyObject> {
    return Py.round(number: number, nDigits: nDigits)
  }

  internal static var divmodDoc: String {
    return """
    Return the tuple (x//y, x%y).  Invariant: div*y + mod == x.
    """
  }

  /// divmod(a, b)
  /// See [this](https://docs.python.org/3/library/functions.html#divmod)
  internal static func divmod(left: PyObject,
                              right: PyObject) -> PyResult<PyObject> {
    return Py.divmod(left: left, right: right)
  }

  internal static var absDoc: String {
    return """
    Return the absolute value of the argument.
    """
  }

  /// abs(x)
  /// See [this](https://docs.python.org/3/library/functions.html#abs)
  internal static func abs(object: PyObject) -> PyResult<PyObject> {
    return Py.abs(object: object)
  }

  internal static var powDoc: String {
    return """
    Equivalent to x**y (with two arguments) or x**y % z (with three arguments)

    Some types, such as ints, are able to use a more efficient algorithm when
    invoked using the three argument form.
    """
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

  internal static var reprDoc: String {
    return """
    Return the canonical string representation of the object.

    For many object types, including most builtins, eval(repr(obj)) == obj.
    """
  }

  /// repr(object)
  /// See [this](https://docs.python.org/3/library/functions.html#repr)
  internal static func repr(object: PyObject) -> PyResult<PyString> {
    return Py.repr(object: object)
  }

  internal static var asciiDoc: String {
    return """
    Return an ASCII-only representation of an object.

    As repr(), return a string containing a printable representation of an
    object, but escape the non-ASCII characters in the string returned by
    repr() using \\x, \\u or \\U escapes. This generates a string similar
    to that returned by repr() in Python 2.
    """
  }

  /// ascii(object)
  /// See [this](https://docs.python.org/3/library/functions.html#ascii)
  internal static func ascii(object: PyObject) -> PyResult<PyString> {
    return Py.ascii(object: object)
  }
}

// MARK: - isinstance

extension Builtins {

  internal static var isinstanceDoc: String {
    return """
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

  internal static var issubclassDoc: String {
    return """
    Return whether 'cls' is a derived from another class or is the same class.

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

  internal static var compileDoc: String {
    return """
    Compile source into a code object that can be executed by exec() or eval().

    The source code may represent a Python module, statement or expression.
    The filename will be used for run-time error messages.
    The mode must be 'exec' to compile a module, 'single' to compile a
    single (interactive) statement, or 'eval' to compile an expression.
    The flags argument, if present, controls which future statements influence
    the compilation of the code.
    The dont_inherit argument, if true, stops the compilation inheriting
    the effects of any future statements in effect in the code calling
    compile; if absent or false these statements do influence the compilation,
    in addition to any features explicitly specified.
    """
  }

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

      let compileResult = Py.compile(source: source,
                                     filename: filename,
                                     mode: mode,
                                     flags: flags,
                                     dontInherit: dontInherit,
                                     optimize: optimize)

      return compileResult.asResult()

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

  internal static var execDoc: String {
    return """
    Execute the given source in the context of globals and locals.

    The source may be a string representing one or more Python statements
    or a code object as returned by compile().
    The globals must be a dictionary and locals can be any mapping,
    defaulting to the current globals and locals.
    If only globals is given, locals defaults to it.
    """
  }

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

  internal static var evalDoc: String {
    return """
    Evaluate the given source in the context of globals and locals.

    The source may be a string representing a Python expression
    or a code object as returned by compile().
    The globals must be a dictionary and locals can be any mapping,
    defaulting to the current globals and locals.
    If only globals is given, locals defaults to it.
    """
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
