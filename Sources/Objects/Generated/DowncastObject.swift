// Generated using Sourcery 0.15.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT


// swiftlint:disable:previous vertical_whitespace
// swiftlint:disable vertical_whitespace
// swiftlint:disable line_length
// swiftlint:disable file_length

// Basically:
// We hold 'PyObjects' on stack.
// We need to call Swift method that needs specific 'self' type.
// This file is responsible for downcasting 'PyObject' -> that specific Swift type.

private func cast<T>(_ object: PyObject,
                     as type: T.Type,
                     typeName: String,
                     methodName: String) -> PyResult<T> {
  if let v = object as? T {
    return .value(v)
  }

  return .typeError(
    "descriptor '\(methodName)' requires a '\(typeName)' object " +
    "but received a '\(object.typeName)'"
  )
}


internal enum Cast {

  // MARK: - Type type

  internal static func asPyType(_ object: PyObject, methodName: String) -> PyResult<PyType> {
    return cast(object, as: PyType.self, typeName: "type", methodName: methodName)
  }

  // MARK: - Bool

  internal static func asPyBool(_ object: PyObject, methodName: String) -> PyResult<PyBool> {
    return cast(object, as: PyBool.self, typeName: "bool", methodName: methodName)
  }

  // MARK: - BuiltinFunction

  internal static func asPyBuiltinFunction(_ object: PyObject, methodName: String) -> PyResult<PyBuiltinFunction> {
    return cast(object, as: PyBuiltinFunction.self, typeName: "builtinFunction", methodName: methodName)
  }

  // MARK: - ByteArray

  internal static func asPyByteArray(_ object: PyObject, methodName: String) -> PyResult<PyByteArray> {
    return cast(object, as: PyByteArray.self, typeName: "bytearray", methodName: methodName)
  }

  // MARK: - ByteArrayIterator

  internal static func asPyByteArrayIterator(_ object: PyObject, methodName: String) -> PyResult<PyByteArrayIterator> {
    return cast(object, as: PyByteArrayIterator.self, typeName: "bytearray_iterator", methodName: methodName)
  }

  // MARK: - Bytes

  internal static func asPyBytes(_ object: PyObject, methodName: String) -> PyResult<PyBytes> {
    return cast(object, as: PyBytes.self, typeName: "bytes", methodName: methodName)
  }

  // MARK: - BytesIterator

  internal static func asPyBytesIterator(_ object: PyObject, methodName: String) -> PyResult<PyBytesIterator> {
    return cast(object, as: PyBytesIterator.self, typeName: "bytes_iterator", methodName: methodName)
  }

  // MARK: - CallableIterator

  internal static func asPyCallableIterator(_ object: PyObject, methodName: String) -> PyResult<PyCallableIterator> {
    return cast(object, as: PyCallableIterator.self, typeName: "callable_iterator", methodName: methodName)
  }

  // MARK: - Code

  internal static func asPyCode(_ object: PyObject, methodName: String) -> PyResult<PyCode> {
    return cast(object, as: PyCode.self, typeName: "code", methodName: methodName)
  }

  // MARK: - Complex

  internal static func asPyComplex(_ object: PyObject, methodName: String) -> PyResult<PyComplex> {
    return cast(object, as: PyComplex.self, typeName: "complex", methodName: methodName)
  }

  // MARK: - Dict

  internal static func asPyDict(_ object: PyObject, methodName: String) -> PyResult<PyDict> {
    return cast(object, as: PyDict.self, typeName: "dict", methodName: methodName)
  }

  // MARK: - DictItemIterator

  internal static func asPyDictItemIterator(_ object: PyObject, methodName: String) -> PyResult<PyDictItemIterator> {
    return cast(object, as: PyDictItemIterator.self, typeName: "dict_itemiterator", methodName: methodName)
  }

  // MARK: - DictItems

  internal static func asPyDictItems(_ object: PyObject, methodName: String) -> PyResult<PyDictItems> {
    return cast(object, as: PyDictItems.self, typeName: "dict_items", methodName: methodName)
  }

  // MARK: - DictKeyIterator

  internal static func asPyDictKeyIterator(_ object: PyObject, methodName: String) -> PyResult<PyDictKeyIterator> {
    return cast(object, as: PyDictKeyIterator.self, typeName: "dict_keyiterator", methodName: methodName)
  }

  // MARK: - DictKeys

  internal static func asPyDictKeys(_ object: PyObject, methodName: String) -> PyResult<PyDictKeys> {
    return cast(object, as: PyDictKeys.self, typeName: "dict_keys", methodName: methodName)
  }

  // MARK: - DictValueIterator

  internal static func asPyDictValueIterator(_ object: PyObject, methodName: String) -> PyResult<PyDictValueIterator> {
    return cast(object, as: PyDictValueIterator.self, typeName: "dict_valueiterator", methodName: methodName)
  }

  // MARK: - DictValues

  internal static func asPyDictValues(_ object: PyObject, methodName: String) -> PyResult<PyDictValues> {
    return cast(object, as: PyDictValues.self, typeName: "dict_values", methodName: methodName)
  }

  // MARK: - Ellipsis

  internal static func asPyEllipsis(_ object: PyObject, methodName: String) -> PyResult<PyEllipsis> {
    return cast(object, as: PyEllipsis.self, typeName: "ellipsis", methodName: methodName)
  }

  // MARK: - Enumerate

  internal static func asPyEnumerate(_ object: PyObject, methodName: String) -> PyResult<PyEnumerate> {
    return cast(object, as: PyEnumerate.self, typeName: "enumerate", methodName: methodName)
  }

  // MARK: - Filter

  internal static func asPyFilter(_ object: PyObject, methodName: String) -> PyResult<PyFilter> {
    return cast(object, as: PyFilter.self, typeName: "filter", methodName: methodName)
  }

  // MARK: - Float

  internal static func asPyFloat(_ object: PyObject, methodName: String) -> PyResult<PyFloat> {
    return cast(object, as: PyFloat.self, typeName: "float", methodName: methodName)
  }

  // MARK: - FrozenSet

  internal static func asPyFrozenSet(_ object: PyObject, methodName: String) -> PyResult<PyFrozenSet> {
    return cast(object, as: PyFrozenSet.self, typeName: "frozenset", methodName: methodName)
  }

  // MARK: - Function

  internal static func asPyFunction(_ object: PyObject, methodName: String) -> PyResult<PyFunction> {
    return cast(object, as: PyFunction.self, typeName: "function", methodName: methodName)
  }

  // MARK: - Int

  internal static func asPyInt(_ object: PyObject, methodName: String) -> PyResult<PyInt> {
    return cast(object, as: PyInt.self, typeName: "int", methodName: methodName)
  }

  // MARK: - Iterator

  internal static func asPyIterator(_ object: PyObject, methodName: String) -> PyResult<PyIterator> {
    return cast(object, as: PyIterator.self, typeName: "iterator", methodName: methodName)
  }

  // MARK: - List

  internal static func asPyList(_ object: PyObject, methodName: String) -> PyResult<PyList> {
    return cast(object, as: PyList.self, typeName: "list", methodName: methodName)
  }

  // MARK: - ListIterator

  internal static func asPyListIterator(_ object: PyObject, methodName: String) -> PyResult<PyListIterator> {
    return cast(object, as: PyListIterator.self, typeName: "list_iterator", methodName: methodName)
  }

  // MARK: - ListReverseIterator

  internal static func asPyListReverseIterator(_ object: PyObject, methodName: String) -> PyResult<PyListReverseIterator> {
    return cast(object, as: PyListReverseIterator.self, typeName: "list_reverseiterator", methodName: methodName)
  }

  // MARK: - Map

  internal static func asPyMap(_ object: PyObject, methodName: String) -> PyResult<PyMap> {
    return cast(object, as: PyMap.self, typeName: "map", methodName: methodName)
  }

  // MARK: - Method

  internal static func asPyMethod(_ object: PyObject, methodName: String) -> PyResult<PyMethod> {
    return cast(object, as: PyMethod.self, typeName: "method", methodName: methodName)
  }

  // MARK: - Module

  internal static func asPyModule(_ object: PyObject, methodName: String) -> PyResult<PyModule> {
    return cast(object, as: PyModule.self, typeName: "module", methodName: methodName)
  }

  // MARK: - Namespace

  internal static func asPyNamespace(_ object: PyObject, methodName: String) -> PyResult<PyNamespace> {
    return cast(object, as: PyNamespace.self, typeName: "types.SimpleNamespace", methodName: methodName)
  }

  // MARK: - None

  internal static func asPyNone(_ object: PyObject, methodName: String) -> PyResult<PyNone> {
    return cast(object, as: PyNone.self, typeName: "NoneType", methodName: methodName)
  }

  // MARK: - NotImplemented

  internal static func asPyNotImplemented(_ object: PyObject, methodName: String) -> PyResult<PyNotImplemented> {
    return cast(object, as: PyNotImplemented.self, typeName: "NotImplementedType", methodName: methodName)
  }

  // MARK: - Property

  internal static func asPyProperty(_ object: PyObject, methodName: String) -> PyResult<PyProperty> {
    return cast(object, as: PyProperty.self, typeName: "property", methodName: methodName)
  }

  // MARK: - Range

  internal static func asPyRange(_ object: PyObject, methodName: String) -> PyResult<PyRange> {
    return cast(object, as: PyRange.self, typeName: "range", methodName: methodName)
  }

  // MARK: - RangeIterator

  internal static func asPyRangeIterator(_ object: PyObject, methodName: String) -> PyResult<PyRangeIterator> {
    return cast(object, as: PyRangeIterator.self, typeName: "range_iterator", methodName: methodName)
  }

  // MARK: - Reversed

  internal static func asPyReversed(_ object: PyObject, methodName: String) -> PyResult<PyReversed> {
    return cast(object, as: PyReversed.self, typeName: "reversed", methodName: methodName)
  }

  // MARK: - Set

  internal static func asPySet(_ object: PyObject, methodName: String) -> PyResult<PySet> {
    return cast(object, as: PySet.self, typeName: "set", methodName: methodName)
  }

  // MARK: - SetIterator

  internal static func asPySetIterator(_ object: PyObject, methodName: String) -> PyResult<PySetIterator> {
    return cast(object, as: PySetIterator.self, typeName: "set_iterator", methodName: methodName)
  }

  // MARK: - Slice

  internal static func asPySlice(_ object: PyObject, methodName: String) -> PyResult<PySlice> {
    return cast(object, as: PySlice.self, typeName: "slice", methodName: methodName)
  }

  // MARK: - String

  internal static func asPyString(_ object: PyObject, methodName: String) -> PyResult<PyString> {
    return cast(object, as: PyString.self, typeName: "str", methodName: methodName)
  }

  // MARK: - StringIterator

  internal static func asPyStringIterator(_ object: PyObject, methodName: String) -> PyResult<PyStringIterator> {
    return cast(object, as: PyStringIterator.self, typeName: "str_iterator", methodName: methodName)
  }

  // MARK: - Tuple

  internal static func asPyTuple(_ object: PyObject, methodName: String) -> PyResult<PyTuple> {
    return cast(object, as: PyTuple.self, typeName: "tuple", methodName: methodName)
  }

  // MARK: - TupleIterator

  internal static func asPyTupleIterator(_ object: PyObject, methodName: String) -> PyResult<PyTupleIterator> {
    return cast(object, as: PyTupleIterator.self, typeName: "tuple_iterator", methodName: methodName)
  }

  // MARK: - Zip

  internal static func asPyZip(_ object: PyObject, methodName: String) -> PyResult<PyZip> {
    return cast(object, as: PyZip.self, typeName: "zip", methodName: methodName)
  }

  // MARK: - ArithmeticError

  internal static func asPyArithmeticError(_ object: PyObject, methodName: String) -> PyResult<PyArithmeticError> {
    return cast(object, as: PyArithmeticError.self, typeName: "ArithmeticError", methodName: methodName)
  }

  // MARK: - AssertionError

  internal static func asPyAssertionError(_ object: PyObject, methodName: String) -> PyResult<PyAssertionError> {
    return cast(object, as: PyAssertionError.self, typeName: "AssertionError", methodName: methodName)
  }

  // MARK: - AttributeError

  internal static func asPyAttributeError(_ object: PyObject, methodName: String) -> PyResult<PyAttributeError> {
    return cast(object, as: PyAttributeError.self, typeName: "AttributeError", methodName: methodName)
  }

  // MARK: - BaseException

  internal static func asPyBaseException(_ object: PyObject, methodName: String) -> PyResult<PyBaseException> {
    return cast(object, as: PyBaseException.self, typeName: "BaseException", methodName: methodName)
  }

  // MARK: - BlockingIOError

  internal static func asPyBlockingIOError(_ object: PyObject, methodName: String) -> PyResult<PyBlockingIOError> {
    return cast(object, as: PyBlockingIOError.self, typeName: "BlockingIOError", methodName: methodName)
  }

  // MARK: - BrokenPipeError

  internal static func asPyBrokenPipeError(_ object: PyObject, methodName: String) -> PyResult<PyBrokenPipeError> {
    return cast(object, as: PyBrokenPipeError.self, typeName: "BrokenPipeError", methodName: methodName)
  }

  // MARK: - BufferError

  internal static func asPyBufferError(_ object: PyObject, methodName: String) -> PyResult<PyBufferError> {
    return cast(object, as: PyBufferError.self, typeName: "BufferError", methodName: methodName)
  }

  // MARK: - BytesWarning

  internal static func asPyBytesWarning(_ object: PyObject, methodName: String) -> PyResult<PyBytesWarning> {
    return cast(object, as: PyBytesWarning.self, typeName: "BytesWarning", methodName: methodName)
  }

  // MARK: - ChildProcessError

  internal static func asPyChildProcessError(_ object: PyObject, methodName: String) -> PyResult<PyChildProcessError> {
    return cast(object, as: PyChildProcessError.self, typeName: "ChildProcessError", methodName: methodName)
  }

  // MARK: - ConnectionAbortedError

  internal static func asPyConnectionAbortedError(_ object: PyObject, methodName: String) -> PyResult<PyConnectionAbortedError> {
    return cast(object, as: PyConnectionAbortedError.self, typeName: "ConnectionAbortedError", methodName: methodName)
  }

  // MARK: - ConnectionError

  internal static func asPyConnectionError(_ object: PyObject, methodName: String) -> PyResult<PyConnectionError> {
    return cast(object, as: PyConnectionError.self, typeName: "ConnectionError", methodName: methodName)
  }

  // MARK: - ConnectionRefusedError

  internal static func asPyConnectionRefusedError(_ object: PyObject, methodName: String) -> PyResult<PyConnectionRefusedError> {
    return cast(object, as: PyConnectionRefusedError.self, typeName: "ConnectionRefusedError", methodName: methodName)
  }

  // MARK: - ConnectionResetError

  internal static func asPyConnectionResetError(_ object: PyObject, methodName: String) -> PyResult<PyConnectionResetError> {
    return cast(object, as: PyConnectionResetError.self, typeName: "ConnectionResetError", methodName: methodName)
  }

  // MARK: - DeprecationWarning

  internal static func asPyDeprecationWarning(_ object: PyObject, methodName: String) -> PyResult<PyDeprecationWarning> {
    return cast(object, as: PyDeprecationWarning.self, typeName: "DeprecationWarning", methodName: methodName)
  }

  // MARK: - EOFError

  internal static func asPyEOFError(_ object: PyObject, methodName: String) -> PyResult<PyEOFError> {
    return cast(object, as: PyEOFError.self, typeName: "EOFError", methodName: methodName)
  }

  // MARK: - Exception

  internal static func asPyException(_ object: PyObject, methodName: String) -> PyResult<PyException> {
    return cast(object, as: PyException.self, typeName: "Exception", methodName: methodName)
  }

  // MARK: - FileExistsError

  internal static func asPyFileExistsError(_ object: PyObject, methodName: String) -> PyResult<PyFileExistsError> {
    return cast(object, as: PyFileExistsError.self, typeName: "FileExistsError", methodName: methodName)
  }

  // MARK: - FileNotFoundError

  internal static func asPyFileNotFoundError(_ object: PyObject, methodName: String) -> PyResult<PyFileNotFoundError> {
    return cast(object, as: PyFileNotFoundError.self, typeName: "FileNotFoundError", methodName: methodName)
  }

  // MARK: - FloatingPointError

  internal static func asPyFloatingPointError(_ object: PyObject, methodName: String) -> PyResult<PyFloatingPointError> {
    return cast(object, as: PyFloatingPointError.self, typeName: "FloatingPointError", methodName: methodName)
  }

  // MARK: - FutureWarning

  internal static func asPyFutureWarning(_ object: PyObject, methodName: String) -> PyResult<PyFutureWarning> {
    return cast(object, as: PyFutureWarning.self, typeName: "FutureWarning", methodName: methodName)
  }

  // MARK: - GeneratorExit

  internal static func asPyGeneratorExit(_ object: PyObject, methodName: String) -> PyResult<PyGeneratorExit> {
    return cast(object, as: PyGeneratorExit.self, typeName: "GeneratorExit", methodName: methodName)
  }

  // MARK: - ImportError

  internal static func asPyImportError(_ object: PyObject, methodName: String) -> PyResult<PyImportError> {
    return cast(object, as: PyImportError.self, typeName: "ImportError", methodName: methodName)
  }

  // MARK: - ImportWarning

  internal static func asPyImportWarning(_ object: PyObject, methodName: String) -> PyResult<PyImportWarning> {
    return cast(object, as: PyImportWarning.self, typeName: "ImportWarning", methodName: methodName)
  }

  // MARK: - IndentationError

  internal static func asPyIndentationError(_ object: PyObject, methodName: String) -> PyResult<PyIndentationError> {
    return cast(object, as: PyIndentationError.self, typeName: "IndentationError", methodName: methodName)
  }

  // MARK: - IndexError

  internal static func asPyIndexError(_ object: PyObject, methodName: String) -> PyResult<PyIndexError> {
    return cast(object, as: PyIndexError.self, typeName: "IndexError", methodName: methodName)
  }

  // MARK: - InterruptedError

  internal static func asPyInterruptedError(_ object: PyObject, methodName: String) -> PyResult<PyInterruptedError> {
    return cast(object, as: PyInterruptedError.self, typeName: "InterruptedError", methodName: methodName)
  }

  // MARK: - IsADirectoryError

  internal static func asPyIsADirectoryError(_ object: PyObject, methodName: String) -> PyResult<PyIsADirectoryError> {
    return cast(object, as: PyIsADirectoryError.self, typeName: "IsADirectoryError", methodName: methodName)
  }

  // MARK: - KeyError

  internal static func asPyKeyError(_ object: PyObject, methodName: String) -> PyResult<PyKeyError> {
    return cast(object, as: PyKeyError.self, typeName: "KeyError", methodName: methodName)
  }

  // MARK: - KeyboardInterrupt

  internal static func asPyKeyboardInterrupt(_ object: PyObject, methodName: String) -> PyResult<PyKeyboardInterrupt> {
    return cast(object, as: PyKeyboardInterrupt.self, typeName: "KeyboardInterrupt", methodName: methodName)
  }

  // MARK: - LookupError

  internal static func asPyLookupError(_ object: PyObject, methodName: String) -> PyResult<PyLookupError> {
    return cast(object, as: PyLookupError.self, typeName: "LookupError", methodName: methodName)
  }

  // MARK: - MemoryError

  internal static func asPyMemoryError(_ object: PyObject, methodName: String) -> PyResult<PyMemoryError> {
    return cast(object, as: PyMemoryError.self, typeName: "MemoryError", methodName: methodName)
  }

  // MARK: - ModuleNotFoundError

  internal static func asPyModuleNotFoundError(_ object: PyObject, methodName: String) -> PyResult<PyModuleNotFoundError> {
    return cast(object, as: PyModuleNotFoundError.self, typeName: "ModuleNotFoundError", methodName: methodName)
  }

  // MARK: - NameError

  internal static func asPyNameError(_ object: PyObject, methodName: String) -> PyResult<PyNameError> {
    return cast(object, as: PyNameError.self, typeName: "NameError", methodName: methodName)
  }

  // MARK: - NotADirectoryError

  internal static func asPyNotADirectoryError(_ object: PyObject, methodName: String) -> PyResult<PyNotADirectoryError> {
    return cast(object, as: PyNotADirectoryError.self, typeName: "NotADirectoryError", methodName: methodName)
  }

  // MARK: - NotImplementedError

  internal static func asPyNotImplementedError(_ object: PyObject, methodName: String) -> PyResult<PyNotImplementedError> {
    return cast(object, as: PyNotImplementedError.self, typeName: "NotImplementedError", methodName: methodName)
  }

  // MARK: - OSError

  internal static func asPyOSError(_ object: PyObject, methodName: String) -> PyResult<PyOSError> {
    return cast(object, as: PyOSError.self, typeName: "OSError", methodName: methodName)
  }

  // MARK: - OverflowError

  internal static func asPyOverflowError(_ object: PyObject, methodName: String) -> PyResult<PyOverflowError> {
    return cast(object, as: PyOverflowError.self, typeName: "OverflowError", methodName: methodName)
  }

  // MARK: - PendingDeprecationWarning

  internal static func asPyPendingDeprecationWarning(_ object: PyObject, methodName: String) -> PyResult<PyPendingDeprecationWarning> {
    return cast(object, as: PyPendingDeprecationWarning.self, typeName: "PendingDeprecationWarning", methodName: methodName)
  }

  // MARK: - PermissionError

  internal static func asPyPermissionError(_ object: PyObject, methodName: String) -> PyResult<PyPermissionError> {
    return cast(object, as: PyPermissionError.self, typeName: "PermissionError", methodName: methodName)
  }

  // MARK: - ProcessLookupError

  internal static func asPyProcessLookupError(_ object: PyObject, methodName: String) -> PyResult<PyProcessLookupError> {
    return cast(object, as: PyProcessLookupError.self, typeName: "ProcessLookupError", methodName: methodName)
  }

  // MARK: - RecursionError

  internal static func asPyRecursionError(_ object: PyObject, methodName: String) -> PyResult<PyRecursionError> {
    return cast(object, as: PyRecursionError.self, typeName: "RecursionError", methodName: methodName)
  }

  // MARK: - ReferenceError

  internal static func asPyReferenceError(_ object: PyObject, methodName: String) -> PyResult<PyReferenceError> {
    return cast(object, as: PyReferenceError.self, typeName: "ReferenceError", methodName: methodName)
  }

  // MARK: - ResourceWarning

  internal static func asPyResourceWarning(_ object: PyObject, methodName: String) -> PyResult<PyResourceWarning> {
    return cast(object, as: PyResourceWarning.self, typeName: "ResourceWarning", methodName: methodName)
  }

  // MARK: - RuntimeError

  internal static func asPyRuntimeError(_ object: PyObject, methodName: String) -> PyResult<PyRuntimeError> {
    return cast(object, as: PyRuntimeError.self, typeName: "RuntimeError", methodName: methodName)
  }

  // MARK: - RuntimeWarning

  internal static func asPyRuntimeWarning(_ object: PyObject, methodName: String) -> PyResult<PyRuntimeWarning> {
    return cast(object, as: PyRuntimeWarning.self, typeName: "RuntimeWarning", methodName: methodName)
  }

  // MARK: - StopAsyncIteration

  internal static func asPyStopAsyncIteration(_ object: PyObject, methodName: String) -> PyResult<PyStopAsyncIteration> {
    return cast(object, as: PyStopAsyncIteration.self, typeName: "StopAsyncIteration", methodName: methodName)
  }

  // MARK: - StopIteration

  internal static func asPyStopIteration(_ object: PyObject, methodName: String) -> PyResult<PyStopIteration> {
    return cast(object, as: PyStopIteration.self, typeName: "StopIteration", methodName: methodName)
  }

  // MARK: - SyntaxError

  internal static func asPySyntaxError(_ object: PyObject, methodName: String) -> PyResult<PySyntaxError> {
    return cast(object, as: PySyntaxError.self, typeName: "SyntaxError", methodName: methodName)
  }

  // MARK: - SyntaxWarning

  internal static func asPySyntaxWarning(_ object: PyObject, methodName: String) -> PyResult<PySyntaxWarning> {
    return cast(object, as: PySyntaxWarning.self, typeName: "SyntaxWarning", methodName: methodName)
  }

  // MARK: - SystemError

  internal static func asPySystemError(_ object: PyObject, methodName: String) -> PyResult<PySystemError> {
    return cast(object, as: PySystemError.self, typeName: "SystemError", methodName: methodName)
  }

  // MARK: - SystemExit

  internal static func asPySystemExit(_ object: PyObject, methodName: String) -> PyResult<PySystemExit> {
    return cast(object, as: PySystemExit.self, typeName: "SystemExit", methodName: methodName)
  }

  // MARK: - TabError

  internal static func asPyTabError(_ object: PyObject, methodName: String) -> PyResult<PyTabError> {
    return cast(object, as: PyTabError.self, typeName: "TabError", methodName: methodName)
  }

  // MARK: - TimeoutError

  internal static func asPyTimeoutError(_ object: PyObject, methodName: String) -> PyResult<PyTimeoutError> {
    return cast(object, as: PyTimeoutError.self, typeName: "TimeoutError", methodName: methodName)
  }

  // MARK: - TypeError

  internal static func asPyTypeError(_ object: PyObject, methodName: String) -> PyResult<PyTypeError> {
    return cast(object, as: PyTypeError.self, typeName: "TypeError", methodName: methodName)
  }

  // MARK: - UnboundLocalError

  internal static func asPyUnboundLocalError(_ object: PyObject, methodName: String) -> PyResult<PyUnboundLocalError> {
    return cast(object, as: PyUnboundLocalError.self, typeName: "UnboundLocalError", methodName: methodName)
  }

  // MARK: - UnicodeDecodeError

  internal static func asPyUnicodeDecodeError(_ object: PyObject, methodName: String) -> PyResult<PyUnicodeDecodeError> {
    return cast(object, as: PyUnicodeDecodeError.self, typeName: "UnicodeDecodeError", methodName: methodName)
  }

  // MARK: - UnicodeEncodeError

  internal static func asPyUnicodeEncodeError(_ object: PyObject, methodName: String) -> PyResult<PyUnicodeEncodeError> {
    return cast(object, as: PyUnicodeEncodeError.self, typeName: "UnicodeEncodeError", methodName: methodName)
  }

  // MARK: - UnicodeError

  internal static func asPyUnicodeError(_ object: PyObject, methodName: String) -> PyResult<PyUnicodeError> {
    return cast(object, as: PyUnicodeError.self, typeName: "UnicodeError", methodName: methodName)
  }

  // MARK: - UnicodeTranslateError

  internal static func asPyUnicodeTranslateError(_ object: PyObject, methodName: String) -> PyResult<PyUnicodeTranslateError> {
    return cast(object, as: PyUnicodeTranslateError.self, typeName: "UnicodeTranslateError", methodName: methodName)
  }

  // MARK: - UnicodeWarning

  internal static func asPyUnicodeWarning(_ object: PyObject, methodName: String) -> PyResult<PyUnicodeWarning> {
    return cast(object, as: PyUnicodeWarning.self, typeName: "UnicodeWarning", methodName: methodName)
  }

  // MARK: - UserWarning

  internal static func asPyUserWarning(_ object: PyObject, methodName: String) -> PyResult<PyUserWarning> {
    return cast(object, as: PyUserWarning.self, typeName: "UserWarning", methodName: methodName)
  }

  // MARK: - ValueError

  internal static func asPyValueError(_ object: PyObject, methodName: String) -> PyResult<PyValueError> {
    return cast(object, as: PyValueError.self, typeName: "ValueError", methodName: methodName)
  }

  // MARK: - Warning

  internal static func asPyWarning(_ object: PyObject, methodName: String) -> PyResult<PyWarning> {
    return cast(object, as: PyWarning.self, typeName: "Warning", methodName: methodName)
  }

  // MARK: - ZeroDivisionError

  internal static func asPyZeroDivisionError(_ object: PyObject, methodName: String) -> PyResult<PyZeroDivisionError> {
    return cast(object, as: PyZeroDivisionError.self, typeName: "ZeroDivisionError", methodName: methodName)
  }
}
