import VioletCore

// cSpell:ignore bytesobject

// In CPython:
// Objects -> bytesobject.c

// sourcery: pytype = bytes_iterator, isDefault, hasGC
public struct PyBytesIterator: PyObjectMixin {

  // sourcery: pytypedoc
  internal static let doc: String? = nil

  // sourcery: storedProperty
  internal var bytes: PyBytes { self.bytesPtr.pointee }

  // sourcery: storedProperty
  internal var index: Int {
    get { self.indexPtr.pointee }
    nonmutating set { self.indexPtr.pointee = newValue }
  }

  public let ptr: RawPtr

  public init(ptr: RawPtr) {
    self.ptr = ptr
  }

  internal func initialize(_ py: Py, type: PyType, bytes: PyBytes) {
    self.initializeBase(py, type: type)
    self.bytesPtr.initialize(to: bytes)
    self.indexPtr.initialize(to: 0)
  }

  // Nothing to do here.
  internal func beforeDeinitialize(_ py: Py) {}

  internal static func createDebugInfo(ptr: RawPtr) -> PyObject.DebugMirror {
    let zelf = PyBytesIterator(ptr: ptr)
    var result = PyObject.DebugMirror(object: zelf)
    result.append(name: "index", value: zelf.index)
    result.append(name: "bytes", value: zelf.bytes)
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

    let elements = zelf.bytes.elements

    if zelf.index < elements.count {
      let byte = elements[zelf.index]
      let result = py.newInt(byte)
      zelf.index += 1
      return PyResult(result)
    }

    return .stopIteration(py)
  }

  // MARK: - Length hint

  // sourcery: pymethod = __length_hint__
  internal static func __length_hint__(_ py: Py, zelf _zelf: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "__length_hint__")
    }

    let count = zelf.bytes.count
    let result = count - zelf.index
    return PyResult(py, result)
  }

  // MARK: - Python new

  // sourcery: pystaticmethod = __new__
  internal static func __new__(_ py: Py,
                               type: PyType,
                               args: [PyObject],
                               kwargs: PyDict?) -> PyResult {
    return .typeError(py, message: "cannot create 'bytes_iterator' instances")
  }
}
