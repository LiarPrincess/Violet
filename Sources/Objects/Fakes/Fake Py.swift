// swiftlint:disable fatal_error_message
// swiftlint:disable unavailable_function

import Foundation
import BigInt
import FileSystem
import VioletCore
import VioletBytecode

public struct Py {

  public var `true`: PyBool { fatalError() }
  public var `false`: PyBool { fatalError() }
  public var none: PyNone { fatalError() }
  public var ellipsis: PyEllipsis { fatalError() }
  public var notImplemented: PyNotImplemented { fatalError() }

  public let memory = PyMemory()
  public var types: Py.Types { fatalError() }
  public var errorTypes: Py.ErrorTypes { fatalError() }
  public var cast: Py.Cast { fatalError() }
  internal var hasher: Hasher { fatalError() }

  // MARK: - New

  public func newObject(type: PyType? = nil) -> PyObject { fatalError() } // default type
  public func newBool(_ value: Bool) -> PyBool { fatalError() }
  public func newInt(_ value: Int) -> PyInt { fatalError() }
  public func newInt(_ value: UInt8) -> PyInt { fatalError() }
  public func newInt(_ value: BigInt) -> PyInt { fatalError() }
  public func newFloat(_ value: Double) -> PyFloat { fatalError() }
  public func newComplex(real: Double, imag: Double) -> PyComplex { fatalError() }
  public func newString(_ s: String) -> PyString { fatalError() }
  public func newBytes(_ d: Data) -> PyBytes { fatalError() }
  public func newCode(code: CodeObject) -> PyString { fatalError() }
  public func newTuple(elements: [PyObject]) -> PyTuple { fatalError() }
  public func newList(elements: [PyObject]) -> PyList { fatalError() }
  public func newDict() -> PyDict { fatalError() }

  // MARK: - String

  public func repr(object: PyObject) -> PyResult<PyString> { fatalError() }
  public func reprString(object: PyObject) -> PyResult<String> { fatalError() }
  public func str(object: PyObject) -> PyResult<PyString> { fatalError() }
  public func strString(object: PyObject) -> PyResult<String> { fatalError() }

  // MARK: - Other

  public enum GetKeysResult {
    case value(PyObject)
    case error(PyBaseException)
    case missingMethod(PyBaseException)
  }

  public func getKeys(object: PyObject) -> GetKeysResult { fatalError() }

  /// Is `type` subtype of `baseException`?
  ///
  /// PyExceptionInstance_Check
  public func isException(type: PyType) -> Bool {
    let baseException = self.errorTypes.baseException
    return type.isSubtype(of: baseException)
  }

  public func isEqualBool(left: PyObject, right: PyObject) -> PyResult<Bool> {
    return .value(false)
  }

  public func intern(string: String) -> PyString { fatalError() }
  public func hashNotAvailable(_ o: PyObject) -> PyBaseException { fatalError() }
  public func get__dict__(object: PyObject) -> PyDict? { fatalError() }

  // MARK: - Collections

  public enum ForEachStep {
    /// Go to the next item.
    case goToNextElement
    /// Finish iteration.
    case finish
    /// Finish iteration with given error.
    case error(PyBaseException)
  }

  public typealias ForEachFn = (PyObject) -> ForEachStep

  public func forEach(iterable: PyObject, fn: ForEachFn) -> PyBaseException? {
    fatalError()
  }

  // MARK: - Errors

  public func newInvalidSelfArgumentError(object: PyObject,
                                          expectedType: String,
                                          fnName: String) -> PyTypeError {
    let message = "descriptor '\(fnName)' requires a '\(expectedType)' object " +
                  "but received a '\(object.typeName)'"
    return self.newTypeError(message: message)
  }

  public func newTypeError(message: String) -> PyTypeError { fatalError() }
  public func newAttributeError(message: String) -> PyAttributeError { fatalError() }
  public func newAttributeError(object: PyObject, hasNoAttribute: PyString) -> PyAttributeError { fatalError() }
  public func newAttributeError(object: PyObject, attributeIsReadOnly: PyString) -> PyAttributeError { fatalError() }

  // MARK: - Call

  public enum CallResult {
    case value(PyObject)
    /// Object is not callable.
    case notCallable(PyBaseException)
    case error(PyBaseException)

    public var asResult: PyResult<PyObject> {
      switch self {
      case let .value(o):
        return .value(o)
      case let .error(e),
           let .notCallable(e):
        return .error(e)
      }
    }
  }

  public func call(callable: PyObject) -> CallResult { fatalError() }
  public func call(callable: PyObject, arg: PyObject) -> CallResult { fatalError() }
  public func call(callable: PyObject, args: PyObject, kwargs: PyObject?) -> CallResult { fatalError() }
  public func call(callable: PyObject, args: [PyObject] = [], kwargs: PyDict? = nil) -> CallResult { fatalError() }

  // MARK: - Methods

  public enum GetMethodResult {
    /// Method found (_yay!_), here is its value (_double yay!_).
    case value(PyObject)
    /// Such method does not exist.
    case notFound(PyBaseException)
    /// Raise error in VM.
    case error(PyBaseException)
  }

  public enum CallMethodResult {
    case value(PyObject)
    /// Such method does not exists.
    case missingMethod(PyBaseException)
    /// Method exists, but it is not callable.
    case notCallable(PyBaseException)
    case error(PyBaseException)

    public var asResult: PyResult<PyObject> {
      switch self {
      case let .value(o):
        return .value(o)
      case let .error(e),
           let .notCallable(e),
           let .missingMethod(e):
        return .error(e)
      }
    }
  }


  public func callMethod(object: PyObject,
                         selector: IdString,
                         args: [PyObject] = [],
                         kwargs: PyDict? = nil,
                         allowsCallableFromDict: Bool = false) -> CallMethodResult {
    fatalError()
  }
}

/* MARKER

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

  public static func unicodeDecodeError(encoding: PyString.Encoding,
                                        data: Data) -> PyResult<Wrapped> {
    let error = Py.newUnicodeDecodeError(data: data, encoding: encoding)
    return PyResult.error(error)
  }

  public static func unicodeEncodeError(encoding: PyString.Encoding,
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

  public static func importError(_ msg: String,
                                 moduleName: String?,
                                 modulePath: Path?) -> PyResult<Wrapped> {
    let error = Py.newImportError(msg: msg,
                                  moduleName: moduleName,
                                  modulePath: modulePath)
    return PyResult.error(error)
  }

  public static func importError(_ msg: String,
                                 moduleName: String? = nil,
                                 modulePath: String? = nil) -> PyResult<Wrapped> {
    let error = Py.newImportError(msg: msg,
                                  moduleName: moduleName,
                                  modulePath: modulePath)
    return PyResult.error(error)
  }

  public static func eofError(_ msg: String) -> PyResult<Wrapped> {
    return PyResult.error(Py.newEOFError(msg: msg))
  }
}
*/
