import Core

// In CPython:
// Objects -> setobject.c
// https://docs.python.org/3.7/c-api/set.html

// swiftlint:disable file_length

// sourcery: pytype = set, default, hasGC, baseType
/// This subtype of PyObject is used to hold the internal data for both set
/// and frozenset objects.
public class PySet: PyObject, PySetType {

  internal static let doc: String = """
    set() -> new empty set object
    set(iterable) -> new set object

    Build an unordered collection of unique elements.
    """

  internal var data: PySetData

  override public var description: String {
    return "PySet(count: \(self.data.count))"
  }

  // MARK: - Init

  override internal convenience init() {
    self.init(data: PySetData())
  }

  internal init(data: PySetData) {
    self.data = data
    super.init(type: Py.types.set)
  }

  /// Use only in `__new__`!
  internal init(type: PyType, data: PySetData) {
    self.data = data
    super.init(type: type)
  }

  // MARK: - Equatable

  // sourcery: pymethod = __eq__
  public func isEqual(_ other: PyObject) -> CompareResult {
    return self.data.isEqual(to: other)
  }

  // sourcery: pymethod = __ne__
  public func isNotEqual(_ other: PyObject) -> CompareResult {
    // CPython has different implementation here,
    // but in the end it all comes down to:
    return self.isEqual(other).not
  }

  // MARK: - Comparable

  // sourcery: pymethod = __lt__
  public func isLess(_ other: PyObject) -> CompareResult {
    return self.data.isLess(than: other)
  }

  // sourcery: pymethod = __le__
  public func isLessEqual(_ other: PyObject) -> CompareResult {
    return self.data.isLessEqual(than: other)
  }

  // sourcery: pymethod = __gt__
  public func isGreater(_ other: PyObject) -> CompareResult {
    return self.data.isGreater(than: other)
  }

  // sourcery: pymethod = __ge__
  public func isGreaterEqual(_ other: PyObject) -> CompareResult {
    return self.data.isGreaterEqual(than: other)
  }

  // MARK: - Hashable

  // sourcery: pymethod = __hash__
  public func hash() -> HashResult {
    return .error(Py.hashNotImplemented(self))
  }

  // MARK: - String

  // sourcery: pymethod = __repr__
  public func repr() -> PyResult<String> {
    if self.hasReprLock {
      return .value("(...)")
    }

    return self.withReprLock {
      self.data.repr(typeName: self.typeName)
    }
  }

  // MARK: - Attributes

  // sourcery: pymethod = __getattribute__
  public func getAttribute(name: PyObject) -> PyResult<PyObject> {
    return AttributeHelper.getAttribute(from: self, name: name)
  }

  public func getAttribute(name: String) -> PyResult<PyObject> {
    return AttributeHelper.getAttribute(from: self, name: name)
  }

  // MARK: - Class

  // sourcery: pyproperty = __class__
  public func getClass() -> PyType {
    return self.type
  }

  // MARK: - Length

  // sourcery: pymethod = __len__
  public func getLength() -> BigInt {
    return BigInt(self.data.count)
  }

  // MARK: - Contaions

  // sourcery: pymethod = __contains__
  public func contains(_ element: PyObject) -> PyResult<Bool> {
    return self.data.contains(value: element)
  }

  // MARK: - And

  // sourcery: pymethod = __and__
  public func and(_ other: PyObject) -> PyResult<PyObject> {
    return self.createSet(result: self.data.and(other: other))
  }

  // sourcery: pymethod = __rand__
  public func rand(_ other: PyObject) -> PyResult<PyObject> {
    return self.and(other)
  }

  // MARK: - Or

  // sourcery: pymethod = __or__
  public func or(_ other: PyObject) -> PyResult<PyObject> {
    return self.createSet(result: self.data.or(other: other))
  }

  // sourcery: pymethod = __ror__
  public func ror(_ other: PyObject) -> PyResult<PyObject> {
    return self.or(other)
  }

  // MARK: - Xor

  // sourcery: pymethod = __xor__
  public func xor(_ other: PyObject) -> PyResult<PyObject> {
    return self.createSet(result: self.data.xor(other: other))
  }

  // sourcery: pymethod = __rxor__
  public func rxor(_ other: PyObject) -> PyResult<PyObject> {
    return self.xor(other)
  }

  // MARK: - Sub

  // sourcery: pymethod = __sub__
  public func sub(_ other: PyObject) -> PyResult<PyObject> {
    return self.createSet(result: self.data.sub(other: other))
  }

  // sourcery: pymethod = __rsub__
  public func rsub(_ other: PyObject) -> PyResult<PyObject> {
    return self.createSet(result: self.data.rsub(other: other))
  }

  // MARK: - Subset

  internal static let isSubsetDoc = """
    Report whether another set contains this set.
    """

  // sourcery: pymethod = issubset, doc = isSubsetDoc
  public func isSubset(of other: PyObject) -> PyResult<Bool> {
    return self.data.isSubset(of: other)
  }

  // MARK: - Superset

  internal static let isSupersetDoc = """
    Report whether this set contains another set.
    """

  // sourcery: pymethod = issuperset, doc = isSupersetDoc
  public func isSuperset(of other: PyObject) -> PyResult<Bool> {
    return self.data.isSuperset(of: other)
  }

  // MARK: - Intersection

  internal static let intersectionDoc = """
    Return the intersection of two sets as a new set.

    (i.e. all elements that are in both sets.)
    """

  // sourcery: pymethod = intersection, doc = intersectionDoc
  public func intersection(with other: PyObject) -> PyResult<PyObject> {
    return self.data.intersection(with: other).map(self.createSet(data:))
  }

  // MARK: - Union

  internal static let unionDoc = """
    Return the union of sets as a new set.

    (i.e. all elements that are in either set.)
    """

  // sourcery: pymethod = union, doc = unionDoc
  public func union(with other: PyObject) -> PyResult<PyObject> {
    return self.data.union(with: other).map(self.createSet(data:))
  }

  // MARK: - Difference

  internal static let differenceDoc = """
    Return the difference of two or more sets as a new set.

    (i.e. all elements that are in this set but not the others.)
    """

  // sourcery: pymethod = difference, doc = differenceDoc
  public func difference(with other: PyObject) -> PyResult<PyObject> {
    return self.data.difference(with: other).map(self.createSet(data:))
  }

  // MARK: - Symmetric difference

  internal static let symmetricDifferenceDoc = """
    Return the symmetric difference of two sets as a new set.

    (i.e. all elements that are in exactly one of the sets.
    """

  // sourcery: pymethod = symmetric_difference, doc = symmetricDifferenceDoc
  public func symmetricDifference(with other: PyObject) -> PyResult<PyObject> {
    return self.data.symmetricDifference(with: other).map(self.createSet(data:))
  }

  // MARK: - Is disjoint

  internal static let isDisjointDoc = """
    Return True if two sets have a null intersection.
    """

  // sourcery: pymethod = isdisjoint, doc = isDisjointDoc
  public func isDisjoint(with other: PyObject) -> PyResult<Bool> {
    return self.data.isDisjoint(with: other)
  }

  // MARK: - Add

  internal static let addDoc = """
    Add an element to a set.

    This has no effect if the element is already present.
    """

  // sourcery: pymethod = add, doc = addDoc
  public func add(_ value: PyObject) -> PyResult<PyNone> {
    switch self.data.insert(value: value) {
    case .ok:
      return .value(Py.none)
    case .error(let e):
      return .error(e)
    }
  }

  // MARK: - Update

  internal static let updateDoc = """
    Update a set with the union of itself and others.
    """

  // sourcery: pymethod = update, doc = updateDoc
  public func update(from other: PyObject) -> PyResult<PyNone> {
    switch self.data.update(from: other) {
    case .ok:
      return .value(Py.none)
    case .error(let e):
      return .error(e)
    }
  }

  // MARK: - Remove

  internal static let removeDoc = """
    Remove an element from a set; it must be a member.

    If the element is not a member, raise a KeyError.
    """

  // sourcery: pymethod = remove, doc = removeDoc
  public func remove(_ value: PyObject) -> PyResult<PyNone> {
    switch self.data.remove(value: value) {
    case .ok:
      return .value(Py.none)
    case .error(let e):
      return .error(e)
    }
  }

  // MARK: - Discard

  internal static let discardDoc = """
    Remove an element from a set if it is a member.

    If the element is not a member, do nothing.
    """

  // sourcery: pymethod = discard, doc = discardDoc
  public func discard(_ value: PyObject) -> PyResult<PyNone> {
    switch self.data.discard(value: value) {
    case .ok:
      return .value(Py.none)
    case .error(let e):
      return .error(e)
    }
  }

  // MARK: - Clear

  internal static let clearDoc = """
    Remove all elements from this set.
    """

  // sourcery: pymethod = clear, doc = clearDoc
  public func clear() -> PyResult<PyNone> {
    self.data.clear()
    return .value(Py.none)
  }

  // MARK: - Copy

  internal static let copyDoc = "Return a shallow copy of a set."

  // sourcery: pymethod = copy, doc = copyDoc
  public func copy() -> PyObject {
    return self.createSet(data: self.data)
  }

  // MARK: - Pop

  internal static let popDoc = """
    Remove and return an arbitrary set element.
    Raises KeyError if the set is empty.
    """

  // sourcery: pymethod = pop, doc = popDoc
  public func pop() -> PyResult<PyObject> {
    return self.data.pop()
  }

  // MARK: - Iter

  // sourcery: pymethod = __iter__
  public func iter() -> PyObject {
    return PySetIterator(set: self)
  }

  // MARK: - Python new

  // sourcery: pymethod = __new__
  internal static func pyNew(type: PyType,
                             args: [PyObject],
                             kwargs: PyDictData?) -> PyResult<PyObject> {
    let isBuiltin = type === Py.types.set
    let alloca = isBuiltin ?
      PySet.init(type:data:) :
      PySetHeap.init(type:data:)

    let data = PySetData()
    return .value(alloca(type, data))
  }

  // MARK: - Python init

  // sourcery: pymethod = __init__
  internal static func pyInit(zelf: PySet,
                              args: [PyObject],
                              kwargs: PyDictData?) -> PyResult<PyNone> {
    if let e = ArgumentParser.noKwargsOrError(fnName: zelf.typeName,
                                              kwargs: kwargs) {
      return .error(e)
    }

    if let e = ArgumentParser.guaranteeArgsCountOrError(fnName: zelf.typeName,
                                                        args: args,
                                                        min: 0,
                                                        max: 1) {
      return .error(e)
    }

    if let iterable = args.first {
      switch zelf.update(from: iterable) {
      case .value: break
      case .error(let e): return .error(e)
      }
    }

    return.value(Py.none)
  }

  // MARK: - Helpers

  private func createSet(result: PySetData.BitOpResult) -> PyResult<PyObject> {
    switch result {
    case .set(let s):
      return .value(self.createSet(data: s))
    case .notImplemented:
      return .value(Py.notImplemented)
    case .error(let e):
      return .error(e)
    }
  }

  private func createSet(data: PySetData) -> PySet {
    return PySet(data: data)
  }
}
