extension Sys {

  // MARK: - Properties

  // sourcery: pyproperty: argv
  /// sys.argv
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.argv).
  public func getArgv() -> PyObject {
    return self.unimplemented
  }

  // sourcery: pyproperty: modules
  /// sys.modules
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.modules).
  public func getModules() -> PyObject {
    return self.unimplemented
  }

  // sourcery: pyproperty: path
  /// sys.path
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.path).
  public func getPath() -> PyObject {
    return self.unimplemented
  }

  // sourcery: pyproperty: executable
  /// sys.executable
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.executable).
  public func getExecutable() -> PyObject {
    return self.unimplemented
  }

  // sourcery: pyproperty: builtin_module_names
  /// sys.builtin_module_names
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.builtin_module_names).
  public func getBuiltinModuleNames() -> PyObject {
    return self.unimplemented
  }

  // sourcery: pyproperty: warnoptions
  /// sys.warnoptions
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.warnoptions).
  public func getWarnOptions() -> PyObject {
    return self.unimplemented
  }

  // MARK: - Version

  // sourcery: pyproperty: version
  /// sys.version
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.version).
  public func getVersion() -> PyObject {
    return self.unimplemented
  }

  // sourcery: pyproperty: version_info
  /// sys.version_info
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.version_info).
  public func getVersionInfo() -> PyObject {
    return self.unimplemented
  }

  // sourcery: pyproperty: implementation
  /// sys.implementation
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.implementation).
  public func getImplementation() -> PyObject {
    return self.unimplemented
  }

  // MARK: - Hash

  // sourcery: pyproperty: hash_info
  /// sys.hash_info
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.hash_info).
  public func getHashInfo() -> PyObject {
    return self.unimplemented
  }

  // MARK: - Copyright

  // sourcery: pyproperty: copyright
  /// sys.copyright
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.copyright).
  public func getCopyright() -> PyObject {
    return self.unimplemented
  }

  // MARK: - Breakpointhook

  // sourcery: pymethod: breakpointhook
  /// sys.breakpointhook()
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.breakpointhook).
  public func breakpointHook() -> PyObject {
    return self.unimplemented
  }

  // sourcery: pyproperty: __breakpointhook__
  /// sys.__breakpointhook__
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.__breakpointhook__).
  public func get__breakpointhook__() -> PyObject {
    return self.unimplemented
  }

  // MARK: - Displayhook

  // sourcery: pymethod: displayhook
  /// sys.displayhook(value)
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.displayhook).
  public func displayHook() -> PyObject {
    return self.unimplemented
  }

  // sourcery: pyproperty: __displayhook__
  /// sys.__displayhook__
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.__displayhook__).
  public func get__displayhook__() -> PyObject {
    return self.unimplemented
  }

  // MARK: - Excepthook

  // sourcery: pymethod: excepthook
  /// sys.excepthook(type, value, traceback)
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.excepthook).
  public func excepthook() -> PyObject {
    return self.unimplemented
  }

  // sourcery: pyproperty: __excepthook__
  /// sys.__excepthook__
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.__excepthook__).
  public func get__excepthook__() -> PyObject {
    return self.unimplemented
  }

  // MARK: - Exit

  // sourcery: pymethod: exit
  /// sys.exit([arg])
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.exit).
  public func exit() -> PyObject {
    return self.unimplemented
  }

  // MARK: - Streams

  // sourcery: pyproperty: stdin
  /// sys.stdin
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.stdin).
  public func getStdin() -> PyObject {
    return self.unimplemented
  }

  // sourcery: pyproperty: stdout
  /// sys.stdout
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.stdin).
  public func getStdout() -> PyObject {
    return self.unimplemented
  }

  // sourcery: pyproperty: stderr
  /// sys.stderr
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.stdin).
  public func getStderr() -> PyObject {
    return self.unimplemented
  }

  // sourcery: pyproperty: __stdin__
  /// sys.__stdin__
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.__stdin__).
  public func get__stdin__() -> PyObject {
    return self.unimplemented
  }

  // sourcery: pyproperty: __stdout__
  /// sys.__stdout__
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.__stdin__).
  public func get__stdout__() -> PyObject {
    return self.unimplemented
  }

  // sourcery: pyproperty: __stderr__
  /// sys.__stderr__
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.__stdin__).
  public func get__stderr__() -> PyObject {
    return self.unimplemented
  }

  // MARK: - Helpers

  internal var unimplemented: PyObject {
    return self.builtins.none
  }

  // MARK: - Other

  // sourcery: pyproperty: byteorder
  /// sys.byteorder
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.byteorder).
  public func getByteOrder() -> PyObject {
    return self.unimplemented
  }

  // sourcery: pymethod: exc_info
  /// sys.exc_info()
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.exc_info).
  public func excInfo() -> PyObject {
    return self.unimplemented
  }
}
