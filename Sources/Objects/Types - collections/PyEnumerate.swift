import BigInt
import VioletCore

// cSpell:ignore enumobject

// In CPython:
// Objects -> enumobject.c

// sourcery: pytype = enumerate, default, hasGC, baseType
// sourcery: subclassInstancesHave__dict__
/// Return an enumerate object. iterable must be a sequence, an iterator,
/// or some other object which supports iteration.
public final class PyEnumerate: PyObject {

  // sourcery: pytypedoc
  internal static let doc = """
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

  override public var description: String {
    return "PyEnumerate()"
  }

  // MARK: - Init

  internal convenience init(iterator: PyObject, startFrom index: BigInt) {
    let type = Py.types.enumerate
    self.init(type: type, iterator: iterator, startFrom: index)
  }

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
    switch Py.next(iterator: self.iterator) {
    case .value(let n):
      item = n
    case .error(let e):
      // This also includes 'StopIteration'
      return .error(e)
    }

    let index = Py.newInt(self.nextIndex)
    let result = Py.newTuple(index, item)

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

  // sourcery: pystaticmethod = __new__
  internal static func pyNew(type: PyType,
                             args: [PyObject],
                             kwargs: PyDict?) -> PyResult<PyEnumerate> {
    switch PyEnumerate.newArguments.bind(args: args, kwargs: kwargs) {
    case let .value(binding):
      assert(binding.requiredCount == 1, "Invalid required argument count.")
      assert(binding.optionalCount == 1, "Invalid optional argument count.")

      let iterable = binding.required(at: 0)
      let start = binding.optional(at: 1)
      return PyEnumerate.pyNew(type: type, iterable: iterable, startFrom: start)

    case let .error(e):
      return .error(e)
    }
  }

  internal static func pyNew(type: PyType,
                             iterable: PyObject,
                             startFrom index: PyObject?) -> PyResult<PyEnumerate> {
    var startIndex = BigInt(0)
    if let index = index {
      switch IndexHelper.bigInt(index) {
      case let .value(i):
        startIndex = i
      case let .error(e),
           let .notIndex(e):
        return .error(e)
      }
    }

    let iter: PyObject
    switch Py.iter(object: iterable) {
    case let .value(i): iter = i
    case let .error(e): return .error(e)
    }

    let result = PyMemory.newEnumerate(type: type,
                                       iterator: iter,
                                       startFrom: startIndex)
    return .value(result)
  }
}
