import VioletCore

// cSpell:ignore iterobject

// In CPython:
// Objects -> iterobject.c

// sourcery: pytype = callable_iterator, isDefault, hasGC
public struct PyCallableIterator: PyObjectMixin {

  // sourcery: pytypedoc
  internal static let doc: String? = nil

  // sourcery: storedProperty
  internal var callable: PyObject { self.callablePtr.pointee }
  // sourcery: storedProperty
  internal var sentinel: PyObject { self.sentinelPtr.pointee }

  public let ptr: RawPtr

  public init(ptr: RawPtr) {
    self.ptr = ptr
  }

  internal func initialize(_ py: Py, type: PyType, callable: PyObject, sentinel: PyObject) {
    self.initializeBase(py, type: type)
    self.callablePtr.initialize(to: callable)
    self.sentinelPtr.initialize(to: sentinel)
  }

  // Nothing to do here.
  internal func beforeDeinitialize(_ py: Py) {}

  internal static func createDebugInfo(ptr: RawPtr) -> PyObject.DebugMirror {
    let zelf = PyCallableIterator(ptr: ptr)
    var result = PyObject.DebugMirror(object: zelf)
    result.append(name: "callable", value: zelf.callable)
    result.append(name: "sentinel", value: zelf.sentinel)
    return result
  }

  // MARK: - Class

  // sourcery: pyproperty = __class__
  internal static func __class__(_ py: Py, zelf: PyObject) -> PyType {
    return zelf.type
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

  // MARK: - Iter

  // sourcery: pymethod = __iter__
  internal static func __iter__(_ py: Py, zelf _zelf: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "__iter__")
    }

    return PyResult(zelf)
  }

  // MARK: - Next

  // sourcery: pymethod = __next__
  internal static func __next__(_ py: Py, zelf _zelf: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "__next__")
    }

    switch py.call(callable: zelf.callable) {
    case let .value(o):
      // If we are equal to 'self.sentinel' then we have to stop
      switch py.isEqualBool(left: o, right: zelf.sentinel) {
      case .value(true):
        return .stopIteration(py)
      case .value(false):
        return .value(o)
      case .error(let e):
        return .error(e)
      }
    case .error(let e),
        .notCallable(let e):
      // This also handles 'StopIteration'
      return .error(e)
    }
  }
}
