import Core

// In CPython:
// Objects -> setobject.c
// https://docs.python.org/3.7/c-api/set.html

// swiftlint:disable file_length

// sourcery: pytype = frozenset, default, hasGC, baseType
/// This is an instance of PyTypeObject representing the Python frozenset type.
public class PyFrozenSet: PyObject, PySetType {

  internal static let doc: String = """
    frozenset() -> empty frozenset object
    frozenset(iterable) -> frozenset object

    Build an immutable unordered collection of unique elements.
    """

  internal var data: PySetData

  override public var description: String {
    return "PyFrozenSet(count: \(self.data.count))"
  }

  // MARK: - Init

  override internal convenience init() {
    self.init(data: PySetData())
  }

  internal init(data: PySetData) {
    self.data = data
    super.init(type: Py.types.frozenset)
  }

  /// Use only in `__new__`!
  internal init(type: PyType, data: PySetData) {
    self.data = data
    super.init(type: type)
  }

  // MARK: - Equatable

  // sourcery: pymethod = __eq__
  internal func isEqual(_ other: PyObject) -> CompareResult {
    guard let other = other as? PySetType else {
      return .notImplemented
    }

    return self.data.isEqual(to: other.data)
  }

  // sourcery: pymethod = __ne__
  internal func isNotEqual(_ other: PyObject) -> CompareResult {
    // CPython has different implementation here,
    // but in the end it all comes down to:
    return self.isEqual(other).not
  }

  // MARK: - Comparable

  // sourcery: pymethod = __lt__
  internal func isLess(_ other: PyObject) -> CompareResult {
    guard let other = other as? PySetType else {
      return .notImplemented
    }

    return self.data.isLess(than: other.data)
  }

  // sourcery: pymethod = __le__
  internal func isLessEqual(_ other: PyObject) -> CompareResult {
    guard let other = other as? PySetType else {
      return .notImplemented
    }

    return self.data.isLessEqual(than: other.data)
  }

  // sourcery: pymethod = __gt__
  internal func isGreater(_ other: PyObject) -> CompareResult {
    guard let other = other as? PySetType else {
      return .notImplemented
    }

    return self.data.isGreater(than: other.data)
  }

  // sourcery: pymethod = __ge__
  internal func isGreaterEqual(_ other: PyObject) -> CompareResult {
    guard let other = other as? PySetType else {
      return .notImplemented
    }

    return self.data.isGreaterEqual(than: other.data)
  }

  // MARK: - Hashable

  // sourcery: pymethod = __hash__
  internal func hash() -> HashResult {
    // This is hash function from 'tuple', which means that 'frozenset'
    // and 'tuple' with the same elements (in the same order) will have
    // the same hash.
    var x: PyHash = 0x345678
    var mult = Hasher.multiplier

    for entry in self.data.dict {
      let y = entry.key.hash
      x = (x ^ y) * mult
      mult += 82_520 + PyHash(2 * self.data.count)
    }

    return .value(x + 97_531)
  }

  // MARK: - String

  // sourcery: pymethod = __repr__
  internal func repr() -> PyResult<String> {
    if self.hasReprLock {
      return .value("(...)")
    }

    return self.withReprLock {
      self.data.repr(typeName: self.typeName)
    }
  }

  // MARK: - Attributes

  // sourcery: pymethod = __getattribute__
  internal func getAttribute(name: PyObject) -> PyResult<PyObject> {
    return AttributeHelper.getAttribute(from: self, name: name)
  }

  internal func getAttribute(name: String) -> PyResult<PyObject> {
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

  // MARK: - Contaions

  // sourcery: pymethod = __contains__
  internal func contains(_ element: PyObject) -> PyResult<Bool> {
    return self.data.contains(value: element)
  }

  // MARK: - And

  // sourcery: pymethod = __and__
  internal func and(_ other: PyObject) -> PyResult<PyObject> {
    guard let otherSet = other as? PySetType else {
      return .value(Py.notImplemented)
    }

    return self.data.and(other: otherSet.data)
      .map(self.createSet(data:))
  }

  // sourcery: pymethod = __rand__
  internal func rand(_ other: PyObject) -> PyResult<PyObject> {
    return self.and(other)
  }

  // MARK: - Or

  // sourcery: pymethod = __or__
  internal func or(_ other: PyObject) -> PyResult<PyObject> {
    guard let otherSet = other as? PySetType else {
      return .value(Py.notImplemented)
    }

    return self.data.or(other: otherSet.data)
      .map(self.createSet(data:))
  }

  // sourcery: pymethod = __ror__
  internal func ror(_ other: PyObject) -> PyResult<PyObject> {
    return self.or(other)
  }

  // MARK: - Xor

  // sourcery: pymethod = __xor__
  internal func xor(_ other: PyObject) -> PyResult<PyObject> {
    guard let otherSet = other as? PySetType else {
      return .value(Py.notImplemented)
    }

    return self.data.xor(other: otherSet.data)
      .map(self.createSet(data:))
  }

  // sourcery: pymethod = __rxor__
  internal func rxor(_ other: PyObject) -> PyResult<PyObject> {
    return self.xor(other)
  }

  // MARK: - Sub

  // sourcery: pymethod = __sub__
  internal func sub(_ other: PyObject) -> PyResult<PyObject> {
    guard let otherSet = other as? PySetType else {
      return .value(Py.notImplemented)
    }

    return self.data.difference(with: otherSet.data)
      .map(self.createSet(data:))
  }

  // sourcery: pymethod = __rsub__
  internal func rsub(_ other: PyObject) -> PyResult<PyObject> {
    guard let otherSet = other as? PySetType else {
      return .value(Py.notImplemented)
    }

    return otherSet.data.difference(with: self.data)
      .map(self.createSet(data:))
  }

  // MARK: - Subset

  internal static let isSubsetDoc = """
    Report whether another set contains this set.
    """

  // sourcery: pymethod = issubset, doc = isSubsetDoc
  internal func isSubset(of other: PyObject) -> PyResult<Bool> {
    guard let otherSet = other as? PySetType else {
      return .typeError("'\(other.typeName)' object is not iterable")
    }

    return self.data.isSubset(of: otherSet.data)
  }

  // MARK: - Superset

  internal static let isSupersetDoc = """
    Report whether this set contains another set.
    """

  // sourcery: pymethod = issuperset, doc = isSupersetDoc
  internal func isSuperset(of other: PyObject) -> PyResult<Bool> {
    guard let otherSet = other as? PySetType else {
      return .typeError("'\(other.typeName)' object is not iterable")
    }

    return self.data.isSuperset(of: otherSet.data)
  }

  // MARK: - Intersection

  internal static let intersectionDoc = """
    Return the intersection of two sets as a new set.

    (i.e. all elements that are in both sets.)
    """

  // sourcery: pymethod = intersection, doc = intersectionDoc
  internal func intersection(with other: PyObject) -> PyResult<PyObject> {
    guard let otherSet = other as? PySetType else {
      return .typeError("'\(other.typeName)' object is not iterable")
    }

    return self.data.intersection(with: otherSet.data)
      .map(self.createSet(data:))
  }

  // MARK: - Union

  internal static let unionDoc = """
    Return the union of sets as a new set.

    (i.e. all elements that are in either set.)
    """

  // sourcery: pymethod = union, doc = unionDoc
  internal func union(with other: PyObject) -> PyResult<PyObject> {
    guard let otherSet = other as? PySetType else {
      return .typeError("'\(other.typeName)' object is not iterable")
    }

    return self.data.union(with: otherSet.data)
      .map(self.createSet(data:))
  }

  // MARK: - Difference

  internal static let differenceDoc = """
    Return the difference of two or more sets as a new set.

    (i.e. all elements that are in this set but not the others.)
    """

  // sourcery: pymethod = difference, doc = differenceDoc
  internal func difference(with other: PyObject) -> PyResult<PyObject> {
    guard let otherSet = other as? PySetType else {
      return .typeError("'\(other.typeName)' object is not iterable")
    }

    return self.data.difference(with: otherSet.data)
      .map(self.createSet(data:))
  }

  // MARK: - Symmetric difference

  internal static let symmetricDifferenceDoc = """
    Return the symmetric difference of two sets as a new set.

    (i.e. all elements that are in exactly one of the sets.
    """

  // sourcery: pymethod = symmetric_difference, doc = symmetricDifferenceDoc
  internal func symmetricDifference(with other: PyObject) -> PyResult<PyObject> {
    guard let otherSet = other as? PySetType else {
      return .typeError("'\(other.typeName)' object is not iterable")
    }

    return self.data.symmetricDifference(with: otherSet.data)
      .map(self.createSet(data:))
  }

  // MARK: - Is disjoint

  internal static let isDisjointDoc = """
    Return True if two sets have a null intersection.
    """

  // sourcery: pymethod = isdisjoint, doc = isDisjointDoc
  internal func isDisjoint(with other: PyObject) -> PyResult<Bool> {
    guard let otherSet = other as? PySetType else {
      return .typeError("'\(other.typeName)' object is not iterable")
    }

    return self.data.isDisjoint(with: otherSet.data)
  }

  // MARK: - Copy

  internal static let copyDoc = "Return a shallow copy of a set."

  // sourcery: pymethod = copy, doc = copyDoc
  internal func copy() -> PyObject {
    return self.createSet(data: self.data)
  }

  // MARK: - Iter

  // sourcery: pymethod = __iter__
  internal func iter() -> PyObject {
    return PySetIterator(set: self)
  }

  // MARK: - Python new

  // sourcery: pymethod = __new__
  internal class func pyNew(type: PyType,
                            args: [PyObject],
                            kwargs: PyDictData?) -> PyResult<PyObject> {
    let isBuiltin = type === Py.types.frozenset
    if isBuiltin {
      if let e = ArgumentParser.noKwargsOrError(fnName: "frozenset",
                                                kwargs: kwargs) {
        return .error(e)
      }
    }

    // Guarantee 0 or 1 args
    if let e = ArgumentParser.guaranteeArgsCountOrError(fnName: "frozenset",
                                                        args: args,
                                                        min: 0,
                                                        max: 1) {
      return .error(e)
    }

    var dataOrNil: PySetData?
    if let iterable = args.first {
      switch PyFrozenSet.data(fromIterable: iterable) {
      case let .value(d): dataOrNil = d
      case let .error(e): return .error(e)
      }
    }

    let alloca = isBuiltin ?
      PyFrozenSet.newSet(type:data:) :
      PyFrozenSetHeap.init(type:data:)

    let result = alloca(type, dataOrNil ?? PySetData())
    return .value(result)
  }

  private static func newSet(type: PyType, data: PySetData) -> PyFrozenSet {
    return Py.newFrozenSet(data)
  }

  private static func data(fromIterable iterable: PyObject) -> PyResult<PySetData> {
    if let set = iterable as? PySetType {
      return .value(set.data)
    }

    switch Py.toArray(iterable: iterable) {
    case let .value(array):
      var data = PySetData()

      for object in array {
        switch data.insert(value: object) {
        case .ok: break
        case .error(let e): return .error(e)
        }
      }

      return .value(data)

    case let .error(e):
      return .error(e)
    }
  }

  // MARK: - Helpers

  private func createSet(data: PySetData) -> PyFrozenSet {
    return PyFrozenSet(data: data)
  }
}
