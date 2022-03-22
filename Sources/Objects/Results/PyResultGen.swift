import Foundation
import BigInt
import FileSystem
import VioletCore

/// Generic result of a `Python` operation.
/// If you want to use `PyResultGen<PyObject>` then use `PyResult` instead
/// (no generic -> better performance).
///
/// It is the truth universally acknowledged that EVERYTHING FAILS.
///
/// On a type-system level:
/// given a type `Wrapped` it will add an `error` possibility to it.
public enum PyResultGen<Wrapped> {

  /// Use this ctor for ordinary (non-error) values.
  ///
  /// It can still hold an `error` (meaning a subclass of `BaseException`),
  /// but in this case it is just a local variable, not an object to be raised.
  case value(Wrapped)
  /// Use this ctor to raise an error in VM.
  case error(PyBaseException)

  // MARK: - Errors

  public static func typeError(_ py: Py, message: String) -> PyResultGen<Wrapped> {
    let error = py.newTypeError(message: message)
    return .error(error.asBaseException)
  }

  public static func indexError(_ py: Py, message: String) -> PyResultGen<Wrapped> {
    let error = py.newIndexError(message: message)
    return .error(error.asBaseException)
  }

  public static func attributeError(_ py: Py, message: String) -> PyResultGen<Wrapped> {
    let error = py.newAttributeError(message: message)
    return .error(error.asBaseException)
  }

  public static func zeroDivisionError(_ py: Py, message: String) -> PyResultGen<Wrapped> {
    let error = py.newZeroDivisionError(message: message)
    return .error(error.asBaseException)
  }

  public static func overflowError(_ py: Py, message: String) -> PyResultGen<Wrapped> {
    let error = py.newOverflowError(message: message)
    return .error(error.asBaseException)
  }

  public static func systemError(_ py: Py, message: String) -> PyResultGen<Wrapped> {
    let error = py.newSystemError(message: message)
    return .error(error.asBaseException)
  }

  public static func nameError(_ py: Py, message: String) -> PyResultGen<Wrapped> {
    let error = py.newNameError(message: message)
    return .error(error.asBaseException)
  }

  public static func keyError(_ py: Py, message: String) -> PyResultGen<Wrapped> {
    let error = py.newKeyError(message: message)
    return .error(error.asBaseException)
  }

  public static func valueError(_ py: Py, message: String) -> PyResultGen<Wrapped> {
    let error = py.newValueError(message: message)
    return .error(error.asBaseException)
  }

  public static func lookupError(_ py: Py, message: String) -> PyResultGen<Wrapped> {
    let error = py.newLookupError(message: message)
    return .error(error.asBaseException)
  }

  public static func runtimeError(_ py: Py, message: String) -> PyResultGen<Wrapped> {
    let error = py.newRuntimeError(message: message)
    return .error(error.asBaseException)
  }

  public static func osError(_ py: Py, message: String) -> PyResultGen<Wrapped> {
    let error = py.newOSError(message: message)
    return .error(error.asBaseException)
  }

  public static func assertionError(_ py: Py, message: String) -> PyResultGen<Wrapped> {
    let error = py.newAssertionError(message: message)
    return .error(error.asBaseException)
  }

  public static func eofError(_ py: Py, message: String) -> PyResultGen<Wrapped> {
    let error = py.newEOFError(message: message)
    return .error(error.asBaseException)
  }

  public static func keyError(_ py: Py, key: PyObject) -> PyResultGen<Wrapped> {
    let error = py.newKeyError(key: key)
    return .error(error.asBaseException)
  }

  /// `Value` is used by generators and coroutines to hold `return` value.
  public static func stopIteration(_ py: Py, value: PyObject? = nil) -> PyResultGen<Wrapped> {
    let error = py.newStopIteration(value: value)
    return .error(error.asBaseException)
  }

  public static func unboundLocalError(_ py: Py, variableName: String) -> PyResultGen<Wrapped> {
    let error = py.newUnboundLocalError(variableName: variableName)
    return .error(error.asBaseException)
  }

  public static func unicodeDecodeError(_ py: Py,
                                        encoding: PyString.Encoding,
                                        data: Data) -> PyResultGen<Wrapped> {
    let error = py.newUnicodeDecodeError(data: data, encoding: encoding)
    return .error(error.asBaseException)
  }

  public static func unicodeEncodeError(_ py: Py,
                                        encoding: PyString.Encoding,
                                        string: String) -> PyResultGen<Wrapped> {
    let error = py.newUnicodeEncodeError(string: string, encoding: encoding)
    return .error(error.asBaseException)
  }

  public static func importError(_ py: Py,
                                 message: String,
                                 moduleName: String?,
                                 modulePath: Path?) -> PyResultGen<Wrapped> {
    let error = py.newImportError(message: message,
                                  moduleName: moduleName,
                                  modulePath: modulePath)
    return .error(error.asBaseException)
  }

  public static func importError(_ py: Py,
                                 message: String,
                                 moduleName: String? = nil,
                                 modulePath: String? = nil) -> PyResultGen<Wrapped> {
    let error = py.newImportError(message: message,
                                  moduleName: moduleName,
                                  modulePath: modulePath)
    return .error(error.asBaseException)
  }

  // MARK: - Map/flatMap

  public func map<A>(_ f: (Wrapped) -> A) -> PyResultGen<A> {
    switch self {
    case let .value(v):
      return .value(f(v))
    case let .error(e):
      return .error(e)
    }
  }

  public func map(_ f: (Wrapped) -> PyObject) -> PyResult {
    switch self {
    case let .value(v):
      return .value(f(v))
    case let .error(e):
      return .error(e)
    }
  }

  public func flatMap<A>(_ f: (Wrapped) -> PyResultGen<A>) -> PyResultGen<A> {
    switch self {
    case let .value(v):
      return f(v)
    case let .error(e):
      return .error(e)
    }
  }

  public func flatMap(_ f: (Wrapped) -> PyResult) -> PyResult {
    switch self {
    case let .value(v):
      return f(v)
    case let .error(e):
      return .error(e)
    }
  }
}

// MARK: - Wrapped = Void

extension PyResultGen where Wrapped == Void {
  public static func value() -> PyResultGen {
    return PyResultGen.value(())
  }
}
