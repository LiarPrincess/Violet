import VioletCore

// cSpell:ignore PyMODINIT

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
    return self.set(.filters, value: value)
  }

  /// static PyObject *
  /// init_filters(void)
  internal func createInitialFilters() -> PyList {
    var elements = [PyObject]()

    func append(category: Py.WarningType, action: String, module: String?) {
      let filter = self.createFilter(category: category, action: action, module: module)
      elements.append(filter.asObject)
    }

    // python3 -b -Wd -Wignore
    // >>> import _warnings
    // >>> _warnings.filters
    // [Thingies…]

    switch self.py.sys.flags.bytesWarning {
    case .ignore:
      break
    case .warning:
      append(category: .bytes, action: "default", module: nil)
    case .error:
      append(category: .bytes, action: "error", module: nil)
    }

    // We have to reverse it, because the LATER options have bigger priority.
    for option in self.py.sys.flags.warnings.reversed() {
      let action = String(describing: option)
      append(category: .warning, action: action, module: nil)
    }

    #if DEBUG
    // DEBUG builds show all warnings by default
    #else
    // Other builds ignore a number of warning categories by default
    append(category: .deprecation, action: "default", module: "__main__")
    append(category: .deprecation, action: "ignore", module: nil)
    append(category: .pendingDeprecation, action: "ignore", module: nil)
    append(category: .import, action: "ignore", module: nil)
    append(category: .resource, action: "ignore", module: nil)
    #endif

    return self.py.newList(elements: elements)
  }

  private func createFilter(category: Py.WarningType,
                            action: String,
                            module: String?) -> PyTuple {
    let _category = self.py.getPythonType(type: category)
    let _action = self.py.intern(string: action)
    let _msg = self.py.none
    let _line = self.py.newInt(0)

    let _module: PyObject
    if let m = module {
      let string = self.py.intern(string: m)
      _module = string.asObject
    } else {
      _module = self.py.none.asObject
    }

    return self.py.newTuple(elements: _action.asObject,
                                      _msg.asObject,
                                      _category.asObject,
                                      _module,
                                      _line.asObject)
  }

  // MARK: - Default action

  public func getDefaultAction() -> PyResult<PyString> {
    return self.getString(._defaultaction)
  }

  public func setDefaultAction(to value: PyObject) -> PyBaseException? {
    return self.set(._defaultaction, value: value)
  }

  // MARK: - Once registry

  public func getOnceRegistry() -> PyResult<PyDict> {
    return self.getDict(._onceregistry)
  }

  public func setOnceRegistry(to value: PyObject) -> PyBaseException? {
    return self.set(._onceregistry, value: value)
  }
}
