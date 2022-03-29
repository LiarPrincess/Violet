import VioletCore

// In CPython:
// Python -> _warnings.c
// https://docs.python.org/3/library/warnings.html#warnings.warn_explicit
// https://docs.python.org/3/library/warnings.html#the-warnings-filter

extension UnderscoreWarnings {

  // swiftlint:disable:next function_parameter_count
  public func warnExplicit(message: PyObject,
                           category: PyType,
                           filename: PyString,
                           lineNo: PyInt,
                           module: PyString?,
                           source: PyObject?,
                           registry: WarningRegistry) -> PyBaseException? {
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
      return e
    }
  }

  /// static PyObject *
  /// warn_explicit(PyObject *category, PyObject *message, ...)
  internal func warnExplicit(warning: Warning,
                             registry: WarningRegistry) -> PyBaseException? {
    let key = self.createKey(warning: warning)
    switch self.hasAlreadyWarned(registry: registry, key: key) {
    case .value(true): return nil
    case .value(false): break
    case .error(let e): return e
    }

    let filter: Filter
    switch self.getFilter(warning: warning) {
    case let .value(f): filter = f
    case let .error(e): return e
    }

    if filter.action == .error {
      return self.createException(warning: warning)
    }

    if filter.action == .ignore {
      return nil
    }

    // Store in the registry that we've been here,
    // except when the action is 'always'
    if filter.action != .always {
      if let e = self.storeInRegistry(registry: registry, key: key, filter: filter) {
        return e
      }
    }

    return self.show(warning: warning)
  }

  private func createKey(warning: Warning) -> PyTuple {
    let text = warning.text
    let category = warning.category.asObject
    let lineNo = warning.lineNo.asObject
    return self.py.newTuple(elements: text, category, lineNo)
  }

  private func createException(warning: Warning) -> PyBaseException {
    switch self.py.newException(type: warning.category, arg: warning.message) {
    case let .value(e):
      return e
    case let .error(e):
      // There was an exception when creating an exception. Ehh…
      return e
    }
  }

  // MARK: - Filter

  /// static PyObject*
  /// get_filter(PyObject *category, PyObject *text, Py_ssize_t lineno,
  private func getFilter(warning: Warning) -> PyResultGen<Filter> {
    let filters: PyList
    switch self.getFilters() {
    case let .value(f): filters = f
    case let .error(e): return .error(e)
    }

    for (index, object) in filters.elements.enumerated() {
      guard let filter = self.py.cast.asTuple(object), filter.elements.count == 5 else {
        let message = "_warnings.filters item \(index) isn't a 5-tuple"
        return .valueError(self.py, message: message)
      }

      switch self.isApplicable(filter: filter, warning: warning) {
      case .value(true):
        let object = filter.elements[0]
        guard let action = self.py.cast.asString(object) else {
          let message = "filter action must be an str, not \(object.typeName)"
          return .typeError(self.py, message: message)
        }

        return .value(Filter(action: action, object: .value(filter)))

      case .value(false):
        break // try other
      case .error(let e):
        return .error(e)
      }
    }

    let defaultAction = self.getDefaultAction()
    return defaultAction.map { Filter(action: $0, object: .none) }
  }

  private func isApplicable(filter: PyTuple, warning: Warning) -> PyResultGen<Bool> {
    assert(filter.elements.count == 5)

    let filterMessage = filter.elements[1]
    switch self.compareStringOrNone(filter: filterMessage, arg: warning.text) {
    case .value(true): break // move to next one
    case .value(false): return .value(false)
    case .error(let e): return .error(e)
    }

    let filterCategory = filter.elements[2]
    switch warning.category.isSubtype(self.py, of: filterCategory) {
    case .value(true): break // move to next one
    case .value(false): return .value(false)
    case .error(let e): return .error(e)
    }

    let filterModule = filter.elements[3]
    let moduleObject = warning.module.asObject
    switch self.compareStringOrNone(filter: filterModule, arg: moduleObject) {
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
                                   arg: PyObject) -> PyResultGen<Bool> {
    // A 'None' filter always matches
    if self.py.cast.isNone(object) {
      return .value(true)
    }

    // An internal plain text default filter must match exactly
    if self.py.cast.isString(object) {
      return self.py.isEqualBool(left: object, right: arg)
    }

    // We do not support regular expressions
    return .value(false)
  }

  private func compareLine(filter object: PyObject,
                           arg: PyInt) -> PyResultGen<Bool> {
    guard let int = self.py.cast.asInt(object) else {
      let message = "filter line must be an int, not \(object.typeName)"
      return .typeError(self.py, message: message)
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
                                key: PyTuple) -> PyResultGen<Bool> {
    assert(key.elements.count == 3, "It should be: text, category, line")
    switch registry {
    case .dict(let dict):
      let keyObject = key.asObject
      switch dict.get(self.py, key: keyObject) {
      case .value(let o):
        return self.py.isTrueBool(object: o)
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
    let keyObject = key.asObject
    let trueObject = self.py.true.asObject

    switch registry.set(self.py, key: keyObject, value: trueObject) {
    case .ok: break
    case .error(let e): return e
    }

    switch filter.action {
    case .once:
      // once_registry[(text, category)] = 1
      switch self.getOnceRegistry() {
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
      let actStr = self.repr(filter.actionObject)
      let objStr = self.repr(filter.object)
      let message = "Unrecognized action (\(actStr))) in warnings.filters:\n \(objStr)"
      let error = self.py.newRuntimeError(message: message)
      return error.asBaseException

    case .error,
         .ignore,
         .always:
      trap("'\(filter.action)' should never be stored!")
    }
  }

  private func repr(_ object: PyString) -> String {
    return self.py.reprOrGenericString(object.asObject)
  }

  private func repr(_ object: Filter.Object) -> String {
    let realObject: PyObject
    switch object {
    case .value(let tuple): realObject = tuple.asObject
    case .none: realObject = self.py.none.asObject
    }

    return self.py.reprOrGenericString(realObject)
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
      let zero = self.py.newInt(0)
      elements.append(zero.asObject)
    }

    let actualKey = self.py.newTuple(elements: elements)
    let actualKeyObject = actualKey.asObject
    let trueObject = self.py.true.asObject

    switch registry.set(self.py, key: actualKeyObject, value: trueObject) {
    case .ok:
      return nil
    case .error(let e):
      return e
    }
  }
}
