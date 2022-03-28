import VioletCore

// cSpell:ignore dictobject

// In CPython:
// Objects -> dictobject.c

// sourcery: pytype = dict_keyiterator, isDefault, hasGC
public struct PyDictKeyIterator: PyObjectMixin, AbstractDictViewIterator {

  // sourcery: pytypedoc
  internal static let doc: String? = nil

  // sourcery: storedProperty
  internal var dict: PyDict { self.dictPtr.pointee }

  // sourcery: storedProperty
  internal var index: Int {
    get { self.indexPtr.pointee }
    nonmutating set { self.indexPtr.pointee = newValue }
  }

  // sourcery: storedProperty
  internal var initialCount: Int { self.initialCountPtr.pointee }

  public let ptr: RawPtr

  public init(ptr: RawPtr) {
    self.ptr = ptr
  }

  internal func initialize(_ py: Py, type: PyType, dict: PyDict) {
    let initialCount = dict.elements.count
    self.initializeBase(py, type: type)
    self.dictPtr.initialize(to: dict)
    self.indexPtr.initialize(to: 0)
    self.initialCountPtr.initialize(to: initialCount)
  }

  // Nothing to do here.
  internal func beforeDeinitialize(_ py: Py) {}

  internal static func createDebugInfo(ptr: RawPtr) -> PyObject.DebugMirror {
    let zelf = PyDictKeyIterator(ptr: ptr)
    var result = PyObject.DebugMirror(object: zelf)
    result.append(name: "index", value: zelf.index, includeInDescription: true)
    result.append(name: "count", value: zelf.dict.count, includeInDescription: true)
    result.append(name: "dict", value: zelf.dict)
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
    return Self.abstract__getattribute__(py, zelf: zelf, name: name)
  }

  // MARK: - Iter

  // sourcery: pymethod = __iter__
  internal static func __iter__(_ py: Py, zelf: PyObject) -> PyResult {
    return Self.abstract__iter__(py, zelf: zelf)
  }

  // MARK: - Next

  // sourcery: pymethod = __next__
  internal static func __next__(_ py: Py, zelf: PyObject) -> PyResult {
    switch Self.abstract__next__(py, zelf: zelf) {
    case let .value(entry):
      let key = entry.key.object
      return .value(key)
    case let .error(e):
      return .error(e)
    }
  }

  // MARK: - Length hint

  // sourcery: pymethod = __length_hint__
  internal static func __length_hint__(_ py: Py, zelf: PyObject) -> PyResult {
    return Self.abstract__length_hint__(py, zelf: zelf)
  }

  // MARK: - Python new

  // sourcery: pystaticmethod = __new__
  internal static func __new__(_ py: Py,
                               type: PyType,
                               args: [PyObject],
                               kwargs: PyDict?) -> PyResult {
    return .typeError(py, message: "cannot create 'dict_keyiterator' instances")
  }
}
