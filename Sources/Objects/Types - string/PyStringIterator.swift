import VioletCore

// cSpell:ignore unicodeobject

// In CPython:
// Objects -> unicodeobject.c

// sourcery: pytype = str_iterator, isDefault, hasGC
public struct PyStringIterator: PyObjectMixin {

  // sourcery: pytypedoc
  internal static let doc: String? = nil

  internal enum Layout {
    internal static let stringOffset = SizeOf.objectHeader
    internal static let stringSize = SizeOf.object

    internal static let indexOffset = stringOffset + stringSize
    internal static let indexSize = SizeOf.int

    internal static let size = indexOffset + indexSize
  }

  private var stringPtr: Ptr<PyString> { self.ptr[Layout.stringOffset] }
  private var indexPtr: Ptr<Int> { self.ptr[Layout.indexOffset] }

  internal var string: PyString { self.stringPtr.pointee }
  internal var index: Int { self.indexPtr.pointee }

  public let ptr: RawPtr

  public init(ptr: RawPtr) {
    self.ptr = ptr
  }

  internal func initialize(type: PyType, string: PyString) {
    self.header.initialize(type: type)
    self.stringPtr.initialize(to: string)
    self.indexPtr.initialize(to: 0)
  }

  internal static func deinitialize(ptr: RawPtr) {
    let zelf = PyStringIterator(ptr: ptr)
    zelf.header.deinitialize()
    zelf.stringPtr.deinitialize()
    zelf.indexPtr.deinitialize()
  }

  internal static func createDebugString(ptr: RawPtr) -> String {
    let zelf = PyStringIterator(ptr: ptr)
    return "PyStringIterator(type: \(zelf.typeName), flags: \(zelf.flags))"
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
    let elements = self.string.elements

    let indexOrNil = elements.index(elements.startIndex,
                                    offsetBy: self.index,
                                    limitedBy: elements.endIndex)

    if let index = indexOrNil, index != elements.endIndex {
      self.index += 1
      let scalar = elements[index]
      let string = Py.newString(scalar: scalar)
      return .value(string)
    }

    return .stopIteration()
  }

  // MARK: - Length hint

  // sourcery: pymethod = __length_hint__
  internal func lengthHint() -> PyInt {
    let count = self.string.count
    let result = count - self.index
    return Py.newInt(result)
  }

  // MARK: - Python new

  // sourcery: pystaticmethod = __new__
  internal class func pyNew(type: PyType,
                            args: [PyObject],
                            kwargs: PyDict?) -> PyResult<PyStringIterator> {
    return .typeError("cannot create 'str_iterator' instances")
  }
}

*/
