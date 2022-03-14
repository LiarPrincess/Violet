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
  public var emptyTuple: PyTuple { fatalError() }
  public var emptyString: PyString { fatalError() }
  public var emptyBytes: PyBytes { fatalError() }
  public var emptyFrozenSet: PyFrozenSet { fatalError() }

  public let memory = PyMemory()
  public var types: Py.Types { fatalError() }
  public var errorTypes: Py.ErrorTypes { fatalError() }
  public var cast: PyCast { fatalError() }
  internal var hasher: Hasher { fatalError() }

  internal var builtinsModule: PyModule { fatalError() }

  public struct Delegate {
    var frame: PyFrame? { fatalError() }

    func eval(name: PyString?,
              qualname: PyString?,
              code: PyCode,

              args: [PyObject],
              kwargs: PyDict?,
              defaults: [PyObject],
              kwDefaults: PyDict?,

              globals: PyDict,
              locals: PyDict,
              closure: PyTuple?) -> PyResult<PyObject> { fatalError() }
  }

  public struct FileSystem {
    func basename(path: Path) -> Filename { fatalError() }
  }

  public let delegate = Delegate()
  public let fileSystem = FileSystem()

  internal func getInterned(int: Int) -> PyInt? { fatalError() }
  internal func getInterned(int: BigInt) -> PyInt? { fatalError() }

  // MARK: - New

  public func newObject(type: PyType? = nil) -> PyObject { fatalError() } // default type

  public func newString(_ s: String) -> PyString { fatalError() }
  public func newString(_ s: String.UnicodeScalarView) -> PyString { fatalError() }
  public func newString(_ s: Substring.UnicodeScalarView) -> PyString { fatalError() }
  public func newString(scalar: UnicodeScalar) -> PyString { fatalError() }
  public func newStringIterator(string: PyString) -> PyStringIterator { fatalError() }

  public func newBytes(_ d: Data) -> PyBytes { fatalError() }
  public func newBytesIterator(bytes: PyBytes) -> PyBytesIterator { fatalError() }
  public func newByteArray(_ d: Data) -> PyByteArray { fatalError() }
  public func newByteArrayIterator(bytes: PyByteArray) -> PyByteArrayIterator { fatalError() }

  public func newCode(code: CodeObject) -> PyCode { fatalError() }
  public func newCell(content: PyObject?) -> PyCell { fatalError() }
  public func newBuiltinFunction(fn: FunctionWrapper, module: PyObject?, doc: String?) -> PyBuiltinFunction { fatalError() }
  public func newStaticMethod(callable: PyBuiltinFunction) -> PyStaticMethod { fatalError() }
  public func newStaticMethod(callable: PyFunction) -> PyStaticMethod { fatalError() }
  public func newClassMethod(callable: PyBuiltinFunction) -> PyClassMethod { fatalError() }
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

  public func newBuiltinMethod(fn: FunctionWrapper,
                               object: PyObject,
                               module: PyObject?,
                               doc: String?) -> PyBuiltinMethod { fatalError() }

  public func newMethod(fn: PyFunction, object: PyObject) -> PyMethod { fatalError() }
  public func newMethod(fn: PyObject, object: PyObject) -> PyResult<PyMethod> { fatalError() }

  // Check if names are '__get__/__set__/__det__'
  public func newProperty(get: FunctionWrapper,
                          set: FunctionWrapper?,
                          del: FunctionWrapper?,
                          doc: String?) -> PyProperty { fatalError() }

  // MARK: - String

  public func repr(object: PyObject) -> PyResult<PyString> { fatalError() }
  public func reprString(object: PyObject) -> PyResult<String> { fatalError() }
  public func reprOrGenericString(object: PyObject) -> String { fatalError() }
  public func str(object: PyObject) -> PyResult<PyString> { fatalError() }
  public func strString(object: PyObject) -> PyResult<String> { fatalError() }

  // MARK: - Other

  /// Is `type` subtype of `baseException`?
  ///
  /// PyExceptionInstance_Check
  public func isException(type: PyType) -> Bool {
    let baseException = self.errorTypes.baseException
    return type.isSubtype(of: baseException)
  }

  public func intern(scalar: UnicodeScalar) -> PyString { fatalError() }
  public func intern(string: String) -> PyString { fatalError() }
  public func get__dict__(object: PyObject) -> PyDict? { fatalError() }

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

  public func setAttribute(object: PyObject, name: String, value: PyObject) -> PyResult<PyNone> { fatalError() }
  public func setAttribute(object: PyObject, name: IdString, value: PyObject) -> PyResult<PyNone> { fatalError() }
  public func setAttribute(object: PyObject, name: PyObject, value: PyObject) -> PyResult<PyNone> { fatalError() }

  // MARK: - Item

  public func getItem(object: PyObject, index: Int) -> PyResult<PyObject> { fatalError() }
  public func getItem(object: PyObject, index: PyObject) -> PyResult<PyObject> { fatalError() }
  public func setItem(object: PyObject, index: PyObject, value: PyObject) -> PyResult<PyNone> { fatalError() }

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
  public func newIndexError(message: String) -> PyIndexError { fatalError() }
  public func newZeroDivisionError(message: String) -> PyZeroDivisionError { fatalError() }
  public func newOverflowError(message: String) -> PyOverflowError { fatalError() }
  public func newNameError(message: String) -> PyNameError { fatalError() }
  public func newKeyError(message: String) -> PyKeyError { fatalError() }
  public func newValueError(message: String) -> PyValueError { fatalError() }
  public func newLookupError(message: String) -> PyLookupError { fatalError() }
  public func newRuntimeError(message: String) -> PyRuntimeError { fatalError() }
  public func newOSError(message: String) -> PyOSError { fatalError() }
  public func newAssertionError(message: String) -> PyAssertionError { fatalError() }
  public func newEOFError(message: String) -> PyEOFError { fatalError() }
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
                         arg: PyObject) -> CallMethodResult {
    fatalError()
  }

  public func callMethod(object: PyObject,
                         selector: IdString,
                         args: [PyObject] = [],
                         kwargs: PyDict? = nil,
                         allowsCallableFromDict: Bool = false) -> CallMethodResult {
    fatalError()
  }

  public func hasMethod(object: PyObject, selector: IdString) -> PyResult<Bool> { fatalError() }
  public func hasMethod(object: PyObject, selector: PyObject) -> PyResult<Bool> { fatalError() }

  public func newSuper(requestedType: PyType?, object: PyObject?, objectType: PyType?) -> PySuper { fatalError() }

  public func isCallable(object: PyObject) -> Bool { fatalError() }
  public func isAbstractMethod(object: PyObject) -> PyResult<Bool> { fatalError() }

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

  public func warnBytesIfEnabled(message: String) -> PyBaseException? { fatalError() }

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
