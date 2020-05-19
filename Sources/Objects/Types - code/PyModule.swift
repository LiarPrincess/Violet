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

  override public var description: String {
    switch self.getName() {
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
  override private init(type: PyType) {
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
    return self.getName().map { "<module \($0)>" }
  }

  // MARK: - Name

  /// PyObject*
  /// PyModule_GetNameObject(PyObject *m)
  public func getName() -> PyResult<String> {
    if let name = self.__dict__.get(id: .__name__) {
      return Py.strValue(object: name)
    }

    return .systemError("nameless module")
  }

  /// Just like `self.getName`, but ignores error and returns `nil`.
  public func getNameOrNil() -> String? {
    switch self.getName() {
    case .value(let n):
      return n
    case .error:
      return nil
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

    let nameQuoted = name.reprRaw().quoted
    let moduleName = self.getNameOrNil() ?? "<unknown module name>"
    let msg = "module \(moduleName) has no attribute \(nameQuoted)"
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
  public func dir() -> PyResult<DirResult> {
    // Do not add 'self.type' dir!
    // We are only interested in functions in this module!

    let result = DirResult()
    let error: PyBaseException?

    // If we have our own '__dir__' method then call it.
    if let dirFunc = self.__dict__.get(id: .__dir__) {
      switch Py.call(callable: dirFunc) {
      case .value(let o):
        error = result.append(elementsFrom: o)
      case let .notCallable(e),
           let .error(e):
        error = e
      }
    } else {
      // Otherwise just fill it with our keys
      error = result.append(keysFrom: self.__dict__)
    }

    if let e = error {
      return .error(e)
    }

    return .value(result)
  }

  // MARK: - GC

  /// Remove all of the references to other Python objects.
  override internal func gcClean() {
    self.__dict__.gcClean()
    super.gcClean()
  }

  // MARK: - Python new

  // sourcery: pystaticmethod = __new__
  internal static func pyNew(type: PyType,
                             args: [PyObject],
                             kwargs: PyDict?) -> PyResult<PyModule> {
    return .value(PyModule(type: type))
  }

  // MARK: - Python init

  private static let initArguments = ArgumentParser.createOrTrap(
    arguments: ["name", "doc"],
    format: "U|O:module"
  )

  // sourcery: pymethod = __init__
  internal func pyInit(args: [PyObject], kwargs: PyDict?) -> PyResult<PyNone> {
    switch PyModule.initArguments.bind(args: args, kwargs: kwargs) {
    case let .value(binding):
      assert(binding.requiredCount == 1, "Invalid required argument count.")
      assert(binding.optionalCount == 1, "Invalid optional argument count.")

      let name = binding.required(at: 0)
      let doc = binding.optional(at: 1) ?? Py.none
      self.initDictContent(name: name, doc: doc)

      return .value(Py.none)

    case let .error(e):
      return .error(e)
    }
  }
}
