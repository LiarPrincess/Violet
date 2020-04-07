// swiftlint:disable line_length
// swiftlint:disable function_body_length
// swiftlint:disable trailing_comma

// Please note that this file was automatically generated. DO NOT EDIT!
// The same goes for other files in 'Generated' directory.

// In CPython:
// Objects -> exceptions.c
// Lib->test->exception_hierarchy.txt <-- this is amazing
// https://docs.python.org/3.7/library/exceptions.html
// https://docs.python.org/3.7/c-api/exceptions.html


public final class BuiltinErrorTypes {
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

  /// Init that will only initialize properties.
  internal init() {
    let types = Py.types
    self.baseException = PyType.initBuiltinType(name: "BaseException", type: types.type, base: types.object)
    self.systemExit = PyType.initBuiltinType(name: "SystemExit", type: types.type, base: self.baseException)
    self.keyboardInterrupt = PyType.initBuiltinType(name: "KeyboardInterrupt", type: types.type, base: self.baseException)
    self.generatorExit = PyType.initBuiltinType(name: "GeneratorExit", type: types.type, base: self.baseException)
    self.exception = PyType.initBuiltinType(name: "Exception", type: types.type, base: self.baseException)
    self.stopIteration = PyType.initBuiltinType(name: "StopIteration", type: types.type, base: self.exception)
    self.stopAsyncIteration = PyType.initBuiltinType(name: "StopAsyncIteration", type: types.type, base: self.exception)
    self.arithmeticError = PyType.initBuiltinType(name: "ArithmeticError", type: types.type, base: self.exception)
    self.floatingPointError = PyType.initBuiltinType(name: "FloatingPointError", type: types.type, base: self.arithmeticError)
    self.overflowError = PyType.initBuiltinType(name: "OverflowError", type: types.type, base: self.arithmeticError)
    self.zeroDivisionError = PyType.initBuiltinType(name: "ZeroDivisionError", type: types.type, base: self.arithmeticError)
    self.assertionError = PyType.initBuiltinType(name: "AssertionError", type: types.type, base: self.exception)
    self.attributeError = PyType.initBuiltinType(name: "AttributeError", type: types.type, base: self.exception)
    self.bufferError = PyType.initBuiltinType(name: "BufferError", type: types.type, base: self.exception)
    self.eofError = PyType.initBuiltinType(name: "EOFError", type: types.type, base: self.exception)
    self.importError = PyType.initBuiltinType(name: "ImportError", type: types.type, base: self.exception)
    self.moduleNotFoundError = PyType.initBuiltinType(name: "ModuleNotFoundError", type: types.type, base: self.importError)
    self.lookupError = PyType.initBuiltinType(name: "LookupError", type: types.type, base: self.exception)
    self.indexError = PyType.initBuiltinType(name: "IndexError", type: types.type, base: self.lookupError)
    self.keyError = PyType.initBuiltinType(name: "KeyError", type: types.type, base: self.lookupError)
    self.memoryError = PyType.initBuiltinType(name: "MemoryError", type: types.type, base: self.exception)
    self.nameError = PyType.initBuiltinType(name: "NameError", type: types.type, base: self.exception)
    self.unboundLocalError = PyType.initBuiltinType(name: "UnboundLocalError", type: types.type, base: self.nameError)
    self.osError = PyType.initBuiltinType(name: "OSError", type: types.type, base: self.exception)
    self.blockingIOError = PyType.initBuiltinType(name: "BlockingIOError", type: types.type, base: self.osError)
    self.childProcessError = PyType.initBuiltinType(name: "ChildProcessError", type: types.type, base: self.osError)
    self.connectionError = PyType.initBuiltinType(name: "ConnectionError", type: types.type, base: self.osError)
    self.brokenPipeError = PyType.initBuiltinType(name: "BrokenPipeError", type: types.type, base: self.connectionError)
    self.connectionAbortedError = PyType.initBuiltinType(name: "ConnectionAbortedError", type: types.type, base: self.connectionError)
    self.connectionRefusedError = PyType.initBuiltinType(name: "ConnectionRefusedError", type: types.type, base: self.connectionError)
    self.connectionResetError = PyType.initBuiltinType(name: "ConnectionResetError", type: types.type, base: self.connectionError)
    self.fileExistsError = PyType.initBuiltinType(name: "FileExistsError", type: types.type, base: self.osError)
    self.fileNotFoundError = PyType.initBuiltinType(name: "FileNotFoundError", type: types.type, base: self.osError)
    self.interruptedError = PyType.initBuiltinType(name: "InterruptedError", type: types.type, base: self.osError)
    self.isADirectoryError = PyType.initBuiltinType(name: "IsADirectoryError", type: types.type, base: self.osError)
    self.notADirectoryError = PyType.initBuiltinType(name: "NotADirectoryError", type: types.type, base: self.osError)
    self.permissionError = PyType.initBuiltinType(name: "PermissionError", type: types.type, base: self.osError)
    self.processLookupError = PyType.initBuiltinType(name: "ProcessLookupError", type: types.type, base: self.osError)
    self.timeoutError = PyType.initBuiltinType(name: "TimeoutError", type: types.type, base: self.osError)
    self.referenceError = PyType.initBuiltinType(name: "ReferenceError", type: types.type, base: self.exception)
    self.runtimeError = PyType.initBuiltinType(name: "RuntimeError", type: types.type, base: self.exception)
    self.notImplementedError = PyType.initBuiltinType(name: "NotImplementedError", type: types.type, base: self.runtimeError)
    self.recursionError = PyType.initBuiltinType(name: "RecursionError", type: types.type, base: self.runtimeError)
    self.syntaxError = PyType.initBuiltinType(name: "SyntaxError", type: types.type, base: self.exception)
    self.indentationError = PyType.initBuiltinType(name: "IndentationError", type: types.type, base: self.syntaxError)
    self.tabError = PyType.initBuiltinType(name: "TabError", type: types.type, base: self.indentationError)
    self.systemError = PyType.initBuiltinType(name: "SystemError", type: types.type, base: self.exception)
    self.typeError = PyType.initBuiltinType(name: "TypeError", type: types.type, base: self.exception)
    self.valueError = PyType.initBuiltinType(name: "ValueError", type: types.type, base: self.exception)
    self.unicodeError = PyType.initBuiltinType(name: "UnicodeError", type: types.type, base: self.valueError)
    self.unicodeDecodeError = PyType.initBuiltinType(name: "UnicodeDecodeError", type: types.type, base: self.unicodeError)
    self.unicodeEncodeError = PyType.initBuiltinType(name: "UnicodeEncodeError", type: types.type, base: self.unicodeError)
    self.unicodeTranslateError = PyType.initBuiltinType(name: "UnicodeTranslateError", type: types.type, base: self.unicodeError)
    self.warning = PyType.initBuiltinType(name: "Warning", type: types.type, base: self.exception)
    self.deprecationWarning = PyType.initBuiltinType(name: "DeprecationWarning", type: types.type, base: self.warning)
    self.pendingDeprecationWarning = PyType.initBuiltinType(name: "PendingDeprecationWarning", type: types.type, base: self.warning)
    self.runtimeWarning = PyType.initBuiltinType(name: "RuntimeWarning", type: types.type, base: self.warning)
    self.syntaxWarning = PyType.initBuiltinType(name: "SyntaxWarning", type: types.type, base: self.warning)
    self.userWarning = PyType.initBuiltinType(name: "UserWarning", type: types.type, base: self.warning)
    self.futureWarning = PyType.initBuiltinType(name: "FutureWarning", type: types.type, base: self.warning)
    self.importWarning = PyType.initBuiltinType(name: "ImportWarning", type: types.type, base: self.warning)
    self.unicodeWarning = PyType.initBuiltinType(name: "UnicodeWarning", type: types.type, base: self.warning)
    self.bytesWarning = PyType.initBuiltinType(name: "BytesWarning", type: types.type, base: self.warning)
    self.resourceWarning = PyType.initBuiltinType(name: "ResourceWarning", type: types.type, base: self.warning)
  }

/// This function finalizes init of all of the stored types.
/// (see comment at the top of this file)
///
/// For example it will:
/// - set type flags
/// - add `__doc__`
/// - fill `__dict__`
  internal func fill__dict__() {
    FillTypes.baseException(self.baseException)
    FillTypes.systemExit(self.systemExit)
    FillTypes.keyboardInterrupt(self.keyboardInterrupt)
    FillTypes.generatorExit(self.generatorExit)
    FillTypes.exception(self.exception)
    FillTypes.stopIteration(self.stopIteration)
    FillTypes.stopAsyncIteration(self.stopAsyncIteration)
    FillTypes.arithmeticError(self.arithmeticError)
    FillTypes.floatingPointError(self.floatingPointError)
    FillTypes.overflowError(self.overflowError)
    FillTypes.zeroDivisionError(self.zeroDivisionError)
    FillTypes.assertionError(self.assertionError)
    FillTypes.attributeError(self.attributeError)
    FillTypes.bufferError(self.bufferError)
    FillTypes.eofError(self.eofError)
    FillTypes.importError(self.importError)
    FillTypes.moduleNotFoundError(self.moduleNotFoundError)
    FillTypes.lookupError(self.lookupError)
    FillTypes.indexError(self.indexError)
    FillTypes.keyError(self.keyError)
    FillTypes.memoryError(self.memoryError)
    FillTypes.nameError(self.nameError)
    FillTypes.unboundLocalError(self.unboundLocalError)
    FillTypes.osError(self.osError)
    FillTypes.blockingIOError(self.blockingIOError)
    FillTypes.childProcessError(self.childProcessError)
    FillTypes.connectionError(self.connectionError)
    FillTypes.brokenPipeError(self.brokenPipeError)
    FillTypes.connectionAbortedError(self.connectionAbortedError)
    FillTypes.connectionRefusedError(self.connectionRefusedError)
    FillTypes.connectionResetError(self.connectionResetError)
    FillTypes.fileExistsError(self.fileExistsError)
    FillTypes.fileNotFoundError(self.fileNotFoundError)
    FillTypes.interruptedError(self.interruptedError)
    FillTypes.isADirectoryError(self.isADirectoryError)
    FillTypes.notADirectoryError(self.notADirectoryError)
    FillTypes.permissionError(self.permissionError)
    FillTypes.processLookupError(self.processLookupError)
    FillTypes.timeoutError(self.timeoutError)
    FillTypes.referenceError(self.referenceError)
    FillTypes.runtimeError(self.runtimeError)
    FillTypes.notImplementedError(self.notImplementedError)
    FillTypes.recursionError(self.recursionError)
    FillTypes.syntaxError(self.syntaxError)
    FillTypes.indentationError(self.indentationError)
    FillTypes.tabError(self.tabError)
    FillTypes.systemError(self.systemError)
    FillTypes.typeError(self.typeError)
    FillTypes.valueError(self.valueError)
    FillTypes.unicodeError(self.unicodeError)
    FillTypes.unicodeDecodeError(self.unicodeDecodeError)
    FillTypes.unicodeEncodeError(self.unicodeEncodeError)
    FillTypes.unicodeTranslateError(self.unicodeTranslateError)
    FillTypes.warning(self.warning)
    FillTypes.deprecationWarning(self.deprecationWarning)
    FillTypes.pendingDeprecationWarning(self.pendingDeprecationWarning)
    FillTypes.runtimeWarning(self.runtimeWarning)
    FillTypes.syntaxWarning(self.syntaxWarning)
    FillTypes.userWarning(self.userWarning)
    FillTypes.futureWarning(self.futureWarning)
    FillTypes.importWarning(self.importWarning)
    FillTypes.unicodeWarning(self.unicodeWarning)
    FillTypes.bytesWarning(self.bytesWarning)
    FillTypes.resourceWarning(self.resourceWarning)
  }

  internal var all: [PyType] {
    return [
      self.baseException,
      self.systemExit,
      self.keyboardInterrupt,
      self.generatorExit,
      self.exception,
      self.stopIteration,
      self.stopAsyncIteration,
      self.arithmeticError,
      self.floatingPointError,
      self.overflowError,
      self.zeroDivisionError,
      self.assertionError,
      self.attributeError,
      self.bufferError,
      self.eofError,
      self.importError,
      self.moduleNotFoundError,
      self.lookupError,
      self.indexError,
      self.keyError,
      self.memoryError,
      self.nameError,
      self.unboundLocalError,
      self.osError,
      self.blockingIOError,
      self.childProcessError,
      self.connectionError,
      self.brokenPipeError,
      self.connectionAbortedError,
      self.connectionRefusedError,
      self.connectionResetError,
      self.fileExistsError,
      self.fileNotFoundError,
      self.interruptedError,
      self.isADirectoryError,
      self.notADirectoryError,
      self.permissionError,
      self.processLookupError,
      self.timeoutError,
      self.referenceError,
      self.runtimeError,
      self.notImplementedError,
      self.recursionError,
      self.syntaxError,
      self.indentationError,
      self.tabError,
      self.systemError,
      self.typeError,
      self.valueError,
      self.unicodeError,
      self.unicodeDecodeError,
      self.unicodeEncodeError,
      self.unicodeTranslateError,
      self.warning,
      self.deprecationWarning,
      self.pendingDeprecationWarning,
      self.runtimeWarning,
      self.syntaxWarning,
      self.userWarning,
      self.futureWarning,
      self.importWarning,
      self.unicodeWarning,
      self.bytesWarning,
      self.resourceWarning,
    ]
  }
}
