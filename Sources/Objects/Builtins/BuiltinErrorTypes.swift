// Most of this file was generatued using 'Scripes/generate_errors.py'.

// swiftlint:disable line_length

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

  // swiftlint:disable:next function_body_length
  internal init(context: PyContext, types: BuiltinTypes) {
    self.baseException = PyType.baseException(context, type: types.type, base: types.object)
    self.systemExit = PyType.systemExit(context, type: types.type, base: self.baseException)
    self.keyboardInterrupt = PyType.keyboardInterrupt(context, type: types.type, base: self.baseException)
    self.generatorExit = PyType.generatorExit(context, type: types.type, base: self.baseException)
    self.exception = PyType.exception(context, type: types.type, base: self.baseException)
    self.stopIteration = PyType.stopIteration(context, type: types.type, base: self.exception)
    self.stopAsyncIteration = PyType.stopAsyncIteration(context, type: types.type, base: self.exception)
    self.arithmeticError = PyType.arithmeticError(context, type: types.type, base: self.exception)
    self.floatingPointError = PyType.floatingPointError(context, type: types.type, base: self.arithmeticError)
    self.overflowError = PyType.overflowError(context, type: types.type, base: self.arithmeticError)
    self.zeroDivisionError = PyType.zeroDivisionError(context, type: types.type, base: self.arithmeticError)
    self.assertionError = PyType.assertionError(context, type: types.type, base: self.exception)
    self.attributeError = PyType.attributeError(context, type: types.type, base: self.exception)
    self.bufferError = PyType.bufferError(context, type: types.type, base: self.exception)
    self.eofError = PyType.eofError(context, type: types.type, base: self.exception)
    self.importError = PyType.importError(context, type: types.type, base: self.exception)
    self.moduleNotFoundError = PyType.moduleNotFoundError(context, type: types.type, base: self.importError)
    self.lookupError = PyType.lookupError(context, type: types.type, base: self.exception)
    self.indexError = PyType.indexError(context, type: types.type, base: self.lookupError)
    self.keyError = PyType.keyError(context, type: types.type, base: self.lookupError)
    self.memoryError = PyType.memoryError(context, type: types.type, base: self.exception)
    self.nameError = PyType.nameError(context, type: types.type, base: self.exception)
    self.unboundLocalError = PyType.unboundLocalError(context, type: types.type, base: self.nameError)
    self.osError = PyType.osError(context, type: types.type, base: self.exception)
    self.blockingIOError = PyType.blockingIOError(context, type: types.type, base: self.osError)
    self.childProcessError = PyType.childProcessError(context, type: types.type, base: self.osError)
    self.connectionError = PyType.connectionError(context, type: types.type, base: self.osError)
    self.brokenPipeError = PyType.brokenPipeError(context, type: types.type, base: self.connectionError)
    self.connectionAbortedError = PyType.connectionAbortedError(context, type: types.type, base: self.connectionError)
    self.connectionRefusedError = PyType.connectionRefusedError(context, type: types.type, base: self.connectionError)
    self.connectionResetError = PyType.connectionResetError(context, type: types.type, base: self.connectionError)
    self.fileExistsError = PyType.fileExistsError(context, type: types.type, base: self.osError)
    self.fileNotFoundError = PyType.fileNotFoundError(context, type: types.type, base: self.osError)
    self.interruptedError = PyType.interruptedError(context, type: types.type, base: self.osError)
    self.isADirectoryError = PyType.isADirectoryError(context, type: types.type, base: self.osError)
    self.notADirectoryError = PyType.notADirectoryError(context, type: types.type, base: self.osError)
    self.permissionError = PyType.permissionError(context, type: types.type, base: self.osError)
    self.processLookupError = PyType.processLookupError(context, type: types.type, base: self.osError)
    self.timeoutError = PyType.timeoutError(context, type: types.type, base: self.osError)
    self.referenceError = PyType.referenceError(context, type: types.type, base: self.exception)
    self.runtimeError = PyType.runtimeError(context, type: types.type, base: self.exception)
    self.notImplementedError = PyType.notImplementedError(context, type: types.type, base: self.runtimeError)
    self.recursionError = PyType.recursionError(context, type: types.type, base: self.runtimeError)
    self.syntaxError = PyType.syntaxError(context, type: types.type, base: self.exception)
    self.indentationError = PyType.indentationError(context, type: types.type, base: self.syntaxError)
    self.tabError = PyType.tabError(context, type: types.type, base: self.indentationError)
    self.systemError = PyType.systemError(context, type: types.type, base: self.exception)
    self.typeError = PyType.typeError(context, type: types.type, base: self.exception)
    self.valueError = PyType.valueError(context, type: types.type, base: self.exception)
    self.unicodeError = PyType.unicodeError(context, type: types.type, base: self.valueError)
    self.unicodeDecodeError = PyType.unicodeDecodeError(context, type: types.type, base: self.unicodeError)
    self.unicodeEncodeError = PyType.unicodeEncodeError(context, type: types.type, base: self.unicodeError)
    self.unicodeTranslateError = PyType.unicodeTranslateError(context, type: types.type, base: self.unicodeError)
  }
}
