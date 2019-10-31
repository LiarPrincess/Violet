import Core

// MARK: - PyErrorEnum

public enum PyErrorEnum {
  case typeError(String)
  case valueError(String)
  case indexError(String)
  case attributeError(String)
  case zeroDivisionError(String)
  case overflowError(String)
}

// MARK: - PyResult

public enum PyResult<V> {
  case value(V)
  case error(PyErrorEnum)

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
