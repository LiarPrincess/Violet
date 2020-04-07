import Core

// In CPython:
// Python -> sysmodule.c
// https://docs.python.org/3.7/library/sys.html

extension Sys {

  // MARK: - Argv

  // sourcery: pyproperty = argv, setter = setArgv
  /// sys.argv
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.argv).
  ///
  /// The list of command line arguments passed to a Python script.
  /// `argv[0]` is the script name.
  /// If the command was executed using the `-c` command line option,
  /// `argv[0]` is set to the string `'-c'`.
  /// If no script name was passed to the Python interpreter,
  /// `argv[0]` is the empty string.
  internal var argv: PyObject {
    if let value = self.get(key: .argv) {
      return value
    }

    let strings = self.createDefaultArgv()
    let objects = strings.map(Py.newString(_:))
    return Py.newList(objects)
  }

  internal func setArgv(to value: PyObject) -> PyResult<()> {
    self.set(key: .argv, value: value)
    return .value()
  }

  /// pymain_init_core_argv(_PyMain *pymain, _PyCoreConfig *config, ...)
  /// And then modified using:
  /// https://docs.python.org/3.8/using/cmdline.html
  ///
  /// Please note that `VM` will also modify `argv` using `setArgv0`.
  private func createDefaultArgv() -> [String] {
    let arguments = Py.config.arguments
    let argumentsWithoutProgramName = arguments.raw.dropFirst()

    var result = Array(argumentsWithoutProgramName)

    if result.isEmpty {
      result = [""]
    }

    assert(result.any)
    return result
  }

  public func setArgv0(value: String) -> PyResult<PyNone> {
    guard let list = self.argv as? PyList else {
      let t = self.argv.typeName
      let pikachu = "<surprised Pikachu face>"
      return .typeError("expected 'sys.argv' to be a list not \(t) \(pikachu)")
    }

    let object = Py.newString(value)
    if list.data.isEmpty {
      list.data.append(object)
      return .value(Py.none)
    }

    return list.data.setItem(at: 0, to: object)
  }

  // MARK: - Flags

  // sourcery: pyproperty = flags
  /// sys.flags
  /// See [this](https://docs.python.org/3/library/sys.html#sys.flags).
  ///
  /// The named tuple flags exposes the status of command line flags.
  /// The attributes are read only.
  internal var flagsObject: PyObject {
    if let value = self.get(key: .flags) {
      return value
    }

    return self.createFlagsObject()
  }

  private func createFlagsObject() -> PyNamespace {
    let dict = PyDict()

    func insertOrTrap(name: String, value: PyObject) {
      let key = Py.newString(name)
      switch dict.set(key: key, to: value) {
      case .ok:
        break
      case .error(let e):
        trap("Error when inserting '\(name)' to 'sys.flags': \(e)")
      }
    }

    let ignoreEnvironment = Py.newBool(self.flags.ignoreEnvironment)

    let optimize: PyInt = {
      switch self.flags.optimize {
      case .none: return Py.newInt(0)
      case .O: return Py.newInt(1)
      case .OO: return Py.newInt(2)
      }
    }()

    let bytesWarning: PyInt = {
      switch self.flags.bytesWarning {
      case .ignore: return Py.newInt(0)
      case .warning: return Py.newInt(1)
      case .error: return Py.newInt(2)
      }
    }()

    insertOrTrap(name: "debug", value: Py.newBool(self.flags.debug))
    insertOrTrap(name: "inspect", value: Py.newBool(self.flags.inspect))
    insertOrTrap(name: "interactive", value: Py.newBool(self.flags.interactive))
    insertOrTrap(name: "optimize", value: optimize)
    insertOrTrap(name: "ignore_environment", value: ignoreEnvironment)
    insertOrTrap(name: "verbose", value: Py.newInt(self.flags.verbose))
    insertOrTrap(name: "bytes_warning", value: bytesWarning)
    insertOrTrap(name: "quiet", value: Py.newBool(self.flags.quiet))
    insertOrTrap(name: "isolated", value: Py.newBool(self.flags.isolated))

    return Py.newNamespace(dict: dict)
  }

  // MARK: - Executable

  // sourcery: pyproperty = executable
  /// sys.executable
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.executable).
  ///
  /// A string giving the absolute path of the executable binary for
  /// the Python interpreter, on systems where this makes sense.
  /// If Python is unable to retrieve the real path to its executable,
  /// `sys.executable` will be an empty string or `None`.
  internal var executable: PyObject {
    if let value = self.get(key: .executable) {
      return value
    }

    let result = Py.config.executablePath
    return Py.newString(result)
  }

  // MARK: - Platform

  public var platform: String {
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

  // sourcery: pyproperty = platform
  /// sys.platform
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.platform).
  ///
  /// This string contains a platform identifier that can be used to append
  /// platform-specific components to `sys.path`, for instance.
  internal var platformObject: PyString {
    return Py.intern(self.platform)
  }

  // MARK: - Copyright

  public var copyright: String {
    return Lyrics.letItGo
  }

  // sourcery: pyproperty = copyright
  /// sys.copyright
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.copyright).
  ///
  /// A string containing the copyright pertaining to the Python interpreter.
  internal var copyrightObject: PyString {
    return Py.intern(self.copyright)
  }

  // MARK: - Hash

  // sourcery: pyproperty = hash_info
  /// sys.hash_info
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.hash_info).
  internal var hashInfoObject: PyObject {
    return self.hashInfo.object
  }
}
