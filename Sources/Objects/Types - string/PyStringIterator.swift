import VioletCore

// cSpell:ignore unicodeobject

// In CPython:
// Objects -> unicodeobject.c

// sourcery: pytype = str_iterator, isDefault, hasGC
public struct PyStringIterator: PyObjectMixin {

  // sourcery: pytypedoc
  internal static let doc: String? = nil

  // Layout will be automatically generated, from `Ptr` fields.
  // Just remember to initialize them in `initialize`!
  internal static let layout = PyMemory.PyStringIteratorLayout()

  internal var stringPtr: Ptr<PyString> { self.ptr[Self.layout.stringOffset] }
  internal var indexPtr: Ptr<Int> { self.ptr[Self.layout.indexOffset] }

  internal var string: PyString { self.stringPtr.pointee }
  internal var index: Int { self.indexPtr.pointee }

  public let ptr: RawPtr

  public init(ptr: RawPtr) {
    self.ptr = ptr
  }

  internal func initialize(_ py: Py, type: PyType, string: PyString) {
    self.header.initialize(py, type: type)
    self.stringPtr.initialize(to: string)
    self.indexPtr.initialize(to: 0)
  }

  // Nothing to do here.
  internal func beforeDeinitialize() { }

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
