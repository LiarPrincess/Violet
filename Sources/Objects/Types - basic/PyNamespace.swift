// cSpell:ignore namespaceobject

// In CPython:
// Objects -> namespaceobject.c

// sourcery: pytype = SimpleNamespace, isDefault, hasGC, isBaseType
// sourcery: instancesHave__dict__
/// `types.SimpleNamespace` is not an part of `builtins`, but it is used in
/// various `sys` properties, so we have to implement it anyway.
public struct PyNamespace: PyObjectMixin {

  // sourcery: pytypedoc
  internal static let doc = """
    A simple attribute-based namespace.

    SimpleNamespace(**kwargs)
    """

  private static let typeName = "SimpleNamespace"

  public let ptr: RawPtr

  public init(ptr: RawPtr) {
    self.ptr = ptr
  }

  internal func initialize(_ py: Py, type: PyType, __dict__: PyDict?) {
    self.header.initialize(py, type: type, __dict__: __dict__)
  }

  // Nothing to do here.
  internal func beforeDeinitialize() { }

  internal static func createDebugString(ptr: RawPtr) -> String {
    let zelf = PyNamespace(ptr: ptr)
    return "PyNamespace(type: \(zelf.typeName), flags: \(zelf.flags))"
  }

  // MARK: - Equatable, comparable

  // sourcery: pymethod = __eq__
  internal static func __eq__(_ py: Py, zelf: PyObject, other: PyObject) -> CompareResult {
    guard let zelf = Self.castZelf(py, zelf) else {
      return .invalidSelfArgument(zelf, Self.typeName, .__eq__)
    }

    return Self.isEqual(py, zelf: zelf, other: other)
  }

  // sourcery: pymethod = __ne__
  internal static func __ne__(_ py: Py, zelf: PyObject, other: PyObject) -> CompareResult {
    guard let zelf = Self.castZelf(py, zelf) else {
      return .invalidSelfArgument(zelf, Self.typeName, .__ne__)
    }

    let isEqual = Self.isEqual(py, zelf: zelf, other: other)
    return isEqual.not
  }

  private static func isEqual(_ py: Py, zelf: PyNamespace, other: PyObject) -> CompareResult {
    guard let other = py.cast.asNamespace(other) else {
      return .notImplemented
    }

    return zelf.__dict__.isEqual(other.__dict__)
  }

  // sourcery: pymethod = __lt__
  internal static func __lt__(_ py: Py, zelf: PyObject, other: PyObject) -> CompareResult {
    return Self.compare(py, zelf: zelf, operation: .__lt__)
  }

  // sourcery: pymethod = __le__
  internal static func __le__(_ py: Py, zelf: PyObject, other: PyObject) -> CompareResult {
    return Self.compare(py, zelf: zelf, operation: .__le__)
  }

  // sourcery: pymethod = __gt__
  internal static func __gt__(_ py: Py, zelf: PyObject, other: PyObject) -> CompareResult {
    return Self.compare(py, zelf: zelf, operation: .__gt__)
  }

  // sourcery: pymethod = __ge__
  internal static func __ge__(_ py: Py, zelf: PyObject, other: PyObject) -> CompareResult {
    return Self.compare(py, zelf: zelf, operation: .__ge__)
  }

  private static func compare(_ py: Py,
                              zelf: PyObject,
                              operation: CompareResult.Operation) -> CompareResult {
    guard py.cast.isNamespace(zelf) else {
      return .invalidSelfArgument(zelf, Self.typeName, operation)
    }

    return .notImplemented
  }

  // MARK: - Class

  // sourcery: pyproperty = __class__
  internal static func __class__(_ py: Py, zelf: PyObject) -> PyType {
    return zelf.type
  }

  // MARK: - Dict

  // sourcery: pyproperty = __dict__
  internal static func __dict__(_ py: Py, zelf: PyObject) -> PyResult<PyObject> {
    guard let zelf = Self.castZelf(py, zelf) else {
      return Self.invalidZelfArgument(py, zelf, "__dict__")
    }

    let result = zelf.__dict__
    return .value(result.asObject)
  }

  // MARK: - String

  // sourcery: pymethod = __repr__
  internal static func __repr__(_ py: Py, zelf: PyObject) -> PyResult<PyObject> {
    guard let zelf = Self.castZelf(py, zelf) else {
      return Self.invalidZelfArgument(py, zelf, "__repr__")
    }

    let isBuiltin = zelf.type === py.types.simpleNamespace
    let name = isBuiltin ? "namespace" : zelf.typeName

    if zelf.hasReprLock {
      let result = py.intern(string: name + "(...)")
      return .value(result.asObject)
    }

    return zelf.withReprLock {
      var values = ""

      for (index, entry) in zelf.__dict__.elements.enumerated() {
        if index > 0 {
          values.append(", ")
        }

        let keyRepr: String
        switch py.reprString(object: entry.key.object) {
        case let .value(r): keyRepr = r
        case let .error(e): return .error(e)
        }

        let valueRepr: String
        switch py.reprString(object: entry.value) {
        case let .value(r): valueRepr = r
        case let .error(e): return .error(e)
        }

        values.append("\(keyRepr)=\(valueRepr)")
      }

      let result = py.newString("\(name)(\(values))")
      return .value(result.asObject)
    }
  }

  // MARK: - Attributes

  // sourcery: pymethod = __getattribute__
  internal static func __getattribute__(_ py: Py,
                                        zelf: PyObject,
                                        name: PyObject) -> PyResult<PyObject> {
    guard let zelf = Self.castZelf(py, zelf) else {
      return Self.invalidZelfArgument(py, zelf, "__getattribute__")
    }

    return AttributeHelper.getAttribute(py, object: zelf.asObject, name: name)
  }

  // sourcery: pymethod = __setattr__
  internal static func __setattr__(_ py: Py,
                                   zelf: PyObject,
                                   name: PyObject,
                                   value: PyObject?) -> PyResult<PyObject> {
    guard let zelf = Self.castZelf(py, zelf) else {
      return Self.invalidZelfArgument(py, zelf, "__setattr__")
    }

    return AttributeHelper.setAttribute(py, object: zelf.asObject, name: name, value: value)
  }

  // sourcery: pymethod = __delattr__
  internal static func __delattr__(_ py: Py,
                                   zelf: PyObject,
                                   name: PyObject) -> PyResult<PyObject> {
    guard let zelf = Self.castZelf(py, zelf) else {
      return Self.invalidZelfArgument(py, zelf, "__delattr__")
    }

    return AttributeHelper.delAttribute(py, object: zelf.asObject, name: name)
  }

  // MARK: - Python new

  // sourcery: pystaticmethod = __new__
  internal static func __new__(_ py: Py,
                               type: PyType,
                               args: [PyObject],
                               kwargs: PyDict?) -> PyResult<PyObject> {
    let dict = py.newDict()
    let result = py.memory.newNamespace(py, type: type, __dict__: dict)
    return .value(result.asObject)
  }

  // MARK: - Python init

  // sourcery: pymethod = __init__
  internal static func __init__(_ py: Py,
                                zelf: PyObject,
                                args: [PyObject],
                                kwargs: PyDict?) -> PyResult<PyObject> {
    guard let zelf = Self.castZelf(py, zelf) else {
      return Self.invalidZelfArgument(py, zelf, "__init__")
    }

    guard args.isEmpty else {
      return .typeError(py, message: "no positional arguments expected")
    }

    guard let kwargs = kwargs else {
      return .none(py)
    }

    switch ArgumentParser.guaranteeStringKeywords(py, kwargs: kwargs) {
    case .value: break
    case .error(let e): return .error(e)
    }

    switch zelf.__dict__.update(from: kwargs, onKeyDuplicate: .continue) {
    case .value: break
    case .error(let e): return .error(e)
    }

    return .none(py)
  }

  // MARK: - Helpers

  internal static func castZelf(_ py: Py, _ object: PyObject) -> PyNamespace? {
    return py.cast.asNamespace(object)
  }

  internal static func invalidZelfArgument(_ py: Py,
                                           _ object: PyObject,
                                           _ fnName: String) -> PyResult<PyObject> {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.typeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}
