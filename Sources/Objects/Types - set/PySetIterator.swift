import VioletCore

// cSpell:ignore setobject

// In CPython:
// Objects -> setobject.c

// sourcery: pytype = set_iterator, isDefault, hasGC
public struct PySetIterator: PyObjectMixin {

  // sourcery: pytypedoc
  internal static let doc: String? = nil

  // sourcery: storedProperty
  internal var set: PyAnySet { self.setPtr.pointee }

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

  internal func initialize(_ py: Py, type: PyType, set: PySet) {
    self.initializeCommon(py, type: type, set: .init(set: set))
  }

  internal func initialize(_ py: Py, type: PyType, frozenSet: PyFrozenSet) {
    self.initializeCommon(py, type: type, set: .init(frozenSet: frozenSet))
  }

  internal func initializeCommon(_ py: Py, type: PyType, set: PyAnySet) {
    let initialCount = set.elements.count
    self.initializeBase(py, type: type)
    self.setPtr.initialize(to: set)
    self.indexPtr.initialize(to: 0)
    self.initialCountPtr.initialize(to: initialCount)
  }

  // Nothing to do here.
  internal func beforeDeinitialize(_ py: Py) {}

  internal static func createDebugInfo(ptr: RawPtr) -> PyObject.DebugMirror {
    let zelf = PySetIterator(ptr: ptr)
    var result = PyObject.DebugMirror(object: zelf)
    let count = zelf.set.elements.count
    result.append(name: "index", value: zelf.index, includeInDescription: true)
    result.append(name: "count", value: count, includeInDescription: true)
    result.append(name: "initialCount", value: zelf.initialCount, includeInDescription: true)
    result.append(name: "set", value: zelf.set)
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

    let currentCount = zelf.set.elements.count
    guard currentCount == zelf.initialCount else {
      zelf.index = -1 // Make this state sticky
      return .runtimeError(py, message: "Set changed size during iteration")
    }

    let entries = zelf.set.elements.dict.entries
    while zelf.index < entries.count {
      let entry = entries[zelf.index]

      // Increment index NOW, so that the regardless of whether we return 'entry'
      // or iterate more we move to next element.
      zelf.index += 1

      switch entry {
      case .entry(let e):
        let result = e.key.object
        return .value(result)
      case .deleted:
        break // move to next element
      }
    }

    let error = py.newStopIteration(value: nil)
    return .error(error.asBaseException)
  }

  // MARK: - Length hint

  // sourcery: pymethod = __length_hint__
  internal static func __length_hint__(_ py: Py, zelf _zelf: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "__length_hint__")
    }

    let count = zelf.set.elements.count
    let result = count - zelf.index
    return PyResult(py, result)
  }

  // MARK: - Python new

  // sourcery: pystaticmethod = __new__
  internal static func __new__(_ py: Py,
                               type: PyType,
                               args: [PyObject],
                               kwargs: PyDict?) -> PyResult {
    return .typeError(py, message: "cannot create 'set_iterator' instances")
  }
}
