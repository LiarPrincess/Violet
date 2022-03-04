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
  public func newTuple(elements: PyObject...) -> PyTuple { fatalError() }
  public func newList(elements: [PyObject]) -> PyList { fatalError() }
  public func newDict() -> PyDict { fatalError() }

  public func newStaticMethod(callable: PyFunction) -> PyStaticMethod { fatalError() }
  public func newClassMethod(callable: PyFunction) -> PyClassMethod { fatalError() }

  internal func newType(
    name: String,
    qualname: String,
    flags: PyType.TypeFlags,
    base: PyType,
    mro: MethodResolutionOrder,
    layout: PyType.MemoryLayout,
    staticMethods: PyStaticCall.KnownNotOverriddenMethods,
    debugFn: @escaping PyType.DebugFn,
    deinitialize: @escaping PyType.DeinitializeFn
  ) -> PyType {
    let metatype = self.types.type
    return self.memory.newType(self,
                               type: metatype,
                               name: name,
                               qualname: qualname,
                               flags: flags,
                               base: base,
                               bases: mro.baseClasses,
                               mroWithoutSelf: mro.resolutionOrder,
                               subclasses: [],
                               layout: layout,
                               staticMethods: staticMethods,
                               debugFn: debugFn,
                               deinitialize: deinitialize)
  }

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
  public func globals() -> PyResult<PyDict> { fatalError() }

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

  public func forEach(iterable: PyObject, fn: ForEachFn) -> PyBaseException? { fatalError() }
  public func toArray(iterable: PyObject) -> PyResult<[PyObject]> { fatalError() }

  // MARK: - Attributes

  public func getAttribute(object: PyObject,
                           name: String,
                           default: PyObject? = nil) -> PyResult<PyObject> { fatalError() }
  public func getAttribute(object: PyObject,
                           name: IdString,
                           default: PyObject? = nil) -> PyResult<PyObject> { fatalError() }
  public func getAttribute(object: PyObject,
                           name: PyObject,
                           default: PyObject? = nil) -> PyResult<PyObject> { fatalError() }

  public func hasAttribute(object: PyObject, name: String) -> PyResult<Bool> { fatalError() }
  public func hasAttribute(object: PyObject, name: IdString) -> PyResult<Bool> { fatalError() }
  public func hasAttribute(object: PyObject, name: PyObject) -> PyResult<Bool> { fatalError() }

  public func setAttribute(object: PyObject,
                           name: String,
                           value: PyObject) -> PyResult<PyNone> { fatalError() }
  public func setAttribute(object: PyObject,
                           name: IdString,
                           value: PyObject) -> PyResult<PyNone> { fatalError() }
  public func setAttribute(object: PyObject,
                           name: PyObject,
                           value: PyObject) -> PyResult<PyNone> { fatalError() }

  // MARK: - Errors

  public func newInvalidSelfArgumentError(object: PyObject,
                                          expectedType: String,
                                          swiftFnName: StaticString) -> PyTypeError {
    // Note that 'swiftFnName' is a full selector!
    // For example: '__repr__(_:zelf:)'
    fatalError()
  }

  public func newInvalidSelfArgumentError(object: PyObject,
                                          expectedType: String,
                                          fnName: String) -> PyTypeError {
    let t = object.typeName
    let message = "descriptor '\(fnName)' requires a '\(expectedType)' object but received a '\(t)'"
    return self.newTypeError(message: message)
  }

  public func newSystemError(message: String) -> PySystemError { fatalError() }
  public func newTypeError(message: String) -> PyTypeError { fatalError() }
  public func newAttributeError(message: String) -> PyAttributeError { fatalError() }
  public func newAttributeError(object: PyObject, hasNoAttribute: PyString) -> PyAttributeError { fatalError() }
  public func newAttributeError(object: PyObject, attributeIsReadOnly: PyString) -> PyAttributeError { fatalError() }
  public func newIndexError(message: String) -> PySystemError { fatalError() }
  public func newZeroDivisionError(message: String) -> PySystemError { fatalError() }
  public func newOverflowError(message: String) -> PySystemError { fatalError() }
  public func newNameError(message: String) -> PySystemError { fatalError() }
  public func newKeyError(message: String) -> PySystemError { fatalError() }
  public func newValueError(message: String) -> PySystemError { fatalError() }
  public func newLookupError(message: String) -> PySystemError { fatalError() }
  public func newRuntimeError(message: String) -> PySystemError { fatalError() }
  public func newOSError(message: String) -> PySystemError { fatalError() }
  public func newAssertionError(message: String) -> PySystemError { fatalError() }
  public func newEOFError(message: String) -> PySystemError { fatalError() }
  public func newKeyError(key: PyObject) -> PyKeyError { fatalError() }
  public func newStopIteration(value: PyObject?) -> PyStopIteration { fatalError() }
  public func newUnboundLocalError(variableName: String) -> PyUnboundLocalError { fatalError() }
  public func newUnicodeDecodeError(data: Data, encoding: PyString.Encoding) -> PyUnicodeDecodeError { fatalError() }
  public func newUnicodeEncodeError(string: String, encoding: PyString.Encoding) -> PyUnicodeEncodeError { fatalError() }
  public func newImportError(message: String,
                             moduleName: String?,
                             modulePath: String?) -> PyImportError { fatalError() }
  public func newImportError(message: String,
                             moduleName: String?,
                             modulePath: Path?) -> PyImportError { fatalError() }
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

  // MARK: - Warn

  public enum PyWarningEnum {

    /// Base class for warning categories.
    case warning
    /// Base class for warnings about deprecated features.
    case deprecation
    /// Base class for warnings about features which will be deprecated
    /// in the future.
    case pendingDeprecation
    /// Base class for warnings about dubious runtime behavior.
    case runtime
    /// Base class for warnings about dubious syntax.
    case syntax
    /// Base class for warnings generated by user code.
    case user
    /// Base class for warnings about constructs that will change semantically
    /// in the future.
    case future
    /// Base class for warnings about probable mistakes in module imports
    case `import`
    /// Base class for warnings about Unicode related problems, mostly
    /// related to conversion problems.
    case unicode
    /// Base class for warnings about bytes and buffer related problems,
    /// mostly related to conversion from str or comparing to str.
    case bytes
    /// Base class for warnings about resource usage.
    case resource
  }

  public func warn(type: PyWarningEnum, message: String) -> PyBaseException? {
    fatalError()
  }

  public func warn(type: PyWarningEnum, message: PyString) -> PyBaseException? {
    fatalError()
  }

  // MARK: - Get string

  internal enum GetStringResult {
    case string(PyString, String)
    case bytes(PyAnyBytes, String)
    case byteDecodingError(PyAnyBytes)
    case notStringOrBytes
  }

  internal func getString(object: PyObject,
                          encoding: PyString.Encoding?) -> GetStringResult {
    fatalError()
  }

  internal func getString(bytes: PyAnyBytes,
                          encoding: PyString.Encoding?) -> String? {
    fatalError()
  }

  internal func getString(data: Data,
                          encoding: PyString.Encoding?) -> String? {
    fatalError()
  }
}

struct PyAnyBytes {
  var object: PyBytes { fatalError() }
}
