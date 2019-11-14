import Core

// MARK: - PyErrorEnum

public enum PyErrorEnum {
  case typeError(String)
  case valueError(String)
  case indexError(String)
  case attributeError(String)
  case zeroDivisionError(String)
  case overflowError(String)
  case systemError(String)
  case nameError(String)
  case keyError(String)
  case keyErrorForKey(PyObject)
}

// MARK: - PyResult

public enum PyResult<V> {
  case value(V)
  case error(PyErrorEnum)

  public static func typeError(_ msg: String) -> PyResult<V> {
    return PyResult.error(.typeError(msg))
  }

  public static func valueError(_ msg: String) -> PyResult<V> {
    return PyResult.error(.valueError(msg))
  }

  public static func indexError(_ msg: String) -> PyResult<V> {
    return PyResult.error(.indexError(msg))
  }

  public static func attributeError(_ msg: String) -> PyResult<V> {
    return PyResult.error(.attributeError(msg))
  }

  public static func zeroDivisionError(_ msg: String) -> PyResult<V> {
    return PyResult.error(.zeroDivisionError(msg))
  }

  public static func overflowError(_ msg: String) -> PyResult<V> {
    return PyResult.error(.overflowError(msg))
  }

  public static func systemError(_ msg: String) -> PyResult<V> {
    return PyResult.error(.systemError(msg))
  }

  public static func nameError(_ msg: String) -> PyResult<V> {
    return PyResult.error(.nameError(msg))
  }

  public static func keyError(_ msg: String) -> PyResult<V> {
    return PyResult.error(.keyError(msg))
  }

  public static func keyErrorForKey(_ key: PyObject) -> PyResult<V> {
    return PyResult.error(.keyErrorForKey(key))
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

  public var asResultOrNot: PyResultOrNot<V> {
    switch self {
    case let .value(v):
      return .value(v)
    case let .error(e):
      return .error(e)
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

  public static func typeError(_ msg: String) -> PyResultOrNot<V> {
    return PyResultOrNot.error(.typeError(msg))
  }

  public static func valueError(_ msg: String) -> PyResultOrNot<V> {
    return PyResultOrNot.error(.valueError(msg))
  }

  public static func indexError(_ msg: String) -> PyResultOrNot<V> {
    return PyResultOrNot.error(.indexError(msg))
  }

  public static func attributeError(_ msg: String) -> PyResultOrNot<V> {
    return PyResultOrNot.error(.attributeError(msg))
  }

  public static func zeroDivisionError(_ msg: String) -> PyResultOrNot<V> {
    return PyResultOrNot.error(.zeroDivisionError(msg))
  }

  public static func overflowError(_ msg: String) -> PyResultOrNot<V> {
    return PyResultOrNot.error(.overflowError(msg))
  }

  public static func systemError(_ msg: String) -> PyResultOrNot<V> {
    return PyResultOrNot.error(.systemError(msg))
  }

  public static func nameError(_ msg: String) -> PyResultOrNot<V> {
    return PyResultOrNot.error(.nameError(msg))
  }

  public static func keyError(_ msg: String) -> PyResultOrNot<V> {
    return PyResultOrNot.error(.keyError(msg))
  }

  public static func keyErrorForKey(_ key: PyObject) -> PyResultOrNot<V> {
    return PyResultOrNot.error(.keyErrorForKey(key))
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
