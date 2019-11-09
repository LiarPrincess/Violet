import Core

// MARK: - PyErrorEnum

public enum PyErrorEnum {
  case typeError(String)
  case valueError(String)
  case indexError(String)
  case attributeError(String)
  case zeroDivisionError(String)
  case overflowError(String)
  case keyError(hash: PyHash, key: PyObject)
}

// MARK: - PyResult

public enum PyResult<V> {
  case value(V)
  case error(PyErrorEnum)

  internal static func typeError(_ msg: String) -> PyResult<V> {
    return PyResult.error(.typeError(msg))
  }

  internal static func valueError(_ msg: String) -> PyResult<V> {
    return PyResult.error(.valueError(msg))
  }

  internal static func indexError(_ msg: String) -> PyResult<V> {
    return PyResult.error(.indexError(msg))
  }

  internal static func attributeError(_ msg: String) -> PyResult<V> {
    return PyResult.error(.attributeError(msg))
  }

  internal static func zeroDivisionError(_ msg: String) -> PyResult<V> {
    return PyResult.error(.zeroDivisionError(msg))
  }

  internal static func overflowError(_ msg: String) -> PyResult<V> {
    return PyResult.error(.overflowError(msg))
  }

  internal static func keyError(hash: PyHash, key: PyObject) -> PyResult<V> {
    return PyResult.error(.keyError(hash: hash, key: key))
  }

  public func map<A>(_ f: (V) -> A) -> PyResult<A> {
    switch self {
    case let .value(v):
      return .value(f(v))
    case let .error(e):
      return .error(e)
    }
  }

  public func flatMap<A>(_ f: (V) -> PyResult<A>) -> PyResult<A> {
    switch self {
    case let .value(v):
      return f(v)
    case let .error(e):
      return .error(e)
    }
  }

  public func mapError(_ f: (PyErrorEnum) -> PyErrorEnum) -> PyResult<V> {
    switch self {
    case let .value(v):
      return .value(v)
    case let .error(e):
      return .error(f(e))
    }
  }
}

extension PyResult where V == Void {
  public static func value() -> PyResult {
    return PyResult.value(())
  }
}

// MARK: - PyResultOrNot

/// Basically `PyResult` + notImplemented.
///
/// This is really good name or really bad name, depending on how you see it.
public enum PyResultOrNot<V> {
  case value(V)
  case error(PyErrorEnum)
  case notImplemented

  public var isNotImplemented: Bool {
    switch self {
    case .notImplemented:
      return true
    case .value, .error:
      return false
    }
  }

  internal static func typeError(_ msg: String) -> PyResultOrNot<V> {
    return PyResultOrNot.error(.typeError(msg))
  }

  internal static func valueError(_ msg: String) -> PyResultOrNot<V> {
    return PyResultOrNot.error(.valueError(msg))
  }

  internal static func indexError(_ msg: String) -> PyResultOrNot<V> {
    return PyResultOrNot.error(.indexError(msg))
  }

  internal static func attributeError(_ msg: String) -> PyResultOrNot<V> {
    return PyResultOrNot.error(.attributeError(msg))
  }

  internal static func zeroDivisionError(_ msg: String) -> PyResultOrNot<V> {
    return PyResultOrNot.error(.zeroDivisionError(msg))
  }

  internal static func overflowError(_ msg: String) -> PyResultOrNot<V> {
    return PyResultOrNot.error(.overflowError(msg))
  }

  internal static func keyError(hash: PyHash, key: PyObject) -> PyResultOrNot<V> {
    return PyResultOrNot.error(.keyError(hash: hash, key: key))
  }

  public func map<A>(_ f: (V) -> A) -> PyResultOrNot<A> {
    switch self {
    case let .value(v):
      return .value(f(v))
    case let .error(e):
      return .error(e)
    case .notImplemented:
      return .notImplemented
    }
  }

  public func flatMap<A>(_ f: (V) -> PyResultOrNot<A>) -> PyResultOrNot<A> {
    switch self {
    case let .value(v):
      return f(v)
    case let .error(e):
      return .error(e)
    case .notImplemented:
      return .notImplemented
    }
  }

  public func mapError(_ f: (PyErrorEnum) -> PyErrorEnum) -> PyResultOrNot<V> {
    switch self {
    case let .value(v):
      return .value(v)
    case let .error(e):
      return .error(f(e))
    case .notImplemented:
      return .notImplemented
    }
  }
}

extension PyResultOrNot where V == Void {
  public static func value() -> PyResultOrNot {
    return PyResultOrNot.value(())
  }
}

// MARK: - Optional transformer

extension Optional {
  public func map<V, A>(_ f: (V) -> A) -> PyResult<A>?
    where Wrapped == PyResult<V> {

      switch self {
      case let .some(result):
        return result.map(f)
      case .none:
        return .none
      }
  }

  public func flatMap<V, A>(_ f: (V) -> PyResult<A>) -> PyResult<A>?
    where Wrapped == PyResult<V> {

      switch self {
      case let .some(result):
        return result.flatMap(f)
      case .none:
        return .none
      }
  }

  public func map<V, A>(_ f: (V) -> A) -> PyResultOrNot<A>?
    where Wrapped == PyResultOrNot<V> {

      switch self {
      case let .some(result):
        return result.map(f)
      case .none:
        return .none
      }
  }

  public func flatMap<V, A>(_ f: (V) -> PyResultOrNot<A>) -> PyResultOrNot<A>?
    where Wrapped == PyResultOrNot<V> {

      switch self {
      case let .some(result):
        return result.flatMap(f)
      case .none:
        return .none
      }
  }
}
