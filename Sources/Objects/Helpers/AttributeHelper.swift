internal enum AttributeHelper {

  // MARK: - Get

  internal static func genericGetAttributeWithDict(
    zelf: PyObject,
    name: PyObject,
    dict: Attributes?) -> PyResult<PyObject> {

    guard let nameString = name as? PyString else {
      return .error(
        .typeError("attribute name must be string, not '\(name.typeName)'")
      )
    }

    return AttributeHelper.genericGetAttributeWithDict(zelf: zelf,
                                                       name: nameString.value,
                                                       dict: dict)
  }

  /// PyObject *
  /// _PyObject_GenericGetAttrWithDict(PyObject *obj,
  ///                                  PyObject *name,
  ///                                  PyObject *dict,
  ///                                  int suppress)
  internal static func genericGetAttributeWithDict(
    zelf: PyObject,
    name: String,
    dict: Attributes?) -> PyResult<PyObject> {

    let tp = zelf.type
    let descr = tp.lookup(name: name)
    var descrGet: PyObject?

    if let descr = descr {
      descrGet = descr.type.lookup(name: "__get__")
      // TODO: Also check if 'PyDescr_IsData(descr)'
      if let descrGet = descrGet {
        let args = [descr, zelf, zelf.type]
        return zelf.context.call(descrGet, args: args)
      }
    }

    if let dict = dict, let value = dict[name] {
      return .value(value)
    }

    if let descrGet = descrGet {
      let args = [descr, zelf, zelf.type]
      return zelf.context.call(descrGet, args: args)
    }

    return .error(
      .attributeError("\(zelf.typeName) object has no attribute '\(name)'")
    )
  }

  // MARK: - Set

  internal static func genericSetAttributeWithDict(
    zelf: PyObject,
    name: PyObject,
    value: PyObject,
    dict: Attributes?) -> PyResult<()> {

    guard let nameString = name as? PyString else {
      return .error(
        .typeError("attribute name must be string, not '\(name.typeName)'")
      )
    }

    return AttributeHelper.genericSetAttributeWithDict(zelf:zelf,
                                                       name: nameString.value,
                                                       value: value,
                                                       dict: dict)
  }

  /// int
  /// _PyObject_GenericSetAttrWithDict(PyObject *obj,
  ///                                  PyObject *name,
  ///                                  PyObject *value,
  ///                                  PyObject *dict)
  internal static func genericSetAttributeWithDict(
    zelf: PyObject,
    name: String,
    value: PyObject,
    dict: Attributes?) -> PyResult<()> {

    let tp = zelf.type
    let descr = tp.lookup(name: name)
    var descrSet: PyObject?

    if let desc = descr {
      descrSet = desc.type.lookup(name: "__set__")

      if let descrSet = descrSet {
        let args = [descr, zelf, value]
        return zelf.context.call(descrSet, args: args).map { _ in () }
      }
    }

    if let dict = dict {
      if value is PyNone {
        dict.del(key: name)
      } else {
        dict.set(key: name, to: value)
      }

      return .value()
    }

    let msg = descr == nil ?
      "'\(zelf.typeName)' object has no attribute '\(name)'" :
      "'\(zelf.typeName)' object attribute '\(name)' is read-only"

    return .error(.attributeError(msg))
  }
}
