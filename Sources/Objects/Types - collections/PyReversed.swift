import Core

// In CPython:
// Objects -> enumobject.c

// sourcery: pytype = reversed, default, hasGC, baseType
/// Return a reverse iterator over the values of the given sequence.
public class PyReversed: PyObject {

  internal static let doc: String = """
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
    self.init(type: Py.types.reversed, sequence: sequence, count: count)
  }

  /// Use only in `__new__`!
  internal init(type: PyType, sequence: PyObject, count: Int) {
    self.sequence = sequence
    self.index = count - 1
    super.init(type: type)
  }

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
      switch Py.getItem(self.sequence, at: self.index) {
      case .value(let o):
        self.index -= 1
        return .value(o)

      case .error(let e):
        if e.isIndexError || e.isStopIteration {
          break
        }

        return .error(e)
      }
    }

    self.index = PyReversed.endIndex
    return .stopIteration()
  }

  // MARK: - Python new

  // sourcery: pymethod = __new__
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
    switch PyReversed.call__reversed__(on: object) {
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

    let isBuiltin = type === Py.types.reversed
    let alloca = isBuiltin ?
      PyReversed.init(type:sequence:count:) :
      PyReversedHeap.init(type:sequence:count:)

    let result = alloca(type, object, count)
    return .value(result)
  }

  private static func call__reversed__(on object: PyObject) -> CallMethodResult {
    if let owner = object as? __reversed__Owner {
      return .value(owner.reversed())
    }

    return Py.callMethod(object: object, selector: .__reversed__)
  }

  private static func has__getitem__(object: PyObject) -> PyResult<Bool> {
    if object is __getitem__Owner {
      return .value(true)
    }

    return Py.hasMethod(object: object, selector: .__getitem__)
  }
}
