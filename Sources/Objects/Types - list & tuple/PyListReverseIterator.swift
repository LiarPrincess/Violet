import VioletCore

// cSpell:ignore listobject

// In CPython:
// Objects -> listobject.c

// sourcery: pytype = list_reverseiterator, isDefault, hasGC
public struct PyListReverseIterator: PyObjectMixin {

  // sourcery: pytypedoc
  internal static let doc: String? = nil

  // sourcery: storedProperty
  internal var list: PyList { self.listPtr.pointee }

  // sourcery: storedProperty
  internal var index: Int {
    get { self.indexPtr.pointee }
    nonmutating set { self.indexPtr.pointee = newValue }
  }

  public let ptr: RawPtr

  public init(ptr: RawPtr) {
    self.ptr = ptr
  }

  internal func initialize(_ py: Py, type: PyType, list: PyList) {
    let index = list.count - 1
    self.initializeBase(py, type: type)
    self.listPtr.initialize(to: list)
    self.indexPtr.initialize(to: index)
  }

  // Nothing to do here.
  internal func beforeDeinitialize(_ py: Py) {}

  internal static func createDebugInfo(ptr: RawPtr) -> PyObject.DebugMirror {
    let zelf = PyListReverseIterator(ptr: ptr)
    var result = PyObject.DebugMirror(object: zelf)
    result.append(name: "index", value: zelf.index, includeInDescription: true)
    result.append(name: "count", value: zelf.list.count, includeInDescription: true)
    result.append(name: "list", value: zelf.list)
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
                                        zelf: PyObject,
                                        name: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, zelf) else {
      return Self.invalidZelfArgument(py, zelf, "__getattribute__")
    }

    return AttributeHelper.getAttribute(py, object: zelf.asObject, name: name)
  }

  // MARK: - Iter

  // sourcery: pymethod = __iter__
  internal static func __iter__(_ py: Py, zelf: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, zelf) else {
      return Self.invalidZelfArgument(py, zelf, "__iter__")
    }

    return PyResult(zelf)
  }

  // MARK: - Next

  // sourcery: pymethod = __next__
  internal static func __next__(_ py: Py, zelf: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, zelf) else {
      return Self.invalidZelfArgument(py, zelf, "__next__")
    }

    if zelf.index >= 0 {
      let item = zelf.list.elements[zelf.index]
      zelf.index -= 1
      return .value(item)
    }

    zelf.index = -1
    return .stopIteration(py)
  }

  // MARK: - Length hint

  // sourcery: pymethod = __length_hint__
  internal static func __length_hint__(_ py: Py, zelf: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, zelf) else {
      return Self.invalidZelfArgument(py, zelf, "__length_hint__")
    }

    // '+1' because users start counting from 1, not from 0
    let result = zelf.index + 1
    return PyResult(py, result)
  }

  // MARK: - Python new

  // sourcery: pystaticmethod = __new__
  internal static func __new__(_ py: Py,
                               type: PyType,
                               args: [PyObject],
                               kwargs: PyDict?) -> PyResult {
    return .typeError(py, message: "cannot create 'list_reverseiterator' instances")
  }
}
