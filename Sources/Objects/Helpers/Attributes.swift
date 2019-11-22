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

/// Dictionary used for `__dict__`.
public final class Attributes {

  internal typealias DataType = OrderedDictionary<String, PyObject>

  private var _values = DataType()

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

  // MARK: - Basic operations

  public func has(key: String) -> Bool {
    switch self._values.contains(key: key) {
    case let .value(b):
      return b
    case let .error(e):
      self.errorNotHandled(operation: "has", error: e)
    }
  }

  /// Use this for `__getattribute__` implementation
  public func get(key: String) -> PyObject? {
    switch self._values.get(key: key) {
    case .value(let v):
      return v
    case .notFound:
      return nil
    case .error(let e):
      self.errorNotHandled(operation: "get", error: e)
    }
  }

  /// Use this for `__setattr__` implementation
  public func set(key: String, to value: PyObject) {
    switch self._values.insert(key: key, value: value) {
    case .inserted,
         .updated:
      break
    case .error(let e):
      self.errorNotHandled(operation: "set", error: e)
    }
  }

  /// Use this for `__delattr__` implementation
  @discardableResult
  public func del(key: String) -> PyObject? {
    switch self._values.remove(key: key) {
    case .value(let v):
      return v
    case .notFound:
      return nil
    case .error(let e):
      self.errorNotHandled(operation: "delete", error: e)
    }
  }

  private func errorNotHandled(operation: String, error: PyErrorEnum) -> Never {
    fatalError(
      "Attribute dictionary '\(operation)' operation returned an error: \(error)"
    )
  }

  // MARK: - Keys, entries

  public var keys: [String] {
    return self._values.map { $0.key }
  }

  public var values: [PyObject] {
    return self._values.map { $0.value }
  }

  internal var entries: AnySequence<DataType.Entry> {
    return AnySequence(self._values.makeIterator)
  }

  // MARK: - Equatable

  public func isEqual(to other: Attributes) -> PyResult<Bool> {
    guard self._values.count == other._values.count else {
      return .value(false)
    }

    for entry in self._values {
      let key = entry.key
      let lhs = entry.value

      let rhs: PyObject
      switch other._values.get(key: key) {
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
