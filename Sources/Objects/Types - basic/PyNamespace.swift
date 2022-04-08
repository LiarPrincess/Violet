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

  public let ptr: RawPtr

  public init(ptr: RawPtr) {
    self.ptr = ptr
  }

  internal func initialize(_ py: Py, type: PyType, __dict__: PyDict?) {
    self.initializeBase(py, type: type, __dict__: __dict__)
  }

  // Nothing to do here.
  internal func beforeDeinitialize(_ py: Py) {}

  internal static func createDebugInfo(ptr: RawPtr) -> PyObject.DebugMirror {
    let zelf = PyNamespace(ptr: ptr)
    var result = PyObject.DebugMirror(object: zelf)
    result.append(name: "__dict__", value: zelf.__dict__)
    return result
  }

  // MARK: - Equatable, comparable

  // sourcery: pymethod = __eq__
  internal static func __eq__(_ py: Py,
                              zelf _zelf: PyObject,
                              other: PyObject) -> CompareResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return .invalidSelfArgument(_zelf, Self.pythonTypeName, .__eq__)
    }

    return Self.isEqual(py, zelf: zelf, other: other)
  }

  // sourcery: pymethod = __ne__
  internal static func __ne__(_ py: Py,
                              zelf _zelf: PyObject,
                              other: PyObject) -> CompareResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return .invalidSelfArgument(_zelf, Self.pythonTypeName, .__ne__)
    }

    let isEqual = Self.isEqual(py, zelf: zelf, other: other)
    return isEqual.not
  }

  private static func isEqual(_ py: Py,
                              zelf: PyNamespace,
                              other: PyObject) -> CompareResult {
    guard let other = Self.downcast(py, other) else {
      return .notImplemented
    }

    let zelfDict = zelf.getDict(py)
    let otherDict = other.getDict(py)
    let result = zelfDict.isEqual(py, other: otherDict)
    return CompareResult(result)
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
    guard Self.downcast(py, zelf) != nil else {
      return .invalidSelfArgument(zelf, Self.pythonTypeName, operation)
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

    let isBuiltin = zelf.type === py.types.simpleNamespace
    let name = isBuiltin ? "namespace" : zelf.typeName

    if zelf.hasReprLock {
      let result = name + "(...)"
      return PyResult(py, interned: result)
    }

    return zelf.withReprLock {
      var values = ""

      let dict = zelf.getDict(py)
      for (index, entry) in dict.elements.enumerated() {
        if index > 0 {
          values.append(", ")
        }

        let keyRepr: String
        switch py.reprString(entry.key.object) {
        case let .value(r): keyRepr = r
        case let .error(e): return .error(e)
        }

        let valueRepr: String
        switch py.reprString(entry.value) {
        case let .value(r): valueRepr = r
        case let .error(e): return .error(e)
        }

        values.append("\(keyRepr)=\(valueRepr)")
      }

      let result = "\(name)(\(values))"
      return PyResult(py, result)
    }
  }

  // MARK: - Attributes

  // sourcery: pymethod = __getattribute__
  internal static func __getattribute__(_ py: Py,
                                        zelf _zelf: PyObject,
                                        name: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "__getattribute__")
    }

    return AttributeHelper.getAttribute(py, object: zelf.asObject, name: name)
  }

  // sourcery: pymethod = __setattr__
  internal static func __setattr__(_ py: Py,
                                   zelf _zelf: PyObject,
                                   name: PyObject,
                                   value: PyObject?) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "__setattr__")
    }

    return AttributeHelper.setAttribute(py, object: zelf.asObject, name: name, value: value)
  }

  // sourcery: pymethod = __delattr__
  internal static func __delattr__(_ py: Py,
                                   zelf _zelf: PyObject,
                                   name: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "__delattr__")
    }

    return AttributeHelper.delAttribute(py, object: zelf.asObject, name: name)
  }

  // MARK: - Python new

  // sourcery: pystaticmethod = __new__
  internal static func __new__(_ py: Py,
                               type: PyType,
                               args: [PyObject],
                               kwargs: PyDict?) -> PyResult {
    let dict = py.newDict()
    let result = py.memory.newNamespace(type: type, __dict__: dict)
    return PyResult(result)
  }

  // MARK: - Python init

  // sourcery: pymethod = __init__
  internal static func __init__(_ py: Py,
                                zelf _zelf: PyObject,
                                args: [PyObject],
                                kwargs: PyDict?) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "__init__")
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

    let dict = zelf.getDict(py)
    if let e = dict.update(py, from: kwargs, onKeyDuplicate: .continue) {
      return .error(e)
    }

    return .none(py)
  }
}
