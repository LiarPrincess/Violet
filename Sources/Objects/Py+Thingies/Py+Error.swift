import Foundation
import BigInt
import VioletCore
import VioletLexer
import VioletParser
import VioletCompiler

// swiftlint:disable file_length
// cSpell:ignore bltinmod

// In CPython:
// Objects -> exceptions.c
// Python -> errors.c
// https://docs.python.org/3.7/library/exceptions.html

extension PyInstance {

  // MARK: - Type error

  /// Inappropriate argument type.
  public func newTypeError(msg: String) -> PyTypeError {
    return PyTypeError(msg: msg)
  }

  // MARK: - Value error

  /// Inappropriate argument value (of correct type).
  public func newValueError(msg: String) -> PyValueError {
    return PyValueError(msg: msg)
  }

  // MARK: - Index error

  /// Sequence index out of range.
  public func newIndexError(msg: String) -> PyIndexError {
    return PyIndexError(msg: msg)
  }

  // MARK: - Attribute error

  /// Attribute not found.
  public func newAttributeError(msg: String) -> PyAttributeError {
    return PyAttributeError(msg: msg)
  }

  /// Attribute not found.
  public func newAttributeError(
    object: PyObject,
    hasNoAttribute name: PyString
  ) -> PyAttributeError {
    let repr = name.reprRaw()
    return self.newAttributeError(object: object, hasNoAttribute: repr)
  }

  /// Attribute not found.
  public func newAttributeError(
    object: PyObject,
    hasNoAttribute name: String
  ) -> PyAttributeError {
    let msg = "\(object.typeName) object has no attribute \(name.quoted)"
    return self.newAttributeError(msg: msg)
  }

  /// Attribute is read-only.
  public func newAttributeError(
    object: PyObject,
    attributeIsReadOnly name: PyString
  ) -> PyAttributeError {
    let repr = name.reprRaw()
    return self.newAttributeError(object: object, attributeIsReadOnly: repr)
  }

  /// Attribute is read-only.
  public func newAttributeError(
    object: PyObject,
    attributeIsReadOnly name: String
  ) -> PyAttributeError {
    let msg = "'\(object.typeName)' object attribute \(name.quoted) is read-only"
    return self.newAttributeError(msg: msg)
  }

  // MARK: - Numeric errors

  /// Second argument to a division or modulo operation was zero.
  public func newZeroDivisionError(msg: String) -> PyZeroDivisionError {
    return PyZeroDivisionError(msg: msg)
  }

  /// Result too large to be represented.
  public func newOverflowError(msg: String) -> PyOverflowError {
    return PyOverflowError(msg: msg)
  }

  // MARK: - System

  /// Internal error in the Python interpreter.
  public func newSystemError(msg: String) -> PySystemError {
    return PySystemError(msg: msg)
  }

  // MARK: - System exit

  /// Request to exit from the interpreter.
  public func newSystemExit(code: PyObject?) -> PySystemExit {
    return PySystemExit(code: code)
  }

  // MARK: - Runtime error

  /// Unspecified run-time error.
  public func newRuntimeError(msg: String) -> PyRuntimeError {
    return PyRuntimeError(msg: msg)
  }

  // MARK: - OS error

  /// Base class for I/O related errors.
  ///
  /// https://docs.python.org/3/library/exceptions.html#OSError
  public func newOSError(msg: String) -> PyOSError {
    return PyOSError(msg: msg)
  }

  /// Base class for I/O related errors.
  ///
  /// https://docs.python.org/3/library/exceptions.html#OSError
  public func newOSError(errno: Int32) -> PyOSError {
    return self.createOSError(errno: errno, filename: nil)
  }

  /// Base class for I/O related errors.
  ///
  /// https://docs.python.org/3/library/exceptions.html#OSError
  public func newOSError(errno: Int32, filename: String) -> PyOSError {
    return self.createOSError(errno: errno, filename: filename)
  }

  /// Base class for I/O related errors.
  ///
  /// https://docs.python.org/3/library/exceptions.html#OSError
  public func newOSError(errno: Int32, path: String) -> PyOSError {
    let filename = self.fileSystem.basename(path: path)
    return self.createOSError(errno: errno, filename: filename)
  }

  /// void
  /// _PyExc_Init(PyObject *bltinmod) <-- seriously check this
  /// https://docs.python.org/3/library/exceptions.html#OSError
  private func createOSError(errno: Int32, filename: String?) -> PyOSError {
    // 'ENOENT' handles its arguments differently than other
    if errno == ENOENT {
      return self.newFileNotFoundError(filename: filename)
    }

    let args = self.createOSErrorArgs(errno: errno, filename: filename)
    switch errno {
    case EAGAIN,
         EALREADY,
         EINPROGRESS,
         EWOULDBLOCK: return PyBlockingIOError(args: args)
    case EPIPE,
         ESHUTDOWN: return PyBrokenPipeError(args: args)
    case ECHILD: return PyChildProcessError(args: args)
    case ECONNABORTED: return PyConnectionAbortedError(args: args)
    case ECONNREFUSED: return PyConnectionRefusedError(args: args)
    case ECONNRESET: return PyConnectionResetError(args: args)
    case EEXIST: return PyFileExistsError(args: args)
    case ENOENT: return PyFileNotFoundError(args: args)
    case EISDIR: return PyIsADirectoryError(args: args)
    case ENOTDIR: return PyNotADirectoryError(args: args)
    case EINTR: return PyInterruptedError(args: args)
    case EACCES,
         EPERM: return PyPermissionError(args: args)
    case ESRCH: return PyProcessLookupError(args: args)
    case ETIMEDOUT: return PyTimeoutError(args: args)
    default: return PyOSError(args: args)
    }
  }

  private func createOSErrorArgs(errno: Int32, filename: String?) -> PyTuple {
    var result = [PyObject]()
    result.append(self.newInt(errno))

    let str = String(errno: errno) ?? "unknown OS error (errno: \(errno))"
    result.append(self.newString(str))

    if let filename = filename {
      result.append(self.newString(filename))
    }

    return self.newTuple(elements: result)
  }

  // MARK: - File not found

  public func newFileNotFoundError(path: String?) -> PyFileNotFoundError {
    let filename = path.map(self.fileSystem.basename(path:))
    return self.newFileNotFoundError(filename: filename)
  }

  public func newFileNotFoundError(filename: String?) -> PyFileNotFoundError {
    var msg = "No such file or directory"

    if let f = filename {
      msg.append(" (file: \(f))")
    }

    var args = [PyObject]()
    args.append(self.newString(msg))

    if let f = filename {
      args.append(self.newString(f))
    }

    let argsTuple = self.newTuple(elements: args)
    return PyFileNotFoundError(args: argsTuple)
  }

  // MARK: - Key error

  /// Mapping key not found.
  public func newKeyError(msg: String) -> PyKeyError {
    return PyKeyError(msg: msg)
  }

  /// Mapping key not found.
  public func newKeyError(key: PyObject) -> PyKeyError {
    let args = self.newTuple(elements: key)
    return PyKeyError(args: args)
  }

  // MARK: - Lookup error

  /// Base class for lookup errors.
  public func newLookupError(msg: String) -> PyLookupError {
    return PyLookupError(msg: msg)
  }

  // MARK: - Stop iteration

  /// Signal the end from iterator.__next__().
  public func newStopIteration(value: PyObject? = nil) -> PyStopIteration {
    return PyStopIteration(value: value)
  }

  // MARK: - Name errors

  /// Name not found globally.
  public func newNameError(msg: String) -> PyNameError {
    return PyNameError(msg: msg)
  }

  /// Local name referenced but not bound to a value.
  public func newUnboundLocalError(variableName: String) -> PyUnboundLocalError {
    let msg = "local variable '\(variableName)' referenced before assignment"
    return PyUnboundLocalError(msg: msg)
  }

  // MARK: - Unicode encoding

  /// Unicode decoding error.
  public func newUnicodeDecodeError(
    data: Data,
    encoding: PyStringEncoding
  ) -> PyUnicodeDecodeError {
    let bytes = self.newBytes(data)
    return self.newUnicodeDecodeError(data: bytes, encoding: encoding)
  }

  /// Unicode decoding error.
  internal func newUnicodeDecodeError(
    data: PyBytesType,
    encoding: PyStringEncoding
  ) -> PyUnicodeDecodeError {
    let msg = "'\(encoding)' codec can't decode data"
    let error = PyUnicodeDecodeError(msg: msg)

    let dict = error.__dict__
    dict.set(id: .object, to: data)
    dict.set(id: .encoding, to: self.newString(encoding))

    return error
  }

  /// Unicode encoding error.
  public func newUnicodeEncodeError(
    string: String,
    encoding: PyStringEncoding
  ) -> PyUnicodeEncodeError {
    let str = self.newString(string)
    return self.newUnicodeEncodeError(string: str, encoding: encoding)
  }

  /// Unicode encoding error.
  public func newUnicodeEncodeError(
    string: PyString,
    encoding: PyStringEncoding
  ) -> PyUnicodeEncodeError {
    let msg = "'\(encoding)' codec can't encode data"
    let error = PyUnicodeEncodeError(msg: msg)

    let dict = error.__dict__
    dict.set(id: .object, to: string)
    dict.set(id: .encoding, to: self.newString(encoding))

    return error
  }

  // MARK: - Assertion error

  /// Assertion failed.
  public func newAssertionError(msg: String) -> PyAssertionError {
    return PyAssertionError(msg: msg)
  }

  // MARK: - Import error

  /// Import failed.
  public func newImportError(msg: String,
                             moduleName: String? = nil,
                             modulePath: String? = nil) -> PyImportError {
    return PyImportError(msg: msg,
                         moduleName: moduleName,
                         modulePath: modulePath)
  }

  // MARK: - Syntax error

  public func newSyntaxError(filename: String,
                             error: LexerError) -> PySyntaxError {
    let msg = String(describing: error.kind)
    let lineno = BigInt(error.location.line)
    let offset = BigInt(error.location.column)
    let text = String(describing: error)
    let printFileAndLine = Py.true

    switch error.kind {
    case .tooManyIndentationLevels,
         .noMatchingDedent:
      return self.newIndentationError(msg: msg,
                                      filename: filename,
                                      lineno: lineno,
                                      offset: offset,
                                      text: text,
                                      printFileAndLine: printFileAndLine)
    default:
      return self.newSyntaxError(msg: msg,
                                 filename: filename,
                                 lineno: lineno,
                                 offset: offset,
                                 text: text,
                                 printFileAndLine: printFileAndLine)
    }
  }

  public func newSyntaxError(filename: String,
                             error: ParserError) -> PySyntaxError {
    let msg = String(describing: error.kind)
    let lineno = BigInt(error.location.line)
    let offset = BigInt(error.location.column)
    let text = String(describing: error)
    let printFileAndLine = Py.true

    switch error.kind {
    case let .unexpectedToken(token, expected: expected):
      let gotUnexpectedIndent = token == .indent || token == .dedent
      let missingIndent = expected.contains { $0 == .indent || $0 == .dedent }

      guard gotUnexpectedIndent || missingIndent else {
        break
      }

      return self.newIndentationError(msg: msg,
                                      filename: filename,
                                      lineno: lineno,
                                      offset: offset,
                                      text: text,
                                      printFileAndLine: printFileAndLine)

    default:
      break
    }

    return self.newSyntaxError(msg: msg,
                               filename: filename,
                               lineno: lineno,
                               offset: offset,
                               text: text,
                               printFileAndLine: printFileAndLine)
  }

  public func newSyntaxError(filename: String,
                             error: CompilerError) -> PySyntaxError {
    let msg = String(describing: error.kind)
    let lineno = BigInt(error.location.line)
    let offset = BigInt(error.location.column)
    let text = String(describing: error)
    let printFileAndLine = Py.true

    return self.newSyntaxError(msg: msg,
                               filename: filename,
                               lineno: lineno,
                               offset: offset,
                               text: text,
                               printFileAndLine: printFileAndLine)
  }

  // swiftlint:disable:next function_parameter_count
  public func newSyntaxError(msg: String?,
                             filename: String?,
                             lineno: BigInt?,
                             offset: BigInt?,
                             text: String?,
                             printFileAndLine: PyObject?) -> PySyntaxError {
    return PySyntaxError(msg: msg,
                         filename: filename,
                         lineno: lineno,
                         offset: offset,
                         text: text,
                         printFileAndLine: printFileAndLine)
  }

  // swiftlint:disable:next function_parameter_count
  public func newSyntaxError(msg: PyString?,
                             filename: PyString?,
                             lineno: PyInt?,
                             offset: PyInt?,
                             text: PyString?,
                             printFileAndLine: PyObject?) -> PySyntaxError {
    return PySyntaxError(msg: msg,
                         filename: filename,
                         lineno: lineno,
                         offset: offset,
                         text: text,
                         printFileAndLine: printFileAndLine)
  }

  // MARK: - Indentation error

  // swiftlint:disable:next function_parameter_count
  public func newIndentationError(msg: String?,
                                  filename: String?,
                                  lineno: BigInt?,
                                  offset: BigInt?,
                                  text: String?,
                                  printFileAndLine: PyObject?) -> PySyntaxError {
    return PyIndentationError(msg: msg,
                              filename: filename,
                              lineno: lineno,
                              offset: offset,
                              text: text,
                              printFileAndLine: printFileAndLine)
  }

  // swiftlint:disable:next function_parameter_count
  public func newIndentationError(msg: PyString?,
                                  filename: PyString?,
                                  lineno: PyInt?,
                                  offset: PyInt?,
                                  text: PyString?,
                                  printFileAndLine: PyObject?) -> PySyntaxError {
    return PyIndentationError(msg: msg,
                              filename: filename,
                              lineno: lineno,
                              offset: offset,
                              text: text,
                              printFileAndLine: printFileAndLine)
  }

  // MARK: - Keyboard interrupt

  public func newKeyboardInterrupt() -> PyKeyboardInterrupt {
    return PyKeyboardInterrupt(args: self.emptyTuple)
  }

  // MARK: - Recursion

  public func newRecursionError() -> PyRecursionError {
    let msg = "maximum recursion depth exceeded"
    return PyRecursionError(msg: msg)
  }

  // MARK: - Factory from type

  /// static PyObject*
  /// _PyErr_CreateException(PyObject *exception, PyObject *value)
  public func newException(type: PyType,
                           value: PyObject?) -> PyResult<PyBaseException> {
    guard type.isException else {
      return .typeError("exceptions must derive from BaseException")
    }

    switch self.callExceptionType(type: type, arg: value) {
    case let .value(object):
      guard let exception = PyCast.asBaseException(object) else {
        let typeName = type.getName()
        let msg = "calling \(typeName) should have returned " +
                  "an instance of BaseException, not \(object.typeName)"
        return .typeError(msg)
      }

      return .value(exception)

    case let .error(e), let .notCallable(e):
      return .error(e)
    }
  }

  private func callExceptionType(type: PyType, arg: PyObject?) -> CallResult {
    guard let arg = arg else {
      return self.call(callable: type, args: [])
    }

    if arg is PyNone {
      return self.call(callable: type, args: [])
    }

    if let argTuple = PyCast.asTuple(arg) {
      return self.call(callable: type, args: argTuple.elements)
    }

    return self.call(callable: type, args: [arg])
  }

  // MARK: - Exception matches

  /// Check if a given `error` is an instance of `expectedType`.
  ///
  /// CPython:
  /// ```py
  /// int
  /// PyErr_GivenExceptionMatches(PyObject *err, PyObject *exc)
  /// ```
  ///
  /// - Parameters:
  ///   - error: Exception instance/type.
  ///   - expectedType: Exception type to check against (tuples are also allowed).
  public func exceptionMatches(error: PyObject,
                               expectedType: PyObject) -> Bool {
    if let tuple = PyCast.asTuple(expectedType) {
      return tuple.elements.contains {
        self.exceptionMatches(error: error, expectedType: $0)
      }
    }

    if let type = PyCast.asType(expectedType) {
      return self.exceptionMatches(error: error, expectedType: type)
    }

    return false
  }

  private func exceptionMatches(error: PyObject,
                                expectedType: PyType) -> Bool {
    // 'error' is a type
    if let type = PyCast.asType(error) {
      return self.exceptionMatches(type: type, expectedType: expectedType)
    }

    // 'error' is an error instance, so check its class
    return self.exceptionMatches(type: error.type, expectedType: expectedType)
  }

  /// Final version of `exceptionMatches` where we compare types.
  private func exceptionMatches(type: PyType,
                                expectedType: PyType) -> Bool {
    guard type.isException else {
      return false
    }

    guard expectedType.isException else {
      return false
    }

    return type.isSubtype(of: expectedType)
  }

  // MARK: - Context

  /// Context - another exception during whose handling this exception was raised.
  public func setContextUsingCurrentlyHandledExceptionFromDelegate(
    on exception: PyBaseException,
    overrideCurrent: Bool
  ) {
    // No current -> nothing to do
    guard let current = self.delegate.currentlyHandledException else {
      return
    }

    let hasEmptyContext = exception.getContext()?.isNone ?? true
    guard hasEmptyContext || overrideCurrent else {
      return
    }

    exception.setContext(current, checkAndPossiblyBreakCycle: true)
  }

  // MARK: - Traceback

  public func newTraceback(frame: PyFrame,
                           error: PyBaseException?) -> PyTraceback {
    let traceback = error?.getTraceback()
    return self.newTraceback(frame: frame, next: traceback)
  }

  public func newTraceback(frame: PyFrame,
                           next: PyTraceback?) -> PyTraceback {
    let instruction = self.newInt(frame.currentInstructionIndex ?? 0)
    let line = self.newInt(frame.currentInstructionLine)

    return PyTraceback(
      next: next,
      frame: frame,
      lastInstruction: instruction,
      lineNo: line
    )
  }

  /// Add traceback to given `error` using given `frame`.
  public func addTraceback(to error: PyBaseException, frame: PyFrame) {
    let current = error.getTraceback()
    let new = self.newTraceback(frame: frame, next: current)
    error.setTraceback(traceback: new)
  }
}
