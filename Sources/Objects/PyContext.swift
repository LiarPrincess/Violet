public class PyContext {

  public var `true`:  PyObject { return self.types.bool.true }
  public var `false`: PyObject { return self.types.bool.false }

  public var none: PyObject { return self.types.none.value }
  public var ellipsis: PyObject { return self.types.ellipsis.value }
  public var emptyTuple: PyObject { return self.types.tuple.empty }
  public var notImplemented: PyObject { return self.types.notImplemented.value }

  internal lazy var types = PyContextTypes(context: self)
  internal lazy var errorTypes = PyContextErrorTypes(context: self)
  internal lazy var warningTypes = PyContextWarningTypes(context: self)

  internal let hasher = Hasher()

  public init() { }
}

// MARK: - Types

internal final class PyContextTypes {

  internal lazy var none = PyNoneType(context: self.context)
  internal lazy var notImplemented = PyNotImplementedType(context: self.context)

  internal lazy var int   = PyIntType(context: self.context)
  internal lazy var float = PyFloatType(context: self.context)
  internal lazy var bool  = PyBoolType(context: self.context)

  internal lazy var tuple = PyTupleType(context: self.context)
  internal lazy var list  = PyListType(context: self.context)

  internal lazy var slice = PySliceType(context: self.context)
  internal lazy var ellipsis = PyEllipsisType(context: self.context)

  internal lazy var unicode = PyUnicodeType()

  private unowned let context: PyContext

  fileprivate init(context: PyContext) {
    self.context = context
  }
}

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
