import VioletCore

// cSpell:ignore enumobject

// In CPython:
// Objects -> enumobject.c

// sourcery: pytype = reversed, isDefault, hasGC, isBaseType
// sourcery: subclassInstancesHave__dict__
/// Return a reverse iterator over the values of the given sequence.
public struct PyReversed: PyObjectMixin {

  // sourcery: pytypedoc
  internal static let doc = """
    reversed(sequence, /)
    --

    Return a reverse iterator over the values of the given sequence.
    """

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

  internal func initialize(_ py: Py,
                           type: PyType,
                           sequence: PyObject,
                           count: Int) {
    self.initializeBase(py, type: type)
    self.sequencePtr.initialize(to: sequence)
    self.indexPtr.initialize(to: count - 1)
  }

  // Nothing to do here.
  internal func beforeDeinitialize(_ py: Py) {}

  internal static func createDebugInfo(ptr: RawPtr) -> PyObject.DebugMirror {
    let zelf = PyReversed(ptr: ptr)
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

    if zelf.index != PyReversed.endIndex {
      switch py.getItem(object: zelf.sequence, index: zelf.index) {
      case .value(let o):
        zelf.index -= 1
        return .value(o)

      case .error(let e):
        if py.cast.isIndexError(e.asObject) || py.cast.isStopIteration(e.asObject) {
          break
        }

        return .error(e)
      }
    }

    zelf.index = PyReversed.endIndex
    return .stopIteration(py)
  }

  // MARK: - Length hint

  // sourcery: pymethod = __length_hint__
  internal static func __length_hint__(_ py: Py, zelf _zelf: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "__length_hint__")
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
    if let e = ArgumentParser.noKwargsOrError(py,
                                              fnName: Self.pythonTypeName,
                                              kwargs: kwargs) {
      return .error(e.asBaseException)
    }

    if let e = ArgumentParser.guaranteeArgsCountOrError(py,
                                                        fnName: Self.pythonTypeName,
                                                        args: args,
                                                        min: 1,
                                                        max: 1) {
      return .error(e.asBaseException)
    }

    return Self.__new__(py, type: type, object: args[0])
  }

  private static func __new__(_ py: Py,
                              type: PyType,
                              object: PyObject) -> PyResult {
    // If we have dedicated '__reversed__' then we will use it
    switch Self.call__reversed__(py, object: object) {
    case .value(let r):
      return .value(r)
    case .missingMethod:
      break // try other options
    case .error(let e),
        .notCallable(let e):
      return .error(e)
    }

    // If we have '__getitem__' and '__len__' the we can manually create reverse.
    switch PyReversed.has__getitem__(py, object: object) {
    case .value(true):
      break // yay!
    case .value(false):
      let message = "'\(object.typeName)' object is not reversible"
      return .typeError(py, message: message)
    case .error(let e):
      return .error(e)
    }

    let count: Int
    switch py.lengthInt(iterable: object) {
    case let .value(l): count = l
    case let .error(e): return .error(e)
    }

    let result = py.memory.newReversed(type: type, sequence: object, count: count)
    return PyResult(result)
  }

  private static func call__reversed__(_ py: Py, object: PyObject) -> Py.CallMethodResult {
    if let result = PyStaticCall.__reversed__(py, object: object) {
      switch result {
      case let .value(o): return .value(o)
      case let .error(e): return .error(e)
      }
    }

    return py.callMethod(object: object, selector: .__reversed__)
  }

  private static func has__getitem__(_ py: Py, object: PyObject) -> PyResultGen<Bool> {
    return py.hasMethod(object: object, selector: .__getitem__)
  }
}
