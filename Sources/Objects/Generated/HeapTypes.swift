// swiftlint:disable vertical_whitespace
// swiftlint:disable file_length

// Please note that this file was automatically generated. DO NOT EDIT!
// The same goes for other files in 'Generated' directory.

// Types used when we subclass one of the builtin types.
//
// Normally most builtin types (like int, float etc.) do not have '__dict__'.
// But if we subclass then then '__dict__' is now present.
//
// For example:
// >>> 1.__dict__ # Builtin int does not have '__dict__'
// SyntaxError: invalid syntax
//
// >>> class MyInt(int): pass
// >>> MyInt().__dict__ # But the subclass has
// { }

internal protocol HeapType: __dict__GetterOwner {
  var __dict__: PyDict { get set }
}

extension HeapType {
  internal func getDict() -> PyDict {
    return self.__dict__
  }
}

// MARK: - Object

/// Type used when we subclass builtin `object` class.
/// For example: `class Rapunzel(object): pass`.
internal final class PyObjectHeap: PyObject, HeapType {

  /// Python `__dict__` property.
  internal lazy var __dict__ = PyDict()
}

// MARK: - Bool

// PyBool is not a base type.

// MARK: - BuiltinFunction

// PyBuiltinFunction is not a base type.

// MARK: - BuiltinMethod

// PyBuiltinMethod is not a base type.

// MARK: - ByteArray

/// Type used when we subclass builtin `bytearray` class.
/// For example: `class Rapunzel(bytearray): pass`.
internal final class PyByteArrayHeap: PyByteArray, HeapType {

  /// Python `__dict__` property.
  internal lazy var __dict__ = PyDict()
}

// MARK: - ByteArrayIterator

// PyByteArrayIterator is not a base type.

// MARK: - Bytes

/// Type used when we subclass builtin `bytes` class.
/// For example: `class Rapunzel(bytes): pass`.
internal final class PyBytesHeap: PyBytes, HeapType {

  /// Python `__dict__` property.
  internal lazy var __dict__ = PyDict()
}

// MARK: - BytesIterator

// PyBytesIterator is not a base type.

// MARK: - CallableIterator

// PyCallableIterator is not a base type.

// MARK: - Cell

// PyCell is not a base type.

// MARK: - ClassMethod

// PyClassMethod already has everything we need.

// MARK: - Code

// PyCode is not a base type.

// MARK: - Complex

/// Type used when we subclass builtin `complex` class.
/// For example: `class Rapunzel(complex): pass`.
internal final class PyComplexHeap: PyComplex, HeapType {

  /// Python `__dict__` property.
  internal lazy var __dict__ = PyDict()
}

// MARK: - Dict

/// Type used when we subclass builtin `dict` class.
/// For example: `class Rapunzel(dict): pass`.
internal final class PyDictHeap: PyDict, HeapType {

  /// Python `__dict__` property.
  internal lazy var __dict__ = PyDict()
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

// MARK: - DictValues

// PyDictValues is not a base type.

// MARK: - Ellipsis

// PyEllipsis is not a base type.

// MARK: - Enumerate

/// Type used when we subclass builtin `enumerate` class.
/// For example: `class Rapunzel(enumerate): pass`.
internal final class PyEnumerateHeap: PyEnumerate, HeapType {

  /// Python `__dict__` property.
  internal lazy var __dict__ = PyDict()
}

// MARK: - Filter

/// Type used when we subclass builtin `filter` class.
/// For example: `class Rapunzel(filter): pass`.
internal final class PyFilterHeap: PyFilter, HeapType {

  /// Python `__dict__` property.
  internal lazy var __dict__ = PyDict()
}

// MARK: - Float

/// Type used when we subclass builtin `float` class.
/// For example: `class Rapunzel(float): pass`.
internal final class PyFloatHeap: PyFloat, HeapType {

  /// Python `__dict__` property.
  internal lazy var __dict__ = PyDict()
}

// MARK: - Frame

// PyFrame is not a base type.

// MARK: - FrozenSet

/// Type used when we subclass builtin `frozenset` class.
/// For example: `class Rapunzel(frozenset): pass`.
internal final class PyFrozenSetHeap: PyFrozenSet, HeapType {

  /// Python `__dict__` property.
  internal lazy var __dict__ = PyDict()
}

// MARK: - Function

// PyFunction is not a base type.

// MARK: - Int

/// Type used when we subclass builtin `int` class.
/// For example: `class Rapunzel(int): pass`.
internal final class PyIntHeap: PyInt, HeapType {

  /// Python `__dict__` property.
  internal lazy var __dict__ = PyDict()
}

// MARK: - Iterator

// PyIterator is not a base type.

// MARK: - List

/// Type used when we subclass builtin `list` class.
/// For example: `class Rapunzel(list): pass`.
internal final class PyListHeap: PyList, HeapType {

  /// Python `__dict__` property.
  internal lazy var __dict__ = PyDict()
}

// MARK: - ListIterator

// PyListIterator is not a base type.

// MARK: - ListReverseIterator

// PyListReverseIterator is not a base type.

// MARK: - Map

/// Type used when we subclass builtin `map` class.
/// For example: `class Rapunzel(map): pass`.
internal final class PyMapHeap: PyMap, HeapType {

  /// Python `__dict__` property.
  internal lazy var __dict__ = PyDict()
}

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
  internal lazy var __dict__ = PyDict()
}

// MARK: - Range

// PyRange is not a base type.

// MARK: - RangeIterator

// PyRangeIterator is not a base type.

// MARK: - Reversed

/// Type used when we subclass builtin `reversed` class.
/// For example: `class Rapunzel(reversed): pass`.
internal final class PyReversedHeap: PyReversed, HeapType {

  /// Python `__dict__` property.
  internal lazy var __dict__ = PyDict()
}

// MARK: - Set

/// Type used when we subclass builtin `set` class.
/// For example: `class Rapunzel(set): pass`.
internal final class PySetHeap: PySet, HeapType {

  /// Python `__dict__` property.
  internal lazy var __dict__ = PyDict()
}

// MARK: - SetIterator

// PySetIterator is not a base type.

// MARK: - Slice

// PySlice is not a base type.

// MARK: - StaticMethod

// PyStaticMethod already has everything we need.

// MARK: - String

/// Type used when we subclass builtin `str` class.
/// For example: `class Rapunzel(str): pass`.
internal final class PyStringHeap: PyString, HeapType {

  /// Python `__dict__` property.
  internal lazy var __dict__ = PyDict()
}

// MARK: - StringIterator

// PyStringIterator is not a base type.

// MARK: - Super

/// Type used when we subclass builtin `super` class.
/// For example: `class Rapunzel(super): pass`.
internal final class PySuperHeap: PySuper, HeapType {

  /// Python `__dict__` property.
  internal lazy var __dict__ = PyDict()
}

// MARK: - TextFile

// PyTextFile is not a base type.

// MARK: - Tuple

/// Type used when we subclass builtin `tuple` class.
/// For example: `class Rapunzel(tuple): pass`.
internal final class PyTupleHeap: PyTuple, HeapType {

  /// Python `__dict__` property.
  internal lazy var __dict__ = PyDict()
}

// MARK: - TupleIterator

// PyTupleIterator is not a base type.

// MARK: - Type

// PyType already has everything we need.

// MARK: - Zip

/// Type used when we subclass builtin `zip` class.
/// For example: `class Rapunzel(zip): pass`.
internal final class PyZipHeap: PyZip, HeapType {

  /// Python `__dict__` property.
  internal lazy var __dict__ = PyDict()
}

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

