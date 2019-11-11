import Core

// TODO: All of the set methods should work for any iterable
// TODO: All of the set methods should have tuple as an arg

// MARK: - Set type

/// Small trick: when we use `Void` (which is the same as `()`) as value
/// then it would not take any space in dictionary!
/// For example `struct { Int, Void }` has the same storage as `struct { Int }`.
/// This trick is sponsored by 'go lang': `map[T]struct{}`.
internal typealias PySetData = OrderedDictionary<PySetElement, ()>

extension OrderedDictionary where Value == Void {
  public mutating func insert(key: Key) {
    self.insert(key: key, value: ())
  }
}

internal protocol PySetType: PyObject {
  var elements: PySetData { get set }
}

extension PySet: PySetType { }
extension PyFrozenSet: PySetType { }

internal struct PySetElement: VioletHashable {

  internal var hash: PyHash
  internal var object: PyObject

  internal init(hash: PyHash, object: PyObject) {
    self.hash = hash
    self.object = object
  }

  internal func isEqual(to other: PySetElement) -> Bool {
    return self.hash == other.hash &&
      self.object.builtins.isEqualBool(left: self.object, right: other.object)
  }
}

internal enum SetHelper {

  // MARK: - Equatable

  internal static func isEqual(left: PySetType, right: PySetType) -> Bool {
    // Equal count + isSubset -> equal
    return left.elements.count == right.elements.count
      && SetHelper.isSubset(left, of: right)
  }

  // MARK: - Comparable

  internal static func isLess(left: PySetType, right: PySetType) -> Bool {
    return left.elements.count < right.elements.count
      && SetHelper.isSubset(left, of: right)
  }

  internal static func isLessEqual(left: PySetType, right: PySetType) -> Bool {
    return SetHelper.isSubset(left, of: right)
  }

  internal static func isGreater(left: PySetType, right: PySetType) -> Bool {
    return left.elements.count > right.elements.count
      && SetHelper.isSuperset(left, of: right)
  }

  internal static func isGreaterEqual(left: PySetType, right: PySetType) -> Bool {
    return SetHelper.isSuperset(left, of: right)
  }

  // MARK: - String

  // sourcery: pymethod = __repr__
  internal static func repr(_ set: PySetType) -> String {
    if set.elements.isEmpty {
      return "()"
    }

    if set.hasReprLock {
      return "(...)"
    }

    return set.withReprLock {
      var result = "\(set.typeName)("
      for (index, element) in set.elements.enumerated() {
        if index > 0 {
          result += ", " // so that we don't have ', )'.
        }

        result += set.context._repr(value: element.key.object)
      }

      result += set.elements.count > 1 ? ")" : ",)"
      return result
    }
  }

  // MARK: - Length

  // sourcery: pymethod = __len__
  internal static func getLength(_ set: PySetType) -> BigInt {
    return BigInt(set.elements.count)
  }

  // MARK: - Contains

  internal static func contains(set: PySetType, element: PyObject) -> PyResult<Bool> {
    let key: PySetElement
    switch SetHelper.createKey(from: element) {
    case let .value(v): key = v
    case let .error(e): return .error(e)
    }

    return .value(set.elements.contains(key: key))
  }

  // MARK: - And

  internal static func and(left: PySetType, right: PySetType) -> PySetData {
    return SetHelper.intersection(left: left, right: right)
  }

  // MARK: - Or

  internal static func or(left: PySetType, right: PySetType) -> PySetData {
    return SetHelper.union(left: left, right: right)
  }

  // MARK: - Xor

  internal static func xor(left: PySetType, right: PySetType) -> PySetData {
    return SetHelper.symmetricDifference(left: left, right: right)
  }

  // MARK: - Sub

  internal static func sub(left: PySetType, right: PySetType) -> PySetData {
    return SetHelper.difference(left: left, right: right)
  }

  // MARK: - Subset

  internal static func isSubset(_ set: PySetType, of other: PySetType) -> Bool {
    guard set.elements.count <= other.elements.count else {
      return false
    }

    for entry in set.elements {
      guard other.elements.contains(key: entry.key) else {
        return false
      }
    }

    return true
  }

  // MARK: - Superset

  internal static func isSuperset(_ set: PySetType, of other: PySetType) -> Bool {
    return SetHelper.isSubset(other, of: set)
  }

  // MARK: - Intersection

  internal static func intersection(left: PySetType, right: PySetType) -> PySetData {
    let isLeftSmaller = left.elements.count < right.elements.count
    let smallerSet = isLeftSmaller ? left : right
    let largerSet = isLeftSmaller ? right : left

    var result = PySetData()
    for entry in smallerSet.elements {
      if largerSet.elements.contains(key: entry.key) {
        result.insert(key: entry.key)
      }
    }

    return result
  }

  // MARK: - Union

  internal static func union(left: PySetType, right: PySetType) -> PySetData {
    let isLeftSmaller = left.elements.count < right.elements.count
    let smallerSet = isLeftSmaller ? left : right
    let largerSet = isLeftSmaller ? right : left

    var result = largerSet.elements
    for entry in smallerSet.elements {
      result.insert(key: entry.key)
    }

    return result
  }

  // MARK: - Difference

  internal static func difference(left: PySetType, right: PySetType) -> PySetData {
    var result = PySetData()
    for entry in left.elements {
      if !right.elements.contains(key: entry.key) {
        result.insert(key: entry.key)
      }
    }

    return result
  }

  // MARK: - Symmetric difference

  internal static func symmetricDifference(left: PySetType,
                                           right: PySetType) -> PySetData {
    var result = PySetData()

    for entry in left.elements {
      if !right.elements.contains(key: entry.key) {
        result.insert(key: entry.key)
      }
    }

    for entry in right.elements {
      if !left.elements.contains(key: entry.key) {
        result.insert(key: entry.key)
      }
    }

    return result
  }

  // MARK: - Is disjoint

  internal static func isDisjoint(left: PySetType, right: PySetType) -> Bool {
    let isLeftSmaller = left.elements.count < right.elements.count
    let smallerSet = isLeftSmaller ? left : right
    let largerSet = isLeftSmaller ? right : left

    for entry in smallerSet.elements {
      if largerSet.elements.contains(key: entry.key) {
        return false
      }
    }

    return true
  }

  // MARK: - Add

  internal static func add(_ set: PySetType, value: PyObject) -> PyErrorEnum? {
    let key: PySetElement
    switch SetHelper.createKey(from: value) {
    case let .value(v): key = v
    case let .error(e): return e
    }

    set.elements.insert(key: key)
    return nil
  }

  // MARK: - Remove

  internal static func remove(_ set: PySetType, value: PyObject) -> PyErrorEnum? {
    let key: PySetElement
    switch SetHelper.createKey(from: value) {
    case let .value(v): key = v
    case let .error(e): return e
    }

    if set.elements.remove(key: key) == nil {
      return .keyErrorForKey(value)
    }

    return nil
  }

  // MARK: - Discard

  internal static func discard(_ set: PySetType, value: PyObject) -> PyErrorEnum? {
    let key: PySetElement
    switch self.createKey(from: value) {
    case let .value(v): key = v
    case let .error(e): return e
    }

    _ = set.elements.remove(key: key)
    return nil
  }

  // MARK: - Helpers

  private static func createKey(from object: PyObject) -> PyResult<PySetElement> {
    switch object.builtins.hash(object) {
    case let .value(hash):
      return .value(PySetElement(hash: hash, object: object))
    case let .error(e):
      return .error(e)
    }
  }
}
