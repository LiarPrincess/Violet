// swiftlint:disable file_length
// swiftlint:disable opening_brace
// swiftlint:disable trailing_newline

// MARK: - BaseObject

// PyBaseObject does not own anything.
extension PyBaseObject { }

// MARK: - Type

// Type does not own anything.
extension PyType { }

// MARK: - Bool

// PyBool does not add any new protocols to PyInt
extension PyBool { }

// MARK: - BuiltinFunction

extension PyBuiltinFunction:
  __class__GetterOwner,
  __name__GetterOwner,
  __qualname__GetterOwner,
  __text_signature__GetterOwner,
  __module__GetterOwner,
  __self__GetterOwner,
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

// MARK: - Code

extension PyCode:
  __class__GetterOwner,
  __eq__Owner,
  __lt__Owner,
  __le__Owner,
  __gt__Owner,
  __ge__Owner,
  __hash__Owner,
  __repr__Owner
{ }

// MARK: - Complex

extension PyComplex:
  __class__GetterOwner,
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
  __int__Owner,
  __float__Owner,
  realOwner,
  imagOwner,
  conjugateOwner,
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
  __class__GetterOwner,
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
  clearOwner,
  getOwner,
  setdefaultOwner,
  copyOwner,
  popitemOwner
{ }

// MARK: - Ellipsis

extension PyEllipsis:
  __class__GetterOwner,
  __repr__Owner,
  __getattribute__Owner
{ }

// MARK: - Float

extension PyFloat:
  __class__GetterOwner,
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
  __int__Owner,
  __float__Owner,
  realOwner,
  imagOwner,
  conjugateOwner,
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
  __round__Owner
{ }

// MARK: - FrozenSet

extension PyFrozenSet:
  __class__GetterOwner,
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
  issubsetOwner,
  issupersetOwner,
  intersectionOwner,
  unionOwner,
  differenceOwner,
  symmetric_differenceOwner,
  isdisjointOwner,
  copyOwner
{ }

// MARK: - Function

extension PyFunction:
  __class__GetterOwner,
  __name__GetterOwner,
  __name__SetterOwner,
  __qualname__GetterOwner,
  __qualname__SetterOwner,
  __code__GetterOwner,
  __doc__GetterOwner,
  __module__GetterOwner,
  __dict__GetterOwner,
  __repr__Owner,
  __get__Owner
{ }

// MARK: - Int

extension PyInt:
  __class__GetterOwner,
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
  __int__Owner,
  __float__Owner,
  __index__Owner,
  realOwner,
  imagOwner,
  conjugateOwner,
  numeratorOwner,
  denominatorOwner,
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

// MARK: - List

extension PyList:
  __class__GetterOwner,
  __eq__Owner,
  __ne__Owner,
  __lt__Owner,
  __le__Owner,
  __gt__Owner,
  __ge__Owner,
  __repr__Owner,
  __getattribute__Owner,
  __len__Owner,
  __contains__Owner,
  __getitem__Owner,
  countOwner,
  indexOwner,
  appendOwner,
  clearOwner,
  copyOwner,
  __add__Owner,
  __mul__Owner,
  __rmul__Owner,
  __imul__Owner
{ }

// MARK: - Method

extension PyMethod:
  __class__GetterOwner,
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
  __delattr__Owner,
  __func__Owner,
  __self__Owner,
  __get__Owner
{ }

// MARK: - Module

extension PyModule:
  __dict__GetterOwner,
  __class__GetterOwner,
  __repr__Owner,
  __getattribute__Owner,
  __setattr__Owner,
  __delattr__Owner,
  __dir__Owner
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
  __delattr__Owner
{ }

// MARK: - None

extension PyNone:
  __class__GetterOwner,
  __repr__Owner,
  __bool__Owner
{ }

// MARK: - NotImplemented

extension PyNotImplemented:
  __class__GetterOwner,
  __repr__Owner
{ }

// MARK: - Property

extension PyProperty:
  __class__GetterOwner,
  FgetGetterOwner,
  FsetGetterOwner,
  FdelGetterOwner,
  __getattribute__Owner,
  __get__Owner,
  __set__Owner,
  __delete__Owner
{ }

// MARK: - Range

extension PyRange:
  __class__GetterOwner,
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
  countOwner,
  indexOwner
{ }

// MARK: - Set

extension PySet:
  __class__GetterOwner,
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
  issubsetOwner,
  issupersetOwner,
  intersectionOwner,
  unionOwner,
  differenceOwner,
  symmetric_differenceOwner,
  isdisjointOwner,
  addOwner,
  removeOwner,
  discardOwner,
  clearOwner,
  copyOwner
{ }

// MARK: - Slice

extension PySlice:
  __class__GetterOwner,
  __eq__Owner,
  __ne__Owner,
  __lt__Owner,
  __le__Owner,
  __gt__Owner,
  __ge__Owner,
  __repr__Owner,
  __getattribute__Owner
{ }

// MARK: - String

extension PyString:
  __class__GetterOwner,
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
  isalnumOwner,
  isalphaOwner,
  isasciiOwner,
  isdecimalOwner,
  isdigitOwner,
  isidentifierOwner,
  islowerOwner,
  isnumericOwner,
  isprintableOwner,
  isspaceOwner,
  istitleOwner,
  isupperOwner,
  startswithOwner,
  startswithRangedOwner,
  endswithOwner,
  endswithRangedOwner,
  stripOwner,
  lstripOwner,
  rstripOwner,
  findOwner,
  findRangedOwner,
  rfindOwner,
  rfindRangedOwner,
  indexOwner,
  indexRangedOwner,
  rindexOwner,
  rindexRangedOwner,
  lowerOwner,
  upperOwner,
  titleOwner,
  swapcaseOwner,
  casefoldOwner,
  capitalizeOwner,
  centerOwner,
  ljustOwner,
  rjustOwner,
  splitOwner,
  rsplitOwner,
  splitlinesOwner,
  partitionOwner,
  rpartitionOwner,
  expandtabsOwner,
  countOwner,
  countRangedOwner,
  replaceOwner,
  zfillOwner,
  __add__Owner,
  __mul__Owner,
  __rmul__Owner
{ }

// MARK: - Tuple

extension PyTuple:
  __class__GetterOwner,
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
  countOwner,
  indexOwner,
  __add__Owner,
  __mul__Owner,
  __rmul__Owner
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
  __class__GetterOwner,
  ArgsGetterOwner,
  ArgsSetterOwner,
  __traceback__GetterOwner,
  __traceback__SetterOwner,
  __cause__GetterOwner,
  __cause__SetterOwner,
  __context__GetterOwner,
  __context__SetterOwner,
  __suppress_context__GetterOwner,
  __suppress_context__SetterOwner,
  __repr__Owner,
  __str__Owner,
  __getattribute__Owner,
  __setattr__Owner,
  __delattr__Owner
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
