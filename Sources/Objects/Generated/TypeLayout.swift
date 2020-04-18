// swiftlint:disable file_length

// Please note that this file was automatically generated. DO NOT EDIT!
// The same goes for other files in 'Generated' directory.

// When creating new class we will check if all of the base classes have
// the same layout.
// So, for example we will allow this:
//   >>> class C(int, object): pass
// but do not allow this:
//   >>> class C(int, str): pass
//   TypeError: multiple bases have instance lay-out conflict

internal class TypeLayout: Equatable {

  private let base: TypeLayout?

  private init() {
    self.base = nil
  }

  private init(base: TypeLayout) {
    self.base = base
  }

  /// Is the current layout based on given layout?
  /// 'Based' means that that is uses the given layout, but has more properties.
  internal func isAddingNewProperties(to other: TypeLayout) -> Bool {
    var parentOrNil: TypeLayout? = self

    while let parent = parentOrNil {
      if parent == other {
        return true
      }

      parentOrNil = parent.base
    }

    return false
  }

  internal static func == (lhs: TypeLayout, rhs: TypeLayout) -> Bool {
    let lhsId = ObjectIdentifier(lhs)
    let rhsId = ObjectIdentifier(rhs)
    return lhsId == rhsId
  }

  /// - `_type: PyType!`
  /// - `flags: PyObjectFlags`
  internal static let PyObject = TypeLayout()
  /// `PyBool` uses the same layout as it s base type (`PyInt`).
  internal static let PyBool = TypeLayout.PyInt
  /// - `function: FunctionWrapper`
  /// - `module: PyObject?`
  /// - `doc: String?`
  internal static let PyBuiltinFunction = TypeLayout(base: TypeLayout.PyObject)
  /// - `function: FunctionWrapper`
  /// - `object: PyObject`
  /// - `module: PyObject?`
  /// - `doc: String?`
  internal static let PyBuiltinMethod = TypeLayout(base: TypeLayout.PyObject)
  /// - `data: PyBytesData`
  internal static let PyByteArray = TypeLayout(base: TypeLayout.PyObject)
  /// - `bytes: PyByteArray`
  /// - `index: Int`
  internal static let PyByteArrayIterator = TypeLayout(base: TypeLayout.PyObject)
  /// - `data: PyBytesData`
  internal static let PyBytes = TypeLayout(base: TypeLayout.PyObject)
  /// - `bytes: PyBytes`
  /// - `index: Int`
  internal static let PyBytesIterator = TypeLayout(base: TypeLayout.PyObject)
  /// - `callable: PyObject`
  /// - `sentinel: PyObject`
  internal static let PyCallableIterator = TypeLayout(base: TypeLayout.PyObject)
  /// - `content: PyObject?`
  internal static let PyCell = TypeLayout(base: TypeLayout.PyObject)
  /// - `callable: PyObject?`
  /// - `__dict__: PyDict`
  internal static let PyClassMethod = TypeLayout(base: TypeLayout.PyObject)
  /// - `codeObject: CodeObject`
  /// - `name: PyString`
  /// - `qualifiedName: PyString`
  /// - `filename: PyString`
  /// - `constants: [Constant]`
  /// - `names: [PyString]`
  internal static let PyCode = TypeLayout(base: TypeLayout.PyObject)
  /// - `real: Double`
  /// - `imag: Double`
  internal static let PyComplex = TypeLayout(base: TypeLayout.PyObject)
  /// - `data: PyDictData`
  internal static let PyDict = TypeLayout(base: TypeLayout.PyObject)
  /// - `object: PyDict`
  /// - `index: Int`
  /// - `initCount: Int`
  internal static let PyDictItemIterator = TypeLayout(base: TypeLayout.PyObject)
  /// - `dict: PyDict`
  internal static let PyDictItems = TypeLayout(base: TypeLayout.PyObject)
  /// - `object: PyDict`
  /// - `index: Int`
  /// - `initCount: Int`
  internal static let PyDictKeyIterator = TypeLayout(base: TypeLayout.PyObject)
  /// - `dict: PyDict`
  internal static let PyDictKeys = TypeLayout(base: TypeLayout.PyObject)
  /// - `object: PyDict`
  /// - `index: Int`
  /// - `initCount: Int`
  internal static let PyDictValueIterator = TypeLayout(base: TypeLayout.PyObject)
  /// - `dict: PyDict`
  internal static let PyDictValues = TypeLayout(base: TypeLayout.PyObject)
  /// `PyEllipsis` uses the same layout as it s base type (`PyObject`).
  internal static let PyEllipsis = TypeLayout.PyObject
  /// - `iterator: PyObject`
  /// - `nextIndex: BigInt`
  internal static let PyEnumerate = TypeLayout(base: TypeLayout.PyObject)
  /// - `fn: PyObject`
  /// - `iterator: PyObject`
  internal static let PyFilter = TypeLayout(base: TypeLayout.PyObject)
  /// - `value: Double`
  internal static let PyFloat = TypeLayout(base: TypeLayout.PyObject)
  /// - `code: PyCode`
  /// - `parent: PyFrame?`
  /// - `stack: ObjectStack`
  /// - `blocks: BlockStack`
  /// - `locals: PyDict`
  /// - `globals: PyDict`
  /// - `builtins: PyDict`
  /// - `fastLocals: [PyObject?]`
  /// - `cellsAndFreeVariables: [PyCell]`
  /// - `instructionIndex: Int?`
  internal static let PyFrame = TypeLayout(base: TypeLayout.PyObject)
  /// - `data: PySetData`
  internal static let PyFrozenSet = TypeLayout(base: TypeLayout.PyObject)
  /// - `name: PyString`
  /// - `qualname: PyString`
  /// - `doc: PyString?`
  /// - `module: PyObject`
  /// - `code: PyCode`
  /// - `globals: PyDict`
  /// - `defaults: PyTuple?`
  /// - `kwDefaults: PyDict?`
  /// - `closure: PyTuple?`
  /// - `annotations: PyDict?`
  /// - `__dict__: PyDict`
  internal static let PyFunction = TypeLayout(base: TypeLayout.PyObject)
  /// - `value: BigInt`
  internal static let PyInt = TypeLayout(base: TypeLayout.PyObject)
  /// - `sequence: PyObject`
  /// - `index: Int`
  internal static let PyIterator = TypeLayout(base: TypeLayout.PyObject)
  /// - `data: PySequenceData`
  internal static let PyList = TypeLayout(base: TypeLayout.PyObject)
  /// - `list: PyList`
  /// - `index: Int`
  internal static let PyListIterator = TypeLayout(base: TypeLayout.PyObject)
  /// - `list: PyList`
  /// - `index: Int`
  internal static let PyListReverseIterator = TypeLayout(base: TypeLayout.PyObject)
  /// - `fn: PyObject`
  /// - `iterators: [PyObject]`
  internal static let PyMap = TypeLayout(base: TypeLayout.PyObject)
  /// - `function: PyFunction`
  /// - `object: PyObject`
  internal static let PyMethod = TypeLayout(base: TypeLayout.PyObject)
  /// - `__dict__: PyDict`
  internal static let PyModule = TypeLayout(base: TypeLayout.PyObject)
  /// - `__dict__: PyDict`
  internal static let PyNamespace = TypeLayout(base: TypeLayout.PyObject)
  /// `PyNone` uses the same layout as it s base type (`PyObject`).
  internal static let PyNone = TypeLayout.PyObject
  /// `PyNotImplemented` uses the same layout as it s base type (`PyObject`).
  internal static let PyNotImplemented = TypeLayout.PyObject
  /// - `_get: PyObject?`
  /// - `_set: PyObject?`
  /// - `_del: PyObject?`
  /// - `doc: PyObject?`
  internal static let PyProperty = TypeLayout(base: TypeLayout.PyObject)
  /// - `start: PyInt`
  /// - `stop: PyInt`
  /// - `step: PyInt`
  /// - `length: PyInt`
  /// - `stepType: StepType`
  internal static let PyRange = TypeLayout(base: TypeLayout.PyObject)
  /// - `start: BigInt`
  /// - `step: BigInt`
  /// - `length: BigInt`
  /// - `index: BigInt`
  internal static let PyRangeIterator = TypeLayout(base: TypeLayout.PyObject)
  /// - `sequence: PyObject`
  /// - `index: Int`
  internal static let PyReversed = TypeLayout(base: TypeLayout.PyObject)
  /// - `data: PySetData`
  internal static let PySet = TypeLayout(base: TypeLayout.PyObject)
  /// - `set: PySetType`
  /// - `index: Int`
  /// - `initCount: Int`
  internal static let PySetIterator = TypeLayout(base: TypeLayout.PyObject)
  /// - `start: PyObject`
  /// - `stop: PyObject`
  /// - `step: PyObject`
  internal static let PySlice = TypeLayout(base: TypeLayout.PyObject)
  /// - `callable: PyObject?`
  /// - `__dict__: PyDict`
  internal static let PyStaticMethod = TypeLayout(base: TypeLayout.PyObject)
  /// - `data: PyStringData`
  internal static let PyString = TypeLayout(base: TypeLayout.PyObject)
  /// - `string: PyString`
  /// - `index: Int`
  internal static let PyStringIterator = TypeLayout(base: TypeLayout.PyObject)
  /// - `thisClass: PyType?`
  /// - `object: PyObject?`
  /// - `objectType: PyType?`
  internal static let PySuper = TypeLayout(base: TypeLayout.PyObject)
  /// - `name: String?`
  /// - `fd: FileDescriptorType`
  /// - `encoding: PyStringEncoding`
  /// - `errors: PyStringErrorHandler`
  /// - `mode: FileMode`
  /// - `closeOnDealloc: Bool`
  internal static let PyTextFile = TypeLayout(base: TypeLayout.PyObject)
  /// `PyTraceback` uses the same layout as it s base type (`PyObject`).
  internal static let PyTraceback = TypeLayout.PyObject
  /// - `data: PySequenceData`
  internal static let PyTuple = TypeLayout(base: TypeLayout.PyObject)
  /// - `tuple: PyTuple`
  /// - `index: Int`
  internal static let PyTupleIterator = TypeLayout(base: TypeLayout.PyObject)
  /// - `name: String`
  /// - `qualname: String`
  /// - `base: PyType?`
  /// - `bases: [PyType]`
  /// - `mro: [PyType]`
  /// - `subclasses: [PyTypeWeakRef]`
  /// - `__dict__: PyDict`
  /// - `layout: TypeLayout?`
  /// - `typeFlags: PyTypeFlags`
  internal static let PyType = TypeLayout(base: TypeLayout.PyObject)
  /// - `iterators: [PyObject]`
  internal static let PyZip = TypeLayout(base: TypeLayout.PyObject)
  /// `PyArithmeticError` uses the same layout as it s base type (`PyException`).
  internal static let PyArithmeticError = TypeLayout.PyException
  /// `PyAssertionError` uses the same layout as it s base type (`PyException`).
  internal static let PyAssertionError = TypeLayout.PyException
  /// `PyAttributeError` uses the same layout as it s base type (`PyException`).
  internal static let PyAttributeError = TypeLayout.PyException
  /// - `args: PyTuple`
  /// - `traceback: PyObject?`
  /// - `cause: PyObject?`
  /// - `__dict__: Py`
  /// - `context: PyBaseException?`
  /// - `suppressContext: Bool`
  internal static let PyBaseException = TypeLayout(base: TypeLayout.PyObject)
  /// `PyBlockingIOError` uses the same layout as it s base type (`PyOSError`).
  internal static let PyBlockingIOError = TypeLayout.PyOSError
  /// `PyBrokenPipeError` uses the same layout as it s base type (`PyConnectionError`).
  internal static let PyBrokenPipeError = TypeLayout.PyConnectionError
  /// `PyBufferError` uses the same layout as it s base type (`PyException`).
  internal static let PyBufferError = TypeLayout.PyException
  /// `PyBytesWarning` uses the same layout as it s base type (`PyWarning`).
  internal static let PyBytesWarning = TypeLayout.PyWarning
  /// `PyChildProcessError` uses the same layout as it s base type (`PyOSError`).
  internal static let PyChildProcessError = TypeLayout.PyOSError
  /// `PyConnectionAbortedError` uses the same layout as it s base type (`PyConnectionError`).
  internal static let PyConnectionAbortedError = TypeLayout.PyConnectionError
  /// `PyConnectionError` uses the same layout as it s base type (`PyOSError`).
  internal static let PyConnectionError = TypeLayout.PyOSError
  /// `PyConnectionRefusedError` uses the same layout as it s base type (`PyConnectionError`).
  internal static let PyConnectionRefusedError = TypeLayout.PyConnectionError
  /// `PyConnectionResetError` uses the same layout as it s base type (`PyConnectionError`).
  internal static let PyConnectionResetError = TypeLayout.PyConnectionError
  /// `PyDeprecationWarning` uses the same layout as it s base type (`PyWarning`).
  internal static let PyDeprecationWarning = TypeLayout.PyWarning
  /// `PyEOFError` uses the same layout as it s base type (`PyException`).
  internal static let PyEOFError = TypeLayout.PyException
  /// `PyException` uses the same layout as it s base type (`PyBaseException`).
  internal static let PyException = TypeLayout.PyBaseException
  /// `PyFileExistsError` uses the same layout as it s base type (`PyOSError`).
  internal static let PyFileExistsError = TypeLayout.PyOSError
  /// `PyFileNotFoundError` uses the same layout as it s base type (`PyOSError`).
  internal static let PyFileNotFoundError = TypeLayout.PyOSError
  /// `PyFloatingPointError` uses the same layout as it s base type (`PyArithmeticError`).
  internal static let PyFloatingPointError = TypeLayout.PyArithmeticError
  /// `PyFutureWarning` uses the same layout as it s base type (`PyWarning`).
  internal static let PyFutureWarning = TypeLayout.PyWarning
  /// `PyGeneratorExit` uses the same layout as it s base type (`PyBaseException`).
  internal static let PyGeneratorExit = TypeLayout.PyBaseException
  /// `PyImportError` uses the same layout as it s base type (`PyException`).
  internal static let PyImportError = TypeLayout.PyException
  /// `PyImportWarning` uses the same layout as it s base type (`PyWarning`).
  internal static let PyImportWarning = TypeLayout.PyWarning
  /// `PyIndentationError` uses the same layout as it s base type (`PySyntaxError`).
  internal static let PyIndentationError = TypeLayout.PySyntaxError
  /// `PyIndexError` uses the same layout as it s base type (`PyLookupError`).
  internal static let PyIndexError = TypeLayout.PyLookupError
  /// `PyInterruptedError` uses the same layout as it s base type (`PyOSError`).
  internal static let PyInterruptedError = TypeLayout.PyOSError
  /// `PyIsADirectoryError` uses the same layout as it s base type (`PyOSError`).
  internal static let PyIsADirectoryError = TypeLayout.PyOSError
  /// `PyKeyError` uses the same layout as it s base type (`PyLookupError`).
  internal static let PyKeyError = TypeLayout.PyLookupError
  /// `PyKeyboardInterrupt` uses the same layout as it s base type (`PyBaseException`).
  internal static let PyKeyboardInterrupt = TypeLayout.PyBaseException
  /// `PyLookupError` uses the same layout as it s base type (`PyException`).
  internal static let PyLookupError = TypeLayout.PyException
  /// `PyMemoryError` uses the same layout as it s base type (`PyException`).
  internal static let PyMemoryError = TypeLayout.PyException
  /// `PyModuleNotFoundError` uses the same layout as it s base type (`PyImportError`).
  internal static let PyModuleNotFoundError = TypeLayout.PyImportError
  /// `PyNameError` uses the same layout as it s base type (`PyException`).
  internal static let PyNameError = TypeLayout.PyException
  /// `PyNotADirectoryError` uses the same layout as it s base type (`PyOSError`).
  internal static let PyNotADirectoryError = TypeLayout.PyOSError
  /// `PyNotImplementedError` uses the same layout as it s base type (`PyRuntimeError`).
  internal static let PyNotImplementedError = TypeLayout.PyRuntimeError
  /// `PyOSError` uses the same layout as it s base type (`PyException`).
  internal static let PyOSError = TypeLayout.PyException
  /// `PyOverflowError` uses the same layout as it s base type (`PyArithmeticError`).
  internal static let PyOverflowError = TypeLayout.PyArithmeticError
  /// `PyPendingDeprecationWarning` uses the same layout as it s base type (`PyWarning`).
  internal static let PyPendingDeprecationWarning = TypeLayout.PyWarning
  /// `PyPermissionError` uses the same layout as it s base type (`PyOSError`).
  internal static let PyPermissionError = TypeLayout.PyOSError
  /// `PyProcessLookupError` uses the same layout as it s base type (`PyOSError`).
  internal static let PyProcessLookupError = TypeLayout.PyOSError
  /// `PyRecursionError` uses the same layout as it s base type (`PyRuntimeError`).
  internal static let PyRecursionError = TypeLayout.PyRuntimeError
  /// `PyReferenceError` uses the same layout as it s base type (`PyException`).
  internal static let PyReferenceError = TypeLayout.PyException
  /// `PyResourceWarning` uses the same layout as it s base type (`PyWarning`).
  internal static let PyResourceWarning = TypeLayout.PyWarning
  /// `PyRuntimeError` uses the same layout as it s base type (`PyException`).
  internal static let PyRuntimeError = TypeLayout.PyException
  /// `PyRuntimeWarning` uses the same layout as it s base type (`PyWarning`).
  internal static let PyRuntimeWarning = TypeLayout.PyWarning
  /// `PyStopAsyncIteration` uses the same layout as it s base type (`PyException`).
  internal static let PyStopAsyncIteration = TypeLayout.PyException
  /// `PyStopIteration` uses the same layout as it s base type (`PyException`).
  internal static let PyStopIteration = TypeLayout.PyException
  /// `PySyntaxError` uses the same layout as it s base type (`PyException`).
  internal static let PySyntaxError = TypeLayout.PyException
  /// `PySyntaxWarning` uses the same layout as it s base type (`PyWarning`).
  internal static let PySyntaxWarning = TypeLayout.PyWarning
  /// `PySystemError` uses the same layout as it s base type (`PyException`).
  internal static let PySystemError = TypeLayout.PyException
  /// `PySystemExit` uses the same layout as it s base type (`PyBaseException`).
  internal static let PySystemExit = TypeLayout.PyBaseException
  /// `PyTabError` uses the same layout as it s base type (`PyIndentationError`).
  internal static let PyTabError = TypeLayout.PyIndentationError
  /// `PyTimeoutError` uses the same layout as it s base type (`PyOSError`).
  internal static let PyTimeoutError = TypeLayout.PyOSError
  /// `PyTypeError` uses the same layout as it s base type (`PyException`).
  internal static let PyTypeError = TypeLayout.PyException
  /// `PyUnboundLocalError` uses the same layout as it s base type (`PyNameError`).
  internal static let PyUnboundLocalError = TypeLayout.PyNameError
  /// `PyUnicodeDecodeError` uses the same layout as it s base type (`PyUnicodeError`).
  internal static let PyUnicodeDecodeError = TypeLayout.PyUnicodeError
  /// `PyUnicodeEncodeError` uses the same layout as it s base type (`PyUnicodeError`).
  internal static let PyUnicodeEncodeError = TypeLayout.PyUnicodeError
  /// `PyUnicodeError` uses the same layout as it s base type (`PyValueError`).
  internal static let PyUnicodeError = TypeLayout.PyValueError
  /// `PyUnicodeTranslateError` uses the same layout as it s base type (`PyUnicodeError`).
  internal static let PyUnicodeTranslateError = TypeLayout.PyUnicodeError
  /// `PyUnicodeWarning` uses the same layout as it s base type (`PyWarning`).
  internal static let PyUnicodeWarning = TypeLayout.PyWarning
  /// `PyUserWarning` uses the same layout as it s base type (`PyWarning`).
  internal static let PyUserWarning = TypeLayout.PyWarning
  /// `PyValueError` uses the same layout as it s base type (`PyException`).
  internal static let PyValueError = TypeLayout.PyException
  /// `PyWarning` uses the same layout as it s base type (`PyException`).
  internal static let PyWarning = TypeLayout.PyException
  /// `PyZeroDivisionError` uses the same layout as it s base type (`PyArithmeticError`).
  internal static let PyZeroDivisionError = TypeLayout.PyArithmeticError
}
