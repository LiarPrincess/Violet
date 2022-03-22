import Foundation
import BigInt
import FileSystem
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

extension Py {

  // MARK: - Type error

  /// Inappropriate argument type.
  public func newTypeError(message: String) -> PyTypeError {
    let type = self.errorTypes.typeError
    let args = self.createErrorArgs(message: message)
    return self.memory.newTypeError(self, type: type, args: args)
  }

  public func newInvalidSelfArgumentError(object: PyObject,
                                          expectedType expected: String,
                                          fnName: String) -> PyTypeError {
    let got = object.typeName
    let message = "descriptor '\(fnName)' requires a '\(expected)' object but received a '\(got)'"
    return self.newTypeError(message: message)
  }

  // MARK: - Value error

  /// Inappropriate argument value (of correct type).
  public func newValueError(message: String) -> PyValueError {
    let type = self.errorTypes.valueError
    let args = self.createErrorArgs(message: message)
    return self.memory.newValueError(self, type: type, args: args)
  }

  // MARK: - Index error

  /// Sequence index out of range.
  public func newIndexError(message: String) -> PyIndexError {
    let type = self.errorTypes.indexError
    let args = self.createErrorArgs(message: message)
    return self.memory.newIndexError(self, type: type, args: args)
  }

  // MARK: - Attribute error

  /// Attribute not found.
  public func newAttributeError(message: String) -> PyAttributeError {
    let type = self.errorTypes.attributeError
    let args = self.createErrorArgs(message: message)
    return self.memory.newAttributeError(self, type: type, args: args)
  }

  /// Attribute not found.
  public func newAttributeError(object: PyObject,
                                hasNoAttribute name: PyString) -> PyAttributeError {
    let repr = name.repr()
    return self.newAttributeError(object: object, hasNoAttribute: repr)
  }

  /// Attribute not found.
  public func newAttributeError(object: PyObject,
                                hasNoAttribute name: String) -> PyAttributeError {
    let message = "\(object.typeName) object has no attribute \(name.quoted)"
    return self.newAttributeError(message: message)
  }


  /// Attribute is read-only.
  public func newAttributeError(object: PyObject,
                                attributeIsReadOnly name: PyString) -> PyAttributeError {
    let repr = name.repr()
    return self.newAttributeError(object: object, attributeIsReadOnly: repr)
  }

  /// Attribute is read-only.
  public func newAttributeError(object: PyObject,
                                attributeIsReadOnly name: String) -> PyAttributeError {
    let message = "'\(object.typeName)' object attribute \(name.quoted) is read-only"
    return self.newAttributeError(message: message)
  }

  // MARK: - Numeric errors

  /// Second argument to a division or modulo operation was zero.
  public func newZeroDivisionError(message: String) -> PyZeroDivisionError {
    let type = self.errorTypes.zeroDivisionError
    let args = self.createErrorArgs(message: message)
    return self.memory.newZeroDivisionError(self, type: type, args: args)
  }

  /// Result too large to be represented.
  public func newOverflowError(message: String) -> PyOverflowError {
    let type = self.errorTypes.overflowError
    let args = self.createErrorArgs(message: message)
    return self.memory.newOverflowError(self, type: type, args: args)
  }

  // MARK: - System

  /// Internal error in the Python interpreter.
  public func newSystemError(message: String) -> PySystemError {
    let type = self.errorTypes.systemError
    let args = self.createErrorArgs(message: message)
    return self.memory.newSystemError(self, type: type, args: args)
  }

  // MARK: - System exit

  /// Request to exit from the interpreter.
  public func newSystemExit(code: PyObject?) -> PySystemExit {
    let type = self.errorTypes.systemExit
    return self.memory.newSystemExit(self, type: type, code: code)
  }

  // MARK: - Runtime error

  /// Unspecified run-time error.
  public func newRuntimeError(message: String) -> PyRuntimeError {
    let type = self.errorTypes.runtimeError
    let args = self.createErrorArgs(message: message)
    return self.memory.newRuntimeError(self, type: type, args: args)
  }

  // MARK: - OS error

  /// Base class for I/O related errors.
  ///
  /// https://docs.python.org/3/library/exceptions.html#OSError
  public func newOSError(message: String) -> PyOSError {
    let type = self.errorTypes.osError
    let args = self.createErrorArgs(message: message)
    return self.memory.newOSError(self, type: type, args: args)
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
  public func newOSError(errno: Int32, filename: Filename) -> PyOSError {
    return self.createOSError(errno: errno, filename: filename.string)
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
  public func newOSError(errno: Int32, path: Path) -> PyOSError {
    let filename = self.fileSystem.basename(path: path)
    return self.newOSError(errno: errno, filename: filename)
  }

  /// Base class for I/O related errors.
  ///
  /// https://docs.python.org/3/library/exceptions.html#OSError
  public func newOSError(errno: Int32, path: String) -> PyOSError {
    let p = Path(string: path)
    return self.newOSError(errno: errno, path: p)
  }

  /// void
  /// _PyExc_Init(PyObject *bltinmod) <-- seriously check this
  ///
  /// https://docs.python.org/3/library/exceptions.html#OSError
  private func createOSError(errno: Int32, filename: String?) -> PyOSError {
    // 'ENOENT' handles its arguments differently than other
    if errno == ENOENT {
      let error = self.newFileNotFoundError(filename: filename)
      return self.asOSError(error)
    }

    let args = self.createOSErrorArgs(errno: errno, filename: filename)
    switch errno {
    case EAGAIN,
         EALREADY,
         EINPROGRESS,
         EWOULDBLOCK:
      let error = self.newBlockingIOError(args: args)
      return self.asOSError(error)
    case EPIPE,
         ESHUTDOWN:
      let error = self.newBrokenPipeError(args: args)
      return self.asOSError(error)
    case ECHILD:
      let error = self.newChildProcessError(args: args)
      return self.asOSError(error)
    case ECONNABORTED:
      let error = self.newConnectionAbortedError(args: args)
      return self.asOSError(error)
    case ECONNREFUSED:
      let error = self.newConnectionRefusedError(args: args)
      return self.asOSError(error)
    case ECONNRESET:
      let error = self.newConnectionResetError(args: args)
      return self.asOSError(error)
    case EEXIST:
      let error = self.newFileExistsError(args: args)
      return self.asOSError(error)
    case ENOENT:
      let error = self.newFileNotFoundError(args: args)
      return self.asOSError(error)
    case EISDIR:
      let error = self.newIsADirectoryError(args: args)
      return self.asOSError(error)
    case ENOTDIR:
      let error = self.newNotADirectoryError(args: args)
      return self.asOSError(error)
    case EINTR:
      let error = self.newInterruptedError(args: args)
      return self.asOSError(error)
    case EACCES,
         EPERM:
      let error = self.newPermissionError(args: args)
      return self.asOSError(error)
    case ESRCH:
      let error = self.newProcessLookupError(args: args)
      return self.asOSError(error)
    case ETIMEDOUT:
      let error = self.newTimeoutError(args: args)
      return self.asOSError(error)
    default:
      let error = self.newOSError(args: args)
      return self.asOSError(error)
    }
  }

  private func newBlockingIOError(args: PyTuple) -> PyBlockingIOError {
    let type = self.errorTypes.blockingIOError
    return self.memory.newBlockingIOError(self, type: type, args: args)
  }

  private func newBrokenPipeError(args: PyTuple) -> PyBrokenPipeError {
    let type = self.errorTypes.brokenPipeError
    return self.memory.newBrokenPipeError(self, type: type, args: args)
  }

  private func newChildProcessError(args: PyTuple) -> PyChildProcessError {
    let type = self.errorTypes.childProcessError
    return self.memory.newChildProcessError(self, type: type, args: args)
  }

  private func newConnectionAbortedError(args: PyTuple) -> PyConnectionAbortedError {
    let type = self.errorTypes.connectionAbortedError
    return self.memory.newConnectionAbortedError(self, type: type, args: args)
  }

  private func newConnectionRefusedError(args: PyTuple) -> PyConnectionRefusedError {
    let type = self.errorTypes.connectionRefusedError
    return self.memory.newConnectionRefusedError(self, type: type, args: args)
  }

  private func newConnectionResetError(args: PyTuple) -> PyConnectionResetError {
    let type = self.errorTypes.connectionResetError
    return self.memory.newConnectionResetError(self, type: type, args: args)
  }

  private func newFileExistsError(args: PyTuple) -> PyFileExistsError {
    let type = self.errorTypes.fileExistsError
    return self.memory.newFileExistsError(self, type: type, args: args)
  }

  private func newFileNotFoundError(args: PyTuple) -> PyFileNotFoundError {
    let type = self.errorTypes.fileNotFoundError
    return self.memory.newFileNotFoundError(self, type: type, args: args)
  }

  private func newIsADirectoryError(args: PyTuple) -> PyIsADirectoryError {
    let type = self.errorTypes.isADirectoryError
    return self.memory.newIsADirectoryError(self, type: type, args: args)
  }

  private func newNotADirectoryError(args: PyTuple) -> PyNotADirectoryError {
    let type = self.errorTypes.notADirectoryError
    return self.memory.newNotADirectoryError(self, type: type, args: args)
  }

  private func newInterruptedError(args: PyTuple) -> PyInterruptedError {
    let type = self.errorTypes.interruptedError
    return self.memory.newInterruptedError(self, type: type, args: args)
  }

  private func newPermissionError(args: PyTuple) -> PyPermissionError {
    let type = self.errorTypes.permissionError
    return self.memory.newPermissionError(self, type: type, args: args)
  }

  private func newProcessLookupError(args: PyTuple) -> PyProcessLookupError {
    let type = self.errorTypes.processLookupError
    return self.memory.newProcessLookupError(self, type: type, args: args)
  }

  private func newTimeoutError(args: PyTuple) -> PyTimeoutError {
    let type = self.errorTypes.timeoutError
    return self.memory.newTimeoutError(self, type: type, args: args)
  }

  private func newOSError(args: PyTuple) -> PyOSError {
    let type = self.errorTypes.osError
    return self.memory.newOSError(self, type: type, args: args)
  }

  private func createOSErrorArgs(errno: Int32, filename: String?) -> PyTuple {
    var result = [PyObject]()

    let errnoObject = self.newInt(errno)
    result.append(errnoObject.asObject)

    let str = String(errno: errno) ?? "unknown OS error (errno: \(errno))"
    let strObject = self.newString(str)
    result.append(strObject.asObject)

    if let filename = filename {
      let filenameObject = self.newString(filename)
      result.append(filenameObject.asObject)
    }

    return self.newTuple(elements: result)
  }

  private func asOSError<T: PyErrorMixin>(_ error: T) -> PyOSError {
    return PyOSError(ptr: error.ptr)
  }

  // MARK: - File not found

  public func newFileNotFoundError(path: Path?) -> PyFileNotFoundError {
    let basename = path.map(self.fileSystem.basename(path:))
    return self.newFileNotFoundError(filename: basename)
  }

  public func newFileNotFoundError(path: String?) -> PyFileNotFoundError {
    let p = path.map(Path.init(string:))
    return self.newFileNotFoundError(path: p)
  }

  public func newFileNotFoundError(filename: Filename?) -> PyFileNotFoundError {
    return self.newFileNotFoundError(filename: filename?.string)
  }

  public func newFileNotFoundError(filename: String?) -> PyFileNotFoundError {
    var message = "No such file or directory"

    if let f = filename {
      message.append(" (file: \(f))")
    }

    var args = [PyObject]()

    let messageObject = self.newString(message)
    args.append(messageObject.asObject)

    if let filename = filename {
      let filenameObject = self.newString(filename)
      args.append(filenameObject.asObject)
    }

    let argsTuple = self.newTuple(elements: args)
    let type = self.errorTypes.fileNotFoundError

    return self.memory.newFileNotFoundError(self, type: type, args: argsTuple)
  }

  // MARK: - Key error

  /// Mapping key not found or duplicate entry when updating.
  public func newKeyError(message: String) -> PyKeyError {
    let args = self.createErrorArgs(message: message)
    return self.createKeyError(args: args)
  }

  /// Mapping key not found or duplicate entry when updating.
  public func newKeyError(key: PyObject) -> PyKeyError {
    let args = self.newTuple(elements: key)
    return self.createKeyError(args: args)
  }

  private func createKeyError(args: PyTuple) -> PyKeyError {
    let type = self.errorTypes.keyError
    return self.memory.newKeyError(self, type: type, args: args)
  }

  // MARK: - Lookup error

  /// Base class for lookup errors.
  public func newLookupError(message: String) -> PyLookupError {
    let type = self.errorTypes.lookupError
    let args = self.createErrorArgs(message: message)
    return self.memory.newLookupError(self, type: type, args: args)
  }

  // MARK: - Stop iteration

  /// Signal the end from iterator.__next__().
  public func newStopIteration(value: PyObject?) -> PyStopIteration {
    let type = self.errorTypes.stopIteration
    let valueArg = value?.asObject ?? self.none.asObject
    return self.memory.newStopIteration(self, type: type, value: valueArg)
  }

  // MARK: - Name errors

  /// Name not found globally.
  public func newNameError(message: String) -> PyNameError {
    let type = self.errorTypes.nameError
    let args = self.createErrorArgs(message: message)
    return self.memory.newNameError(self, type: type, args: args)
  }

  /// Local name referenced but not bound to a value.
  public func newUnboundLocalError(variableName: String) -> PyUnboundLocalError {
    let message = "local variable '\(variableName)' referenced before assignment"
    let args = self.createErrorArgs(message: message)
    let type = self.errorTypes.unboundLocalError
    return self.memory.newUnboundLocalError(self, type: type, args: args)
  }

  // MARK: - Unicode encoding

  /// Unicode decoding error.
  public func newUnicodeDecodeError(data: Data,
                                    encoding: PyString.Encoding) -> PyUnicodeDecodeError {
    let bytes = self.newBytes(data)
    return self.newUnicodeDecodeError(bytes: bytes, encoding: encoding)
  }

  /// Unicode decoding error.
  internal func newUnicodeDecodeError(bytes: PyBytes,
                                      encoding: PyString.Encoding) -> PyUnicodeDecodeError {
    return self.newUnicodeDecodeError(bytes: .init(bytes: bytes), encoding: encoding)
  }

  /// Unicode decoding error.
  internal func newUnicodeDecodeError(bytearray: PyByteArray,
                                      encoding: PyString.Encoding) -> PyUnicodeDecodeError {
    return self.newUnicodeDecodeError(bytes: .init(bytearray: bytearray), encoding: encoding)
  }

  /// Unicode decoding error.
  internal func newUnicodeDecodeError(bytes: PyAnyBytes,
                                      encoding: PyString.Encoding) -> PyUnicodeDecodeError {
    let message = "'\(encoding)' codec can't decode data"
    let args = self.createErrorArgs(message: message)
    let type = self.errorTypes.unicodeDecodeError
    let error = self.memory.newUnicodeDecodeError(self, type: type, args: args)

    let dict = error.asBaseException.getDict(self)
    dict.set(self, id: .object, value: bytes.asObject)

    let encodingString = self.toString(encoding: encoding)
    dict.set(self, id: .encoding, value: encodingString.asObject)

    return error
  }

  /// Unicode encoding error.
  public func newUnicodeEncodeError(string: String,
                                    encoding: PyString.Encoding) -> PyUnicodeEncodeError {
    let str = self.newString(string)
    return self.newUnicodeEncodeError(string: str, encoding: encoding)
  }

  /// Unicode encoding error.
  public func newUnicodeEncodeError(string: PyString,
                                    encoding: PyString.Encoding) -> PyUnicodeEncodeError {
    let message = "'\(encoding)' codec can't encode data"
    let args = self.createErrorArgs(message: message)
    let type = self.errorTypes.unicodeEncodeError
    let error = self.memory.newUnicodeEncodeError(self, type: type, args: args)

    let dict = error.asBaseException.getDict(self)
    dict.set(self, id: .object, value: string.asObject)

    let encodingString = self.toString(encoding: encoding)
    dict.set(self, id: .encoding, value: encodingString.asObject)

    return error
  }

  private func toString(encoding: PyString.Encoding) -> PyString {
    return self.intern(string: encoding.description)
  }

  // MARK: - Assertion error

  /// Assertion failed.
  public func newAssertionError(message: String) -> PyAssertionError {
    let type = self.errorTypes.assertionError
    let args = self.createErrorArgs(message: message)
    return self.memory.newAssertionError(self, type: type, args: args)
  }

  // MARK: - Import error

  /// Import failed.
  public func newImportError(message: String,
                             moduleName: String?,
                             modulePath: Path?) -> PyImportError {
    return self.newImportError(message: message,
                               moduleName: moduleName,
                               modulePath: modulePath?.string)
  }

  /// Import failed.
  public func newImportError(message: String,
                             moduleName: String? = nil,
                             modulePath: String? = nil) -> PyImportError {
    let messageObject = self.newString(message)
    let moduleNameObject = moduleName.map(self.newString(_:))
    let modulePathObject = modulePath.map(self.newString(_:))
    let type = self.errorTypes.importError
    return self.memory.newImportError(self,
                                      type: type,
                                      msg: messageObject.asObject,
                                      moduleName: moduleNameObject?.asObject,
                                      modulePath: modulePathObject?.asObject)
  }

  // MARK: - EOF error

  public func newEOFError(message: String) -> PyEOFError {
    let type = self.errorTypes.eofError
    let args = self.createErrorArgs(message: message)
    return self.memory.newEOFError(self, type: type, args: args)
  }

  // MARK: - Syntax error

  public func newSyntaxError(filename: String, error: LexerError) -> PySyntaxError {
    let message = String(describing: error.kind)
    let lineno = BigInt(error.location.line)
    let offset = BigInt(error.location.column)
    let text = String(describing: error)
    let printFileAndLine = true

    switch error.kind {
    case .tooManyIndentationLevels,
         .noMatchingDedent:
      let error = self.newIndentationError(message: message,
                                           filename: filename,
                                           lineno: lineno,
                                           offset: offset,
                                           text: text,
                                           printFileAndLine: printFileAndLine)
      return PySyntaxError(ptr: error.ptr)
    default:
      return self.newSyntaxError(message: message,
                                 filename: filename,
                                 lineno: lineno,
                                 offset: offset,
                                 text: text,
                                 printFileAndLine: printFileAndLine)
    }
  }

  public func newSyntaxError(filename: String, error: ParserError) -> PySyntaxError {
    let message = String(describing: error.kind)
    let lineno = BigInt(error.location.line)
    let offset = BigInt(error.location.column)
    let text = String(describing: error)
    let printFileAndLine = true

    switch error.kind {
    case let .unexpectedToken(token, expected: expected):
      let gotUnexpectedIndent = token == .indent || token == .dedent
      let missingIndent = expected.contains { $0 == .indent || $0 == .dedent }

      guard gotUnexpectedIndent || missingIndent else {
        break
      }

      let error = self.newIndentationError(message: message,
                                           filename: filename,
                                           lineno: lineno,
                                           offset: offset,
                                           text: text,
                                           printFileAndLine: printFileAndLine)

      return PySyntaxError(ptr: error.ptr)

    default:
      break
    }

    return self.newSyntaxError(message: message,
                               filename: filename,
                               lineno: lineno,
                               offset: offset,
                               text: text,
                               printFileAndLine: printFileAndLine)
  }

  public func newSyntaxError(filename: String, error: CompilerError) -> PySyntaxError {
    let message = String(describing: error.kind)
    let lineno = BigInt(error.location.line)
    let offset = BigInt(error.location.column)
    let text = String(describing: error)
    let printFileAndLine = true

    return self.newSyntaxError(message: message,
                               filename: filename,
                               lineno: lineno,
                               offset: offset,
                               text: text,
                               printFileAndLine: printFileAndLine)
  }

  // swiftlint:disable:next function_parameter_count
  public func newSyntaxError(message: String?,
                             filename: String?,
                             lineno: BigInt?,
                             offset: BigInt?,
                             text: String?,
                             printFileAndLine: Bool?) -> PySyntaxError {
    let messageObject = message.map(self.newString(_:))
    let filenameObject = filename.map(self.newString(_:))
    let linenoObject = lineno.map(self.newInt(_:))
    let offsetObject = offset.map(self.newInt(_:))
    let textObject = text.map(self.newString(_:))
    let printFileAndLineObject = printFileAndLine.map(self.newBool(_:))

    return self.newSyntaxError(message: messageObject,
                               filename: filenameObject,
                               lineno: linenoObject,
                               offset: offsetObject,
                               text: textObject,
                               printFileAndLine: printFileAndLineObject)
  }

  // swiftlint:disable:next function_parameter_count
  public func newSyntaxError(message: PyString?,
                             filename: PyString?,
                             lineno: PyInt?,
                             offset: PyInt?,
                             text: PyString?,
                             printFileAndLine: PyBool?) -> PySyntaxError {
    let type = self.errorTypes.syntaxError
    return self.memory.newSyntaxError(self,
                                      type: type,
                                      msg: message?.asObject,
                                      filename: filename?.asObject,
                                      lineno: lineno?.asObject,
                                      offset: offset?.asObject,
                                      text: text?.asObject,
                                      printFileAndLine: printFileAndLine?.asObject)
  }

  // MARK: - Indentation error

  // swiftlint:disable:next function_parameter_count
  public func newIndentationError(message: String?,
                                  filename: String?,
                                  lineno: BigInt?,
                                  offset: BigInt?,
                                  text: String?,
                                  printFileAndLine: Bool?) -> PyIndentationError {
    let _message = message.map(self.newString(_:))
    let _filename = filename.map(self.newString(_:))
    let _lineno = lineno.map(self.newInt(_:))
    let _offset = offset.map(self.newInt(_:))
    let _text = text.map(self.newString(_:))
    let _printFileAndLine = printFileAndLine.map(self.newBool(_:))
    return self.newIndentationError(message: _message,
                                    filename: _filename,
                                    lineno: _lineno,
                                    offset: _offset,
                                    text: _text,
                                    printFileAndLine: _printFileAndLine)
  }

  // swiftlint:disable:next function_parameter_count
  public func newIndentationError(message: PyString?,
                                  filename: PyString?,
                                  lineno: PyInt?,
                                  offset: PyInt?,
                                  text: PyString?,
                                  printFileAndLine: PyBool?) -> PyIndentationError {
    let type = self.errorTypes.indentationError
    return self.memory.newIndentationError(self,
                                           type: type,
                                           msg: message?.asObject,
                                           filename: filename?.asObject,
                                           lineno: lineno?.asObject,
                                           offset: offset?.asObject,
                                           text: text?.asObject,
                                           printFileAndLine: printFileAndLine?.asObject)
  }

  // MARK: - Keyboard interrupt

  public func newKeyboardInterrupt() -> PyKeyboardInterrupt {
    let args = self.emptyTuple
    let type = self.errorTypes.keyboardInterrupt
    return self.memory.newKeyboardInterrupt(self, type: type, args: args)
  }

  // MARK: - Recursion

  public func newRecursionError() -> PyRecursionError {
    let message = self.intern(string: "maximum recursion depth exceeded")
    let args = self.createErrorArgs(message: message)
    let type = self.errorTypes.recursionError
    return self.memory.newRecursionError(self, type: type, args: args)
  }

  // MARK: - Factory from type

  /// static PyObject*
  /// _PyErr_CreateException(PyObject *exception, PyObject *value)
  public func newException(type: PyType, arg: PyObject?) -> PyResultGen<PyBaseException> {
    guard self.isException(type: type) else {
      return .typeError(self, message: "exceptions must derive from BaseException")
    }

    switch self.callExceptionType(type: type, arg: arg) {
    case let .value(object):
      guard let exception = self.cast.asBaseException(object) else {
        let typeName = type.getNameString()
        let message = "calling \(typeName) should have returned " +
          "an instance of BaseException, not \(object.typeName)"
        return .typeError(self, message: message)
      }

      return .value(exception)

    case let .error(e),
         let .notCallable(e):
      return .error(e)
    }
  }

  private func callExceptionType(type: PyType, arg: PyObject?) -> CallResult {
    let typeObject = type.asObject

    guard let arg = arg else {
      return self.call(callable: typeObject, args: [])
    }

    if self.cast.isNone(arg) {
      return self.call(callable: typeObject, args: [])
    }

    if let argTuple = self.cast.asTuple(arg) {
      return self.call(callable: typeObject, args: argTuple.elements)
    }

    return self.call(callable: typeObject, args: [arg])
  }

  // MARK: - Helpers

  internal func createErrorArgs(message: String) -> PyTuple {
    let object = self.newString(message)
    return self.newTuple(elements: object.asObject)
  }

  internal func createErrorArgs(message: PyString) -> PyTuple {
    return self.newTuple(elements: message.asObject)
  }
}
