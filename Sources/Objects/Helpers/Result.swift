import Core
import Foundation

// swiftlint:disable file_length

// MARK: - PyErrorEnum

public enum PyErrorEnum: CustomStringConvertible {
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
  case stopIteration
  case runtimeError(String)
  case unboundLocalError(variableName: String)
  case deprecationWarning(String)
  case lookupError(String)
  case unicodeDecodeError(FileEncoding, Data)
  case unicodeEncodeError(FileEncoding, String)
  case osError(String)

  public var description: String {
    switch self {
    case .typeError(let msg): return "Type error: '\(msg)'"
    case .valueError(let msg): return "Value error: '\(msg)'"
    case .indexError(let msg): return "Index error: '\(msg)'"
    case .attributeError(let msg): return "Attribute error: '\(msg)'"
    case .zeroDivisionError(let msg): return "ZeroDivision error: '\(msg)'"
    case .overflowError(let msg): return "Overflow error: '\(msg)'"
    case .systemError(let msg): return "System error: '\(msg)'"
    case .nameError(let msg): return "Name error: '\(msg)'"
    case .keyError(let msg): return "Key error: '\(msg)'"
    case .keyErrorForKey: return "Key error for key"
    case .stopIteration: return "Stop iteration"
    case .runtimeError(let msg): return "Runtime error: '\(msg)'"
    case .unboundLocalError(variableName: let v):
      return "UnboundLocalError: local variable '\(v)' referenced before assignment"
    case .deprecationWarning(let msg): return "Deprecation warning: '\(msg)'"
    case .lookupError(let msg): return "Lookup error: '\(msg)'"
    case .unicodeDecodeError(let e, _): return "'\(e)' codec can't decode data"
    case .unicodeEncodeError(let e, _): return "'\(e)' codec can't encode data"
    case .osError(let msg): return "OS error: '\(msg)'"
    }
  }
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

  public static var stopIteration: PyResult<V> {
    return PyResult.error(.stopIteration)
  }

  public static func runtimeError(_ msg: String) -> PyResult<V> {
    return PyResult.error(.runtimeError(msg))
  }

  public static func unboundLocalError(variableName: String) -> PyResult<V> {
    return PyResult.error(.unboundLocalError(variableName: variableName))
  }

  public static func deprecationWarning(_ msg: String) -> PyResult<V> {
    return PyResult.error(.deprecationWarning(msg))
  }

  public static func lookupError(_ msg: String) -> PyResult<V> {
    return PyResult.error(.lookupError(msg))
  }

  public static func unicodeDecodeError(encoding: FileEncoding,
                                        data: Data) -> PyResult<V> {
    return PyResult.error(.unicodeDecodeError(encoding, data))
  }

  public static func unicodeEncodeError(encoding: FileEncoding,
                                        string: String) -> PyResult<V> {
    return PyResult.error(.unicodeEncodeError(encoding, string))
  }

  public static func osError(_ msg: String) -> PyResult<V> {
    return PyResult.error(.osError(msg))
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

  public static var stopIteration: PyResultOrNot<V> {
    return PyResultOrNot.error(.stopIteration)
  }

  public static func runtimeError(_ msg: String) -> PyResultOrNot<V> {
    return PyResultOrNot.error(.runtimeError(msg))
  }

  public static func unboundLocalError(variableName: String) -> PyResultOrNot<V> {
    return PyResultOrNot.error(.unboundLocalError(variableName: variableName))
  }

  public static func deprecationWarning(_ msg: String) -> PyResultOrNot<V> {
    return PyResultOrNot.error(.deprecationWarning(msg))
  }

  public static func lookupError(_ msg: String) -> PyResultOrNot<V> {
    return PyResultOrNot.error(.lookupError(msg))
  }

  public static func unicodeDecodeError(encoding: FileEncoding,
                                        data: Data) -> PyResultOrNot<V> {
    return PyResultOrNot.error(.unicodeDecodeError(encoding, data))
  }

  public static func unicodeEncodeError(encoding: FileEncoding,
                                        string: String) -> PyResultOrNot<V> {
    return PyResultOrNot.error(.unicodeEncodeError(encoding, string))
  }

  public static func osError(_ msg: String) -> PyResultOrNot<V> {
    return PyResultOrNot.error(.osError(msg))
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
