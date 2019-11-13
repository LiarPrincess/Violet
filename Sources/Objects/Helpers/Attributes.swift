/// For types that have `__dict__`.
internal protocol AttributesOwner {
  var _attributes: Attributes { get }
}

/// Dictionary used for `__dict__`.
/// Basically a Swift Dictionary, but as a reference type.
public final class Attributes {

  private var values = [String:PyObject]()

  internal var asDictionary: [String: PyObject] {
    return self.values
  }

  public subscript(key: String) -> PyObject? {
    get { return self.values[key] }
    set { self.values[key] = newValue }
  }

  public func has(key: String) -> Bool {
    return self.values[key] != nil
  }

  /// Use this for `__getattribute__` implementation
  public func get(key: String) -> PyObject? {
    return self.values[key]
  }

  /// Use this for `__setattr__` implementation
  public func set(key: String, to value: PyObject) {
    self.values[key] = value
  }

  /// Use this for `__delattr__` implementation
  @discardableResult
  public func del(key: String) -> PyObject? {
    return self.values.removeValue(forKey: key)
  }

  // Technically thats an implementaton detail
  internal typealias KeysType = Dictionary<String, PyObject>.Keys

  internal var keys: KeysType {
    return self.values.keys
  }

  // MARK: - Equatable

  public func isEqual(to other: Attributes) -> PyResult<Bool> {
    guard self.values.count == other.values.count else {
      return .value(false)
    }

    for (key, lhsObject) in self.values {
      guard let rhsObject = other.values[key] else {
        return .value(false)
      }

      let context = lhsObject.context

      switch context.builtins.isEqualBool(left: lhsObject, right: rhsObject) {
      case .value(true): break // next one please!
      case .value(false): return .value(false)
      case let .error(e): return .error(e)
      }
    }

    return .value(true)
  }
}
