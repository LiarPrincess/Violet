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
    let descriptor = GetDescriptor.get(object: object, attributeName: name)

    if let descr = descriptor, descr.isData {
      return descr.call()
    }

    switch Self.getFrom__dict__(object: object, name: name) {
    case .value(let o):
      return .value(o)
    case .notInDict:
      break // try other
    case .error(let e):
      return .error(e)
    }

    if let descr = descriptor {
      return descr.call()
    }

    let msg = "\(object.typeName) object has no attribute '\(name.reprRaw())'"
    return .attributeError(msg)
  }

  private enum GetFromDictResult {
    case value(PyObject)
    case notInDict
    case error(PyBaseException)
  }

  private static func getFrom__dict__(object: PyObject,
                                      name: PyString) -> GetFromDictResult {
    switch Py.get__dict__(object: object) {
    case .value(let dict):
      switch dict.getItem(at: object) {
      case .value(let o):
        return .value(o)
      case .error(let e):
        if e.isKeyError {
          return .notInDict
        }

        return .error(e)
      }

    case .noDict:
      return .notInDict

    case .error(let e):
      return .error(e)
    }
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
    let descriptor = SetDescriptor.get(object: object, attributeName: name)

    if let desc = descriptor {
      _ = desc.call(value: value)
      return .value(Py.none)
    }

    switch Py.get__dict__(object: object) {
    case .value(let dict):
      if let value = value {
        return dict.setItem(at: name, to: value)
      } else {
        return dict.delItem(at: name)
      }
    case .noDict: break // try other
    case .error(let e): return .error(e)
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
