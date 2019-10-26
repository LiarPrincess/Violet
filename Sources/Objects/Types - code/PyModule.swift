// In CPython:
// Objects -> moduleobject.c

// sourcery: pytype = module
public class PyModule: PyObject, AttributesOwner {

  public static let doc: String = """
    module(name, doc=None)
    --
    Create a module object.
    The name must be a string; the optional doc argument can have any type.
    """

  internal let _attributes = Attributes()

  internal var attributes: Attributes {
    return self._attributes
  }

  private var name: String {
    guard let obj = self._attributes["__name__"] else {
      return "module"
    }

    guard let str = obj as? PyString else {
      return self.context._repr(value: obj)
    }

    return str.value
  }

  public convenience init(_ context: PyContext, name: String, doc: String? = nil) {
    let n = context._string(name)
    let d = doc.map(context._string)
    self.init(context, name: n, doc: d)
  }

  public init(_ context: PyContext, name: PyObject, doc: PyObject? = nil) {
    super.init(type: context.types.module)
    self._attributes["__name__"] = name
    self._attributes["__doc__"] = doc
    self._attributes["__package__"] = context._none
    self._attributes["__loader__"] = context._none
    self._attributes["__spec__"] = context._none
  }

  // MARK: - Dict

  // sourcery: pyproperty = __dict__
  public func dict() -> Attributes {
    return self._attributes
  }

  // MARK: - String

  // sourcery: pymethod = __repr__
  public func repr() -> String {
    return "'\(self.name)'"
  }

  // MARK: - Attributes

  // sourcery: pymethod = __getattribute__
  public func getAttribute(name: PyObject) -> PyResult<PyObject> {
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
  public func setAttribute(name: PyObject, value: PyObject) -> PyResult<PyNone> {
    return AttributeHelper.setAttribute(zelf: self, name: name, value: value)
  }

  // sourcery: pymethod = __delattr__
  public func delAttribute(name: PyObject) -> PyResult<PyNone> {
    return AttributeHelper.delAttribute(zelf: self, name: name)
  }

  public func delAttribute(name: String) -> PyResult<()> {
    switch self._attributes.del(key: name) {
    case .some:
      return .value()
    case .none:
      return .error(
        .attributeError("module '\(self.name)' has no attribute '\(name)'")
      )
    }
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
