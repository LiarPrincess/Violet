import VioletCore

// cSpell:ignore iterobject

// In CPython:
// Objects -> iterobject.c

// sourcery: pytype = callable_iterator, isDefault, hasGC
public struct PyCallableIterator: PyObjectMixin {

  // sourcery: pytypedoc
  internal static let doc: String? = nil

  // Layout will be automatically generated, from `Ptr` fields.
  // Just remember to initialize them in `initialize`!
  internal static let layout = PyMemory.PyCallableIteratorLayout()

  internal var callablePtr: Ptr<PyObject> { self.ptr[Self.layout.callableOffset] }
  internal var sentinelPtr: Ptr<PyObject> { self.ptr[Self.layout.sentinelOffset] }

  internal var callable: PyObject { self.callablePtr.pointee }
  internal var sentinel: PyObject { self.sentinelPtr.pointee }

  public let ptr: RawPtr

  public init(ptr: RawPtr) {
    self.ptr = ptr
  }

  internal func initialize(_ py: Py, type: PyType, callable: PyObject, sentinel: PyObject) {
    self.header.initialize(py, type: type)
    self.callablePtr.initialize(to: callable)
    self.sentinelPtr.initialize(to: sentinel)
  }

  // Nothing to do here.
  internal func beforeDeinitialize() { }

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
