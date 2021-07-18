import VioletCore

// cSpell:ignore enumobject

// In CPython:
// Objects -> enumobject.c

// sourcery: pytype = reversed, default, hasGC, baseType
// sourcery: subclassInstancesHave__dict__
/// Return a reverse iterator over the values of the given sequence.
public class PyReversed: PyObject {

  // sourcery: pytypedoc
  internal static let doc = """
    reversed(sequence, /)
    --

    Return a reverse iterator over the values of the given sequence.
    """

  internal let sequence: PyObject
  internal private(set) var index: Int

  private static let endIndex = -1

  override public var description: String {
    return "PyReversed()"
  }

  // MARK: - Init

  internal convenience init(sequence: PyObject, count: Int) {
    let type = Py.types.reversed
    self.init(type: type, sequence: sequence, count: count)
  }

  internal init(type: PyType, sequence: PyObject, count: Int) {
    self.sequence = sequence
    self.index = count - 1
    super.init(type: type)
  }

  // MARK: - Class

  // sourcery: pyproperty = __class__
  public func getClass() -> PyType {
    return self.type
  }

  // MARK: - Attributes

  // sourcery: pymethod = __getattribute__
  public func getAttribute(name: PyObject) -> PyResult<PyObject> {
    return AttributeHelper.getAttribute(from: self, name: name)
  }

  // MARK: - Iter

  // sourcery: pymethod = __iter__
  public func iter() -> PyObject {
    return self
  }

  // MARK: - Next

  // sourcery: pymethod = __next__
  public func next() -> PyResult<PyObject> {
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
  public func lengthHint() -> PyInt {
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
    case .error(let e), .notCallable(let e):
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
    if let result = Fast.__reversed__(object) {
      return .value(result)
    }

    return Py.callMethod(object: object, selector: .__reversed__)
  }

  private static func has__getitem__(object: PyObject) -> PyResult<Bool> {
    return Py.hasMethod(object: object, selector: .__getitem__)
  }
}
