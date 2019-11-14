// In CPython:
// Objects -> moduleobject.c

// sourcery: pytype = module
public final class PyModule: PyObject, AttributesOwner {

  internal static let doc: String = """
    module(name, doc=None)
    --
    Create a module object.
    The name must be a string; the optional doc argument can have any type.
    """

  internal let _attributes = Attributes()

  /// PyObject*
  /// PyModule_GetNameObject(PyObject *m)
  internal var name: PyResult<String> {
    guard let nameObject = self._attributes["__name__"] else {
      return .systemError("nameless module")
    }

    return .value(self.context._str(value: nameObject))
  }

  internal init(_ context: PyContext, name: PyObject, doc: PyObject?) {
    super.init(type: context.builtins.types.module)
    self._attributes["__name__"] = name
    self._attributes["__doc__"] = doc
    self._attributes["__package__"] = context._none
    self._attributes["__loader__"] = context._none
    self._attributes["__spec__"] = context._none
  }

  // MARK: - Dict

  // sourcery: pyproperty = __dict__
  internal func dict() -> Attributes {
    return self._attributes
  }

  // MARK: - String

  // sourcery: pymethod = __repr__
  internal func repr() -> PyResult<String> {
    switch self.name {
    case let .value(s):
      return .value("'\(s)'")
    case let .error(e):
      return .error(e)
    }
  }

  // MARK: - Attributes

  // sourcery: pymethod = __getattribute__
  internal func getAttribute(name: PyObject) -> PyResult<PyObject> {
    let m = self
    let attr = AttributeHelper.getAttribute(zelf: m, name: name)

    switch attr {
    case let .value(v):
      return .value(v)
    case let .error(e):
      switch e {
      case .attributeError: break // attr error -> there is still hope!
      default: return attr // normal error -> end with error
      }
    }

    guard let nameString = name as? PyString else {
      return .error(
        .typeError("attribute name must be string, not '\(name.typeName)'")
      )
    }

    if let getAttr = self._attributes["__getattr__"] {
      return self.builtins.call(getAttr, args: [self, name])
    }

    return .error(
      .attributeError("module \(self.name) has no attribute '\(nameString.value)'")
    )
  }

  // sourcery: pymethod = __setattr__
  internal func setAttribute(name: PyObject, value: PyObject?) -> PyResult<PyNone> {
    return AttributeHelper.setAttribute(zelf: self, name: name, value: value)
  }

  // sourcery: pymethod = __delattr__
  internal func delAttribute(name: PyObject) -> PyResult<PyNone> {
    return AttributeHelper.delAttribute(zelf: self, name: name)
  }

  internal func delAttribute(name: String) -> PyResult<PyNone> {
    return AttributeHelper.delAttribute(zelf: self, name: name)
  }

  // MARK: - Class

  // sourcery: pyproperty = __class__
  internal func getClass() -> PyType {
    return self.type
  }

  // MARK: - Dir

  // sourcery: pymethod = __dir__
  internal func dir() -> DirResult {
    // Do not add `self.type` dir!
    if let dirFunc = self._attributes["__dir__"] {
      return self.context.callDir(dirFunc, args: [])
    } else {
      return DirResult(self._attributes.keys)
    }
  }
}
