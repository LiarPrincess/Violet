// Generated using Sourcery 0.15.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT


// swiftlint:disable:previous vertical_whitespace
// swiftlint:disable vertical_whitespace
// swiftlint:disable file_length

// Types used when we subclass on of the builtin types.
//
// Normally most builtin types (like int, float etc.) do not have `__dict__`.
// But if we subclass then then `__dict__` is now present.
//
// For example:
// ```Python
// >>> 1.__dict__ # Builtin int does not have `__dict__`
// SyntaxError: invalid syntax
//
// >>> class MyInt(int): pass
// >>> MyInt().__dict__ # But the subclass has
// { }
// ```

/// Marker protocol for all heap types
internal protocol HeapType { }


// MARK: - Type type

// PyType already has everything we need.

// MARK: - Bool

// PyBool is not a base type.

// MARK: - BuiltinFunction

// PyBuiltinFunction is not a base type.

// MARK: - Code

// PyCode is not a base type.

// MARK: - Complex

/// Type used when we subclass builtin `complex` class.
/// For example: `class Rapunzel(complex): pass`.
internal final class PyComplexHeap: PyComplex, HeapType {

  /// Python `__dict__` property.
  internal lazy var attributes = Attributes()
}

// MARK: - Dict

/// Type used when we subclass builtin `dict` class.
/// For example: `class Rapunzel(dict): pass`.
internal final class PyDictHeap: PyDict, HeapType {

  /// Python `__dict__` property.
  internal lazy var attributes = Attributes()
}

// MARK: - DictItemIterator

// PyDictItemIterator is not a base type.

// MARK: - DictItems

// PyDictItems is not a base type.

// MARK: - DictKeyIterator

// PyDictKeyIterator is not a base type.

// MARK: - DictKeys

// PyDictKeys is not a base type.

// MARK: - DictValueIterator

// PyDictValueIterator is not a base type.

// MARK: - Ellipsis

// PyEllipsis is not a base type.

// MARK: - Float

/// Type used when we subclass builtin `float` class.
/// For example: `class Rapunzel(float): pass`.
internal final class PyFloatHeap: PyFloat, HeapType {

  /// Python `__dict__` property.
  internal lazy var attributes = Attributes()
}

// MARK: - FrozenSet

/// Type used when we subclass builtin `frozenset` class.
/// For example: `class Rapunzel(frozenset): pass`.
internal final class PyFrozenSetHeap: PyFrozenSet, HeapType {

  /// Python `__dict__` property.
  internal lazy var attributes = Attributes()
}

// MARK: - Function

// PyFunction is not a base type.

// MARK: - Int

/// Type used when we subclass builtin `int` class.
/// For example: `class Rapunzel(int): pass`.
internal final class PyIntHeap: PyInt, HeapType {

  /// Python `__dict__` property.
  internal lazy var attributes = Attributes()
}

// MARK: - List

/// Type used when we subclass builtin `list` class.
/// For example: `class Rapunzel(list): pass`.
internal final class PyListHeap: PyList, HeapType {

  /// Python `__dict__` property.
  internal lazy var attributes = Attributes()
}

// MARK: - ListIterator

// PyListIterator is not a base type.

// MARK: - ListReverseIterator

// PyListReverseIterator is not a base type.

// MARK: - Method

// PyMethod is not a base type.

// MARK: - Module

// PyModule already has everything we need.

// MARK: - Namespace

// PyNamespace already has everything we need.

// MARK: - None

// PyNone is not a base type.

// MARK: - NotImplemented

// PyNotImplemented is not a base type.

// MARK: - Property

/// Type used when we subclass builtin `property` class.
/// For example: `class Rapunzel(property): pass`.
internal final class PyPropertyHeap: PyProperty, HeapType {

  /// Python `__dict__` property.
  internal lazy var attributes = Attributes()
}

// MARK: - Range

// PyRange is not a base type.

// MARK: - Set

/// Type used when we subclass builtin `set` class.
/// For example: `class Rapunzel(set): pass`.
internal final class PySetHeap: PySet, HeapType {

  /// Python `__dict__` property.
  internal lazy var attributes = Attributes()
}

// MARK: - SetIterator

// PySetIterator is not a base type.

// MARK: - Slice

// PySlice is not a base type.

// MARK: - String

/// Type used when we subclass builtin `str` class.
/// For example: `class Rapunzel(str): pass`.
internal final class PyStringHeap: PyString, HeapType {

  /// Python `__dict__` property.
  internal lazy var attributes = Attributes()
}

// MARK: - Tuple

/// Type used when we subclass builtin `tuple` class.
/// For example: `class Rapunzel(tuple): pass`.
internal final class PyTupleHeap: PyTuple, HeapType {

  /// Python `__dict__` property.
  internal lazy var attributes = Attributes()
}

// MARK: - TupleIterator

// PyTupleIterator is not a base type.


// MARK: - ArithmeticError

// PyArithmeticError already has everything we need.

// MARK: - AssertionError

// PyAssertionError already has everything we need.

// MARK: - AttributeError

// PyAttributeError already has everything we need.

// MARK: - BaseException

// PyBaseException already has everything we need.

// MARK: - BlockingIOError

// PyBlockingIOError already has everything we need.

// MARK: - BrokenPipeError

// PyBrokenPipeError already has everything we need.

// MARK: - BufferError

// PyBufferError already has everything we need.

// MARK: - BytesWarning

// PyBytesWarning already has everything we need.

// MARK: - ChildProcessError

// PyChildProcessError already has everything we need.

// MARK: - ConnectionAbortedError

// PyConnectionAbortedError already has everything we need.

// MARK: - ConnectionError

// PyConnectionError already has everything we need.

// MARK: - ConnectionRefusedError

// PyConnectionRefusedError already has everything we need.

// MARK: - ConnectionResetError

// PyConnectionResetError already has everything we need.

// MARK: - DeprecationWarning

// PyDeprecationWarning already has everything we need.

// MARK: - EOFError

// PyEOFError already has everything we need.

// MARK: - Exception

// PyException already has everything we need.

// MARK: - FileExistsError

// PyFileExistsError already has everything we need.

// MARK: - FileNotFoundError

// PyFileNotFoundError already has everything we need.

// MARK: - FloatingPointError

// PyFloatingPointError already has everything we need.

// MARK: - FutureWarning

// PyFutureWarning already has everything we need.

// MARK: - GeneratorExit

// PyGeneratorExit already has everything we need.

// MARK: - ImportError

// PyImportError already has everything we need.

// MARK: - ImportWarning

// PyImportWarning already has everything we need.

// MARK: - IndentationError

// PyIndentationError already has everything we need.

// MARK: - IndexError

// PyIndexError already has everything we need.

// MARK: - InterruptedError

// PyInterruptedError already has everything we need.

// MARK: - IsADirectoryError

// PyIsADirectoryError already has everything we need.

// MARK: - KeyError

// PyKeyError already has everything we need.

// MARK: - KeyboardInterrupt

// PyKeyboardInterrupt already has everything we need.

// MARK: - LookupError

// PyLookupError already has everything we need.

// MARK: - MemoryError

// PyMemoryError already has everything we need.

// MARK: - ModuleNotFoundError

// PyModuleNotFoundError already has everything we need.

// MARK: - NameError

// PyNameError already has everything we need.

// MARK: - NotADirectoryError

// PyNotADirectoryError already has everything we need.

// MARK: - NotImplementedError

// PyNotImplementedError already has everything we need.

// MARK: - OSError

// PyOSError already has everything we need.

// MARK: - OverflowError

// PyOverflowError already has everything we need.

// MARK: - PendingDeprecationWarning

// PyPendingDeprecationWarning already has everything we need.

// MARK: - PermissionError

// PyPermissionError already has everything we need.

// MARK: - ProcessLookupError

// PyProcessLookupError already has everything we need.

// MARK: - RecursionError

// PyRecursionError already has everything we need.

// MARK: - ReferenceError

// PyReferenceError already has everything we need.

// MARK: - ResourceWarning

// PyResourceWarning already has everything we need.

// MARK: - RuntimeError

// PyRuntimeError already has everything we need.

// MARK: - RuntimeWarning

// PyRuntimeWarning already has everything we need.

// MARK: - StopAsyncIteration

// PyStopAsyncIteration already has everything we need.

// MARK: - StopIteration

// PyStopIteration already has everything we need.

// MARK: - SyntaxError

// PySyntaxError already has everything we need.

// MARK: - SyntaxWarning

// PySyntaxWarning already has everything we need.

// MARK: - SystemError

// PySystemError already has everything we need.

// MARK: - SystemExit

// PySystemExit already has everything we need.

// MARK: - TabError

// PyTabError already has everything we need.

// MARK: - TimeoutError

// PyTimeoutError already has everything we need.

// MARK: - TypeError

// PyTypeError already has everything we need.

// MARK: - UnboundLocalError

// PyUnboundLocalError already has everything we need.

// MARK: - UnicodeDecodeError

// PyUnicodeDecodeError already has everything we need.

// MARK: - UnicodeEncodeError

// PyUnicodeEncodeError already has everything we need.

// MARK: - UnicodeError

// PyUnicodeError already has everything we need.

// MARK: - UnicodeTranslateError

// PyUnicodeTranslateError already has everything we need.

// MARK: - UnicodeWarning

// PyUnicodeWarning already has everything we need.

// MARK: - UserWarning

// PyUserWarning already has everything we need.

// MARK: - ValueError

// PyValueError already has everything we need.

// MARK: - Warning

// PyWarning already has everything we need.

// MARK: - ZeroDivisionError

// PyZeroDivisionError already has everything we need.
