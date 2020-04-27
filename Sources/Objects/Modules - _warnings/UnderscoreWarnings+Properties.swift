import VioletCore

// In CPython:
// Python -> _warnings.c
// https://docs.python.org/3/library/warnings.html

// Code in this file is mostly taken from:
// PyMODINIT_FUNC
// _PyWarnings_Init(void)

extension UnderscoreWarnings {

  // MARK: - Filters

  public func getFilters() -> PyResult<PyList> {
    return self.getList(.filters)
  }

  public func setFilters(to value: PyObject) -> PyBaseException? {
    return self.set(.filters, to: value)
  }

  /// static PyObject *
  /// init_filters(void)
  internal func createInitialFilters() -> PyList {
    var elements = [PyObject]()

    func append(category: PyWarningEnum, action: String, module: String?) {
      let filter = self.createFilter(category: category.asPyType,
                                     action: action,
                                     module: module)
      elements.append(filter)
    }

    // python3 -b -Wd -Wignore
    // >>> import _warnings
    // >>> _warnings.filters
    // [Thingies...]

    switch Py.sys.flags.bytesWarning {
    case .ignore:
      break
    case .warning:
      append(category: .bytes, action: "default", module: nil)
    case .error:
      append(category: .bytes, action: "error", module: nil)
    }

    // We have to reverse it, because the LATER options have bigger priority.
    for option in Py.sys.flags.warnings.reversed() {
      let action = String(describing: option)
      append(category: .warning, action: action, module: nil)
    }

    #if DEBUG
    // DEBUG builds show all warnings by default
    #else
    // Other builds ignore a number of warning categories by default
    append(category: .deprecationWarning, action: "default", module: "__main__")
    append(category: .deprecationWarning, action: "ignore", module: nil)
    append(category: .pendingDeprecationWarning, action: "ignore", module: nil)
    append(category: .importWarning, action: "ignore", module: nil)
    append(category: .resourceWarning, action: "ignore", module: nil)
    #endif

    return Py.newList(elements)
  }

  private func createFilter(category: PyType,
                            action actionArg: String,
                            module moduleArg: String?) -> PyTuple {
    let action = Py.intern(actionArg)
    let module: PyObject = moduleArg.map(Py.intern) ?? Py.none
    let msg = Py.none
    let line = Py.newInt(0)
    return Py.newTuple([action, msg, category, module, line])
  }

  // MARK: - Default action

  public func getDefaultAction() -> PyResult<PyString> {
    return self.getString(._defaultaction)
  }

  public func setDefaultAction(to value: PyObject) -> PyBaseException? {
    return self.set(._defaultaction, to: value)
  }

  // MARK: - Once registry

  public func getOnceRegistry() -> PyResult<PyDict> {
    return self.getDict(._onceregistry)
  }

  public func setOnceRegistry(to value: PyObject) -> PyBaseException? {
    return self.set(._onceregistry, to: value)
  }
}
