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
    return AttributeHelper.extractName(from: name)
      .flatMap { AttributeHelper.getAttribute(from: object, name: $0) }
  }

  internal static func getAttribute(from object: PyObject,
                                    name: PyString) -> PyResult<PyObject> {
    let staticProperty: PyObject?
    let descriptor: GetDescriptor?

    switch object.type.lookup(name: name) {
    case .value(let p):
      staticProperty = p
      descriptor = GetDescriptor.create(object: object, attribute: p)
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

    let msg = "\(object.typeName) object has no attribute '\(name.reprRaw())'"
    return .attributeError(msg)
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
    return AttributeHelper.extractName(from: name)
      .flatMap { AttributeHelper.setAttribute(on: object, name: $0, to: value) }
  }

  internal static func setAttribute(on object: PyObject,
                                    name: PyString,
                                    to value: PyObject?) -> PyResult<PyNone> {
    let descriptor = SetDescriptor.create(object: object, attributeName: name)

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

    let msg = descriptor == nil ?
      "'\(object.typeName)' object has no attribute '\(name.reprRaw())'" :
      "'\(object.typeName)' object attribute '\(name.reprRaw())' is read-only"

    return .attributeError(msg)
  }

  // MARK: - Del

  /// Basically: `AttributeHelper.setAttribute` with `None` as value
  internal static func delAttribute(on object: PyObject,
                                    name: PyObject) -> PyResult<PyNone> {
    return AttributeHelper.extractName(from: name)
      .flatMap { AttributeHelper.delAttribute(on: object, name: $0) }
  }

  internal static func delAttribute(on object: PyObject,
                                    name: PyString) -> PyResult<PyNone> {
    return AttributeHelper.setAttribute(on: object, name: name, to: nil)
  }

  // MARK: - Extract name

  internal static func extractName(from object: PyObject) -> PyResult<PyString> {
    guard let string = object as? PyString else {
      let msg = "attribute name must be string, not '\(object.typeName)'"
      return .typeError(msg)
    }

    return .value(string)
  }
}
