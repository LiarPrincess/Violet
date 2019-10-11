public class PyContext {

  // Internal typed values
  internal lazy var _true  = PyBool(self, value: true)
  internal lazy var _false = PyBool(self, value: false)
  internal lazy var _none  = PyNone(self)
  internal lazy var _ellipsis = PyEllipsis(self)
  internal lazy var _notImplemented = PyNotImplemented(self)
  internal lazy var _emptyTuple = PyTuple(self, elements: [])

  // Public PyObject values
  public var `true`:   PyObject { return self._true }
  public var `false`:  PyObject { return self._false }
  public var none:     PyObject { return self._none }
  public var ellipsis: PyObject { return self._ellipsis }
  public var notImplemented: PyObject { return self._notImplemented }
  public var emptyTuple: PyObject { return self._emptyTuple }

  internal lazy var types = PyContextTypes(context: self)
//  internal lazy var errorTypes = PyContextErrorTypes(context: self)
//  internal lazy var warningTypes = PyContextWarningTypes(context: self)

  internal let hasher = Hasher()

  public init() { }
}

// MARK: - Types

internal final class PyContextTypes {

  /// Root of the type hierarchy
  internal let object: PyType
  /// Type which is set as `type` on all of the `PyType` objects
  internal let type: PyType

  internal let none: PyType
  internal let ellipsis: PyType
  internal let notImplemented: PyType

  internal let int: PyType
  internal let float: PyType
  internal let bool: PyType
  internal let complex: PyType

  internal let tuple: PyType
  internal let list: PyType
  internal let set: PyType
  internal let dict: PyType

  internal let slice: PyType
  internal let range: PyType
  internal let enumerate: PyType
  internal let string: PyType

  fileprivate init(context: PyContext) {
    // 1. `type` inherits from `object`
    // 2. both `type` and `object are instances of `type`.
    // to produce this circular dependency, we need to do small hack.
    // (and yes, this will never get dropped. TODO?)

    self.object = PyType.createTypeWithoutTypeProperty(context, name: "object", base: nil)
    self.type   = PyType.createTypeWithoutTypeProperty(context, name: "type",   base: nil)

    self.none     = PyType(context, name: "none",     type: self.type, base: self.object)
    self.ellipsis = PyType(context, name: "ellipsis", type: self.type, base: self.object)
    self.notImplemented =
      PyType(context, name: "notImplemented", type: self.type, base: self.object)

    self.int     = PyType(context, name: "int",     type: self.type, base: self.object)
    self.float   = PyType(context, name: "float",   type: self.type, base: self.object)
    self.bool    = PyType(context, name: "bool",    type: self.type, base: self.int)
    self.complex = PyType(context, name: "complex", type: self.type, base: self.object)

    self.tuple = PyType(context, name: "tuple", type: self.type, base: self.object)
    self.list  = PyType(context, name: "list",  type: self.type, base: self.object)
    self.set   = PyType(context, name: "set",   type: self.type, base: self.object)
    self.dict  = PyType(context, name: "dict",  type: self.type, base: self.object)

    self.slice = PyType(context, name: "slice", type: self.type, base: self.object)
    self.range = PyType(context, name: "range", type: self.type, base: self.object)
    self.enumerate = PyType(context, name: "enumerate", type: self.type, base: self.object)
    self.string = PyType(context, name: "string", type: self.type, base: self.object)

    PyType.setTypeProperty(type: self.object, setting: self.type)
    PyType.setTypeProperty(type: self.type, setting: self.type)
  }
}
/*
internal final class PyContextErrorTypes {

  internal lazy var base = PyBaseExceptionType(context: self.context)
  internal lazy var systemExit = PySystemExitType(context: self.context)
  internal lazy var keyboardInterrupt =
    PyKeyboardInterruptType(context: self.context)
  internal lazy var generatorExit = PyGeneratorExitType(context: self.context)
  internal lazy var exception = PyExceptionType(context: self.context)
  internal lazy var stopIteration = PyStopIterationType(context: self.context)
  internal lazy var stopAsyncIteration =
    PyStopAsyncIterationType(context: self.context)
  internal lazy var arithmetic = PyArithmeticErrorType(context: self.context)
  internal lazy var floatingPoint =
    PyFloatingPointErrorType(context: self.context)
  internal lazy var overflow = PyOverflowErrorType(context: self.context)
  internal lazy var zeroDivision = PyZeroDivisionErrorType(context: self.context)
  internal lazy var assertion = PyAssertionErrorType(context: self.context)
  internal lazy var attribute = PyAttributeErrorType(context: self.context)
  internal lazy var buffer = PyBufferErrorType(context: self.context)
  internal lazy var eof = PyEOFErrorType(context: self.context)
  internal lazy var `import` = PyImportErrorType(context: self.context)
  internal lazy var moduleNotFound =
    PyModuleNotFoundErrorType(context: self.context)
  internal lazy var lookup = PyLookupErrorType(context: self.context)
  internal lazy var index = PyIndexErrorType(context: self.context)
  internal lazy var key = PyKeyErrorType(context: self.context)
  internal lazy var name = PyNameErrorType(context: self.context)
  internal lazy var unboundLocal = PyUnboundLocalErrorType(context: self.context)
//  internal lazy var os = PyOSErrorType(context: self.context)
//  internal lazy var blockingIO = PyBlockingIOErrorType(context: self.context)
//  internal lazy var childProcess = PyChildProcessErrorType(context: self.context)
//  internal lazy var connection = PyConnectionErrorType(context: self.context)
//  internal lazy var brokenPipe = PyBrokenPipeErrorType(context: self.context)
//  internal lazy var connectionAborted = PyConnectionAbortedErrorType(context: self.context)
//  internal lazy var connectionRefused = PyConnectionRefusedErrorType(context: self.context)
//  internal lazy var connectionReset = PyConnectionResetErrorType(context: self.context)
//  internal lazy var fileExists = PyFileExistsErrorType(context: self.context)
//  internal lazy var fileNotFound = PyFileNotFoundErrorType(context: self.context)
//  internal lazy var interrupted = PyInterruptedErrorType(context: self.context)
//  internal lazy var isADirectory = PyIsADirectoryErrorType(context: self.context)
//  internal lazy var notADirectory = PyNotADirectoryErrorType(context: self.context)
//  internal lazy var permission = PyPermissionErrorType(context: self.context)
//  internal lazy var processLookup = PyProcessLookupErrorType(context: self.context)
//  internal lazy var timeout = PyTimeoutErrorType(context: self.context)
  internal lazy var reference = PyReferenceErrorType(context: self.context)
  internal lazy var runtime = PyRuntimeErrorType(context: self.context)
  internal lazy var notImplemented = PyNotImplementedErrorType(context: self.context)
  internal lazy var recursion = PyRecursionErrorType(context: self.context)
  internal lazy var syntax = PySyntaxErrorType(context: self.context)
  internal lazy var indentation = PyIndentationErrorType(context: self.context)
  internal lazy var tab = PyTabErrorType(context: self.context)
  internal lazy var system = PySystemErrorType(context: self.context)
  internal lazy var type = PyTypeErrorType(context: self.context)
//  internal lazy var value = PyValueErrorType(context: self.context)
//  internal lazy var unicode = PyUnicodeErrorType(context: self.context)
//  internal lazy var unicodeDecode = PyUnicodeDecodeErrorType(context: self.context)
//  internal lazy var unicodeEncode = PyUnicodeEncodeErrorType(context: self.context)
//  internal lazy var unicodeTranslate = PyUnicodeTranslateErrorType(context: self.context)

  private unowned let context: PyContext

  fileprivate init(context: PyContext) {
    self.context = context
  }
}

internal final class PyContextWarningTypes {

  internal lazy var base = PyWarningType(context: self.context)
  internal lazy var userWarning = PyUserWarningType(context: self.context)
  internal lazy var deprecationWarning =
    PyDeprecationWarningType(context: self.context)
  internal lazy var pendingDeprecationWarning =
    PyPendingDeprecationWarningType(context: self.context)
  internal lazy var syntaxWarning = PySyntaxWarningType(context: self.context)
  internal lazy var runtimeWarning = PyRuntimeWarningType(context: self.context)
  internal lazy var futureWarning = PyFutureWarningType(context: self.context)
  internal lazy var importWarning = PyImportWarningType(context: self.context)
  internal lazy var unicodeWarning = PyUnicodeWarningType(context: self.context)
  internal lazy var bytesWarning = PyBytesWarningType(context: self.context)
  internal lazy var resourceWarning = PyResourceWarningType(context: self.context)

  private unowned let context: PyContext

  fileprivate init(context: PyContext) {
    self.context = context
  }
}
*/
