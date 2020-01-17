import Foundation

// In CPython:
// Objects -> exceptions.c
// Python -> errors.c (kind of...)
// https://docs.python.org/3.7/library/exceptions.html

extension BuiltinFunctions {

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
     // variableName - standard 'msg'
    let msg = "local variable '\(variableName)' referenced before assignment"
    return PyUnboundLocalError(msg: msg)
  }

  /// Unicode decoding error.
  public func newUnicodeDecodeError(encoding: FileEncoding,
                                    data: Data) -> PyUnicodeDecodeError {
    let msg = "'\(encoding)' codec can't decode data"
    return PyUnicodeDecodeError(msg: msg)
  }

  /// Unicode encoding error.
  public func newUnicodeEncodeError(encoding: FileEncoding,
                                    string: String) -> PyUnicodeEncodeError {
    let msg = "'\(encoding)' codec can't encode data"
    return PyUnicodeEncodeError(msg: msg)
  }
}
