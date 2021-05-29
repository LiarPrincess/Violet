import Foundation
import VioletCore

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
  case error(PyBaseException)

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

// 'PyResult' can be returned from Python function.
// Yeah… I know… shocking…
extension PyResult: PyFunctionResultConvertible
  where Wrapped: PyFunctionResultConvertible {

  internal var asFunctionResult: PyFunctionResult {
    return self.flatMap { $0.asFunctionResult }
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
    return PyResult.error(Py.newTypeError(msg: msg))
  }

  public static func valueError(_ msg: String) -> PyResult<Wrapped> {
    return PyResult.error(Py.newValueError(msg: msg))
  }

  public static func indexError(_ msg: String) -> PyResult<Wrapped> {
    return PyResult.error(Py.newIndexError(msg: msg))
  }

  public static func attributeError(_ msg: String) -> PyResult<Wrapped> {
    return PyResult.error(Py.newAttributeError(msg: msg))
  }

  public static func zeroDivisionError(_ msg: String) -> PyResult<Wrapped> {
    return PyResult.error(Py.newZeroDivisionError(msg: msg))
  }

  public static func overflowError(_ msg: String) -> PyResult<Wrapped> {
    return PyResult.error(Py.newOverflowError(msg: msg))
  }

  public static func systemError(_ msg: String) -> PyResult<Wrapped> {
    return PyResult.error(Py.newSystemError(msg: msg))
  }

  public static func nameError(_ msg: String) -> PyResult<Wrapped> {
    return PyResult.error(Py.newNameError(msg: msg))
  }

  public static func keyError(_ msg: String) -> PyResult<Wrapped> {
    return PyResult.error(Py.newKeyError(msg: msg))
  }

  public static func keyError(key: PyObject) -> PyResult<Wrapped> {
    return PyResult.error(Py.newKeyError(key: key))
  }

  /// `Value` is used by generators and coroutines to hold `return` value.
  public static func stopIteration(value: PyObject? = nil) -> PyResult<Wrapped> {
    return PyResult.error(Py.newStopIteration(value: value))
  }

  public static func runtimeError(_ msg: String) -> PyResult<Wrapped> {
    return PyResult.error(Py.newRuntimeError(msg: msg))
  }

  public static func unboundLocalError(variableName: String) -> PyResult<Wrapped> {
    return PyResult.error(Py.newUnboundLocalError(variableName: variableName))
  }

  public static func lookupError(_ msg: String) -> PyResult<Wrapped> {
    return PyResult.error(Py.newLookupError(msg: msg))
  }

  public static func unicodeDecodeError(encoding: PyStringEncoding,
                                        data: Data) -> PyResult<Wrapped> {
    let error = Py.newUnicodeDecodeError(data: data, encoding: encoding)
    return PyResult.error(error)
  }

  public static func unicodeEncodeError(encoding: PyStringEncoding,
                                        string: String) -> PyResult<Wrapped> {
    let error = Py.newUnicodeEncodeError(string: string, encoding: encoding)
    return PyResult.error(error)
  }

  public static func osError(_ msg: String) -> PyResult<Wrapped> {
    return PyResult.error(Py.newOSError(msg: msg))
  }

  public static func assertionError(_ msg: String) -> PyResult<Wrapped> {
    return PyResult.error(Py.newAssertionError(msg: msg))
  }

  public static func importError(_ msg: String) -> PyResult<Wrapped> {
    return PyResult.error(Py.newImportError(msg: msg))
  }
}
