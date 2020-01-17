import Core

// In CPython:
// Objects -> enumobject.c

// sourcery: pytype = enumerate, default, hasGC, baseType
/// Return an enumerate object. iterable must be a sequence, an iterator,
/// or some other object which supports iteration.
public class PyEnumerate: PyObject {

  internal static let doc: String = """
    enumerate(iterable, start=0)
    --

    Return an enumerate object.

    iterable
    an object supporting iteration

    The enumerate object yields pairs containing a count (from start, which
    defaults to zero) and a value yielded by the iterable argument.

    enumerate is useful for obtaining an indexed list:
    (0, seq[0]), (1, seq[1]), (2, seq[2]), ...
    """

  /// Secondary iterator of enumeration
  internal let iterator: PyObject
  /// Next used index of enumeration
  internal private(set) var nextIndex: BigInt

  // MARK: - Init

  internal init(iterator: PyObject, startFrom index: BigInt) {
    self.iterator = iterator
    self.nextIndex = index
    super.init(type: iterator.builtins.types.enumerate)
  }

  /// Use only in `__new__`!
  internal init(type: PyType, iterator: PyObject, startFrom index: BigInt) {
    self.iterator = iterator
    self.nextIndex = index
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
    let item: PyObject
    switch self.builtins.next(iterator: self.iterator) {
    case .value(let n):
      item = n
    case .error(let e):
      // This also includes 'StopIteration'
      return .error(e)
    }

    let index = self.builtins.newInt(self.nextIndex)
    let result = self.builtins.newTuple(index, item)

    self.nextIndex += 1
    return .value(result)
  }

  // MARK: - Python new

  private static let newDoc = """
    enumerate(iterable, start=0)
    --

    Return an enumerate object.

      iterable
        an object supporting iteration

    The enumerate object yields pairs containing a count (from start, which
    defaults to zero) and a value yielded by the iterable argument.

    enumerate is useful for obtaining an indexed list:
        (0, seq[0]), (1, seq[1]), (2, seq[2]), ...
    """

  private static let newArguments = ArgumentParser.createOrTrap(
    arguments: ["iterable", "start"],
    format: "O|O:enumerate"
  )

  // sourcery: pymethod = __new__
  internal static func pyNew(type: PyType,
                             args: [PyObject],
                             kwargs: PyDictData?) -> PyResult<PyObject> {
    switch PyEnumerate.newArguments.parse(args: args, kwargs: kwargs) {
    case let .value(bind):
      assert(1 <= bind.count && bind.count <= 2,
             "Invalid argument count returned from parser.")

      let iterable = bind[0]
      let start = bind.count >= 2 ? bind[1] : nil
      return PyEnumerate.pyNew(type: type, iterable: iterable, startFrom: start)

    case let .error(e):
      return .error(e)
    }
  }

  internal static func pyNew(type: PyType,
                             iterable: PyObject,
                             startFrom index: PyObject?) -> PyResult<PyObject> {
    var startIndex = BigInt(0)
    if let index = index {
      switch IndexHelper.bigInt(index) {
      case let .value(i): startIndex = i
      case let .error(e): return .error(e)
      }
    }

    let iter: PyObject
    switch iterable.builtins.iter(from: iterable) {
    case let .value(i): iter = i
    case let .error(e): return .error(e)
    }

    let result = PyEnumerate(type: type, iterator: iter, startFrom: startIndex)
    return .value(result)
  }
}
