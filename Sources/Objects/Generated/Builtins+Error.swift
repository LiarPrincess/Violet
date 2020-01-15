import Foundation

// In CPython:
// Objects -> exceptions.c
// Python -> errors.c (kind of...)
// https://docs.python.org/3.7/library/exceptions.html

extension Builtins {

  /// Inappropriate argument type.
  public func newTypeError(msg: String) -> PyTypeError {
    return PyTypeError(self.context, msg: msg)
  }

  /// Inappropriate argument value (of correct type).
  public func newValueError(msg: String) -> PyValueError {
    return PyValueError(self.context, msg: msg)
  }

  /// Sequence index out of range.
  public func newIndexError(msg: String) -> PyIndexError {
    return PyIndexError(self.context, msg: msg)
  }

  /// Attribute not found.
  public func newAttributeError(msg: String) -> PyAttributeError {
    return PyAttributeError(self.context, msg: msg)
  }

  /// Second argument to a division or modulo operation was zero.
  public func newZeroDivisionError(msg: String) -> PyZeroDivisionError {
    return PyZeroDivisionError(self.context, msg: msg)
  }

  /// Result too large to be represented.
  public func newOverflowError(msg: String) -> PyOverflowError {
    return PyOverflowError(self.context, msg: msg)
  }

  /// Internal error in the Python interpreter.
  public func newSystemError(msg: String) -> PySystemError {
    return PySystemError(self.context, msg: msg)
  }

  /// Name not found globally.
  public func newNameError(msg: String) -> PyNameError {
    return PyNameError(self.context, msg: msg)
  }

  /// Unspecified run-time error.
  public func newRuntimeError(msg: String) -> PyRuntimeError {
    return PyRuntimeError(self.context, msg: msg)
  }

  /// Base class for warnings about deprecated features.
  public func newDeprecationWarning(msg: String) -> PyDeprecationWarning {
    return PyDeprecationWarning(self.context, msg: msg)
  }

  /// Base class for lookup errors.
  public func newLookupError(msg: String) -> PyLookupError {
    return PyLookupError(self.context, msg: msg)
  }

  /// Base class for I/O related errors.
  public func newOSError(msg: String) -> PyOSError {
    return PyOSError(self.context, msg: msg)
  }

  /// Mapping key not found.
  public func newKeyError(msg: String) -> PyKeyError {
    return PyKeyError(self.context, msg: msg)
  }

  /// Mapping key not found.
  public func newKeyError(key: PyObject) -> PyKeyError {
    let args = self.newTuple(key)
    return PyKeyError(self.context, args: args)
  }

  /// Signal the end from iterator.__next__().
  public func newStopIteration(value: PyObject) -> PyStopIteration {
    let args = self.newTuple(value)
    return PyStopIteration(self.context, args: args)
  }

  /// Local name referenced but not bound to a value.
  public func newUnboundLocalError(variableName: String) -> PyUnboundLocalError {
     // variableName - standard 'msg'
    let msg = "local variable '\(variableName)' referenced before assignment"
    return PyUnboundLocalError(self.context, msg: msg)
  }

  /// Unicode decoding error.
  public func newUnicodeDecodeError(encoding: FileEncoding,
                                    data: Data) -> PyUnicodeDecodeError {
    let msg = "'\(encoding)' codec can't decode data"
    return PyUnicodeDecodeError(self.context, msg: msg)
  }

  /// Unicode encoding error.
  public func newUnicodeEncodeError(encoding: FileEncoding,
                                    string: String) -> PyUnicodeEncodeError {
    let msg = "'\(encoding)' codec can't encode data"
    return PyUnicodeEncodeError(self.context, msg: msg)
  }
}
