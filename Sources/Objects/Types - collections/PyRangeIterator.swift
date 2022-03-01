import BigInt
import VioletCore

// cSpell:ignore rangeobject

// In CPython:
// Objects -> rangeobject.c

// sourcery: pytype = range_iterator, isDefault
public struct PyRangeIterator: PyObjectMixin {

  // sourcery: pytypedoc
  internal static let doc: String? = nil

  // MARK: - Properties

  // Layout will be automatically generated, from `Ptr` fields.
  // Just remember to initialize them in `initialize`!
  internal static let layout = PyMemory.PyRangeIteratorLayout()

  internal var startPtr: Ptr<BigInt> { self.ptr[Self.layout.startOffset] }
  internal var stepPtr: Ptr<BigInt> { self.ptr[Self.layout.stepOffset] }
  internal var lengthPtr: Ptr<BigInt> { self.ptr[Self.layout.lengthOffset] }
  internal var indexPtr: Ptr<BigInt> { self.ptr[Self.layout.indexOffset] }

  internal var start: BigInt { self.startPtr.pointee }
  internal var step: BigInt { self.stepPtr.pointee }
  internal var length: BigInt { self.lengthPtr.pointee }
  internal var index: BigInt { self.indexPtr.pointee }

  // MARK: - Swift init

  public let ptr: RawPtr

  public init(ptr: RawPtr) {
    self.ptr = ptr
  }

  // MARK: - Initialize/deinitialize

  internal func initialize(type: PyType, start: BigInt, step: BigInt, length: BigInt) {
    self.header.initialize(type: type)
    self.startPtr.initialize(to: start)
    self.stepPtr.initialize(to: step)
    self.lengthPtr.initialize(to: length)
    self.indexPtr.initialize(to: 0)
  }

  // Nothing to do here.
  internal func beforeDeinitialize() { }

  // MARK: - Debug

  internal static func createDebugString(ptr: RawPtr) -> String {
    let zelf = PyRangeIterator(ptr: ptr)
    return "PyRangeIterator(type: \(zelf.typeName), flags: \(zelf.flags))"
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
    if self.index < self.length {
      let result = self.start + self.step * self.index
      self.index += 1
      return .value(Py.newInt(result))
    }

    return .stopIteration()
  }

  // MARK: - Length hint

  // sourcery: pymethod = __length_hint__
  internal func lengthHint() -> PyInt {
    let result = self.length - self.index
    return Py.newInt(result)
  }

  // MARK: - Python new

  // sourcery: pystaticmethod = __new__
  internal static func pyNew(type: PyType,
                             args: [PyObject],
                             kwargs: PyDict?) -> PyResult<PyRangeIterator> {
    return .typeError("cannot create 'range_iterator' instances")
  }
}

*/
