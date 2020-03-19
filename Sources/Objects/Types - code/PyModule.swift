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

  internal let __dict__: PyDict

  /// PyObject*
  /// PyModule_GetNameObject(PyObject *m)
  internal var name: PyResult<String> {
    if let name = self.__dict__.get(id: .__name__) {
      return Py.strValue(name)
    }

    return .systemError("nameless module")
  }

  override public var description: String {
    switch self.name {
    case .value(let name):
      return "PyModule(name: \(name))"
    case .error:
      return "PyModule(name: ?)"
    }
  }

  // MARK: - Init

  internal init(name: PyObject, doc: PyObject?, dict: PyDict? = nil) {
    self.__dict__ = dict ?? Py.newDict()
    super.init(type: Py.types.module)

    self.initDictContent(name: name, doc: doc)
  }

  /// Use only in `__new__`!
  override internal init(type: PyType) {
    self.__dict__ = Py.newDict()
    super.init(type: type)
  }

  /// This method is called in Swift `init` and also in Python `__init__`.
  private func initDictContent(name: PyObject, doc: PyObject?) {
    self.__dict__.set(id: .__name__, to: name)
    self.__dict__.set(id: .__doc__, to: doc ?? Py.none)
    self.__dict__.set(id: .__package__, to: Py.none)
    self.__dict__.set(id: .__loader__, to: Py.none)
    self.__dict__.set(id: .__spec__, to: Py.none)
  }

  // MARK: - Dict

  // sourcery: pyproperty = __dict__
  public func getDict() -> PyDict {
    return self.__dict__
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
  public func getAttribute(name: PyObject) -> PyResult<PyObject> {
    return AttributeHelper.extractName(from: name)
      .flatMap(self.getAttribute(name:))
  }

  /// static PyObject*
  /// module_getattro(PyModuleObject *m, PyObject *name)
  private func getAttribute(name: PyString) -> PyResult<PyObject> {
    let attr = AttributeHelper.getAttribute(from: self, name: name)

    switch attr {
    case let .value(v):
      return .value(v)
    case let .error(e):
      if e.isAttributeError {
        break // there is still hope!
      }

      return attr // 'attr' is an error, just return it
    }

    if let getAttr = self.__dict__.get(id: .__getattr__) {
      switch Py.call(callable: getAttr, args: [self, name]) {
      case .value(let r):
        return .value(r)
      case .error(let e), .notCallable(let e):
        return .error(e)
      }
    }

    let msg = "module \(self.name) has no attribute '\(name.reprRaw())'"
    return .attributeError(msg)
  }

  // sourcery: pymethod = __setattr__
  public func setAttribute(name: PyObject, value: PyObject?) -> PyResult<PyNone> {
    return AttributeHelper.setAttribute(on: self, name: name, to: value)
  }

  // sourcery: pymethod = __delattr__
  public func delAttribute(name: PyObject) -> PyResult<PyNone> {
    return AttributeHelper.delAttribute(on: self, name: name)
  }

  // MARK: - Class

  // sourcery: pyproperty = __class__
  public func getClass() -> PyType {
    return self.type
  }

  // MARK: - Dir

  // sourcery: pymethod = __dir__
  public func dir() -> DirResult {
    // Do not add 'self.type' dir!
    if let dirFunc = self.__dict__.get(id: .__dir__) {
      return Py.callDir(dirFunc, args: [])
    }

    var result = DirResult()
    result.append(contentsOf: self.__dict__)
    return result
  }

  // MARK: - GC

  /// Remove all of the references to other Python objects.
  override internal func gcClean() {
    self.__dict__.gcClean()
    super.gcClean()
  }

  // MARK: - Python new

  // sourcery: pymethod = __new__
  internal static func pyNew(type: PyType,
                             args: [PyObject],
                             kwargs: PyDict?) -> PyResult<PyObject> {
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
                              kwargs: PyDict?) -> PyResult<PyNone> {
    switch PyModule.initArguments.bind(args: args, kwargs: kwargs) {
    case let .value(binding):
      assert(binding.requiredCount == 1, "Invalid required argument count.")
      assert(binding.optionalCount == 1, "Invalid optional argument count.")

      let name = binding.required(at: 0)
      let doc = binding.optional(at: 1) ?? Py.none
      zelf.initDictContent(name: name, doc: doc)

      return .value(Py.none)

    case let .error(e):
      return .error(e)
    }
  }
}
