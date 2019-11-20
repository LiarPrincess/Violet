// In CPython:
// Python -> builtinmodule.c
// https://docs.python.org/3/library/functions.html

extension Builtins {

  internal static let getAttributeDoc = """
    getattr(object, name[, default]) -> value

    Get a named attribute from an object; getattr(x, 'y') is equivalent to x.y.
    When a default argument is given, it is returned when the attribute doesn't
    exist; without it, an exception is raised in that case.
    """

  public func getAttribute(_ object: PyObject,
                           name: String) -> PyResult<PyObject> {
    let nameString = self.newString(name)
    return self.getAttribute(object, name: nameString)
  }

  // sourcery: pymethod: getattr, doc = getAttributeDoc
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
    guard let name = name as? PyString else {
      return .typeError("getattr(): attribute name must be string")
    }

    // Fast protocol-based path
    if let owner = object as? __getattribute__Owner {
      let result = owner.getAttribute(name: name)
      return self.handleAttributeError(result: result, default: `default`)
    }

    // Slow python path
    switch self.callMethod(on: object, selector: "__getattribute__", arg: name) {
    case .value(let o):
      return .value(o)

    case .noSuchMethod,
         .notImplemented:
      let result = AttributeHelper.getAttribute(from: object, name: name.value)
      return self.handleAttributeError(result: result, default: `default`)

    case .methodIsNotCallable(let e):
      return .error(e)

    case .error(let e):
      return self.handleAttributeError(error: e, default: `default`)
    }
  }

  private func handleAttributeError(result: PyResult<PyObject>,
                                    default: PyObject?) -> PyResult<PyObject> {
    guard case let PyResult.error(e) = result else {
      return result
    }

    return self.handleAttributeError(error: e, default: `default`)
  }

  private func handleAttributeError(error: PyErrorEnum,
                                    default: PyObject?) -> PyResult<PyObject> {
    // We are only interested in AttributeError
    guard case PyErrorEnum.attributeError = error else {
      return .error(error)
    }

    // It is AttributeError. If we have `default` then return it.
    if let def = `default` {
      return .value(def)
    }

    return .error(error)
  }

  // sourcery: pymethod: hasattr
  /// hasattr(object, name)
  /// See [this](https://docs.python.org/3/library/functions.html#hasattr)
  public func hasAttribute(_ object: PyObject,
                           name: PyObject) -> PyResult<Bool> {
    guard name is PyString else {
      return .typeError("hasattr(): attribute name must be string")
    }

    switch self.getAttribute(object, name: name, default: nil) {
    case .value:
      return .value(true)
    case .error(.attributeError):
      return .value(false)
    case .error(let e):
      return .error(e)
    }
  }

  // sourcery: pymethod: setattr
  /// setattr(object, name, value)
  /// See [this](https://docs.python.org/3/library/functions.html#setattr)
  public func setAttribute(_ object: PyObject,
                           name: PyObject,
                           value: PyObject?) -> PyResult<()> {
    guard let name = name as? PyString else {
      return .typeError("setattr(): attribute name must be string")
    }

    if let setAttr = self.lookup(object, name: "__setattr__") {
      let result = object.context.call(setAttr, args: [object, name, value])
      return result.map { _ in () }
    }

    let type = object.typeName
    let op = value is PyNone ? "del" : "assign to"
    let nameStr = name.str()

    switch self.hasAttribute(object, name: name) {
    case .value(true):
      return .typeError("'\(type)' object has only read-only attributes (\(op) \(nameStr))")
    case .value(false):
      return .typeError("'\(type)' object has no attributes (\(op) \(nameStr))")
    case let .error(e):
      return .error(e)
    }
  }

  // sourcery: pymethod: delattr
  /// delattr(object, name)
  /// See [this](https://docs.python.org/3/library/functions.html#delattr)
  public func delAttribute(_ object: PyObject, name: PyObject) -> PyResult<()> {
    guard let name = name as? PyString else {
      return .typeError("delattr(): attribute name must be string")
    }

    return self.setAttribute(object, name: name, value: nil)
  }
}
