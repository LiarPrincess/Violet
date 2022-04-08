import BigInt
import VioletCore

// cSpell:ignore iterobject

// In CPython:
// Objects -> iterobject.c

// sourcery: pytype = iterator, isDefault, hasGC
public struct PyIterator: PyObjectMixin {

  // sourcery: pytypedoc
  internal static let doc: String? = nil

  private static let endIndex = -1

  // sourcery: storedProperty
  internal var sequence: PyObject { self.sequencePtr.pointee }

  // sourcery: storedProperty
  internal var index: Int {
    get { self.indexPtr.pointee }
    nonmutating set { self.indexPtr.pointee = newValue }
  }

  public let ptr: RawPtr

  public init(ptr: RawPtr) {
    self.ptr = ptr
  }

  internal func initialize(_ py: Py, type: PyType, sequence: PyObject) {
    self.initializeBase(py, type: type)
    self.sequencePtr.initialize(to: sequence)
    self.indexPtr.initialize(to: 0)
  }

  // Nothing to do here.
  internal func beforeDeinitialize(_ py: Py) {}

  internal static func createDebugInfo(ptr: RawPtr) -> PyObject.DebugMirror {
    let zelf = PyIterator(ptr: ptr)
    var result = PyObject.DebugMirror(object: zelf)
    result.append(name: "index", value: zelf.index)
    result.append(name: "sequence", value: zelf.sequence)
    return result
  }

  // MARK: - Class

  // sourcery: pyproperty = __class__
  internal static func __class__(_ py: Py, zelf: PyObject) -> PyType {
    return zelf.type
  }

  // MARK: - Attributes

  // sourcery: pymethod = __getattribute__
  internal static func __getattribute__(_ py: Py,
                                        zelf _zelf: PyObject,
                                        name: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "__getattribute__")
    }

    return AttributeHelper.getAttribute(py, object: zelf.asObject, name: name)
  }

  // MARK: - Iter

  // sourcery: pymethod = __iter__
  internal static func __iter__(_ py: Py, zelf _zelf: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "__iter__")
    }

    return PyResult(zelf)
  }

  // MARK: - Next

  // sourcery: pymethod = __next__
  internal static func __next__(_ py: Py, zelf _zelf: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "__next__")
    }

    guard zelf.index != Self.endIndex else {
      return .stopIteration(py)
    }

    switch py.getItem(object: zelf.sequence, index: zelf.index) {
    case .value(let o):
      zelf.index += 1
      return .value(o)

    case .error(let e):
      if py.cast.isIndexError(e.asObject) || py.cast.isStopIteration(e.asObject) {
        zelf.index = Self.endIndex
        return .stopIteration(py)
      }

      return .error(e)
    }
  }

  // MARK: - Length hint

  // sourcery: pymethod = __length_hint__
  internal static func __length_hint__(_ py: Py, zelf _zelf: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "__length_hint__")
    }

    let len: PyInt
    switch py.lengthPyInt(iterable: zelf.sequence) {
    case let .value(l): len = l
    case let .error(e): return .error(e)
    }

    let result = len.value - BigInt(zelf.index)
    return PyResult(py, result)
  }
}
