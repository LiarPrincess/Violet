/* MARKER
// TODO: All of the set methods should allow tuple as an arg

// MARK: - Element

// swiftlint:disable:next type_name
internal struct AbstractSet_Element: PyHashable, CustomStringConvertible {

  internal let hash: PyHash
  internal let object: PyObject

  internal var description: String {
    return "PySetElement(hash: \(self.hash), object: \(self.object))"
  }

  internal init(hash: PyHash, object: PyObject) {
    self.hash = hash
    self.object = object
  }

  internal func isEqual(to other: AbstractSet_Element) -> PyResult<Bool> {
    guard self.hash == other.hash else {
      return .value(false)
    }

    return Py.isEqualBool(left: self.object, right: other.object)
  }
}

// MARK: - AbstractSet

/// Mixin with `set/frozenset` methods.
///
/// All of the methods/properties should be prefixed with `_`.
/// DO NOT use them outside of the `set/frozenset` objects!
internal protocol AbstractSet: PyObject {

  /// Main requirement.
  var elements: OrderedSet { get }

  /// Create new Python object with specified elements.
  ///
  /// DO NOT USE! This is a part of `AbstractSet` implementation.
  static func _toSelf(elements: OrderedSet) -> Self
}

extension AbstractSet {

  internal typealias Element = AbstractSet_Element
  internal typealias OrderedSet = VioletObjects.OrderedSet<AbstractSet_Element>

  /// DO NOT USE! This is a part of `AbstractSet` implementation.
  internal var _isEmpty: Bool {
    return self.elements.isEmpty
  }

  /// DO NOT USE! This is a part of `AbstractSet` implementation.
  internal var _count: Int {
    return self.elements.count
  }

  // MARK: - Get elements

  /// DO NOT USE! This is a part of `AbstractSet` implementation.
  internal static func _getElements(iterable: PyObject) -> PyResult<OrderedSet> {
    // Fast path for sets (since they already have hashed elements)
    if let set = PyCast.asExactlyAnySet(iterable) {
      return .value(set.elements)
    }

    // Fast path for dictionaries (same reason as above)
    if let dict = PyCast.asExactlyDict(iterable) {
      // Init with 'count', so that we don't have to resize later
      var result = OrderedSet(count: dict.elements.count)

      for entry in dict.elements {
        let key = entry.key
        let element = Element(hash: key.hash, object: key.object)

        switch result.insert(element: element) {
        case .inserted,
             .updated:
          break // go to next element
        case .error(let e):
          return .error(e)
        }
      }

      return .value(result)
    }

    var result = OrderedSet()
    let reduceError = Py.reduce(iterable: iterable, into: &result) { acc, object in
      switch self._createElement(from: object) {
      case let .value(e):
        switch acc.insert(element: e) {
        case .inserted,
             .updated:
          return .goToNextElement
        case .error(let e):
          return .error(e)
        }
      case let .error(e):
        return .error(e)
      }
    }

    if let e = reduceError {
      return .error(e)
    }

    return .value(result)
  }

  // MARK: - Create element

  /// DO NOT USE! This is a part of `AbstractSet` implementation.
  internal static func _createElement(from object: PyObject) -> PyResult<Element> {
    switch Py.hash(object: object) {
    case let .value(hash):
      return .value(Element(hash: hash, object: object))
    case let .error(e):
      return .error(e)
    }
  }
}

*/