import Core
import Lexer
import Parser
import Compiler
import Foundation

// In CPython:
// Objects -> exceptions.c
// Python -> errors.c
// https://docs.python.org/3.7/library/exceptions.html

// swiftlint:disable file_length

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
    hasNoAttribute name: String
  ) -> PyAttributeError {
    let quoted = self.addQuoutesIfNotPresent(name: name)
    let msg = "\(object.typeName) object has no attribute \(quoted)"
    return self.newAttributeError(msg: msg)
  }

  /// Attribute is read-only.
  public func newAttributeError(
    object: PyObject,
    attributeIsReadOnly name: String
  ) -> PyAttributeError {
    let quoted = self.addQuoutesIfNotPresent(name: name)
    let msg = "'\(object.typeName)' object attribute \(quoted) is read-only"
    return self.newAttributeError(msg: msg)
  }

  private func addQuoutesIfNotPresent(name: String) -> String {
    // This will also check for empty
    guard let first = name.first, let last = name.last else {
      return "''"
    }

    var result = name

    let quoteChar: Character
    switch first {
    case "'":
      quoteChar = "'"
    case "\"":
      quoteChar = "\""
    default:
      quoteChar = "'"
      result = "'" + result
    }

    if last != quoteChar {
      result.append(quoteChar)
    }

    return result
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

  /// Request to exit from the interpreter.
  public func newSystemExit(status: PyObject?) -> PySystemExit {
    var args = [PyObject]()
    if let s = status {
      args.append(s)
    }

    let result = PySystemExit(args: self.newTuple(args))

    let dict = result.__dict__
    let codeValue = status ?? Py.none
    self.insertOrTrap(dict: dict, key: "code", value: codeValue)

    return result
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

  public func newOSError(errno: Int32) -> PyOSError {
    let args = self.createOSErrorArgs(errno: errno, filename: nil)
    let tuple = Py.newTuple(args)
    return PyOSError(args: tuple)
  }

  /// Base class for I/O related errors.
  public func newOSError(errno: Int32, filename: String) -> PyOSError {
    let args = self.createOSErrorArgs(errno: errno, filename: filename)
    let tuple = Py.newTuple(args)
    return PyOSError(args: tuple)
  }

  /// Base class for I/O related errors.
  public func newOSError(errno: Int32, path: String) -> PyOSError {
    // If we can't get filename then we will use full path.
    // It is still better than not providing anything.
    let filename = Py.fileSystem.basename(path: path)
    return self.newOSError(errno: errno, filename: filename)
  }

  /// https://docs.python.org/3/library/exceptions.html#OSError
  private func createOSErrorArgs(errno: Int32, filename: String?) -> [PyObject] {
    var result = [PyObject]()
    result.append(Py.newInt(errno))

    let str = String(errno: errno) ?? "unknown OS error (errno: \(errno))"
    result.append(Py.newString(str))

    if let filename = filename {
      result.append(Py.newString(filename))
    }

    return result
  }

  // MARK: - File not found

  public func newFileNotFoundError() -> PyFileNotFoundError {
    let result = PyFileNotFoundError(msg: "No such file or directory")
    return result
  }

  // MARK: - Key error

  /// Mapping key not found.
  public func newKeyError(msg: String) -> PyKeyError {
    return PyKeyError(msg: msg)
  }

  /// Mapping key not found.
  public func newKeyError(key: PyObject) -> PyKeyError {
    let args = self.newTuple(key)
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
    let args = self.newTuple(value ?? Py.none)
    return PyStopIteration(args: args)
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
    let bytes = Py.newBytes(data)
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
    dict.set(id: .encoding, to: Py.newString(encoding))

    return error
  }

  /// Unicode encoding error.
  public func newUnicodeEncodeError(
    string: String,
    encoding: PyStringEncoding
  ) -> PyUnicodeEncodeError {
    let str = Py.newString(string)
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
    dict.set(id: .encoding, to: Py.newString(encoding))

    return error
  }

  // MARK: - Assertion error

  /// Assertion failed.
  public func newAssertionError(msg: String) -> PyAssertionError {
    return PyAssertionError(msg: msg)
  }

  // MARK: - Import error

  /// Import failed.
  public func newPyImportError(msg: String) -> PyImportError {
    return PyImportError(msg: msg)
  }

  // MARK: - Syntax error

  public func newSyntaxError(filename: String,
                             error: LexerError) -> PySyntaxError {
    return Py.newSyntaxError(
      filename: filename,
      line: error.location.line,
      column: error.location.column,
      text: String(describing: error)
    )
  }

  public func newSyntaxError(filename: String,
                             error: ParserError) -> PySyntaxError {
    return Py.newSyntaxError(
      filename: filename,
      line: error.location.line,
      column: error.location.column,
      text: String(describing: error)
    )
  }

  public func newSyntaxError(filename: String,
                             error: CompilerError) -> PySyntaxError {
    return Py.newSyntaxError(
      filename: filename,
      line: error.location.line,
      column: error.location.column,
      text: String(describing: error)
    )
  }

  public func newSyntaxError(filename: String,
                             line: SourceLine,
                             column: SourceColumn,
                             text: String) -> PySyntaxError {
    return self.newSyntaxError(
      filename: Py.intern(filename),
      line: Py.newInt(Int(line)),
      column: Py.newInt(Int(column)),
      text: Py.newString(text)
    )
  }

  public func newSyntaxError(filename: PyString,
                             line: PyInt,
                             column: PyInt,
                             text: PyString) -> PySyntaxError {
    let args = Py.newTuple([filename, line, column, text])
    let e = PySyntaxError(args: args)
    self.fillSyntaxErrorDict(error: e,
                             filename: filename,
                             line: line,
                             column: column,
                             text: text)
    return e
  }

  internal func fillSyntaxErrorDict(error: PyBaseException,
                                    filename: PyString,
                                    line: PyInt,
                                    column: PyInt,
                                    text: PyString) {
    let dict = error.__dict__
    insertOrTrap(dict: dict, key: "filename", value: filename)
    insertOrTrap(dict: dict, key: "lineno", value: line)
    insertOrTrap(dict: dict, key: "offset", value: column)
    insertOrTrap(dict: dict, key: "text", value: text)
    insertOrTrap(dict: dict, key: "print_file_and_line", value: Py.none)
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
      guard let exception = object as? PyBaseException else {
        let msg = "calling \(type.getName()) should have returned " +
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
      return Py.call(callable: type, args: [])
    }

    if arg is PyNone {
      return Py.call(callable: type, args: [])
    }

    if let argTuple = arg as? PyTuple {
      return Py.call(callable: type, args: argTuple.elements)
    }

    return Py.call(callable: type, args: [arg])
  }
}

extension PyInstance {

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
  ///   - expectedType: Exception type to check agains (tuples are also allowed).
  public func exceptionMatches(error: PyObject,
                               expectedType: PyObject) -> Bool {
    if let tuple = expectedType as? PyTuple {
      return tuple.elements.contains {
        self.exceptionMatches(error: error, expectedType: $0)
      }
    }

    if let type = expectedType as? PyType {
      return self.exceptionMatches(error: error, expectedType: type)
    }

    return false
  }

  private func exceptionMatches(error: PyObject,
                                expectedType: PyType) -> Bool {
    // 'error' is a type
    if let type = error as? PyType {
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
    overrideCurrentContext: Bool
  ) {
    // No current -> nothing to do
    guard let current = Py.delegate.currentlyHandledException else {
      return
    }

    let hasEmptyContext = exception.getContext()?.isNone ?? true
    guard hasEmptyContext || overrideCurrentContext else {
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
    let instruction = Py.newInt(frame.currentInstructionIndex ?? 0)
    let line = Py.newInt(frame.currentInstructionLine)

    return PyTraceback(
      next: next,
      frame: frame,
      lastInstruction: instruction,
      lineNo: line
    )
  }

  // MARK: - Helpers

  private func insertOrTrap(dict: PyDict, key: String, value: PyObject) {
    let keyObject = Py.intern(key)
    switch dict.set(key: keyObject, to: value) {
    case .ok:
      break
    case .error(let e):
      trap("Error when inserting '\(key)' to SyntaxError: \(e)")
    }
  }
}
