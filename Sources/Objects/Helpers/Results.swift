import Core

// MARK: - PyErrorEnum

internal enum PyErrorEnum {
  case typeError(String)
  case valueError(String)
  case indexError(String)
  case zeroDivisionError(String)
}

// MARK: - PyResult

internal enum PyResult<V> {
  case value(V)
  case error(PyErrorEnum)

  internal func map<A>(_ f: (V) -> A) -> PyResult<A> {
    switch self {
    case let .value(v):
      return .value(f(v))
    case let .error(e):
      return .error(e)
    }
  }

  internal func flatMap<A>(_ f: (V) -> PyResult<A>) -> PyResult<A> {
    switch self {
    case let .value(v):
      return f(v)
    case let .error(e):
      return .error(e)
    }
  }

  internal func mapError(_ f: (PyErrorEnum) -> PyErrorEnum) -> PyResult<V> {
    switch self {
    case let .value(v):
      return .value(v)
    case let .error(e):
      return .error(f(e))
    }
  }
}

// MARK: - PyResultOrNot

/// Basically `PyResult` + notImplemented.
///
/// This is soooo... bad name for an enum, I love it!
internal enum PyResultOrNot<V> {
  case value(V)
  case error(PyErrorEnum)
  case notImplemented

  internal var isNotImplemented: Bool {
    switch self {
    case .notImplemented:
      return true
    case .value, .error:
      return false
    }
  }

  internal func map<A>(_ f: (V) -> A) -> PyResultOrNot<A> {
    switch self {
    case let .value(v):
      return .value(f(v))
    case let .error(e):
      return .error(e)
    case .notImplemented:
      return .notImplemented
    }
  }

  internal func flatMap<A>(_ f: (V) -> PyResultOrNot<A>) -> PyResultOrNot<A> {
    switch self {
    case let .value(v):
      return f(v)
    case let .error(e):
      return .error(e)
    case .notImplemented:
      return .notImplemented
    }
  }

  internal func mapError(_ f: (PyErrorEnum) -> PyErrorEnum) -> PyResultOrNot<V> {
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

// MARK: - Optional transformer

extension Optional {
  internal func map<V, A>(_ f: (V) -> A) -> PyResult<A>?
    where Wrapped == PyResult<V> {

      switch self {
      case let .some(result):
        return result.map(f)
      case .none:
        return .none
      }
  }

  internal func flatMap<V, A>(_ f: (V) -> PyResult<A>) -> PyResult<A>?
    where Wrapped == PyResult<V> {

      switch self {
      case let .some(result):
        return result.flatMap(f)
      case .none:
        return .none
      }
  }

  internal func map<V, A>(_ f: (V) -> A) -> PyResultOrNot<A>?
    where Wrapped == PyResultOrNot<V> {

      switch self {
      case let .some(result):
        return result.map(f)
      case .none:
        return .none
      }
  }

  internal func flatMap<V, A>(_ f: (V) -> PyResultOrNot<A>) -> PyResultOrNot<A>?
    where Wrapped == PyResultOrNot<V> {

      switch self {
      case let .some(result):
        return result.flatMap(f)
      case .none:
        return .none
      }
  }
}

// MARK: - Instances

public enum GetAttributeResult {
  case value(PyObject)
  case attributeError(String)
}

public enum DelAttributeResult {
  case value(PyObject)
  case attributeError(String)
}

internal typealias EquatableResult = PyResultOrNot<Bool>
internal typealias ComparableResult = PyResultOrNot<Bool>
internal typealias HashableResult = PyResultOrNot<PyHash>
internal typealias GetItemResult<T> = PyResult<T>
internal typealias CountResult = PyResult<BigInt>
internal typealias IndexOfResult = PyResult<BigInt>
internal typealias AddResult<T> = PyResultOrNot<T>
internal typealias SubResult<T> = PyResultOrNot<T>
internal typealias MulResult<T> = PyResultOrNot<T>
internal typealias MatrixMulResult<T> = PyResultOrNot<T>
internal typealias PowResult<T> = PyResultOrNot<T>
internal typealias TrueDivResult<T> = PyResultOrNot<T>
internal typealias FloorDivResult<T> = PyResultOrNot<T>
internal typealias ModResult<T> = PyResultOrNot<T>
internal typealias DivModResult<T> = PyResultOrNot<T>
internal typealias ShiftResult<T> = PyResultOrNot<T>
internal typealias BinaryResult<T> = PyResultOrNot<T>
internal typealias RoundResult<T> = PyResultOrNot<T>
internal typealias TruncResult<T> = PyResultOrNot<T>
internal typealias FloorResult<T> = PyResultOrNot<T>
internal typealias CeilResult<T> = PyResultOrNot<T>
