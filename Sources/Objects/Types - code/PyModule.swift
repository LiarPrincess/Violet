// In CPython:
// Objects -> moduleobject.c

// sourcery: pytype = module, default, hasGC, baseType
public class PyModule: PyObject {

  internal static let doc: String = """
    module(name, doc=None)
    --

    Create a module object.
    The name must be a string; the optional doc argument can have any type.
    """

  internal let attributes = Attributes()

  /// PyObject*
  /// PyModule_GetNameObject(PyObject *m)
  internal var name: PyResult<String> {
    guard let nameObject = self.attributes["__name__"] else {
      return .systemError("nameless module")
    }

    return self.builtins.strValue(nameObject)
  }

  internal init(_ context: PyContext, name: PyObject, doc: PyObject?) {
    super.init(type: context.builtins.types.module)
    self.attributes["__name__"] = name
    self.attributes["__doc__"] = doc
    self.attributes["__package__"] = context.builtins.none
    self.attributes["__loader__"] = context.builtins.none
    self.attributes["__spec__"] = context.builtins.none
  }

  /// Use in `__new__`!
  internal override init(type: PyType) {
    super.init(type: type)
  }

  // MARK: - Dict

  // sourcery: pyproperty = __dict__
  internal func getDict() -> Attributes {
    return self.attributes
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
    let attr = AttributeHelper.getAttribute(from: self, name: name)

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
      return .typeError("attribute name must be string, not '\(name.typeName)'")
    }

    if let getAttr = self.attributes["__getattr__"] {
      return self.builtins.call(getAttr, args: [self, name])
    }

    return .attributeError("module \(self.name) has no attribute '\(nameString.value)'")
  }

  // sourcery: pymethod = __setattr__
  internal func setAttribute(name: PyObject, value: PyObject?) -> PyResult<PyNone> {
    return AttributeHelper.setAttribute(on: self, name: name, to: value)
  }

  // sourcery: pymethod = __delattr__
  internal func delAttribute(name: PyObject) -> PyResult<PyNone> {
    return AttributeHelper.delAttribute(on: self, name: name)
  }

  internal func delAttribute(name: String) -> PyResult<PyNone> {
    return AttributeHelper.delAttribute(on: self, name: name)
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
    if let dirFunc = self.attributes["__dir__"] {
      return self.context.callDir(dirFunc, args: [])
    } else {
      return DirResult(self.attributes.keys)
    }
  }

  // MARK: - Python new

  // sourcery: pymethod = __new__
  internal static func pyNew(type: PyType,
                             args: [PyObject],
                             kwargs: PyDictData?) -> PyResult<PyObject> {
    return .value(PyModule(type: type))
  }
}
