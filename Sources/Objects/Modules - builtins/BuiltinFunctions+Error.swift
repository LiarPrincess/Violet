import Core
import Foundation

// In CPython:
// Objects -> exceptions.c
// Python -> errors.c
// https://docs.python.org/3.7/library/exceptions.html

extension BuiltinFunctions {

  // MARK: - New

  /// Inappropriate argument type.
  public func newTypeError(msg: String) -> PyTypeError {
    return PyTypeError(msg: msg)
  }

  /// Inappropriate argument value (of correct type).
  public func newValueError(msg: String) -> PyValueError {
    return PyValueError(msg: msg)
  }

  /// Sequence index out of range.
  public func newIndexError(msg: String) -> PyIndexError {
    return PyIndexError(msg: msg)
  }

  /// Attribute not found.
  public func newAttributeError(msg: String) -> PyAttributeError {
    return PyAttributeError(msg: msg)
  }

  /// Attribute not found.
  public func newAttributeError(
    object: PyObject,
    hasNoAttribute name: String
  ) -> PyAttributeError {
    let msg = "\(object.typeName) object has no attribute '\(name)'"
    return self.newAttributeError(msg: msg)
  }

  /// Attribute is read-only.
  public func newAttributeError(
    object: PyObject,
    attributeIsReadOnly name: String
  ) -> PyAttributeError {
    let msg = "'\(object.typeName)' object attribute '\(name)' is read-only"
    return self.newAttributeError(msg: msg)
  }

  /// Second argument to a division or modulo operation was zero.
  public func newZeroDivisionError(msg: String) -> PyZeroDivisionError {
    return PyZeroDivisionError(msg: msg)
  }

  /// Result too large to be represented.
  public func newOverflowError(msg: String) -> PyOverflowError {
    return PyOverflowError(msg: msg)
  }

  /// Internal error in the Python interpreter.
  public func newSystemError(msg: String) -> PySystemError {
    return PySystemError(msg: msg)
  }

  /// Name not found globally.
  public func newNameError(msg: String) -> PyNameError {
    return PyNameError(msg: msg)
  }

  /// Unspecified run-time error.
  public func newRuntimeError(msg: String) -> PyRuntimeError {
    return PyRuntimeError(msg: msg)
  }

  /// Base class for warnings about deprecated features.
  public func newDeprecationWarning(msg: String) -> PyDeprecationWarning {
    return PyDeprecationWarning(msg: msg)
  }

  /// Base class for lookup errors.
  public func newLookupError(msg: String) -> PyLookupError {
    return PyLookupError(msg: msg)
  }

  /// Base class for I/O related errors.
  public func newOSError(msg: String) -> PyOSError {
    return PyOSError(msg: msg)
  }

  /// Mapping key not found.
  public func newKeyError(msg: String) -> PyKeyError {
    return PyKeyError(msg: msg)
  }

  /// Mapping key not found.
  public func newKeyError(key: PyObject) -> PyKeyError {
    let args = self.newTuple(key)
    return PyKeyError(args: args)
  }

  /// Signal the end from iterator.__next__().
  public func newStopIteration(value: PyObject? = nil) -> PyStopIteration {
    let args = self.newTuple(value ?? Py.none)
    return PyStopIteration(args: args)
  }

  /// Local name referenced but not bound to a value.
  public func newUnboundLocalError(variableName: String) -> PyUnboundLocalError {
    let msg = "local variable '\(variableName)' referenced before assignment"
    return PyUnboundLocalError(msg: msg)
  }

  /// Unicode decoding error.
  public func newUnicodeDecodeError(encoding: PyStringEncoding,
                                    data: Data) -> PyUnicodeDecodeError {
    let msg = "'\(encoding)' codec can't decode data"
    return PyUnicodeDecodeError(msg: msg)
  }

  /// Unicode encoding error.
  public func newUnicodeEncodeError(encoding: PyStringEncoding,
                                    string: String) -> PyUnicodeEncodeError {
    let msg = "'\(encoding)' codec can't encode data"
    return PyUnicodeEncodeError(msg: msg)
  }

  /// Assertion failed.
  public func newAssertionError(msg: String) -> PyAssertionError {
    return PyAssertionError(msg: msg)
  }

  /// Import failed.
  public func newPyImportError(msg: String) -> PyImportError {
    return PyImportError(msg: msg)
  }

  public func newSyntaxError(filename: String,
                             location: SourceLocation,
                             text: String) -> PySyntaxError {
    return self.newSyntaxError(filename: filename,
                               line: location.line,
                               offset: location.column,
                               text: String(describing: text))
  }

  public func newSyntaxError(filename: String,
                             line: SourceLine,
                             offset: SourceColumn,
                             text: String) -> PySyntaxError {
    let filenameObject = Py.newString(filename)
    let lineObject = Py.newInt(Int(line))
    let offsetObject = Py.newInt(Int(offset))
    let textObject = Py.newString(text)

    let args = Py.newTuple([filenameObject, lineObject, offsetObject, textObject])
    let e = PySyntaxError(args: args)

    let dict = e.__dict__
    dict.set(id: .filename, to: filenameObject)
    dict.set(id: .lineno, to: lineObject)
    dict.set(id: .offset, to: offsetObject)
    dict.set(id: .text, to: textObject)

    return e
  }

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

// MARK: - Warn

public enum WarningType {
  case `import`
  case deprecation
}

extension BuiltinFunctions {

  public func warn(type: WarningType, msg: String) -> PyBaseException? {
    // TODO: Finish warnings
    return nil
  }

  // MARK: - Exception matches

  /// Check if a given `error` is an instance of `exceptionType`.
  ///
  /// CPython:
  /// ```py
  /// int
  /// PyErr_GivenExceptionMatches(PyObject *err, PyObject *exc)
  /// ```
  ///
  /// - Parameters:
  ///   - error: Exception instance/type.
  ///   - exceptionType: Exception type to check agains (tuples are also allowed).
  public func exceptionMatches(error: PyObject,
                               exceptionType: PyObject) -> Bool {
    if let tuple = exceptionType as? PyTuple {
      return self.exceptionMatches(error: error, exceptionTypes: tuple)
    }

    if let type = exceptionType as? PyType {
      return self.exceptionMatches(error: error, exceptionType: type)
    }

    return false
  }

  public func exceptionMatches(error: PyObject,
                               exceptionTypes: PyTuple) -> Bool {
    return exceptionTypes.elements.contains {
      self.exceptionMatches(error: error, exceptionType: $0)
    }
  }

  public func exceptionMatches(error: PyObject,
                               exceptionType: PyType) -> Bool {
    // 'error' is a type
    if let type = error as? PyType {
      return self.exceptionMatches(error: type, exceptionType: exceptionType)
    }

    // 'error' is an error instance, so check its class
    return self.exceptionMatches(error: error.type, exceptionType: exceptionType)
  }

  /// Final version of `exceptionMatches` where we compare types.
  private func exceptionMatches(error: PyType,
                                exceptionType: PyType) -> Bool {
    guard error.isException else {
      return false
    }

    guard exceptionType.isException else {
      return false
    }

    return error.isSubtype(of: exceptionType)
  }
}
