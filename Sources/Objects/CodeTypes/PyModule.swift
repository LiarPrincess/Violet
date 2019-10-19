// In CPython:
// Objects -> moduleobject.c

// sourcery: pytype = module
public final class PyModule: PyObject {

  public static let doc: String = """
    module(name, doc=None)
    --
    Create a module object.
    The name must be a string; the optional doc argument can have any type.
    """

  private var _attributes = Attributes()

  private var name: String {
    guard let obj = self.dict["__name__"] else {
      return "module"
    }

    guard let str = obj as? PyString else {
      return self.context._repr(value: obj)
    }

    return str.value
  }

  public convenience init(_ context: PyContext, name: String, doc: String? = nil) {
    let n = PyString(context, value: name)
    let d = doc.map { PyString(context, value: $0) }
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
  public var dict: Attributes {
    return self._attributes
  }

  // MARK: - String

  // sourcery: pymethod = __repr__
  public func repr() -> String {
    return "'\(self.name)'"
  }

  // MARK: - Attributes

  // sourcery: pymethod = __getattribute__
  public func getAttribute(key: String) -> GetAttributeResult {
    switch self._attributes.getAttribute(key: key) {
    case let .some(v):
      return .value(v)
    case .none:
      return .attributeError("module '\(self.name)' has no attribute '\(key)'")
    }
  }

  // sourcery: pymethod = __setattr__
  public func setAttribute(key: String, value: PyObject) {
    self._attributes.setAttribute(key: key, value: value)
  }

  // sourcery: pymethod = __delattr__
  public func delAttribute(key: String) -> DelAttributeResult {
    switch self._attributes.delAttribute(key: key) {
    case let .some(v):
      return .value(v)
    case .none:
      return .attributeError("module '\(self.name)' has no attribute '\(key)'")
    }
  }

  // MARK: - Dir

  // sourcery: pymethod = __dir__
  // sourcery: pydoc = "__dir__() -> list\nspecialized dir() implementation"
  public func dir() -> [String] {
    return self._attributes.keys
  }
}
