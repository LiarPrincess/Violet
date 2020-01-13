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

  internal convenience init(_ context: PyContext, name: String, doc: String?) {
    let n = context.builtins.newString(name)
    let d = doc.map(context.builtins.newString(_:))
    self.init(context, name: n, doc: d)
  }

  internal init(_ context: PyContext, name: PyObject, doc: PyObject?) {
    super.init(type: context.builtins.types.module)
    self.attributes["__name__"] = name
    self.attributes["__doc__"] = doc
    self.attributes["__package__"] = context.builtins.none
    self.attributes["__loader__"] = context.builtins.none
    self.attributes["__spec__"] = context.builtins.none
  }

  /// Use only in `__new__`!
  override internal init(type: PyType) {
    super.init(type: type)
  }

  // MARK: - Dict

  // sourcery: pyproperty = __dict__
  public func getDict() -> Attributes {
    return self.attributes
  }

  // MARK: - String

  // sourcery: pymethod = __repr__
  public func repr() -> PyResult<String> {
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
      switch self.builtins.call(callable: getAttr, args: [self, name]) {
      case .value(let r): return .value(r)
      case .notImplemented: break
      case .error(let e), .notCallable(let e): return .error(e)
      }
    }

    let msg = "module \(self.name) has no attribute '\(nameString.value)'"
    return .attributeError(msg)
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
  public func dir() -> DirResult {
    // Do not add `self.type` dir!
    if let dirFunc = self.attributes["__dir__"] {
      return self.builtins.callDir(dirFunc, args: [])
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

  // MARK: - Python init

  private static let initArguments = ArgumentParser.createOrTrap(
    arguments: ["name", "doc"],
    format: "U|O:module"
  )

  // sourcery: pymethod = __init__
  internal static func pyInit(zelf: PyModule,
                              args: [PyObject],
                              kwargs: PyDictData?) -> PyResult<PyNone> {
    switch PyModule.initArguments.parse(args: args, kwargs: kwargs) {
    case let .value(bind):
      assert(1 <= bind.count && bind.count <= 2, "Invalid argument count returned from parser.")
      let name = bind[0]
      let doc = bind.count >= 2 ? bind[1] : zelf.builtins.none

      zelf.attributes.set(key: "___name__", to: name)
      zelf.attributes.set(key: "___doc__", to: doc)
      zelf.attributes.set(key: "___package__", to: zelf.builtins.none)
      zelf.attributes.set(key: "___loader__", to: zelf.builtins.none)
      zelf.attributes.set(key: "___spec__", to: zelf.builtins.none)
      return .value(zelf.builtins.none)

    case let .error(e):
      return .error(e)
    }
  }
}
