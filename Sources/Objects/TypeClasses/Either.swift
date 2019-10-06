internal enum PyErrorEnum {
  case typeError(String)
  case valueError(String)
  case indexError(String)
}

internal enum Either<V, E> {
  case value(V)
  case error(E)

  internal func map<A>(_ f: (V) -> A) -> Either<A, E> {
    switch self {
    case let .value(v):
      return .value(f(v))
    case let .error(e):
      return .error(e)
    }
  }

  internal func flatMap<A>(_ f: (V) -> Either<A, E>) -> Either<A, E> {
    switch self {
    case let .value(v):
      return f(v)
    case let .error(e):
      return .error(e)
    }
  }

  internal func mapError<A>(_ f: (E) -> A) -> Either<V, A> {
    switch self {
    case let .value(v):
      return .value(v)
    case let .error(e):
      return .error(f(e))
    }
  }

  internal func bimap<A, B>(_ f: (V) -> A, _ g: (E) -> B) -> Either<A, B> {
    switch self {
    case let .value(v):
      return .value(f(v))
    case let .error(e):
      return .error(g(e))
    }
  }
}
