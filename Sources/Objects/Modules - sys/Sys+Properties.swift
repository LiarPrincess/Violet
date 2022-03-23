import FileSystem
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
  public func getArgv() -> PyResultGen<PyList> {
    return self.getList(.argv)
  }

  public func setArgv(_ value: PyObject) -> PyBaseException? {
    return self.set(.argv, value: value)
  }

  /// pymain_init_core_argv(_PyMain *pymain, _PyCoreConfig *config, ...)
  /// And then modified using:
  /// https://docs.python.org/3.8/using/cmdline.html
  ///
  /// Please note that `VM` will also modify `argv` using `setArgv0`.
  internal func createInitialArgv() -> PyList {
    let arguments = self.py.config.arguments
    let argumentsWithoutProgramName = arguments.raw.dropFirst()

    var elements = [PyObject]()

    if argumentsWithoutProgramName.isEmpty {
      let empty = self.py.emptyString
      elements.append(empty.asObject)
    } else {
      for arg in argumentsWithoutProgramName {
        let string = py.newString(arg)
        elements.append(string.asObject)
      }
    }

    return self.py.newList(elements: elements)
  }

  // MARK: - Argv0

  public func getArgv0() -> PyResultGen<PyString> {
    let list: PyList
    switch self.getArgv() {
    case let .value(l): list = l
    case let .error(e): return .error(e)
    }

    guard let first = list.elements.first else {
      return .valueError(self.py, message: "'sys.argv' is empty")
    }

    guard let result = self.py.cast.asString(first) else {
      let msg = "Expected first element of 'sys.argv' to be a str, but got \(first.typeName)"
      return .typeError(self.py, message: msg)
    }

    return .value(result)
  }

  public func setArgv0(_ value: Path) -> PyBaseException? {
    return self.setArgv0(value.string)
  }

  public func setArgv0(_ value: String) -> PyBaseException? {
    let list: PyList
    switch self.getArgv() {
    case let .value(l): list = l
    case let .error(e): return e
    }

    let string = self.py.newString(value)
    let object = string.asObject

    if list.isEmpty {
      list.append(object: object)
      return nil
    }

    switch list.setItem(self.py, index: 0, value: object) {
    case .value:
      return nil
    case .error(let e):
      return e
    }
  }

  // MARK: - Flags

  /// sys.flags
  /// See [this](https://docs.python.org/3/library/sys.html#sys.flags).
  ///
  /// The named tuple flags exposes the status of command line flags.
  /// The attributes are read only.
  public func getFlags() -> PyResult {
    return self.get(.flags)
  }

  internal func createInitialFlags() -> PyNamespace {
    let dict = self.py.newDict()

    func insertOrTrap<T: PyObjectMixin>(name: String, value: T) {
      let key = self.py.newString(name)
      switch dict.set(self.py, key: key, value: value.asObject) {
      case .ok:
        break
      case .error(let e):
        trap("Error when inserting '\(name)' to 'sys.flags': \(e)")
      }
    }

    let optimize: Int
    switch self.flags.optimize {
    case .none: optimize = 0
    case .O: optimize = 1
    case .OO: optimize = 2
    }

    let bytesWarning: Int
    switch self.flags.bytesWarning {
    case .ignore: bytesWarning = 0
    case .warning: bytesWarning = 1
    case .error: bytesWarning = 2
    }

    insertOrTrap(name: "debug", value: self.py.newBool(self.flags.debug))
    insertOrTrap(name: "inspect", value: self.py.newBool(self.flags.inspect))
    insertOrTrap(name: "interactive", value: self.py.newBool(self.flags.interactive))
    insertOrTrap(name: "optimize", value: self.py.newInt(optimize))
    insertOrTrap(name: "ignore_environment", value: self.py.newBool(self.flags.ignoreEnvironment))
    insertOrTrap(name: "verbose", value: self.py.newInt(self.flags.verbose))
    insertOrTrap(name: "bytes_warning", value: self.py.newInt(bytesWarning))
    insertOrTrap(name: "quiet", value: self.py.newBool(self.flags.quiet))
    insertOrTrap(name: "isolated", value: self.py.newBool(self.flags.isolated))

    return self.py.newNamespace(dict: dict)
  }

  // MARK: - Warn options

  /// sys.warnoptions
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.warnoptions).
  public func getWarnOptions() -> PyResultGen<PyList> {
    return self.getList(.warnoptions)
  }

  /// static _PyInitError
  /// config_init_warnoptions(_PyCoreConfig *config, _PyCmdline *cmdline)
  ///
  /// Then:
  /// 1. It is moved to '_PyMainInterpreterConfig' (in '_PyMainInterpreterConfig_Read')
  /// 2. Set as 'sys.warnoptions' (in _PySys_EndInit)
  internal func createInitialWarnOptions() -> PyList {
    var elements = [PyObject]()

    for option in self.flags.warnings {
      let string = self.py.newString(option.description)
      elements.append(string.asObject)
    }

    switch self.flags.bytesWarning {
    case .ignore:
      break
    case .warning:
      let string = py.newString("default::BytesWarning")
      elements.append(string.asObject)
    case .error:
      let string = py.newString("error::BytesWarning")
      elements.append(string.asObject)
    }

    return self.py.newList(elements: elements)
  }

  // MARK: - Executable

  /// sys.executable
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.executable).
  ///
  /// A string giving the absolute path of the executable binary for
  /// the Python interpreter, on systems where this makes sense.
  /// If Python is unable to retrieve the real path to its executable,
  /// `sys.executable` will be an empty string or `None`.
  public func getExecutable() -> PyResultGen<PyString> {
    return self.getString(.executable)
  }

  internal func createInitialExecutablePath() -> PyString {
    let executablePath = self.py.config.executablePath
    return self.py.newString(executablePath)
  }

  // MARK: - Platform

  /// sys.platform
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.platform).
  ///
  /// This string contains a platform identifier that can be used to append
  /// platform-specific components to `sys.path`, for instance.
  public func getPlatform() -> PyResultGen<PyString> {
    return self.getString(.platform)
  }

  // MARK: - Copyright

  /// sys.copyright
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.copyright).
  ///
  /// A string containing the copyright pertaining to the Python interpreter.
  public func getCopyright() -> PyResultGen<PyString> {
    return self.getString(.copyright)
  }

  // MARK: - Hash

  /// sys.hash_info
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.hash_info).
  internal func getHashInfo() -> PyResult {
    return self.get(.hash_info)
  }

  internal func createInitialHashInfo() -> PyNamespace {
    let dict = self.py.newDict()

    func set<T: PyObjectMixin>(name: String, value: T) {
      let interned = self.py.intern(string: name)
      switch dict.set(self.py, key: interned, value: value.asObject) {
      case .ok:
        break
      case .error(let e):
        trap("Error when creating 'hash_info' namespace: \(e)")
      }
    }

    set(name: "width", value: self.py.newInt(Self.hashInfo.width))
    set(name: "modulus", value: self.py.newInt(Self.hashInfo.modulus))
    set(name: "inf", value: self.py.newInt(Self.hashInfo.inf))
    set(name: "nan", value: self.py.newInt(Self.hashInfo.nan))
    set(name: "imag", value: self.py.newInt(Self.hashInfo.imag))
    set(name: "algorithm", value: self.py.newString(Self.hashInfo.algorithm))
    set(name: "hash_bits", value: self.py.newInt(Self.hashInfo.hashBits))
    set(name: "seed_bits", value: self.py.newInt(Self.hashInfo.seedBits))

    return self.py.newNamespace(dict: dict)
  }

  // MARK: - Maxsize

  /// sys.maxsize
  ///
  /// An integer giving the maximum value a variable of type `Py_ssize_t` can take.
  /// It’s usually `2**31 - 1` on a 32-bit platform and `2**63 - 1` on a 64-bit
  /// platform.
  ///
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.maxsize).
  public func getMaxSize() -> PyResultGen<PyInt> {
    return self.getInt(.maxsize)
  }
}
