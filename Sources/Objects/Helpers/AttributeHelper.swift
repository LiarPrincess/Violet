internal enum AttributeHelper {

  // MARK: - Get

  /// Basically: PyObject_GenericGetAttr
  ///
  /// PyObject *
  /// _PyObject_GenericGetAttrWithDict(PyObject *obj,
  ///                                  PyObject *name,
  ///                                  PyObject *dict,
  ///                                  int suppress)
  internal static func getAttribute(zelf: PyObject,
                                    name: PyObject) -> PyResult<PyObject> {
    guard let nameString = name as? PyString else {
      return .error(
        .typeError("attribute name must be string, not '\(name.typeName)'")
      )
    }

    let name = nameString.value

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

    if let attribOwner = zelf as? AttributesOwner,
      let value = attribOwner.attributes.get(key: name) {
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

  /// Basically: PyObject_GenericSetAttr
  ///
  /// int
  /// _PyObject_GenericSetAttrWithDict(PyObject *obj,
  ///                                  PyObject *name,
  ///                                  PyObject *value,
  ///                                  PyObject *dict)
  internal static func setAttribute(zelf: PyObject,
                                    name: PyObject,
                                    value: PyObject) -> PyResult<PyNone> {
    guard let nameString = name as? PyString else {
      return .error(
        .typeError("attribute name must be string, not '\(name.typeName)'")
      )
    }

    let name = nameString.value

    let tp = zelf.type
    let descr = tp.lookup(name: name)
    var descrSet: PyObject?

    if let desc = descr {
      descrSet = desc.type.lookup(name: "__set__")

      if let descrSet = descrSet {
        let args = [descr, zelf, value]
        _ = zelf.context.call(descrSet, args: args)
        return .value(zelf.context._none)
      }
    }

    if let attribOwner = zelf as? AttributesOwner {
      if value is PyNone {
        attribOwner.attributes.del(key: name)
      } else {
        attribOwner.attributes.set(key: name, to: value)
      }

      return .value(zelf.context._none)
    }

    let msg = descr == nil ?
      "'\(zelf.typeName)' object has no attribute '\(name)'" :
      "'\(zelf.typeName)' object attribute '\(name)' is read-only"

    return .error(.attributeError(msg))
  }

  // MARK: - Del

  /// Basically: `AttributeHelper.setAttribute` with `None` as value
  internal static func delAttribute(zelf: PyObject,
                                    name: PyObject) -> PyResult<PyNone> {
    let none = zelf.context.none
    return AttributeHelper.setAttribute(zelf: zelf, name: name, value: none)
  }
}
