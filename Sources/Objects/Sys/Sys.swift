import Core

// In CPython:
// Python -> sysmodule.c
// https://docs.python.org/3.7/library/sys.html

// sourcery: pymodule = sys
public final class Sys {

  internal static let doc = """
    This module provides access to some objects used or maintained by the
    interpreter and to functions that interact strongly with the interpreter.

    Dynamic objects:

    argv -- command line arguments; argv[0] is the script pathname if known
    path -- module search path; path[0] is the script directory, else ''
    modules -- dictionary of loaded modules

    displayhook -- called to show results in an interactive session
    excepthook -- called to handle any uncaught exception other than SystemExit
      To customize printing in an interactive session or to install a custom
      top-level exception handler, assign other functions to replace these.

    stdin -- standard input file object; used by input()
    stdout -- standard output file object; used by print()
    stderr -- standard error object; used for error messages
      By assigning other file objects (or objects that behave like files)
      to these, it is possible to redirect all of the interpreter's I/O.

    last_type -- type of last uncaught exception
    last_value -- value of last uncaught exception
    last_traceback -- traceback of last uncaught exception
      These three are only available in an interactive session after a
      traceback has been printed.

    Static objects:

    builtin_module_names -- tuple of module names built into this interpreter
    copyright -- copyright notice pertaining to this interpreter
    exec_prefix -- prefix used to find the machine-specific Python library
    executable -- absolute path of the executable binary of the Python interpreter
    float_info -- a struct sequence with information about the float implementation.
    float_repr_style -- string indicating the style of repr() output for floats
    hash_info -- a struct sequence with information about the hash algorithm.
    hexversion -- version information encoded as a single integer
    implementation -- Python implementation information.
    int_info -- a struct sequence with information about the int implementation.
    maxsize -- the largest supported length of containers.
    maxunicode -- the value of the largest Unicode code point
    platform -- platform identifier
    prefix -- prefix used to find the Python library
    thread_info -- a struct sequence with information about the thread implementation.
    version -- the version of this interpreter as a string
    version_info -- version information as a named tuple
    __stdin__ -- the original stdin; don't touch!
    __stdout__ -- the original stdout; don't touch!
    __stderr__ -- the original stderr; don't touch!
    __displayhook__ -- the original displayhook; don't touch!
    __excepthook__ -- the original excepthook; don't touch!

    Functions:

    displayhook() -- print an object to the screen, and save it in builtins._
    excepthook() -- print an exception and its traceback to sys.stderr
    exc_info() -- return thread-safe information about the current exception
    exit() -- exit the interpreter by raising SystemExit
    getdlopenflags() -- returns flags to be used for dlopen() calls
    getprofile() -- get the global profiling function
    getrefcount() -- return the reference count for an object (plus one :-)
    getrecursionlimit() -- return the max recursion depth for the interpreter
    getsizeof() -- return the size of an object in bytes
    gettrace() -- get the global debug tracing function
    setcheckinterval() -- control how often the interpreter checks for events
    setdlopenflags() -- set the flags to be used for dlopen() calls
    setprofile() -- set the global profiling function
    setrecursionlimit() -- set the max recursion depth for the interpreter
    settrace() -- set the global debug tracing function
    """

  // MARK: - Dict

  /// This dict will be used inside our `PyModule` instance.
  internal private(set) lazy var __dict__ = Py.newDict()

  // MARK: - Modules

  public internal(set) var builtinModuleNames = [String]()

  // MARK: - Version

  /// `sys.version_info`
  ///
  /// ```
  /// >>> sys.version_info
  /// sys.version_info(major=3, minor=7, micro=2, releaselevel='final', serial=0)
  /// ```
  public lazy var versionInfo = VersionInfo(
    major: 3,
    minor: 7,
    micro: 2,
    releaseLevel: .final,
    serial: 0
  )

  public lazy var implementationInfo = ImplementationInfo(
    name: "violet",
    version: VersionInfo(
      major: 0,
      minor: 3,
      micro: 0,
      releaseLevel: .beta,
      serial: 0
    ),
    cacheTag: nil
  )

  // MARK: - Hash

  public lazy var hashInfo = HashInfo()

  // MARK: - Streams

  // sourcery: pyproperty = __stdin__
  /// sys.__stdin__
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.__stdin__).
  public lazy var __stdin__ = self.createStdio(name: "<stdin>",
                                               fd: Py.config.standardInput,
                                               mode: .read)

  // sourcery: pyproperty = __stdout__
  /// sys.__stdout__
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.__stdin__).
  public lazy var __stdout__ = self.createStdio(name: "<stdout>",
                                                fd: Py.config.standardOutput,
                                                mode: .write)

  // sourcery: pyproperty = __stderr__
  /// sys.__stderr__
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.__stdin__).
  public lazy var __stderr__ = self.createStdio(name: "<stderr>",
                                                fd: Py.config.standardError,
                                                mode: .write)

  /// static PyObject*
  /// create_stdio(PyObject* io,
  private func createStdio(name: String,
                           fd: FileDescriptorType,
                           mode: FileMode) -> PyTextFile {
    return PyTextFile(name: name,
                      fd: fd,
                      mode: mode,
                      encoding: Unimplemented.stdioEncoding,
                      errors: Unimplemented.stdioErrors,
                      closeOnDealloc: false)
  }

  // MARK: - Get/set

  /// Get value from `self.__dict__`.
  internal func get(key: IdString) -> PyObject? {
    return self.__dict__.get(id: key)
  }

  /// Set value in `self.__dict__`.
  internal func set(key: IdString, value: PyObject) {
    self.__dict__.set(id: key, to: value)
  }
}
