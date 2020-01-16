import Core

// In CPython:
// Objects -> tupleobject.c
// https://docs.python.org/3.7/c-api/tuple.html

// sourcery: pytype = tuple, default, hasGC, baseType, tupleSubclass
/// This instance of PyTypeObject represents the Python tuple type;
/// it is the same object as tuple in the Python layer.
public class PyTuple: PyObject, PySequenceType {

  internal static let doc: String = """
    tuple() -> an empty tuple
    tuple(sequence) -> tuple initialized from sequence's items

    If the argument is a tuple, the return value is the same object.
    """

  internal let data: PySequenceData

  internal var elements: [PyObject] {
    return self.data.elements
  }

  // MARK: - Init

  convenience init(elements: [PyObject]) {
    let data = PySequenceData(elements: elements)
    self.init(data: data)
  }

  internal init(data: PySequenceData) {
    self.data = data
    super.init(type: Py.types.tuple)
  }

  // MARK: - Equatable

  // sourcery: pymethod = __eq__
  internal func isEqual(_ other: PyObject) -> CompareResult {
    guard let other = other as? PyTuple else {
      return .notImplemented
    }

    return self.data.isEqual(to: other.data).asCompareResult
  }

  // sourcery: pymethod = __ne__
  internal func isNotEqual(_ other: PyObject) -> CompareResult {
    return self.isEqual(other).not
  }

  // MARK: - Comparable

  // sourcery: pymethod = __lt__
  internal func isLess(_ other: PyObject) -> CompareResult {
    guard let other = other as? PyTuple else {
      return .notImplemented
    }

    return self.data.isLess(than: other.data).asCompareResult
  }

  // sourcery: pymethod = __le__
  internal func isLessEqual(_ other: PyObject) -> CompareResult {
    guard let other = other as? PyTuple else {
      return .notImplemented
    }

    return self.data.isLessEqual(than: other.data).asCompareResult
  }

  // sourcery: pymethod = __gt__
  internal func isGreater(_ other: PyObject) -> CompareResult {
    guard let other = other as? PyTuple else {
      return .notImplemented
    }

    return self.data.isGreater(than: other.data).asCompareResult
  }

  // sourcery: pymethod = __ge__
  internal func isGreaterEqual(_ other: PyObject) -> CompareResult {
    guard let other = other as? PyTuple else {
      return .notImplemented
    }

    return self.data.isGreaterEqual(than: other.data).asCompareResult
  }

  // MARK: - Hashable

  // sourcery: pymethod = __hash__
  internal func hash() -> HashResult {
    return self.data.hash.asHashResult
  }

  // MARK: - String

  // sourcery: pymethod = __repr__
  internal func repr() -> PyResult<String> {
    // While not mutable, it is still possible to end up with a cycle in a tuple
    // through an object that stores itself within a tuple (and thus infinitely
    // asks for the repr of itself).
    if self.hasReprLock {
      return .value("(...)")
    }

    return self.withReprLock {
      self.data.repr(openBrace: "(", closeBrace: ")")
    }
  }

  // MARK: - Attributes

  // sourcery: pymethod = __getattribute__
  internal func getAttribute(name: PyObject) -> PyResult<PyObject> {
    return AttributeHelper.getAttribute(from: self, name: name)
  }

  // MARK: - Class

  // sourcery: pyproperty = __class__
  internal func getClass() -> PyType {
    return self.type
  }

  // MARK: - Length

  // sourcery: pymethod = __len__
  internal func getLength() -> BigInt {
    return BigInt(self.data.count)
  }

  // MARK: - Contains

  // sourcery: pymethod = __contains__
  internal func contains(_ element: PyObject) -> PyResult<Bool> {
    return self.data.contains(value: element)
  }

  // MARK: - Get item

  // sourcery: pymethod = __getitem__
  internal func getItem(at index: PyObject) -> PyResult<PyObject> {
    switch self.data.getItem(index: index, typeName: "tuple") {
    case let .single(s): return .value(s)
    case let .slice(s): return .value(self.builtins.newTuple(s))
    case let .error(e): return .error(e)
    }
  }

  // MARK: - Count

  // sourcery: pymethod = count
  internal func count(_ element: PyObject) -> PyResult<BigInt> {
    return self.data.count(element: element).map(BigInt.init)
  }

  // MARK: - Index of

  // Special overload for `IndexOwner` protocol
  internal func index(of element: PyObject) -> PyResult<BigInt> {
    return self.index(of: element, start: nil, end: nil)
  }

  // sourcery: pymethod = index
  internal func index(of element: PyObject,
                      start: PyObject?,
                      end: PyObject?) -> PyResult<BigInt> {
    return self.data.index(of: element,
                           start: start,
                           end: end,
                           typeName: "tuple")
      .map(BigInt.init)
  }

  // MARK: - Iter

  // sourcery: pymethod = __iter__
  internal func iter() -> PyObject {
    return PyTupleIterator(tuple: self)
  }

  // MARK: - Add

  // sourcery: pymethod = __add__
  internal func add(_ other: PyObject) -> PyResult<PyObject> {
    if self.data.isEmpty {
      return .value(other)
    }

    guard let otherTuple = other as? PyTuple else {
      let msg = "can only concatenate tuple (not '\(other.typeName)') to tuple"
      return .typeError(msg)
    }

    if otherTuple.data.isEmpty {
      return .value(self)
    }

    let result = self.data.add(other: otherTuple.data)
    return .value(self.builtins.newTuple(result))
  }

  // MARK: - Mul

  // sourcery: pymethod = __mul__
  internal func mul(_ other: PyObject) -> PyResult<PyObject> {
    return self.mulResult(self.data.mul(count: other))
  }

  // sourcery: pymethod = __rmul__
  internal func rmul(_ other: PyObject) -> PyResult<PyObject> {
    return self.mulResult(self.data.rmul(count: other))
  }

  private func mulResult(_ result: PySequenceData.MulResult) -> PyResult<PyObject> {
    switch result {
    case .value(let elements):
      return .value(self.builtins.newTuple(elements))
    case .error(let e):
      return .error(e)
    case .notImplemented:
      return .value(self.builtins.notImplemented)
    }
  }

  // MARK: - Python new

  // sourcery: pymethod = __new__
  internal static func pyNew(type: PyType,
                             args: [PyObject],
                             kwargs: PyDictData?) -> PyResult<PyObject> {
    if let e = ArgumentParser.noKwargsOrError(fnName: "tuple", kwargs: kwargs) {
      return .error(e)
    }

    if let e = ArgumentParser.guaranteeArgsCountOrError(fnName: "tuple",
                                                        args: args,
                                                        min: 0,
                                                        max: 1) {
      return .error(e)
    }

    let isBuiltin = type === type.builtins.list
    let alloca = isBuiltin ?
      PyList.init(type:data:) :
      PyListHeap.init(type:data:)

    return PyTuple.getSequenceData(args: args).map { alloca(type, $0) }
  }

  private static func getSequenceData(args: [PyObject]) -> PyResult<PySequenceData> {
    // swiftlint:disable:next empty_count
    assert(args.count == 0 || args.count == 1)

    guard let iterable = args.first else {
      return .value(PySequenceData())
    }

    let builtins = iterable.builtins
    return builtins.toArray(iterable: iterable)
      .map(PySequenceData.init(elements:))
  }
}
