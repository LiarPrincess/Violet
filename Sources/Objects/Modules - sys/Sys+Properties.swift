import VioletCore

// In CPython:
// Python -> sysmodule.c
// https://docs.python.org/3.7/library/sys.html

extension Sys {

  // MARK: - Argv

  /// sys.argv
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.argv).
  ///
  /// The list of command line arguments passed to a Python script.
  /// `argv[0]` is the script name.
  /// If the command was executed using the `-c` command line option,
  /// `argv[0]` is set to the string `'-c'`.
  /// If no script name was passed to the Python interpreter,
  /// `argv[0]` is the empty string.
  public func getArgv() -> PyResult<PyList> {
    return self.getList(.argv)
  }

  public func setArgv(to value: PyObject) -> PyBaseException? {
    return self.set(.argv, to: value)
  }

  /// pymain_init_core_argv(_PyMain *pymain, _PyCoreConfig *config, ...)
  /// And then modified using:
  /// https://docs.python.org/3.8/using/cmdline.html
  ///
  /// Please note that `VM` will also modify `argv` using `setArgv0`.
  internal func createInitialArgv() -> PyList {
    let arguments = Py.config.arguments
    let argumentsWithoutProgramName = arguments.raw.dropFirst()

    var result = Array(argumentsWithoutProgramName)

    if result.isEmpty {
      result = [""]
    }

    assert(result.any)
    let objects = result.map(Py.newString(_:))
    return Py.newList(objects)
  }

  // MARK: - Argv0

  public func getArgv0() -> PyResult<PyString> {
    let list: PyList
    switch self.getArgv() {
    case let .value(l): list = l
    case let .error(e): return .error(e)
    }

    guard let first = list.elements.first else {
      let msg = "'sys.argv' is empty"
      return .valueError(msg)
    }

    guard let result = first as? PyString else {
      let t = first.typeName
      let msg = "Expected first element of 'sys.argv' to be a str, but got \(t)"
      return .typeError(msg)
    }

    return .value(result)
  }

  public func setArgv0(value: String) -> PyResult<PyNone> {
    let list: PyList
    switch self.getArgv() {
    case let .value(l): list = l
    case let .error(e): return .error(e)
    }

    let object = Py.newString(value)

    if list.data.isEmpty {
      list.data.append(object)
      return .value(Py.none)
    }

    return list.data.setItem(index: 0, value: object)
  }

  // MARK: - Flags

  /// sys.flags
  /// See [this](https://docs.python.org/3/library/sys.html#sys.flags).
  ///
  /// The named tuple flags exposes the status of command line flags.
  /// The attributes are read only.
  public func getFlags() -> PyResult<PyObject> {
    return self.get(.flags)
  }

  internal func createInitialFlags() -> PyNamespace {
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

  // MARK: - Warn options

  /// sys.warnoptions
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.warnoptions).
  public func getWarnOptions() -> PyResult<PyList> {
    return self.getList(.warnoptions)
  }

  /// static _PyInitError
  /// config_init_warnoptions(_PyCoreConfig *config, _PyCmdline *cmdline)
  ///
  /// Then:
  /// 1. It is moved to '_PyMainInterpreterConfig' (in '_PyMainInterpreterConfig_Read')
  /// 2. Set as 'sys.warnoptions' (in _PySys_EndInit)
  internal func createInitialWarnOptions() -> PyList {
    var result = [String]()

    let options = self.flags.warnings
    let filters = options.map(String.init(describing:))
    result.append(contentsOf: filters)

    switch self.flags.bytesWarning {
    case .ignore:
      break
    case .warning:
      result.append("default::BytesWarning")
    case .error:
      result.append("error::BytesWarning")
    }

    let strings = result.map(Py.newString(_:))
    return Py.newList(strings)
  }

  // MARK: - Executable

  /// sys.executable
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.executable).
  ///
  /// A string giving the absolute path of the executable binary for
  /// the Python interpreter, on systems where this makes sense.
  /// If Python is unable to retrieve the real path to its executable,
  /// `sys.executable` will be an empty string or `None`.
  public func getExecutable() -> PyResult<PyString> {
    return self.getString(.executable)
  }

  // MARK: - Platform

  /// sys.platform
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.platform).
  ///
  /// This string contains a platform identifier that can be used to append
  /// platform-specific components to `sys.path`, for instance.
  public func getPlatform() -> PyResult<PyString> {
    return self.getString(.platform)
  }

  // MARK: - Copyright

  /// sys.copyright
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.copyright).
  ///
  /// A string containing the copyright pertaining to the Python interpreter.
  public func getCopyright() -> PyResult<PyString> {
    return self.getString(.copyright)
  }

  // MARK: - Hash

  /// sys.hash_info
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.hash_info).
  internal func getHashInfo() -> PyResult<PyObject> {
    return self.get(.hash_info)
  }

  internal func createInitialHashInfo() -> PyNamespace {
    let dict = PyDict()

    func set(name: String, value: PyObject) {
      let interned = Py.intern(string: name)
      switch dict.set(key: interned, to: value) {
      case .ok:
        break
      case .error(let e):
        trap("Error when creating 'hash_info' namespace: \(e)")
      }
    }

    set(name: "width", value: Py.newInt(self.hashInfo.width))
    set(name: "modulus", value: Py.newInt(self.hashInfo.modulus))
    set(name: "inf", value: Py.newInt(self.hashInfo.inf))
    set(name: "nan", value: Py.newInt(self.hashInfo.nan))
    set(name: "imag", value: Py.newInt(self.hashInfo.imag))
    set(name: "algorithm", value: Py.newString(self.hashInfo.algorithm))
    set(name: "hash_bits", value: Py.newInt(self.hashInfo.hashBits))
    set(name: "seed_bits", value: Py.newInt(self.hashInfo.seedBits))

    return Py.newNamespace(dict: dict)
  }
}
