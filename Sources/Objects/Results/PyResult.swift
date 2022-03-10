import Foundation
import BigInt
import FileSystem
import VioletCore

/// Result of a `Python` operation.
///
/// It is the truth universally acknowledged that EVERYTHING FAILS.
///
/// On a type-system level:
/// given a type `Wrapped` it will add an `error` possibility to it.
public enum PyResult<Wrapped> {

  /// Use this ctor for ordinary (non-error) values.
  ///
  /// It can still hold an `error` (meaning a subclass of `BaseException`),
  /// but in this case it is just a local variable, not an object to be raised.
  case value(Wrapped)
  /// Use this ctor to raise an error in VM.
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

// MARK: - Wrapped = Void

extension PyResult where Wrapped == Void {
  public static func value() -> PyResult {
    return PyResult.value(())
  }
}

// MARK: - Wrapped = PyObject

extension PyResult where Wrapped == PyObject {
  public static func none(_ py: Py) -> PyResult {
    return .value(py.none.asObject)
  }

  public static func notImplemented(_ py: Py) -> PyResult {
    return .value(py.notImplemented.asObject)
  }

  public init(_ py: Py, _ value: Bool) {
    let object = py.newBool(value)
    self = .value(object.asObject)
  }

  public init(_ py: Py, _ value: PyResult<Bool>) {
    self = value.map { py.newBool($0).asObject }
  }

  public init(_ py: Py, _ value: UInt8) {
    let object = py.newInt(value)
    self = .value(object.asObject)
  }

  public init(_ py: Py, _ value: Int) {
    let object = py.newInt(value)
    self = .value(object.asObject)
  }

  public init(_ py: Py, _ value: PyResult<Int>) {
    self = value.map { py.newInt($0).asObject }
  }

  public init(_ py: Py, _ value: BigInt) {
    let object = py.newInt(value)
    self = .value(object.asObject)
  }

  public init(_ py: Py, _ value: PyResult<BigInt>) {
    self = value.map { py.newInt($0).asObject }
  }

  public init(_ py: Py, _ value: Double) {
    let object = py.newFloat(value)
    self = .value(object.asObject)
  }

  public init(_ py: Py, _ value: PyResult<Double>) {
    self = value.map { py.newFloat($0).asObject }
  }

  public init(_ py: Py, real: Double, imag: Double) {
    let object = py.newComplex(real: real, imag: imag)
    self = .value(object.asObject)
  }

  public init(_ py: Py, _ value: String) {
    let object = py.newString(value)
    self = .value(object.asObject)
  }

  public init(_ py: Py, interned value: String) {
    let object = py.intern(string: value)
    self = .value(object.asObject)
  }

  public init(_ py: Py, _ value: PyResult<String>) {
    self = value.map { py.newString($0).asObject }
  }

  public init<T: PyObjectMixin>(_ value: T) {
    self = .value(value.asObject)
  }

  public init<T: PyObjectMixin>(_ value: PyResult<T>) {
    self = value.map { $0.asObject }
  }

  public init(_ py: Py, tuple elements: PyObject...) {
    let object = py.newTuple(elements: elements)
    self = .value(object.asObject)
  }

  public init(_ py: Py, tuple elements: [PyObject]) {
    let object = py.newTuple(elements: elements)
    self = .value(object.asObject)
  }
}

// MARK: - Errors

extension PyResult {

  public static func typeError(_ py: Py, message: String) -> PyResult<Wrapped> {
    let error = py.newTypeError(message: message)
    return .error(error.asBaseException)
  }

  public static func indexError(_ py: Py, message: String) -> PyResult<Wrapped> {
    let error = py.newIndexError(message: message)
    return .error(error.asBaseException)
  }

  public static func attributeError(_ py: Py, message: String) -> PyResult<Wrapped> {
    let error = py.newAttributeError(message: message)
    return .error(error.asBaseException)
  }

  public static func zeroDivisionError(_ py: Py, message: String) -> PyResult<Wrapped> {
    let error = py.newZeroDivisionError(message: message)
    return .error(error.asBaseException)
  }

  public static func overflowError(_ py: Py, message: String) -> PyResult<Wrapped> {
    let error = py.newOverflowError(message: message)
    return .error(error.asBaseException)
  }

  public static func systemError(_ py: Py, message: String) -> PyResult<Wrapped> {
    let error = py.newSystemError(message: message)
    return .error(error.asBaseException)
  }

  public static func nameError(_ py: Py, message: String) -> PyResult<Wrapped> {
    let error = py.newNameError(message: message)
    return .error(error.asBaseException)
  }

  public static func keyError(_ py: Py, message: String) -> PyResult<Wrapped> {
    let error = py.newKeyError(message: message)
    return .error(error.asBaseException)
  }

  public static func valueError(_ py: Py, message: String) -> PyResult<Wrapped> {
    let error = py.newValueError(message: message)
    return .error(error.asBaseException)
  }

  public static func lookupError(_ py: Py, message: String) -> PyResult<Wrapped> {
    let error = py.newLookupError(message: message)
    return .error(error.asBaseException)
  }

  public static func runtimeError(_ py: Py, message: String) -> PyResult<Wrapped> {
    let error = py.newRuntimeError(message: message)
    return .error(error.asBaseException)
  }

  public static func osError(_ py: Py, message: String) -> PyResult<Wrapped> {
    let error = py.newOSError(message: message)
    return .error(error.asBaseException)
  }

  public static func assertionError(_ py: Py, message: String) -> PyResult<Wrapped> {
    let error = py.newAssertionError(message: message)
    return .error(error.asBaseException)
  }

  public static func eofError(_ py: Py, message: String) -> PyResult<Wrapped> {
    let error = py.newEOFError(message: message)
    return .error(error.asBaseException)
  }

  public static func keyError(_ py: Py, key: PyObject) -> PyResult<Wrapped> {
    let error = py.newKeyError(key: key)
    return .error(error.asBaseException)
  }

  /// `Value` is used by generators and coroutines to hold `return` value.
  public static func stopIteration(_ py: Py, value: PyObject? = nil) -> PyResult<Wrapped> {
    let error = py.newStopIteration(value: value)
    return .error(error.asBaseException)
  }

  public static func unboundLocalError(_ py: Py, variableName: String) -> PyResult<Wrapped> {
    let error = py.newUnboundLocalError(variableName: variableName)
    return .error(error.asBaseException)
  }

  public static func unicodeDecodeError(_ py: Py,
                                        encoding: PyString.Encoding,
                                        data: Data) -> PyResult<Wrapped> {
    let error = py.newUnicodeDecodeError(data: data, encoding: encoding)
    return .error(error.asBaseException)
  }

  public static func unicodeEncodeError(_ py: Py,
                                        encoding: PyString.Encoding,
                                        string: String) -> PyResult<Wrapped> {
    let error = py.newUnicodeEncodeError(string: string, encoding: encoding)
    return .error(error.asBaseException)
  }

  public static func importError(_ py: Py,
                                 message: String,
                                 moduleName: String?,
                                 modulePath: Path?) -> PyResult<Wrapped> {
    let error = py.newImportError(message: message,
                                  moduleName: moduleName,
                                  modulePath: modulePath)
    return .error(error.asBaseException)
  }

  public static func importError(_ py: Py,
                                 message: String,
                                 moduleName: String? = nil,
                                 modulePath: String? = nil) -> PyResult<Wrapped> {
    let error = py.newImportError(message: message,
                                  moduleName: moduleName,
                                  modulePath: modulePath)
    return .error(error.asBaseException)
  }
}
