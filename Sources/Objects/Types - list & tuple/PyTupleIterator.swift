import VioletCore

// cSpell:ignore tupleobject

// In CPython:
// Objects -> tupleobject.c

// sourcery: pytype = tuple_iterator, isDefault, hasGC
 public struct PyTupleIterator: PyObjectMixin {

  // sourcery: pytypedoc
  internal static let doc: String? = nil

   // sourcery: includeInLayout
   internal var tuple: PyTuple { self.tuplePtr.pointee }
   // sourcery: includeInLayout
   internal var index: Int { self.indexPtr.pointee }

   public let ptr: RawPtr

   public init(ptr: RawPtr) {
     self.ptr = ptr
   }

   internal func initialize(_ py: Py, type: PyType, tuple: PyTuple) {
     self.header.initialize(py, type: type)
     self.tuplePtr.initialize(to: tuple)
     self.indexPtr.initialize(to: 0)
   }

   // Nothing to do here.
   internal func beforeDeinitialize() { }

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
