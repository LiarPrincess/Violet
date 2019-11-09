import Core

// swiftlint:disable force_cast
// swiftlint:disable line_length
// swiftlint:disable file_length

// TODO: Better selfAsXXX methods (PyType_Ready(PyTypeObject *type))

extension TypeFactory {

  // MARK: - Types

  internal static func selfAsPyBool(_ value: PyObject) -> PyBool {
    return value as! PyBool
  }

  internal static func selfAsPyBuiltinFunction(_ value: PyObject) -> PyBuiltinFunction {
    return value as! PyBuiltinFunction
  }

  internal static func selfAsPyCode(_ value: PyObject) -> PyCode {
    return value as! PyCode
  }

  internal static func selfAsPyComplex(_ value: PyObject) -> PyComplex {
    return value as! PyComplex
  }

  internal static func selfAsPyDict(_ value: PyObject) -> PyDict {
    return value as! PyDict
  }

  internal static func selfAsPyEllipsis(_ value: PyObject) -> PyEllipsis {
    return value as! PyEllipsis
  }

  internal static func selfAsPyFloat(_ value: PyObject) -> PyFloat {
    return value as! PyFloat
  }

  internal static func selfAsPyFunction(_ value: PyObject) -> PyFunction {
    return value as! PyFunction
  }

  internal static func selfAsPyInt(_ value: PyObject) -> PyInt {
    return value as! PyInt
  }

  internal static func selfAsPyList(_ value: PyObject) -> PyList {
    return value as! PyList
  }

  internal static func selfAsPyMethod(_ value: PyObject) -> PyMethod {
    return value as! PyMethod
  }

  internal static func selfAsPyModule(_ value: PyObject) -> PyModule {
    return value as! PyModule
  }

  internal static func selfAsPyNamespace(_ value: PyObject) -> PyNamespace {
    return value as! PyNamespace
  }

  internal static func selfAsPyNone(_ value: PyObject) -> PyNone {
    return value as! PyNone
  }

  internal static func selfAsPyNotImplemented(_ value: PyObject) -> PyNotImplemented {
    return value as! PyNotImplemented
  }

  internal static func selfAsPyProperty(_ value: PyObject) -> PyProperty {
    return value as! PyProperty
  }

  internal static func selfAsPyRange(_ value: PyObject) -> PyRange {
    return value as! PyRange
  }

  internal static func selfAsPySlice(_ value: PyObject) -> PySlice {
    return value as! PySlice
  }

  internal static func selfAsPyString(_ value: PyObject) -> PyString {
    return value as! PyString
  }

  internal static func selfAsPyType(_ value: PyObject) -> PyType {
    return value as! PyType
  }

  internal static func selfAsPyTuple(_ value: PyObject) -> PyTuple {
    return value as! PyTuple
  }

  // MARK: - Errors

  internal static func selfAsPyBaseException(_ value: PyObject) -> PyBaseException {
    return value as! PyBaseException
  }

  internal static func selfAsPySystemExit(_ value: PyObject) -> PySystemExit {
    return value as! PySystemExit
  }

  internal static func selfAsPyKeyboardInterrupt(_ value: PyObject) -> PyKeyboardInterrupt {
    return value as! PyKeyboardInterrupt
  }

  internal static func selfAsPyGeneratorExit(_ value: PyObject) -> PyGeneratorExit {
    return value as! PyGeneratorExit
  }

  internal static func selfAsPyException(_ value: PyObject) -> PyException {
    return value as! PyException
  }

  internal static func selfAsPyStopIteration(_ value: PyObject) -> PyStopIteration {
    return value as! PyStopIteration
  }

  internal static func selfAsPyStopAsyncIteration(_ value: PyObject) -> PyStopAsyncIteration {
    return value as! PyStopAsyncIteration
  }

  internal static func selfAsPyArithmeticError(_ value: PyObject) -> PyArithmeticError {
    return value as! PyArithmeticError
  }

  internal static func selfAsPyFloatingPointError(_ value: PyObject) -> PyFloatingPointError {
    return value as! PyFloatingPointError
  }

  internal static func selfAsPyOverflowError(_ value: PyObject) -> PyOverflowError {
    return value as! PyOverflowError
  }

  internal static func selfAsPyZeroDivisionError(_ value: PyObject) -> PyZeroDivisionError {
    return value as! PyZeroDivisionError
  }

  internal static func selfAsPyAssertionError(_ value: PyObject) -> PyAssertionError {
    return value as! PyAssertionError
  }

  internal static func selfAsPyAttributeError(_ value: PyObject) -> PyAttributeError {
    return value as! PyAttributeError
  }

  internal static func selfAsPyBufferError(_ value: PyObject) -> PyBufferError {
    return value as! PyBufferError
  }

  internal static func selfAsPyEOFError(_ value: PyObject) -> PyEOFError {
    return value as! PyEOFError
  }

  internal static func selfAsPyImportError(_ value: PyObject) -> PyImportError {
    return value as! PyImportError
  }

  internal static func selfAsPyModuleNotFoundError(_ value: PyObject) -> PyModuleNotFoundError {
    return value as! PyModuleNotFoundError
  }

  internal static func selfAsPyLookupError(_ value: PyObject) -> PyLookupError {
    return value as! PyLookupError
  }

  internal static func selfAsPyIndexError(_ value: PyObject) -> PyIndexError {
    return value as! PyIndexError
  }

  internal static func selfAsPyKeyError(_ value: PyObject) -> PyKeyError {
    return value as! PyKeyError
  }

  internal static func selfAsPyMemoryError(_ value: PyObject) -> PyMemoryError {
    return value as! PyMemoryError
  }

  internal static func selfAsPyNameError(_ value: PyObject) -> PyNameError {
    return value as! PyNameError
  }

  internal static func selfAsPyUnboundLocalError(_ value: PyObject) -> PyUnboundLocalError {
    return value as! PyUnboundLocalError
  }

  internal static func selfAsPyOSError(_ value: PyObject) -> PyOSError {
    return value as! PyOSError
  }

  internal static func selfAsPyBlockingIOError(_ value: PyObject) -> PyBlockingIOError {
    return value as! PyBlockingIOError
  }

  internal static func selfAsPyChildProcessError(_ value: PyObject) -> PyChildProcessError {
    return value as! PyChildProcessError
  }

  internal static func selfAsPyConnectionError(_ value: PyObject) -> PyConnectionError {
    return value as! PyConnectionError
  }

  internal static func selfAsPyBrokenPipeError(_ value: PyObject) -> PyBrokenPipeError {
    return value as! PyBrokenPipeError
  }

  internal static func selfAsPyConnectionAbortedError(_ value: PyObject) -> PyConnectionAbortedError {
    return value as! PyConnectionAbortedError
  }

  internal static func selfAsPyConnectionRefusedError(_ value: PyObject) -> PyConnectionRefusedError {
    return value as! PyConnectionRefusedError
  }

  internal static func selfAsPyConnectionResetError(_ value: PyObject) -> PyConnectionResetError {
    return value as! PyConnectionResetError
  }

  internal static func selfAsPyFileExistsError(_ value: PyObject) -> PyFileExistsError {
    return value as! PyFileExistsError
  }

  internal static func selfAsPyFileNotFoundError(_ value: PyObject) -> PyFileNotFoundError {
    return value as! PyFileNotFoundError
  }

  internal static func selfAsPyInterruptedError(_ value: PyObject) -> PyInterruptedError {
    return value as! PyInterruptedError
  }

  internal static func selfAsPyIsADirectoryError(_ value: PyObject) -> PyIsADirectoryError {
    return value as! PyIsADirectoryError
  }

  internal static func selfAsPyNotADirectoryError(_ value: PyObject) -> PyNotADirectoryError {
    return value as! PyNotADirectoryError
  }

  internal static func selfAsPyPermissionError(_ value: PyObject) -> PyPermissionError {
    return value as! PyPermissionError
  }

  internal static func selfAsPyProcessLookupError(_ value: PyObject) -> PyProcessLookupError {
    return value as! PyProcessLookupError
  }

  internal static func selfAsPyTimeoutError(_ value: PyObject) -> PyTimeoutError {
    return value as! PyTimeoutError
  }

  internal static func selfAsPyReferenceError(_ value: PyObject) -> PyReferenceError {
    return value as! PyReferenceError
  }

  internal static func selfAsPyRuntimeError(_ value: PyObject) -> PyRuntimeError {
    return value as! PyRuntimeError
  }

  internal static func selfAsPyNotImplementedError(_ value: PyObject) -> PyNotImplementedError {
    return value as! PyNotImplementedError
  }

  internal static func selfAsPyRecursionError(_ value: PyObject) -> PyRecursionError {
    return value as! PyRecursionError
  }

  internal static func selfAsPySyntaxError(_ value: PyObject) -> PySyntaxError {
    return value as! PySyntaxError
  }

  internal static func selfAsPyIndentationError(_ value: PyObject) -> PyIndentationError {
    return value as! PyIndentationError
  }

  internal static func selfAsPyTabError(_ value: PyObject) -> PyTabError {
    return value as! PyTabError
  }

  internal static func selfAsPySystemError(_ value: PyObject) -> PySystemError {
    return value as! PySystemError
  }

  internal static func selfAsPyTypeError(_ value: PyObject) -> PyTypeError {
    return value as! PyTypeError
  }

  internal static func selfAsPyValueError(_ value: PyObject) -> PyValueError {
    return value as! PyValueError
  }

  internal static func selfAsPyUnicodeError(_ value: PyObject) -> PyUnicodeError {
    return value as! PyUnicodeError
  }

  internal static func selfAsPyUnicodeDecodeError(_ value: PyObject) -> PyUnicodeDecodeError {
    return value as! PyUnicodeDecodeError
  }

  internal static func selfAsPyUnicodeEncodeError(_ value: PyObject) -> PyUnicodeEncodeError {
    return value as! PyUnicodeEncodeError
  }

  internal static func selfAsPyUnicodeTranslateError(_ value: PyObject) -> PyUnicodeTranslateError {
    return value as! PyUnicodeTranslateError
  }

  // MARK: - Warnings

  internal static func selfAsPyWarning(_ value: PyObject) -> PyWarning {
    return value as! PyWarning
  }

  internal static func selfAsPyDeprecationWarning(_ value: PyObject) -> PyDeprecationWarning {
    return value as! PyDeprecationWarning
  }

  internal static func selfAsPyPendingDeprecationWarning(_ value: PyObject) -> PyPendingDeprecationWarning {
    return value as! PyPendingDeprecationWarning
  }

  internal static func selfAsPyRuntimeWarning(_ value: PyObject) -> PyRuntimeWarning {
    return value as! PyRuntimeWarning
  }

  internal static func selfAsPySyntaxWarning(_ value: PyObject) -> PySyntaxWarning {
    return value as! PySyntaxWarning
  }

  internal static func selfAsPyUserWarning(_ value: PyObject) -> PyUserWarning {
    return value as! PyUserWarning
  }

  internal static func selfAsPyFutureWarning(_ value: PyObject) -> PyFutureWarning {
    return value as! PyFutureWarning
  }

  internal static func selfAsPyImportWarning(_ value: PyObject) -> PyImportWarning {
    return value as! PyImportWarning
  }

  internal static func selfAsPyUnicodeWarning(_ value: PyObject) -> PyUnicodeWarning {
    return value as! PyUnicodeWarning
  }

  internal static func selfAsPyBytesWarning(_ value: PyObject) -> PyBytesWarning {
    return value as! PyBytesWarning
  }

  internal static func selfAsPyResourceWarning(_ value: PyObject) -> PyResourceWarning {
    return value as! PyResourceWarning
  }
}
