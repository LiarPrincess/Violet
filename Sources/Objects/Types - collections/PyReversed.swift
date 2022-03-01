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

  // Layout will be automatically generated, from `Ptr` fields.
  // Just remember to initialize them in `initialize`!
  internal static let layout = PyMemory.PyReversedLayout()

  private static let endIndex = -1

  internal var sequencePtr: Ptr<PyObject> { self.ptr[Self.layout.sequenceOffset] }
  internal var indexPtr: Ptr<Int> { self.ptr[Self.layout.indexOffset] }

  internal var sequence: PyObject { self.sequencePtr.pointee }
  internal var index: Int { self.indexPtr.pointee }

  public let ptr: RawPtr

  public init(ptr: RawPtr) {
    self.ptr = ptr
  }

  internal func initialize(type: PyType,
                           sequence: PyObject,
                           count: Int) {
    self.header.initialize(type: type)
    self.sequencePtr.initialize(to: sequence)
    self.indexPtr.initialize(to: count - 1)
  }

  // Nothing to do here.
  internal func beforeDeinitialize() { }

  internal static func createDebugString(ptr: RawPtr) -> String {
    let zelf = PyReversed(ptr: ptr)
    return "PyReversed(type: \(zelf.typeName), flags: \(zelf.flags))"
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
    if self.index != PyReversed.endIndex {
      switch Py.getItem(object: self.sequence, index: self.index) {
      case .value(let o):
        self.index -= 1
        return .value(o)

      case .error(let e):
        if PyCast.isIndexError(e) || PyCast.isStopIteration(e) {
          break
        }

        return .error(e)
      }
    }

    self.index = PyReversed.endIndex
    return .stopIteration()
  }

  // MARK: - Length hint

  // sourcery: pymethod = __length_hint__
  internal func lengthHint() -> PyInt {
    // '+1' because users start counting from 1, not from 0
    return Py.newInt(self.index + 1)
  }

  // MARK: - Python new

  // sourcery: pystaticmethod = __new__
  internal static func pyNew(type: PyType,
                             args: [PyObject],
                             kwargs: PyDict?) -> PyResult<PyObject> {
    if let e = ArgumentParser.noKwargsOrError(fnName: "reversed", kwargs: kwargs) {
      return .error(e)
    }

    if let e = ArgumentParser.guaranteeArgsCountOrError(fnName: "reversed",
                                                        args: args,
                                                        min: 1,
                                                        max: 1) {
      return .error(e)
    }

    return PyReversed.pyNew(type: type, object: args[0])
  }

  private static func pyNew(type: PyType,
                            object: PyObject) -> PyResult<PyObject> {
    // If we have dedicated '__reversed__' then we will use it
    switch PyReversed.call__reversed__(object: object) {
    case .value(let r):
      return .value(r)
    case .missingMethod:
      break // try other options
    case .error(let e),
         .notCallable(let e):
      return .error(e)
    }

    // If we have '__getitem__' and '__len__' the we can manually create reverse.
    switch PyReversed.has__getitem__(object: object) {
    case .value(true):
      break // yay!
    case .value(false):
      return .typeError("'\(object.typeName)' object is not reversible")
    case .error(let e):
      return .error(e)
    }

    let count: Int
    switch Py.lenInt(iterable: object) {
    case let .value(l): count = l
    case let .error(e): return .error(e)
    }

    let result = PyMemory.newReversed(type: type, sequence: object, count: count)
    return .value(result)
  }

  private static func call__reversed__(object: PyObject) -> PyInstance.CallMethodResult {
    if let result = PyStaticCall.__reversed__(object) {
      return .value(result)
    }

    return Py.callMethod(object: object, selector: .__reversed__)
  }

  private static func has__getitem__(object: PyObject) -> PyResult<Bool> {
    return Py.hasMethod(object: object, selector: .__getitem__)
  }
}

*/
