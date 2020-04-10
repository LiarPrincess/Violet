import Core

// In CPython:
// Python -> _warnings.c
// https://docs.python.org/3/library/warnings.html#warnings.warn_explicit
// https://docs.python.org/3/library/warnings.html#the-warnings-filter

extension UnderscoreWarnings {

  // swiftlint:disable function_parameter_count
  public func warnExplicit(message: PyObject,
                           category: PyType,
                           filename: PyString,
                           lineNo: PyInt,
                           module: PyString?,
                           source: PyObject?,
                           registry: WarningRegistry) -> PyResult<PyNone> {
    // swiftlint:enable function_parameter_count

    let warning = self.createWarning(
      message: message,
      category: category,
      filename: filename,
      lineNo: lineNo,
      module: module,
      source: source
    )

    switch warning {
    case let .value(w):
      return self.warnExplicit(warning: w, registry: registry)
    case let .error(e):
      return .error(e)
    }
  }

  /// static PyObject *
  /// warn_explicit(PyObject *category, PyObject *message, ...)
  internal func warnExplicit(warning: Warning,
                             registry: WarningRegistry) -> PyResult<PyNone> {
    let key = Py.newTuple([warning.text, warning.category, warning.lineNo])
    switch self.hasAlreadyWarned(registry: registry, key: key) {
    case .value(true): return .value(Py.none)
    case .value(false): break
    case .error(let e): return .error(e)
    }

    let filter: Filter
    switch self.getFilter(warning: warning) {
    case let .value(f): filter = f
    case let .error(e): return .error(e)
    }

    if filter.action == .error {
      let e = self.createException(warning: warning)
      return .error(e)
    }

    if filter.action == .ignore {
      return .value(Py.none)
    }

    // Store in the registry that we've been here,
    // except when the action is 'always'
    if filter.action != .always {
      if let e = self.storeInRegistry(registry: registry, key: key, filter: filter) {
        return .error(e)
      }
    }

    return self.show(warning: warning)
  }

  private func createException(warning: Warning) -> PyBaseException {
    switch Py.newException(type: warning.category, value: warning.message) {
    case let .value(e):
      return e
    case let .error(e):
      // There was an exception when creating an exception. Ehh...
      return e
    }
  }

  // MARK: - Filter

  /// static PyObject*
  /// get_filter(PyObject *category, PyObject *text, Py_ssize_t lineno,
  private func getFilter(warning: Warning) -> PyResult<Filter> {
    let filters: PyList
    switch self.getFiltersList() {
    case let .value(f): filters = f
    case let .error(e): return .error(e)
    }

    for (index, object) in filters.elements.enumerated() {
      guard let filter = object as? PyTuple, filter.elements.count == 5 else {
        return .valueError("_warnings.filters item \(index) isn't a 5-tuple")
      }

      switch self.isApplicable(filter: filter, warning: warning) {
      case .value(true):
        let object = filter.elements[0]
        guard let action = object as? PyString else {
          return .typeError("filter action must be an str, not \(object.typeName)")
        }
        return .value(Filter(action: action, object: .value(filter)))
      case .value(false):
        break // try other
      case .error(let e):
        return .error(e)
      }
    }

    let defaultAction = self.getDefaultActionString()
    return defaultAction.map { Filter(action: $0, object: .none) }
  }

  private func isApplicable(filter: PyTuple, warning: Warning) -> PyResult<Bool> {
    assert(filter.elements.count == 5)

    let filterMessage = filter.elements[1]
    switch self.compareStringOrNone(filter: filterMessage, arg: warning.text) {
    case .value(true): break // move to next one
    case .value(false): return .value(false)
    case .error(let e): return .error(e)
    }

    let filterCategory = filter.elements[2]
    switch warning.category.isSubtype(of: filterCategory) {
    case .value(true): break // move to next one
    case .value(false): return .value(false)
    case .error(let e): return .error(e)
    }

    let filterModule = filter.elements[3]
    switch self.compareStringOrNone(filter: filterModule, arg: warning.module) {
    case .value(true): break // move to next one
    case .value(false): return .value(false)
    case .error(let e): return .error(e)
    }

    let filterLine = filter.elements[4]
    switch self.compareLine(filter: filterLine, arg: warning.lineNo) {
    case .value(true): break // move to next one
    case .value(false): return .value(false)
    case .error(let e): return .error(e)
    }

    // Yay!
    return .value(true)
  }

  /// static int
  /// check_matched(PyObject *obj, PyObject *arg)
  private func compareStringOrNone(filter object: PyObject,
                                   arg: PyObject) -> PyResult<Bool> {
    // A 'None' filter always matches
    if object.isNone {
      return .value(true)
    }

    // An internal plain text default filter must match exactly
    if let str = object as? PyString {
      return Py.isEqualBool(left: str, right: arg)
    }

    // We do not suport regexes
    return .value(false)
  }

  private func compareLine(filter object: PyObject,
                           arg: PyInt) -> PyResult<Bool> {
    guard let int = object as? PyInt else {
      return .typeError("filter line must be an int, not \(object.typeName)")
    }

    // Filter line = 0 -> no line requirement
    if int.value == 0 {
      return .value(true)
    }

    let result = int.value == arg.value
    return .value(result)
  }

  // MARK: - Registry

  /// static int
  /// already_warned(PyObject *registry, PyObject *key, int should_set)
  private func hasAlreadyWarned(registry: WarningRegistry,
                                key: PyTuple) -> PyResult<Bool> {
    assert(key.elements.count == 3, "It should be: text, category, line")
    switch registry {
    case .dict(let dict):
      switch dict.get(key: key) {
      case .value(let o):
        return Py.isTrueBool(o)
      case .notFound:
        return .value(false)
      case .error(let e):
        return .error(e)
      }

    case .none:
      return .value(false)
    }
  }

  private func storeInRegistry(registry: WarningRegistry,
                               key: PyTuple,
                               filter: Filter) -> PyBaseException? {
    assert(key.elements.count == 3, "It should be: text, category, line")
    switch registry {
    case .dict(let dict):
      return self.storeInRegistry(registry: dict, key: key, filter: filter)
    case .none:
      return nil
    }
  }

  private func storeInRegistry(registry: PyDict,
                               key: PyTuple,
                               filter: Filter) -> PyBaseException? {
    switch registry.set(key: key, to: Py.true) {
    case .ok: break
    case .error(let e): return e
    }

    switch filter.action {
    case .once:
      // once_registry[(text, category)] = 1
      switch self.getOnceRegistryDict() {
      case let .value(dict):
        return self.storeInHelperRegistry(registry: dict, key: key, addZero: false)
      case let .error(e):
        return e
      }

    case .module:
      // registry[(text, category, 0)] = 1
      return self.storeInHelperRegistry(registry: registry, key: key, addZero: true)

    case .default:
      return nil // Nothing to do

    case .other:
      let actStr = Py.reprOrGeneric(filter.actionObject)
      let objStr = Py.reprOrGeneric(filter.object.py)
      let msg = "Unrecognized action (\(actStr))) in warnings.filters:\n \(objStr)"
      return Py.newRuntimeError(msg: msg)

    case .error,
         .ignore,
         .always:
      assert(false, "This should never be stored!")
      return nil
    }
  }

  /// static int
  /// update_registry(PyObject *registry, PyObject *text, PyObject *category,
  private func storeInHelperRegistry(registry: PyDict,
                                     key: PyTuple,
                                     addZero: Bool) -> PyBaseException? {
    assert(key.elements.count == 3, "It should be: text, category, line")

    let text = key.elements[0]
    let category = key.elements[1]

    var elements = [text, category]
    if addZero {
      elements.append(Py.newInt(0))
    }

    let miniKey = Py.newTuple(elements)

    switch registry.set(key: miniKey, to: Py.true) {
    case .ok:
      return nil
    case .error(let e):
      return e
    }
  }
}
