import VioletCore

// cSpell:ignore unicodeobject

// In CPython:
// Objects -> unicodeobject.c

// sourcery: pytype = str_iterator, isDefault, hasGC
public struct PyStringIterator: PyObjectMixin {

  // sourcery: pytypedoc
  internal static let doc: String? = nil

  // sourcery: storedProperty
  internal var string: PyString { self.stringPtr.pointee }

  // sourcery: storedProperty
  internal var index: Int {
    get { self.indexPtr.pointee }
    nonmutating set { self.indexPtr.pointee = newValue }
  }

  public let ptr: RawPtr

  public init(ptr: RawPtr) {
    self.ptr = ptr
  }

  internal func initialize(_ py: Py, type: PyType, string: PyString) {
    self.initializeBase(py, type: type)
    self.stringPtr.initialize(to: string)
    self.indexPtr.initialize(to: 0)
  }

  // Nothing to do here.
  internal func beforeDeinitialize(_ py: Py) {}

  internal static func createDebugInfo(ptr: RawPtr) -> PyObject.DebugMirror {
    let zelf = PyStringIterator(ptr: ptr)
    var result = PyObject.DebugMirror(object: zelf)
    result.append(name: "index", value: zelf.index)
    result.append(name: "string", value: zelf.string)
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

    let elements = zelf.string.elements

    let indexOrNil = elements.index(elements.startIndex,
                                    offsetBy: zelf.index,
                                    limitedBy: elements.endIndex)

    if let index = indexOrNil, index != elements.endIndex {
      zelf.index += 1
      let scalar = elements[index]
      let result = py.newString(scalar: scalar)
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

    let count = zelf.string.count
    let result = count - zelf.index
    return PyResult(py, result)
  }

  // MARK: - Python new

  // sourcery: pystaticmethod = __new__
  internal static func __new__(_ py: Py,
                               type: PyType,
                               args: [PyObject],
                               kwargs: PyDict?) -> PyResult {
    return .typeError(py, message: "cannot create 'str_iterator' instances")
  }
}
