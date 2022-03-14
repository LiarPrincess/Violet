// swiftlint:disable fatal_error_message
// swiftlint:disable unavailable_function

import Foundation
import BigInt
import FileSystem
import VioletCore
import VioletLexer
import VioletParser
import VioletBytecode
import VioletCompiler

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

  public var delegate: PyDelegate { fatalError() }
  public var fileSystem: PyFileSystem { fatalError() }

  internal var sys: Sys { fatalError() }
  internal var _warnings: UnderscoreWarnings { fatalError() }

  internal var sysModule: PyModule { fatalError() }
  internal var _impModule: PyModule { fatalError() }
  internal var builtinsModule: PyModule { fatalError() }

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

  public func newModule(name: String) -> PyModule { fatalError() }

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

  public func intern(scalar: UnicodeScalar) -> PyString { fatalError() }
  public func intern(string: String) -> PyString { fatalError() }
  public func get__dict__(object: PyObject) -> PyDict? { fatalError() }

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

  public func getMethod(object: PyObject,
                        selector: PyString,
                        allowsCallableFromDict: Bool = false) -> GetMethodResult {
    fatalError()
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

// MARK: - Compile


  public enum CompileResult {
    /// Code compiled successfully (Yay!)
    case code(PyCode)

    /// Lexer warning that should be treated as error OR error when printing
    case lexerWarning(LexerWarning, PyBaseException)
    /// Lexing failed
    case lexerError(LexerError, PyBaseException)

    /// Parser warning that should be treated as error OR error when printing
    case parserWarning(ParserWarning, PyBaseException)
    /// Parsing failed
    case parserError(ParserError, PyBaseException)

    /// Compiler warning that should be treated as error OR error when printing
    case compilerWarning(CompilerWarning, PyBaseException)
    /// Compiling failed
    case compilerError(CompilerError, PyBaseException)

    /// Non lexer, parser or compiler error
    case error(PyBaseException)

    public func asResult() -> PyResult<PyCode> {
      switch self {
      case let .code(c):
        return .value(c)
      case let .lexerWarning(_, e),
           let .lexerError(_, e),
           let .parserWarning(_, e),
           let .parserError(_, e),
           let .compilerWarning(_, e),
           let .compilerError(_, e),
           let .error(e):
        return .error(e)
      }
    }
  }


  public func compile(path: Path,
                      mode: Parser.Mode,
                      optimize: Compiler.OptimizationLevel? = nil) -> CompileResult {
    fatalError()
  }

  // MARK: - Errors

  // 'IndentationError' is a subclass of 'SyntaxError' with custom 'init'
  // ImportError: Exception # Import can't find module, or can't find name in module.
  // ModuleNotFoundError: ImportError # Module not found.
  //
  // SyntaxError: Exception # Invalid syntax.
  // IndentationError: SyntaxError # Improper indentation.
  // TabError: IndentationError # Improper mixture of spaces and tabs.

  public func newIndentationError(message: String?,
                                  filename: String?,
                                  lineno: BigInt?,
                                  offset: BigInt?,
                                  text: String?,
                                  printFileAndLine: Bool?) -> PyIndentationError { fatalError() }

  public func newIndentationError(message: PyString?,
                                  filename: PyString?,
                                  lineno: PyInt?,
                                  offset: PyInt?,
                                  text: PyString?,
                                  printFileAndLine: PyBool?) -> PyIndentationError { fatalError() }

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
