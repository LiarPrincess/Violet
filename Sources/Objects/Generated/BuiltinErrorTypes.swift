// In CPython:
// Objects -> exceptions.c
// Lib->test->exception_hierarchy.txt <-- this is amazing
// https://docs.python.org/3.7/c-api/exceptions.html

// swiftlint:disable line_length
// swiftlint:disable function_body_length

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

  internal init(context: PyContext, types: BuiltinTypes) {
    self.baseException = TypeFactory.baseException(context, type: types.type, base: types.object)
    self.systemExit = TypeFactory.systemExit(context, type: types.type, base: self.baseException)
    self.keyboardInterrupt = TypeFactory.keyboardInterrupt(context, type: types.type, base: self.baseException)
    self.generatorExit = TypeFactory.generatorExit(context, type: types.type, base: self.baseException)
    self.exception = TypeFactory.exception(context, type: types.type, base: self.baseException)
    self.stopIteration = TypeFactory.stopIteration(context, type: types.type, base: self.exception)
    self.stopAsyncIteration = TypeFactory.stopAsyncIteration(context, type: types.type, base: self.exception)
    self.arithmeticError = TypeFactory.arithmeticError(context, type: types.type, base: self.exception)
    self.floatingPointError = TypeFactory.floatingPointError(context, type: types.type, base: self.arithmeticError)
    self.overflowError = TypeFactory.overflowError(context, type: types.type, base: self.arithmeticError)
    self.zeroDivisionError = TypeFactory.zeroDivisionError(context, type: types.type, base: self.arithmeticError)
    self.assertionError = TypeFactory.assertionError(context, type: types.type, base: self.exception)
    self.attributeError = TypeFactory.attributeError(context, type: types.type, base: self.exception)
    self.bufferError = TypeFactory.bufferError(context, type: types.type, base: self.exception)
    self.eofError = TypeFactory.eofError(context, type: types.type, base: self.exception)
    self.importError = TypeFactory.importError(context, type: types.type, base: self.exception)
    self.moduleNotFoundError = TypeFactory.moduleNotFoundError(context, type: types.type, base: self.importError)
    self.lookupError = TypeFactory.lookupError(context, type: types.type, base: self.exception)
    self.indexError = TypeFactory.indexError(context, type: types.type, base: self.lookupError)
    self.keyError = TypeFactory.keyError(context, type: types.type, base: self.lookupError)
    self.memoryError = TypeFactory.memoryError(context, type: types.type, base: self.exception)
    self.nameError = TypeFactory.nameError(context, type: types.type, base: self.exception)
    self.unboundLocalError = TypeFactory.unboundLocalError(context, type: types.type, base: self.nameError)
    self.osError = TypeFactory.osError(context, type: types.type, base: self.exception)
    self.blockingIOError = TypeFactory.blockingIOError(context, type: types.type, base: self.osError)
    self.childProcessError = TypeFactory.childProcessError(context, type: types.type, base: self.osError)
    self.connectionError = TypeFactory.connectionError(context, type: types.type, base: self.osError)
    self.brokenPipeError = TypeFactory.brokenPipeError(context, type: types.type, base: self.connectionError)
    self.connectionAbortedError = TypeFactory.connectionAbortedError(context, type: types.type, base: self.connectionError)
    self.connectionRefusedError = TypeFactory.connectionRefusedError(context, type: types.type, base: self.connectionError)
    self.connectionResetError = TypeFactory.connectionResetError(context, type: types.type, base: self.connectionError)
    self.fileExistsError = TypeFactory.fileExistsError(context, type: types.type, base: self.osError)
    self.fileNotFoundError = TypeFactory.fileNotFoundError(context, type: types.type, base: self.osError)
    self.interruptedError = TypeFactory.interruptedError(context, type: types.type, base: self.osError)
    self.isADirectoryError = TypeFactory.isADirectoryError(context, type: types.type, base: self.osError)
    self.notADirectoryError = TypeFactory.notADirectoryError(context, type: types.type, base: self.osError)
    self.permissionError = TypeFactory.permissionError(context, type: types.type, base: self.osError)
    self.processLookupError = TypeFactory.processLookupError(context, type: types.type, base: self.osError)
    self.timeoutError = TypeFactory.timeoutError(context, type: types.type, base: self.osError)
    self.referenceError = TypeFactory.referenceError(context, type: types.type, base: self.exception)
    self.runtimeError = TypeFactory.runtimeError(context, type: types.type, base: self.exception)
    self.notImplementedError = TypeFactory.notImplementedError(context, type: types.type, base: self.runtimeError)
    self.recursionError = TypeFactory.recursionError(context, type: types.type, base: self.runtimeError)
    self.syntaxError = TypeFactory.syntaxError(context, type: types.type, base: self.exception)
    self.indentationError = TypeFactory.indentationError(context, type: types.type, base: self.syntaxError)
    self.tabError = TypeFactory.tabError(context, type: types.type, base: self.indentationError)
    self.systemError = TypeFactory.systemError(context, type: types.type, base: self.exception)
    self.typeError = TypeFactory.typeError(context, type: types.type, base: self.exception)
    self.valueError = TypeFactory.valueError(context, type: types.type, base: self.exception)
    self.unicodeError = TypeFactory.unicodeError(context, type: types.type, base: self.valueError)
    self.unicodeDecodeError = TypeFactory.unicodeDecodeError(context, type: types.type, base: self.unicodeError)
    self.unicodeEncodeError = TypeFactory.unicodeEncodeError(context, type: types.type, base: self.unicodeError)
    self.unicodeTranslateError = TypeFactory.unicodeTranslateError(context, type: types.type, base: self.unicodeError)
    self.warning = TypeFactory.warning(context, type: types.type, base: self.exception)
    self.deprecationWarning = TypeFactory.deprecationWarning(context, type: types.type, base: self.warning)
    self.pendingDeprecationWarning = TypeFactory.pendingDeprecationWarning(context, type: types.type, base: self.warning)
    self.runtimeWarning = TypeFactory.runtimeWarning(context, type: types.type, base: self.warning)
    self.syntaxWarning = TypeFactory.syntaxWarning(context, type: types.type, base: self.warning)
    self.userWarning = TypeFactory.userWarning(context, type: types.type, base: self.warning)
    self.futureWarning = TypeFactory.futureWarning(context, type: types.type, base: self.warning)
    self.importWarning = TypeFactory.importWarning(context, type: types.type, base: self.warning)
    self.unicodeWarning = TypeFactory.unicodeWarning(context, type: types.type, base: self.warning)
    self.bytesWarning = TypeFactory.bytesWarning(context, type: types.type, base: self.warning)
    self.resourceWarning = TypeFactory.resourceWarning(context, type: types.type, base: self.warning)
  }
}
