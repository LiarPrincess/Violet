// In CPython:
// Python -> builtinmodule.c
// https://docs.python.org/3/library/functions.html

extension BuiltinFunctions {

  // MARK: - Get

  internal static var getAttributeDoc: String {
    return """
    getattr(object, name[, default]) -> value

    Get a named attribute from an object; getattr(x, 'y') is equivalent to x.y.
    When a default argument is given, it is returned when the attribute doesn't
    exist; without it, an exception is raised in that case.
    """
  }

  /// getattr(object, name[, default])
  /// See [this](https://docs.python.org/3/library/functions.html#getattr)
  public func getAttribute(_ object: PyObject,
                           name: String,
                           default: PyObject? = nil) -> PyResult<PyObject> {
    return self.getAttribute(object,
                             name: name,
                             pyName: nil,
                             default: `default`)
  }

  // sourcery: pymethod = getattr, doc = getAttributeDoc
  /// getattr(object, name[, default])
  /// See [this](https://docs.python.org/3/library/functions.html#getattr)
  ///
  /// static PyObject *
  /// builtin_getattr(PyObject *self, PyObject *const *args, Py_ssize_t nargs)
  /// static PyObject *
  /// slot_tp_getattr_hook(PyObject *self, PyObject *name)
  /// int
  /// _PyObject_LookupAttr(PyObject *v, PyObject *name, PyObject **result)
  public func getAttribute(_ object: PyObject,
                           name: PyObject,
                           default: PyObject? = nil) -> PyResult<PyObject> {
    guard let str = name as? PyString else {
      return .typeError("getattr(): attribute name must be string")
    }

    return self.getAttribute(object,
                             name: str.value,
                             pyName: str,
                             default: `default`)
  }

  private func getAttribute(_ object: PyObject,
                            name: String,
                            pyName: PyString?,
                            default: PyObject? = nil) -> PyResult<PyObject> {
    // Fast protocol-based path
    if let owner = object as? __getattribute__Owner {
      let result = owner.getAttribute(name: name)
      return self.defaultIfAttributeError(result: result, default: `default`)
    }

    // Calling '__getattribute__' method could ask for '__getattribute__' attribute.
    // Which would try to call '__getattribute__' to get '__getattribute__'.
    // Which would... (you probably know where this is going...)
    // Anyway... we have to break the cycle.
    // Trust me it is not a hack, it is... yeah it is a hack.
    if name == "__getattribute__" {
      let result = AttributeHelper.getAttribute(from: object, name: name)
      return self.defaultIfAttributeError(result: result, default: `default`)
    }

    // Slow python path
    // attribute names tend to be reused, so we will intern them
    let n = pyName ?? self.interned(name: name)
    switch self.callMethod(on: object, selector: "__getattribute__", arg: n) {
    case .value(let o):
      return .value(o)
    case .missingMethod:
      let result = AttributeHelper.getAttribute(from: object, name: name)
      return self.defaultIfAttributeError(result: result, default: `default`)
    case .notCallable(let e):
      return .error(e)
    case .error(let e):
      return self.defaultIfAttributeError(error: e, default: `default`)
    }
  }

  private func defaultIfAttributeError(result: PyResult<PyObject>,
                                       default: PyObject?) -> PyResult<PyObject> {
    guard case let PyResult.error(e) = result else {
      return result
    }

    return self.defaultIfAttributeError(error: e, default: `default`)
  }

  private func defaultIfAttributeError(error: PyBaseException,
                                       default: PyObject?) -> PyResult<PyObject> {
    // We are only interested in AttributeError
    guard error.isAttributeError else {
      return .error(error)
    }

    // It is AttributeError. If we have `default` then return it.
    if let def = `default` {
      return .value(def)
    }

    return .error(error)
  }

  // MARK: - Has

  public func hasAttribute(_ object: PyObject,
                           name: String) -> PyResult<Bool> {
    return self.hasAttribute(object, name: name, pyName: nil)
  }

  // sourcery: pymethod = hasattr
  /// hasattr(object, name)
  /// See [this](https://docs.python.org/3/library/functions.html#hasattr)
  public func hasAttribute(_ object: PyObject,
                           name: PyObject) -> PyResult<Bool> {
    guard let str = name as? PyString else {
      return .typeError("hasattr(): attribute name must be string")
    }

    return self.hasAttribute(object, name: str.value, pyName: str)
  }

  private func hasAttribute(_ object: PyObject,
                            name: String,
                            pyName: PyString?) -> PyResult<Bool> {
    switch self.getAttribute(object, name: name, pyName: pyName, default: nil) {
    case .value:
      return .value(true)

    case .error(let e):
      if e.isAttributeError {
        return .value(false)
      }

      return .error(e)
    }
  }

  // MARK: - Set

  /// setattr(object, name, value)
  /// See [this](https://docs.python.org/3/library/functions.html#setattr)
  public func setAttribute(_ object: PyObject,
                           name: String,
                           value: PyObject) -> PyResult<PyNone> {
    return self.setAttribute(object, name: name, pyName: nil, value: value)
  }

  // sourcery: pymethod = setattr
  /// setattr(object, name, value)
  /// See [this](https://docs.python.org/3/library/functions.html#setattr)
  public func setAttribute(_ object: PyObject,
                           name: PyObject,
                           value: PyObject) -> PyResult<PyNone> {
    guard let str = name as? PyString else {
      return .typeError("setattr(): attribute name must be string")
    }

    return self.setAttribute(object, name: str.value, pyName: str, value: value)
  }

  private func setAttribute(_ object: PyObject,
                            name: String,
                            pyName: PyString?,
                            value: PyObject) -> PyResult<PyNone> {
    if let owner = object as? __setattr__Owner {
      return owner.setAttribute(name: name, value: value)
    }

    let n = pyName ?? self.interned(name: name)
    switch self.callMethod(on: object, selector: "__setattr__", args: [n, value]) {
    case .value:
      return .value(Py.none)
    case .missingMethod:
      let typeName = object.typeName
      let operation = value is PyNone ? "del" : "assign to"
      let details = "(\(operation) \(name))"

      switch self.hasAttribute(object, name: name, pyName: n) {
      case .value(true):
        return .typeError("'\(typeName)' object has only read-only attributes \(details)")
      case .value(false):
        return .typeError("'\(typeName)' object has no attributes \(details)")
      case let .error(e):
        return .error(e)
      }
    case .error(let e), .notCallable(let e):
      return .error(e)
    }
  }

  // MARK: - Delete

  /// delattr(object, name)
  /// See [this](https://docs.python.org/3/library/functions.html#delattr)
  public func deleteAttribute(_ object: PyObject,
                              name: String) -> PyResult<PyNone> {
    return self.deleteAttribute(object, name: name, pyName: nil)
  }

  // sourcery: pymethod = delattr
  /// delattr(object, name)
  /// See [this](https://docs.python.org/3/library/functions.html#delattr)
  public func deleteAttribute(_ object: PyObject,
                              name: PyObject) -> PyResult<PyNone> {
    guard let str = name as? PyString else {
      return .typeError("delattr(): attribute name must be string")
    }

    return self.deleteAttribute(object, name: str.value, pyName: str)
  }

  private func deleteAttribute(_ object: PyObject,
                               name: String,
                               pyName: PyString?) -> PyResult<PyNone> {
    return self.setAttribute(object, name: name, pyName: pyName, value: Py.none)
  }

  // MARK: - Helpers

  /// We will intern attribute names, because they tend to be repeated a lot.
  private func interned(name: String) -> PyString {
    return Py.getInterned(name)
  }
}
