// swiftlint:disable file_length
// swiftlint:disable opening_brace
// swiftlint:disable trailing_newline

// Please note that this file was automatically generated. DO NOT EDIT!
// The same goes for other files in 'Generated' directory.

// Sometimes instead of doing slow Python dispatch we will use Swift protocols.
// Feel free to add new protocols if you need them (just modify the script
// responsible for generating the code).

// MARK: - BaseObject

// PyObjectType does not own anything.
extension PyObjectType { }

// MARK: - Type

extension PyType:
  __dict__GetterOwner,
  __repr__Owner,
  __subclasscheck__Owner,
  __instancecheck__Owner,
  __getattribute__Owner,
  __setattr__Owner,
  __dir__Owner,
  __call__Owner,
  __init__Owner
{ }

// MARK: - Bool

// PyBool does not add any new protocols to PyInt
extension PyBool { }

// MARK: - BuiltinFunction

extension PyBuiltinFunction:
  __eq__Owner,
  __ne__Owner,
  __lt__Owner,
  __le__Owner,
  __gt__Owner,
  __ge__Owner,
  __hash__Owner,
  __repr__Owner,
  __getattribute__Owner,
  __call__Owner
{ }

// MARK: - BuiltinMethod

extension PyBuiltinMethod:
  __eq__Owner,
  __ne__Owner,
  __lt__Owner,
  __le__Owner,
  __gt__Owner,
  __ge__Owner,
  __hash__Owner,
  __repr__Owner,
  __getattribute__Owner,
  __call__Owner
{ }

// MARK: - ByteArray

extension PyByteArray:
  __eq__Owner,
  __ne__Owner,
  __lt__Owner,
  __le__Owner,
  __gt__Owner,
  __ge__Owner,
  __hash__Owner,
  __repr__Owner,
  __str__Owner,
  __getattribute__Owner,
  __len__Owner,
  __contains__Owner,
  __getitem__Owner,
  __add__Owner,
  __mul__Owner,
  __rmul__Owner,
  __iter__Owner,
  __setitem__Owner,
  __delitem__Owner,
  __init__Owner
{ }

// MARK: - ByteArrayIterator

extension PyByteArrayIterator:
  __getattribute__Owner,
  __iter__Owner,
  __next__Owner
{ }

// MARK: - Bytes

extension PyBytes:
  __eq__Owner,
  __ne__Owner,
  __lt__Owner,
  __le__Owner,
  __gt__Owner,
  __ge__Owner,
  __hash__Owner,
  __repr__Owner,
  __str__Owner,
  __getattribute__Owner,
  __len__Owner,
  __contains__Owner,
  __getitem__Owner,
  __add__Owner,
  __mul__Owner,
  __rmul__Owner,
  __iter__Owner
{ }

// MARK: - BytesIterator

extension PyBytesIterator:
  __getattribute__Owner,
  __iter__Owner,
  __next__Owner
{ }

// MARK: - CallableIterator

extension PyCallableIterator:
  __getattribute__Owner,
  __iter__Owner,
  __next__Owner
{ }

// MARK: - Cell

extension PyCell:
  __eq__Owner,
  __ne__Owner,
  __lt__Owner,
  __le__Owner,
  __gt__Owner,
  __ge__Owner,
  __repr__Owner,
  __getattribute__Owner
{ }

// MARK: - ClassMethod

extension PyClassMethod:
  __dict__GetterOwner,
  __isabstractmethod__Owner,
  __init__Owner
{ }

// MARK: - Code

extension PyCode:
  __eq__Owner,
  __ne__Owner,
  __lt__Owner,
  __le__Owner,
  __gt__Owner,
  __ge__Owner,
  __hash__Owner,
  __repr__Owner,
  __getattribute__Owner
{ }

// MARK: - Complex

extension PyComplex:
  __eq__Owner,
  __ne__Owner,
  __lt__Owner,
  __le__Owner,
  __gt__Owner,
  __ge__Owner,
  __hash__Owner,
  __repr__Owner,
  __str__Owner,
  __bool__Owner,
  __float__Owner,
  __getattribute__Owner,
  __pos__Owner,
  __neg__Owner,
  __abs__Owner,
  __add__Owner,
  __radd__Owner,
  __sub__Owner,
  __rsub__Owner,
  __mul__Owner,
  __rmul__Owner,
  __pow__Owner,
  __rpow__Owner,
  __truediv__Owner,
  __rtruediv__Owner,
  __floordiv__Owner,
  __rfloordiv__Owner,
  __mod__Owner,
  __rmod__Owner,
  __divmod__Owner,
  __rdivmod__Owner
{ }

// MARK: - Dict

extension PyDict:
  __eq__Owner,
  __ne__Owner,
  __lt__Owner,
  __le__Owner,
  __gt__Owner,
  __ge__Owner,
  __hash__Owner,
  __repr__Owner,
  __getattribute__Owner,
  __len__Owner,
  __getitem__Owner,
  __setitem__Owner,
  __delitem__Owner,
  __contains__Owner,
  __iter__Owner,
  keysOwner,
  __init__Owner
{ }

// MARK: - DictItemIterator

extension PyDictItemIterator:
  __getattribute__Owner,
  __iter__Owner,
  __next__Owner
{ }

// MARK: - DictItems

extension PyDictItems:
  __eq__Owner,
  __ne__Owner,
  __lt__Owner,
  __le__Owner,
  __gt__Owner,
  __ge__Owner,
  __hash__Owner,
  __repr__Owner,
  __getattribute__Owner,
  __len__Owner,
  __contains__Owner,
  __iter__Owner
{ }

// MARK: - DictKeyIterator

extension PyDictKeyIterator:
  __getattribute__Owner,
  __iter__Owner,
  __next__Owner
{ }

// MARK: - DictKeys

extension PyDictKeys:
  __eq__Owner,
  __ne__Owner,
  __lt__Owner,
  __le__Owner,
  __gt__Owner,
  __ge__Owner,
  __hash__Owner,
  __repr__Owner,
  __getattribute__Owner,
  __len__Owner,
  __contains__Owner,
  __iter__Owner
{ }

// MARK: - DictValueIterator

extension PyDictValueIterator:
  __getattribute__Owner,
  __iter__Owner,
  __next__Owner
{ }

// MARK: - DictValues

extension PyDictValues:
  __repr__Owner,
  __getattribute__Owner,
  __len__Owner,
  __iter__Owner
{ }

// MARK: - Ellipsis

extension PyEllipsis:
  __repr__Owner,
  __getattribute__Owner
{ }

// MARK: - Enumerate

extension PyEnumerate:
  __getattribute__Owner,
  __iter__Owner,
  __next__Owner
{ }

// MARK: - Filter

extension PyFilter:
  __getattribute__Owner,
  __iter__Owner,
  __next__Owner
{ }

// MARK: - Float

extension PyFloat:
  __eq__Owner,
  __ne__Owner,
  __lt__Owner,
  __le__Owner,
  __gt__Owner,
  __ge__Owner,
  __hash__Owner,
  __repr__Owner,
  __str__Owner,
  __bool__Owner,
  __float__Owner,
  __getattribute__Owner,
  __pos__Owner,
  __neg__Owner,
  __abs__Owner,
  __add__Owner,
  __radd__Owner,
  __sub__Owner,
  __rsub__Owner,
  __mul__Owner,
  __rmul__Owner,
  __pow__Owner,
  __rpow__Owner,
  __truediv__Owner,
  __rtruediv__Owner,
  __floordiv__Owner,
  __rfloordiv__Owner,
  __mod__Owner,
  __rmod__Owner,
  __divmod__Owner,
  __rdivmod__Owner,
  __round__Owner,
  __trunc__Owner
{ }

// MARK: - Frame

extension PyFrame:
  __repr__Owner,
  __getattribute__Owner,
  __setattr__Owner
{ }

// MARK: - FrozenSet

extension PyFrozenSet:
  __eq__Owner,
  __ne__Owner,
  __lt__Owner,
  __le__Owner,
  __gt__Owner,
  __ge__Owner,
  __hash__Owner,
  __repr__Owner,
  __getattribute__Owner,
  __len__Owner,
  __contains__Owner,
  __and__Owner,
  __rand__Owner,
  __or__Owner,
  __ror__Owner,
  __xor__Owner,
  __rxor__Owner,
  __sub__Owner,
  __rsub__Owner,
  __iter__Owner
{ }

// MARK: - Function

extension PyFunction:
  __dict__GetterOwner,
  __repr__Owner,
  __call__Owner
{ }

// MARK: - Int

extension PyInt:
  __eq__Owner,
  __ne__Owner,
  __lt__Owner,
  __le__Owner,
  __gt__Owner,
  __ge__Owner,
  __hash__Owner,
  __repr__Owner,
  __str__Owner,
  __bool__Owner,
  __float__Owner,
  __index__Owner,
  __getattribute__Owner,
  __pos__Owner,
  __neg__Owner,
  __abs__Owner,
  __trunc__Owner,
  __add__Owner,
  __radd__Owner,
  __sub__Owner,
  __rsub__Owner,
  __mul__Owner,
  __rmul__Owner,
  __pow__Owner,
  __rpow__Owner,
  __truediv__Owner,
  __rtruediv__Owner,
  __floordiv__Owner,
  __rfloordiv__Owner,
  __mod__Owner,
  __rmod__Owner,
  __divmod__Owner,
  __rdivmod__Owner,
  __lshift__Owner,
  __rlshift__Owner,
  __rshift__Owner,
  __rrshift__Owner,
  __and__Owner,
  __rand__Owner,
  __or__Owner,
  __ror__Owner,
  __xor__Owner,
  __rxor__Owner,
  __invert__Owner,
  __round__Owner
{ }

// MARK: - Iterator

extension PyIterator:
  __getattribute__Owner,
  __iter__Owner,
  __next__Owner
{ }

// MARK: - List

extension PyList:
  __eq__Owner,
  __ne__Owner,
  __lt__Owner,
  __le__Owner,
  __gt__Owner,
  __ge__Owner,
  __hash__Owner,
  __repr__Owner,
  __getattribute__Owner,
  __len__Owner,
  __contains__Owner,
  __getitem__Owner,
  __setitem__Owner,
  __delitem__Owner,
  __iter__Owner,
  __reversed__Owner,
  __add__Owner,
  __iadd__Owner,
  __mul__Owner,
  __rmul__Owner,
  __init__Owner
{ }

// MARK: - ListIterator

extension PyListIterator:
  __getattribute__Owner,
  __iter__Owner,
  __next__Owner
{ }

// MARK: - ListReverseIterator

extension PyListReverseIterator:
  __getattribute__Owner,
  __iter__Owner,
  __next__Owner
{ }

// MARK: - Map

extension PyMap:
  __getattribute__Owner,
  __iter__Owner,
  __next__Owner
{ }

// MARK: - Method

extension PyMethod:
  __eq__Owner,
  __ne__Owner,
  __lt__Owner,
  __le__Owner,
  __gt__Owner,
  __ge__Owner,
  __repr__Owner,
  __hash__Owner,
  __getattribute__Owner,
  __setattr__Owner,
  __call__Owner
{ }

// MARK: - Module

extension PyModule:
  __dict__GetterOwner,
  __repr__Owner,
  __getattribute__Owner,
  __setattr__Owner,
  __dir__Owner,
  __init__Owner
{ }

// MARK: - Namespace

extension PyNamespace:
  __dict__GetterOwner,
  __eq__Owner,
  __ne__Owner,
  __lt__Owner,
  __le__Owner,
  __gt__Owner,
  __ge__Owner,
  __repr__Owner,
  __getattribute__Owner,
  __setattr__Owner,
  __init__Owner
{ }

// MARK: - None

extension PyNone:
  __repr__Owner,
  __bool__Owner,
  __getattribute__Owner
{ }

// MARK: - NotImplemented

extension PyNotImplemented:
  __repr__Owner
{ }

// MARK: - Property

extension PyProperty:
  __getattribute__Owner,
  __init__Owner
{ }

// MARK: - Range

extension PyRange:
  __eq__Owner,
  __ne__Owner,
  __lt__Owner,
  __le__Owner,
  __gt__Owner,
  __ge__Owner,
  __hash__Owner,
  __repr__Owner,
  __bool__Owner,
  __len__Owner,
  __getattribute__Owner,
  __contains__Owner,
  __getitem__Owner,
  __reversed__Owner,
  __iter__Owner
{ }

// MARK: - RangeIterator

extension PyRangeIterator:
  __getattribute__Owner,
  __iter__Owner,
  __next__Owner
{ }

// MARK: - Reversed

extension PyReversed:
  __getattribute__Owner,
  __iter__Owner,
  __next__Owner
{ }

// MARK: - Set

extension PySet:
  __eq__Owner,
  __ne__Owner,
  __lt__Owner,
  __le__Owner,
  __gt__Owner,
  __ge__Owner,
  __hash__Owner,
  __repr__Owner,
  __getattribute__Owner,
  __len__Owner,
  __contains__Owner,
  __and__Owner,
  __rand__Owner,
  __or__Owner,
  __ror__Owner,
  __xor__Owner,
  __rxor__Owner,
  __sub__Owner,
  __rsub__Owner,
  __iter__Owner,
  __init__Owner
{ }

// MARK: - SetIterator

extension PySetIterator:
  __getattribute__Owner,
  __iter__Owner,
  __next__Owner
{ }

// MARK: - Slice

extension PySlice:
  __eq__Owner,
  __ne__Owner,
  __lt__Owner,
  __le__Owner,
  __gt__Owner,
  __ge__Owner,
  __hash__Owner,
  __repr__Owner,
  __getattribute__Owner
{ }

// MARK: - StaticMethod

extension PyStaticMethod:
  __dict__GetterOwner,
  __isabstractmethod__Owner,
  __init__Owner
{ }

// MARK: - String

extension PyString:
  __eq__Owner,
  __ne__Owner,
  __lt__Owner,
  __le__Owner,
  __gt__Owner,
  __ge__Owner,
  __hash__Owner,
  __repr__Owner,
  __str__Owner,
  __getattribute__Owner,
  __len__Owner,
  __contains__Owner,
  __getitem__Owner,
  __add__Owner,
  __mul__Owner,
  __rmul__Owner,
  __iter__Owner
{ }

// MARK: - StringIterator

extension PyStringIterator:
  __getattribute__Owner,
  __iter__Owner,
  __next__Owner
{ }

// MARK: - Super

extension PySuper:
  __repr__Owner,
  __getattribute__Owner,
  __init__Owner
{ }

// MARK: - TextFile

extension PyTextFile:
  __repr__Owner,
  __del__Owner
{ }

// MARK: - Tuple

extension PyTuple:
  __eq__Owner,
  __ne__Owner,
  __lt__Owner,
  __le__Owner,
  __gt__Owner,
  __ge__Owner,
  __hash__Owner,
  __repr__Owner,
  __getattribute__Owner,
  __len__Owner,
  __contains__Owner,
  __getitem__Owner,
  __iter__Owner,
  __add__Owner,
  __mul__Owner,
  __rmul__Owner
{ }

// MARK: - TupleIterator

extension PyTupleIterator:
  __getattribute__Owner,
  __iter__Owner,
  __next__Owner
{ }

// MARK: - Zip

extension PyZip:
  __getattribute__Owner,
  __iter__Owner,
  __next__Owner
{ }

// MARK: - ArithmeticError

// PyArithmeticError does not add any new protocols to PyException
extension PyArithmeticError { }

// MARK: - AssertionError

// PyAssertionError does not add any new protocols to PyException
extension PyAssertionError { }

// MARK: - AttributeError

// PyAttributeError does not add any new protocols to PyException
extension PyAttributeError { }

// MARK: - BaseException

extension PyBaseException:
  __dict__GetterOwner,
  __repr__Owner,
  __str__Owner,
  __getattribute__Owner,
  __setattr__Owner,
  __init__Owner
{ }

// MARK: - BlockingIOError

// PyBlockingIOError does not add any new protocols to PyOSError
extension PyBlockingIOError { }

// MARK: - BrokenPipeError

// PyBrokenPipeError does not add any new protocols to PyConnectionError
extension PyBrokenPipeError { }

// MARK: - BufferError

// PyBufferError does not add any new protocols to PyException
extension PyBufferError { }

// MARK: - BytesWarning

// PyBytesWarning does not add any new protocols to PyWarning
extension PyBytesWarning { }

// MARK: - ChildProcessError

// PyChildProcessError does not add any new protocols to PyOSError
extension PyChildProcessError { }

// MARK: - ConnectionAbortedError

// PyConnectionAbortedError does not add any new protocols to PyConnectionError
extension PyConnectionAbortedError { }

// MARK: - ConnectionError

// PyConnectionError does not add any new protocols to PyOSError
extension PyConnectionError { }

// MARK: - ConnectionRefusedError

// PyConnectionRefusedError does not add any new protocols to PyConnectionError
extension PyConnectionRefusedError { }

// MARK: - ConnectionResetError

// PyConnectionResetError does not add any new protocols to PyConnectionError
extension PyConnectionResetError { }

// MARK: - DeprecationWarning

// PyDeprecationWarning does not add any new protocols to PyWarning
extension PyDeprecationWarning { }

// MARK: - EOFError

// PyEOFError does not add any new protocols to PyException
extension PyEOFError { }

// MARK: - Exception

// PyException does not add any new protocols to PyBaseException
extension PyException { }

// MARK: - FileExistsError

// PyFileExistsError does not add any new protocols to PyOSError
extension PyFileExistsError { }

// MARK: - FileNotFoundError

// PyFileNotFoundError does not add any new protocols to PyOSError
extension PyFileNotFoundError { }

// MARK: - FloatingPointError

// PyFloatingPointError does not add any new protocols to PyArithmeticError
extension PyFloatingPointError { }

// MARK: - FutureWarning

// PyFutureWarning does not add any new protocols to PyWarning
extension PyFutureWarning { }

// MARK: - GeneratorExit

// PyGeneratorExit does not add any new protocols to PyBaseException
extension PyGeneratorExit { }

// MARK: - ImportError

// PyImportError does not add any new protocols to PyException
extension PyImportError { }

// MARK: - ImportWarning

// PyImportWarning does not add any new protocols to PyWarning
extension PyImportWarning { }

// MARK: - IndentationError

// PyIndentationError does not add any new protocols to PySyntaxError
extension PyIndentationError { }

// MARK: - IndexError

// PyIndexError does not add any new protocols to PyLookupError
extension PyIndexError { }

// MARK: - InterruptedError

// PyInterruptedError does not add any new protocols to PyOSError
extension PyInterruptedError { }

// MARK: - IsADirectoryError

// PyIsADirectoryError does not add any new protocols to PyOSError
extension PyIsADirectoryError { }

// MARK: - KeyError

// PyKeyError does not add any new protocols to PyLookupError
extension PyKeyError { }

// MARK: - KeyboardInterrupt

// PyKeyboardInterrupt does not add any new protocols to PyBaseException
extension PyKeyboardInterrupt { }

// MARK: - LookupError

// PyLookupError does not add any new protocols to PyException
extension PyLookupError { }

// MARK: - MemoryError

// PyMemoryError does not add any new protocols to PyException
extension PyMemoryError { }

// MARK: - ModuleNotFoundError

// PyModuleNotFoundError does not add any new protocols to PyImportError
extension PyModuleNotFoundError { }

// MARK: - NameError

// PyNameError does not add any new protocols to PyException
extension PyNameError { }

// MARK: - NotADirectoryError

// PyNotADirectoryError does not add any new protocols to PyOSError
extension PyNotADirectoryError { }

// MARK: - NotImplementedError

// PyNotImplementedError does not add any new protocols to PyRuntimeError
extension PyNotImplementedError { }

// MARK: - OSError

// PyOSError does not add any new protocols to PyException
extension PyOSError { }

// MARK: - OverflowError

// PyOverflowError does not add any new protocols to PyArithmeticError
extension PyOverflowError { }

// MARK: - PendingDeprecationWarning

// PyPendingDeprecationWarning does not add any new protocols to PyWarning
extension PyPendingDeprecationWarning { }

// MARK: - PermissionError

// PyPermissionError does not add any new protocols to PyOSError
extension PyPermissionError { }

// MARK: - ProcessLookupError

// PyProcessLookupError does not add any new protocols to PyOSError
extension PyProcessLookupError { }

// MARK: - RecursionError

// PyRecursionError does not add any new protocols to PyRuntimeError
extension PyRecursionError { }

// MARK: - ReferenceError

// PyReferenceError does not add any new protocols to PyException
extension PyReferenceError { }

// MARK: - ResourceWarning

// PyResourceWarning does not add any new protocols to PyWarning
extension PyResourceWarning { }

// MARK: - RuntimeError

// PyRuntimeError does not add any new protocols to PyException
extension PyRuntimeError { }

// MARK: - RuntimeWarning

// PyRuntimeWarning does not add any new protocols to PyWarning
extension PyRuntimeWarning { }

// MARK: - StopAsyncIteration

// PyStopAsyncIteration does not add any new protocols to PyException
extension PyStopAsyncIteration { }

// MARK: - StopIteration

// PyStopIteration does not add any new protocols to PyException
extension PyStopIteration { }

// MARK: - SyntaxError

// PySyntaxError does not add any new protocols to PyException
extension PySyntaxError { }

// MARK: - SyntaxWarning

// PySyntaxWarning does not add any new protocols to PyWarning
extension PySyntaxWarning { }

// MARK: - SystemError

// PySystemError does not add any new protocols to PyException
extension PySystemError { }

// MARK: - SystemExit

// PySystemExit does not add any new protocols to PyBaseException
extension PySystemExit { }

// MARK: - TabError

// PyTabError does not add any new protocols to PyIndentationError
extension PyTabError { }

// MARK: - TimeoutError

// PyTimeoutError does not add any new protocols to PyOSError
extension PyTimeoutError { }

// MARK: - TypeError

// PyTypeError does not add any new protocols to PyException
extension PyTypeError { }

// MARK: - UnboundLocalError

// PyUnboundLocalError does not add any new protocols to PyNameError
extension PyUnboundLocalError { }

// MARK: - UnicodeDecodeError

// PyUnicodeDecodeError does not add any new protocols to PyUnicodeError
extension PyUnicodeDecodeError { }

// MARK: - UnicodeEncodeError

// PyUnicodeEncodeError does not add any new protocols to PyUnicodeError
extension PyUnicodeEncodeError { }

// MARK: - UnicodeError

// PyUnicodeError does not add any new protocols to PyValueError
extension PyUnicodeError { }

// MARK: - UnicodeTranslateError

// PyUnicodeTranslateError does not add any new protocols to PyUnicodeError
extension PyUnicodeTranslateError { }

// MARK: - UnicodeWarning

// PyUnicodeWarning does not add any new protocols to PyWarning
extension PyUnicodeWarning { }

// MARK: - UserWarning

// PyUserWarning does not add any new protocols to PyWarning
extension PyUserWarning { }

// MARK: - ValueError

// PyValueError does not add any new protocols to PyException
extension PyValueError { }

// MARK: - Warning

// PyWarning does not add any new protocols to PyException
extension PyWarning { }

// MARK: - ZeroDivisionError

// PyZeroDivisionError does not add any new protocols to PyArithmeticError
extension PyZeroDivisionError { }

