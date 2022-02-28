/* MARKER
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

extension PyInstance {

  // MARK: - Type error

  /// Inappropriate argument type.
  public func newTypeError(msg: String) -> PyTypeError {
    return PyMemory.newTypeError(msg: msg)
  }

  // MARK: - Value error

  /// Inappropriate argument value (of correct type).
  public func newValueError(msg: String) -> PyValueError {
    return PyMemory.newValueError(msg: msg)
  }

  // MARK: - Index error

  /// Sequence index out of range.
  public func newIndexError(msg: String) -> PyIndexError {
    return PyMemory.newIndexError(msg: msg)
  }

  // MARK: - Attribute error

  /// Attribute not found.
  public func newAttributeError(msg: String) -> PyAttributeError {
    return PyMemory.newAttributeError(msg: msg)
  }

  /// Attribute not found.
  public func newAttributeError(
    object: PyObject,
    hasNoAttribute name: PyString
  ) -> PyAttributeError {
    let repr = name.repr()
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
    let repr = name.repr()
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
    return PyMemory.newZeroDivisionError(msg: msg)
  }

  /// Result too large to be represented.
  public func newOverflowError(msg: String) -> PyOverflowError {
    return PyMemory.newOverflowError(msg: msg)
  }

  // MARK: - System

  /// Internal error in the Python interpreter.
  public func newSystemError(msg: String) -> PySystemError {
    return PyMemory.newSystemError(msg: msg)
  }

  // MARK: - System exit

  /// Request to exit from the interpreter.
  public func newSystemExit(code: PyObject?) -> PySystemExit {
    return PyMemory.newSystemExit(code: code)
  }

  // MARK: - Runtime error

  /// Unspecified run-time error.
  public func newRuntimeError(msg: String) -> PyRuntimeError {
    return PyMemory.newRuntimeError(msg: msg)
  }

  // MARK: - OS error

  /// Base class for I/O related errors.
  ///
  /// https://docs.python.org/3/library/exceptions.html#OSError
  public func newOSError(msg: String) -> PyOSError {
    return PyMemory.newOSError(msg: msg)
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
         EWOULDBLOCK: return PyMemory.newBlockingIOError(args: args)
    case EPIPE,
         ESHUTDOWN: return PyMemory.newBrokenPipeError(args: args)
    case ECHILD: return PyMemory.newChildProcessError(args: args)
    case ECONNABORTED: return PyMemory.newConnectionAbortedError(args: args)
    case ECONNREFUSED: return PyMemory.newConnectionRefusedError(args: args)
    case ECONNRESET: return PyMemory.newConnectionResetError(args: args)
    case EEXIST: return PyMemory.newFileExistsError(args: args)
    case ENOENT: return PyMemory.newFileNotFoundError(args: args)
    case EISDIR: return PyMemory.newIsADirectoryError(args: args)
    case ENOTDIR: return PyMemory.newNotADirectoryError(args: args)
    case EINTR: return PyMemory.newInterruptedError(args: args)
    case EACCES,
         EPERM: return PyMemory.newPermissionError(args: args)
    case ESRCH: return PyMemory.newProcessLookupError(args: args)
    case ETIMEDOUT: return PyMemory.newTimeoutError(args: args)
    default: return PyMemory.newOSError(args: args)
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
    return PyMemory.newFileNotFoundError(args: argsTuple)
  }

  // MARK: - Key error

  /// Mapping key not found or duplicate entry when updating.
  public func newKeyError(msg: String) -> PyKeyError {
    return PyMemory.newKeyError(msg: msg)
  }

  /// Mapping key not found or duplicate entry when updating.
  public func newKeyError(key: PyObject) -> PyKeyError {
    let args = self.newTuple(key)
    return PyMemory.newKeyError(args: args)
  }

  // MARK: - Lookup error

  /// Base class for lookup errors.
  public func newLookupError(msg: String) -> PyLookupError {
    return PyMemory.newLookupError(msg: msg)
  }

  // MARK: - Stop iteration

  /// Signal the end from iterator.__next__().
  public func newStopIteration(value: PyObject? = nil) -> PyStopIteration {
    return PyMemory.newStopIteration(value: value)
  }

  // MARK: - Name errors

  /// Name not found globally.
  public func newNameError(msg: String) -> PyNameError {
    return PyMemory.newNameError(msg: msg)
  }

  /// Local name referenced but not bound to a value.
  public func newUnboundLocalError(variableName: String) -> PyUnboundLocalError {
    let msg = "local variable '\(variableName)' referenced before assignment"
    return PyMemory.newUnboundLocalError(msg: msg)
  }

  // MARK: - Unicode encoding

  /// Unicode decoding error.
  public func newUnicodeDecodeError(
    data: Data,
    encoding: PyString.Encoding
  ) -> PyUnicodeDecodeError {
    let bytes = self.newBytes(data)
    return self.newUnicodeDecodeError(bytes: bytes, encoding: encoding)
  }

  /// Unicode decoding error.
  internal func newUnicodeDecodeError(
    bytes: PyBytes,
    encoding: PyString.Encoding
  ) -> PyUnicodeDecodeError {
    return self.newUnicodeDecodeError(bytes: .init(bytes: bytes), encoding: encoding)
  }

  /// Unicode decoding error.
  internal func newUnicodeDecodeError(
    bytearray: PyByteArray,
    encoding: PyString.Encoding
  ) -> PyUnicodeDecodeError {
    return self.newUnicodeDecodeError(bytes: .init(bytearray: bytearray), encoding: encoding)
  }

  /// Unicode decoding error.
  internal func newUnicodeDecodeError(
    bytes: PyAnyBytes,
    encoding: PyString.Encoding
  ) -> PyUnicodeDecodeError {
    let msg = "'\(encoding)' codec can't decode data"
    let error = PyMemory.newUnicodeDecodeError(msg: msg)

    let dict = error.__dict__
    dict.set(id: .object, to: bytes.object)
    dict.set(id: .encoding, to: self.newString(encoding))

    return error
  }

  /// Unicode encoding error.
  public func newUnicodeEncodeError(
    string: String,
    encoding: PyString.Encoding
  ) -> PyUnicodeEncodeError {
    let str = self.newString(string)
    return self.newUnicodeEncodeError(string: str, encoding: encoding)
  }

  /// Unicode encoding error.
  public func newUnicodeEncodeError(
    string: PyString,
    encoding: PyString.Encoding
  ) -> PyUnicodeEncodeError {
    let msg = "'\(encoding)' codec can't encode data"
    let error = PyMemory.newUnicodeEncodeError(msg: msg)

    let dict = error.__dict__
    dict.set(id: .object, to: string)
    dict.set(id: .encoding, to: self.newString(encoding))

    return error
  }

  // MARK: - Assertion error

  /// Assertion failed.
  public func newAssertionError(msg: String) -> PyAssertionError {
    return PyMemory.newAssertionError(msg: msg)
  }

  // MARK: - Import error

  /// Import failed.
  public func newImportError(msg: String,
                             moduleName: String?,
                             modulePath: Path?) -> PyImportError {
    return self.newImportError(msg: msg,
                               moduleName: moduleName,
                               modulePath: modulePath?.string)
  }

  /// Import failed.
  public func newImportError(msg: String,
                             moduleName: String? = nil,
                             modulePath: String? = nil) -> PyImportError {
    return PyMemory.newImportError(msg: msg,
                                   moduleName: moduleName,
                                   modulePath: modulePath)
  }

  // MARK: - EOF error

  public func newEOFError(msg: String) -> PyEOFError {
    return PyMemory.newEOFError(msg: msg)
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
    return PyMemory.newSyntaxError(msg: msg,
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
    return PyMemory.newSyntaxError(msg: msg,
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
    return PyMemory.newIndentationError(msg: msg,
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
    return PyMemory.newIndentationError(msg: msg,
                                        filename: filename,
                                        lineno: lineno,
                                        offset: offset,
                                        text: text,
                                        printFileAndLine: printFileAndLine)
  }

  // MARK: - Keyboard interrupt

  public func newKeyboardInterrupt() -> PyKeyboardInterrupt {
    return PyMemory.newKeyboardInterrupt(args: self.emptyTuple)
  }

  // MARK: - Recursion

  public func newRecursionError() -> PyRecursionError {
    let msg = "maximum recursion depth exceeded"
    return PyMemory.newRecursionError(msg: msg)
  }

  // MARK: - Factory from type

  /// static PyObject*
  /// _PyErr_CreateException(PyObject *exception, PyObject *value)
  public func newException(type: PyType,
                           arg: PyObject?) -> PyResult<PyBaseException> {
    guard type.isException else {
      return .typeError("exceptions must derive from BaseException")
    }

    switch self.callExceptionType(type: type, arg: arg) {
    case let .value(object):
      guard let exception = PyCast.asBaseException(object) else {
        let typeName = type.getNameString()
        let msg = "calling \(typeName) should have returned " +
          "an instance of BaseException, not \(object.typeName)"
        return .typeError(msg)
      }

      return .value(exception)

    case let .error(e),
         let .notCallable(e):
      return .error(e)
    }
  }

  private func callExceptionType(type: PyType, arg: PyObject?) -> CallResult {
    guard let arg = arg else {
      return self.call(callable: type, args: [])
    }

    if PyCast.isNone(arg) {
      return self.call(callable: type, args: [])
    }

    if let argTuple = PyCast.asTuple(arg) {
      return self.call(callable: type, args: argTuple.elements)
    }

    return self.call(callable: type, args: [arg])
  }
}

*/