import BigInt
import VioletCore

// cSpell:ignore rangeobject

// In CPython:
// Objects -> rangeobject.c

// sourcery: pytype = range_iterator, isDefault
public struct PyRangeIterator: PyObjectMixin {

  // sourcery: pytypedoc
  internal static let doc: String? = nil

  // sourcery: storedProperty
  internal var start: BigInt { self.startPtr.pointee }
  // sourcery: storedProperty
  internal var step: BigInt { self.stepPtr.pointee }
  // sourcery: storedProperty
  internal var length: BigInt { self.lengthPtr.pointee }

  // sourcery: storedProperty
  internal var index: BigInt {
    get { self.indexPtr.pointee }
    nonmutating set { self.indexPtr.pointee = newValue }
  }

  public let ptr: RawPtr

  public init(ptr: RawPtr) {
    self.ptr = ptr
  }

  internal func initialize(_ py: Py, type: PyType, start: BigInt, step: BigInt, length: BigInt) {
    self.header.initialize(py, type: type)
    self.startPtr.initialize(to: start)
    self.stepPtr.initialize(to: step)
    self.lengthPtr.initialize(to: length)
    self.indexPtr.initialize(to: 0)
  }

  // Nothing to do here.
  internal func beforeDeinitialize() { }

  internal static func createDebugString(ptr: RawPtr) -> String {
    let zelf = PyRangeIterator(ptr: ptr)
    return "PyRangeIterator(type: \(zelf.typeName), flags: \(zelf.flags))"
  }

  // MARK: - Class

  // sourcery: pyproperty = __class__
  internal static func __class__(_ py: Py, zelf: PyObject) -> PyType {
    return zelf.type
  }

  // MARK: - Attributes

  // sourcery: pymethod = __getattribute__
  internal static func __getattribute__(_ py: Py,
                                        zelf: PyObject,
                                        name: PyObject) -> PyResult<PyObject> {
    guard let zelf = Self.downcast(py, zelf) else {
      return Self.invalidZelfArgument(py, zelf, "__getattribute__")
    }

    return AttributeHelper.getAttribute(py, object: zelf.asObject, name: name)
  }

  // MARK: - Iter

  // sourcery: pymethod = __iter__
  internal static func __iter__(_ py: Py, zelf: PyObject) -> PyResult<PyObject> {
    guard let zelf = Self.downcast(py, zelf) else {
      return Self.invalidZelfArgument(py, zelf, "__iter__")
    }

    return PyResult(zelf)
  }

  // MARK: - Next

  // sourcery: pymethod = __next__
  internal static func __next__(_ py: Py, zelf: PyObject) -> PyResult<PyObject> {
    guard let zelf = Self.downcast(py, zelf) else {
      return Self.invalidZelfArgument(py, zelf, "__next__")
    }

    if zelf.index < zelf.length {
      let result = zelf.start + zelf.step * zelf.index
      zelf.index += 1
      return PyResult(py, result)
    }

    return .stopIteration(py)
  }

  // MARK: - Length hint

  // sourcery: pymethod = __length_hint__
  internal static func __length_hint__(_ py: Py, zelf: PyObject) -> PyResult<PyObject> {
    guard let zelf = Self.downcast(py, zelf) else {
      return Self.invalidZelfArgument(py, zelf, "__length_hint__")
    }

    let result = zelf.length - zelf.index
    return PyResult(py, result)
  }

  // MARK: - Python new

  // sourcery: pystaticmethod = __new__
  internal static func __new__(_ py: Py,
                               type: PyType,
                               args: [PyObject],
                               kwargs: PyDict?) -> PyResult<PyObject> {
    return .typeError(py, message: "cannot create 'range_iterator' instances")
  }
}
