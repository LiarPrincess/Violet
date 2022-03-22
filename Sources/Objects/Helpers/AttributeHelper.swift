internal enum AttributeHelper {

  // MARK: - Get

  /// Basically: PyObject_GenericGetAttr
  ///
  /// PyObject *
  /// _PyObject_GenericGetAttrWithDict(PyObject *obj,
  ///                                  PyObject *name,
  ///                                  PyObject *dict,
  ///                                  int suppress)
  internal static func getAttribute(_ py: Py,
                                    object: PyObject,
                                    name: PyObject) -> PyResult {
    switch AttributeHelper.extractName(py, name: name) {
    case let .value(n):
      return AttributeHelper.getAttribute(py, object: object, name: n)
    case let .error(e):
      return .error(e)
    }
  }

  internal static func getAttribute(_ py: Py,
                                    object: PyObject,
                                    name: PyString) -> PyResult {
    let staticProperty: PyObject?
    let descriptor: GetDescriptor?

    switch object.type.mroLookup(py, name: name) {
    case .value(let l):
      staticProperty = l.object
      descriptor = GetDescriptor(py, object: object, attribute: l.object)
    case .notFound:
      staticProperty = nil
      descriptor = nil
    case .error(let e):
      return .error(e)
    }

    if let descr = descriptor, descr.isData {
      return descr.call()
    }

    if let dict = py.get__dict__(object: object) {
      switch dict.get(py, key: name) {
      case .value(let o):
        return .value(o)
      case .notFound:
        break // try other
      case .error(let e):
        return .error(e)
      }
    }

    if let descr = descriptor {
      return descr.call()
    }

    if let p = staticProperty {
      return .value(p)
    }

    let error = py.newAttributeError(object: object, hasNoAttribute: name)
    return .error(error.asBaseException)
  }

  // MARK: - Set

  /// Basically: PyObject_GenericSetAttr
  ///
  /// int
  /// _PyObject_GenericSetAttrWithDict(PyObject *obj,
  ///                                  PyObject *name,
  ///                                  PyObject *value,
  ///                                  PyObject *dict)
  internal static func setAttribute(_ py: Py,
                                    object: PyObject,
                                    name: PyObject,
                                    value: PyObject?) -> PyResult {
    switch AttributeHelper.extractName(py, name: name) {
    case let .value(n):
      return AttributeHelper.setAttribute(py, object: object, name: n, value: value)
    case let .error(e):
      return .error(e)
    }
  }

  internal static func setAttribute(_ py: Py,
                                    object: PyObject,
                                    name: PyString,
                                    value: PyObject?) -> PyResult {
    let descriptor = SetDescriptor(py, object: object, attributeName: name)

    if let desc = descriptor {
      return desc.call(value: value)
    }

    if let dict = py.get__dict__(object: object) {
      if let value = value {
        switch dict.set(py, key: name, value: value) {
        case .ok: return .none(py)
        case .error(let e): return .error(e)
        }
      } else {
        switch dict.del(py, key: name) {
        case .value: return .none(py)
        case .notFound: break // try other
        case .error(let e): return .error(e)
        }
      }
    }

    let error = descriptor == nil ?
      py.newAttributeError(object: object, hasNoAttribute: name) :
      py.newAttributeError(object: object, attributeIsReadOnly: name)

    return .error(error.asBaseException)
  }

  // MARK: - Del

  /// Basically: `AttributeHelper.setAttribute` with `None` as value
  internal static func delAttribute(_ py: Py,
                                    object: PyObject,
                                    name: PyObject) -> PyResult {
    switch AttributeHelper.extractName(py, name: name) {
    case let .value(n):
      return AttributeHelper.delAttribute(py, object: object, name: n)
    case let .error(e):
      return .error(e)
    }
  }

  internal static func delAttribute(_ py: Py,
                                    object: PyObject,
                                    name: PyString) -> PyResult {
    return AttributeHelper.setAttribute(py, object: object, name: name, value: nil)
  }

  // MARK: - Extract name

  internal static func extractName(_ py: Py,
                                   name: PyObject) -> PyResultGen<PyString> {
    guard let string = py.cast.asString(name) else {
      let msg = "attribute name must be string, not '\(name.typeName)'"
      return .typeError(py, message: msg)
    }

    return .value(string)
  }
}
