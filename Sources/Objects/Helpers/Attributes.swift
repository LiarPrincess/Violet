// MARK: - Attributes

// It has to be a class because it needs to be shared between multiple entities:
// >>> class C(): pass
// >>> c = C()        <-- 'c' has reference to its own '__dict__'
// >>> d = c.__dict__ <-- save dict reference
// >>> c.a = 1        <-- add attribute
// >>> d
// {'a': 1} <-- attribute is present in dict

/// Dictionary used for `__dict__`.
public final class Attributes {

  internal typealias DataType = OrderedDictionary<String, PyObject>

  private lazy var data = DataType()

  // MARK: - Subscript

  public subscript(key: String) -> PyObject? {
    get { return self.get(key: key) }
    set {
      if let v = newValue {
        self.set(key: key, to: v)
      } else {
        _ = self.del(key: key)
      }
    }
  }

  // MARK: - Has

  public func has(key: String) -> Bool {
    switch self.data.contains(key: key) {
    case let .value(b):
      return b
    case let .error(e):
      self.errorNotHandled(operation: "has", error: e)
    }
  }

  // MARK: - Get

  /// Use this for `__getattribute__` implementation
  public func get(key: String) -> PyObject? {
    switch self.data.get(key: key) {
    case .value(let v):
      return v
    case .notFound:
      return nil
    case .error(let e):
      self.errorNotHandled(operation: "get", error: e)
    }
  }

  // MARK: - Set

  /// Use this for `__setattr__` implementation
  public func set(key: String, to value: PyObject) {
    switch self.data.insert(key: key, value: value) {
    case .inserted,
         .updated:
      break
    case .error(let e):
      self.errorNotHandled(operation: "set", error: e)
    }
  }

  // MARK: - Del

  /// Use this for `__delattr__` implementation
  @discardableResult
  public func del(key: String) -> PyObject? {
    switch self.data.remove(key: key) {
    case .value(let v):
      return v
    case .notFound:
      return nil
    case .error(let e):
      self.errorNotHandled(operation: "delete", error: e)
    }
  }

  // swiftlint:disable unavailable_function
  /// Errors can happen when the value is not-hashable.
  /// Strings are always hashable, so we don't expect errors.
  private func errorNotHandled(operation: String, error: PyErrorEnum) -> Never {
    // swiftlint:enable unavailable_function
    let msg = "Attribute dictionary '\(operation)' operation returned an error: \(error)"
    fatalError(msg)
  }

  // MARK: - Clear

  public func clear() {
    self.data.clear()
  }

  // MARK: - Update

  public func update(values: [String:PyObject]) {
    for (key, value) in values {
      self.set(key: key, to: value)
    }
  }

  // MARK: - Keys, values, entries

  public var keys: [String] {
    return self.data.map { $0.key }
  }

  public var values: [PyObject] {
    return self.data.map { $0.value }
  }

  internal var entries: AnySequence<DataType.Entry> {
    return AnySequence(self.data.makeIterator)
  }

  // MARK: - Is equal

  public func isEqual(to other: Attributes) -> PyResult<Bool> {
    guard self.data.count == other.data.count else {
      return .value(false)
    }

    for entry in self.data {
      let key = entry.key
      let lhs = entry.value

      let rhs: PyObject
      switch other.data.get(key: key) {
      case .value(let o): rhs = o
      case .notFound: return .value(false)
      case .error(let e): return .error(e)
      }

      switch lhs.builtins.isEqualBool(left: lhs, right: rhs) {
      case .value(true): break // Go to next entry
      case .value(false): return .value(false)
      case .error(let e): return .error(e)
      }
    }

    return .value(true)
  }
}

// MARK: - String + PyHashable

extension String: PyHashable {

  internal func isEqual(to other: String) -> PyResult<Bool> {
    var selfIter = self.unicodeScalars.makeIterator()
    var otherIter = other.unicodeScalars.makeIterator()

    var selfValue = selfIter.next()
    var otherValue = otherIter.next()

    while let s = selfValue, let o = otherValue {
      if s != o {
        return .value(false)
      }

      selfValue = selfIter.next()
      otherValue = otherIter.next()
    }

    // One (or both) of the values is nil (which means that we arrived to end)
    let isSelfEnd = selfValue == nil
    let isOtherEnd = otherValue == nil
    let isCountEqual = isSelfEnd && isOtherEnd
    return .value(isCountEqual)
  }
}
