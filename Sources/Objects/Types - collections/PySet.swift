import Core

// In CPython:
// Objects -> listobject.c
// https://docs.python.org/3.7/c-api/set.html

// TODO: Frozen set
#warning("This is not a correct implementation, it will fail on collision!")

// swiftlint:disable file_length

/// This subtype of PyObject is used to hold the internal data for both set
/// and frozenset objects.
internal final class PySet: PyObject {

  internal var elements: [PyHash: PyObject]

  internal init(_ context: PyContext, elements: [PyHash:PyObject]) {
    self.elements = elements
    // TOOD: add to context
    super.init()
  }
}

/// This subtype of PyObject is used to hold the internal data for both set
/// and frozenset objects.
internal final class PySetType: PyObject /* ,
  ReprTypeClass,
  ComparableTypeClass, HashableTypeClass,
  SubTypeClass, SubInPlaceTypeClass,
  BinaryTypeClass, BinaryInPlaceTypeClass,
  LengthTypeClass, ContainsTypeClass,
  ClearTypeClass */ {

//  override internal var name: String { return "set" }
//  override internal var doc: String? { return """
//    set() -> new empty set object
//    set(iterable) -> new set object
//
//    Build an unordered collection of unique elements.
//    """
//  }

  // MARK: - Ctor
/*
  // MARK: - Equatable, hashable

  internal func compare(left: PyObject,
                        right: PyObject,
                        mode: CompareMode) throws -> Bool {
    let l = try self.matchType(left)
    let r = try self.matchType(right)

    switch mode {
    case .equal:
      guard l.elements.count == r.elements.count else {
        return false
      }

      let lHash = try self.hash(value: left)
      let rHash = try self.hash(value: right)
      guard lHash == rHash else {
        return false
      }

      return try self.isSubset(set: left, of: right)

    case .notEqual:
      let cmp = try self.compare(left: left, right: right, mode: .equal)
      return !cmp

    case .less:
      guard l.elements.count == r.elements.count else {
        return false
      }
      return try self.isSubset(set: left, of: right)
    case .lessEqual:
      return try self.isSubset(set: left, of: right)

    case .greater:
      guard l.elements.count == r.elements.count else {
        return false
      }
      return try self.isSuperset(set: left, of: right)
    case .greaterEqual:
      return try self.isSuperset(set: left, of: right)
    }
  }

  internal func hash(value: PyObject) throws -> PyHash {
    throw HashableNotImplemented(value: value)
  }

  // MARK: - String

  internal func repr(value: PyObject) throws -> String {
    let v = try self.matchType(value)

    if v.elements.isEmpty {
      return "()"
    }

    if value.hasReprLock {
      return "(...)"
    }

    return try value.withReprLock {
      var result = "\(self.name)("
      for (index, element) in v.elements.enumerated() {
        if index > 0 {
          result += ", " // so that we don't have ', )'.
        }

        result += try self.context.reprString(value: element.value)
      }

      result += v.elements.count > 1 ? ")" : ",)"
      return result
    }
  }

  // MARK: - Items

  internal func add(owner: PyObject, element: PyObject) throws {
    let o = try self.matchType(owner)
    let hash = try self.context.hash(value: element)
    o.elements[hash] = element
  }

  // sourcery: pymethod = __sub__
  internal func sub(left: PyObject, right: PyObject) throws -> PyObject {
    return try self.difference(left: left, right: right)
  }

  // sourcery: pymethod = __isub__
  internal func subInPlace(left: PyObject, right: PyObject) throws {
    let l = try self.matchType(left)
    let diff = try self.difference(left: left, right: right)
    l.elements = diff.elements
  }

  internal func length(value: PyObject) throws -> PyInt {
    let v = try self.matchType(value)
    return self.types.int.new(v.elements.count)
  }

  internal func contains(owner: PyObject, element: PyObject) throws -> Bool {
    let v = try self.matchType(owner)
    let hash = try self.context.hash(value: element)
    return v.elements.contains { h, _ in h == hash }
  }

  internal func clear(value: PyObject) throws {
    let v = try self.matchType(value)
    v.elements.removeAll()
  }

  // MARK: - Subset/superset

  private func isSubset(set: PyObject, of superset: PyObject) throws -> Bool {
    let set = try self.matchType(set)
    let superset = try self.matchType(superset)

    guard superset.elements.count > set.elements.count else {
      return false
    }

    for (hash, _) in set.elements {
      if !superset.elements.contains(hash) {
        return false
      }
    }

    return true
  }

  private func isSuperset(set superset: PyObject, of subset: PyObject) throws -> Bool {
    let superset = try self.matchType(superset)
    let subset = try self.matchType(subset)

    guard superset.elements.count > subset.elements.count else {
      return false
    }

    for (hash, _) in subset.elements {
      if !superset.elements.contains(hash) {
        return false
      }
    }

    return true
  }

  // MARK: - Binary

  internal func and(left: PyObject, right: PyObject) throws -> PyObject {
    return try self.intersection(left: left, right: right)
  }

  internal func andInPlace(left: PyObject, right: PyObject) throws {
    let l = try self.matchType(left)
    let inter = try self.intersection(left: left, right: right)
    l.elements = inter.elements
  }

  internal func or(left: PyObject, right: PyObject) throws -> PyObject {
    return try self.union(left: left, right: right)
  }

  internal func orInPlace(left: PyObject, right: PyObject) throws {
    let l = try self.matchType(left)
    let sum = try self.union(left: left, right: right)
    l.elements = sum.elements
  }

  internal func xor(left: PyObject, right: PyObject) throws -> PyObject {
    return try self.symmetricDifference(left: left, right: right)
  }

  internal func xorInPlace(left: PyObject, right: PyObject) throws {
    let l = try self.matchType(left)
    let diff = try self.symmetricDifference(left: left, right: right)
    l.elements = diff.elements
  }

  // MARK: - Set operations

  /// Returns: `left - right`
  private func difference(left: PyObject, right: PyObject) throws -> PySet {
    let l = try self.matchType(left)
    let r = try self.matchType(right)

    var result = [PyHash: PyObject]()
    for (hash, object) in l.elements {
      if !r.elements.contains(hash) {
        result[hash] = object
      }
    }
    return self.new(elements: result)
  }

  /// Returns: `left ^ right`
  /// (i.e. all elements that are in exactly one of the sets.)
  private func symmetricDifference(left: PyObject, right: PyObject) throws -> PySet {
    let l = try self.matchType(left)
    let r = try self.matchType(right)

    var result = [PyHash: PyObject]()
    for (hash, object) in l.elements {
      if r.elements.contains(hash) {
        result[hash] = object
      }
    }
    return self.new(elements: result)
  }

  /// Returns: `left + right`
  private func union(left: PyObject, right: PyObject) throws -> PySet {
    let l = try self.matchType(left)
    let r = try self.matchType(right)

    var result = l.elements
    for (hash, object) in r.elements {
      if !result.contains(hash) {
        result[hash] = object
      }
    }
    return self.new(elements: result)
  }

  /// Returns: `left & right`
  private func intersection(left: PyObject, right: PyObject) throws -> PySet {
    let l = try self.matchType(left)
    let r = try self.matchType(right)

    var result = [PyHash: PyObject]()
    for (hash, object) in l.elements {
      if r.elements.contains(hash) {
        result[hash] = object
      }
    }
    return self.new(elements: result)
  }

  // MARK: - Helpers

  internal func matchTypeOrNil(_ object: PyObject) -> PySet? {
    if let o = object as? PySet {
      return o
    }

    return nil
  }

  internal func matchType(_ object: PyObject) throws -> PySet {
    if let o = object as? PySet {
      return o
    }

    throw PyContextError.invalidTypeConversion(object: object, to: self)
  }
*/
}