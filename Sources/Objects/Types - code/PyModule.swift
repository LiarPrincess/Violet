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
    self.initializeBase(py, type: type, __dict__: __dict__)
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
  internal func beforeDeinitialize(_ py: Py) {}

  internal static func createDebugInfo(ptr: RawPtr) -> PyObject.DebugMirror {
    let zelf = PyModule(ptr: ptr)
    var result = PyObject.DebugMirror(object: zelf)

    let ps = zelf.getDebugInfoPropertiesFromDict()
    result.append(name: "__name__", value: ps.__name__ as Any, includeInDescription: true)
    result.append(name: "__doc__", value: ps.__doc__ as Any)
    result.append(name: "__package__", value: ps.__package__ as Any, includeInDescription: true)
    result.append(name: "__loader__", value: ps.__loader__ as Any)
    result.append(name: "__spec__", value: ps.__spec__ as Any)
    result.append(name: "__dict__", value: zelf.__dict__)
    return result
  }

  private struct DebugInfoProperties {
    fileprivate var __name__: PyObject?
    fileprivate var __doc__: PyObject?
    fileprivate var __package__: PyObject?
    fileprivate var __loader__: PyObject?
    fileprivate var __spec__: PyObject?
  }

  private func getDebugInfoPropertiesFromDict() -> DebugInfoProperties {
    // We don't have 'py' to get all of the interesting entries,
    // so instead we will iterate '__dict__'.
    var result = DebugInfoProperties()

    let __dict__: PyDict
    switch self.__dict__ {
    case .created(let d):
      __dict__ = d
    case .noDict,
        .notCreated:
      return result
    }

    for entry in __dict__.elements {
      let keyObject = entry.key.object
      let key = String(describing: keyObject)

      if key.contains("__name__") {
        result.__name__ = entry.value
      } else if key.contains("__doc__") {
        result.__doc__ = entry.value
      } else if key.contains("__package__") {
        result.__package__ = entry.value
      } else if key.contains("__loader__") {
        result.__loader__ = entry.value
      } else if key.contains("__spec__") {
        result.__spec__ = entry.value
      }
    }

    return result
  }

  // MARK: - Dict

  // sourcery: pyproperty = __dict__
  internal static func __dict__(_ py: Py, zelf _zelf: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "__dict__")
    }

    let result = zelf.getDict(py)
    return PyResult(result)
  }

  internal func getDict(_ py: Py) -> PyDict {
    let object = self.asObject

    guard let result = object.get__dict__(py) else {
      py.trapMissing__dict__(object: self)
    }

    return result
  }

  // MARK: - String

  // sourcery: pymethod = __repr__
  internal static func __repr__(_ py: Py, zelf _zelf: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "__repr__")
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
  internal func getName(_ py: Py) -> PyResult {
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
      switch py.strString(object) {
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
                                        zelf _zelf: PyObject,
                                        name: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "__getattribute__")
    }

    return zelf.getAttribute(py, name: name)
  }

  internal func getAttribute(_ py: Py, name: PyObject) -> PyResult {
    switch AttributeHelper.extractName(py, name: name) {
    case let .value(n):
      return self.getAttribute(py, name: n)
    case let .error(e):
      return .error(e)
    }
  }

  /// static PyObject*
  /// module_getattro(PyModuleObject *m, PyObject *name)
  internal func getAttribute(_ py: Py, name: PyString) -> PyResult {
    let selfObject = self.asObject
    let attribute = AttributeHelper.getAttribute(py, object: selfObject, name: name)

    switch attribute {
    case let .value(v):
      return .value(v)
    case let .error(e):
      if py.cast.isAttributeError(e.asObject) {
        break // there is still hope!
      }

      return .error(e)
    }

    let dict = self.getDict(py)
    if let getAttr = dict.get(py, id: .__getattr__) {
      switch py.call(callable: getAttr, args: [selfObject, name.asObject]) {
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
    switch self.getNameString(py) {
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
                                   zelf _zelf: PyObject,
                                   name: PyObject,
                                   value: PyObject?) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "__setattr__")
    }

    return zelf.setAttribute(py, name: name, value: value)
  }

  internal func setAttribute(_ py: Py,
                             name: PyObject,
                             value: PyObject?) -> PyResult {
    switch AttributeHelper.extractName(py, name: name) {
    case let .value(n):
      return self.setAttribute(py, name: n, value: value)
    case let .error(e):
      return .error(e)
    }
  }

  internal func setAttribute(_ py: Py,
                             name: PyString,
                             value: PyObject?) -> PyResult {
    let selfObject = self.asObject
    return AttributeHelper.setAttribute(py,
                                        object: selfObject,
                                        name: name,
                                        value: value)
  }

  // MARK: - Del attribute

  // sourcery: pymethod = __delattr__
  internal static func __delattr__(_ py: Py,
                                   zelf _zelf: PyObject,
                                   name: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "__delattr__")
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
  internal static func __dir__(_ py: Py, zelf _zelf: PyObject) -> PyResultGen<DirResult> {
    guard let zelf = Self.downcast(py, _zelf) else {
      return .invalidSelfArgument(py, _zelf, Self.pythonTypeName)
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
                               kwargs: PyDict?) -> PyResult {
    let result = py.memory.newModule(type: type, name: nil, doc: nil, __dict__: nil)
    return PyResult(result)
  }

  // MARK: - Python init

  private static let initArguments = ArgumentParser.createOrTrap(
    arguments: ["name", "doc"],
    format: "U|O:module"
  )

  // sourcery: pymethod = __init__
  internal static func __init__(_ py: Py,
                                zelf _zelf: PyObject,
                                args: [PyObject],
                                kwargs: PyDict?) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "__init__")
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
