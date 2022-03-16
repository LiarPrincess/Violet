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
    self.init__dict__(py, name: name, doc: doc)
  }

  /// This method is called in `initialize` and also in Python `__init__`.
  private func init__dict__(_ py: Py, name: PyObject?, doc: PyObject?) {
    // Name can be anything, 'str' is not required:
    // >>> builtins.__dict__['__name__'] = 1
    // >>> repr(builtins)
    // "<module 1 (built-in)>"
    let dict = self.getDict(py)
    let none = py.none.asObject
    dict.set(py, id: .__name__, value: name ?? none)
    dict.set(py, id: .__doc__, value: doc ?? none)
    dict.set(py, id: .__package__, value: none)
    dict.set(py, id: .__loader__, value: none)
    dict.set(py, id: .__spec__, value: none)
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

  // MARK: - Dict

  // sourcery: pyproperty = __dict__
  internal static func __dict__(_ py: Py, zelf: PyObject) -> PyResult<PyObject> {
    guard let zelf = Self.downcast(py, zelf) else {
      return Self.invalidZelfArgument(py, zelf, "__dict__")
    }

    let result = zelf.getDict(py)
    return PyResult(result)
  }

  internal func getDict(_ py: Py) -> PyDict {
    guard let result = self.header.__dict__.get(py) else {
      py.trapMissing__dict__(object: self)
    }

    return result
  }

  // MARK: - String

  // sourcery: pymethod = __repr__
  internal static func __repr__(_ py: Py, zelf: PyObject) -> PyResult<PyObject> {
    guard let zelf = Self.downcast(py, zelf) else {
      return Self.invalidZelfArgument(py, zelf, "__repr__")
    }

    switch zelf.getNameString(py) {
    case .string(let s):
      return PyResult(py, interned: "<module \(s)>")
    case .stringConversionFailed(_, let e):
      return .error(e)
    case .namelessModule:
      let error = Self.createNamelessModuleError(py)
      return .error(error)
    }
  }

  // MARK: - Name

  /// PyObject*
  /// PyModule_GetNameObject(PyObject *m)
  internal func getName(_ py: Py) -> PyResult<PyObject> {
    if let object = self.getNameObjectOrNil(py) {
      return .value(object)
    }

    let error = Self.createNamelessModuleError(py)
    return .error(error)
  }

  internal enum ModuleName {
    case string(String)
    case stringConversionFailed(PyObject, PyBaseException)
    case namelessModule
  }

  internal func getNameString(_ py: Py) -> ModuleName {
    if let object = self.getNameObjectOrNil(py) {
      switch py.strString(object: object) {
      case let .value(s):
        return .string(s)
      case let .error(e):
        return .stringConversionFailed(object, e)
      }
    }

    return .namelessModule
  }

  private func getNameObjectOrNil(_ py: Py) -> PyObject? {
    let dict = self.getDict(py)
    return dict.get(py, id: .__name__)
  }

  private static func createNamelessModuleError(_ py: Py) -> PyBaseException {
    let error = py.newSystemError(message: "nameless module")
    return error.asBaseException
  }

  // MARK: - Get attribute

  // sourcery: pymethod = __getattribute__
  internal static func __getattribute__(_ py: Py,
                                        zelf: PyObject,
                                        name: PyObject) -> PyResult<PyObject> {
    guard let zelf = Self.downcast(py, zelf) else {
      return Self.invalidZelfArgument(py, zelf, "__getattribute__")
    }

    switch AttributeHelper.extractName(py, name: name) {
    case let .value(n):
      return Self.getAttribute(py, zelf: zelf, name: n)
    case let .error(e):
      return .error(e)
    }
  }

  /// static PyObject*
  /// module_getattro(PyModuleObject *m, PyObject *name)
  private static func getAttribute(_ py: Py,
                                   zelf: PyModule,
                                   name: PyString) -> PyResult<PyObject> {
    let zelfObject = zelf.asObject
    let attribute = AttributeHelper.getAttribute(py, object: zelfObject, name: name)

    switch attribute {
    case let .value(v):
      return .value(v)
    case let .error(e):
      if py.cast.isAttributeError(e.asObject) {
        break // there is still hope!
      }

      return .error(e)
    }

    let dict = zelf.getDict(py)
    if let getAttr = dict.get(py, id: .__getattr__) {
      switch py.call(callable: getAttr, args: [zelfObject, name.asObject]) {
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
    switch zelf.getNameString(py) {
    case .string(let s): moduleName = s
    case .stringConversionFailed,
         .namelessModule: break
    }

    let message = "module \(moduleName) has no attribute \(attributeName)"
    return .attributeError(py, message: message)
  }

  // MARK: - Set attribute

  // sourcery: pymethod = __setattr__
  internal static func __setattr__(_ py: Py,
                                   zelf: PyObject,
                                   name: PyObject,
                                   value: PyObject?) -> PyResult<PyObject> {
    guard let zelf = Self.downcast(py, zelf) else {
      return Self.invalidZelfArgument(py, zelf, "__setattr__")
    }

    return AttributeHelper.setAttribute(py, object: zelf.asObject, name: name, value: value)
  }

  // MARK: - Del attribute

  // sourcery: pymethod = __delattr__
  internal static func __delattr__(_ py: Py,
                                   zelf: PyObject,
                                   name: PyObject) -> PyResult<PyObject> {
    guard let zelf = Self.downcast(py, zelf) else {
      return Self.invalidZelfArgument(py, zelf, "__delattr__")
    }

    return AttributeHelper.delAttribute(py, object: zelf.asObject, name: name)
  }

  // MARK: - Class

  // sourcery: pyproperty = __class__
  internal static func __class__(_ py: Py, zelf: PyObject) -> PyType {
    return zelf.type
  }

  // MARK: - Dir

  // sourcery: pymethod = __dir__
  internal static func __dir__(_ py: Py, zelf: PyObject) -> PyResult<DirResult> {
    guard let zelf = Self.downcast(py, zelf) else {
      return Self.invalidZelfArgument(py, zelf, Self.pythonTypeName)
    }

    // Do not add 'self.type' dir!
    // We are only interested in functions in this module!

    var result = DirResult()
    let error: PyBaseException?

    // If we have our own '__dir__' method then call it.
    let dict = zelf.getDict(py)
    if let dirFn = dict.get(py, id: .__dir__) {
      switch py.call(callable: dirFn) {
      case .value(let o):
        error = result.append(py, elementsFrom: o)
      case let .notCallable(e),
           let .error(e):
        error = e
      }
    } else {
      // Otherwise just fill it with our keys
      error = result.append(py, keysFrom: dict)
    }

    if let e = error {
      return .error(e)
    }

    return .value(result)
  }

  // MARK: - Python new

  // sourcery: pystaticmethod = __new__
  internal static func __new__(_ py: Py,
                               type: PyType,
                               args: [PyObject],
                               kwargs: PyDict?) -> PyResult<PyObject> {
    let result = py.memory.newModule(py, type: type, name: nil, doc: nil, __dict__: nil)
    return PyResult(result)
  }

  // MARK: - Python init

  private static let initArguments = ArgumentParser(
    arguments: ["name", "doc"],
    format: "U|O:module"
  )

  // sourcery: pymethod = __init__
  internal static func __init__(_ py: Py,
                                zelf: PyObject,
                                args: [PyObject],
                                kwargs: PyDict?) -> PyResult<PyObject> {
    guard let zelf = Self.downcast(py, zelf) else {
      return Self.invalidZelfArgument(py, zelf, "__init__")
    }

    switch PyModule.initArguments.bind(py, args: args, kwargs: kwargs) {
    case let .value(binding):
      assert(binding.requiredCount == 1, "Invalid required argument count.")
      assert(binding.optionalCount == 1, "Invalid optional argument count.")

      let name = binding.required(at: 0)
      let doc = binding.optional(at: 1)
      zelf.init__dict__(py, name: name, doc: doc)

      return .none(py)

    case let .error(e):
      return .error(e)
    }
  }
}
