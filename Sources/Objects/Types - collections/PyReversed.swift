import Core

// In CPython:
// Objects -> enumobject.c

// sourcery: pytype = reversed, default, hasGC, baseType
/// Return a reverse iterator over the values of the given sequence.
internal class PyReversed: PyObject {

  internal static let doc: String = """
    reversed(sequence, /)
    --

    Return a reverse iterator over the values of the given sequence.
    """

  internal let sequence: PyObject
  internal private(set) var index: Int

  private static let endIndex = -1

  // MARK: - Init

  internal convenience init(sequence: PyObject, sequenceCount: Int) {
    let type = sequence.builtins.types.reversed
    self.init(type: type, sequence: sequence, sequenceCount: sequenceCount)
  }

  /// Use only in `__new__`!
  internal init(type: PyType, sequence: PyObject, sequenceCount: Int) {
    self.sequence = sequence
    self.index = sequenceCount - 1
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
    if self.index >= 0 {
      switch self.builtins.getItem(self.sequence, at: self.index) {
      case .value(let o):
        self.index -= 1
        return .value(o)
      case .error(.indexError),
           .error(.stopIteration):
        break
      case .error(let e):
        return .error(e)
      }
    }

    self.index = PyReversed.endIndex
    return .stopIteration
  }

  // MARK: - Python new

  // sourcery: pymethod = __new__
  internal static func pyNew(type: PyType,
                             args: [PyObject],
                             kwargs: PyDictData?) -> PyResult<PyObject> {
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
    let reverse: PyObject
    switch PyReversed.call__reversed__(on: object) {
    case .value(let r):
      reverse = r
    case .notImplemented:
      return .typeError("'\(object.typeName)' object is not reversible")
    case .error(let e):
      return .error(e)
    }

    let count: Int
    switch reverse.builtins.lengthInt(iterable: reverse) {
    case let .value(l): count = l
    case let .error(e): return .error(e)
    }

    let isBuiltin = type === type.builtins.reversed
    let alloca = isBuiltin ?
      PyReversed.init(type:sequence:sequenceCount:) :
      PyReversedHeap.init(type:sequence:sequenceCount:)

    let result = alloca(type, reverse, count)
    return .value(result)
  }

  private static func call__reversed__(on object: PyObject) -> PyResultOrNot<PyObject> {
    if let owner = object as? __reversed__Owner {
      return .value(owner.reversed())
    }

    let builtins = object.builtins
    switch builtins.callMethod(on: object, selector: "__reversed__") {
    case .value(let o):
      return .value(o)
    case .missingMethod:
      return .notImplemented
    case .error(let e), .notCallable(let e):
      return .error(e)
    }
  }
}
