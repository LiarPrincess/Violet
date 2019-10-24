/// For types that have `__dict__`.
internal protocol AttributesOwner {
  var attributes: Attributes { get }
}

/// Dictionary used for `__dict__`.
/// Basically a Swift Dictionary, but as a reference type.
public final class Attributes: Equatable {

  private var _values = [String:PyObject]()

  internal var asDictionary: [String: PyObject] {
    return self._values
  }

  public subscript(key: String) -> PyObject? {
    get { return self._values[key] }
    set { self._values[key] = newValue }
  }

  public func has(key: String) -> Bool {
    return self._values[key] != nil
  }

  /// Use this for `__getattribute__` implementation
  public func get(key: String) -> PyObject? {
    return self._values[key]
  }

  /// Use this for `__setattr__` implementation
  public func set(key: String, to value: PyObject) {
    self._values[key] = value
  }

  /// Use this for `__delattr__` implementation
  @discardableResult
  public func del(key: String) -> PyObject? {
    return self._values.removeValue(forKey: key)
  }

  // Technically thats an implementaton detail
  internal typealias KeysType = Dictionary<String, PyObject>.Keys

  internal var keys: KeysType {
    return self._values.keys
  }

  // MARK: - Equatable

  public static func == (lhs: Attributes, rhs: Attributes) -> Bool {
    guard lhs._values.count == rhs._values.count else {
      return false
    }

    for (key, lhsObject) in lhs._values {
      guard let rhsObject = rhs._values[key] else {
        return false
      }

      let context = lhsObject.context
      switch context.isEqual(left: lhsObject, right: rhsObject) {
      case .value(true):
        break // next one please!
      case .value(false),
           .notImplemented,
           .error:
        return false
      }
    }

    return true
  }
}
