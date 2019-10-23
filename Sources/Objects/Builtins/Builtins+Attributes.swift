extension Builtins {

  internal static let getAttributeDoc = """
    getattr(object, name[, default]) -> value

    Get a named attribute from an object; getattr(x, 'y') is equivalent to x.y.
    When a default argument is given, it is returned when the attribute doesn't
    exist; without it, an exception is raised in that case.
    """

  // sourcery: pybuiltin: getattr, doc = getAttributeDoc
  /// getattr(object, name[, default])
  /// See [this](https://docs.python.org/3/library/functions.html#getattr).
  public static func getAttribute(object: PyObject,
                                  name: PyObject,
                                  default: PyObject? = nil) -> PyResult<PyObject> {
    guard let name = name as? PyString else {
      return .error(.typeError("getattr(): attribute name must be string"))
    }

    guard let getAttro = object.type.lookup(name: "__getattribute__") else {
      return .error(
        .attributeError("'\(object.typeName)' object has no attribute '\(name.str())'")
      )
    }

    let result = object.context.call(getAttro, args: [object, name])
    // TODO: If result is AttributeError then return default
    return result
  }

  // sourcery: pybuiltin: hasattr
  /// hasattr(object, name)
  /// See [this](https://docs.python.org/3/library/functions.html#hasattr)
  public static func hasAttribute(object: PyObject,
                                  name: PyObject) -> PyResult<Bool> {
    guard name is PyString else {
      return .error(.typeError("hasattr(): attribute name must be string"))
    }

    guard let getAttro = object.type.lookup(name: "__getattribute__") else {
      return .value(false)
    }

    let result = object.context.call(getAttro, args: [object, name])
    // TODO: If result is AttributeError then return false
    return .value(true)
  }

  // sourcery: pybuiltin: setattr
  /// setattr(object, name, value)
  /// See [this](https://docs.python.org/3/library/functions.html#setattr)
  public static func setAttribute(object: PyObject,
                                  name: PyObject,
                                  value: PyObject) -> PyResult<()> {
    guard let name = name as? PyString else {
      return .error(.typeError("setattr(): attribute name must be string"))
    }

    if let setAttr = object.type.lookup(name: "__setattr__") {
      let result = object.context.call(setAttr, args: [object, name, value])
      return result.map { _ in () }
    }

    let type = object.typeName
    let op = value is PyNone ? "del" : "assign to"
    let nameStr = name.str()

    switch Builtins.hasAttribute(object: object, name: name) {
    case .value(true):
      return .error(
        .typeError("'\(type)' object has only read-only attributes (\(op) \(nameStr))")
      )
    case .value(false):
      return .error(
        .typeError("'\(type)' object has no attributes (\(op) \(nameStr))")
      )
    case let .error(e):
      return .error(e)
    }
  }

  // sourcery: pybuiltin: delattr
  /// delattr(object, name)
  /// See [this](https://docs.python.org/3/library/functions.html#delattr)
  public static func delAttribute(object: PyObject,
                                  name: PyObject) -> PyResult<()> {
    let none = object.context.none
    return Builtins.setAttribute(object: object, name: name, value: none)
  }
}
