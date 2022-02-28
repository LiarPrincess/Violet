import BigInt
import VioletCore

// cSpell:ignore iterobject

// In CPython:
// Objects -> iterobject.c

// sourcery: pytype = iterator, isDefault, hasGC
public struct PyIterator: PyObjectMixin {

  // sourcery: pytypedoc
  internal static let doc: String? = nil

  internal enum Layout {
    internal static let sequenceOffset = SizeOf.objectHeader
    internal static let sequenceSize = SizeOf.object

    internal static let indexOffset = sequenceOffset + sequenceSize
    internal static let indexSize = SizeOf.int

    internal static let size = indexOffset + indexSize
  }

  private var sequencePtr: Ptr<PyObject> { self.ptr[Layout.sequenceOffset] }
  private var indexPtr: Ptr<Int> { self.ptr[Layout.indexOffset] }

  internal var sequence: PyObject { self.sequencePtr.pointee }
  internal var index: Int { self.indexPtr.pointee }

  public let ptr: RawPtr

  public init(ptr: RawPtr) {
    self.ptr = ptr
  }

  internal func initialize(type: PyType, sequence: PyObject) {
    self.header.initialize(type: type)
    self.sequencePtr.initialize(to: sequence)
    self.indexPtr.initialize(to: 0)
  }

  internal static func deinitialize(ptr: RawPtr) {
    let zelf = PyIterator(ptr: ptr)
    zelf.header.deinitialize()
    zelf.sequencePtr.deinitialize()
    zelf.indexPtr.deinitialize()
  }

  internal static func createDebugString(ptr: RawPtr) -> String {
    let zelf = PyIterator(ptr: ptr)
    return "PyIterator(type: \(zelf.typeName), flags: \(zelf.flags))"
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
    guard self.index != PyIterator.endIndex else {
      return .stopIteration()
    }

    switch Py.getItem(object: self.sequence, index: self.index) {
    case .value(let o):
      self.index += 1
      return .value(o)

    case .error(let e):
      if PyCast.isIndexError(e) || PyCast.isStopIteration(e) {
        self.index = PyIterator.endIndex
        return .stopIteration()
      }

      return .error(e)
    }
  }

  // MARK: - Length hint

  // sourcery: pymethod = __length_hint__
  internal func lengthHint() -> PyResult<PyInt> {
    let len: BigInt
    switch Py.lenBigInt(iterable: self.sequence) {
    case let .value(l): len = l
    case let .error(e): return .error(e)
    }

    let result = len - BigInt(self.index)
    return .value(Py.newInt(result))
  }
}

*/
