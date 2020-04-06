import Core

// In CPython:
// Python -> _warnings.c
// https://docs.python.org/3/library/warnings.html

// Code in this file is mostly taken from:
// PyMODINIT_FUNC
// _PyWarnings_Init(void)

extension UnderscoreWarnings {

  // MARK: - Filters

  // sourcery: pyproperty = filters, setter = setFilters
  public var filters: PyObject {
    if let value = self.get(key: .filters) {
      return value
    }

    let list = self.getDefaultFilters()
    return list
  }

  /// static PyObject *
  /// init_filters(void)
  private func getDefaultFilters() -> PyList {
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
    let action = Py.getInterned(actionArg)
    let module: PyObject = moduleArg.map(Py.getInterned) ?? Py.none
    let msg = Py.none
    let line = Py.newInt(0)
    return Py.newTuple([action, msg, category, module, line])
  }

  public func setFilters(to value: PyObject) -> PyResult<()> {
    self.set(key: .filters, value: value)
    return .value()
  }

  internal func getFiltersList() -> PyResult<PyList> {
    let object = self.filters

    guard let list = object as? PyList else {
      return .valueError("_warnings.filters must be a list")
    }

    return .value(list)
  }

  // MARK: - Default action

  // sourcery: pyproperty = _defaultaction, setter = setDefaultAction
  public var defaultAction: PyObject {
    if let value = self.get(key: .defaultaction) {
      return value
    }

    return Py.newString("default")
  }

  public func setDefaultAction(to value: PyObject) -> PyResult<()> {
    self.set(key: .defaultaction, value: value)
    return .value()
  }

  internal func getDefaultActionString() -> PyResult<PyString> {
    let object = self.defaultAction

    guard let string = object as? PyString else {
      let t = object.typeName
      return .typeError("_warnings._defaultaction must be a string, not '\(t)'")
    }

    return .value(string)
  }

  // MARK: - Once registry

  // sourcery: pyproperty = _onceregistry, setter = setOnceRegistry
  public var onceRegistry: PyObject {
    if let value = self.get(key: ._onceregistry) {
      return value
    }

    return Py.newDict()
  }

  public func setOnceRegistry(to value: PyObject) -> PyResult<()> {
    self.set(key: ._onceregistry, value: value)
    return .value()
  }

  internal func getOnceRegistryDict() -> PyResult<PyDict> {
    let object = self.onceRegistry

    guard let dict = object as? PyDict else {
      let t = object.typeName
      return .typeError("_warnings._onceregistry must be a dict, not '\(t)'")
    }

    return .value(dict)
  }

  // MARK: - Helpers

  /// Get value from `self.__dict__`.
  internal func get(key: IdString) -> PyObject? {
    return self.__dict__.get(id: key)
  }

  /// Set value in `self.__dict__`.
  internal func set(key: IdString, value: PyObject) {
    self.__dict__.set(id: key, to: value)
  }
}
