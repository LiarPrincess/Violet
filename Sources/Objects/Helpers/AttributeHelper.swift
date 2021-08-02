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
    switch AttributeHelper.extractName(from: name) {
    case let .value(n):
      return AttributeHelper.getAttribute(from: object, name: n)
    case let .error(e):
      return .error(e)
    }
  }

  internal static func getAttribute(from object: PyObject,
                                    name: PyString) -> PyResult<PyObject> {
    let staticProperty: PyObject?
    let descriptor: GetDescriptor?

    switch object.type.mroLookup(name: name) {
    case .value(let l):
      staticProperty = l.object
      descriptor = GetDescriptor(object: object, attribute: l.object)
    case .notFound:
      staticProperty = nil
      descriptor = nil
    case .error(let e):
      return .error(e)
    }

    if let descr = descriptor, descr.isData {
      return descr.call()
    }

    if let dict = Py.get__dict__(object: object) {
      switch dict.get(key: name) {
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

    let e = Py.newAttributeError(object: object, hasNoAttribute: name)
    return .error(e)
  }

  private enum GetFromDictResult {
    case value(PyObject)
    case notInDict
    case error(PyBaseException)
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
    switch AttributeHelper.extractName(from: name) {
    case let .value(n):
      return AttributeHelper.setAttribute(on: object, name: n, to: value)
    case let .error(e):
      return .error(e)
    }
  }

  internal static func setAttribute(on object: PyObject,
                                    name: PyString,
                                    to value: PyObject?) -> PyResult<PyNone> {
    let descriptor = SetDescriptor(object: object, attributeName: name)

    if let desc = descriptor {
      let result = desc.call(value: value)
      return result.map { _ in Py.none }
    }

    if let dict = Py.get__dict__(object: object) {
      if let value = value {
        switch dict.set(key: name, to: value) {
        case .ok: return .value(Py.none)
        case .error(let e): return .error(e)
        }
      } else {
        switch dict.del(key: name) {
        case .value: return .value(Py.none)
        case .notFound: break // try other
        case .error(let e): return .error(e)
        }
      }
    }

    let e = descriptor == nil ?
      Py.newAttributeError(object: object, hasNoAttribute: name) :
      Py.newAttributeError(object: object, attributeIsReadOnly: name)

    return .error(e)
  }

  // MARK: - Del

  /// Basically: `AttributeHelper.setAttribute` with `None` as value
  internal static func delAttribute(on object: PyObject,
                                    name: PyObject) -> PyResult<PyNone> {
    switch AttributeHelper.extractName(from: name) {
    case let .value(n):
      return AttributeHelper.delAttribute(on: object, name: n)
    case let .error(e):
      return .error(e)
    }
  }

  internal static func delAttribute(on object: PyObject,
                                    name: PyString) -> PyResult<PyNone> {
    return AttributeHelper.setAttribute(on: object, name: name, to: nil)
  }

  // MARK: - Extract name

  internal static func extractName(from object: PyObject) -> PyResult<PyString> {
    guard let string = PyCast.asString(object) else {
      let msg = "attribute name must be string, not '\(object.typeName)'"
      return .typeError(msg)
    }

    return .value(string)
  }
}
