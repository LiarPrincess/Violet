import Core

// In CPython:
// Python -> sysmodule.c
// https://docs.python.org/3.7/library/sys.html

public final class Sys: PyModuleImplementation {

  internal static let moduleName = "sys"

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

  // MARK: - Properties

  /// This dict will be used inside our `PyModule` instance.
  public let __dict__ = Py.newDict()

  /// Initial value for `sys.flags`.
  public let flags = SysFlags(
    arguments: Py.config.arguments,
    environment: Py.config.environment
  )

  /// Initial value for `sys.version_info`.
  public var versionInfo: VersionInfo {
    return Configure.versionInfo
  }

  /// Initial value for `sys.hex_version`.
  public var hexVersion: UInt32 {
    return self.versionInfo.hexVersion
  }

  /// Initial value for `sys.implementation`.
  public var implementation: ImplementationInfo {
    return Configure.implementationInfo
  }

  /// Initial value for `sys.version`.
  public private(set) lazy var version: String = {
    let v = self.versionInfo
    let i = self.implementation.version
    return "Python \(v.major).\(v.minor).\(v.micro) " +
           "(Violet \(i.major).\(i.minor).\(i.micro))"
  }()

  /// Initial value for `sys.hash_info`.
  public let hashInfo = HashInfo()

  /// This value will be returned in `sys.getdefaultencoding`.
  public var defaultEncoding: PyStringEncoding {
    return .utf8
  }

  /// Initial value for `sys.builtin_module_names`.
  public internal(set) var builtinModuleNames = [String]()

  /// Initial value for `sys.platform`.
  private var platform: String {
    #if os(macOS) || os(iOS) || os(watchOS) || os(tvOS)
    return "darwin"
    #elseif os(Linux) || os(Android)
    return "linux"
    #elseif os(Cygwin) // Is this even a thing?
    return "cygwin"
    #elseif os(Windows)
    return "win32"
    #else
    return "unknown"
    #endif
  }

  /// Initial value for `sys.copyright`.
  public var copyright: String {
    return Lyrics.galavant // Very important...
  }

  // MARK: - Init

  internal init() {
    self.fill__dict__()
  }

  // MARK: - Fill dict

  // swiftlint:disable:next function_body_length
  private func fill__dict__() {
    self.setOrTrap(.ps1, to: Py.newString(">>> "))
    self.setOrTrap(.ps2, to: Py.newString("... "))

    self.setOrTrap(.argv, to: self.createInitialArgv())
    self.setOrTrap(.flags, to: self.createInitialFlags())
    self.setOrTrap(.executable, to: Py.newString(Py.config.executablePath))
    self.setOrTrap(.platform, to: Py.newString(self.platform))
    self.setOrTrap(.copyright, to: Py.newString(self.copyright))
    self.setOrTrap(.hash_info, to: self.createInitialHashInfo())
    self.setOrTrap(.tracebacklimit, to: Py.newInt(1_000))

    self.setOrTrap(.modules, to: Py.newDict())
    self.setOrTrap(.builtin_module_names, to: Py.emptyTuple)

    let prefix = self.createInitialPrefix()
    let path = self.createInitialPath(prefix: prefix)
    self.setOrTrap(.meta_path, to: Py.newList())
    self.setOrTrap(.path_hooks, to: Py.newList())
    self.setOrTrap(.path_importer_cache, to: Py.newDict())
    self.setOrTrap(.path, to: path)
    self.setOrTrap(.prefix, to: prefix)

    let stdin = self.createInitialStdin()
    let stdout = self.createInitialStdout()
    let stderr = self.createInitialStderr()
    self.setOrTrap(.__stdin__, to: stdin)
    self.setOrTrap(.__stdout__, to: stdout)
    self.setOrTrap(.__stderr__, to: stderr)
    self.setOrTrap(.stdin, to: stdin)
    self.setOrTrap(.stdout, to: stdout)
    self.setOrTrap(.stderr, to: stderr)

    self.setOrTrap(.version, to: Py.newString(self.version))
    self.setOrTrap(.version_info, to: self.createInitialVersionInfo())
    self.setOrTrap(.implementation, to: self.createInitialImplementation())
    self.setOrTrap(.hexversion, to: Py.newInt(self.hexVersion))

    self.setOrTrap(.warnoptions, to: self.createInitialWarnOptions())

    // Not that capturing 'self' is intended.
    // See comment at the top of 'PyModuleImplementation' for details.
    self.setOrTrap(.exit,
                   doc: Self.exitDoc,
                   fn: self.exit(status:))
    self.setOrTrap(.intern,
                   doc: Self.internDoc,
                   fn: self.intern(value:))
    self.setOrTrap(.getdefaultencoding,
                   doc: Self.getDefaultEncodingDoc,
                   fn: self.getDefaultEncoding)
    self.setOrTrap(.excepthook,
                   doc: Self.excepthookDoc,
                   fn: self.excepthook(type:value:traceback:))
  }

  // MARK: - Properties

  internal struct Properties: CustomStringConvertible {

    internal static let ps1 = Properties(value: "ps1")
    internal static let ps2 = Properties(value: "ps2")

    internal static let argv = Properties(value: "argv")
    internal static let flags = Properties(value: "flags")
    internal static let executable = Properties(value: "executable")
    internal static let platform = Properties(value: "platform")
    internal static let copyright = Properties(value: "copyright")
    internal static let hash_info = Properties(value: "hash_info")
    internal static let tracebacklimit = Properties(value: "tracebacklimit")

    internal static let modules = Properties(value: "modules")
    internal static let builtin_module_names =
      Properties(value: "builtin_module_names")

    internal static let meta_path = Properties(value: "meta_path")
    internal static let path_hooks = Properties(value: "path_hooks")
    internal static let path_importer_cache = Properties(value: "path_importer_cache")
    internal static let path = Properties(value: "path")
    internal static let prefix = Properties(value: "prefix")

    internal static let __stdin__ = Properties(value: "__stdin__")
    internal static let __stdout__ = Properties(value: "__stdout__")
    internal static let __stderr__ = Properties(value: "__stderr__")
    internal static let stdin = Properties(value: "stdin")
    internal static let stdout = Properties(value: "stdout")
    internal static let stderr = Properties(value: "stderr")

    internal static let version = Properties(value: "version")
    internal static let version_info = Properties(value: "version_info")
    internal static let implementation = Properties(value: "implementation")
    internal static let hexversion = Properties(value: "hexversion")

    internal static let warnoptions = Properties(value: "warnoptions")

    internal static let exit = Properties(value: "exit")
    internal static let intern = Properties(value: "intern")
    internal static let getdefaultencoding = Properties(value: "getdefaultencoding")
    internal static let excepthook = Properties(value: "excepthook")

    private let value: String

    internal var description: String {
      return self.value
    }

    // Private so we can't create new values from the outside.
    private init(value: String) {
      self.value = value
    }
  }
}
