import VioletCore

// cSpell:ignore tupleobject

// In CPython:
// Objects -> tupleobject.c

// sourcery: pytype = tuple_iterator, isDefault, hasGC
 public struct PyTupleIterator: PyObjectMixin {

  // sourcery: pytypedoc
  internal static let doc: String? = nil

   internal enum Layout {
     internal static let tupleOffset = SizeOf.objectHeader
     internal static let tupleSize = SizeOf.object

     internal static let indexOffset = tupleOffset + tupleSize
     internal static let indexSize = SizeOf.int

     internal static let size = indexOffset + indexSize
   }

   private var tuplePtr: Ptr<PyTuple> { self.ptr[Layout.tupleOffset] }
   private var indexPtr: Ptr<Int> { self.ptr[Layout.indexOffset] }

   internal var tuple: PyTuple { self.tuplePtr.pointee }
   internal var index: Int { self.indexPtr.pointee }

   public let ptr: RawPtr

   public init(ptr: RawPtr) {
     self.ptr = ptr
   }

   internal func initialize(type: PyType, tuple: PyTuple) {
     self.header.initialize(type: type)
     self.tuplePtr.initialize(to: tuple)
     self.indexPtr.initialize(to: 0)
   }

   internal static func deinitialize(ptr: RawPtr) {
     let zelf = PyTupleIterator(ptr: ptr)
     zelf.header.deinitialize()
     zelf.tuplePtr.deinitialize()
     zelf.indexPtr.deinitialize()
   }

   internal static func createDebugString(ptr: RawPtr) -> String {
     let zelf = PyTupleIterator(ptr: ptr)
     return "PyTupleIterator(type: \(zelf.typeName), flags: \(zelf.flags))"
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
    if self.index < self.tuple.elements.count {
      let item = self.tuple.elements[self.index]
      self.index += 1
      return .value(item)
    }

    return .stopIteration()
  }

  // MARK: - Length hint

  // sourcery: pymethod = __length_hint__
  internal func lengthHint() -> PyInt {
    let tupleCount = self.tuple.count
    let result = tupleCount - self.index
    return Py.newInt(result)
  }

  // MARK: - Python new

  // sourcery: pystaticmethod = __new__
  internal static func pyNew(type: PyType,
                             args: [PyObject],
                             kwargs: PyDict?) -> PyResult<PyTupleIterator> {
    return .typeError("cannot create 'tuple_iterator' instances")
  }
}

*/
