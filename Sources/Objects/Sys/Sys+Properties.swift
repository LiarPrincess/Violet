import Core

// In CPython:
// Python -> sysmodule.c
// https://docs.python.org/3.7/library/sys.html

public enum GetModuleResult {
  case value(PyObject)
  case notFound(PyBaseException)
  case error(PyBaseException)
}

extension Sys {

  // MARK: - PS1

  // sourcery: pyproperty = ps1, setter = setPS1
  /// sys.ps1
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.ps1).
  ///
  /// Strings specifying the primary and secondary prompt of the interpreter.
  /// These are only defined if the interpreter is in interactive mode.
  internal var ps1Object: PyObject {
    return self.get(key: .ps1) ?? Py.getInterned(">>> ")
  }

  internal func setPS1(to value: PyObject) -> PyResult<()> {
    self.set(key: .ps1, value: value)
    return .value()
  }

  /// String that should be printed in interactive mode.
  public var ps1: String {
    switch Py.strValue(self.ps1Object) {
    case .value(let s): return s
    case .error: return ""
    }
  }

  // MARK: - PS2

  // sourcery: pyproperty = ps2, setter = setPS2
  /// sys.ps2
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.ps1).
  ///
  /// Strings specifying the primary and secondary prompt of the interpreter.
  /// These are only defined if the interpreter is in interactive mode.
  internal var ps2Object: PyObject {
    return self.get(key: .ps2) ?? Py.getInterned("... ")
  }

  internal func setPS2(to value: PyObject) -> PyResult<()> {
    self.set(key: .ps2, value: value)
    return .value()
  }

  /// String that should be printed in interactive mode.
  public var ps2: String {
    switch Py.strValue(self.ps2Object) {
    case .value(let s): return s
    case .error: return ""
    }
  }

  // MARK: - Stdin

  // sourcery: pyproperty = stdin, setter = setStdin
  /// sys.stdin
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.stdin).
  internal var stdin: PyObject {
    return self.get(key: .stdin) ?? self.__stdin__
  }

  internal func setStdin(to value: PyObject) -> PyResult<()> {
    self.set(key: .stdin, value: value)
    return .value()
  }

  // MARK: - Stdout

  // sourcery: pyproperty = stdout, setter = setStdout
  /// sys.stdout
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.stdin).
  internal var stdout: PyObject {
    return self.get(key: .stdout) ?? self.__stdout__
  }

  internal func setStdout(to value: PyObject) -> PyResult<()> {
    self.set(key: .stdout, value: value)
    return .value()
  }

  // MARK: - Stderr

  // sourcery: pyproperty = stderr, setter = setStderr
  /// sys.stderr
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.stdin).
  internal var stderr: PyObject {
    return self.get(key: .stderr) ?? self.__stderr__
  }

  internal func setStderr(to value: PyObject) -> PyResult<()> {
    self.set(key: .stderr, value: value)
    return .value()
  }

  // MARK: - Builtin modules

  // sourcery: pyproperty = builtin_module_names
  /// sys.builtin_module_names
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.builtin_module_names).
  ///
  /// A tuple of strings giving the names of all modules that are compiled
  /// into this Python interpreter.
  internal var builtinModuleNamesObject: PyObject {
    return self.get(key: .builtin_module_names) ?? Py.newTuple()
  }

  internal func setBuiltinModules(to value: PyObject) -> PyResult<()> {
    self.set(key: .builtin_module_names, value: value)
    return .value()
  }

  internal func setBuiltinModules(modules: PyModule...) {
    assert(
      self.builtinModuleNames.isEmpty,
      "This function should be called in 'Py.initialize(config:delegate:)'."
    )

    var names = [PyString]()

    for module in modules {
      let name: String = {
        switch module.name {
        case .value(let s):
          return s
        case .error:
          trap("Error when inserting '\(module)' to 'sys.builtin_module_names': " +
               "unable to extract module name.")
        }
      }()

      let interned = Py.getInterned(name)
      names.append(interned)

      // sys.modules
      switch Py.add(dict: self.modules, key: interned, value: module) {
      case .value:
        break
      case .error(let e):
        trap("Error when inserting '\(name)' module to 'sys.modules': \(e)")
      }
    }

    // sys.builtin_module_names
    self.builtinModuleNames = names.map { $0.value }

    let tuple = Py.newTuple(names)
    switch self.setBuiltinModules(to: tuple) {
    case .value:
      break
    case .error(let e):
      trap("Error when setting 'sys.builtin_module_names': \(e)")
    }
  }

  // MARK: - Modules

  // sourcery: pyproperty = modules, setter = setModules
  /// sys.modules
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.modules).
  ///
  /// This is a dictionary that maps module names to modules
  /// which have already been loaded.
  public var modules: PyObject {
    return self.get(key: .modules) ?? PyDict()
  }

  internal func setModules(to value: PyObject) -> PyResult<()> {
    self.set(key: .modules, value: value)
    return .value()
  }

  internal func getModule(name: PyObject) -> GetModuleResult {
    switch Py.getItem(self.modules, at: name) {
    case let .value(o):
      return .value(o)
    case let .error(e):
      if e.isKeyError {
        return .notFound(e)
      }

      return .error(e)
    }
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
    return Py.getInterned(self.platform)
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
    return Py.getInterned(self.copyright)
  }

  // MARK: - Version

  public var version: String {
    let p = self.versionInfo
    let v = self.implementationInfo.version
    return "Python \(p.major).\(p.minor).\(p.micro) " +
           "(Violet \(v.major).\(v.minor).\(v.micro))"
  }

  // sourcery: pyproperty = version
  /// sys.version
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.version).
  internal var versionObject: PyString {
    return Py.getInterned(self.version)
  }

  // sourcery: pyproperty = version_info
  /// sys.version_info
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.version_info).
  ///
  /// A tuple containing the five components of the version number:
  /// major, minor, micro, releaselevel, and serial.
  /// All values except releaselevel are integers;
  /// the release level is 'alpha', 'beta', 'candidate', or 'final'.
  internal var versionInfoObject: PyObject {
    return self.versionInfo.object
  }

  // sourcery: pyproperty = implementation
  /// sys.implementation
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.implementation).
  internal var implementationObject: PyObject {
    return self.implementationInfo.object
  }

  // MARK: - Hash

  // sourcery: pyproperty = hash_info
  /// sys.hash_info
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.hash_info).
  internal var hashInfoObject: PyObject {
    return self.hashInfo.object
  }
}
