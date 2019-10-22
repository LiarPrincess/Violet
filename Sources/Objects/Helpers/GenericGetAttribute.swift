internal protocol GenericGetAttribute { }

extension GenericGetAttribute where Self: PyObject {

  internal func genericGetAttributeWithDict(
    name: PyObject,
    dict: Attributes?) -> PyResult<PyObject> {

    guard let nameString = name as? PyString else {
      return .error(
        .typeError("attribute name must be string, not '\(name.typeName)'")
      )
    }

    return self.genericGetAttributeWithDict(name: nameString.value, dict: dict)
  }

  /// PyObject *
  /// _PyObject_GenericGetAttrWithDict(PyObject *obj,
  ///                                  PyObject *name,
  ///                                  PyObject *dict,
  ///                                  int suppress)
  internal func genericGetAttributeWithDict(
    name: String,
    dict: Attributes?) -> PyResult<PyObject> {

    let tp = self.type
    let descr = tp.lookup(name: name)
    var descrGet: PyObject?

    if let descr = descr {
      descrGet = descr.type.lookup(name: "__get__")
      // TODO: Also check if 'PyDescr_IsData(descr)'
      if let descrGet = descrGet {
        let args = [descr, self, self.type]
        return self.context.call(descrGet, args: args)
      }
    }

    if let dict = dict, let value = dict[name] {
      return .value(value)
    }

    if let descrGet = descrGet {
      let args = [descr, self, self.type]
      return self.context.call(descrGet, args: args)
    }

    return .error(
      .attributeError("\(self.typeName) object has no attribute '\(name)'")
    )
  }
}
