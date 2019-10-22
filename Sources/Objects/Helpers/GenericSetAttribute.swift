internal protocol GenericSetAttribute { }

extension GenericSetAttribute where Self: PyObject {

  internal func genericSetAttributeWithDict(
    name: PyObject,
    value: PyObject,
    dict: Attributes?) -> PyResult<()> {

    guard let nameString = name as? PyString else {
      return .error(
        .typeError("attribute name must be string, not '\(name.typeName)'")
      )
    }

    return self.genericSetAttributeWithDict(name: nameString.value,
                                            value: value,
                                            dict: dict)
  }

  /// int
  /// _PyObject_GenericSetAttrWithDict(PyObject *obj,
  ///                                  PyObject *name,
  ///                                  PyObject *value,
  ///                                  PyObject *dict)
  internal func genericSetAttributeWithDict(
    name: String,
    value: PyObject,
    dict: Attributes?) -> PyResult<()> {

    let tp = self.type
    let descr = tp.lookup(name: name)
    var descrSet: PyObject?

    if let desc = descr {
      descrSet = desc.type.lookup(name: "__set__")

      if let descrSet = descrSet {
        let args = [descr, self, value]
        return self.context.call(descrSet, args: args).map { _ in () }
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
      "'\(self.typeName)' object has no attribute '\(name)'" :
      "'\(self.typeName)' object attribute '\(name)' is read-only"

    return .error(.attributeError(msg))
  }
}
