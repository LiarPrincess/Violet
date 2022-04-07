=====================================
=== Configuration/Arguments.swift ===
=====================================

public struct Arguments {
  public var help = false
  public var version = false
  public var debug = false
  public var quiet = false
  public var inspectInteractively = false
  public var ignoreEnvironment = false
  public var isolated = false
  public var verbose = 0
  public var optimize = Py.OptimizationLevel.none
  public enum WarningOption: Equatable, CustomStringConvertible {
    public var description: String { get }
  }
  public var warnings = [WarningOption]()
  public enum BytesWarningOption: Equatable {}
  public var bytesWarning = BytesWarningOption.ignore
  public var command: String?
  public var module: String?
  public var script: Path?
  public var raw: [String] = []
  public init()
  public init(from arguments: [String]) throws
  public static func helpMessage(columns: Int? = nil) -> String
}

=======================================
=== Configuration/Environment.swift ===
=======================================

public struct Environment {
  public var violetHome: Path?
  public var violetPath = Configure.pythonPath
  public var optimize = Py.OptimizationLevel.none
  public var warnings = [Arguments.WarningOption]()
  public var debug = false
  public var inspectInteractively = false
  public var verbose = 0
  public init()
  public init(from environment: [String: String])
}

===========================================
=== Generated/ExceptionSubclasses.swift ===
===========================================

public struct PyKeyboardInterrupt: PyErrorMixin {
  public let ptr: RawPtr
  public init(ptr: RawPtr)
}

public struct PyGeneratorExit: PyErrorMixin {
  public let ptr: RawPtr
  public init(ptr: RawPtr)
}

public struct PyException: PyErrorMixin {
  public let ptr: RawPtr
  public init(ptr: RawPtr)
}

public struct PyStopAsyncIteration: PyErrorMixin {
  public let ptr: RawPtr
  public init(ptr: RawPtr)
}

public struct PyArithmeticError: PyErrorMixin {
  public let ptr: RawPtr
  public init(ptr: RawPtr)
}

public struct PyFloatingPointError: PyErrorMixin {
  public let ptr: RawPtr
  public init(ptr: RawPtr)
}

public struct PyOverflowError: PyErrorMixin {
  public let ptr: RawPtr
  public init(ptr: RawPtr)
}

public struct PyZeroDivisionError: PyErrorMixin {
  public let ptr: RawPtr
  public init(ptr: RawPtr)
}

public struct PyAssertionError: PyErrorMixin {
  public let ptr: RawPtr
  public init(ptr: RawPtr)
}

public struct PyAttributeError: PyErrorMixin {
  public let ptr: RawPtr
  public init(ptr: RawPtr)
}

public struct PyBufferError: PyErrorMixin {
  public let ptr: RawPtr
  public init(ptr: RawPtr)
}

public struct PyEOFError: PyErrorMixin {
  public let ptr: RawPtr
  public init(ptr: RawPtr)
}

public struct PyModuleNotFoundError: PyErrorMixin {
  public let ptr: RawPtr
  public init(ptr: RawPtr)
}

public struct PyLookupError: PyErrorMixin {
  public let ptr: RawPtr
  public init(ptr: RawPtr)
}

public struct PyIndexError: PyErrorMixin {
  public let ptr: RawPtr
  public init(ptr: RawPtr)
}

public struct PyMemoryError: PyErrorMixin {
  public let ptr: RawPtr
  public init(ptr: RawPtr)
}

public struct PyNameError: PyErrorMixin {
  public let ptr: RawPtr
  public init(ptr: RawPtr)
}

public struct PyUnboundLocalError: PyErrorMixin {
  public let ptr: RawPtr
  public init(ptr: RawPtr)
}

public struct PyOSError: PyErrorMixin {
  public let ptr: RawPtr
  public init(ptr: RawPtr)
}

public struct PyBlockingIOError: PyErrorMixin {
  public let ptr: RawPtr
  public init(ptr: RawPtr)
}

public struct PyChildProcessError: PyErrorMixin {
  public let ptr: RawPtr
  public init(ptr: RawPtr)
}

public struct PyConnectionError: PyErrorMixin {
  public let ptr: RawPtr
  public init(ptr: RawPtr)
}

public struct PyBrokenPipeError: PyErrorMixin {
  public let ptr: RawPtr
  public init(ptr: RawPtr)
}

public struct PyConnectionAbortedError: PyErrorMixin {
  public let ptr: RawPtr
  public init(ptr: RawPtr)
}

public struct PyConnectionRefusedError: PyErrorMixin {
  public let ptr: RawPtr
  public init(ptr: RawPtr)
}

public struct PyConnectionResetError: PyErrorMixin {
  public let ptr: RawPtr
  public init(ptr: RawPtr)
}

public struct PyFileExistsError: PyErrorMixin {
  public let ptr: RawPtr
  public init(ptr: RawPtr)
}

public struct PyFileNotFoundError: PyErrorMixin {
  public let ptr: RawPtr
  public init(ptr: RawPtr)
}

public struct PyInterruptedError: PyErrorMixin {
  public let ptr: RawPtr
  public init(ptr: RawPtr)
}

public struct PyIsADirectoryError: PyErrorMixin {
  public let ptr: RawPtr
  public init(ptr: RawPtr)
}

public struct PyNotADirectoryError: PyErrorMixin {
  public let ptr: RawPtr
  public init(ptr: RawPtr)
}

public struct PyPermissionError: PyErrorMixin {
  public let ptr: RawPtr
  public init(ptr: RawPtr)
}

public struct PyProcessLookupError: PyErrorMixin {
  public let ptr: RawPtr
  public init(ptr: RawPtr)
}

public struct PyTimeoutError: PyErrorMixin {
  public let ptr: RawPtr
  public init(ptr: RawPtr)
}

public struct PyReferenceError: PyErrorMixin {
  public let ptr: RawPtr
  public init(ptr: RawPtr)
}

public struct PyRuntimeError: PyErrorMixin {
  public let ptr: RawPtr
  public init(ptr: RawPtr)
}

public struct PyNotImplementedError: PyErrorMixin {
  public let ptr: RawPtr
  public init(ptr: RawPtr)
}

public struct PyRecursionError: PyErrorMixin {
  public let ptr: RawPtr
  public init(ptr: RawPtr)
}

public struct PyIndentationError: PyErrorMixin {
  public let ptr: RawPtr
  public init(ptr: RawPtr)
}

public struct PyTabError: PyErrorMixin {
  public let ptr: RawPtr
  public init(ptr: RawPtr)
}

public struct PySystemError: PyErrorMixin {
  public let ptr: RawPtr
  public init(ptr: RawPtr)
}

public struct PyTypeError: PyErrorMixin {
  public let ptr: RawPtr
  public init(ptr: RawPtr)
}

public struct PyValueError: PyErrorMixin {
  public let ptr: RawPtr
  public init(ptr: RawPtr)
}

public struct PyUnicodeError: PyErrorMixin {
  public let ptr: RawPtr
  public init(ptr: RawPtr)
}

public struct PyUnicodeDecodeError: PyErrorMixin {
  public let ptr: RawPtr
  public init(ptr: RawPtr)
}

public struct PyUnicodeEncodeError: PyErrorMixin {
  public let ptr: RawPtr
  public init(ptr: RawPtr)
}

public struct PyUnicodeTranslateError: PyErrorMixin {
  public let ptr: RawPtr
  public init(ptr: RawPtr)
}

public struct PyWarning: PyErrorMixin {
  public let ptr: RawPtr
  public init(ptr: RawPtr)
}

public struct PyDeprecationWarning: PyErrorMixin {
  public let ptr: RawPtr
  public init(ptr: RawPtr)
}

public struct PyPendingDeprecationWarning: PyErrorMixin {
  public let ptr: RawPtr
  public init(ptr: RawPtr)
}

public struct PyRuntimeWarning: PyErrorMixin {
  public let ptr: RawPtr
  public init(ptr: RawPtr)
}

public struct PySyntaxWarning: PyErrorMixin {
  public let ptr: RawPtr
  public init(ptr: RawPtr)
}

public struct PyUserWarning: PyErrorMixin {
  public let ptr: RawPtr
  public init(ptr: RawPtr)
}

public struct PyFutureWarning: PyErrorMixin {
  public let ptr: RawPtr
  public init(ptr: RawPtr)
}

public struct PyImportWarning: PyErrorMixin {
  public let ptr: RawPtr
  public init(ptr: RawPtr)
}

public struct PyUnicodeWarning: PyErrorMixin {
  public let ptr: RawPtr
  public init(ptr: RawPtr)
}

public struct PyBytesWarning: PyErrorMixin {
  public let ptr: RawPtr
  public init(ptr: RawPtr)
}

public struct PyResourceWarning: PyErrorMixin {
  public let ptr: RawPtr
  public init(ptr: RawPtr)
}

========================================
=== Generated/FunctionWrappers.swift ===
========================================

public struct FunctionWrapper: CustomStringConvertible {
  public var name: String { get }
  public func call(_ py: Py, args: [PyObject], kwargs: PyDict?) -> PyResult
  public var description: String { get }
  public typealias Void_to_Result_Fn = (Py) -> PyResult
  public init(name: String, fn: @escaping Void_to_Result_Fn)
  public typealias Object_to_Result_Fn = (Py, PyObject) -> PyResult
  public init(name: String, fn: @escaping Object_to_Result_Fn)
  public typealias ObjectOpt_to_Result_Fn = (Py, PyObject?) -> PyResult
  public init(name: String, fn: @escaping ObjectOpt_to_Result_Fn)
  public typealias Type_to_Result_Fn = (Py, PyType) -> PyResult
  public init(name: String, fn: @escaping Type_to_Result_Fn)
  public typealias Object_Object_to_Result_Fn = (Py, PyObject, PyObject) -> PyResult
  public init(name: String, fn: @escaping Object_Object_to_Result_Fn)
  public typealias Object_ObjectOpt_to_Result_Fn = (Py, PyObject, PyObject?) -> PyResult
  public init(name: String, fn: @escaping Object_ObjectOpt_to_Result_Fn)
  public typealias ObjectOpt_ObjectOpt_to_Result_Fn = (Py, PyObject?, PyObject?) -> PyResult
  public init(name: String, fn: @escaping ObjectOpt_ObjectOpt_to_Result_Fn)
  public typealias Type_Object_to_Result_Fn = (Py, PyType, PyObject) -> PyResult
  public init(name: String, fn: @escaping Type_Object_to_Result_Fn)
  public typealias Type_ObjectOpt_to_Result_Fn = (Py, PyType, PyObject?) -> PyResult
  public init(name: String, fn: @escaping Type_ObjectOpt_to_Result_Fn)
  public typealias Object_Object_Object_to_Result_Fn = (Py, PyObject, PyObject, PyObject) -> PyResult
  public init(name: String, fn: @escaping Object_Object_Object_to_Result_Fn)
  public typealias Object_Object_ObjectOpt_to_Result_Fn = (Py, PyObject, PyObject, PyObject?) -> PyResult
  public init(name: String, fn: @escaping Object_Object_ObjectOpt_to_Result_Fn)
  public typealias Object_ObjectOpt_ObjectOpt_to_Result_Fn = (Py, PyObject, PyObject?, PyObject?) -> PyResult
  public init(name: String, fn: @escaping Object_ObjectOpt_ObjectOpt_to_Result_Fn)
  public typealias ObjectOpt_ObjectOpt_ObjectOpt_to_Result_Fn = (Py, PyObject?, PyObject?, PyObject?) -> PyResult
  public init(name: String, fn: @escaping ObjectOpt_ObjectOpt_ObjectOpt_to_Result_Fn)
  public typealias Type_Object_Object_to_Result_Fn = (Py, PyType, PyObject, PyObject) -> PyResult
  public init(name: String, fn: @escaping Type_Object_Object_to_Result_Fn)
  public typealias Type_Object_ObjectOpt_to_Result_Fn = (Py, PyType, PyObject, PyObject?) -> PyResult
  public init(name: String, fn: @escaping Type_Object_ObjectOpt_to_Result_Fn)
  public typealias Type_ObjectOpt_ObjectOpt_to_Result_Fn = (Py, PyType, PyObject?, PyObject?) -> PyResult
  public init(name: String, fn: @escaping Type_ObjectOpt_ObjectOpt_to_Result_Fn)
  public typealias Object_Object_Object_Object_to_Result_Fn = (Py, PyObject, PyObject, PyObject, PyObject) -> PyResult
  public init(name: String, fn: @escaping Object_Object_Object_Object_to_Result_Fn)
  public typealias Object_Object_Object_ObjectOpt_to_Result_Fn = (Py, PyObject, PyObject, PyObject, PyObject?) -> PyResult
  public init(name: String, fn: @escaping Object_Object_Object_ObjectOpt_to_Result_Fn)
  public typealias Object_Object_ObjectOpt_ObjectOpt_to_Result_Fn = (Py, PyObject, PyObject, PyObject?, PyObject?) -> PyResult
  public init(name: String, fn: @escaping Object_Object_ObjectOpt_ObjectOpt_to_Result_Fn)
  public typealias Object_ObjectOpt_ObjectOpt_ObjectOpt_to_Result_Fn = (Py, PyObject, PyObject?, PyObject?, PyObject?) -> PyResult
  public init(name: String, fn: @escaping Object_ObjectOpt_ObjectOpt_ObjectOpt_to_Result_Fn)
  public typealias ObjectOpt_ObjectOpt_ObjectOpt_ObjectOpt_to_Result_Fn = (Py, PyObject?, PyObject?, PyObject?, PyObject?) -> PyResult
  public init(name: String, fn: @escaping ObjectOpt_ObjectOpt_ObjectOpt_ObjectOpt_to_Result_Fn)
  public typealias Type_Object_Object_Object_to_Result_Fn = (Py, PyType, PyObject, PyObject, PyObject) -> PyResult
  public init(name: String, fn: @escaping Type_Object_Object_Object_to_Result_Fn)
  public typealias Type_Object_Object_ObjectOpt_to_Result_Fn = (Py, PyType, PyObject, PyObject, PyObject?) -> PyResult
  public init(name: String, fn: @escaping Type_Object_Object_ObjectOpt_to_Result_Fn)
  public typealias Type_Object_ObjectOpt_ObjectOpt_to_Result_Fn = (Py, PyType, PyObject, PyObject?, PyObject?) -> PyResult
  public init(name: String, fn: @escaping Type_Object_ObjectOpt_ObjectOpt_to_Result_Fn)
  public typealias Type_ObjectOpt_ObjectOpt_ObjectOpt_to_Result_Fn = (Py, PyType, PyObject?, PyObject?, PyObject?) -> PyResult
  public init(name: String, fn: @escaping Type_ObjectOpt_ObjectOpt_ObjectOpt_to_Result_Fn)
}

=================================
=== Generated/IdStrings.swift ===
=================================

public struct IdString: CustomStringConvertible {
  public static let __abs__ = IdString(index: 0)
  public static let __add__ = IdString(index: 1)
  public static let __all__ = IdString(index: 2)
  public static let __and__ = IdString(index: 3)
  public static let __annotations__ = IdString(index: 4)
  public static let __bool__ = IdString(index: 5)
  public static let __build_class__ = IdString(index: 6)
  public static let __builtins__ = IdString(index: 7)
  public static let __call__ = IdString(index: 8)
  public static let __class__ = IdString(index: 9)
  public static let __class_getitem__ = IdString(index: 10)
  public static let __classcell__ = IdString(index: 11)
  public static let __complex__ = IdString(index: 12)
  public static let __contains__ = IdString(index: 13)
  public static let __del__ = IdString(index: 14)
  public static let __delattr__ = IdString(index: 15)
  public static let __delitem__ = IdString(index: 16)
  public static let __dict__ = IdString(index: 17)
  public static let __dir__ = IdString(index: 18)
  public static let __divmod__ = IdString(index: 19)
  public static let __doc__ = IdString(index: 20)
  public static let __enter__ = IdString(index: 21)
  public static let __eq__ = IdString(index: 22)
  public static let __exit__ = IdString(index: 23)
  public static let __file__ = IdString(index: 24)
  public static let __float__ = IdString(index: 25)
  public static let __floordiv__ = IdString(index: 26)
  public static let __ge__ = IdString(index: 27)
  public static let __get__ = IdString(index: 28)
  public static let __getattr__ = IdString(index: 29)
  public static let __getattribute__ = IdString(index: 30)
  public static let __getitem__ = IdString(index: 31)
  public static let __gt__ = IdString(index: 32)
  public static let __hash__ = IdString(index: 33)
  public static let __iadd__ = IdString(index: 34)
  public static let __iand__ = IdString(index: 35)
  public static let __idivmod__ = IdString(index: 36)
  public static let __ifloordiv__ = IdString(index: 37)
  public static let __ilshift__ = IdString(index: 38)
  public static let __imatmul__ = IdString(index: 39)
  public static let __imod__ = IdString(index: 40)
  public static let __import__ = IdString(index: 41)
  public static let __imul__ = IdString(index: 42)
  public static let __index__ = IdString(index: 43)
  public static let __init__ = IdString(index: 44)
  public static let __init_subclass__ = IdString(index: 45)
  public static let __instancecheck__ = IdString(index: 46)
  public static let __int__ = IdString(index: 47)
  public static let __invert__ = IdString(index: 48)
  public static let __ior__ = IdString(index: 49)
  public static let __ipow__ = IdString(index: 50)
  public static let __irshift__ = IdString(index: 51)
  public static let __isabstractmethod__ = IdString(index: 52)
  public static let __isub__ = IdString(index: 53)
  public static let __iter__ = IdString(index: 54)
  public static let __itruediv__ = IdString(index: 55)
  public static let __ixor__ = IdString(index: 56)
  public static let __le__ = IdString(index: 57)
  public static let __len__ = IdString(index: 58)
  public static let __loader__ = IdString(index: 59)
  public static let __lshift__ = IdString(index: 60)
  public static let __lt__ = IdString(index: 61)
  public static let __matmul__ = IdString(index: 62)
  public static let __missing__ = IdString(index: 63)
  public static let __mod__ = IdString(index: 64)
  public static let __module__ = IdString(index: 65)
  public static let __mul__ = IdString(index: 66)
  public static let __name__ = IdString(index: 67)
  public static let __ne__ = IdString(index: 68)
  public static let __neg__ = IdString(index: 69)
  public static let __new__ = IdString(index: 70)
  public static let __next__ = IdString(index: 71)
  public static let __or__ = IdString(index: 72)
  public static let __package__ = IdString(index: 73)
  public static let __path__ = IdString(index: 74)
  public static let __pos__ = IdString(index: 75)
  public static let __pow__ = IdString(index: 76)
  public static let __prepare__ = IdString(index: 77)
  public static let __qualname__ = IdString(index: 78)
  public static let __radd__ = IdString(index: 79)
  public static let __rand__ = IdString(index: 80)
  public static let __rdivmod__ = IdString(index: 81)
  public static let __repr__ = IdString(index: 82)
  public static let __reversed__ = IdString(index: 83)
  public static let __rfloordiv__ = IdString(index: 84)
  public static let __rlshift__ = IdString(index: 85)
  public static let __rmatmul__ = IdString(index: 86)
  public static let __rmod__ = IdString(index: 87)
  public static let __rmul__ = IdString(index: 88)
  public static let __ror__ = IdString(index: 89)
  public static let __round__ = IdString(index: 90)
  public static let __rpow__ = IdString(index: 91)
  public static let __rrshift__ = IdString(index: 92)
  public static let __rshift__ = IdString(index: 93)
  public static let __rsub__ = IdString(index: 94)
  public static let __rtruediv__ = IdString(index: 95)
  public static let __rxor__ = IdString(index: 96)
  public static let __set__ = IdString(index: 97)
  public static let __set_name__ = IdString(index: 98)
  public static let __setattr__ = IdString(index: 99)
  public static let __setitem__ = IdString(index: 100)
  public static let __spec__ = IdString(index: 101)
  public static let __str__ = IdString(index: 102)
  public static let __sub__ = IdString(index: 103)
  public static let __subclasscheck__ = IdString(index: 104)
  public static let __truediv__ = IdString(index: 105)
  public static let __trunc__ = IdString(index: 106)
  public static let __warningregistry__ = IdString(index: 107)
  public static let __xor__ = IdString(index: 108)
  public static let _find_and_load = IdString(index: 109)
  public static let _handle_fromlist = IdString(index: 110)
  public static let builtins = IdString(index: 111)
  public static let encoding = IdString(index: 112)
  public static let keys = IdString(index: 113)
  public static let metaclass = IdString(index: 114)
  public static let mro = IdString(index: 115)
  public static let name = IdString(index: 116)
  public static let object = IdString(index: 117)
  public static let origin = IdString(index: 118)
  public var description: String { get }
}

===============================================
=== Generated/Py+ErrorTypeDefinitions.swift ===
===============================================

extension Py {
  public final class ErrorTypes {
    public let baseException: PyType
    public let systemExit: PyType
    public let keyboardInterrupt: PyType
    public let generatorExit: PyType
    public let exception: PyType
    public let stopIteration: PyType
    public let stopAsyncIteration: PyType
    public let arithmeticError: PyType
    public let floatingPointError: PyType
    public let overflowError: PyType
    public let zeroDivisionError: PyType
    public let assertionError: PyType
    public let attributeError: PyType
    public let bufferError: PyType
    public let eofError: PyType
    public let importError: PyType
    public let moduleNotFoundError: PyType
    public let lookupError: PyType
    public let indexError: PyType
    public let keyError: PyType
    public let memoryError: PyType
    public let nameError: PyType
    public let unboundLocalError: PyType
    public let osError: PyType
    public let blockingIOError: PyType
    public let childProcessError: PyType
    public let connectionError: PyType
    public let brokenPipeError: PyType
    public let connectionAbortedError: PyType
    public let connectionRefusedError: PyType
    public let connectionResetError: PyType
    public let fileExistsError: PyType
    public let fileNotFoundError: PyType
    public let interruptedError: PyType
    public let isADirectoryError: PyType
    public let notADirectoryError: PyType
    public let permissionError: PyType
    public let processLookupError: PyType
    public let timeoutError: PyType
    public let referenceError: PyType
    public let runtimeError: PyType
    public let notImplementedError: PyType
    public let recursionError: PyType
    public let syntaxError: PyType
    public let indentationError: PyType
    public let tabError: PyType
    public let systemError: PyType
    public let typeError: PyType
    public let valueError: PyType
    public let unicodeError: PyType
    public let unicodeDecodeError: PyType
    public let unicodeEncodeError: PyType
    public let unicodeTranslateError: PyType
    public let warning: PyType
    public let deprecationWarning: PyType
    public let pendingDeprecationWarning: PyType
    public let runtimeWarning: PyType
    public let syntaxWarning: PyType
    public let userWarning: PyType
    public let futureWarning: PyType
    public let importWarning: PyType
    public let unicodeWarning: PyType
    public let bytesWarning: PyType
    public let resourceWarning: PyType
  }
}

==========================================
=== Generated/Py+TypeDefinitions.swift ===
==========================================

extension Py {
  public final class Types {
    public let bool: PyType
    public let builtinFunction: PyType
    public let builtinMethod: PyType
    public let bytearray: PyType
    public let bytearray_iterator: PyType
    public let bytes: PyType
    public let bytes_iterator: PyType
    public let callable_iterator: PyType
    public let cell: PyType
    public let classmethod: PyType
    public let code: PyType
    public let complex: PyType
    public let dict: PyType
    public let dict_itemiterator: PyType
    public let dict_items: PyType
    public let dict_keyiterator: PyType
    public let dict_keys: PyType
    public let dict_valueiterator: PyType
    public let dict_values: PyType
    public let ellipsis: PyType
    public let enumerate: PyType
    public let filter: PyType
    public let float: PyType
    public let frame: PyType
    public let frozenset: PyType
    public let function: PyType
    public let int: PyType
    public let iterator: PyType
    public let list: PyType
    public let list_iterator: PyType
    public let list_reverseiterator: PyType
    public let map: PyType
    public let method: PyType
    public let module: PyType
    public let simpleNamespace: PyType
    public let none: PyType
    public let notImplemented: PyType
    public let object: PyType
    public let property: PyType
    public let range: PyType
    public let range_iterator: PyType
    public let reversed: PyType
    public let set: PyType
    public let set_iterator: PyType
    public let slice: PyType
    public let staticmethod: PyType
    public let str: PyType
    public let str_iterator: PyType
    public let `super`: PyType
    public let textFile: PyType
    public let traceback: PyType
    public let tuple: PyType
    public let tuple_iterator: PyType
    public let type: PyType
    public let zip: PyType
  }
}

==============================
=== Generated/PyCast.swift ===
==============================

public struct PyCast {
  public func isBool(_ object: PyObject) -> Bool
  public func asBool(_ object: PyObject) -> PyBool?
  public func isBuiltinFunction(_ object: PyObject) -> Bool
  public func asBuiltinFunction(_ object: PyObject) -> PyBuiltinFunction?
  public func isBuiltinMethod(_ object: PyObject) -> Bool
  public func asBuiltinMethod(_ object: PyObject) -> PyBuiltinMethod?
  public func isByteArray(_ object: PyObject) -> Bool
  public func isExactlyByteArray(_ object: PyObject) -> Bool
  public func asByteArray(_ object: PyObject) -> PyByteArray?
  public func asExactlyByteArray(_ object: PyObject) -> PyByteArray?
  public func isByteArrayIterator(_ object: PyObject) -> Bool
  public func asByteArrayIterator(_ object: PyObject) -> PyByteArrayIterator?
  public func isBytes(_ object: PyObject) -> Bool
  public func isExactlyBytes(_ object: PyObject) -> Bool
  public func asBytes(_ object: PyObject) -> PyBytes?
  public func asExactlyBytes(_ object: PyObject) -> PyBytes?
  public func isBytesIterator(_ object: PyObject) -> Bool
  public func asBytesIterator(_ object: PyObject) -> PyBytesIterator?
  public func isCallableIterator(_ object: PyObject) -> Bool
  public func asCallableIterator(_ object: PyObject) -> PyCallableIterator?
  public func isCell(_ object: PyObject) -> Bool
  public func asCell(_ object: PyObject) -> PyCell?
  public func isClassMethod(_ object: PyObject) -> Bool
  public func isExactlyClassMethod(_ object: PyObject) -> Bool
  public func asClassMethod(_ object: PyObject) -> PyClassMethod?
  public func asExactlyClassMethod(_ object: PyObject) -> PyClassMethod?
  public func isCode(_ object: PyObject) -> Bool
  public func asCode(_ object: PyObject) -> PyCode?
  public func isComplex(_ object: PyObject) -> Bool
  public func isExactlyComplex(_ object: PyObject) -> Bool
  public func asComplex(_ object: PyObject) -> PyComplex?
  public func asExactlyComplex(_ object: PyObject) -> PyComplex?
  public func isDict(_ object: PyObject) -> Bool
  public func isExactlyDict(_ object: PyObject) -> Bool
  public func asDict(_ object: PyObject) -> PyDict?
  public func asExactlyDict(_ object: PyObject) -> PyDict?
  public func isDictItemIterator(_ object: PyObject) -> Bool
  public func asDictItemIterator(_ object: PyObject) -> PyDictItemIterator?
  public func isDictItems(_ object: PyObject) -> Bool
  public func asDictItems(_ object: PyObject) -> PyDictItems?
  public func isDictKeyIterator(_ object: PyObject) -> Bool
  public func asDictKeyIterator(_ object: PyObject) -> PyDictKeyIterator?
  public func isDictKeys(_ object: PyObject) -> Bool
  public func asDictKeys(_ object: PyObject) -> PyDictKeys?
  public func isDictValueIterator(_ object: PyObject) -> Bool
  public func asDictValueIterator(_ object: PyObject) -> PyDictValueIterator?
  public func isDictValues(_ object: PyObject) -> Bool
  public func asDictValues(_ object: PyObject) -> PyDictValues?
  public func isEllipsis(_ object: PyObject) -> Bool
  public func asEllipsis(_ object: PyObject) -> PyEllipsis?
  public func isEnumerate(_ object: PyObject) -> Bool
  public func isExactlyEnumerate(_ object: PyObject) -> Bool
  public func asEnumerate(_ object: PyObject) -> PyEnumerate?
  public func asExactlyEnumerate(_ object: PyObject) -> PyEnumerate?
  public func isFilter(_ object: PyObject) -> Bool
  public func isExactlyFilter(_ object: PyObject) -> Bool
  public func asFilter(_ object: PyObject) -> PyFilter?
  public func asExactlyFilter(_ object: PyObject) -> PyFilter?
  public func isFloat(_ object: PyObject) -> Bool
  public func isExactlyFloat(_ object: PyObject) -> Bool
  public func asFloat(_ object: PyObject) -> PyFloat?
  public func asExactlyFloat(_ object: PyObject) -> PyFloat?
  public func isFrame(_ object: PyObject) -> Bool
  public func asFrame(_ object: PyObject) -> PyFrame?
  public func isFrozenSet(_ object: PyObject) -> Bool
  public func isExactlyFrozenSet(_ object: PyObject) -> Bool
  public func asFrozenSet(_ object: PyObject) -> PyFrozenSet?
  public func asExactlyFrozenSet(_ object: PyObject) -> PyFrozenSet?
  public func isFunction(_ object: PyObject) -> Bool
  public func asFunction(_ object: PyObject) -> PyFunction?
  public func isInt(_ object: PyObject) -> Bool
  public func isExactlyInt(_ object: PyObject) -> Bool
  public func asInt(_ object: PyObject) -> PyInt?
  public func asExactlyInt(_ object: PyObject) -> PyInt?
  public func isIterator(_ object: PyObject) -> Bool
  public func asIterator(_ object: PyObject) -> PyIterator?
  public func isList(_ object: PyObject) -> Bool
  public func isExactlyList(_ object: PyObject) -> Bool
  public func asList(_ object: PyObject) -> PyList?
  public func asExactlyList(_ object: PyObject) -> PyList?
  public func isListIterator(_ object: PyObject) -> Bool
  public func asListIterator(_ object: PyObject) -> PyListIterator?
  public func isListReverseIterator(_ object: PyObject) -> Bool
  public func asListReverseIterator(_ object: PyObject) -> PyListReverseIterator?
  public func isMap(_ object: PyObject) -> Bool
  public func isExactlyMap(_ object: PyObject) -> Bool
  public func asMap(_ object: PyObject) -> PyMap?
  public func asExactlyMap(_ object: PyObject) -> PyMap?
  public func isMethod(_ object: PyObject) -> Bool
  public func asMethod(_ object: PyObject) -> PyMethod?
  public func isModule(_ object: PyObject) -> Bool
  public func isExactlyModule(_ object: PyObject) -> Bool
  public func asModule(_ object: PyObject) -> PyModule?
  public func asExactlyModule(_ object: PyObject) -> PyModule?
  public func isNamespace(_ object: PyObject) -> Bool
  public func isExactlyNamespace(_ object: PyObject) -> Bool
  public func asNamespace(_ object: PyObject) -> PyNamespace?
  public func asExactlyNamespace(_ object: PyObject) -> PyNamespace?
  public func isNone(_ object: PyObject) -> Bool
  public func asNone(_ object: PyObject) -> PyNone?
  public func isNilOrNone(_ object: PyObject?) -> Bool
  public func isNotImplemented(_ object: PyObject) -> Bool
  public func asNotImplemented(_ object: PyObject) -> PyNotImplemented?
  public func isProperty(_ object: PyObject) -> Bool
  public func isExactlyProperty(_ object: PyObject) -> Bool
  public func asProperty(_ object: PyObject) -> PyProperty?
  public func asExactlyProperty(_ object: PyObject) -> PyProperty?
  public func isRange(_ object: PyObject) -> Bool
  public func asRange(_ object: PyObject) -> PyRange?
  public func isRangeIterator(_ object: PyObject) -> Bool
  public func asRangeIterator(_ object: PyObject) -> PyRangeIterator?
  public func isReversed(_ object: PyObject) -> Bool
  public func isExactlyReversed(_ object: PyObject) -> Bool
  public func asReversed(_ object: PyObject) -> PyReversed?
  public func asExactlyReversed(_ object: PyObject) -> PyReversed?
  public func isSet(_ object: PyObject) -> Bool
  public func isExactlySet(_ object: PyObject) -> Bool
  public func asSet(_ object: PyObject) -> PySet?
  public func asExactlySet(_ object: PyObject) -> PySet?
  public func isSetIterator(_ object: PyObject) -> Bool
  public func asSetIterator(_ object: PyObject) -> PySetIterator?
  public func isSlice(_ object: PyObject) -> Bool
  public func asSlice(_ object: PyObject) -> PySlice?
  public func isStaticMethod(_ object: PyObject) -> Bool
  public func isExactlyStaticMethod(_ object: PyObject) -> Bool
  public func asStaticMethod(_ object: PyObject) -> PyStaticMethod?
  public func asExactlyStaticMethod(_ object: PyObject) -> PyStaticMethod?
  public func isString(_ object: PyObject) -> Bool
  public func isExactlyString(_ object: PyObject) -> Bool
  public func asString(_ object: PyObject) -> PyString?
  public func asExactlyString(_ object: PyObject) -> PyString?
  public func isStringIterator(_ object: PyObject) -> Bool
  public func asStringIterator(_ object: PyObject) -> PyStringIterator?
  public func isSuper(_ object: PyObject) -> Bool
  public func isExactlySuper(_ object: PyObject) -> Bool
  public func asSuper(_ object: PyObject) -> PySuper?
  public func asExactlySuper(_ object: PyObject) -> PySuper?
  public func isTextFile(_ object: PyObject) -> Bool
  public func asTextFile(_ object: PyObject) -> PyTextFile?
  public func isTraceback(_ object: PyObject) -> Bool
  public func asTraceback(_ object: PyObject) -> PyTraceback?
  public func isTuple(_ object: PyObject) -> Bool
  public func isExactlyTuple(_ object: PyObject) -> Bool
  public func asTuple(_ object: PyObject) -> PyTuple?
  public func asExactlyTuple(_ object: PyObject) -> PyTuple?
  public func isTupleIterator(_ object: PyObject) -> Bool
  public func asTupleIterator(_ object: PyObject) -> PyTupleIterator?
  public func isType(_ object: PyObject) -> Bool
  public func isExactlyType(_ object: PyObject) -> Bool
  public func asType(_ object: PyObject) -> PyType?
  public func asExactlyType(_ object: PyObject) -> PyType?
  public func isZip(_ object: PyObject) -> Bool
  public func isExactlyZip(_ object: PyObject) -> Bool
  public func asZip(_ object: PyObject) -> PyZip?
  public func asExactlyZip(_ object: PyObject) -> PyZip?
  public func isArithmeticError(_ object: PyObject) -> Bool
  public func isExactlyArithmeticError(_ object: PyObject) -> Bool
  public func asArithmeticError(_ object: PyObject) -> PyArithmeticError?
  public func asExactlyArithmeticError(_ object: PyObject) -> PyArithmeticError?
  public func isAssertionError(_ object: PyObject) -> Bool
  public func isExactlyAssertionError(_ object: PyObject) -> Bool
  public func asAssertionError(_ object: PyObject) -> PyAssertionError?
  public func asExactlyAssertionError(_ object: PyObject) -> PyAssertionError?
  public func isAttributeError(_ object: PyObject) -> Bool
  public func isExactlyAttributeError(_ object: PyObject) -> Bool
  public func asAttributeError(_ object: PyObject) -> PyAttributeError?
  public func asExactlyAttributeError(_ object: PyObject) -> PyAttributeError?
  public func isBaseException(_ object: PyObject) -> Bool
  public func isExactlyBaseException(_ object: PyObject) -> Bool
  public func asBaseException(_ object: PyObject) -> PyBaseException?
  public func asExactlyBaseException(_ object: PyObject) -> PyBaseException?
  public func isBlockingIOError(_ object: PyObject) -> Bool
  public func isExactlyBlockingIOError(_ object: PyObject) -> Bool
  public func asBlockingIOError(_ object: PyObject) -> PyBlockingIOError?
  public func asExactlyBlockingIOError(_ object: PyObject) -> PyBlockingIOError?
  public func isBrokenPipeError(_ object: PyObject) -> Bool
  public func isExactlyBrokenPipeError(_ object: PyObject) -> Bool
  public func asBrokenPipeError(_ object: PyObject) -> PyBrokenPipeError?
  public func asExactlyBrokenPipeError(_ object: PyObject) -> PyBrokenPipeError?
  public func isBufferError(_ object: PyObject) -> Bool
  public func isExactlyBufferError(_ object: PyObject) -> Bool
  public func asBufferError(_ object: PyObject) -> PyBufferError?
  public func asExactlyBufferError(_ object: PyObject) -> PyBufferError?
  public func isBytesWarning(_ object: PyObject) -> Bool
  public func isExactlyBytesWarning(_ object: PyObject) -> Bool
  public func asBytesWarning(_ object: PyObject) -> PyBytesWarning?
  public func asExactlyBytesWarning(_ object: PyObject) -> PyBytesWarning?
  public func isChildProcessError(_ object: PyObject) -> Bool
  public func isExactlyChildProcessError(_ object: PyObject) -> Bool
  public func asChildProcessError(_ object: PyObject) -> PyChildProcessError?
  public func asExactlyChildProcessError(_ object: PyObject) -> PyChildProcessError?
  public func isConnectionAbortedError(_ object: PyObject) -> Bool
  public func isExactlyConnectionAbortedError(_ object: PyObject) -> Bool
  public func asConnectionAbortedError(_ object: PyObject) -> PyConnectionAbortedError?
  public func asExactlyConnectionAbortedError(_ object: PyObject) -> PyConnectionAbortedError?
  public func isConnectionError(_ object: PyObject) -> Bool
  public func isExactlyConnectionError(_ object: PyObject) -> Bool
  public func asConnectionError(_ object: PyObject) -> PyConnectionError?
  public func asExactlyConnectionError(_ object: PyObject) -> PyConnectionError?
  public func isConnectionRefusedError(_ object: PyObject) -> Bool
  public func isExactlyConnectionRefusedError(_ object: PyObject) -> Bool
  public func asConnectionRefusedError(_ object: PyObject) -> PyConnectionRefusedError?
  public func asExactlyConnectionRefusedError(_ object: PyObject) -> PyConnectionRefusedError?
  public func isConnectionResetError(_ object: PyObject) -> Bool
  public func isExactlyConnectionResetError(_ object: PyObject) -> Bool
  public func asConnectionResetError(_ object: PyObject) -> PyConnectionResetError?
  public func asExactlyConnectionResetError(_ object: PyObject) -> PyConnectionResetError?
  public func isDeprecationWarning(_ object: PyObject) -> Bool
  public func isExactlyDeprecationWarning(_ object: PyObject) -> Bool
  public func asDeprecationWarning(_ object: PyObject) -> PyDeprecationWarning?
  public func asExactlyDeprecationWarning(_ object: PyObject) -> PyDeprecationWarning?
  public func isEOFError(_ object: PyObject) -> Bool
  public func isExactlyEOFError(_ object: PyObject) -> Bool
  public func asEOFError(_ object: PyObject) -> PyEOFError?
  public func asExactlyEOFError(_ object: PyObject) -> PyEOFError?
  public func isException(_ object: PyObject) -> Bool
  public func isExactlyException(_ object: PyObject) -> Bool
  public func asException(_ object: PyObject) -> PyException?
  public func asExactlyException(_ object: PyObject) -> PyException?
  public func isFileExistsError(_ object: PyObject) -> Bool
  public func isExactlyFileExistsError(_ object: PyObject) -> Bool
  public func asFileExistsError(_ object: PyObject) -> PyFileExistsError?
  public func asExactlyFileExistsError(_ object: PyObject) -> PyFileExistsError?
  public func isFileNotFoundError(_ object: PyObject) -> Bool
  public func isExactlyFileNotFoundError(_ object: PyObject) -> Bool
  public func asFileNotFoundError(_ object: PyObject) -> PyFileNotFoundError?
  public func asExactlyFileNotFoundError(_ object: PyObject) -> PyFileNotFoundError?
  public func isFloatingPointError(_ object: PyObject) -> Bool
  public func isExactlyFloatingPointError(_ object: PyObject) -> Bool
  public func asFloatingPointError(_ object: PyObject) -> PyFloatingPointError?
  public func asExactlyFloatingPointError(_ object: PyObject) -> PyFloatingPointError?
  public func isFutureWarning(_ object: PyObject) -> Bool
  public func isExactlyFutureWarning(_ object: PyObject) -> Bool
  public func asFutureWarning(_ object: PyObject) -> PyFutureWarning?
  public func asExactlyFutureWarning(_ object: PyObject) -> PyFutureWarning?
  public func isGeneratorExit(_ object: PyObject) -> Bool
  public func isExactlyGeneratorExit(_ object: PyObject) -> Bool
  public func asGeneratorExit(_ object: PyObject) -> PyGeneratorExit?
  public func asExactlyGeneratorExit(_ object: PyObject) -> PyGeneratorExit?
  public func isImportError(_ object: PyObject) -> Bool
  public func isExactlyImportError(_ object: PyObject) -> Bool
  public func asImportError(_ object: PyObject) -> PyImportError?
  public func asExactlyImportError(_ object: PyObject) -> PyImportError?
  public func isImportWarning(_ object: PyObject) -> Bool
  public func isExactlyImportWarning(_ object: PyObject) -> Bool
  public func asImportWarning(_ object: PyObject) -> PyImportWarning?
  public func asExactlyImportWarning(_ object: PyObject) -> PyImportWarning?
  public func isIndentationError(_ object: PyObject) -> Bool
  public func isExactlyIndentationError(_ object: PyObject) -> Bool
  public func asIndentationError(_ object: PyObject) -> PyIndentationError?
  public func asExactlyIndentationError(_ object: PyObject) -> PyIndentationError?
  public func isIndexError(_ object: PyObject) -> Bool
  public func isExactlyIndexError(_ object: PyObject) -> Bool
  public func asIndexError(_ object: PyObject) -> PyIndexError?
  public func asExactlyIndexError(_ object: PyObject) -> PyIndexError?
  public func isInterruptedError(_ object: PyObject) -> Bool
  public func isExactlyInterruptedError(_ object: PyObject) -> Bool
  public func asInterruptedError(_ object: PyObject) -> PyInterruptedError?
  public func asExactlyInterruptedError(_ object: PyObject) -> PyInterruptedError?
  public func isIsADirectoryError(_ object: PyObject) -> Bool
  public func isExactlyIsADirectoryError(_ object: PyObject) -> Bool
  public func asIsADirectoryError(_ object: PyObject) -> PyIsADirectoryError?
  public func asExactlyIsADirectoryError(_ object: PyObject) -> PyIsADirectoryError?
  public func isKeyError(_ object: PyObject) -> Bool
  public func isExactlyKeyError(_ object: PyObject) -> Bool
  public func asKeyError(_ object: PyObject) -> PyKeyError?
  public func asExactlyKeyError(_ object: PyObject) -> PyKeyError?
  public func isKeyboardInterrupt(_ object: PyObject) -> Bool
  public func isExactlyKeyboardInterrupt(_ object: PyObject) -> Bool
  public func asKeyboardInterrupt(_ object: PyObject) -> PyKeyboardInterrupt?
  public func asExactlyKeyboardInterrupt(_ object: PyObject) -> PyKeyboardInterrupt?
  public func isLookupError(_ object: PyObject) -> Bool
  public func isExactlyLookupError(_ object: PyObject) -> Bool
  public func asLookupError(_ object: PyObject) -> PyLookupError?
  public func asExactlyLookupError(_ object: PyObject) -> PyLookupError?
  public func isMemoryError(_ object: PyObject) -> Bool
  public func isExactlyMemoryError(_ object: PyObject) -> Bool
  public func asMemoryError(_ object: PyObject) -> PyMemoryError?
  public func asExactlyMemoryError(_ object: PyObject) -> PyMemoryError?
  public func isModuleNotFoundError(_ object: PyObject) -> Bool
  public func isExactlyModuleNotFoundError(_ object: PyObject) -> Bool
  public func asModuleNotFoundError(_ object: PyObject) -> PyModuleNotFoundError?
  public func asExactlyModuleNotFoundError(_ object: PyObject) -> PyModuleNotFoundError?
  public func isNameError(_ object: PyObject) -> Bool
  public func isExactlyNameError(_ object: PyObject) -> Bool
  public func asNameError(_ object: PyObject) -> PyNameError?
  public func asExactlyNameError(_ object: PyObject) -> PyNameError?
  public func isNotADirectoryError(_ object: PyObject) -> Bool
  public func isExactlyNotADirectoryError(_ object: PyObject) -> Bool
  public func asNotADirectoryError(_ object: PyObject) -> PyNotADirectoryError?
  public func asExactlyNotADirectoryError(_ object: PyObject) -> PyNotADirectoryError?
  public func isNotImplementedError(_ object: PyObject) -> Bool
  public func isExactlyNotImplementedError(_ object: PyObject) -> Bool
  public func asNotImplementedError(_ object: PyObject) -> PyNotImplementedError?
  public func asExactlyNotImplementedError(_ object: PyObject) -> PyNotImplementedError?
  public func isOSError(_ object: PyObject) -> Bool
  public func isExactlyOSError(_ object: PyObject) -> Bool
  public func asOSError(_ object: PyObject) -> PyOSError?
  public func asExactlyOSError(_ object: PyObject) -> PyOSError?
  public func isOverflowError(_ object: PyObject) -> Bool
  public func isExactlyOverflowError(_ object: PyObject) -> Bool
  public func asOverflowError(_ object: PyObject) -> PyOverflowError?
  public func asExactlyOverflowError(_ object: PyObject) -> PyOverflowError?
  public func isPendingDeprecationWarning(_ object: PyObject) -> Bool
  public func isExactlyPendingDeprecationWarning(_ object: PyObject) -> Bool
  public func asPendingDeprecationWarning(_ object: PyObject) -> PyPendingDeprecationWarning?
  public func asExactlyPendingDeprecationWarning(_ object: PyObject) -> PyPendingDeprecationWarning?
  public func isPermissionError(_ object: PyObject) -> Bool
  public func isExactlyPermissionError(_ object: PyObject) -> Bool
  public func asPermissionError(_ object: PyObject) -> PyPermissionError?
  public func asExactlyPermissionError(_ object: PyObject) -> PyPermissionError?
  public func isProcessLookupError(_ object: PyObject) -> Bool
  public func isExactlyProcessLookupError(_ object: PyObject) -> Bool
  public func asProcessLookupError(_ object: PyObject) -> PyProcessLookupError?
  public func asExactlyProcessLookupError(_ object: PyObject) -> PyProcessLookupError?
  public func isRecursionError(_ object: PyObject) -> Bool
  public func isExactlyRecursionError(_ object: PyObject) -> Bool
  public func asRecursionError(_ object: PyObject) -> PyRecursionError?
  public func asExactlyRecursionError(_ object: PyObject) -> PyRecursionError?
  public func isReferenceError(_ object: PyObject) -> Bool
  public func isExactlyReferenceError(_ object: PyObject) -> Bool
  public func asReferenceError(_ object: PyObject) -> PyReferenceError?
  public func asExactlyReferenceError(_ object: PyObject) -> PyReferenceError?
  public func isResourceWarning(_ object: PyObject) -> Bool
  public func isExactlyResourceWarning(_ object: PyObject) -> Bool
  public func asResourceWarning(_ object: PyObject) -> PyResourceWarning?
  public func asExactlyResourceWarning(_ object: PyObject) -> PyResourceWarning?
  public func isRuntimeError(_ object: PyObject) -> Bool
  public func isExactlyRuntimeError(_ object: PyObject) -> Bool
  public func asRuntimeError(_ object: PyObject) -> PyRuntimeError?
  public func asExactlyRuntimeError(_ object: PyObject) -> PyRuntimeError?
  public func isRuntimeWarning(_ object: PyObject) -> Bool
  public func isExactlyRuntimeWarning(_ object: PyObject) -> Bool
  public func asRuntimeWarning(_ object: PyObject) -> PyRuntimeWarning?
  public func asExactlyRuntimeWarning(_ object: PyObject) -> PyRuntimeWarning?
  public func isStopAsyncIteration(_ object: PyObject) -> Bool
  public func isExactlyStopAsyncIteration(_ object: PyObject) -> Bool
  public func asStopAsyncIteration(_ object: PyObject) -> PyStopAsyncIteration?
  public func asExactlyStopAsyncIteration(_ object: PyObject) -> PyStopAsyncIteration?
  public func isStopIteration(_ object: PyObject) -> Bool
  public func isExactlyStopIteration(_ object: PyObject) -> Bool
  public func asStopIteration(_ object: PyObject) -> PyStopIteration?
  public func asExactlyStopIteration(_ object: PyObject) -> PyStopIteration?
  public func isSyntaxError(_ object: PyObject) -> Bool
  public func isExactlySyntaxError(_ object: PyObject) -> Bool
  public func asSyntaxError(_ object: PyObject) -> PySyntaxError?
  public func asExactlySyntaxError(_ object: PyObject) -> PySyntaxError?
  public func isSyntaxWarning(_ object: PyObject) -> Bool
  public func isExactlySyntaxWarning(_ object: PyObject) -> Bool
  public func asSyntaxWarning(_ object: PyObject) -> PySyntaxWarning?
  public func asExactlySyntaxWarning(_ object: PyObject) -> PySyntaxWarning?
  public func isSystemError(_ object: PyObject) -> Bool
  public func isExactlySystemError(_ object: PyObject) -> Bool
  public func asSystemError(_ object: PyObject) -> PySystemError?
  public func asExactlySystemError(_ object: PyObject) -> PySystemError?
  public func isSystemExit(_ object: PyObject) -> Bool
  public func isExactlySystemExit(_ object: PyObject) -> Bool
  public func asSystemExit(_ object: PyObject) -> PySystemExit?
  public func asExactlySystemExit(_ object: PyObject) -> PySystemExit?
  public func isTabError(_ object: PyObject) -> Bool
  public func isExactlyTabError(_ object: PyObject) -> Bool
  public func asTabError(_ object: PyObject) -> PyTabError?
  public func asExactlyTabError(_ object: PyObject) -> PyTabError?
  public func isTimeoutError(_ object: PyObject) -> Bool
  public func isExactlyTimeoutError(_ object: PyObject) -> Bool
  public func asTimeoutError(_ object: PyObject) -> PyTimeoutError?
  public func asExactlyTimeoutError(_ object: PyObject) -> PyTimeoutError?
  public func isTypeError(_ object: PyObject) -> Bool
  public func isExactlyTypeError(_ object: PyObject) -> Bool
  public func asTypeError(_ object: PyObject) -> PyTypeError?
  public func asExactlyTypeError(_ object: PyObject) -> PyTypeError?
  public func isUnboundLocalError(_ object: PyObject) -> Bool
  public func isExactlyUnboundLocalError(_ object: PyObject) -> Bool
  public func asUnboundLocalError(_ object: PyObject) -> PyUnboundLocalError?
  public func asExactlyUnboundLocalError(_ object: PyObject) -> PyUnboundLocalError?
  public func isUnicodeDecodeError(_ object: PyObject) -> Bool
  public func isExactlyUnicodeDecodeError(_ object: PyObject) -> Bool
  public func asUnicodeDecodeError(_ object: PyObject) -> PyUnicodeDecodeError?
  public func asExactlyUnicodeDecodeError(_ object: PyObject) -> PyUnicodeDecodeError?
  public func isUnicodeEncodeError(_ object: PyObject) -> Bool
  public func isExactlyUnicodeEncodeError(_ object: PyObject) -> Bool
  public func asUnicodeEncodeError(_ object: PyObject) -> PyUnicodeEncodeError?
  public func asExactlyUnicodeEncodeError(_ object: PyObject) -> PyUnicodeEncodeError?
  public func isUnicodeError(_ object: PyObject) -> Bool
  public func isExactlyUnicodeError(_ object: PyObject) -> Bool
  public func asUnicodeError(_ object: PyObject) -> PyUnicodeError?
  public func asExactlyUnicodeError(_ object: PyObject) -> PyUnicodeError?
  public func isUnicodeTranslateError(_ object: PyObject) -> Bool
  public func isExactlyUnicodeTranslateError(_ object: PyObject) -> Bool
  public func asUnicodeTranslateError(_ object: PyObject) -> PyUnicodeTranslateError?
  public func asExactlyUnicodeTranslateError(_ object: PyObject) -> PyUnicodeTranslateError?
  public func isUnicodeWarning(_ object: PyObject) -> Bool
  public func isExactlyUnicodeWarning(_ object: PyObject) -> Bool
  public func asUnicodeWarning(_ object: PyObject) -> PyUnicodeWarning?
  public func asExactlyUnicodeWarning(_ object: PyObject) -> PyUnicodeWarning?
  public func isUserWarning(_ object: PyObject) -> Bool
  public func isExactlyUserWarning(_ object: PyObject) -> Bool
  public func asUserWarning(_ object: PyObject) -> PyUserWarning?
  public func asExactlyUserWarning(_ object: PyObject) -> PyUserWarning?
  public func isValueError(_ object: PyObject) -> Bool
  public func isExactlyValueError(_ object: PyObject) -> Bool
  public func asValueError(_ object: PyObject) -> PyValueError?
  public func asExactlyValueError(_ object: PyObject) -> PyValueError?
  public func isWarning(_ object: PyObject) -> Bool
  public func isExactlyWarning(_ object: PyObject) -> Bool
  public func asWarning(_ object: PyObject) -> PyWarning?
  public func asExactlyWarning(_ object: PyObject) -> PyWarning?
  public func isZeroDivisionError(_ object: PyObject) -> Bool
  public func isExactlyZeroDivisionError(_ object: PyObject) -> Bool
  public func asZeroDivisionError(_ object: PyObject) -> PyZeroDivisionError?
  public func asExactlyZeroDivisionError(_ object: PyObject) -> PyZeroDivisionError?
}

====================================
=== Generated/PyStaticCall.swift ===
====================================

public enum PyStaticCall {
  public final class KnownNotOverriddenMethods {
    public typealias StringConversion = (Py, PyObject) -> PyResult
    public typealias Hash = (Py, PyObject) -> HashResult
    public typealias Dir = (Py, PyObject) -> PyResultGen<DirResult>
    public typealias Comparison = (Py, PyObject, PyObject) -> CompareResult
    public typealias AsBool = (Py, PyObject) -> PyResult
    public typealias AsInt = (Py, PyObject) -> PyResult
    public typealias AsFloat = (Py, PyObject) -> PyResult
    public typealias AsComplex = (Py, PyObject) -> PyResult
    public typealias AsIndex = (Py, PyObject) -> PyResult
    public typealias GetAttribute = (Py, PyObject, PyObject) -> PyResult
    public typealias SetAttribute = (Py, PyObject, PyObject, PyObject?) -> PyResult
    public typealias DelAttribute = (Py, PyObject, PyObject) -> PyResult
    public typealias GetItem = (Py, PyObject, PyObject) -> PyResult
    public typealias SetItem = (Py, PyObject, PyObject, PyObject) -> PyResult
    public typealias DelItem = (Py, PyObject, PyObject) -> PyResult
    public typealias Iter = (Py, PyObject) -> PyResult
    public typealias Next = (Py, PyObject) -> PyResult
    public typealias GetLength = (Py, PyObject) -> PyResult
    public typealias Contains = (Py, PyObject, PyObject) -> PyResult
    public typealias Reversed = (Py, PyObject) -> PyResult
    public typealias Keys = (Py, PyObject) -> PyResult
    public typealias Del = (Py, PyObject) -> PyResult
    public typealias Call = (Py, PyObject, [PyObject], PyDict?) -> PyResult
    public typealias InstanceCheck = (Py, PyObject, PyObject) -> PyResult
    public typealias SubclassCheck = (Py, PyObject, PyObject) -> PyResult
    public typealias IsAbstractMethod = (Py, PyObject) -> PyResult
    public typealias NumericUnary = (Py, PyObject) -> PyResult
    public typealias NumericRound = (Py, PyObject, PyObject?) -> PyResult
    public typealias NumericBinary = (Py, PyObject, PyObject) -> PyResult
    public typealias NumericPow = (Py, PyObject, PyObject, PyObject) -> PyResult
    public var __repr__: StringConversion?
    public var __str__: StringConversion?
    public var __hash__: Hash?
    public var __dir__: Dir?
    public var __eq__: Comparison?
    public var __ne__: Comparison?
    public var __lt__: Comparison?
    public var __le__: Comparison?
    public var __gt__: Comparison?
    public var __ge__: Comparison?
    public var __bool__: AsBool?
    public var __int__: AsInt?
    public var __float__: AsFloat?
    public var __complex__: AsComplex?
    public var __index__: AsIndex?
    public var __getattr__: GetAttribute?
    public var __getattribute__: GetAttribute?
    public var __setattr__: SetAttribute?
    public var __delattr__: DelAttribute?
    public var __getitem__: GetItem?
    public var __setitem__: SetItem?
    public var __delitem__: DelItem?
    public var __iter__: Iter?
    public var __next__: Next?
    public var __len__: GetLength?
    public var __contains__: Contains?
    public var __reversed__: Reversed?
    public var keys: Keys?
    public var __del__: Del?
    public var __call__: Call?
    public var __instancecheck__: InstanceCheck?
    public var __subclasscheck__: SubclassCheck?
    public var __isabstractmethod__: IsAbstractMethod?
    public var __pos__: NumericUnary?
    public var __neg__: NumericUnary?
    public var __invert__: NumericUnary?
    public var __abs__: NumericUnary?
    public var __trunc__: NumericUnary?
    public var __round__: NumericRound?
    public var __add__: NumericBinary?
    public var __and__: NumericBinary?
    public var __divmod__: NumericBinary?
    public var __floordiv__: NumericBinary?
    public var __lshift__: NumericBinary?
    public var __matmul__: NumericBinary?
    public var __mod__: NumericBinary?
    public var __mul__: NumericBinary?
    public var __or__: NumericBinary?
    public var __rshift__: NumericBinary?
    public var __sub__: NumericBinary?
    public var __truediv__: NumericBinary?
    public var __xor__: NumericBinary?
    public var __radd__: NumericBinary?
    public var __rand__: NumericBinary?
    public var __rdivmod__: NumericBinary?
    public var __rfloordiv__: NumericBinary?
    public var __rlshift__: NumericBinary?
    public var __rmatmul__: NumericBinary?
    public var __rmod__: NumericBinary?
    public var __rmul__: NumericBinary?
    public var __ror__: NumericBinary?
    public var __rrshift__: NumericBinary?
    public var __rsub__: NumericBinary?
    public var __rtruediv__: NumericBinary?
    public var __rxor__: NumericBinary?
    public var __iadd__: NumericBinary?
    public var __iand__: NumericBinary?
    public var __idivmod__: NumericBinary?
    public var __ifloordiv__: NumericBinary?
    public var __ilshift__: NumericBinary?
    public var __imatmul__: NumericBinary?
    public var __imod__: NumericBinary?
    public var __imul__: NumericBinary?
    public var __ior__: NumericBinary?
    public var __irshift__: NumericBinary?
    public var __isub__: NumericBinary?
    public var __itruediv__: NumericBinary?
    public var __ixor__: NumericBinary?
    public var __pow__: NumericPow?
    public var __rpow__: NumericPow?
    public var __ipow__: NumericPow?
    public init()
    public convenience init(_ py: Py, mroWithoutCurrentlyCreatedType mro: [PyType], dictForCurrentlyCreatedType dict: PyDict)
    public func copy() -> KnownNotOverriddenMethods
  }
}

=======================================
=== Generated/Types+Generated.swift ===
=======================================

extension PyMemory {
  public func newTypeAndObjectTypes(_ py: Py) -> (objectType: PyType, typeType: PyType)
}

extension PyBool {
  public static let pythonTypeName = "bool"
}

extension PyMemory {
  public func newBool(type: PyType, value: Bool) -> PyBool
}

extension PyBuiltinFunction {
  public static let pythonTypeName = "builtinFunction"
}

extension PyMemory {
  public func newBuiltinFunction(type: PyType, function: FunctionWrapper, module: PyObject?, doc: String?) -> PyBuiltinFunction
}

extension PyBuiltinMethod {
  public static let pythonTypeName = "builtinMethod"
}

extension PyMemory {
  public func newBuiltinMethod(type: PyType, function: FunctionWrapper, object: PyObject, module: PyObject?, doc: String?) -> PyBuiltinMethod
}

extension PyByteArray {
  public static let pythonTypeName = "bytearray"
}

extension PyMemory {
  public func newByteArray(type: PyType, elements: Data) -> PyByteArray
}

extension PyByteArrayIterator {
  public static let pythonTypeName = "bytearray_iterator"
}

extension PyMemory {
  public func newByteArrayIterator(type: PyType, bytes: PyByteArray) -> PyByteArrayIterator
}

extension PyBytes {
  public static let pythonTypeName = "bytes"
}

extension PyMemory {
  public func newBytes(type: PyType, elements: Data) -> PyBytes
}

extension PyBytesIterator {
  public static let pythonTypeName = "bytes_iterator"
}

extension PyMemory {
  public func newBytesIterator(type: PyType, bytes: PyBytes) -> PyBytesIterator
}

extension PyCallableIterator {
  public static let pythonTypeName = "callable_iterator"
}

extension PyMemory {
  public func newCallableIterator(type: PyType, callable: PyObject, sentinel: PyObject) -> PyCallableIterator
}

extension PyCell {
  public static let pythonTypeName = "cell"
}

extension PyMemory {
  public func newCell(type: PyType, content: PyObject?) -> PyCell
}

extension PyClassMethod {
  public static let pythonTypeName = "classmethod"
}

extension PyMemory {
  public func newClassMethod(type: PyType, callable: PyObject?) -> PyClassMethod
}

extension PyCode {
  public static let pythonTypeName = "code"
}

extension PyMemory {
  public func newCode(type: PyType, code: VioletBytecode.CodeObject) -> PyCode
}

extension PyComplex {
  public static let pythonTypeName = "complex"
}

extension PyMemory {
  public func newComplex(type: PyType, real: Double, imag: Double) -> PyComplex
}

extension PyDict {
  public static let pythonTypeName = "dict"
}

extension PyMemory {
  public func newDict(type: PyType, elements: PyDict.OrderedDictionary) -> PyDict
}

extension PyDictItemIterator {
  public static let pythonTypeName = "dict_itemiterator"
}

extension PyMemory {
  public func newDictItemIterator(type: PyType, dict: PyDict) -> PyDictItemIterator
}

extension PyDictItems {
  public static let pythonTypeName = "dict_items"
}

extension PyMemory {
  public func newDictItems(type: PyType, dict: PyDict) -> PyDictItems
}

extension PyDictKeyIterator {
  public static let pythonTypeName = "dict_keyiterator"
}

extension PyMemory {
  public func newDictKeyIterator(type: PyType, dict: PyDict) -> PyDictKeyIterator
}

extension PyDictKeys {
  public static let pythonTypeName = "dict_keys"
}

extension PyMemory {
  public func newDictKeys(type: PyType, dict: PyDict) -> PyDictKeys
}

extension PyDictValueIterator {
  public static let pythonTypeName = "dict_valueiterator"
}

extension PyMemory {
  public func newDictValueIterator(type: PyType, dict: PyDict) -> PyDictValueIterator
}

extension PyDictValues {
  public static let pythonTypeName = "dict_values"
}

extension PyMemory {
  public func newDictValues(type: PyType, dict: PyDict) -> PyDictValues
}

extension PyEllipsis {
  public static let pythonTypeName = "ellipsis"
}

extension PyMemory {
  public func newEllipsis(type: PyType) -> PyEllipsis
}

extension PyEnumerate {
  public static let pythonTypeName = "enumerate"
}

extension PyMemory {
  public func newEnumerate(type: PyType, iterator: PyObject, initialIndex: BigInt) -> PyEnumerate
}

extension PyFilter {
  public static let pythonTypeName = "filter"
}

extension PyMemory {
  public func newFilter(type: PyType, fn: PyObject, iterator: PyObject) -> PyFilter
}

extension PyFloat {
  public static let pythonTypeName = "float"
}

extension PyMemory {
  public func newFloat(type: PyType, value: Double) -> PyFloat
}

extension PyFrame {
  public static let pythonTypeName = "frame"
}

extension PyMemory {
  public func newFrame(type: PyType, code: PyCode, locals: PyDict, globals: PyDict, parent: PyFrame?) -> PyFrame
}

extension PyFrozenSet {
  public static let pythonTypeName = "frozenset"
}

extension PyMemory {
  public func newFrozenSet(type: PyType, elements: OrderedSet) -> PyFrozenSet
}

extension PyFunction {
  public static let pythonTypeName = "function"
}

extension PyMemory {
  public func newFunction(type: PyType, qualname: PyString?, module: PyObject, code: PyCode, globals: PyDict) -> PyFunction
}

extension PyInt {
  public static let pythonTypeName = "int"
}

extension PyMemory {
  public func newInt(type: PyType, value: BigInt) -> PyInt
}

extension PyIterator {
  public static let pythonTypeName = "iterator"
}

extension PyMemory {
  public func newIterator(type: PyType, sequence: PyObject) -> PyIterator
}

extension PyList {
  public static let pythonTypeName = "list"
}

extension PyMemory {
  public func newList(type: PyType, elements: [PyObject]) -> PyList
}

extension PyListIterator {
  public static let pythonTypeName = "list_iterator"
}

extension PyMemory {
  public func newListIterator(type: PyType, list: PyList) -> PyListIterator
}

extension PyListReverseIterator {
  public static let pythonTypeName = "list_reverseiterator"
}

extension PyMemory {
  public func newListReverseIterator(type: PyType, list: PyList) -> PyListReverseIterator
}

extension PyMap {
  public static let pythonTypeName = "map"
}

extension PyMemory {
  public func newMap(type: PyType, fn: PyObject, iterators: [PyObject]) -> PyMap
}

extension PyMethod {
  public static let pythonTypeName = "method"
}

extension PyMemory {
  public func newMethod(type: PyType, function: PyFunction, object: PyObject) -> PyMethod
}

extension PyModule {
  public static let pythonTypeName = "module"
}

extension PyMemory {
  public func newModule(type: PyType, name: PyObject?, doc: PyObject?, __dict__: PyDict? = nil) -> PyModule
}

extension PyNamespace {
  public static let pythonTypeName = "SimpleNamespace"
}

extension PyMemory {
  public func newNamespace(type: PyType, __dict__: PyDict?) -> PyNamespace
}

extension PyNone {
  public static let pythonTypeName = "NoneType"
}

extension PyMemory {
  public func newNone(type: PyType) -> PyNone
}

extension PyNotImplemented {
  public static let pythonTypeName = "NotImplementedType"
}

extension PyMemory {
  public func newNotImplemented(type: PyType) -> PyNotImplemented
}

extension PyObject {
  public static let pythonTypeName = "object"
}

extension PyMemory {
  public func newObject(type: PyType, __dict__: PyDict? = nil) -> PyObject
}

extension PyProperty {
  public static let pythonTypeName = "property"
}

extension PyMemory {
  public func newProperty(type: PyType, get: PyObject?, set: PyObject?, del: PyObject?, doc: PyObject?) -> PyProperty
}

extension PyRange {
  public static let pythonTypeName = "range"
}

extension PyMemory {
  public func newRange(type: PyType, start: PyInt, stop: PyInt, step: PyInt?) -> PyRange
}

extension PyRangeIterator {
  public static let pythonTypeName = "range_iterator"
}

extension PyMemory {
  public func newRangeIterator(type: PyType, start: BigInt, step: BigInt, length: BigInt) -> PyRangeIterator
}

extension PyReversed {
  public static let pythonTypeName = "reversed"
}

extension PyMemory {
  public func newReversed(type: PyType, sequence: PyObject, count: Int) -> PyReversed
}

extension PySet {
  public static let pythonTypeName = "set"
}

extension PyMemory {
  public func newSet(type: PyType, elements: OrderedSet) -> PySet
}

extension PySetIterator {
  public static let pythonTypeName = "set_iterator"
}

extension PyMemory {
  public func newSetIterator(type: PyType, set: PySet) -> PySetIterator
  public func newSetIterator(type: PyType, frozenSet: PyFrozenSet) -> PySetIterator
}

extension PySlice {
  public static let pythonTypeName = "slice"
}

extension PyMemory {
  public func newSlice(type: PyType, start: PyObject, stop: PyObject, step: PyObject) -> PySlice
}

extension PyStaticMethod {
  public static let pythonTypeName = "staticmethod"
}

extension PyMemory {
  public func newStaticMethod(type: PyType, callable: PyObject?) -> PyStaticMethod
}

extension PyString {
  public static let pythonTypeName = "str"
}

extension PyMemory {
  public func newString(type: PyType, value: String) -> PyString
}

extension PyStringIterator {
  public static let pythonTypeName = "str_iterator"
}

extension PyMemory {
  public func newStringIterator(type: PyType, string: PyString) -> PyStringIterator
}

extension PySuper {
  public static let pythonTypeName = "super"
}

extension PyMemory {
  public func newSuper(type: PyType, requestedType: PyType?, object: PyObject?, objectType: PyType?) -> PySuper
}

extension PyTextFile {
  public static let pythonTypeName = "TextFile"
}

extension PyMemory {
  public func newTextFile(type: PyType, name: String?, fd: PyFileDescriptorType, mode: FileMode, encoding: PyString.Encoding, errorHandling: PyString.ErrorHandling, closeOnDealloc: Bool) -> PyTextFile
}

extension PyTraceback {
  public static let pythonTypeName = "traceback"
}

extension PyMemory {
  public func newTraceback(type: PyType, next: PyTraceback?, frame: PyFrame, lastInstruction: PyInt, lineNo: PyInt) -> PyTraceback
}

extension PyTuple {
  public static let pythonTypeName = "tuple"
}

extension PyMemory {
  public func newTuple(type: PyType, elements: [PyObject]) -> PyTuple
}

extension PyTupleIterator {
  public static let pythonTypeName = "tuple_iterator"
}

extension PyMemory {
  public func newTupleIterator(type: PyType, tuple: PyTuple) -> PyTupleIterator
}

extension PyType {
  public static let pythonTypeName = "type"
}

extension PyMemory {
  public func newType(type: PyType, name: String, qualname: String, flags: PyType.Flags, base: PyType?, bases: [PyType], mroWithoutSelf: [PyType], subclasses: [PyType], instanceSizeWithoutTail: Int, staticMethods: PyStaticCall.KnownNotOverriddenMethods, debugFn: @escaping PyType.DebugFn, deinitialize: @escaping PyType.DeinitializeFn) -> PyType
}

extension PyZip {
  public static let pythonTypeName = "zip"
}

extension PyMemory {
  public func newZip(type: PyType, iterators: [PyObject]) -> PyZip
}

extension PyArithmeticError {
  public static let pythonTypeName = "ArithmeticError"
}

extension PyMemory {
  public func newArithmeticError(type: PyType, args: PyTuple, traceback: PyTraceback? = nil, cause: PyBaseException? = nil, context: PyBaseException? = nil, suppressContext: Bool = PyBaseException.defaultSuppressContext) -> PyArithmeticError
}

extension PyAssertionError {
  public static let pythonTypeName = "AssertionError"
}

extension PyMemory {
  public func newAssertionError(type: PyType, args: PyTuple, traceback: PyTraceback? = nil, cause: PyBaseException? = nil, context: PyBaseException? = nil, suppressContext: Bool = PyBaseException.defaultSuppressContext) -> PyAssertionError
}

extension PyAttributeError {
  public static let pythonTypeName = "AttributeError"
}

extension PyMemory {
  public func newAttributeError(type: PyType, args: PyTuple, traceback: PyTraceback? = nil, cause: PyBaseException? = nil, context: PyBaseException? = nil, suppressContext: Bool = PyBaseException.defaultSuppressContext) -> PyAttributeError
}

extension PyBaseException {
  public static let pythonTypeName = "BaseException"
}

extension PyMemory {
  public func newBaseException(type: PyType, args: PyTuple, traceback: PyTraceback? = nil, cause: PyBaseException? = nil, context: PyBaseException? = nil, suppressContext: Bool = PyBaseException.defaultSuppressContext) -> PyBaseException
}

extension PyBlockingIOError {
  public static let pythonTypeName = "BlockingIOError"
}

extension PyMemory {
  public func newBlockingIOError(type: PyType, args: PyTuple, traceback: PyTraceback? = nil, cause: PyBaseException? = nil, context: PyBaseException? = nil, suppressContext: Bool = PyBaseException.defaultSuppressContext) -> PyBlockingIOError
}

extension PyBrokenPipeError {
  public static let pythonTypeName = "BrokenPipeError"
}

extension PyMemory {
  public func newBrokenPipeError(type: PyType, args: PyTuple, traceback: PyTraceback? = nil, cause: PyBaseException? = nil, context: PyBaseException? = nil, suppressContext: Bool = PyBaseException.defaultSuppressContext) -> PyBrokenPipeError
}

extension PyBufferError {
  public static let pythonTypeName = "BufferError"
}

extension PyMemory {
  public func newBufferError(type: PyType, args: PyTuple, traceback: PyTraceback? = nil, cause: PyBaseException? = nil, context: PyBaseException? = nil, suppressContext: Bool = PyBaseException.defaultSuppressContext) -> PyBufferError
}

extension PyBytesWarning {
  public static let pythonTypeName = "BytesWarning"
}

extension PyMemory {
  public func newBytesWarning(type: PyType, args: PyTuple, traceback: PyTraceback? = nil, cause: PyBaseException? = nil, context: PyBaseException? = nil, suppressContext: Bool = PyBaseException.defaultSuppressContext) -> PyBytesWarning
}

extension PyChildProcessError {
  public static let pythonTypeName = "ChildProcessError"
}

extension PyMemory {
  public func newChildProcessError(type: PyType, args: PyTuple, traceback: PyTraceback? = nil, cause: PyBaseException? = nil, context: PyBaseException? = nil, suppressContext: Bool = PyBaseException.defaultSuppressContext) -> PyChildProcessError
}

extension PyConnectionAbortedError {
  public static let pythonTypeName = "ConnectionAbortedError"
}

extension PyMemory {
  public func newConnectionAbortedError(type: PyType, args: PyTuple, traceback: PyTraceback? = nil, cause: PyBaseException? = nil, context: PyBaseException? = nil, suppressContext: Bool = PyBaseException.defaultSuppressContext) -> PyConnectionAbortedError
}

extension PyConnectionError {
  public static let pythonTypeName = "ConnectionError"
}

extension PyMemory {
  public func newConnectionError(type: PyType, args: PyTuple, traceback: PyTraceback? = nil, cause: PyBaseException? = nil, context: PyBaseException? = nil, suppressContext: Bool = PyBaseException.defaultSuppressContext) -> PyConnectionError
}

extension PyConnectionRefusedError {
  public static let pythonTypeName = "ConnectionRefusedError"
}

extension PyMemory {
  public func newConnectionRefusedError(type: PyType, args: PyTuple, traceback: PyTraceback? = nil, cause: PyBaseException? = nil, context: PyBaseException? = nil, suppressContext: Bool = PyBaseException.defaultSuppressContext) -> PyConnectionRefusedError
}

extension PyConnectionResetError {
  public static let pythonTypeName = "ConnectionResetError"
}

extension PyMemory {
  public func newConnectionResetError(type: PyType, args: PyTuple, traceback: PyTraceback? = nil, cause: PyBaseException? = nil, context: PyBaseException? = nil, suppressContext: Bool = PyBaseException.defaultSuppressContext) -> PyConnectionResetError
}

extension PyDeprecationWarning {
  public static let pythonTypeName = "DeprecationWarning"
}

extension PyMemory {
  public func newDeprecationWarning(type: PyType, args: PyTuple, traceback: PyTraceback? = nil, cause: PyBaseException? = nil, context: PyBaseException? = nil, suppressContext: Bool = PyBaseException.defaultSuppressContext) -> PyDeprecationWarning
}

extension PyEOFError {
  public static let pythonTypeName = "EOFError"
}

extension PyMemory {
  public func newEOFError(type: PyType, args: PyTuple, traceback: PyTraceback? = nil, cause: PyBaseException? = nil, context: PyBaseException? = nil, suppressContext: Bool = PyBaseException.defaultSuppressContext) -> PyEOFError
}

extension PyException {
  public static let pythonTypeName = "Exception"
}

extension PyMemory {
  public func newException(type: PyType, args: PyTuple, traceback: PyTraceback? = nil, cause: PyBaseException? = nil, context: PyBaseException? = nil, suppressContext: Bool = PyBaseException.defaultSuppressContext) -> PyException
}

extension PyFileExistsError {
  public static let pythonTypeName = "FileExistsError"
}

extension PyMemory {
  public func newFileExistsError(type: PyType, args: PyTuple, traceback: PyTraceback? = nil, cause: PyBaseException? = nil, context: PyBaseException? = nil, suppressContext: Bool = PyBaseException.defaultSuppressContext) -> PyFileExistsError
}

extension PyFileNotFoundError {
  public static let pythonTypeName = "FileNotFoundError"
}

extension PyMemory {
  public func newFileNotFoundError(type: PyType, args: PyTuple, traceback: PyTraceback? = nil, cause: PyBaseException? = nil, context: PyBaseException? = nil, suppressContext: Bool = PyBaseException.defaultSuppressContext) -> PyFileNotFoundError
}

extension PyFloatingPointError {
  public static let pythonTypeName = "FloatingPointError"
}

extension PyMemory {
  public func newFloatingPointError(type: PyType, args: PyTuple, traceback: PyTraceback? = nil, cause: PyBaseException? = nil, context: PyBaseException? = nil, suppressContext: Bool = PyBaseException.defaultSuppressContext) -> PyFloatingPointError
}

extension PyFutureWarning {
  public static let pythonTypeName = "FutureWarning"
}

extension PyMemory {
  public func newFutureWarning(type: PyType, args: PyTuple, traceback: PyTraceback? = nil, cause: PyBaseException? = nil, context: PyBaseException? = nil, suppressContext: Bool = PyBaseException.defaultSuppressContext) -> PyFutureWarning
}

extension PyGeneratorExit {
  public static let pythonTypeName = "GeneratorExit"
}

extension PyMemory {
  public func newGeneratorExit(type: PyType, args: PyTuple, traceback: PyTraceback? = nil, cause: PyBaseException? = nil, context: PyBaseException? = nil, suppressContext: Bool = PyBaseException.defaultSuppressContext) -> PyGeneratorExit
}

extension PyImportError {
  public static let pythonTypeName = "ImportError"
}

extension PyMemory {
  public func newImportError(type: PyType, msg: PyObject?, moduleName: PyObject?, modulePath: PyObject?, traceback: PyTraceback? = nil, cause: PyBaseException? = nil, context: PyBaseException? = nil, suppressContext: Bool = PyBaseException.defaultSuppressContext) -> PyImportError
  public func newImportError(type: PyType, args: PyTuple, traceback: PyTraceback? = nil, cause: PyBaseException? = nil, context: PyBaseException? = nil, suppressContext: Bool = PyBaseException.defaultSuppressContext) -> PyImportError
}

extension PyImportWarning {
  public static let pythonTypeName = "ImportWarning"
}

extension PyMemory {
  public func newImportWarning(type: PyType, args: PyTuple, traceback: PyTraceback? = nil, cause: PyBaseException? = nil, context: PyBaseException? = nil, suppressContext: Bool = PyBaseException.defaultSuppressContext) -> PyImportWarning
}

extension PyIndentationError {
  public static let pythonTypeName = "IndentationError"
}

extension PyMemory {
  public func newIndentationError(type: PyType, msg: PyObject?, filename: PyObject?, lineno: PyObject?, offset: PyObject?, text: PyObject?, printFileAndLine: PyObject?, traceback: PyTraceback? = nil, cause: PyBaseException? = nil, context: PyBaseException? = nil, suppressContext: Bool = PyBaseException.defaultSuppressContext) -> PyIndentationError
  public func newIndentationError(type: PyType, args: PyTuple, traceback: PyTraceback? = nil, cause: PyBaseException? = nil, context: PyBaseException? = nil, suppressContext: Bool = PyBaseException.defaultSuppressContext) -> PyIndentationError
}

extension PyIndexError {
  public static let pythonTypeName = "IndexError"
}

extension PyMemory {
  public func newIndexError(type: PyType, args: PyTuple, traceback: PyTraceback? = nil, cause: PyBaseException? = nil, context: PyBaseException? = nil, suppressContext: Bool = PyBaseException.defaultSuppressContext) -> PyIndexError
}

extension PyInterruptedError {
  public static let pythonTypeName = "InterruptedError"
}

extension PyMemory {
  public func newInterruptedError(type: PyType, args: PyTuple, traceback: PyTraceback? = nil, cause: PyBaseException? = nil, context: PyBaseException? = nil, suppressContext: Bool = PyBaseException.defaultSuppressContext) -> PyInterruptedError
}

extension PyIsADirectoryError {
  public static let pythonTypeName = "IsADirectoryError"
}

extension PyMemory {
  public func newIsADirectoryError(type: PyType, args: PyTuple, traceback: PyTraceback? = nil, cause: PyBaseException? = nil, context: PyBaseException? = nil, suppressContext: Bool = PyBaseException.defaultSuppressContext) -> PyIsADirectoryError
}

extension PyKeyError {
  public static let pythonTypeName = "KeyError"
}

extension PyMemory {
  public func newKeyError(type: PyType, args: PyTuple, traceback: PyTraceback? = nil, cause: PyBaseException? = nil, context: PyBaseException? = nil, suppressContext: Bool = PyBaseException.defaultSuppressContext) -> PyKeyError
}

extension PyKeyboardInterrupt {
  public static let pythonTypeName = "KeyboardInterrupt"
}

extension PyMemory {
  public func newKeyboardInterrupt(type: PyType, args: PyTuple, traceback: PyTraceback? = nil, cause: PyBaseException? = nil, context: PyBaseException? = nil, suppressContext: Bool = PyBaseException.defaultSuppressContext) -> PyKeyboardInterrupt
}

extension PyLookupError {
  public static let pythonTypeName = "LookupError"
}

extension PyMemory {
  public func newLookupError(type: PyType, args: PyTuple, traceback: PyTraceback? = nil, cause: PyBaseException? = nil, context: PyBaseException? = nil, suppressContext: Bool = PyBaseException.defaultSuppressContext) -> PyLookupError
}

extension PyMemoryError {
  public static let pythonTypeName = "MemoryError"
}

extension PyMemory {
  public func newMemoryError(type: PyType, args: PyTuple, traceback: PyTraceback? = nil, cause: PyBaseException? = nil, context: PyBaseException? = nil, suppressContext: Bool = PyBaseException.defaultSuppressContext) -> PyMemoryError
}

extension PyModuleNotFoundError {
  public static let pythonTypeName = "ModuleNotFoundError"
}

extension PyMemory {
  public func newModuleNotFoundError(type: PyType, msg: PyObject?, moduleName: PyObject?, modulePath: PyObject?, traceback: PyTraceback? = nil, cause: PyBaseException? = nil, context: PyBaseException? = nil, suppressContext: Bool = PyBaseException.defaultSuppressContext) -> PyModuleNotFoundError
  public func newModuleNotFoundError(type: PyType, args: PyTuple, traceback: PyTraceback? = nil, cause: PyBaseException? = nil, context: PyBaseException? = nil, suppressContext: Bool = PyBaseException.defaultSuppressContext) -> PyModuleNotFoundError
}

extension PyNameError {
  public static let pythonTypeName = "NameError"
}

extension PyMemory {
  public func newNameError(type: PyType, args: PyTuple, traceback: PyTraceback? = nil, cause: PyBaseException? = nil, context: PyBaseException? = nil, suppressContext: Bool = PyBaseException.defaultSuppressContext) -> PyNameError
}

extension PyNotADirectoryError {
  public static let pythonTypeName = "NotADirectoryError"
}

extension PyMemory {
  public func newNotADirectoryError(type: PyType, args: PyTuple, traceback: PyTraceback? = nil, cause: PyBaseException? = nil, context: PyBaseException? = nil, suppressContext: Bool = PyBaseException.defaultSuppressContext) -> PyNotADirectoryError
}

extension PyNotImplementedError {
  public static let pythonTypeName = "NotImplementedError"
}

extension PyMemory {
  public func newNotImplementedError(type: PyType, args: PyTuple, traceback: PyTraceback? = nil, cause: PyBaseException? = nil, context: PyBaseException? = nil, suppressContext: Bool = PyBaseException.defaultSuppressContext) -> PyNotImplementedError
}

extension PyOSError {
  public static let pythonTypeName = "OSError"
}

extension PyMemory {
  public func newOSError(type: PyType, args: PyTuple, traceback: PyTraceback? = nil, cause: PyBaseException? = nil, context: PyBaseException? = nil, suppressContext: Bool = PyBaseException.defaultSuppressContext) -> PyOSError
}

extension PyOverflowError {
  public static let pythonTypeName = "OverflowError"
}

extension PyMemory {
  public func newOverflowError(type: PyType, args: PyTuple, traceback: PyTraceback? = nil, cause: PyBaseException? = nil, context: PyBaseException? = nil, suppressContext: Bool = PyBaseException.defaultSuppressContext) -> PyOverflowError
}

extension PyPendingDeprecationWarning {
  public static let pythonTypeName = "PendingDeprecationWarning"
}

extension PyMemory {
  public func newPendingDeprecationWarning(type: PyType, args: PyTuple, traceback: PyTraceback? = nil, cause: PyBaseException? = nil, context: PyBaseException? = nil, suppressContext: Bool = PyBaseException.defaultSuppressContext) -> PyPendingDeprecationWarning
}

extension PyPermissionError {
  public static let pythonTypeName = "PermissionError"
}

extension PyMemory {
  public func newPermissionError(type: PyType, args: PyTuple, traceback: PyTraceback? = nil, cause: PyBaseException? = nil, context: PyBaseException? = nil, suppressContext: Bool = PyBaseException.defaultSuppressContext) -> PyPermissionError
}

extension PyProcessLookupError {
  public static let pythonTypeName = "ProcessLookupError"
}

extension PyMemory {
  public func newProcessLookupError(type: PyType, args: PyTuple, traceback: PyTraceback? = nil, cause: PyBaseException? = nil, context: PyBaseException? = nil, suppressContext: Bool = PyBaseException.defaultSuppressContext) -> PyProcessLookupError
}

extension PyRecursionError {
  public static let pythonTypeName = "RecursionError"
}

extension PyMemory {
  public func newRecursionError(type: PyType, args: PyTuple, traceback: PyTraceback? = nil, cause: PyBaseException? = nil, context: PyBaseException? = nil, suppressContext: Bool = PyBaseException.defaultSuppressContext) -> PyRecursionError
}

extension PyReferenceError {
  public static let pythonTypeName = "ReferenceError"
}

extension PyMemory {
  public func newReferenceError(type: PyType, args: PyTuple, traceback: PyTraceback? = nil, cause: PyBaseException? = nil, context: PyBaseException? = nil, suppressContext: Bool = PyBaseException.defaultSuppressContext) -> PyReferenceError
}

extension PyResourceWarning {
  public static let pythonTypeName = "ResourceWarning"
}

extension PyMemory {
  public func newResourceWarning(type: PyType, args: PyTuple, traceback: PyTraceback? = nil, cause: PyBaseException? = nil, context: PyBaseException? = nil, suppressContext: Bool = PyBaseException.defaultSuppressContext) -> PyResourceWarning
}

extension PyRuntimeError {
  public static let pythonTypeName = "RuntimeError"
}

extension PyMemory {
  public func newRuntimeError(type: PyType, args: PyTuple, traceback: PyTraceback? = nil, cause: PyBaseException? = nil, context: PyBaseException? = nil, suppressContext: Bool = PyBaseException.defaultSuppressContext) -> PyRuntimeError
}

extension PyRuntimeWarning {
  public static let pythonTypeName = "RuntimeWarning"
}

extension PyMemory {
  public func newRuntimeWarning(type: PyType, args: PyTuple, traceback: PyTraceback? = nil, cause: PyBaseException? = nil, context: PyBaseException? = nil, suppressContext: Bool = PyBaseException.defaultSuppressContext) -> PyRuntimeWarning
}

extension PyStopAsyncIteration {
  public static let pythonTypeName = "StopAsyncIteration"
}

extension PyMemory {
  public func newStopAsyncIteration(type: PyType, args: PyTuple, traceback: PyTraceback? = nil, cause: PyBaseException? = nil, context: PyBaseException? = nil, suppressContext: Bool = PyBaseException.defaultSuppressContext) -> PyStopAsyncIteration
}

extension PyStopIteration {
  public static let pythonTypeName = "StopIteration"
}

extension PyMemory {
  public func newStopIteration(type: PyType, value: PyObject, traceback: PyTraceback? = nil, cause: PyBaseException? = nil, context: PyBaseException? = nil, suppressContext: Bool = PyBaseException.defaultSuppressContext) -> PyStopIteration
  public func newStopIteration(type: PyType, args: PyTuple, traceback: PyTraceback? = nil, cause: PyBaseException? = nil, context: PyBaseException? = nil, suppressContext: Bool = PyBaseException.defaultSuppressContext) -> PyStopIteration
}

extension PySyntaxError {
  public static let pythonTypeName = "SyntaxError"
}

extension PyMemory {
  public func newSyntaxError(type: PyType, msg: PyObject?, filename: PyObject?, lineno: PyObject?, offset: PyObject?, text: PyObject?, printFileAndLine: PyObject?, traceback: PyTraceback? = nil, cause: PyBaseException? = nil, context: PyBaseException? = nil, suppressContext: Bool = PyBaseException.defaultSuppressContext) -> PySyntaxError
  public func newSyntaxError(type: PyType, args: PyTuple, traceback: PyTraceback? = nil, cause: PyBaseException? = nil, context: PyBaseException? = nil, suppressContext: Bool = PyBaseException.defaultSuppressContext) -> PySyntaxError
}

extension PySyntaxWarning {
  public static let pythonTypeName = "SyntaxWarning"
}

extension PyMemory {
  public func newSyntaxWarning(type: PyType, args: PyTuple, traceback: PyTraceback? = nil, cause: PyBaseException? = nil, context: PyBaseException? = nil, suppressContext: Bool = PyBaseException.defaultSuppressContext) -> PySyntaxWarning
}

extension PySystemError {
  public static let pythonTypeName = "SystemError"
}

extension PyMemory {
  public func newSystemError(type: PyType, args: PyTuple, traceback: PyTraceback? = nil, cause: PyBaseException? = nil, context: PyBaseException? = nil, suppressContext: Bool = PyBaseException.defaultSuppressContext) -> PySystemError
}

extension PySystemExit {
  public static let pythonTypeName = "SystemExit"
}

extension PyMemory {
  public func newSystemExit(type: PyType, code: PyObject?, traceback: PyTraceback? = nil, cause: PyBaseException? = nil, context: PyBaseException? = nil, suppressContext: Bool = PyBaseException.defaultSuppressContext) -> PySystemExit
  public func newSystemExit(type: PyType, args: PyTuple, traceback: PyTraceback? = nil, cause: PyBaseException? = nil, context: PyBaseException? = nil, suppressContext: Bool = PyBaseException.defaultSuppressContext) -> PySystemExit
}

extension PyTabError {
  public static let pythonTypeName = "TabError"
}

extension PyMemory {
  public func newTabError(type: PyType, msg: PyObject?, filename: PyObject?, lineno: PyObject?, offset: PyObject?, text: PyObject?, printFileAndLine: PyObject?, traceback: PyTraceback? = nil, cause: PyBaseException? = nil, context: PyBaseException? = nil, suppressContext: Bool = PyBaseException.defaultSuppressContext) -> PyTabError
  public func newTabError(type: PyType, args: PyTuple, traceback: PyTraceback? = nil, cause: PyBaseException? = nil, context: PyBaseException? = nil, suppressContext: Bool = PyBaseException.defaultSuppressContext) -> PyTabError
}

extension PyTimeoutError {
  public static let pythonTypeName = "TimeoutError"
}

extension PyMemory {
  public func newTimeoutError(type: PyType, args: PyTuple, traceback: PyTraceback? = nil, cause: PyBaseException? = nil, context: PyBaseException? = nil, suppressContext: Bool = PyBaseException.defaultSuppressContext) -> PyTimeoutError
}

extension PyTypeError {
  public static let pythonTypeName = "TypeError"
}

extension PyMemory {
  public func newTypeError(type: PyType, args: PyTuple, traceback: PyTraceback? = nil, cause: PyBaseException? = nil, context: PyBaseException? = nil, suppressContext: Bool = PyBaseException.defaultSuppressContext) -> PyTypeError
}

extension PyUnboundLocalError {
  public static let pythonTypeName = "UnboundLocalError"
}

extension PyMemory {
  public func newUnboundLocalError(type: PyType, args: PyTuple, traceback: PyTraceback? = nil, cause: PyBaseException? = nil, context: PyBaseException? = nil, suppressContext: Bool = PyBaseException.defaultSuppressContext) -> PyUnboundLocalError
}

extension PyUnicodeDecodeError {
  public static let pythonTypeName = "UnicodeDecodeError"
}

extension PyMemory {
  public func newUnicodeDecodeError(type: PyType, args: PyTuple, traceback: PyTraceback? = nil, cause: PyBaseException? = nil, context: PyBaseException? = nil, suppressContext: Bool = PyBaseException.defaultSuppressContext) -> PyUnicodeDecodeError
}

extension PyUnicodeEncodeError {
  public static let pythonTypeName = "UnicodeEncodeError"
}

extension PyMemory {
  public func newUnicodeEncodeError(type: PyType, args: PyTuple, traceback: PyTraceback? = nil, cause: PyBaseException? = nil, context: PyBaseException? = nil, suppressContext: Bool = PyBaseException.defaultSuppressContext) -> PyUnicodeEncodeError
}

extension PyUnicodeError {
  public static let pythonTypeName = "UnicodeError"
}

extension PyMemory {
  public func newUnicodeError(type: PyType, args: PyTuple, traceback: PyTraceback? = nil, cause: PyBaseException? = nil, context: PyBaseException? = nil, suppressContext: Bool = PyBaseException.defaultSuppressContext) -> PyUnicodeError
}

extension PyUnicodeTranslateError {
  public static let pythonTypeName = "UnicodeTranslateError"
}

extension PyMemory {
  public func newUnicodeTranslateError(type: PyType, args: PyTuple, traceback: PyTraceback? = nil, cause: PyBaseException? = nil, context: PyBaseException? = nil, suppressContext: Bool = PyBaseException.defaultSuppressContext) -> PyUnicodeTranslateError
}

extension PyUnicodeWarning {
  public static let pythonTypeName = "UnicodeWarning"
}

extension PyMemory {
  public func newUnicodeWarning(type: PyType, args: PyTuple, traceback: PyTraceback? = nil, cause: PyBaseException? = nil, context: PyBaseException? = nil, suppressContext: Bool = PyBaseException.defaultSuppressContext) -> PyUnicodeWarning
}

extension PyUserWarning {
  public static let pythonTypeName = "UserWarning"
}

extension PyMemory {
  public func newUserWarning(type: PyType, args: PyTuple, traceback: PyTraceback? = nil, cause: PyBaseException? = nil, context: PyBaseException? = nil, suppressContext: Bool = PyBaseException.defaultSuppressContext) -> PyUserWarning
}

extension PyValueError {
  public static let pythonTypeName = "ValueError"
}

extension PyMemory {
  public func newValueError(type: PyType, args: PyTuple, traceback: PyTraceback? = nil, cause: PyBaseException? = nil, context: PyBaseException? = nil, suppressContext: Bool = PyBaseException.defaultSuppressContext) -> PyValueError
}

extension PyWarning {
  public static let pythonTypeName = "Warning"
}

extension PyMemory {
  public func newWarning(type: PyType, args: PyTuple, traceback: PyTraceback? = nil, cause: PyBaseException? = nil, context: PyBaseException? = nil, suppressContext: Bool = PyBaseException.defaultSuppressContext) -> PyWarning
}

extension PyZeroDivisionError {
  public static let pythonTypeName = "ZeroDivisionError"
}

extension PyMemory {
  public func newZeroDivisionError(type: PyType, args: PyTuple, traceback: PyTraceback? = nil, cause: PyBaseException? = nil, context: PyBaseException? = nil, suppressContext: Bool = PyBaseException.defaultSuppressContext) -> PyZeroDivisionError
}

============================
=== Helpers/Hasher.swift ===
============================

public typealias PyHash = Int

===========================================
=== Helpers/MethodResolutionOrder.swift ===
===========================================

public struct MethodResolutionOrder {}

==============================
=== Memory/BufferPtr.swift ===
==============================

public struct BufferPtr<TrivialElement>: RandomAccessCollection {
  public let baseAddress: UnsafeMutablePointer<TrivialElement>
  public let count: Int
  public var startIndex: Int { get }
  public var endIndex: Int { get }
  public init(start: UnsafePointer<TrivialElement>, count: Int)
  public init(start: UnsafeMutablePointer<TrivialElement>, count: Int)
  public func initialize(repeating repeatedValue: TrivialElement)
  public func initialize(from source: BufferPtr<TrivialElement>)
  public func initialize(fn: (Int) -> TrivialElement)
  @discardableResult
  public func deinitialize() -> RawPtr
  public subscript(index: Int) -> TrivialElement { get; nonmutating set }
  public subscript(range: Range<Int>) -> BufferPtr<TrivialElement> { get }
}

========================
=== Memory/Ptr.swift ===
========================

public struct Ptr<Pointee> {
  public var pointee: Pointee { get; nonmutating set }
  public init(_ value: UnsafePointer<Pointee>)
  public init(_ value: UnsafeMutablePointer<Pointee>)
  public init(_ baseRawPtr: RawPtr, offset: Int)
  public func initialize(to pointee: Pointee)
  @discardableResult
  public func deinitialize() -> RawPtr
  public static func ===(lhs: Ptr, rhs: Ptr) -> Bool
}

=============================
=== Memory/PyMemory.swift ===
=============================

public final class PyMemory {
  public func allocateObject(size: Int, alignment: Int) -> RawPtr
  public func destroy(object: PyObject)
}

===========================
=== Memory/RawPtr.swift ===
===========================

public struct RawPtr: CustomStringConvertible {
  public var description: String { get }
  public init(_ value: UnsafeRawPointer)
  public init(_ value: UnsafeMutableRawPointer)
  public func bind<T>(to type: T.Type) -> Ptr<T>
  public func bind<T>(to type: T.Type, count: Int) -> BufferPtr<T>
  public func advanced(by n: Int) -> RawPtr
  public static func allocate(byteCount: Int, alignment: Int) -> RawPtr
  public func deallocate()
  public static func ===(lhs: RawPtr, rhs: RawPtr) -> Bool
  public static func !==(lhs: RawPtr, rhs: RawPtr) -> Bool
}

extension Int {
  public init(bitPattern pointer: RawPtr)
}

===================================================
=== Modules - _imp/UnderscoreImp+Builtins.swift ===
===================================================

extension UnderscoreImp {
  public func isBuiltin(name: PyObject) -> PyResultGen<Int>
  public func createBuiltin(spec: PyObject) -> PyResultGen<PyModule>
  public func execBuiltin(module: PyObject) -> PyBaseException?
}

===============================================
=== Modules - _imp/UnderscoreImp+Lock.swift ===
===============================================

extension UnderscoreImp {
  public func lockHeld() -> PyBool
  public func acquireLock()
  public func releaseLock()
}

==========================================
=== Modules - _imp/UnderscoreImp.swift ===
==========================================

public final class UnderscoreImp: PyModuleImplementation {}

========================================
=== Modules - _os/UnderscoreOS.swift ===
========================================

public final class UnderscoreOS: PyModuleImplementation {
  public func getCwd() -> PyString
  public func getFSPath(path: PyObject) -> PyResultGen<PyString>
  public func getStat(path: PyObject) -> PyResultGen<PyNamespace>
  public func listdir(path: PyObject?) -> PyResultGen<PyList>
}

=============================================================
=== Modules - _warnings/UnderscoreWarnings+Entities.swift ===
=============================================================

extension UnderscoreWarnings {
  public enum WarningRegistry {}
}

===============================================================
=== Modules - _warnings/UnderscoreWarnings+Properties.swift ===
===============================================================

extension UnderscoreWarnings {
  public func getFilters() -> PyResultGen<PyList>
  public func setFilters(_ value: PyObject) -> PyBaseException?
  public func getDefaultAction() -> PyResultGen<PyString>
  public func setDefaultAction(_ value: PyObject) -> PyBaseException?
  public func getOnceRegistry() -> PyResultGen<PyDict>
  public func setOnceRegistry(_ value: PyObject) -> PyBaseException?
}

=========================================================
=== Modules - _warnings/UnderscoreWarnings+Warn.swift ===
=========================================================

extension UnderscoreWarnings {
  public func warn(message: PyObject, category categoryArg: PyObject? = nil, stackLevel stackLevelArg: PyObject? = nil, source: PyObject? = nil) -> PyBaseException?
  public func getWarningRegistry(frame: PyFrame?) -> PyResultGen<WarningRegistry>
  public func getWarningRegistry(globals: PyDict) -> PyResultGen<WarningRegistry>
}

=================================================================
=== Modules - _warnings/UnderscoreWarnings+WarnExplicit.swift ===
=================================================================

extension UnderscoreWarnings {
  public func warnExplicit(message: PyObject, category: PyType, filename: PyString, lineNo: PyInt, module: PyString?, source: PyObject?, registry: WarningRegistry) -> PyBaseException?
}

====================================================
=== Modules - _warnings/UnderscoreWarnings.swift ===
====================================================

public final class UnderscoreWarnings: PyModuleImplementation {}

=========================================
=== Modules - builtins/Builtins.swift ===
=========================================

public final class Builtins: PyModuleImplementation {}

========================================
=== Modules - sys/Sys+Entities.swift ===
========================================

extension Sys {
  public struct Flags {
    public var debug: Bool { get }
    public var inspect: Bool { get }
    public var interactive: Bool { get }
    public var optimize: Py.OptimizationLevel { get }
    public var ignoreEnvironment: Bool { get }
    public var verbose: Int { get }
    public var warnings: [Arguments.WarningOption] { get }
    public var bytesWarning: Arguments.BytesWarningOption { get }
    public var quiet: Bool { get }
    public var isolated: Bool { get }
  }
  public struct HashInfo {
    public let algorithm = Hasher.algorithm
    public let width = Hasher.width
    public let hashBits = Hasher.hashBits
    public let seedBits = Hasher.seedBits
    public let modulus = Hasher.modulus
    public let inf = Hasher.inf
    public let nan = Hasher.nan
    public let imag = Hasher.imag
  }
  public struct VersionInfo {
    public enum ReleaseLevel: CustomStringConvertible {
      public var description: String { get }
    }
    public let major: UInt8
    public let minor: UInt8
    public let micro: UInt8
    public let releaseLevel: ReleaseLevel
    public let serial: UInt8
    public let hexVersion: UInt32
  }
  public struct ImplementationInfo {
    public let name: String
    public let abstract: String
    public let discussion: String
    public let version: VersionInfo
    public let cacheTag: String?
  }
}

=========================================
=== Modules - sys/Sys+Functions.swift ===
=========================================

extension Sys {
  public func intern(_ value: PyObject) -> PyResultGen<PyString>
  public func intern(_ value: PyString) -> PyString
  public func intern(_ value: String) -> PyString
  public func exit(status: PyObject?) -> PyBaseException
  public func getExit() -> PyResult
  public func setRecursionLimit(_ limit: PyObject) -> PyBaseException?
  public func getTracebackLimit() -> PyResultGen<PyInt>
}

=====================================
=== Modules - sys/Sys+Hooks.swift ===
=====================================

extension Sys {
  public func getDisplayhook() -> PyResult
  public func callDisplayhook(object: PyObject) -> PyResult
  public func getExcepthook() -> PyResult
  public enum CallExcepthookResult {}
  public func callExcepthook(error: PyBaseException) -> CallExcepthookResult
}

=======================================
=== Modules - sys/Sys+Modules.swift ===
=======================================

extension Sys {
  public func getBuiltinModuleNames() -> PyResultGen<PyTuple>
  public func setBuiltinModuleNames(_ value: PyObject) -> PyBaseException?
  public func getModules() -> PyResultGen<PyDict>
  public func setModules(_ value: PyObject) -> PyBaseException?
  public enum GetModuleResult {}
  public func getModule(name: PyString) -> GetModuleResult
  public func getModule(name: PyObject) -> GetModuleResult
  public func addModule(module: PyModule) -> PyBaseException?
}

===========================================
=== Modules - sys/Sys+Prefix+Path.swift ===
===========================================

extension Sys {
  public func getPrefix() -> PyResultGen<PyString>
  public func setPrefix(_ value: PyObject) -> PyBaseException?
  public func getPath() -> PyResultGen<PyList>
  public func setPath(_ value: PyObject) -> PyBaseException?
  public func prependPath(_ value: Path) -> PyBaseException?
  public func getMetaPath() -> PyResultGen<PyList>
  public func setMetaPath(_ value: PyObject) -> PyBaseException?
  public func getPathHooks() -> PyResultGen<PyList>
  public func setPathHooks(_ value: PyObject) -> PyBaseException?
  public func getPathImporterCache() -> PyResultGen<PyDict>
  public func setPathImporterCache(_ value: PyObject) -> PyBaseException?
}

======================================
=== Modules - sys/Sys+Prompt.swift ===
======================================

extension Sys {
  public func getPS1() -> PyResult
  public func setPS1(_ value: PyObject) -> PyBaseException?
  public func getPS2() -> PyResult
  public func setPS2(_ value: PyObject) -> PyBaseException?
}

==========================================
=== Modules - sys/Sys+Properties.swift ===
==========================================

extension Sys {
  public func getArgv() -> PyResultGen<PyList>
  public func setArgv(_ value: PyObject) -> PyBaseException?
  public func getArgv0() -> PyResultGen<PyString>
  public func setArgv0(_ value: Path) -> PyBaseException?
  public func setArgv0(_ value: String) -> PyBaseException?
  public func getFlags() -> PyResult
  public func getWarnOptions() -> PyResultGen<PyList>
  public func getExecutable() -> PyResultGen<PyString>
  public func getPlatform() -> PyResultGen<PyString>
  public func getCopyright() -> PyResultGen<PyString>
  public func getMaxSize() -> PyResultGen<PyInt>
}

=======================================
=== Modules - sys/Sys+Streams.swift ===
=======================================

extension Sys {
  public func get__stdin__() -> PyResultGen<PyTextFile>
  public func getStdin() -> PyResultGen<PyTextFile>
  public func setStdin(fd: PyFileDescriptorType?) -> PyBaseException?
  public func get__stdout__() -> PyResultGen<PyTextFile>
  public func getStdout() -> PyResultGen<PyTextFile>
  public func setStdout(fd: PyFileDescriptorType?) -> PyBaseException?
  public func get__stderr__() -> PyResultGen<PyTextFile>
  public func getStderr() -> PyResultGen<PyTextFile>
  public func setStderr(fd: PyFileDescriptorType?) -> PyBaseException?
  public enum StreamOrNone {}
  public func getStderrOrNone() -> StreamOrNone
  public func getStdoutOrNone() -> StreamOrNone
  public enum InputStream {}
  public func getFile(stream: InputStream) -> PyResultGen<PyTextFile>
  public enum OutputStream {}
  public func getFile(stream: OutputStream) -> PyResultGen<PyTextFile>
}

=======================================
=== Modules - sys/Sys+Version.swift ===
=======================================

extension Sys {
  public func getVersion() -> PyResult
  public func getVersionInfo() -> PyResult
  public func getImplementation() -> PyResult
  public func getHexVersion() -> PyResult
}

===============================
=== Modules - sys/Sys.swift ===
===============================

public final class Sys: PyModuleImplementation {
  public static let pythonVersion = Configure.pythonVersion
  public static let implementation = Configure.implementation
  public static let version: String = {
      let p = Configure.pythonVersion
      let i = Configure.implementation
      let iv = i.version
     <and so on…>
  public static let hashInfo = HashInfo()
  public static var platform: String { get }
  public static let defaultEncoding = PyString.Encoding.utf8
  public let flags: Flags
  public internal(set) var recursionLimit: PyInt
}

========================================
=== Py+Thingies/Py+Any+All+Sum.swift ===
========================================

extension Py {
  public func any(iterable: PyObject) -> PyResultGen<Bool>
  public func all(iterable: PyObject) -> PyResultGen<Bool>
  public func sum(iterable: PyObject, start: PyObject?) -> PyResult
}

=======================================
=== Py+Thingies/Py+Attributes.swift ===
=======================================

extension Py {
  public func getAttribute(object: PyObject, name: String, default: PyObject? = nil) -> PyResult
  public func getAttribute(object: PyObject, name: IdString, default: PyObject? = nil) -> PyResult
  public func getAttribute(object: PyObject, name: PyString, default: PyObject? = nil) -> PyResult
  public func getAttribute(object: PyObject, name: PyObject, default: PyObject? = nil) -> PyResult
  public func hasAttribute(object: PyObject, name: String) -> PyResultGen<Bool>
  public func hasAttribute(object: PyObject, name: IdString) -> PyResultGen<Bool>
  public func hasAttribute(object: PyObject, name: PyString) -> PyResultGen<Bool>
  public func hasAttribute(object: PyObject, name: PyObject) -> PyResultGen<Bool>
  public func setAttribute(object: PyObject, name: String, value: PyObject) -> PyResult
  public func setAttribute(object: PyObject, name: IdString, value: PyObject) -> PyResult
  public func setAttribute(object: PyObject, name: PyString, value: PyObject) -> PyResult
  public func setAttribute(object: PyObject, name nameObject: PyObject, value: PyObject) -> PyResult
  public func delAttribute(object: PyObject, name: String) -> PyResult
  public func delAttribute(object: PyObject, name: IdString) -> PyResult
  public func delAttribute(object: PyObject, name: PyString) -> PyResult
  public func delAttribute(object: PyObject, name nameObject: PyObject) -> PyResult
}

========================================
=== Py+Thingies/Py+Bin+Hex+Oct.swift ===
========================================

extension Py {
  public func bin(object: PyObject) -> PyResultGen<PyString>
  public func oct(object: PyObject) -> PyResultGen<PyString>
  public func hex(object: PyObject) -> PyResultGen<PyString>
}

=================================
=== Py+Thingies/Py+Bool.swift ===
=================================

extension Py {
  public func newBool(_ value: Bool) -> PyBool
  public func newBool(_ value: BigInt) -> PyBool
  public func not(object: PyObject) -> PyResult
  public func notBool(object: PyObject) -> PyResultGen<Bool>
  public func isTrue(object: PyObject) -> PyResult
  public func isTrueBool(object: PyBool) -> Bool
  public func isTrueBool(object: PyObject) -> PyResultGen<Bool>
}

=================================
=== Py+Thingies/Py+Call.swift ===
=================================

extension Py {
  public enum CallResult {
    public var asResult: PyResult { get }
  }
  public func call(callable: PyObject, arg: PyObject) -> CallResult
  public func call(callable: PyObject, args: PyObject, kwargs: PyObject?) -> CallResult
  public func call(callable: PyObject, args: [PyObject] = [], kwargs: PyDict? = nil) -> CallResult
  public func isCallable(object: PyObject) -> Bool
}

extension Py {
  public func hasMethod(object: PyObject, selector: IdString) -> PyResultGen<Bool>
  public func hasMethod(object: PyObject, selector: PyString) -> PyResultGen<Bool>
  public enum GetMethodResult {}
  public func getMethod(object: PyObject, selector: PyString, allowsCallableFromDict: Bool = false) -> GetMethodResult
  public enum CallMethodResult {
    public var asResult: PyResult { get }
  }
  public func callMethod(object: PyObject, selector: IdString, arg: PyObject) -> CallMethodResult
  public func callMethod(object: PyObject, selector: PyString, arg: PyObject) -> CallMethodResult
  public func callMethod(object: PyObject, selector: IdString, args: PyObject, kwargs: PyObject?) -> CallMethodResult
  public func callMethod(object: PyObject, selector: PyString, args: PyObject, kwargs: PyObject?) -> CallMethodResult
  public func callMethod(object: PyObject, selector: IdString, args: [PyObject] = [], kwargs: PyDict? = nil, allowsCallableFromDict: Bool = false) -> CallMethodResult
  public func callMethod(object: PyObject, selector: PyString, args: [PyObject] = [], kwargs: PyDict? = nil, allowsCallableFromDict: Bool = false) -> CallMethodResult
}

==================================
=== Py+Thingies/Py+Class.swift ===
==================================

extension Py {
  public func get__build_class__() -> PyResult
  public func __build_class__(name: PyString, bases basesTuple: PyTuple, bodyFn: PyFunction, kwargs: PyDict?) -> PyResult
}

=================================
=== Py+Thingies/Py+Code.swift ===
=================================

extension Py {
  public func newBuiltinFunction(fn: FunctionWrapper, module: PyObject?, doc: String?) -> PyBuiltinFunction
  public func newBuiltinMethod(fn: FunctionWrapper, object: PyObject, module: PyObject?, doc: String?) -> PyBuiltinMethod
  public func newFunction(qualname: PyObject, code: PyObject, globals: PyDict, defaults: PyObject?, keywordDefaults: PyObject?, closure: PyObject?, annotations: PyObject?) -> PyResultGen<PyFunction>
  public func newFunction(qualname: PyString?, code: PyCode, globals: PyDict, defaults: PyObject?, keywordDefaults: PyObject?, closure: PyObject?, annotations: PyObject?) -> PyResultGen<PyFunction>
  public func newMethod(fn: PyFunction, object: PyObject) -> PyMethod
  public func newMethod(fn: PyObject, object: PyObject) -> PyResult
  public func newStaticMethod(callable: PyBuiltinFunction) -> PyStaticMethod
  public func newStaticMethod(callable: PyFunction) -> PyStaticMethod
  public func newClassMethod(callable: PyBuiltinFunction) -> PyClassMethod
  public func newClassMethod(callable: PyFunction) -> PyClassMethod
  public func newProperty(get: FunctionWrapper, set: FunctionWrapper?, del: FunctionWrapper?, doc: String?) -> PyProperty
  public func getName(function object: PyObject) -> PyString?
  public func newModule(name: String, doc: String?, dict: PyDict?) -> PyModule
  public func newModule(name: PyObject, doc: PyObject?, dict: PyDict?) -> PyModule
  public enum ModuleName {}
  public func getName(module object: PyObject) -> ModuleName
  public func newCode(code: CodeObject) -> PyCode
  public func newFrame(parent: PyFrame?, code: PyCode, args: [PyObject], kwargs: PyDict?, defaults: [PyObject], kwDefaults: PyDict?, locals: PyDict, globals: PyDict, closure: PyTuple?) -> PyResultGen<PyFrame>
  public func newSuper(requestedType: PyType?, object: PyObject?, objectType: PyType?) -> PySuper
  public func newCell(content: PyObject?) -> PyCell
  public func isAbstractMethod(object: PyObject) -> PyResultGen<Bool>
}

================================================
=== Py+Thingies/Py+CollectionIteration.swift ===
================================================

extension Py {
  public func toArray(iterable: PyObject) -> PyResultGen<[PyObject]>
  public enum ForEachStep {}
  public typealias ForEachFn = (PyObject) -> ForEachStep
  public func forEach(iterable: PyObject, fn: ForEachFn) -> PyBaseException?
  public typealias ForEachDictFn = (PyObject, PyObject) -> ForEachStep
  public func forEach(dict: PyDict, fn: ForEachDictFn) -> PyBaseException?
  public typealias ForEachTupleFn = (Int, PyObject) -> ForEachStep
  public func forEach(tuple: PyTuple, fn: ForEachTupleFn) -> PyBaseException?
  public enum ReduceStep<Acc> {}
  public typealias ReduceFn<Acc> = (Acc, PyObject) -> ReduceStep<Acc>
  public func reduce<Acc>(iterable: PyObject, initial: Acc, fn: ReduceFn<Acc>) -> PyResultGen<Acc>
  public enum ReduceIntoStep<Acc> {}
  public typealias ReduceIntoFn<Acc> = (inout Acc, PyObject) -> ReduceIntoStep<Acc>
  public func reduce<Acc>(iterable: PyObject, into acc: inout Acc, fn: ReduceIntoFn<Acc>) -> PyBaseException?
}

========================================
=== Py+Thingies/Py+Collections.swift ===
========================================

extension Py {
  public func newTuple(elements: PyObject...) -> PyTuple
  public func newTuple(elements: [PyObject]) -> PyTuple
  public func newTuple(list object: PyObject) -> PyResultGen<PyTuple>
  public func newTuple(list: PyList) -> PyTuple
  public func newTuple(iterable: PyObject) -> PyResultGen<PyTuple>
  public func newIterator(tuple: PyTuple) -> PyTupleIterator
  public func newList(elements: PyObject...) -> PyList
  public func newList(elements: [PyObject]) -> PyList
  public func newList(iterable: PyObject) -> PyResultGen<PyList>
  public func add(list: PyObject, object: PyObject) -> PyBaseException?
  public func add(list: PyList, object: PyObject)
  public func newIterator(list: PyList) -> PyListIterator
  public func newReverseIterator(list: PyList) -> PyListReverseIterator
  public func newSet() -> PySet
  public func newSet(elements args: [PyObject]) -> PyResultGen<PySet>
  public func add(set: PyObject, object: PyObject) -> PyBaseException?
  public func add(set: PySet, object: PyObject) -> PyBaseException?
  public func update(set: PySet, fromIterable iterable: PyObject) -> PyBaseException?
  public func newIterator(set: PySet) -> PySetIterator
  public func newFrozenSet() -> PyFrozenSet
  public func newFrozenSet(elements args: [PyObject]) -> PyResultGen<PyFrozenSet>
  public func newIterator(set: PyFrozenSet) -> PySetIterator
  public func newDict() -> PyDict
  public struct DictionaryElement {
    public let key: PyObject
    public let value: PyObject
    public init(key: PyObject, value: PyObject)
  }
  public func newDict(elements: [DictionaryElement]) -> PyResultGen<PyDict>
  public func newDict(keys: PyTuple, elements: [PyObject]) -> PyResultGen<PyDict>
  public func add(dict: PyObject, key: IdString, value: PyObject) -> PyBaseException?
  public func add(dict: PyObject, key: PyString, value: PyObject) -> PyBaseException?
  public func add(dict: PyObject, key: PyObject, value: PyObject) -> PyBaseException?
  public func add(dict: PyDict, key: PyObject, value: PyObject) -> PyBaseException?
  public func newDictKeys(dict: PyDict) -> PyDictKeys
  public func newDictItems(dict: PyDict) -> PyDictItems
  public func newDictValues(dict: PyDict) -> PyDictValues
  public func newIterator(keys dict: PyDict) -> PyDictKeyIterator
  public func newIterator(items dict: PyDict) -> PyDictItemIterator
  public func newIterator(values dict: PyDict) -> PyDictValueIterator
  public enum GetKeysResult {}
  public func getKeys(object: PyObject) -> GetKeysResult
  public func newRange(stop: BigInt) -> PyResultGen<PyRange>
  public func newRange(stop: PyInt) -> PyResultGen<PyRange>
  public func newRange(stop: PyObject) -> PyResultGen<PyRange>
  public func newRange(start: BigInt, stop: BigInt, step: BigInt?) -> PyResultGen<PyRange>
  public func newRange(start: PyInt, stop: PyInt, step: PyInt?) -> PyResultGen<PyRange>
  public func newRange(start: PyObject, stop: PyObject, step: PyObject?) -> PyResultGen<PyRange>
  public func newRangeIterator(start: BigInt, step: BigInt, length: BigInt) -> PyRangeIterator
  public func newEnumerate(iterable: PyObject, initialIndex: Int) -> PyResultGen<PyEnumerate>
  public func newEnumerate(iterable: PyObject, initialIndex: BigInt) -> PyResultGen<PyEnumerate>
  public func newSlice(stop: PyObject) -> PySlice
  public func newSlice(start: PyObject?, stop: PyObject?, step: PyObject? = nil) -> PySlice
  public func length(iterable: PyObject) -> PyResult
  public func lengthPyInt(iterable: PyObject) -> PyResultGen<PyInt>
  public func lengthInt(tuple: PyTuple) -> Int
  public func lengthInt(dict: PyDict) -> Int
  public func lengthInt(iterable: PyObject) -> PyResultGen<Int>
  public func contains(iterable: PyObject, object: PyObject) -> PyResult
  public func contains(iterable: PyObject, allFrom subset: PyObject) -> PyResultGen<Bool>
}

====================================
=== Py+Thingies/Py+Compare.swift ===
====================================

extension Py {
  public func isEqual(left: PyObject, right: PyObject) -> PyResult
  public func isEqualBool(left: PyObject, right: PyObject) -> PyResultGen<Bool>
}

extension Py {
  public func isNotEqual(left: PyObject, right: PyObject) -> PyResult
  public func isNotEqualBool(left: PyObject, right: PyObject) -> PyResultGen<Bool>
}

extension Py {
  public func isLess(left: PyObject, right: PyObject) -> PyResult
  public func isLessBool(left: PyObject, right: PyObject) -> PyResultGen<Bool>
}

extension Py {
  public func isLessEqual(left: PyObject, right: PyObject) -> PyResult
  public func isLessEqualBool(left: PyObject, right: PyObject) -> PyResultGen<Bool>
}

extension Py {
  public func isGreater(left: PyObject, right: PyObject) -> PyResult
  public func isGreaterBool(left: PyObject, right: PyObject) -> PyResultGen<Bool>
}

extension Py {
  public func isGreaterEqual(left: PyObject, right: PyObject) -> PyResult
  public func isGreaterEqualBool(left: PyObject, right: PyObject) -> PyResultGen<Bool>
}

====================================
=== Py+Thingies/Py+Compile.swift ===
====================================

extension Py {
  public enum ParserMode {
    public static var exec: ParserMode { get }
    public static var single: ParserMode { get }
  }
  public enum OptimizationLevel: Equatable, Comparable {}
  public enum OptimizationLevelArg {}
  public func compile(source sourceArg: PyObject, filename filenameArg: PyObject, mode modeArg: PyObject, flags: PyObject?, dontInherit: PyObject?, optimize optimizeArg: PyObject?) -> PyResultGen<PyCode>
  public func compile(path: Path, mode: ParserMode, optimize: OptimizationLevelArg) -> PyResultGen<PyCode>
  public func compile(source: String, filename: String, mode: ParserMode, optimize: OptimizationLevelArg) -> PyResultGen<PyCode>
}

===========================================
=== Py+Thingies/Py+Error creation.swift ===
===========================================

extension Py {
  public func newTypeError(message: String) -> PyTypeError
  public func newInvalidSelfArgumentError(object: PyObject, expectedType expected: String, fnName: String) -> PyTypeError
  public func newValueError(message: String) -> PyValueError
  public func newIndexError(message: String) -> PyIndexError
  public func newAttributeError(message: String) -> PyAttributeError
  public func newAttributeError(object: PyObject, hasNoAttribute name: PyString) -> PyAttributeError
  public func newAttributeError(object: PyObject, hasNoAttribute name: String) -> PyAttributeError
  public func newAttributeError(object: PyObject, attributeIsReadOnly name: PyString) -> PyAttributeError
  public func newAttributeError(object: PyObject, attributeIsReadOnly name: String) -> PyAttributeError
  public func newZeroDivisionError(message: String) -> PyZeroDivisionError
  public func newOverflowError(message: String) -> PyOverflowError
  public func newSystemError(message: String) -> PySystemError
  public func newSystemExit(code: PyObject?) -> PySystemExit
  public func newRuntimeError(message: String) -> PyRuntimeError
  public func newOSError(message: String) -> PyOSError
  public func newOSError(errno: Int32) -> PyOSError
  public func newOSError(errno: Int32, filename: Filename) -> PyOSError
  public func newOSError(errno: Int32, filename: String) -> PyOSError
  public func newOSError(errno: Int32, path: Path) -> PyOSError
  public func newOSError(errno: Int32, path: String) -> PyOSError
  public func newFileNotFoundError(path: Path?) -> PyFileNotFoundError
  public func newFileNotFoundError(path: String?) -> PyFileNotFoundError
  public func newFileNotFoundError(filename: Filename?) -> PyFileNotFoundError
  public func newFileNotFoundError(filename: String?) -> PyFileNotFoundError
  public func newKeyError(message: String) -> PyKeyError
  public func newKeyError(key: PyObject) -> PyKeyError
  public func newLookupError(message: String) -> PyLookupError
  public func newStopIteration(value: PyObject?) -> PyStopIteration
  public func newNameError(message: String) -> PyNameError
  public func newUnboundLocalError(variableName: String) -> PyUnboundLocalError
  public func newUnicodeDecodeError(data: Data, encoding: PyString.Encoding) -> PyUnicodeDecodeError
  public func newUnicodeEncodeError(string: String, encoding: PyString.Encoding) -> PyUnicodeEncodeError
  public func newUnicodeEncodeError(string: PyString, encoding: PyString.Encoding) -> PyUnicodeEncodeError
  public func newAssertionError(message: String) -> PyAssertionError
  public func newImportError(message: String, moduleName: String?, modulePath: Path?) -> PyImportError
  public func newImportError(message: String, moduleName: String? = nil, modulePath: String? = nil) -> PyImportError
  public func newEOFError(message: String) -> PyEOFError
  public func newSyntaxError(message: String?, filename: String?, lineno: BigInt?, offset: BigInt?, text: String?, printFileAndLine: Bool?) -> PySyntaxError
  public func newSyntaxError(message: PyString?, filename: PyString?, lineno: PyInt?, offset: PyInt?, text: PyString?, printFileAndLine: PyBool?) -> PySyntaxError
  public func newIndentationError(message: String?, filename: String?, lineno: BigInt?, offset: BigInt?, text: String?, printFileAndLine: Bool?) -> PyIndentationError
  public func newIndentationError(message: PyString?, filename: PyString?, lineno: PyInt?, offset: PyInt?, text: PyString?, printFileAndLine: PyBool?) -> PyIndentationError
  public func newKeyboardInterrupt() -> PyKeyboardInterrupt
  public func newRecursionError() -> PyRecursionError
  public func newException(type: PyType, arg: PyObject?) -> PyResultGen<PyBaseException>
}

==================================
=== Py+Thingies/Py+Error.swift ===
==================================

extension Py {
  public func exceptionMatches(exception: PyObject, expectedType: PyObject) -> Bool
  public func isException(object: PyObject) -> Bool
  public func isException(type: PyType) -> Bool
  public func getArgs(exception: PyBaseException) -> PyTuple
  public func setArgs(exception: PyBaseException, args: PyTuple)
  public func getCause(exception: PyBaseException) -> PyBaseException?
  public func setCause(exception: PyBaseException, cause: PyBaseException)
  public func getContext(exception: PyBaseException) -> PyBaseException?
  public func setContextUsingCurrentlyHandledExceptionFromDelegate(on exception: PyBaseException, overrideCurrent: Bool)
  public func newTraceback(frame: PyFrame, exception: PyBaseException?) -> PyTraceback
  public func newTraceback(frame: PyFrame, next: PyTraceback?) -> PyTraceback
  public func getTraceback(exception: PyBaseException) -> PyTraceback?
  public func addTraceback(to exception: PyBaseException, frame: PyFrame)
  public func getFrame(traceback: PyTraceback) -> PyFrame
}

======================================
=== Py+Thingies/Py+Exec+Eval.swift ===
======================================

extension Py {
  public func exec(source: PyObject, globals: PyObject?, locals: PyObject?) -> PyBaseException?
  public func eval(source: PyObject, globals: PyObject?, locals: PyObject?) -> PyResult
}

=================================
=== Py+Thingies/Py+Hash.swift ===
=================================

extension Py {
  public func hash(object: PyObject) -> PyResultGen<PyHash>
}

===================================
=== Py+Thingies/Py+Import.swift ===
===================================

extension Py {
  public func get__import__() -> PyResult
  public func __import__(name nameArg: PyObject, globals: PyObject? = nil, locals: PyObject? = nil, fromList: PyObject? = nil, level levelArg: PyObject? = nil) -> PyResult
}

======================================
=== Py+Thingies/Py+Importlib.swift ===
======================================

extension Py {
  public func getImportlib() -> PyResultGen<PyModule>
  public func initImportlibIfNeeded() -> PyResultGen<PyModule>
  public func getImportlibExternal() -> PyResultGen<PyModule>
  public func getImportlibExternal(importlib: PyModule) -> PyResultGen<PyModule>
  public func initImportlibExternalIfNeeded(importlib: PyModule) -> PyResultGen<PyModule>
}

===========================================
=== Py+Thingies/Py+Locals+Globals.swift ===
===========================================

extension Py {
  public func globals() -> PyResultGen<PyDict>
  public func locals() -> PyResultGen<PyDict>
}

======================================
=== Py+Thingies/Py+Next+Iter.swift ===
======================================

extension Py {
  public func next(iterator: PyObject, default: PyObject? = nil) -> PyResult
  public func iter(object: PyObject) -> PyResult
  public func iter(object: PyObject, sentinel: PyObject?) -> PyResult
  public func hasIter(object: PyObject) -> Bool
}

====================================
=== Py+Thingies/Py+Numeric.swift ===
====================================

extension Py {
  public func newInt<I: BinaryInteger>(_ value: I) -> PyInt
  public func newInt(_ value: Int) -> PyInt
  public func newInt(_ value: BigInt) -> PyInt
  public func newInt(double value: Double) -> PyResultGen<PyInt>
  public func newFloat(_ value: Double) -> PyFloat
  public func newComplex(real: Double, imag: Double) -> PyComplex
  public func round(number: PyObject, nDigits: PyObject? = nil) -> PyResult
}

==========================================
=== Py+Thingies/Py+NumericBinary.swift ===
==========================================

extension Py {
  public func add(left: PyObject, right: PyObject) -> PyResult
  public func addInPlace(left: PyObject, right: PyObject) -> PyResult
}

extension Py {
  public func sub(left: PyObject, right: PyObject) -> PyResult
  public func subInPlace(left: PyObject, right: PyObject) -> PyResult
}

extension Py {
  public func mul(left: PyObject, right: PyObject) -> PyResult
  public func mulInPlace(left: PyObject, right: PyObject) -> PyResult
}

extension Py {
  public func matmul(left: PyObject, right: PyObject) -> PyResult
  public func matmulInPlace(left: PyObject, right: PyObject) -> PyResult
}

extension Py {
  public func trueDiv(left: PyObject, right: PyObject) -> PyResult
  public func trueDivInPlace(left: PyObject, right: PyObject) -> PyResult
}

extension Py {
  public func floorDiv(left: PyObject, right: PyObject) -> PyResult
  public func floorDivInPlace(left: PyObject, right: PyObject) -> PyResult
}

extension Py {
  public func mod(left: PyObject, right: PyObject) -> PyResult
  public func modInPlace(left: PyObject, right: PyObject) -> PyResult
}

extension Py {
  public func divMod(left: PyObject, right: PyObject) -> PyResult
}

extension Py {
  public func lshift(left: PyObject, right: PyObject) -> PyResult
  public func lshiftInPlace(left: PyObject, right: PyObject) -> PyResult
}

extension Py {
  public func rshift(left: PyObject, right: PyObject) -> PyResult
  public func rshiftInPlace(left: PyObject, right: PyObject) -> PyResult
}

extension Py {
  public func and(left: PyObject, right: PyObject) -> PyResult
  public func andInPlace(left: PyObject, right: PyObject) -> PyResult
}

extension Py {
  public func or(left: PyObject, right: PyObject) -> PyResult
  public func orInPlace(left: PyObject, right: PyObject) -> PyResult
}

extension Py {
  public func xor(left: PyObject, right: PyObject) -> PyResult
  public func xorInPlace(left: PyObject, right: PyObject) -> PyResult
}

===========================================
=== Py+Thingies/Py+NumericTernary.swift ===
===========================================

extension Py {
  public func pow(base: PyObject, exp: PyObject, mod: PyObject? = nil) -> PyResult
  public func powInPlace(base: PyObject, exp: PyObject, mod: PyObject? = nil) -> PyResult
}

=========================================
=== Py+Thingies/Py+NumericUnary.swift ===
=========================================

extension Py {
  public func positive(object: PyObject) -> PyResult
  public func negative(object: PyObject) -> PyResult
  public func invert(object: PyObject) -> PyResult
  public func absolute(object: PyObject) -> PyResult
}

=================================
=== Py+Thingies/Py+Open.swift ===
=================================

extension Py {
  public func open(file fileArg: PyObject, mode modeArg: PyObject? = nil, buffering: PyObject? = nil, encoding encodingArg: PyObject? = nil, errors errorsArg: PyObject? = nil, newline: PyObject? = nil, closefd closefdArg: PyObject? = nil, opener: PyObject? = nil) -> PyResultGen<PyTextFile>
  public func newTextFile(name: String?, fd: PyFileDescriptorType, mode: FileMode, encoding: PyString.Encoding, errorHandling: PyString.ErrorHandling, closeOnDealloc: Bool) -> PyTextFile
}

====================================
=== Py+Thingies/Py+Ord+Chr.swift ===
====================================

extension Py {
  public func chr(object: PyObject) -> PyResultGen<PyString>
  public func ord(object: PyObject) -> PyResultGen<PyInt>
}

==================================
=== Py+Thingies/Py+Other.swift ===
==================================

extension Py {
  public func newNamespace() -> PyNamespace
  public func newNamespace(dict: PyDict) -> PyNamespace
  public func get__dict__(object: PyObject) -> PyDict?
  public func get__dict__(type: PyType) -> PyDict
  public func get__dict__(module: PyModule) -> PyDict
  public func get__dict__(error: PyBaseException) -> PyDict
  public func id(object: PyObject) -> PyInt
  public func dir(object: PyObject? = nil) -> PyResult
}

==================================
=== Py+Thingies/Py+Print.swift ===
==================================

extension Py {
  public func print(file: PyObject?, arg: PyObject, end: PyObject? = nil, flush: PyObject? = nil) -> PyBaseException?
  public func print(file: PyObject?, args: [PyObject], separator: PyObject? = nil, end: PyObject? = nil, flush: PyObject? = nil) -> PyBaseException?
  public func print(stream: Sys.OutputStream?, args: [PyObject], separator: PyString? = nil, end: PyString? = nil, flush: PyObject? = nil) -> PyBaseException?
}

=======================================
=== Py+Thingies/Py+PrintError.swift ===
=======================================

extension Py {
  public func print(file: PyTextFile, error: PyBaseException) -> PyBaseException?
  public func printRecursiveIgnoringErrors(file: PyTextFile, error: PyBaseException)
}

===========================================
=== Py+Thingies/Py+PrintTraceback.swift ===
===========================================

extension Py {
  public func print(file: PyTextFile, traceback: PyTraceback) -> PyBaseException?
  public func print(file: PyTextFile, traceback: PyTraceback, limit: Int) -> PyBaseException?
}

===========================================
=== Py+Thingies/Py+Str+Repr+ASCII.swift ===
===========================================

extension Py {
  public func repr(_ object: PyObject) -> PyResultGen<PyString>
  public func reprString(_ object: PyObject) -> PyResultGen<String>
  public func reprOrGeneric(_ object: PyObject) -> PyString
  public func reprOrGenericString(_ object: PyObject) -> String
  public func str(_ object: PyObject) -> PyResultGen<PyString>
  public func strString(_ string: PyString) -> String
  public func strString(_ object: PyObject) -> PyResultGen<String>
  public func ascii(_ object: PyObject) -> PyResultGen<PyString>
  public func asciiString(_ object: PyObject) -> PyResultGen<String>
}

===================================
=== Py+Thingies/Py+String.swift ===
===================================

extension Py {
  public func newString(_ value: String) -> PyString
  public func newString(scalar: UnicodeScalar) -> PyString
  public func newString(_ value: String.UnicodeScalarView) -> PyString
  public func newString(_ value: String.UnicodeScalarView.SubSequence) -> PyString
  public func newString(_ value: CustomStringConvertible) -> PyString
  public func newString(_ value: Path) -> PyString
  public func newStringIterator(string: PyString) -> PyStringIterator
  public func newBytes(_ elements: Data) -> PyBytes
  public func newBytesIterator(bytes: PyBytes) -> PyBytesIterator
  public func newByteArray(_ elements: Data) -> PyByteArray
  public func newByteArrayIterator(bytes: PyByteArray) -> PyByteArrayIterator
  public func join(strings elements: [PyObject], separator: PyObject) -> PyResultGen<PyString>
}

=======================================
=== Py+Thingies/Py+Subscripts.swift ===
=======================================

extension Py {
  public func getItem(object: PyObject, index: Int) -> PyResult
  public func getItem(object: PyObject, index: PyObject) -> PyResult
  public func setItem(object: PyObject, index: PyObject, value: PyObject) -> PyResult
  public func deleteItem(object: PyObject, index: PyObject) -> PyResult
}

=================================
=== Py+Thingies/Py+Type.swift ===
=================================

extension Py {
  public func newType(name: String, qualname: String, flags: PyType.Flags, base: PyType, mro: MethodResolutionOrder, instanceSizeWithoutTail: Int, staticMethods: PyStaticCall.KnownNotOverriddenMethods, debugFn: @escaping PyType.DebugFn, deinitialize: @escaping PyType.DeinitializeFn) -> PyType
  public func getName(type: PyType) -> String
  public enum LookupResult {}
  public func mroLookup(object: PyObject, name: IdString) -> LookupResult
  public func isInstance(object: PyObject, of typeOrTuple: PyObject) -> PyResultGen<Bool>
  public func isSubclass(object: PyObject, of typeOrTuple: PyObject) -> PyResultGen<Bool>
}

====================================
=== Py+Thingies/Py+Warning.swift ===
====================================

extension Py {
  public enum WarningType {}
  public func warnSyntax(filename: String, line: SourceLine, column: SourceColumn, text: String) -> PyBaseException?
  public func warnSyntax(filename: PyString, line: PyInt, column: PyInt, text: PyString) -> PyBaseException?
  public func newSyntaxWarning(filename: String, line: BigInt, column: BigInt, text: String) -> PySyntaxWarning
  public func newSyntaxWarning(filename: PyString, line: PyInt, column: PyInt, text: PyString) -> PySyntaxWarning
  public func warnBytesIfEnabled(message: String) -> PyBaseException?
  public func warn(type: WarningType, message: String) -> PyBaseException?
  public func warn(type: WarningType, message: PyString) -> PyBaseException?
  public func warn(type: PyType, message: String) -> PyBaseException?
  public func warn(type: PyType, message: PyString) -> PyBaseException?
}

================
=== Py.swift ===
================

public struct Py: CustomStringConvertible {
  public var `true`: PyBool { get }
  public var `false`: PyBool { get }
  public var none: PyNone { get }
  public var notImplemented: PyNotImplemented { get }
  public var ellipsis: PyEllipsis { get }
  public var emptyTuple: PyTuple { get }
  public var emptyString: PyString { get }
  public var emptyBytes: PyBytes { get }
  public var emptyFrozenSet: PyFrozenSet { get }
  public var builtins: Builtins { get }
  public var sys: Sys { get }
  public var _imp: UnderscoreImp { get }
  public var _warnings: UnderscoreWarnings { get }
  public var _os: UnderscoreOS { get }
  public var builtinsModule: PyModule { get }
  public var sysModule: PyModule { get }
  public var _impModule: PyModule { get }
  public var _warningsModule: PyModule { get }
  public var _osModule: PyModule { get }
  public var types: Py.Types { get }
  public var errorTypes: Py.ErrorTypes { get }
  public var config: PyConfig { get }
  public var delegate: PyDelegateType { get }
  public var fileSystem: PyFileSystemType { get }
  public var memory: PyMemory { get }
  public var cast: PyCast { get }
  public var description: String { get }
  public let ptr: RawPtr
  public init(config: PyConfig, delegate: PyDelegateType, fileSystem: PyFileSystemType)
  public func destroy()
  public func resolve(id: IdString) -> PyString
  public func getInterned(string: String) -> PyString?
  public func intern(scalar: UnicodeScalar) -> PyString
  public func intern(path: Path) -> PyString
  public func intern(string: String) -> PyString
  public func intern(string: PyString) -> PyString
}

======================
=== PyConfig.swift ===
======================

public struct PyConfig {
  public var hashKey0: UInt64 = 0x5669_6f6c_6574_4576
  public var hashKey1: UInt64 = 0x6572_6761_7264_656e
  public var arguments: Arguments
  public var environment: Environment
  public var executablePath: Path
  public var standardInput: PyFileDescriptorType
  public var standardOutput: PyFileDescriptorType
  public var standardError: PyFileDescriptorType
  public struct Sys {
    public var path: [Path]?
    public var prefix: Path?
  }
  public var sys = Sys()
  public init(arguments: Arguments, environment: Environment, executablePath: Path, standardInput: PyFileDescriptorType, standardOutput: PyFileDescriptorType, standardError: PyFileDescriptorType)
}

============================
=== PyDelegateType.swift ===
============================

public protocol PyDelegateType: AnyObject {}

==============================
=== PyFileSystemType.swift ===
==============================

public enum PyFileSystemStatResult {}
public enum PyFileSystemReaddirResult {}
public protocol PyFileSystemType: AnyObject {}
extension PyFileSystemType {
  public func read(_ py: Py, fd: Int32) -> PyResultGen<Data>
  public func read(_ py: Py, path: Path) -> PyResultGen<Data>
}

============================
=== PyObject+Flags.swift ===
============================

extension PyObject {
  public struct Flags: Equatable, CustomStringConvertible {
    public static let `default` = Flags()
    public init()
    public static let reprLock = Flags(rawValue: 1 << 0)
    public static let descriptionLock = Flags(rawValue: 1 << 1)
    public static let custom0 = Flags(rawValue: 1 << (Self.customStart + 0))
    public static let custom1 = Flags(rawValue: 1 << (Self.customStart + 1))
    public static let custom2 = Flags(rawValue: 1 << (Self.customStart + 2))
    public static let custom3 = Flags(rawValue: 1 << (Self.customStart + 3))
    public static let custom4 = Flags(rawValue: 1 << (Self.customStart + 4))
    public static let custom5 = Flags(rawValue: 1 << (Self.customStart + 5))
    public static let custom6 = Flags(rawValue: 1 << (Self.customStart + 6))
    public static let custom7 = Flags(rawValue: 1 << (Self.customStart + 7))
    public static let custom8 = Flags(rawValue: 1 << (Self.customStart + 8))
    public static let custom9 = Flags(rawValue: 1 << (Self.customStart + 9))
    public static let custom10 = Flags(rawValue: 1 << (Self.customStart + 10))
    public static let custom11 = Flags(rawValue: 1 << (Self.customStart + 11))
    public static let custom12 = Flags(rawValue: 1 << (Self.customStart + 12))
    public static let custom13 = Flags(rawValue: 1 << (Self.customStart + 13))
    public static let custom14 = Flags(rawValue: 1 << (Self.customStart + 14))
    public static let custom15 = Flags(rawValue: 1 << (Self.customStart + 15))
    public static let custom16 = Flags(rawValue: 1 << (Self.customStart + 16))
    public static let custom17 = Flags(rawValue: 1 << (Self.customStart + 17))
    public static let custom18 = Flags(rawValue: 1 << (Self.customStart + 18))
    public static let custom19 = Flags(rawValue: 1 << (Self.customStart + 19))
    public static let custom20 = Flags(rawValue: 1 << (Self.customStart + 20))
    public static let custom21 = Flags(rawValue: 1 << (Self.customStart + 21))
    public static let custom22 = Flags(rawValue: 1 << (Self.customStart + 22))
    public static let custom23 = Flags(rawValue: 1 << (Self.customStart + 23))
    public var description: String { get }
    public func isSet(_ flag: Flags) -> Bool
  }
}

======================
=== PyObject.swift ===
======================

public struct PyObject: PyObjectMixin {
  public var type: PyType { get }
  public var flags: PyObject.Flags { get; nonmutating set }
  public let ptr: RawPtr
  public init(ptr: RawPtr)
  public struct DebugMirror {
    public struct Property {
      public let name: String
      public let value: Any
      public let includeInDescription: Bool
    }
    public let object: PyObject
    public let swiftType: String
    public private(set) var properties = [Property]()
    public init<T: PyObjectMixin>(object: T)
    public mutating func append(name: String, value: Any, includeInDescription: Bool = false)
  }
}

===========================
=== PyObjectMixin.swift ===
===========================

public protocol PyObjectMixin: CustomStringConvertible {}
extension PyObjectMixin {
  public var asObject: PyObject { get }
  public var type: PyType { get }
  public var typeName: String { get }
  public var description: String { get }
}

==========================
=== PyType+Flags.swift ===
==========================

extension PyType {
  public struct Flags: CustomStringConvertible, ExpressibleByArrayLiteral {
    public static let isHeapTypeFlag = Flags(objectFlags: .custom0)
    public static let isBaseTypeFlag = Flags(objectFlags: .custom1)
    public static let hasGCFlag = Flags(objectFlags: .custom2)
    public static let isAbstractFlag = Flags(objectFlags: .custom3)
    public static let hasFinalizeFlag = Flags(objectFlags: .custom4)
    public static let isDefaultFlag = Flags(objectFlags: .custom5)
    public static let isLongSubclassFlag = Flags(objectFlags: .custom8)
    public static let isListSubclassFlag = Flags(objectFlags: .custom9)
    public static let isTupleSubclassFlag = Flags(objectFlags: .custom10)
    public static let isBytesSubclassFlag = Flags(objectFlags: .custom11)
    public static let isUnicodeSubclassFlag = Flags(objectFlags: .custom12)
    public static let isDictSubclassFlag = Flags(objectFlags: .custom13)
    public static let isBaseExceptionSubclassFlag = Flags(objectFlags: .custom14)
    public static let isTypeSubclassFlag = Flags(objectFlags: .custom15)
    public static let instancesHave__dict__Flag = Flags(objectFlags: .custom20)
    public static let subclassInstancesHave__dict__Flag = Flags(objectFlags: .custom21)
    public init()
    public init(objectFlags: PyObject.Flags)
    public init(arrayLiteral elements: PyType.Flags...)
    public var description: String { get }
    public var isHeapType: Bool { get; set }
    public var isBaseType: Bool { get; set }
    public var hasGC: Bool { get; set }
    public var isAbstract: Bool { get; set }
    public var hasFinalize: Bool { get; set }
    public var isDefault: Bool { get; set }
    public var isLongSubclass: Bool { get; set }
    public var isListSubclass: Bool { get; set }
    public var isTupleSubclass: Bool { get; set }
    public var isBytesSubclass: Bool { get; set }
    public var isUnicodeSubclass: Bool { get; set }
    public var isDictSubclass: Bool { get; set }
    public var isBaseExceptionSubclass: Bool { get; set }
    public var isTypeSubclass: Bool { get; set }
    public var instancesHave__dict__: Bool { get; set }
    public var subclassInstancesHave__dict__: Bool { get; set }
  }
}

====================
=== PyType.swift ===
====================

public func ===(lhs: PyType, rhs: PyType) -> Bool
public func !==(lhs: PyType, rhs: PyType) -> Bool
public struct PyType: PyObjectMixin {
  public typealias DebugFn = (RawPtr) -> PyObject.DebugMirror
  public typealias DeinitializeFn = (Py, RawPtr) -> Void
  public let ptr: RawPtr
  public init(ptr: RawPtr)
}

===================================
=== Results/CompareResult.swift ===
===================================

public enum CompareResult {
  public enum Operation: String {}
  public init(_ value: Bool?)
  public init(_ value: PyResultGen<Bool>)
  public var not: CompareResult { get }
}

extension PyResult {
  public init(_ py: Py, _ result: CompareResult)
}

===============================
=== Results/DirResult.swift ===
===============================

public struct DirResult {
  public init()
  public init<S: Sequence>(_ elements: S) where S.Element == PyObject
  public mutating func append(_ element: PyObject)
  public mutating func append<S: Sequence>(contentsOf newElements: S) where S.Element == PyObject
  public mutating func append(contentsOf newElements: DirResult)
  public mutating func append(_ py: Py, keysFrom dict: PyDict) -> PyBaseException?
  public mutating func append(_ py: Py, keysFrom object: PyObject) -> PyBaseException?
  public mutating func append(_ py: Py, elementsFrom iterable: PyObject) -> PyBaseException?
}

extension PyResult {
  public init(_ py: Py, _ dir: DirResult)
  public init(_ py: Py, _ result: PyResultGen<DirResult>)
}

extension PyResultGen where Wrapped == DirResult {
  public static func invalidSelfArgument(_ py: Py, _ zelf: PyObject, _ expectedType: String) -> PyResultGen<DirResult>
}

================================
=== Results/HashResult.swift ===
================================

public enum HashResult {}
extension PyResult {
  public init(_ py: Py, _ result: HashResult)
}

==============================
=== Results/PyResult.swift ===
==============================

public enum PyResult {
  public static func none(_ py: Py) -> PyResult
  public static func notImplemented(_ py: Py) -> PyResult
  public init(_ py: Py, _ value: Bool)
  public init(_ py: Py, _ value: PyResultGen<Bool>)
  public init(_ py: Py, _ value: UInt8)
  public init(_ py: Py, _ value: Int)
  public init(_ py: Py, _ value: PyResultGen<Int>)
  public init(_ py: Py, _ value: BigInt)
  public init(_ py: Py, _ value: PyResultGen<BigInt>)
  public init(_ py: Py, _ value: Double)
  public init(_ py: Py, _ value: PyResultGen<Double>)
  public init(_ py: Py, real: Double, imag: Double)
  public init(_ py: Py, _ value: String)
  public init(_ py: Py, interned value: String)
  public init(_ py: Py, _ value: PyResultGen<String>)
  public init<T: PyObjectMixin>(_ value: T)
  public init<T: PyObjectMixin>(_ value: PyResultGen<T>)
  public init<T: PyObjectMixin>(_ py: Py, _ value: T?)
  public init(_ py: Py, tuple elements: PyObject...)
  public init(_ py: Py, tuple elements: [PyObject])
  public static func typeError(_ py: Py, message: String) -> PyResult
  public static func indexError(_ py: Py, message: String) -> PyResult
  public static func attributeError(_ py: Py, message: String) -> PyResult
  public static func zeroDivisionError(_ py: Py, message: String) -> PyResult
  public static func overflowError(_ py: Py, message: String) -> PyResult
  public static func systemError(_ py: Py, message: String) -> PyResult
  public static func nameError(_ py: Py, message: String) -> PyResult
  public static func keyError(_ py: Py, message: String) -> PyResult
  public static func valueError(_ py: Py, message: String) -> PyResult
  public static func lookupError(_ py: Py, message: String) -> PyResult
  public static func runtimeError(_ py: Py, message: String) -> PyResult
  public static func osError(_ py: Py, message: String) -> PyResult
  public static func assertionError(_ py: Py, message: String) -> PyResult
  public static func eofError(_ py: Py, message: String) -> PyResult
  public static func keyError(_ py: Py, key: PyObject) -> PyResult
  public static func stopIteration(_ py: Py, value: PyObject? = nil) -> PyResult
  public static func unboundLocalError(_ py: Py, variableName: String) -> PyResult
  public static func unicodeDecodeError(_ py: Py, encoding: PyString.Encoding, data: Data) -> PyResult
  public static func unicodeEncodeError(_ py: Py, encoding: PyString.Encoding, string: String) -> PyResult
  public static func importError(_ py: Py, message: String, moduleName: String?, modulePath: Path?) -> PyResult
  public static func importError(_ py: Py, message: String, moduleName: String? = nil, modulePath: String? = nil) -> PyResult
  public func map(_ f: (PyObject) -> PyObject) -> PyResult
  public func map<A>(_ f: (PyObject) -> A) -> PyResultGen<A>
  public func flatMap(_ f: (PyObject) -> PyResult) -> PyResult
  public func flatMap<A>(_ f: (PyObject) -> PyResultGen<A>) -> PyResultGen<A>
}

=================================
=== Results/PyResultGen.swift ===
=================================

public enum PyResultGen<Wrapped> {
  public static func typeError(_ py: Py, message: String) -> PyResultGen<Wrapped>
  public static func indexError(_ py: Py, message: String) -> PyResultGen<Wrapped>
  public static func attributeError(_ py: Py, message: String) -> PyResultGen<Wrapped>
  public static func zeroDivisionError(_ py: Py, message: String) -> PyResultGen<Wrapped>
  public static func overflowError(_ py: Py, message: String) -> PyResultGen<Wrapped>
  public static func systemError(_ py: Py, message: String) -> PyResultGen<Wrapped>
  public static func nameError(_ py: Py, message: String) -> PyResultGen<Wrapped>
  public static func keyError(_ py: Py, message: String) -> PyResultGen<Wrapped>
  public static func valueError(_ py: Py, message: String) -> PyResultGen<Wrapped>
  public static func lookupError(_ py: Py, message: String) -> PyResultGen<Wrapped>
  public static func runtimeError(_ py: Py, message: String) -> PyResultGen<Wrapped>
  public static func osError(_ py: Py, message: String) -> PyResultGen<Wrapped>
  public static func assertionError(_ py: Py, message: String) -> PyResultGen<Wrapped>
  public static func eofError(_ py: Py, message: String) -> PyResultGen<Wrapped>
  public static func keyError(_ py: Py, key: PyObject) -> PyResultGen<Wrapped>
  public static func stopIteration(_ py: Py, value: PyObject? = nil) -> PyResultGen<Wrapped>
  public static func unboundLocalError(_ py: Py, variableName: String) -> PyResultGen<Wrapped>
  public static func unicodeDecodeError(_ py: Py, encoding: PyString.Encoding, data: Data) -> PyResultGen<Wrapped>
  public static func unicodeEncodeError(_ py: Py, encoding: PyString.Encoding, string: String) -> PyResultGen<Wrapped>
  public static func importError(_ py: Py, message: String, moduleName: String?, modulePath: Path?) -> PyResultGen<Wrapped>
  public static func importError(_ py: Py, message: String, moduleName: String? = nil, modulePath: String? = nil) -> PyResultGen<Wrapped>
  public func map<A>(_ f: (Wrapped) -> A) -> PyResultGen<A>
  public func map(_ f: (Wrapped) -> PyObject) -> PyResult
  public func flatMap<A>(_ f: (Wrapped) -> PyResultGen<A>) -> PyResultGen<A>
  public func flatMap(_ f: (Wrapped) -> PyResult) -> PyResult
}

extension PyResultGen where Wrapped == Void {
  public static func value() -> PyResultGen
}

==================================
=== Types - basic/PyBool.swift ===
==================================

public struct PyBool: PyObjectMixin {
  public let ptr: RawPtr
  public init(ptr: RawPtr)
}

=====================================
=== Types - basic/PyComplex.swift ===
=====================================

public struct PyComplex: PyObjectMixin {
  public let ptr: RawPtr
  public init(ptr: RawPtr)
}

======================================
=== Types - basic/PyEllipsis.swift ===
======================================

public struct PyEllipsis: PyObjectMixin {
  public let ptr: RawPtr
  public init(ptr: RawPtr)
}

===================================
=== Types - basic/PyFloat.swift ===
===================================

public struct PyFloat: PyObjectMixin {
  public let ptr: RawPtr
  public init(ptr: RawPtr)
}

=================================
=== Types - basic/PyInt.swift ===
=================================

public struct PyInt: PyObjectMixin {
  public var value: BigInt { get }
  public let ptr: RawPtr
  public init(ptr: RawPtr)
}

=======================================
=== Types - basic/PyNamespace.swift ===
=======================================

public struct PyNamespace: PyObjectMixin {
  public let ptr: RawPtr
  public init(ptr: RawPtr)
}

==================================
=== Types - basic/PyNone.swift ===
==================================

public struct PyNone: PyObjectMixin {
  public let ptr: RawPtr
  public init(ptr: RawPtr)
}

============================================
=== Types - basic/PyNotImplemented.swift ===
============================================

public struct PyNotImplemented: PyObjectMixin {
  public let ptr: RawPtr
  public init(ptr: RawPtr)
}

=================================
=== Types - code/PyCell.swift ===
=================================

public struct PyCell: PyObjectMixin {
  public var content: PyObject? { get; nonmutating set }
  public let ptr: RawPtr
  public init(ptr: RawPtr)
}

=================================
=== Types - code/PyCode.swift ===
=================================

public struct PyCode: PyObjectMixin {
  public typealias CodeObject = VioletBytecode.CodeObject
  public typealias CodeObject = Void
  public var codeObject: PyCode.CodeObject { get }
  public var name: PyString { get }
  public var qualifiedName: PyString { get }
  public var filename: PyString { get }
  public var instructions: [Instruction] { get }
  public var firstLine: SourceLine { get }
  public func getLine(instructionIndex index: Int) -> SourceLine
  public var constants: [PyObject] { get }
  public var labels: [VioletBytecode.CodeObject.Label] { get }
  public var names: [PyString] { get }
  public var variableNames: [MangledName] { get }
  public var variableCount: Int { get }
  public var cellVariableNames: [MangledName] { get }
  public var cellVariableCount: Int { get }
  public var freeVariableNames: [MangledName] { get }
  public var freeVariableCount: Int { get }
  public var argCount: Int { get }
  public var kwOnlyArgCount: Int { get }
  public var predictedObjectStackCount: Int { get; nonmutating set }
  public private(set) var codeFlags: VioletBytecode.CodeObject.Flags { get; nonmutating set }
  public let ptr: RawPtr
  public init(ptr: RawPtr)
}

=============================================
=== Types - code/PyFrame+BlockStack.swift ===
=============================================

extension PyFrame {
  public struct Block: Equatable, CustomStringConvertible {
    public enum Kind: Equatable, CustomStringConvertible {
      public var description: String { get }
    }
    public let kind: Kind
    public let stackCount: Int
    public var isExceptHandler: Bool { get }
    public var description: String { get }
    public init(kind: Kind, stackCount: Int)
  }
  public struct BlockStackProxy {
    public var current: Block? { get }
    public var isEmpty: Bool { get }
    public var count: Int { get }
    public func peek(_ n: Int) -> Block
    public func push(_ block: Block)
    public func pop() -> Block?
  }
}

====================================================
=== Types - code/PyFrame+CellFreeVariables.swift ===
====================================================

extension PyFrame {
  public typealias Cell = PyCell
  public struct CellVariablesProxy {
    public var count: Int { get }
    public func fill(code: PyCode, fastLocals: FastLocalsProxy)
    public subscript(index: Int) -> Cell { get }
  }
  public struct FreeVariablesProxy {
    public var count: Int { get }
    public func fill(_ py: Py, code: PyCode, closure: PyTuple?)
    public subscript(index: Int) -> Cell { get }
  }
}

=============================================
=== Types - code/PyFrame+FastLocals.swift ===
=============================================

extension PyFrame {
  public typealias FastLocal = PyObject?
  public struct FastLocalsProxy {
    public var count: Int { get }
    public func fill(_ py: Py, code: PyCode, args: [PyObject], kwargs: PyDict?, defaults: [PyObject], kwDefaults: PyDict?) -> PyBaseException?
    public subscript(index: Int) -> FastLocal { get; nonmutating set }
  }
}

=============================================
=== Types - code/PyFrame+LocalsDict.swift ===
=============================================

extension PyFrame {
  public func copyFastToLocals(_ py: Py) -> PyBaseException?
  public enum LocalMissingStrategy {}
  public func copyLocalsToFast(_ py: Py, onLocalMissing: LocalMissingStrategy) -> PyBaseException?
}

==============================================
=== Types - code/PyFrame+ObjectStack.swift ===
==============================================

extension PyFrame {
  public struct ObjectStackProxy {
    public var top: PyObject { get; nonmutating set }
    public var second: PyObject { get; nonmutating set }
    public var third: PyObject { get; nonmutating set }
    public var fourth: PyObject { get; nonmutating set }
    public var isEmpty: Bool { get }
    public var count: Int { get }
    public var predictedNextRunCount: Int { get }
    public func peek(_ n: Int) -> PyObject
    public func set(_ n: Int, object: PyObject)
    public func push(_ object: PyObject)
    public func push<C: Collection>(contentsOf objects: C) where C.Element == PyObject
    public func pop() -> PyObject
    public func popElementsInPushOrder(count: Int) -> [PyObject]
    public func pop(untilCount: Int)
  }
}

==================================
=== Types - code/PyFrame.swift ===
==================================

public struct PyFrame: PyObjectMixin {
  public var code: PyCode { get }
  public var parent: PyFrame? { get }
  public var locals: PyDict { get }
  public var globals: PyDict { get }
  public var builtins: PyDict { get }
  public var objectStack: ObjectStackProxy { get }
  public static let maxBlockStackCount = 32
  public var fastLocals: FastLocalsProxy { get }
  public var cellVariables: CellVariablesProxy { get }
  public var freeVariables: FreeVariablesProxy { get }
  public var blockStack: BlockStackProxy { get }
  public var currentInstructionIndex: Int? { get; nonmutating set }
  public var nextInstructionIndex: Int { get; nonmutating set }
  public var currentInstructionLine: SourceLine { get }
  public let ptr: RawPtr
  public init(ptr: RawPtr)
}

===================================
=== Types - code/PyModule.swift ===
===================================

public struct PyModule: PyObjectMixin {
  public let ptr: RawPtr
  public init(ptr: RawPtr)
}

==================================
=== Types - code/PySuper.swift ===
==================================

public struct PySuper: PyObjectMixin {
  public let ptr: RawPtr
  public init(ptr: RawPtr)
}

====================================================
=== Types - collections/PyCallableIterator.swift ===
====================================================

public struct PyCallableIterator: PyObjectMixin {
  public let ptr: RawPtr
  public init(ptr: RawPtr)
}

=============================================
=== Types - collections/PyEnumerate.swift ===
=============================================

public struct PyEnumerate: PyObjectMixin {
  public let ptr: RawPtr
  public init(ptr: RawPtr)
}

==========================================
=== Types - collections/PyFilter.swift ===
==========================================

public struct PyFilter: PyObjectMixin {
  public let ptr: RawPtr
  public init(ptr: RawPtr)
}

============================================
=== Types - collections/PyIterator.swift ===
============================================

public struct PyIterator: PyObjectMixin {
  public let ptr: RawPtr
  public init(ptr: RawPtr)
}

=======================================
=== Types - collections/PyMap.swift ===
=======================================

public struct PyMap: PyObjectMixin {
  public let ptr: RawPtr
  public init(ptr: RawPtr)
}

=========================================
=== Types - collections/PyRange.swift ===
=========================================

public struct PyRange: PyObjectMixin {
  public let ptr: RawPtr
  public init(ptr: RawPtr)
}

=================================================
=== Types - collections/PyRangeIterator.swift ===
=================================================

public struct PyRangeIterator: PyObjectMixin {
  public let ptr: RawPtr
  public init(ptr: RawPtr)
}

============================================
=== Types - collections/PyReversed.swift ===
============================================

public struct PyReversed: PyObjectMixin {
  public let ptr: RawPtr
  public init(ptr: RawPtr)
}

=========================================
=== Types - collections/PySlice.swift ===
=========================================

public struct PySlice: PyObjectMixin {
  public let ptr: RawPtr
  public init(ptr: RawPtr)
}

=======================================
=== Types - collections/PyZip.swift ===
=======================================

public struct PyZip: PyObjectMixin {
  public let ptr: RawPtr
  public init(ptr: RawPtr)
}

==================================================
=== Types - dictionary/OrderedDictionary.swift ===
==================================================

public struct OrderedDictionary<Value> {
  public struct Key: CustomStringConvertible {
    public let hash: PyHash
    public let object: PyObject
    public var description: String { get }
  }
  public struct Entry {
    public let key: Key
    public let value: Value
  }
  public var count: Int { get }
  public var capacity: Int { get }
  public var isEmpty: Bool { get }
  public var any: Bool { get }
  public var last: Entry? { get }
  public init()
  public init(count: Int)
  public init(copy: OrderedDictionary<Value>)
  public enum GetResult {}
  public func get(_ py: Py, key: Key) -> GetResult
  public func contains(_ py: Py, key: Key) -> PyResultGen<Bool>
  public enum InsertResult {}
  public mutating func insert(_ py: Py, key: Key, value: Value) -> InsertResult
  public enum RemoveResult {}
  public mutating func remove(_ py: Py, key: Key) -> RemoveResult
  public func copy() -> OrderedDictionary<Value>
  public mutating func clear()
}

extension OrderedDictionary: CustomStringConvertible {
  public var description: String { get }
}

extension OrderedDictionary.EntryIndex: CustomReflectable {
  public var customMirror: Mirror { get }
}

extension OrderedDictionary.EntryOrDeleted: CustomReflectable {
  public var customMirror: Mirror { get }
}

extension OrderedDictionary: CustomReflectable {
  public var customMirror: Mirror { get }
}

extension OrderedDictionary: Sequence {
  public struct Iterator: IteratorProtocol {
    public typealias OrderedDictionaryType = OrderedDictionary<Value>
    public typealias Element = OrderedDictionaryType.Entry
    public init(_ dictionary: OrderedDictionaryType)
    public mutating func next() -> Element?
  }
  public typealias Element = Iterator.Element
  public func makeIterator() -> Iterator
}

==============================================
=== Types - dictionary/PyDict+Update.swift ===
==============================================

extension PyDict {
  public enum OnUpdateKeyDuplicate {}
  public func update(_ py: Py, from object: PyObject, onKeyDuplicate: OnUpdateKeyDuplicate) -> PyBaseException?
}

=======================================
=== Types - dictionary/PyDict.swift ===
=======================================

public struct PyDict: PyObjectMixin {
  public typealias OrderedDictionary = VioletObjects.OrderedDictionary<PyObject>
  public typealias Key = OrderedDictionary.Key
  public let ptr: RawPtr
  public init(ptr: RawPtr)
  public enum GetResult {}
  public func get(_ py: Py, id: IdString) -> PyObject?
  public func get(_ py: Py, key: PyString) -> GetResult
  public func get(_ py: Py, key: PyObject) -> GetResult
  public enum SetResult {}
  public func set(_ py: Py, id: IdString, value: PyObject)
  public func set(_ py: Py, key: PyString, value: PyObject) -> SetResult
  public func set(_ py: Py, key: PyObject, value: PyObject) -> SetResult
  public enum DelResult {}
  public func del(_ py: Py, id: IdString) -> PyObject?
  public func del(_ py: Py, key: PyString) -> DelResult
  public func del(_ py: Py, key: PyObject) -> DelResult
}

===================================================
=== Types - dictionary/PyDictItemIterator.swift ===
===================================================

public struct PyDictItemIterator: PyObjectMixin, AbstractDictViewIterator {
  public let ptr: RawPtr
  public init(ptr: RawPtr)
}

============================================
=== Types - dictionary/PyDictItems.swift ===
============================================

public struct PyDictItems: PyObjectMixin, AbstractDictView {
  public let ptr: RawPtr
  public init(ptr: RawPtr)
}

==================================================
=== Types - dictionary/PyDictKeyIterator.swift ===
==================================================

public struct PyDictKeyIterator: PyObjectMixin, AbstractDictViewIterator {
  public let ptr: RawPtr
  public init(ptr: RawPtr)
}

===========================================
=== Types - dictionary/PyDictKeys.swift ===
===========================================

public struct PyDictKeys: PyObjectMixin, AbstractDictView {
  public let ptr: RawPtr
  public init(ptr: RawPtr)
}

====================================================
=== Types - dictionary/PyDictValueIterator.swift ===
====================================================

public struct PyDictValueIterator: PyObjectMixin, AbstractDictViewIterator {
  public let ptr: RawPtr
  public init(ptr: RawPtr)
}

=============================================
=== Types - dictionary/PyDictValues.swift ===
=============================================

public struct PyDictValues: PyObjectMixin, AbstractDictView {
  public let ptr: RawPtr
  public init(ptr: RawPtr)
}

============================================
=== Types - errors/PyBaseException.swift ===
============================================

public func ===(lhs: PyBaseException, rhs: PyBaseException) -> Bool
public func !==(lhs: PyBaseException, rhs: PyBaseException) -> Bool
public struct PyBaseException: PyErrorMixin {
  public static let defaultSuppressContext = false
  public let ptr: RawPtr
  public init(ptr: RawPtr)
}

=========================================
=== Types - errors/PyErrorMixin.swift ===
=========================================

public protocol PyErrorMixin: PyObjectMixin {}
extension PyErrorMixin {
  public var asBaseException: PyBaseException { get }
}

==========================================
=== Types - errors/PyImportError.swift ===
==========================================

public struct PyImportError: PyErrorMixin {
  public let ptr: RawPtr
  public init(ptr: RawPtr)
}

=======================================
=== Types - errors/PyKeyError.swift ===
=======================================

public struct PyKeyError: PyErrorMixin {
  public let ptr: RawPtr
  public init(ptr: RawPtr)
}

============================================
=== Types - errors/PyStopIteration.swift ===
============================================

public struct PyStopIteration: PyErrorMixin {
  public let ptr: RawPtr
  public init(ptr: RawPtr)
}

==========================================
=== Types - errors/PySyntaxError.swift ===
==========================================

public struct PySyntaxError: PyErrorMixin {
  public let ptr: RawPtr
  public init(ptr: RawPtr)
}

=========================================
=== Types - errors/PySystemExit.swift ===
=========================================

public struct PySystemExit: PyErrorMixin {
  public let ptr: RawPtr
  public init(ptr: RawPtr)
}

========================================
=== Types - errors/PyTraceback.swift ===
========================================

public struct PyTraceback: PyObjectMixin {
  public let ptr: RawPtr
  public init(ptr: RawPtr)
}

===================================================================
=== Types - functions/Helpers/FunctionWrapper+HandWritten.swift ===
===================================================================

extension FunctionWrapper {
  public typealias NewFn = (Py, PyType, [PyObject], PyDict?) -> PyResult
  public init(type: PyType, fn: @escaping NewFn)
  public typealias InitFn = (Py, PyObject, [PyObject], PyDict?) -> PyResult
  public init(type: PyType, fn: @escaping InitFn)
  public typealias CompareFn = (Py, PyObject, PyObject) -> CompareResult
  public init(name: String, fn: @escaping CompareFn)
  public typealias HashFn = (Py, PyObject) -> HashResult
  public init(name: String, fn: @escaping HashFn)
  public typealias DirFn = (Py, PyObject) -> PyResultGen<DirResult>
  public init(name: String, fn: @escaping DirFn)
  public typealias ClassFn = (Py, PyObject) -> PyType
  public init(name: String, fn: @escaping ClassFn)
  public typealias ArgsKwargsFunction = (Py, [PyObject], PyDict?) -> PyResult
  public init(name: String, fn: @escaping ArgsKwargsFunction)
  public typealias ArgsKwargsMethod = (Py, PyObject, [PyObject], PyDict?) -> PyResult
  public init(name: String, fn: @escaping ArgsKwargsMethod)
  public typealias ArgsKwargsClassMethod = (Py, PyType, [PyObject], PyDict?) -> PyResult
  public init(name: String, fn: @escaping ArgsKwargsClassMethod)
}

=================================================
=== Types - functions/PyBuiltinFunction.swift ===
=================================================

public struct PyBuiltinFunction: PyObjectMixin, AbstractBuiltinFunction {
  public let ptr: RawPtr
  public init(ptr: RawPtr)
}

===============================================
=== Types - functions/PyBuiltinMethod.swift ===
===============================================

public struct PyBuiltinMethod: PyObjectMixin, AbstractBuiltinFunction {
  public let ptr: RawPtr
  public init(ptr: RawPtr)
}

=============================================
=== Types - functions/PyClassMethod.swift ===
=============================================

public struct PyClassMethod: PyObjectMixin {
  public let ptr: RawPtr
  public init(ptr: RawPtr)
}

==========================================
=== Types - functions/PyFunction.swift ===
==========================================

public struct PyFunction: PyObjectMixin {
  public let ptr: RawPtr
  public init(ptr: RawPtr)
}

========================================
=== Types - functions/PyMethod.swift ===
========================================

public struct PyMethod: PyObjectMixin {
  public let ptr: RawPtr
  public init(ptr: RawPtr)
}

==========================================
=== Types - functions/PyProperty.swift ===
==========================================

public struct PyProperty: PyObjectMixin {
  public let ptr: RawPtr
  public init(ptr: RawPtr)
}

==============================================
=== Types - functions/PyStaticMethod.swift ===
==============================================

public struct PyStaticMethod: PyObjectMixin {
  public let ptr: RawPtr
  public init(ptr: RawPtr)
}

=================================
=== Types - io/FileMode.swift ===
=================================

public enum FileMode: CustomStringConvertible {
  public var description: String { get }
}

=============================================
=== Types - io/PyFileDescriptorType.swift ===
=============================================

public protocol PyFileDescriptorType {}

===================================
=== Types - io/PyTextFile.swift ===
===================================

public struct PyTextFile: PyObjectMixin {
  public let ptr: RawPtr
  public init(ptr: RawPtr)
  public var isReadable: Bool { get }
  public func readLine(_ py: Py) -> PyResultGen<String>
  public func read(_ py: Py, size: Int) -> PyResultGen<PyString>
  public var isWritable: Bool { get }
  public func write(_ py: Py, object: PyObject) -> PyBaseException?
  public func write(_ py: Py, string: String) -> PyBaseException?
  public func flush(_ py: Py) -> PyBaseException?
  public var isClosed: Bool { get }
  public func close(_ py: Py) -> PyBaseException?
}

=========================================
=== Types - list & tuple/PyList.swift ===
=========================================

public struct PyList: PyObjectMixin, AbstractSequence {
  public let ptr: RawPtr
  public init(ptr: RawPtr)
}

=================================================
=== Types - list & tuple/PyListIterator.swift ===
=================================================

public struct PyListIterator: PyObjectMixin {
  public let ptr: RawPtr
  public init(ptr: RawPtr)
}

========================================================
=== Types - list & tuple/PyListReverseIterator.swift ===
========================================================

public struct PyListReverseIterator: PyObjectMixin {
  public let ptr: RawPtr
  public init(ptr: RawPtr)
}

==========================================
=== Types - list & tuple/PyTuple.swift ===
==========================================

public struct PyTuple: PyObjectMixin, AbstractSequence {
  public let ptr: RawPtr
  public init(ptr: RawPtr)
}

==================================================
=== Types - list & tuple/PyTupleIterator.swift ===
==================================================

public struct PyTupleIterator: PyObjectMixin {
  public let ptr: RawPtr
  public init(ptr: RawPtr)
}

====================================
=== Types - set/OrderedSet.swift ===
====================================

public struct OrderedSet {
  public typealias Dict = OrderedDictionary<Void>
  public typealias Element = Dict.Key
  public var count: Int { get }
  public var capacity: Int { get }
  public var isEmpty: Bool { get }
  public var any: Bool { get }
  public var last: Element? { get }
  public init()
  public init(count: Int)
  public init(copy: OrderedSet)
  public func contains(_ py: Py, element: Element) -> PyResultGen<Bool>
  public typealias InsertResult = Dict.InsertResult
  public mutating func insert(_ py: Py, element: Element) -> InsertResult
  public enum RemoveResult {}
  public mutating func remove(_ py: Py, element: Element) -> RemoveResult
  public func copy() -> OrderedSet
  public mutating func clear()
}

extension OrderedSet: CustomStringConvertible {
  public var description: String { get }
}

extension OrderedSet: Sequence {
  public struct Iterator: IteratorProtocol {
    public init(_ set: OrderedSet)
    public mutating func next() -> Element?
  }
  public func makeIterator() -> Iterator
}

=====================================
=== Types - set/PyFrozenSet.swift ===
=====================================

public struct PyFrozenSet: PyObjectMixin, AbstractSet {
  public let ptr: RawPtr
  public init(ptr: RawPtr)
}

===============================
=== Types - set/PySet.swift ===
===============================

public struct PySet: PyObjectMixin, AbstractSet {
  public let ptr: RawPtr
  public init(ptr: RawPtr)
}

=======================================
=== Types - set/PySetIterator.swift ===
=======================================

public struct PySetIterator: PyObjectMixin {
  public let ptr: RawPtr
  public init(ptr: RawPtr)
}

========================================
=== Types - string/PyByteArray.swift ===
========================================

public struct PyByteArray: PyObjectMixin, AbstractBytes {
  public let ptr: RawPtr
  public init(ptr: RawPtr)
}

================================================
=== Types - string/PyByteArrayIterator.swift ===
================================================

public struct PyByteArrayIterator: PyObjectMixin {
  public let ptr: RawPtr
  public init(ptr: RawPtr)
}

====================================
=== Types - string/PyBytes.swift ===
====================================

public struct PyBytes: PyObjectMixin, AbstractBytes {
  public let ptr: RawPtr
  public init(ptr: RawPtr)
}

============================================
=== Types - string/PyBytesIterator.swift ===
============================================

public struct PyBytesIterator: PyObjectMixin {
  public let ptr: RawPtr
  public init(ptr: RawPtr)
}

==============================================
=== Types - string/PyString+Encoding.swift ===
==============================================

extension PyString {
  public enum Encoding: CustomStringConvertible {
    public var description: String { get }
  }
}

===================================================
=== Types - string/PyString+ErrorHandling.swift ===
===================================================

extension PyString {
  public enum ErrorHandling {}
}

=====================================
=== Types - string/PyString.swift ===
=====================================

public struct PyString: PyObjectMixin, AbstractString {
  public let ptr: RawPtr
  public init(ptr: RawPtr)
}

=============================================
=== Types - string/PyStringIterator.swift ===
=============================================

public struct PyStringIterator: PyObjectMixin {
  public let ptr: RawPtr
  public init(ptr: RawPtr)
}

