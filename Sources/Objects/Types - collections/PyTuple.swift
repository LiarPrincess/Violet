import BigInt
import VioletCore

// cSpell:ignore tupleobject

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

  public var elements: [PyObject] {
    return self.data.elements
  }

  override public var description: String {
    return "PyTuple(count: \(self.elements.count))"
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

  /// Use only in `__new__`!
  internal init(type: PyType, data: PySequenceData) {
    self.data = data
    super.init(type: type)
  }

  // MARK: - Equatable

  // sourcery: pymethod = __eq__
  internal func isEqual(_ other: PyObject) -> CompareResult {
    return self.compare(with: other) { $0.isEqual(to: $1) }
  }

  // sourcery: pymethod = __ne__
  internal func isNotEqual(_ other: PyObject) -> CompareResult {
    return self.isEqual(other).not
  }

  // MARK: - Comparable

  // sourcery: pymethod = __lt__
  internal func isLess(_ other: PyObject) -> CompareResult {
    return self.compare(with: other) { $0.isLess(than: $1) }
  }

  // sourcery: pymethod = __le__
  internal func isLessEqual(_ other: PyObject) -> CompareResult {
    return self.compare(with: other) { $0.isLessEqual(than: $1) }
  }

  // sourcery: pymethod = __gt__
  internal func isGreater(_ other: PyObject) -> CompareResult {
    return self.compare(with: other) { $0.isGreater(than: $1) }
  }

  // sourcery: pymethod = __ge__
  internal func isGreaterEqual(_ other: PyObject) -> CompareResult {
    return self.compare(with: other) { $0.isGreaterEqual(than: $1) }
  }

  private func compare(
    with other: PyObject,
    using compareFn: (PySequenceData, PySequenceData) -> CompareResult
  ) -> CompareResult {
    guard let other = PyCast.asTuple(other) else {
      return .notImplemented
    }

    return compareFn(self.data, other.data)
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
      self.data.repr(openBracket: "(",
                     closeBracket: ")",
                     appendCommaIfSingleElement: true)
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
  internal func contains(element: PyObject) -> PyResult<Bool> {
    return self.data.contains(value: element)
  }

  // MARK: - Get item

  // sourcery: pymethod = __getitem__
  internal func getItem(index: PyObject) -> PyResult<PyObject> {
    switch self.data.getItem(index: index) {
    case let .single(s): return .value(s)
    case let .slice(s): return .value(Py.newTuple(s))
    case let .error(e): return .error(e)
    }
  }

  // MARK: - Count

  // sourcery: pymethod = count
  internal func count(element: PyObject) -> PyResult<BigInt> {
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

    guard let otherTuple = PyCast.asTuple(other) else {
      let msg = "can only concatenate tuple (not '\(other.typeName)') to tuple"
      return .typeError(msg)
    }

    if otherTuple.data.isEmpty {
      return .value(self)
    }

    let result = self.data.add(other: otherTuple.data)
    return .value(Py.newTuple(result))
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
      return .value(Py.newTuple(elements))
    case .error(let e):
      return .error(e)
    case .notImplemented:
      return .value(Py.notImplemented)
    }
  }

  // MARK: - Check exact

  public func checkExact() -> Bool {
    return self.type === Py.types.tuple
  }

  // MARK: - Python new

  // sourcery: pystaticmethod = __new__
  internal static func pyNew(type: PyType,
                             args: [PyObject],
                             kwargs: PyDict?) -> PyResult<PyTuple> {
    if let e = ArgumentParser.noKwargsOrError(fnName: "tuple", kwargs: kwargs) {
      return .error(e)
    }

    if let e = ArgumentParser.guaranteeArgsCountOrError(fnName: "tuple",
                                                        args: args,
                                                        min: 0,
                                                        max: 1) {
      return .error(e)
    }

    let isBuiltin = type === Py.types.tuple
    let alloca = isBuiltin ?
      PyTuple.newTuple(type:data:) :
      PyTupleHeap.init(type:data:)

    return PyTuple.getSequenceData(args: args).map { alloca(type, $0) }
  }

  /// Allocate new PyType (it will use 'builtins' cache if possible).
  private static func newTuple(type: PyType, data: PySequenceData) -> PyTuple {
    assert(type === Py.types.tuple, "Only for builtin tuple (not subclass!)")
    return Py.newTuple(data)
  }

  private static func getSequenceData(args: [PyObject]) -> PyResult<PySequenceData> {
    // swiftlint:disable:next empty_count
    assert(args.count == 0 || args.count == 1)

    guard let iterable = args.first else {
      return .value(PySequenceData())
    }

    return Py.toArray(iterable: iterable)
      .map(PySequenceData.init(elements:))
  }
}
