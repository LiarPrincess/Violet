import Core
import Foundation

/// Result of a `Python` operation.
///
/// On a type-system level:
/// given a type `Wrapped` it will add `error` possibility to it.
public enum PyResult<Wrapped> {
  /// Use this ctor for ordinary (non-error) values.
  ///
  /// It can still hold `error` (meaning subclass of `BaseException`),
  /// but in this case it is just a local variable, not object to be raised.
  case value(Wrapped)
  /// Use this ctor to raise error in VM.
  case error(PyErrorEnum)

  public func map<A>(_ f: (Wrapped) -> A) -> PyResult<A> {
    switch self {
    case let .value(v):
      return .value(f(v))
    case let .error(e):
      return .error(e)
    }
  }

  public func flatMap<A>(_ f: (Wrapped) -> PyResult<A>) -> PyResult<A> {
    switch self {
    case let .value(v):
      return f(v)
    case let .error(e):
      return .error(e)
    }
  }
}

// MARK: - Function result convertible

extension PyResult: PyFunctionResultConvertible
  where Wrapped: PyFunctionResultConvertible {

  internal func toFunctionResult(in context: PyContext) -> PyFunctionResult {
    return self.flatMap { $0.toFunctionResult(in: context) }
  }
}

// MARK: - Void sugar

extension PyResult where Wrapped == Void {
  public static func value() -> PyResult {
    return PyResult.value(())
  }
}

// MARK: - Errors

extension PyResult {

  public static func typeError(_ msg: String) -> PyResult<Wrapped> {
    return PyResult.error(.typeError(msg))
  }

  public static func valueError(_ msg: String) -> PyResult<Wrapped> {
    return PyResult.error(.valueError(msg))
  }

  public static func indexError(_ msg: String) -> PyResult<Wrapped> {
    return PyResult.error(.indexError(msg))
  }

  public static func attributeError(_ msg: String) -> PyResult<Wrapped> {
    return PyResult.error(.attributeError(msg))
  }

  public static func zeroDivisionError(_ msg: String) -> PyResult<Wrapped> {
    return PyResult.error(.zeroDivisionError(msg))
  }

  public static func overflowError(_ msg: String) -> PyResult<Wrapped> {
    return PyResult.error(.overflowError(msg))
  }

  public static func systemError(_ msg: String) -> PyResult<Wrapped> {
    return PyResult.error(.systemError(msg))
  }

  public static func nameError(_ msg: String) -> PyResult<Wrapped> {
    return PyResult.error(.nameError(msg))
  }

  public static func keyError(_ msg: String) -> PyResult<Wrapped> {
    return PyResult.error(.keyError(msg))
  }

  public static func keyErrorForKey(_ key: PyObject) -> PyResult<Wrapped> {
    return PyResult.error(.keyErrorForKey(key))
  }

  public static var stopIteration: PyResult<Wrapped> {
    return PyResult.error(.stopIteration)
  }

  public static func runtimeError(_ msg: String) -> PyResult<Wrapped> {
    return PyResult.error(.runtimeError(msg))
  }

  public static func unboundLocalError(variableName: String) -> PyResult<Wrapped> {
    return PyResult.error(.unboundLocalError(variableName: variableName))
  }

  public static func deprecationWarning(_ msg: String) -> PyResult<Wrapped> {
    return PyResult.error(.deprecationWarning(msg))
  }

  public static func lookupError(_ msg: String) -> PyResult<Wrapped> {
    return PyResult.error(.lookupError(msg))
  }

  public static func unicodeDecodeError(encoding: FileEncoding,
                                        data: Data) -> PyResult<Wrapped> {
    return PyResult.error(.unicodeDecodeError(encoding, data))
  }

  public static func unicodeEncodeError(encoding: FileEncoding,
                                        string: String) -> PyResult<Wrapped> {
    return PyResult.error(.unicodeEncodeError(encoding, string))
  }

  public static func osError(_ msg: String) -> PyResult<Wrapped> {
    return PyResult.error(.osError(msg))
  }
}
