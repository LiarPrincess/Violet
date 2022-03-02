// cSpell:ignore moduleobject getattro

// In CPython:
// Objects -> moduleobject.c

// sourcery: pytype = module, isDefault, hasGC, isBaseType
// sourcery: instancesHave__dict__
public struct PyModule: PyObjectMixin {

  // sourcery: pytypedoc
  internal static let doc = """
    module(name, doc=None)
    --

    Create a module object.
    The name must be a string; the optional doc argument can have any type.
    """

  public let ptr: RawPtr

  public init(ptr: RawPtr) {
    self.ptr = ptr
  }

  internal func initialize(_ py: Py,
                           type: PyType,
                           name: PyObject?,
                           doc: PyObject?,
                           __dict__: PyDict? = nil) {
    self.header.initialize(py, type: type, __dict__: __dict__)
    self.initDictContent(name: name, doc: doc)
  }

  /// This method is called in Swift `init` and also in Python `__init__`.
  private func initDictContent(name: PyObject?, doc: PyObject?) {
    // Name can be anything, 'str' is not required:
    // >>> builtins.__dict__['__name__'] = 1
    // >>> repr(builtins)
    // "<module 1 (built-in)>"
//    self.__dict__.set(id: .__name__, to: name ?? Py.none)
//    self.__dict__.set(id: .__doc__, to: doc ?? Py.none)
//    self.__dict__.set(id: .__package__, to: Py.none)
//    self.__dict__.set(id: .__loader__, to: Py.none)
//    self.__dict__.set(id: .__spec__, to: Py.none)
    fatalError()
  }

  // Nothing to do here.
  internal func beforeDeinitialize() { }

  internal static func createDebugString(ptr: RawPtr) -> String {
    let zelf = PyModule(ptr: ptr)
    return "PyModule(type: \(zelf.typeName), flags: \(zelf.flags))"
  }

//  public var customMirror: Mirror {
//    let name = self.__dict__.get(id: .__name__)
//    let doc = self.__dict__.get(id: .__doc__)
//    let package = self.__dict__.get(id: .__package__)
//    let loader = self.__dict__.get(id: .__loader__)
//    let spec = self.__dict__.get(id: .__spec__)
//
//    return Mirror(
//      self,
//      children: [
//        "name": name as Any,
//        "doc": doc as Any,
//        "package": package as Any,
//        "loader": loader as Any,
//        "spec": spec as Any
//      ]
//    )
//  }
}

 /* MARKER

  // MARK: - Dict

  // sourcery: pyproperty = __dict__
  internal func getDict() -> PyDict {
    return self.__dict__
  }

  // MARK: - String

  // sourcery: pymethod = __repr__
  internal func repr() -> PyResult<String> {
    switch self.getNameString() {
    case .string(let s):
      return .value("<module \(s)>")
    case .stringConversionFailed(_, let e):
      return .error(e)
    case .namelessModule:
      let e = self.createNamelessModuleError()
      return .error(e)
    }
  }

  // MARK: - Name

  /// PyObject*
  /// PyModule_GetNameObject(PyObject *m)
  internal func getName() -> PyResult<PyObject> {
    if let object = self.getNameObjectOrNil() {
      return .value(object)
    }

    let e = self.createNamelessModuleError()
    return .error(e)
  }

  internal enum NameAsString {
    case string(String)
    case stringConversionFailed(PyObject, PyBaseException)
    case namelessModule
  }

  internal func getNameString() -> NameAsString {
    if let object = self.getNameObjectOrNil() {
      switch Py.strString(object: object) {
      case let .value(s):
        return .string(s)
      case let .error(e):
        return .stringConversionFailed(object, e)
      }
    }

    return .namelessModule
  }

  private func getNameObjectOrNil() -> PyObject? {
    return self.__dict__.get(id: .__name__)
  }

  private func createNamelessModuleError() -> PyBaseException {
    return Py.newSystemError(msg: "nameless module")
  }

  // MARK: - Get attribute

  // sourcery: pymethod = __getattribute__
  internal func getAttribute(name: PyObject) -> PyResult<PyObject> {
    switch AttributeHelper.extractName(from: name) {
    case let .value(n):
      return self.getAttribute(name: n)
    case let .error(e):
      return .error(e)
    }
  }

  /// static PyObject*
  /// module_getattro(PyModuleObject *m, PyObject *name)
  private func getAttribute(name: PyString) -> PyResult<PyObject> {
    let attr = AttributeHelper.getAttribute(from: self, name: name)

    switch attr {
    case let .value(v):
      return .value(v)
    case let .error(e):
      if PyCast.isAttributeError(e) {
        break // there is still hope!
      }

      return .error(e)
    }

    if let getAttr = self.__dict__.get(id: .__getattr__) {
      switch Py.call(callable: getAttr, args: [self, name]) {
      case .value(let r):
        return .value(r)
      case .error(let e),
           .notCallable(let e):
        return .error(e)
      }
    }

    let attributeNameRepr = name.repr()
    let attributeName = attributeNameRepr.quoted

    var moduleName = "<unknown module name>"
    switch self.getNameString() {
    case .string(let s): moduleName = s
    case .stringConversionFailed,
         .namelessModule: break
    }

    let msg = "module \(moduleName) has no attribute \(attributeName)"
    return .attributeError(msg)
  }

  private func getAttribute(id: IdString) -> PyResult<PyObject> {
    return self.getAttribute(name: id.value)
  }

  // MARK: - Set attribute

  // sourcery: pymethod = __setattr__
  internal func setAttribute(name: PyObject, value: PyObject?) -> PyResult<PyNone> {
    return AttributeHelper.setAttribute(on: self, name: name, to: value)
  }

  internal func setAttribute(id: IdString, value: PyObject?) -> PyResult<PyNone> {
    return AttributeHelper.setAttribute(on: self, name: id.value, to: value)
  }

  // MARK: - Del attribute

  // sourcery: pymethod = __delattr__
  internal func delAttribute(name: PyObject) -> PyResult<PyNone> {
    return AttributeHelper.delAttribute(on: self, name: name)
  }

  internal func delAttribute(id: IdString) -> PyResult<PyNone> {
    return AttributeHelper.delAttribute(on: self, name: id.value)
  }

  // MARK: - Class

  // sourcery: pyproperty = __class__
  internal func getClass() -> PyType {
    return self.type
  }

  // MARK: - Dir

  // sourcery: pymethod = __dir__
  internal func dir() -> PyResult<DirResult> {
    // Do not add 'self.type' dir!
    // We are only interested in functions in this module!

    let result = DirResult()
    let error: PyBaseException?

    // If we have our own '__dir__' method then call it.
    if let dirFn = self.__dict__.get(id: .__dir__) {
      switch Py.call(callable: dirFn) {
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
    let result = PyMemory.newModule(type: type, name: nil, doc: nil, dict: nil)
    return .value(result)
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

*/
