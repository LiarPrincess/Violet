// TODO: All of the set methods should allow tuple as an arg

/// Mixin with `set/frozenset` methods.
///
/// DO NOT use them outside of the `set/frozenset` objects!
internal protocol AbstractSet: PyObjectMixin {

  /// Name of the type in Python.
  ///
  /// Used mainly in error messages.
  static var pythonTypeName: String { get }

  /// Main requirement.
  var elements: OrderedSet { get }

  /// Create new Python object with specified elements.
  static func newObject(_ py: Py, elements: OrderedSet) -> Self

  /// Convert `object` to this type.
  ///
  /// - For `set` it should return `set`.
  /// - For `frozenset` it should return `frozenset`.
  static func downcast(_ py: Py, _ object: PyObject) -> Self?
}

extension AbstractSet {

  internal typealias OrderedSet = VioletObjects.OrderedSet
  internal typealias Element = OrderedSet.Element

  internal var isEmpty: Bool {
    return self.elements.isEmpty
  }

  internal var count: Int {
    return self.elements.count
  }

  // MARK: - Get elements

  internal static func getElements(_ py: Py, iterable: PyObject) -> PyResultGen<OrderedSet> {
    // Fast path for sets (since they already have hashed elements)
    if let set = py.cast.asExactlyAnySet(iterable) {
      return .value(set.elements)
    }

    // Fast path for dictionaries (same reason as above)
    if let dict = py.cast.asExactlyDict(iterable) {
      // Init with 'count', so that we don't have to resize later
      var result = OrderedSet(count: dict.elements.count)

      for entry in dict.elements {
        let key = entry.key
        let element = Element(hash: key.hash, object: key.object)

        switch result.insert(py, element: element) {
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
    let reduceError = py.reduce(iterable: iterable, into: &result) { acc, object in
      switch self.createElement(py, object: object) {
      case let .value(e):
        switch acc.insert(py, element: e) {
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

  internal static func createElement(_ py: Py, object: PyObject) -> PyResultGen<Element> {
    switch py.hash(object: object) {
    case let .value(hash):
      let element = Element(hash: hash, object: object)
      return .value(element)
    case let .error(e):
      return .error(e)
    }
  }

  // MARK: - Helpers

  internal static func invalidZelfArgument(_ py: Py,
                                           _ object: PyObject,
                                           _ fnName: String) -> PyResult {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}
