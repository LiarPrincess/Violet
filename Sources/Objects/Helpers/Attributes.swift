/// Dictionary used for `__dict__`.
/// Basically a Swift Dictionary, but as a reference type.
public final class Attributes {

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

  public var keys: [String] {
    return Array(self._values.keys)
  }
}
