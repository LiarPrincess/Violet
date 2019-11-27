internal enum AttributeHelper {

  // MARK: - Get

  /// Basically: PyObject_GenericGetAttr
  ///
  /// PyObject *
  /// _PyObject_GenericGetAttrWithDict(PyObject *obj,
  ///                                  PyObject *name,
  ///                                  PyObject *dict,
  ///                                  int suppress)
  internal static func getAttribute(from object: PyObject,
                                    name: PyObject) -> PyResult<PyObject> {
    guard let nameString = name as? PyString else {
      return .error(AttributeHelper.nameTypeError(name: name))
    }

    return getAttribute(from: object, name: nameString.value)
  }

  internal static func getAttribute(from object: PyObject,
                                    name: String) -> PyResult<PyObject> {
    let descriptor = GetDescriptor.get(object: object, attributeName: name)

    if let descr = descriptor, descr.isData {
      return descr.call()
    }

    if let attribOwner = object as? __dict__GetterOwner,
      let value = attribOwner.getDict().get(key: name) {
      return .value(value)
    }

    if let descr = descriptor {
      return descr.call()
    }

    return .error(attributeError(object: object, name: name))
  }

  // MARK: - Set

  /// Basically: PyObject_GenericSetAttr
  ///
  /// int
  /// _PyObject_GenericSetAttrWithDict(PyObject *obj,
  ///                                  PyObject *name,
  ///                                  PyObject *value,
  ///                                  PyObject *dict)
  internal static func setAttribute(on object: PyObject,
                                    name: PyObject,
                                    to value: PyObject?) -> PyResult<PyNone> {
    guard let nameString = name as? PyString else {
      return .error(AttributeHelper.nameTypeError(name: name))
    }

    return setAttribute(on: object, name: nameString.value, to: value)
  }

  internal static func setAttribute(on object: PyObject,
                                    name: String,
                                    to value: PyObject?) -> PyResult<PyNone> {
    let descriptor = SetDescriptor.get(object: object, attributeName: name)

    if let desc = descriptor {
      _ = desc.call(value: value)
      return .value(object.builtins.none)
    }

    if let owner = object as? __dict__GetterOwner {
      let dict = owner.getDict()

      if let value = value {
        dict.set(key: name, to: value)
      } else {
        dict.del(key: name)
      }
      return .value(object.builtins.none)
    }

    let msg = descriptor == nil ?
      "'\(object.typeName)' object has no attribute '\(name)'" :
      "'\(object.typeName)' object attribute '\(name)' is read-only"

    return .attributeError(msg)
  }

  // MARK: - Del

  /// Basically: `AttributeHelper.setAttribute` with `None` as value
  internal static func delAttribute(on object: PyObject,
                                    name: PyObject) -> PyResult<PyNone> {
    return AttributeHelper.setAttribute(on: object, name: name, to: nil)
  }

  internal static func delAttribute(on object: PyObject,
                                    name: String) -> PyResult<PyNone> {
    return AttributeHelper.setAttribute(on: object, name: name, to: nil)
  }

  // MARK: - Errors

  internal static func attributeError(object: PyObject,
                                      name: String) -> PyErrorEnum {
    return .attributeError("\(object.typeName) object has no attribute '\(name)'")
  }

  internal static func nameTypeError(name: PyObject) -> PyErrorEnum {
    return .typeError("attribute name must be string, not '\(name.typeName)'")
  }
}
