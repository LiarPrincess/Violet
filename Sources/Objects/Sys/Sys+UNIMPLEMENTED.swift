extension Sys {
/*
  // MARK: - Properties

  // sourcery: pyproperty = argv
  /// sys.argv
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.argv).
  ///
  /// The list of command line arguments passed to a Python script.
  /// `argv[0]` is the script name.
  /// If the command was executed using the `-c` command line option,
  /// `argv[0]` is set to the string `'-c'`.
  /// If no script name was passed to the Python interpreter,
  /// `argv[0]` is the empty string.
  internal func getArgv() -> PyObject {
    return self.unimplemented
  }

  // sourcery: pyproperty = path
  /// sys.path
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.path).
  ///
  /// A list of strings that specifies the search path for modules.
  /// Initialized from the environment variable PYTHONPATH,
  /// plus an installation-dependent default.
  ///
  /// `path[0]`, is the directory containing the script that was used to invoke
  /// the Python interpreter.
  /// If the script directory is not available, `path[0]` is the empty string,
  /// which directs Python to search modules in the current directory first.
  internal func getPath() -> PyObject {
    return self.unimplemented
  }

  // sourcery: pyproperty = builtin_module_names
  /// sys.builtin_module_names
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.builtin_module_names).
  ///
  /// A tuple of strings giving the names of all modules that are compiled
  /// into this Python interpreter.
  internal func getBuiltinModuleNames() -> PyObject {
    return self.unimplemented
  }

  // sourcery: pyproperty = executable
  /// sys.executable
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.executable).
  ///
  /// A string giving the absolute path of the executable binary for
  /// the Python interpreter, on systems where this makes sense.
  /// If Python is unable to retrieve the real path to its executable,
  /// `sys.executable` will be an empty string or `None`.
  internal func getExecutable() -> PyObject {
    return self.unimplemented
  }

  // sourcery: pyproperty = warnoptions
  /// sys.warnoptions
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.warnoptions).
  ///
  /// This is an implementation detail of the warnings framework;
  /// do not modify this value.
  /// Refer to the `warnings` module for more information on the warnings framework.
  internal func getWarnOptions() -> PyObject {
    return self.unimplemented
  }

  // MARK: - Breakpointhook

  // sourcery: pymethod = breakpointhook
  /// sys.breakpointhook()
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.breakpointhook).
  internal func breakpointHook() -> PyObject {
    return self.unimplemented
  }

  // sourcery: pyproperty = __breakpointhook__
  /// sys.__breakpointhook__
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.__breakpointhook__).
  internal func get__breakpointhook__() -> PyObject {
    return self.unimplemented
  }

  // MARK: - Displayhook

  // sourcery: pymethod = displayhook
  /// sys.displayhook(value)
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.displayhook).
  internal func displayHook() -> PyObject {
    return self.unimplemented
  }

  // sourcery: pyproperty = __displayhook__
  /// sys.__displayhook__
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.__displayhook__).
  internal func get__displayhook__() -> PyObject {
    return self.unimplemented
  }

  // MARK: - Excepthook

  // sourcery: pymethod = excepthook
  /// sys.excepthook(type, value, traceback)
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.excepthook).
  internal func excepthook() -> PyObject {
    return self.unimplemented
  }

  // sourcery: pyproperty = __excepthook__
  /// sys.__excepthook__
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.__excepthook__).
  internal func get__excepthook__() -> PyObject {
    return self.unimplemented
  }

  // MARK: - Exit

  // sourcery: pymethod = exit
  /// sys.exit([arg])
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.exit).
  internal func exit() -> PyObject {
    return self.unimplemented
  }

  // MARK: - Other

  // sourcery: pyproperty = byteorder
  /// sys.byteorder
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.byteorder).
  internal func getByteOrder() -> PyObject {
    return self.unimplemented
  }

  // sourcery: pymethod = exc_info
  /// sys.exc_info()
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.exc_info).
  internal func excInfo() -> PyObject {
    return self.unimplemented
  }
*/
}
