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
    if let getAttributeOwner = object as? __getattribute__Owner {
      return getAttributeOwner.getAttribute(name: name)
    }

    // Slow python path
    // TODO: Recheck this after we have `__call__`
    switch self.callMethod(on: object, selector: "__getattribute__", arg: name) {
    case .value(let o):
      return .value(o)
    case .noSuchMethod:
      return AttributeHelper.getAttribute(from: object, name: name.value)
    case .methodIsNotCallable(let e):
      return .error(e)
    }
  }

  // sourcery: pymethod: hasattr
  /// hasattr(object, name)
  /// See [this](https://docs.python.org/3/library/functions.html#hasattr)
  public func hasAttribute(_ object: PyObject,
                           name: PyObject) -> PyResult<Bool> {
//    guard name is PyString else {
//      return .typeError("hasattr(): attribute name must be string")
//    }
//
//    guard let getAttro = self.lookup(object, name: "__getattribute__") else {
//      return .value(false)
//    }
//
//    let result = self.call(getAttro, args: [object, name])
    // TODO: If result is AttributeError then return false
    return .value(true)
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
