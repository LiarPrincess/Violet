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

  // MARK: - Init

  internal init(_ context: PyContext) {
    self.data = PySetData()
    super.init(type: context.builtins.types.set)
  }

  internal init(_ context: PyContext, data: PySetData) {
    self.data = data
    super.init(type: context.builtins.types.set)
  }

  /// Use only in `__new__`!
  internal init(type: PyType, data: PySetData) {
    self.data = data
    super.init(type: type)
  }

  // MARK: - Equatable

  // sourcery: pymethod = __eq__
  internal func isEqual(_ other: PyObject) -> PyResultOrNot<Bool> {
    guard let other = other as? PySetType else {
      return .notImplemented
    }

    return self.data.isEqual(to: other.data).asResultOrNot
  }

  // sourcery: pymethod = __ne__
  internal func isNotEqual(_ other: PyObject) -> PyResultOrNot<Bool> {
    // CPython has different implementation here,
    // but in the end it all comes down to:
    return NotEqualHelper.fromIsEqual(self.isEqual(other))
  }

  // MARK: - Comparable

  // sourcery: pymethod = __lt__
  internal func isLess(_ other: PyObject) -> PyResultOrNot<Bool> {
    guard let other = other as? PySetType else {
      return .notImplemented
    }

    return self.data.isLess(than: other.data).asResultOrNot
  }

  // sourcery: pymethod = __le__
  internal func isLessEqual(_ other: PyObject) -> PyResultOrNot<Bool> {
    guard let other = other as? PySetType else {
      return .notImplemented
    }

    return self.data.isLessEqual(than: other.data).asResultOrNot
  }

  // sourcery: pymethod = __gt__
  internal func isGreater(_ other: PyObject) -> PyResultOrNot<Bool> {
    guard let other = other as? PySetType else {
      return .notImplemented
    }

    return self.data.isGreater(than: other.data).asResultOrNot
  }

  // sourcery: pymethod = __ge__
  internal func isGreaterEqual(_ other: PyObject) -> PyResultOrNot<Bool> {
    guard let other = other as? PySetType else {
      return .notImplemented
    }

    return self.data.isGreaterEqual(than: other.data).asResultOrNot
  }

  // MARK: - Hashable

  // sourcery: pymethod = __hash__
  internal func hash() -> PyResultOrNot<PyHash> {
    return .error(self.builtins.hashNotImplemented(self))
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
      return .value(self.builtins.notImplemented)
    }

    return self.data.and(other: otherSet.data).map(self.createSet(data:))
  }

  // sourcery: pymethod = __rand__
  internal func rand(_ other: PyObject) -> PyResult<PyObject> {
    return self.and(other)
  }

  // MARK: - Or

  // sourcery: pymethod = __or__
  internal func or(_ other: PyObject) -> PyResult<PyObject> {
    guard let otherSet = other as? PySetType else {
      return .value(self.builtins.notImplemented)
    }

    return self.data.or(other: otherSet.data).map(self.createSet(data:))
  }

  // sourcery: pymethod = __ror__
  internal func ror(_ other: PyObject) -> PyResult<PyObject> {
    return self.or(other)
  }

  // MARK: - Xor

  // sourcery: pymethod = __xor__
  internal func xor(_ other: PyObject) -> PyResult<PyObject> {
    guard let otherSet = other as? PySetType else {
      return .value(self.builtins.notImplemented)
    }

    return self.data.xor(other: otherSet.data).map(self.createSet(data:))
  }

  // sourcery: pymethod = __rxor__
  internal func rxor(_ other: PyObject) -> PyResult<PyObject> {
    return self.xor(other)
  }

  // MARK: - Sub

  // sourcery: pymethod = __sub__
  internal func sub(_ other: PyObject) -> PyResult<PyObject> {
    guard let otherSet = other as? PySetType else {
      return .value(self.builtins.notImplemented)
    }

    return self.data.difference(with: otherSet.data).map(self.createSet(data:))
  }

  // sourcery: pymethod = __rsub__
  internal func rsub(_ other: PyObject) -> PyResult<PyObject> {
    guard let otherSet = other as? PySetType else {
      return .value(self.builtins.notImplemented)
    }

    return otherSet.data.difference(with: self.data).map(self.createSet(data:))
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

  // MARK: - Add

  internal static let addDoc = """
    Add an element to a set.

    This has no effect if the element is already present.
    """

  // sourcery: pymethod = add, doc = addDoc
  internal func add(_ value: PyObject) -> PyResult<PyNone> {
    switch self.data.insert(value: value) {
    case .ok:
      return .value(self.builtins.none)
    case .error(let e):
      return .error(e)
    }
  }

  // MARK: - Update

  internal static let updateDoc = """
    Update a set with the union of itself and others.
    """

  // sourcery: pymethod = update, doc = updateDoc
  internal func update(from other: PyObject) -> PyResult<PyNone> {
    switch self.data.update(from: other) {
    case .ok:
      return .value(self.builtins.none)
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
  internal func remove(_ value: PyObject) -> PyResult<PyNone> {
    switch self.data.remove(value: value) {
    case .ok:
      return .value(self.builtins.none)
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
  internal func discard(_ value: PyObject) -> PyResult<PyNone> {
    switch self.data.discard(value: value) {
    case .ok:
      return .value(self.builtins.none)
    case .error(let e):
      return .error(e)
    }
  }

  // MARK: - Clear

  internal static let clearDoc = """
    Remove all elements from this set.
    """

  // sourcery: pymethod = clear, doc = clearDoc
  internal func clear() -> PyResult<PyNone> {
    self.data.clear()
    return .value(self.builtins.none)
  }

  // MARK: - Copy

  internal static let copyDoc = "Return a shallow copy of a set."

  // sourcery: pymethod = copy, doc = copyDoc
  internal func copy() -> PyObject {
    return self.createSet(data: self.data)
  }

  // MARK: - Pop

  internal static let popDoc = """
    Remove and return an arbitrary set element.
    Raises KeyError if the set is empty.
    """

  // sourcery: pymethod = pop, doc = popDoc
  internal func pop() -> PyResult<PyObject> {
    guard let lastElement = self.data.dict.last else {
      return .keyError("pop from an empty set")
    }

    _ = self.data.remove(element: lastElement.key)
    return .value(lastElement.key.object)
  }

  // MARK: - Iter

  // sourcery: pymethod = __iter__
  internal func iter() -> PyObject {
    return PySetIterator(set: self)
  }

  // MARK: - Python new

  // sourcery: pymethod = __new__
  internal static func pyNew(type: PyType,
                             args: [PyObject],
                             kwargs: PyDictData?) -> PyResult<PyObject> {
    let isBuiltin = type === type.builtins.set
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

    return.value(zelf.builtins.none)
  }

  // MARK: - Helpers

  private func createSet(data: PySetData) -> PySet {
    return PySet(self.context, data: data)
  }
}
