import Core

// TODO: All of the set methods should work for any iterable
// TODO: All of the set methods should have tuple as an arg

// swiftlint:disable file_length

internal protocol PySetType: PyObject {
  var elements: PySetData { get set }
}

extension PySet: PySetType { }
extension PyFrozenSet: PySetType { }

internal enum SetHelper {

  // MARK: - Equatable

  internal static func isEqual(left: PySetType,
                               right: PySetType) -> PyResult<Bool> {
    // Equal count + isSubset -> equal
    guard left.elements.count == right.elements.count else {
      return .value(false)
    }

    switch SetHelper.isSubset(left, of: right) {
    case let .value(b): return .value(b)
    case let .error(e): return .error(e)
    }
  }

  // MARK: - Comparable

  internal static func isLess(left: PySetType,
                              right: PySetType) -> PyResult<Bool> {
    guard left.elements.count < right.elements.count else {
      return .value(false)
    }

    switch SetHelper.isSubset(left, of: right) {
    case let .value(b): return .value(b)
    case let .error(e): return .error(e)
    }
  }

  internal static func isLessEqual(left: PySetType,
                                   right: PySetType) -> PyResult<Bool> {
    switch SetHelper.isSubset(left, of: right) {
    case let .value(b): return .value(b)
    case let .error(e): return .error(e)
    }
  }

  internal static func isGreater(left: PySetType,
                                 right: PySetType) -> PyResult<Bool> {
    guard left.elements.count > right.elements.count else {
      return .value(false)
    }

    switch SetHelper.isSuperset(left, of: right) {
    case let .value(b): return .value(b)
    case let .error(e): return .error(e)
    }
  }

  internal static func isGreaterEqual(left: PySetType,
                                      right: PySetType) -> PyResult<Bool> {
    switch SetHelper.isSuperset(left, of: right) {
    case let .value(b): return .value(b)
    case let .error(e): return .error(e)
    }
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

  internal static func contains(_ set: PySetType,
                                element: PyObject) -> PyResult<Bool> {
    let key: PySetElement
    switch SetHelper.createKey(from: element) {
    case let .value(v): key = v
    case let .error(e): return .error(e)
    }

    switch set.elements.contains(key: key) {
    case let .value(b): return .value(b)
    case let .error(e): return .error(e)
    }
  }

  // MARK: - And

  internal static func and(left: PySetType,
                           right: PySetType) -> PyResult<PySetData> {
    return SetHelper.intersection(left: left, right: right)
  }

  // MARK: - Or

  internal static func or(left: PySetType,
                          right: PySetType) -> PyResult<PySetData> {
    return SetHelper.union(left: left, right: right)
  }

  // MARK: - Xor

  internal static func xor(left: PySetType,
                           right: PySetType) -> PyResult<PySetData> {
    return SetHelper.symmetricDifference(left: left, right: right)
  }

  // MARK: - Sub

  internal static func sub(left: PySetType,
                           right: PySetType) -> PyResult<PySetData> {
    return SetHelper.difference(left: left, right: right)
  }

  // MARK: - Subset

  internal static func isSubset(_ set: PySetType,
                                of other: PySetType) -> PyResult<Bool> {
    guard set.elements.count <= other.elements.count else {
      return .value(false)
    }

    for entry in set.elements {
      switch other.elements.contains(key: entry.key) {
      case .value(true): break // try next
      case .value(false): return .value(false)
      case .error(let e): return .error(e)
      }
    }

    return .value(true)
  }

  // MARK: - Superset

  internal static func isSuperset(_ set: PySetType,
                                  of other: PySetType) -> PyResult<Bool> {
    return SetHelper.isSubset(other, of: set)
  }

  // MARK: - Intersection

  internal static func intersection(left: PySetType,
                                    right: PySetType) -> PyResult<PySetData> {
    let isLeftSmaller = left.elements.count < right.elements.count
    let smallerSet = isLeftSmaller ? left : right
    let largerSet = isLeftSmaller ? right : left

    var result = PySetData()
    for entry in smallerSet.elements {
      switch largerSet.elements.contains(key: entry.key) {
      case .value(true):
        switch result.insert(key: entry.key) {
        case .inserted, .updated: break
        case .error(let e): return .error(e)
        }
      case .value(false): break
      case .error(let e): return .error(e)
      }
    }

    return .value(result)
  }

  // MARK: - Union

  internal static func union(left: PySetType,
                             right: PySetType) -> PyResult<PySetData> {
    let isLeftSmaller = left.elements.count < right.elements.count
    let smallerSet = isLeftSmaller ? left : right
    let largerSet = isLeftSmaller ? right : left

    var result = largerSet.elements
    for entry in smallerSet.elements {
      switch result.insert(key: entry.key) {
      case .inserted, .updated: break
      case .error(let e): return .error(e)
      }
    }

    return .value(result)
  }

  // MARK: - Difference

  internal static func difference(left: PySetType,
                                  right: PySetType) -> PyResult<PySetData> {
    var result = PySetData()
    for entry in left.elements {
      switch right.elements.contains(key: entry.key) {
      case .value(true):
        break
      case .value(false):
        switch result.insert(key: entry.key) {
        case .inserted, .updated: break
        case .error(let e): return .error(e)
        }
      case .error(let e):
        return .error(e)
      }
    }

    return .value(result)
  }

  // MARK: - Symmetric difference

  internal static func symmetricDifference(left: PySetType,
                                           right: PySetType) -> PyResult<PySetData> {
    var result = PySetData()

    for entry in left.elements {
      switch right.elements.contains(key: entry.key) {
      case .value(true):
        break
      case .value(false):
        switch result.insert(key: entry.key) {
        case .inserted, .updated: break
        case .error(let e): return .error(e)
        }
      case .error(let e):
        return .error(e)
      }
    }

    for entry in right.elements {
      switch left.elements.contains(key: entry.key) {
      case .value(true):
        break
      case .value(false):
        switch result.insert(key: entry.key) {
        case .inserted, .updated: break
        case .error(let e): return .error(e)
        }
      case .error(let e):
        return .error(e)
      }
    }

    return .value(result)
  }

  // MARK: - Is disjoint

  internal static func isDisjoint(left: PySetType,
                                  right: PySetType) -> PyResult<Bool> {
    let isLeftSmaller = left.elements.count < right.elements.count
    let smallerSet = isLeftSmaller ? left : right
    let largerSet = isLeftSmaller ? right : left

    for entry in smallerSet.elements {
      switch largerSet.elements.contains(key: entry.key) {
      case .value(true): return .value(false)
      case .value(false) : break
      case .error(let e): return .error(e)
      }
    }

    return .value(true)
  }

  // MARK: - Add

  internal static func add(_ set: PySetType, value: PyObject) -> PyErrorEnum? {
    let key: PySetElement
    switch SetHelper.createKey(from: value) {
    case let .value(v): key = v
    case let .error(e): return e
    }

    switch set.elements.insert(key: key) {
    case .inserted, .updated: return nil
    case .error(let e): return e
    }
  }

  // MARK: - Remove

  internal static func remove(_ set: PySetType, value: PyObject) -> PyErrorEnum? {
    let key: PySetElement
    switch SetHelper.createKey(from: value) {
    case let .value(v): key = v
    case let .error(e): return e
    }

    switch set.elements.remove(key: key) {
    case .value: return nil
    case .notFound: return .keyErrorForKey(value)
    case .error(let e): return e
    }
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
