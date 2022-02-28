import VioletCore

// cSpell:ignore iterobject

// In CPython:
// Objects -> iterobject.c

// sourcery: pytype = callable_iterator, isDefault, hasGC
public struct PyCallableIterator: PyObjectMixin {

  // sourcery: pytypedoc
  internal static let doc: String? = nil

  internal enum Layout {
    internal static let callableOffset = SizeOf.objectHeader
    internal static let callableSize = SizeOf.object

    internal static let sentinelOffset = callableOffset + callableSize
    internal static let sentinelSize = SizeOf.object

    internal static let size = sentinelOffset + sentinelSize
  }

  private var callablePtr: Ptr<PyObject> { Ptr(self.ptr, offset: Layout.callableOffset) }
  private var sentinelPtr: Ptr<PyObject> { Ptr(self.ptr, offset: Layout.sentinelOffset) }

  internal var callable: PyObject { self.callablePtr.pointee }
  internal var sentinel: PyObject { self.sentinelPtr.pointee }

  public let ptr: RawPtr

  public init(ptr: RawPtr) {
    self.ptr = ptr
  }

  internal func initialize(type: PyType, callable: PyObject, sentinel: PyObject) {
    self.header.initialize(type: type)
    self.callablePtr.initialize(to: callable)
    self.sentinelPtr.initialize(to: sentinel)
  }

  internal static func deinitialize(ptr: RawPtr) {
    let zelf = PyCallableIterator(ptr: ptr)
    zelf.header.deinitialize()
    zelf.callablePtr.deinitialize()
    zelf.sentinelPtr.deinitialize()
  }

  internal static func createDebugString(ptr: RawPtr) -> String {
    let zelf = PyCallableIterator(ptr: ptr)
    return "PyCallableIterator(type: \(zelf.typeName), flags: \(zelf.flags))"
  }
}

/* MARKER

  // MARK: - Class

  // sourcery: pyproperty = __class__
  internal func getClass() -> PyType {
    return self.type
  }

  // MARK: - Attributes

  // sourcery: pymethod = __getattribute__
  internal func getAttribute(name: PyObject) -> PyResult<PyObject> {
    return AttributeHelper.getAttribute(from: self, name: name)
  }

  // MARK: - Iter

  // sourcery: pymethod = __iter__
  internal func iter() -> PyObject {
    return self
  }

  // MARK: - Next

  // sourcery: pymethod = __next__
  internal func next() -> PyResult<PyObject> {
    switch Py.call(callable: self.callable) {
    case let .value(o):
      // If we are equal to 'self.sentinel' then we have to stop
      switch Py.isEqualBool(left: o, right: self.sentinel) {
      case .value(true):
        return .stopIteration()
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

*/
