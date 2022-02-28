import VioletCore

// cSpell:ignore bytearrayobject

// In CPython:
// Objects -> bytearrayobject.c

// sourcery: pytype = bytearray_iterator, isDefault, hasGC
public struct PyByteArrayIterator: PyObjectMixin {

  // sourcery: pytypedoc
  internal static let doc: String? = nil

  internal enum Layout {
    internal static let bytesOffset = SizeOf.objectHeader
    internal static let bytesSize = SizeOf.object

    internal static let indexOffset = bytesOffset + bytesSize
    internal static let indexSize = SizeOf.int

    internal static let size = indexOffset + indexSize
  }

  private var bytesPtr: Ptr<PyByteArray> { self.ptr[Layout.bytesOffset] }
  private var indexPtr: Ptr<Int> { self.ptr[Layout.indexOffset] }

  internal var bytes: PyByteArray { self.bytesPtr.pointee }
  internal var index: Int { self.indexPtr.pointee }

  public let ptr: RawPtr

  public init(ptr: RawPtr) {
    self.ptr = ptr
  }

  internal func initialize(type: PyType, bytes: PyByteArray) {
    self.header.initialize(type: type)
    self.bytesPtr.initialize(to: bytes)
    self.indexPtr.initialize(to: 0)
  }

  internal static func deinitialize(ptr: RawPtr) {
    let zelf = PyByteArrayIterator(ptr: ptr)
    zelf.header.deinitialize()
    zelf.bytesPtr.deinitialize()
    zelf.indexPtr.deinitialize()
  }

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
