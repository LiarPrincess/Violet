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
      return .typeError("attribute name must be string, not '\(name.typeName)'")
    }

    return getAttribute(from: object, name: nameString.value)
  }

  internal static func getAttribute(from object: PyObject,
                                    name: String) -> PyResult<PyObject> {
    let tp = object.type
    let descr = tp.lookup(name: name)
    var descrGet: PyObject?

    if let descr = descr {
      descrGet = descr.type.lookup(name: "__get__")
      if let descrGet = descrGet, DescriptorHelper.isData(descr) {
        return callDescriptorGet(descr: descr, descrGet: descrGet, object: object)
      }
    }

    if let attribOwner = object as? AttributesOwner,
       let value = attribOwner._attributes.get(key: name) {
      return .value(value)
    }

    if let descr = descr, let descrGet = descrGet {
      return callDescriptorGet(descr: descr, descrGet: descrGet, object: object)
    }

    return .error(attributeError(object: object, name: name))
  }

  private static func callDescriptorGet(descr: PyObject,
                                        descrGet: PyObject,
                                        object: PyObject) -> PyResult<PyObject> {
    let args = [descr, object, object.type]
    return object.context.call(descrGet, args: args)
  }

  internal static func attributeError(object: PyObject,
                                      name: String) -> PyErrorEnum {
    return .attributeError("\(object.typeName) object has no attribute '\(name)'")
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
      return .typeError("attribute name must be string, not '\(name.typeName)'")
    }

    return setAttribute(on: object, name: nameString.value, to: value)
  }

  internal static func setAttribute(on object: PyObject,
                                    name: String,
                                    to value: PyObject?) -> PyResult<PyNone> {
    let tp = object.type
    let descr = tp.lookup(name: name)
    var descrSet: PyObject?

    if let desc = descr {
      descrSet = desc.type.lookup(name: "__set__")

      if let descrSet = descrSet {
        let args = [descr, object, value]
        _ = object.context.call(descrSet, args: args)
        return .value(object.builtins.none)
      }
    }

    if let attribOwner = object as? AttributesOwner {
      if let value = value {
        attribOwner._attributes.set(key: name, to: value)
      } else {
        attribOwner._attributes.del(key: name)
      }
      return .value(object.builtins.none)
    }

    let msg = descr == nil ?
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
}
