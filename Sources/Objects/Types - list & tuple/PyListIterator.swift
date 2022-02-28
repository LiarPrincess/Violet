import VioletCore

// cSpell:ignore listobject

// In CPython:
// Objects -> listobject.c

// sourcery: pytype = list_iterator, isDefault, hasGC
public struct PyListIterator: PyObjectMixin {

  // sourcery: pytypedoc
  internal static let doc: String? = nil

  internal enum Layout {
    internal static let listOffset = SizeOf.objectHeader
    internal static let listSize = SizeOf.object

    internal static let indexOffset = listOffset + listSize
    internal static let indexSize = SizeOf.int

    internal static let size = indexOffset + indexSize
  }

  private var listPtr: Ptr<PyList> { Ptr(self.ptr, offset: Layout.listOffset) }
  private var indexPtr: Ptr<Int> { Ptr(self.ptr, offset: Layout.indexOffset) }

  internal var list: PyList { self.listPtr.pointee }
  internal var index: Int { self.indexPtr.pointee }

  public let ptr: RawPtr

  public init(ptr: RawPtr) {
    self.ptr = ptr
  }

  internal func initialize(type: PyType, list: PyList) {
    self.header.initialize(type: type)
    self.listPtr.initialize(to: list)
    self.indexPtr.initialize(to: 0)
  }

  internal static func deinitialize(ptr: RawPtr) {
    let zelf = PyListIterator(ptr: ptr)
    zelf.header.deinitialize()
    zelf.listPtr.deinitialize()
    zelf.indexPtr.deinitialize()
  }

  // MARK: - Debug

  internal static func createDebugString(ptr: RawPtr) -> String {
    let zelf = PyListIterator(ptr: ptr)
    return "PyListIterator(type: \(zelf.typeName), flags: \(zelf.flags))"
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
    if self.index < self.list.elements.count {
      let item = self.list.elements[self.index]
      self.index += 1
      return .value(item)
    }

    return .stopIteration()
  }

  // MARK: - Length hint

  // sourcery: pymethod = __length_hint__
  internal func lengthHint() -> PyInt {
    let count = self.list.count
    let result = count - self.index
    return Py.newInt(result)
  }

  // MARK: - Python new

  // sourcery: pystaticmethod = __new__
  internal static func pyNew(type: PyType,
                             args: [PyObject],
                             kwargs: PyDict?) -> PyResult<PyListIterator> {
    return .typeError("cannot create 'list_iterator' instances")
  }
}

*/
