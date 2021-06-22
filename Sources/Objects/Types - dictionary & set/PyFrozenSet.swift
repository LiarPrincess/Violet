import BigInt
import VioletCore

// swiftlint:disable file_length
// cSpell:ignore setobject

// In CPython:
// Objects -> setobject.c
// https://docs.python.org/3.7/c-api/set.html

// sourcery: pytype = frozenset, default, hasGC, baseType
/// This is an instance of PyTypeObject representing the Python frozenset type.
public class PyFrozenSet: PyObject {

  // MARK: - OrderedSet & Element

  public typealias OrderedSet = PySet.OrderedSet
  public typealias Element = PySet.Element

  // MARK: - Properties

  internal static let doc: String = """
    frozenset() -> empty frozenset object
    frozenset(iterable) -> frozenset object

    Build an immutable unordered collection of unique elements.
    """

  internal let data: PySetData

  override public var description: String {
    return "PyFrozenSet(count: \(self.data.count))"
  }

  // MARK: - Init

  internal init(elements: PyFrozenSet.OrderedSet) {
    self.data = PySetData(elements: elements)
    super.init(type: Py.types.frozenset)
  }

  internal init(type: PyType, elements: PyFrozenSet.OrderedSet) {
    self.data = PySetData(elements: elements)
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
    // This is hash function from 'tuple', which means that 'frozenset'
    // and 'tuple' with the same elements (in the same order) will have
    // the same hash.
    var x: PyHash = 0x34_5678
    var multiplier = Hasher.multiplier

    for element in self.data.elements {
      let y = element.hash
      x = (x ^ y) * multiplier
      multiplier += 82_520 + PyHash(2 * self.data.count)
    }

    return .value(x + 97_531)
  }

  // MARK: - String

  // sourcery: pymethod = __repr__
  public func repr() -> PyResult<String> {
    if self.data.isEmpty {
      return .value(self.typeName + "()")
    }

    if self.hasReprLock {
      return .value(self.typeName + "(...)")
    }

    return self.withReprLock {
      let elements = self.data.joinElementsForRepr()
      return elements.map { "\(typeName)({" + $0 + "})" }
    }
  }

  // MARK: - Attributes

  // sourcery: pymethod = __getattribute__
  public func getAttribute(name: PyObject) -> PyResult<PyObject> {
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

  // MARK: - Contains

  // sourcery: pymethod = __contains__
  public func contains(element: PyObject) -> PyResult<Bool> {
    return self.data.contains(object: element)
  }

  // MARK: - And

  // sourcery: pymethod = __and__
  public func and(_ other: PyObject) -> PyResult<PyObject> {
    let result = self.data.and(other: other)
    return self.createSet(result: result)
  }

  // sourcery: pymethod = __rand__
  public func rand(_ other: PyObject) -> PyResult<PyObject> {
    return self.and(other)
  }

  // MARK: - Or

  // sourcery: pymethod = __or__
  public func or(_ other: PyObject) -> PyResult<PyObject> {
    let result = self.data.or(other: other)
    return self.createSet(result: result)
  }

  // sourcery: pymethod = __ror__
  public func ror(_ other: PyObject) -> PyResult<PyObject> {
    return self.or(other)
  }

  // MARK: - Xor

  // sourcery: pymethod = __xor__
  public func xor(_ other: PyObject) -> PyResult<PyObject> {
    let result = self.data.xor(other: other)
    return self.createSet(result: result)
  }

  // sourcery: pymethod = __rxor__
  public func rxor(_ other: PyObject) -> PyResult<PyObject> {
    return self.xor(other)
  }

  // MARK: - Sub

  // sourcery: pymethod = __sub__
  public func sub(_ other: PyObject) -> PyResult<PyObject> {
    let result = self.data.sub(other: other)
    return self.createSet(result: result)
  }

  // sourcery: pymethod = __rsub__
  public func rsub(_ other: PyObject) -> PyResult<PyObject> {
    let result = self.data.rsub(other: other)
    return self.createSet(result: result)
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
    let result = self.data.intersection(with: other)
    return self.createSet(result: result)
  }

  // MARK: - Union

  internal static let unionDoc = """
    Return the union of sets as a new set.

    (i.e. all elements that are in either set.)
    """

  // sourcery: pymethod = union, doc = unionDoc
  public func union(with other: PyObject) -> PyResult<PyObject> {
    let result = self.data.union(with: other)
    return self.createSet(result: result)
  }

  // MARK: - Difference

  internal static let differenceDoc = """
    Return the difference of two or more sets as a new set.

    (i.e. all elements that are in this set but not the others.)
    """

  // sourcery: pymethod = difference, doc = differenceDoc
  public func difference(with other: PyObject) -> PyResult<PyObject> {
    let result = self.data.difference(with: other)
    return self.createSet(result: result)
  }

  // MARK: - Symmetric difference

  internal static let symmetricDifferenceDoc = """
    Return the symmetric difference of two sets as a new set.

    (i.e. all elements that are in exactly one of the sets.
    """

  // sourcery: pymethod = symmetric_difference, doc = symmetricDifferenceDoc
  public func symmetricDifference(with other: PyObject) -> PyResult<PyObject> {
    let result = self.data.symmetricDifference(with: other)
    return self.createSet(result: result)
  }

  // MARK: - Is disjoint

  internal static let isDisjointDoc = """
    Return True if two sets have a null intersection.
    """

  // sourcery: pymethod = isdisjoint, doc = isDisjointDoc
  public func isDisjoint(with other: PyObject) -> PyResult<Bool> {
    return self.data.isDisjoint(with: other)
  }

  // MARK: - Copy

  internal static let copyDoc = "Return a shallow copy of a set."

  // sourcery: pymethod = copy, doc = copyDoc
  public func copy() -> PyObject {
    return self.createSet(data: self.data)
  }

  // MARK: - Iter

  // sourcery: pymethod = __iter__
  public func iter() -> PyObject {
    return PyMemory.newSetIterator(frozenSet: self)
  }

  // MARK: - Python new

  // sourcery: pystaticmethod = __new__
  internal class func pyNew(type: PyType,
                            args: [PyObject],
                            kwargs: PyDict?) -> PyResult<PyFrozenSet> {
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

    let data: PySetData
    if let iterable = args.first {
      switch PySetData.from(iterable: iterable) {
      case let .value(d): data = d
      case let .error(e): return .error(e)
      }
    } else {
      data = PySetData()
    }

    let elements = data.elements

    let result: PyFrozenSet = isBuiltin ?
      Py.newFrozenSet(elements: elements) :
      PyFrozenSetHeap(type: type, elements: elements)

    return .value(result)
  }

  // MARK: - Helpers

  private func createSet(result: PySetData.BitOperationResult) -> PyResult<PyObject> {
    switch result {
    case .set(let data):
      return .value(self.createSet(data: data))
    case .notImplemented:
      return .value(Py.notImplemented)
    case .error(let e):
      return .error(e)
    }
  }

  private func createSet(result: PyResult<PySetData>) -> PyResult<PyObject> {
    switch result {
    case let .value(data):
      return .value(self.createSet(data: data))
    case let .error(e):
      return .error(e)
    }
  }

  private func createSet(data: PySetData) -> PyFrozenSet {
    return Py.newFrozenSet(elements: data.elements)
  }
}
