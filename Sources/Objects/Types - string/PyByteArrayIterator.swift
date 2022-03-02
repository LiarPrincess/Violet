import VioletCore

// cSpell:ignore bytearrayobject

// In CPython:
// Objects -> bytearrayobject.c

// sourcery: pytype = bytearray_iterator, isDefault, hasGC
public struct PyByteArrayIterator: PyObjectMixin {

  // sourcery: pytypedoc
  internal static let doc: String? = nil

  // Layout will be automatically generated, from `Ptr` fields.
  // Just remember to initialize them in `initialize`!
  internal static let layout = PyMemory.PyByteArrayIteratorLayout()

  internal var bytesPtr: Ptr<PyByteArray> { self.ptr[Self.layout.bytesOffset] }
  internal var indexPtr: Ptr<Int> { self.ptr[Self.layout.indexOffset] }

  internal var bytes: PyByteArray { self.bytesPtr.pointee }
  internal var index: Int { self.indexPtr.pointee }

  public let ptr: RawPtr

  public init(ptr: RawPtr) {
    self.ptr = ptr
  }

  internal func initialize(_ py: Py, type: PyType, bytes: PyByteArray) {
    self.header.initialize(py, type: type)
    self.bytesPtr.initialize(to: bytes)
    self.indexPtr.initialize(to: 0)
  }

  // Nothing to do here.
  internal func beforeDeinitialize() { }

  internal static func createDebugString(ptr: RawPtr) -> String {
    let zelf = PyByteArrayIterator(ptr: ptr)
    return "PyByteArrayIterator(type: \(zelf.typeName), flags: \(zelf.flags))"
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
    if self.index < self.bytes.count {
      let byte = self.bytes.elements[self.index]
      let result = Py.newInt(byte)
      self.index += 1
      return .value(result)
    }

    return .stopIteration()
  }

  // MARK: - Length hint

  // sourcery: pymethod = __length_hint__
  internal func lengthHint() -> PyInt {
    let count = self.bytes.count
    let result = count - self.index
    return Py.newInt(result)
  }

  // MARK: - Python new

  // sourcery: pystaticmethod = __new__
  internal class func pyNew(type: PyType,
                            args: [PyObject],
                            kwargs: PyDict?) -> PyResult<PyByteArrayIterator> {
    return .typeError("cannot create 'bytearray_iterator' instances")
  }
}

*/
