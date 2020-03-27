extension Sys {
/*
  // MARK: - Properties

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

  // MARK: - Exit

  // sourcery: pymethod = exit
  /// sys.exit([arg])
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.exit).
  internal func exit() -> PyObject {
    return self.unimplemented
  }

  // MARK: - Other

  // sourcery: pymethod = exc_info
  /// sys.exc_info()
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.exc_info).
  internal func excInfo() -> PyObject {
    return self.unimplemented
  }
*/
}
