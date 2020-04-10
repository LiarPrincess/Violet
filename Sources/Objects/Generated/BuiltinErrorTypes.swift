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

// Just like 'BuiltinTypes' this will be 2 phase init.
// See 'BuiltinTypes' for reasoning.
public final class BuiltinErrorTypes {

  // MARK: - Properties

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

  // MARK: - Stage 1 - init

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

  // MARK: - Stage 2 - fill __dict__

  /// This function finalizes init of all of the stored types.
  /// (see comment at the top of this file)
  ///
  /// For example it will:
  /// - set type flags
  /// - add `__doc__`
  /// - fill `__dict__`
  internal func fill__dict__() {
    self.fillBaseException()
    self.fillSystemExit()
    self.fillKeyboardInterrupt()
    self.fillGeneratorExit()
    self.fillException()
    self.fillStopIteration()
    self.fillStopAsyncIteration()
    self.fillArithmeticError()
    self.fillFloatingPointError()
    self.fillOverflowError()
    self.fillZeroDivisionError()
    self.fillAssertionError()
    self.fillAttributeError()
    self.fillBufferError()
    self.fillEOFError()
    self.fillImportError()
    self.fillModuleNotFoundError()
    self.fillLookupError()
    self.fillIndexError()
    self.fillKeyError()
    self.fillMemoryError()
    self.fillNameError()
    self.fillUnboundLocalError()
    self.fillOSError()
    self.fillBlockingIOError()
    self.fillChildProcessError()
    self.fillConnectionError()
    self.fillBrokenPipeError()
    self.fillConnectionAbortedError()
    self.fillConnectionRefusedError()
    self.fillConnectionResetError()
    self.fillFileExistsError()
    self.fillFileNotFoundError()
    self.fillInterruptedError()
    self.fillIsADirectoryError()
    self.fillNotADirectoryError()
    self.fillPermissionError()
    self.fillProcessLookupError()
    self.fillTimeoutError()
    self.fillReferenceError()
    self.fillRuntimeError()
    self.fillNotImplementedError()
    self.fillRecursionError()
    self.fillSyntaxError()
    self.fillIndentationError()
    self.fillTabError()
    self.fillSystemError()
    self.fillTypeError()
    self.fillValueError()
    self.fillUnicodeError()
    self.fillUnicodeDecodeError()
    self.fillUnicodeEncodeError()
    self.fillUnicodeTranslateError()
    self.fillWarning()
    self.fillDeprecationWarning()
    self.fillPendingDeprecationWarning()
    self.fillRuntimeWarning()
    self.fillSyntaxWarning()
    self.fillUserWarning()
    self.fillFutureWarning()
    self.fillImportWarning()
    self.fillUnicodeWarning()
    self.fillBytesWarning()
    self.fillResourceWarning()
  }

  // MARK: - All

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

  // MARK: - BaseException

  func fillBaseException() {
    let type = self.baseException
    type.setBuiltinTypeDoc(PyBaseException.doc)
    type.setFlag(.baseExceptionSubclass)
    type.setFlag(.baseType)
    type.setFlag(.default)
    type.setFlag(.hasGC)
    type.setLayout(.PyBaseException)

    insert(type: type, name: "__dict__", value: PyProperty.wrap(name: "__dict__", doc: nil, get: PyBaseException.getDict, castSelf: Cast.asPyBaseException))
    insert(type: type, name: "__class__", value: PyProperty.wrap(name: "__class__", doc: nil, get: PyBaseException.getClass, castSelf: Cast.asPyBaseException))
    insert(type: type, name: "args", value: PyProperty.wrap(name: "args", doc: nil, get: PyBaseException.getArgs, set: PyBaseException.setArgs, castSelf: Cast.asPyBaseException))
    insert(type: type, name: "__traceback__", value: PyProperty.wrap(name: "__traceback__", doc: nil, get: PyBaseException.getTraceback, set: PyBaseException.setTraceback, castSelf: Cast.asPyBaseException))
    insert(type: type, name: "__cause__", value: PyProperty.wrap(name: "__cause__", doc: PyBaseException.getCauseDoc, get: PyBaseException.getCause, set: PyBaseException.setCause, castSelf: Cast.asPyBaseException))
    insert(type: type, name: "__context__", value: PyProperty.wrap(name: "__context__", doc: PyBaseException.getContextDoc, get: PyBaseException.getContext, set: PyBaseException.setContext, castSelf: Cast.asPyBaseException))
    insert(type: type, name: "__suppress_context__", value: PyProperty.wrap(name: "__suppress_context__", doc: nil, get: PyBaseException.getSuppressContext, set: PyBaseException.setSuppressContext, castSelf: Cast.asPyBaseException))

    insert(type: type, name: "__new__", value: PyBuiltinFunction.wrapNew(type: type, doc: nil, fn: PyBaseException.pyNew(type:args:kwargs:)))
    insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PyBaseException.pyInit(zelf:args:kwargs:)))

    insert(type: type, name: "__repr__", value: PyBuiltinFunction.wrap(name: "__repr__", doc: nil, fn: PyBaseException.repr, castSelf: Cast.asPyBaseException))
    insert(type: type, name: "__str__", value: PyBuiltinFunction.wrap(name: "__str__", doc: nil, fn: PyBaseException.str, castSelf: Cast.asPyBaseException))
    insert(type: type, name: "__getattribute__", value: PyBuiltinFunction.wrap(name: "__getattribute__", doc: nil, fn: PyBaseException.getAttribute(name:), castSelf: Cast.asPyBaseException))
    insert(type: type, name: "__setattr__", value: PyBuiltinFunction.wrap(name: "__setattr__", doc: nil, fn: PyBaseException.setAttribute(name:value:), castSelf: Cast.asPyBaseException))
    insert(type: type, name: "__delattr__", value: PyBuiltinFunction.wrap(name: "__delattr__", doc: nil, fn: PyBaseException.delAttribute(name:), castSelf: Cast.asPyBaseException))
  }

  // MARK: - SystemExit

  func fillSystemExit() {
    let type = self.systemExit
    type.setBuiltinTypeDoc(PySystemExit.doc)
    type.setFlag(.baseExceptionSubclass)
    type.setFlag(.baseType)
    type.setFlag(.default)
    type.setFlag(.hasGC)
    type.setLayout(.PySystemExit)

    insert(type: type, name: "__class__", value: PyProperty.wrap(name: "__class__", doc: nil, get: PySystemExit.getClass, castSelf: Cast.asPySystemExit))
    insert(type: type, name: "__dict__", value: PyProperty.wrap(name: "__dict__", doc: nil, get: PySystemExit.getDict, castSelf: Cast.asPySystemExit))

    insert(type: type, name: "__new__", value: PyBuiltinFunction.wrapNew(type: type, doc: nil, fn: PySystemExit.pyNew(type:args:kwargs:)))
    insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PySystemExit.pyInit(zelf:args:kwargs:)))
  }

  // MARK: - KeyboardInterrupt

  func fillKeyboardInterrupt() {
    let type = self.keyboardInterrupt
    type.setBuiltinTypeDoc(PyKeyboardInterrupt.doc)
    type.setFlag(.baseExceptionSubclass)
    type.setFlag(.baseType)
    type.setFlag(.default)
    type.setFlag(.hasGC)
    type.setLayout(.PyKeyboardInterrupt)

    insert(type: type, name: "__class__", value: PyProperty.wrap(name: "__class__", doc: nil, get: PyKeyboardInterrupt.getClass, castSelf: Cast.asPyKeyboardInterrupt))
    insert(type: type, name: "__dict__", value: PyProperty.wrap(name: "__dict__", doc: nil, get: PyKeyboardInterrupt.getDict, castSelf: Cast.asPyKeyboardInterrupt))

    insert(type: type, name: "__new__", value: PyBuiltinFunction.wrapNew(type: type, doc: nil, fn: PyKeyboardInterrupt.pyNew(type:args:kwargs:)))
    insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PyKeyboardInterrupt.pyInit(zelf:args:kwargs:)))
  }

  // MARK: - GeneratorExit

  func fillGeneratorExit() {
    let type = self.generatorExit
    type.setBuiltinTypeDoc(PyGeneratorExit.doc)
    type.setFlag(.baseExceptionSubclass)
    type.setFlag(.baseType)
    type.setFlag(.default)
    type.setFlag(.hasGC)
    type.setLayout(.PyGeneratorExit)

    insert(type: type, name: "__class__", value: PyProperty.wrap(name: "__class__", doc: nil, get: PyGeneratorExit.getClass, castSelf: Cast.asPyGeneratorExit))
    insert(type: type, name: "__dict__", value: PyProperty.wrap(name: "__dict__", doc: nil, get: PyGeneratorExit.getDict, castSelf: Cast.asPyGeneratorExit))

    insert(type: type, name: "__new__", value: PyBuiltinFunction.wrapNew(type: type, doc: nil, fn: PyGeneratorExit.pyNew(type:args:kwargs:)))
    insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PyGeneratorExit.pyInit(zelf:args:kwargs:)))
  }

  // MARK: - Exception

  func fillException() {
    let type = self.exception
    type.setBuiltinTypeDoc(PyException.doc)
    type.setFlag(.baseExceptionSubclass)
    type.setFlag(.baseType)
    type.setFlag(.default)
    type.setFlag(.hasGC)
    type.setLayout(.PyException)

    insert(type: type, name: "__class__", value: PyProperty.wrap(name: "__class__", doc: nil, get: PyException.getClass, castSelf: Cast.asPyException))
    insert(type: type, name: "__dict__", value: PyProperty.wrap(name: "__dict__", doc: nil, get: PyException.getDict, castSelf: Cast.asPyException))

    insert(type: type, name: "__new__", value: PyBuiltinFunction.wrapNew(type: type, doc: nil, fn: PyException.pyNew(type:args:kwargs:)))
    insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PyException.pyInit(zelf:args:kwargs:)))
  }

  // MARK: - StopIteration

  func fillStopIteration() {
    let type = self.stopIteration
    type.setBuiltinTypeDoc(PyStopIteration.doc)
    type.setFlag(.baseExceptionSubclass)
    type.setFlag(.baseType)
    type.setFlag(.default)
    type.setFlag(.hasGC)
    type.setLayout(.PyStopIteration)

    insert(type: type, name: "__class__", value: PyProperty.wrap(name: "__class__", doc: nil, get: PyStopIteration.getClass, castSelf: Cast.asPyStopIteration))
    insert(type: type, name: "__dict__", value: PyProperty.wrap(name: "__dict__", doc: nil, get: PyStopIteration.getDict, castSelf: Cast.asPyStopIteration))

    insert(type: type, name: "__new__", value: PyBuiltinFunction.wrapNew(type: type, doc: nil, fn: PyStopIteration.pyNew(type:args:kwargs:)))
    insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PyStopIteration.pyInit(zelf:args:kwargs:)))
  }

  // MARK: - StopAsyncIteration

  func fillStopAsyncIteration() {
    let type = self.stopAsyncIteration
    type.setBuiltinTypeDoc(PyStopAsyncIteration.doc)
    type.setFlag(.baseExceptionSubclass)
    type.setFlag(.baseType)
    type.setFlag(.default)
    type.setFlag(.hasGC)
    type.setLayout(.PyStopAsyncIteration)

    insert(type: type, name: "__class__", value: PyProperty.wrap(name: "__class__", doc: nil, get: PyStopAsyncIteration.getClass, castSelf: Cast.asPyStopAsyncIteration))
    insert(type: type, name: "__dict__", value: PyProperty.wrap(name: "__dict__", doc: nil, get: PyStopAsyncIteration.getDict, castSelf: Cast.asPyStopAsyncIteration))

    insert(type: type, name: "__new__", value: PyBuiltinFunction.wrapNew(type: type, doc: nil, fn: PyStopAsyncIteration.pyNew(type:args:kwargs:)))
    insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PyStopAsyncIteration.pyInit(zelf:args:kwargs:)))
  }

  // MARK: - ArithmeticError

  func fillArithmeticError() {
    let type = self.arithmeticError
    type.setBuiltinTypeDoc(PyArithmeticError.doc)
    type.setFlag(.baseExceptionSubclass)
    type.setFlag(.baseType)
    type.setFlag(.default)
    type.setFlag(.hasGC)
    type.setLayout(.PyArithmeticError)

    insert(type: type, name: "__class__", value: PyProperty.wrap(name: "__class__", doc: nil, get: PyArithmeticError.getClass, castSelf: Cast.asPyArithmeticError))
    insert(type: type, name: "__dict__", value: PyProperty.wrap(name: "__dict__", doc: nil, get: PyArithmeticError.getDict, castSelf: Cast.asPyArithmeticError))

    insert(type: type, name: "__new__", value: PyBuiltinFunction.wrapNew(type: type, doc: nil, fn: PyArithmeticError.pyNew(type:args:kwargs:)))
    insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PyArithmeticError.pyInit(zelf:args:kwargs:)))
  }

  // MARK: - FloatingPointError

  func fillFloatingPointError() {
    let type = self.floatingPointError
    type.setBuiltinTypeDoc(PyFloatingPointError.doc)
    type.setFlag(.baseExceptionSubclass)
    type.setFlag(.baseType)
    type.setFlag(.default)
    type.setFlag(.hasGC)
    type.setLayout(.PyFloatingPointError)

    insert(type: type, name: "__class__", value: PyProperty.wrap(name: "__class__", doc: nil, get: PyFloatingPointError.getClass, castSelf: Cast.asPyFloatingPointError))
    insert(type: type, name: "__dict__", value: PyProperty.wrap(name: "__dict__", doc: nil, get: PyFloatingPointError.getDict, castSelf: Cast.asPyFloatingPointError))

    insert(type: type, name: "__new__", value: PyBuiltinFunction.wrapNew(type: type, doc: nil, fn: PyFloatingPointError.pyNew(type:args:kwargs:)))
    insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PyFloatingPointError.pyInit(zelf:args:kwargs:)))
  }

  // MARK: - OverflowError

  func fillOverflowError() {
    let type = self.overflowError
    type.setBuiltinTypeDoc(PyOverflowError.doc)
    type.setFlag(.baseExceptionSubclass)
    type.setFlag(.baseType)
    type.setFlag(.default)
    type.setFlag(.hasGC)
    type.setLayout(.PyOverflowError)

    insert(type: type, name: "__class__", value: PyProperty.wrap(name: "__class__", doc: nil, get: PyOverflowError.getClass, castSelf: Cast.asPyOverflowError))
    insert(type: type, name: "__dict__", value: PyProperty.wrap(name: "__dict__", doc: nil, get: PyOverflowError.getDict, castSelf: Cast.asPyOverflowError))

    insert(type: type, name: "__new__", value: PyBuiltinFunction.wrapNew(type: type, doc: nil, fn: PyOverflowError.pyNew(type:args:kwargs:)))
    insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PyOverflowError.pyInit(zelf:args:kwargs:)))
  }

  // MARK: - ZeroDivisionError

  func fillZeroDivisionError() {
    let type = self.zeroDivisionError
    type.setBuiltinTypeDoc(PyZeroDivisionError.doc)
    type.setFlag(.baseExceptionSubclass)
    type.setFlag(.baseType)
    type.setFlag(.default)
    type.setFlag(.hasGC)
    type.setLayout(.PyZeroDivisionError)

    insert(type: type, name: "__class__", value: PyProperty.wrap(name: "__class__", doc: nil, get: PyZeroDivisionError.getClass, castSelf: Cast.asPyZeroDivisionError))
    insert(type: type, name: "__dict__", value: PyProperty.wrap(name: "__dict__", doc: nil, get: PyZeroDivisionError.getDict, castSelf: Cast.asPyZeroDivisionError))

    insert(type: type, name: "__new__", value: PyBuiltinFunction.wrapNew(type: type, doc: nil, fn: PyZeroDivisionError.pyNew(type:args:kwargs:)))
    insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PyZeroDivisionError.pyInit(zelf:args:kwargs:)))
  }

  // MARK: - AssertionError

  func fillAssertionError() {
    let type = self.assertionError
    type.setBuiltinTypeDoc(PyAssertionError.doc)
    type.setFlag(.baseExceptionSubclass)
    type.setFlag(.baseType)
    type.setFlag(.default)
    type.setFlag(.hasGC)
    type.setLayout(.PyAssertionError)

    insert(type: type, name: "__class__", value: PyProperty.wrap(name: "__class__", doc: nil, get: PyAssertionError.getClass, castSelf: Cast.asPyAssertionError))
    insert(type: type, name: "__dict__", value: PyProperty.wrap(name: "__dict__", doc: nil, get: PyAssertionError.getDict, castSelf: Cast.asPyAssertionError))

    insert(type: type, name: "__new__", value: PyBuiltinFunction.wrapNew(type: type, doc: nil, fn: PyAssertionError.pyNew(type:args:kwargs:)))
    insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PyAssertionError.pyInit(zelf:args:kwargs:)))
  }

  // MARK: - AttributeError

  func fillAttributeError() {
    let type = self.attributeError
    type.setBuiltinTypeDoc(PyAttributeError.doc)
    type.setFlag(.baseExceptionSubclass)
    type.setFlag(.baseType)
    type.setFlag(.default)
    type.setFlag(.hasGC)
    type.setLayout(.PyAttributeError)

    insert(type: type, name: "__class__", value: PyProperty.wrap(name: "__class__", doc: nil, get: PyAttributeError.getClass, castSelf: Cast.asPyAttributeError))
    insert(type: type, name: "__dict__", value: PyProperty.wrap(name: "__dict__", doc: nil, get: PyAttributeError.getDict, castSelf: Cast.asPyAttributeError))

    insert(type: type, name: "__new__", value: PyBuiltinFunction.wrapNew(type: type, doc: nil, fn: PyAttributeError.pyNew(type:args:kwargs:)))
    insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PyAttributeError.pyInit(zelf:args:kwargs:)))
  }

  // MARK: - BufferError

  func fillBufferError() {
    let type = self.bufferError
    type.setBuiltinTypeDoc(PyBufferError.doc)
    type.setFlag(.baseExceptionSubclass)
    type.setFlag(.baseType)
    type.setFlag(.default)
    type.setFlag(.hasGC)
    type.setLayout(.PyBufferError)

    insert(type: type, name: "__class__", value: PyProperty.wrap(name: "__class__", doc: nil, get: PyBufferError.getClass, castSelf: Cast.asPyBufferError))
    insert(type: type, name: "__dict__", value: PyProperty.wrap(name: "__dict__", doc: nil, get: PyBufferError.getDict, castSelf: Cast.asPyBufferError))

    insert(type: type, name: "__new__", value: PyBuiltinFunction.wrapNew(type: type, doc: nil, fn: PyBufferError.pyNew(type:args:kwargs:)))
    insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PyBufferError.pyInit(zelf:args:kwargs:)))
  }

  // MARK: - EOFError

  func fillEOFError() {
    let type = self.eofError
    type.setBuiltinTypeDoc(PyEOFError.doc)
    type.setFlag(.baseExceptionSubclass)
    type.setFlag(.baseType)
    type.setFlag(.default)
    type.setFlag(.hasGC)
    type.setLayout(.PyEOFError)

    insert(type: type, name: "__class__", value: PyProperty.wrap(name: "__class__", doc: nil, get: PyEOFError.getClass, castSelf: Cast.asPyEOFError))
    insert(type: type, name: "__dict__", value: PyProperty.wrap(name: "__dict__", doc: nil, get: PyEOFError.getDict, castSelf: Cast.asPyEOFError))

    insert(type: type, name: "__new__", value: PyBuiltinFunction.wrapNew(type: type, doc: nil, fn: PyEOFError.pyNew(type:args:kwargs:)))
    insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PyEOFError.pyInit(zelf:args:kwargs:)))
  }

  // MARK: - ImportError

  func fillImportError() {
    let type = self.importError
    type.setBuiltinTypeDoc(PyImportError.doc)
    type.setFlag(.baseExceptionSubclass)
    type.setFlag(.baseType)
    type.setFlag(.default)
    type.setFlag(.hasGC)
    type.setLayout(.PyImportError)

    insert(type: type, name: "__class__", value: PyProperty.wrap(name: "__class__", doc: nil, get: PyImportError.getClass, castSelf: Cast.asPyImportError))
    insert(type: type, name: "__dict__", value: PyProperty.wrap(name: "__dict__", doc: nil, get: PyImportError.getDict, castSelf: Cast.asPyImportError))

    insert(type: type, name: "__new__", value: PyBuiltinFunction.wrapNew(type: type, doc: nil, fn: PyImportError.pyNew(type:args:kwargs:)))
    insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PyImportError.pyInit(zelf:args:kwargs:)))
  }

  // MARK: - ModuleNotFoundError

  func fillModuleNotFoundError() {
    let type = self.moduleNotFoundError
    type.setBuiltinTypeDoc(PyModuleNotFoundError.doc)
    type.setFlag(.baseExceptionSubclass)
    type.setFlag(.baseType)
    type.setFlag(.default)
    type.setFlag(.hasGC)
    type.setLayout(.PyModuleNotFoundError)

    insert(type: type, name: "__class__", value: PyProperty.wrap(name: "__class__", doc: nil, get: PyModuleNotFoundError.getClass, castSelf: Cast.asPyModuleNotFoundError))
    insert(type: type, name: "__dict__", value: PyProperty.wrap(name: "__dict__", doc: nil, get: PyModuleNotFoundError.getDict, castSelf: Cast.asPyModuleNotFoundError))

    insert(type: type, name: "__new__", value: PyBuiltinFunction.wrapNew(type: type, doc: nil, fn: PyModuleNotFoundError.pyNew(type:args:kwargs:)))
    insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PyModuleNotFoundError.pyInit(zelf:args:kwargs:)))
  }

  // MARK: - LookupError

  func fillLookupError() {
    let type = self.lookupError
    type.setBuiltinTypeDoc(PyLookupError.doc)
    type.setFlag(.baseExceptionSubclass)
    type.setFlag(.baseType)
    type.setFlag(.default)
    type.setFlag(.hasGC)
    type.setLayout(.PyLookupError)

    insert(type: type, name: "__class__", value: PyProperty.wrap(name: "__class__", doc: nil, get: PyLookupError.getClass, castSelf: Cast.asPyLookupError))
    insert(type: type, name: "__dict__", value: PyProperty.wrap(name: "__dict__", doc: nil, get: PyLookupError.getDict, castSelf: Cast.asPyLookupError))

    insert(type: type, name: "__new__", value: PyBuiltinFunction.wrapNew(type: type, doc: nil, fn: PyLookupError.pyNew(type:args:kwargs:)))
    insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PyLookupError.pyInit(zelf:args:kwargs:)))
  }

  // MARK: - IndexError

  func fillIndexError() {
    let type = self.indexError
    type.setBuiltinTypeDoc(PyIndexError.doc)
    type.setFlag(.baseExceptionSubclass)
    type.setFlag(.baseType)
    type.setFlag(.default)
    type.setFlag(.hasGC)
    type.setLayout(.PyIndexError)

    insert(type: type, name: "__class__", value: PyProperty.wrap(name: "__class__", doc: nil, get: PyIndexError.getClass, castSelf: Cast.asPyIndexError))
    insert(type: type, name: "__dict__", value: PyProperty.wrap(name: "__dict__", doc: nil, get: PyIndexError.getDict, castSelf: Cast.asPyIndexError))

    insert(type: type, name: "__new__", value: PyBuiltinFunction.wrapNew(type: type, doc: nil, fn: PyIndexError.pyNew(type:args:kwargs:)))
    insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PyIndexError.pyInit(zelf:args:kwargs:)))
  }

  // MARK: - KeyError

  func fillKeyError() {
    let type = self.keyError
    type.setBuiltinTypeDoc(PyKeyError.doc)
    type.setFlag(.baseExceptionSubclass)
    type.setFlag(.baseType)
    type.setFlag(.default)
    type.setFlag(.hasGC)
    type.setLayout(.PyKeyError)

    insert(type: type, name: "__class__", value: PyProperty.wrap(name: "__class__", doc: nil, get: PyKeyError.getClass, castSelf: Cast.asPyKeyError))
    insert(type: type, name: "__dict__", value: PyProperty.wrap(name: "__dict__", doc: nil, get: PyKeyError.getDict, castSelf: Cast.asPyKeyError))

    insert(type: type, name: "__new__", value: PyBuiltinFunction.wrapNew(type: type, doc: nil, fn: PyKeyError.pyNew(type:args:kwargs:)))
    insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PyKeyError.pyInit(zelf:args:kwargs:)))
  }

  // MARK: - MemoryError

  func fillMemoryError() {
    let type = self.memoryError
    type.setBuiltinTypeDoc(PyMemoryError.doc)
    type.setFlag(.baseExceptionSubclass)
    type.setFlag(.baseType)
    type.setFlag(.default)
    type.setFlag(.hasGC)
    type.setLayout(.PyMemoryError)

    insert(type: type, name: "__class__", value: PyProperty.wrap(name: "__class__", doc: nil, get: PyMemoryError.getClass, castSelf: Cast.asPyMemoryError))
    insert(type: type, name: "__dict__", value: PyProperty.wrap(name: "__dict__", doc: nil, get: PyMemoryError.getDict, castSelf: Cast.asPyMemoryError))

    insert(type: type, name: "__new__", value: PyBuiltinFunction.wrapNew(type: type, doc: nil, fn: PyMemoryError.pyNew(type:args:kwargs:)))
    insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PyMemoryError.pyInit(zelf:args:kwargs:)))
  }

  // MARK: - NameError

  func fillNameError() {
    let type = self.nameError
    type.setBuiltinTypeDoc(PyNameError.doc)
    type.setFlag(.baseExceptionSubclass)
    type.setFlag(.baseType)
    type.setFlag(.default)
    type.setFlag(.hasGC)
    type.setLayout(.PyNameError)

    insert(type: type, name: "__class__", value: PyProperty.wrap(name: "__class__", doc: nil, get: PyNameError.getClass, castSelf: Cast.asPyNameError))
    insert(type: type, name: "__dict__", value: PyProperty.wrap(name: "__dict__", doc: nil, get: PyNameError.getDict, castSelf: Cast.asPyNameError))

    insert(type: type, name: "__new__", value: PyBuiltinFunction.wrapNew(type: type, doc: nil, fn: PyNameError.pyNew(type:args:kwargs:)))
    insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PyNameError.pyInit(zelf:args:kwargs:)))
  }

  // MARK: - UnboundLocalError

  func fillUnboundLocalError() {
    let type = self.unboundLocalError
    type.setBuiltinTypeDoc(PyUnboundLocalError.doc)
    type.setFlag(.baseExceptionSubclass)
    type.setFlag(.baseType)
    type.setFlag(.default)
    type.setFlag(.hasGC)
    type.setLayout(.PyUnboundLocalError)

    insert(type: type, name: "__class__", value: PyProperty.wrap(name: "__class__", doc: nil, get: PyUnboundLocalError.getClass, castSelf: Cast.asPyUnboundLocalError))
    insert(type: type, name: "__dict__", value: PyProperty.wrap(name: "__dict__", doc: nil, get: PyUnboundLocalError.getDict, castSelf: Cast.asPyUnboundLocalError))

    insert(type: type, name: "__new__", value: PyBuiltinFunction.wrapNew(type: type, doc: nil, fn: PyUnboundLocalError.pyNew(type:args:kwargs:)))
    insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PyUnboundLocalError.pyInit(zelf:args:kwargs:)))
  }

  // MARK: - OSError

  func fillOSError() {
    let type = self.osError
    type.setBuiltinTypeDoc(PyOSError.doc)
    type.setFlag(.baseExceptionSubclass)
    type.setFlag(.baseType)
    type.setFlag(.default)
    type.setFlag(.hasGC)
    type.setLayout(.PyOSError)

    insert(type: type, name: "__class__", value: PyProperty.wrap(name: "__class__", doc: nil, get: PyOSError.getClass, castSelf: Cast.asPyOSError))
    insert(type: type, name: "__dict__", value: PyProperty.wrap(name: "__dict__", doc: nil, get: PyOSError.getDict, castSelf: Cast.asPyOSError))

    insert(type: type, name: "__new__", value: PyBuiltinFunction.wrapNew(type: type, doc: nil, fn: PyOSError.pyNew(type:args:kwargs:)))
    insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PyOSError.pyInit(zelf:args:kwargs:)))
  }

  // MARK: - BlockingIOError

  func fillBlockingIOError() {
    let type = self.blockingIOError
    type.setBuiltinTypeDoc(PyBlockingIOError.doc)
    type.setFlag(.baseExceptionSubclass)
    type.setFlag(.baseType)
    type.setFlag(.default)
    type.setFlag(.hasGC)
    type.setLayout(.PyBlockingIOError)

    insert(type: type, name: "__class__", value: PyProperty.wrap(name: "__class__", doc: nil, get: PyBlockingIOError.getClass, castSelf: Cast.asPyBlockingIOError))
    insert(type: type, name: "__dict__", value: PyProperty.wrap(name: "__dict__", doc: nil, get: PyBlockingIOError.getDict, castSelf: Cast.asPyBlockingIOError))

    insert(type: type, name: "__new__", value: PyBuiltinFunction.wrapNew(type: type, doc: nil, fn: PyBlockingIOError.pyNew(type:args:kwargs:)))
    insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PyBlockingIOError.pyInit(zelf:args:kwargs:)))
  }

  // MARK: - ChildProcessError

  func fillChildProcessError() {
    let type = self.childProcessError
    type.setBuiltinTypeDoc(PyChildProcessError.doc)
    type.setFlag(.baseExceptionSubclass)
    type.setFlag(.baseType)
    type.setFlag(.default)
    type.setFlag(.hasGC)
    type.setLayout(.PyChildProcessError)

    insert(type: type, name: "__class__", value: PyProperty.wrap(name: "__class__", doc: nil, get: PyChildProcessError.getClass, castSelf: Cast.asPyChildProcessError))
    insert(type: type, name: "__dict__", value: PyProperty.wrap(name: "__dict__", doc: nil, get: PyChildProcessError.getDict, castSelf: Cast.asPyChildProcessError))

    insert(type: type, name: "__new__", value: PyBuiltinFunction.wrapNew(type: type, doc: nil, fn: PyChildProcessError.pyNew(type:args:kwargs:)))
    insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PyChildProcessError.pyInit(zelf:args:kwargs:)))
  }

  // MARK: - ConnectionError

  func fillConnectionError() {
    let type = self.connectionError
    type.setBuiltinTypeDoc(PyConnectionError.doc)
    type.setFlag(.baseExceptionSubclass)
    type.setFlag(.baseType)
    type.setFlag(.default)
    type.setFlag(.hasGC)
    type.setLayout(.PyConnectionError)

    insert(type: type, name: "__class__", value: PyProperty.wrap(name: "__class__", doc: nil, get: PyConnectionError.getClass, castSelf: Cast.asPyConnectionError))
    insert(type: type, name: "__dict__", value: PyProperty.wrap(name: "__dict__", doc: nil, get: PyConnectionError.getDict, castSelf: Cast.asPyConnectionError))

    insert(type: type, name: "__new__", value: PyBuiltinFunction.wrapNew(type: type, doc: nil, fn: PyConnectionError.pyNew(type:args:kwargs:)))
    insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PyConnectionError.pyInit(zelf:args:kwargs:)))
  }

  // MARK: - BrokenPipeError

  func fillBrokenPipeError() {
    let type = self.brokenPipeError
    type.setBuiltinTypeDoc(PyBrokenPipeError.doc)
    type.setFlag(.baseExceptionSubclass)
    type.setFlag(.baseType)
    type.setFlag(.default)
    type.setFlag(.hasGC)
    type.setLayout(.PyBrokenPipeError)

    insert(type: type, name: "__class__", value: PyProperty.wrap(name: "__class__", doc: nil, get: PyBrokenPipeError.getClass, castSelf: Cast.asPyBrokenPipeError))
    insert(type: type, name: "__dict__", value: PyProperty.wrap(name: "__dict__", doc: nil, get: PyBrokenPipeError.getDict, castSelf: Cast.asPyBrokenPipeError))

    insert(type: type, name: "__new__", value: PyBuiltinFunction.wrapNew(type: type, doc: nil, fn: PyBrokenPipeError.pyNew(type:args:kwargs:)))
    insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PyBrokenPipeError.pyInit(zelf:args:kwargs:)))
  }

  // MARK: - ConnectionAbortedError

  func fillConnectionAbortedError() {
    let type = self.connectionAbortedError
    type.setBuiltinTypeDoc(PyConnectionAbortedError.doc)
    type.setFlag(.baseExceptionSubclass)
    type.setFlag(.baseType)
    type.setFlag(.default)
    type.setFlag(.hasGC)
    type.setLayout(.PyConnectionAbortedError)

    insert(type: type, name: "__class__", value: PyProperty.wrap(name: "__class__", doc: nil, get: PyConnectionAbortedError.getClass, castSelf: Cast.asPyConnectionAbortedError))
    insert(type: type, name: "__dict__", value: PyProperty.wrap(name: "__dict__", doc: nil, get: PyConnectionAbortedError.getDict, castSelf: Cast.asPyConnectionAbortedError))

    insert(type: type, name: "__new__", value: PyBuiltinFunction.wrapNew(type: type, doc: nil, fn: PyConnectionAbortedError.pyNew(type:args:kwargs:)))
    insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PyConnectionAbortedError.pyInit(zelf:args:kwargs:)))
  }

  // MARK: - ConnectionRefusedError

  func fillConnectionRefusedError() {
    let type = self.connectionRefusedError
    type.setBuiltinTypeDoc(PyConnectionRefusedError.doc)
    type.setFlag(.baseExceptionSubclass)
    type.setFlag(.baseType)
    type.setFlag(.default)
    type.setFlag(.hasGC)
    type.setLayout(.PyConnectionRefusedError)

    insert(type: type, name: "__class__", value: PyProperty.wrap(name: "__class__", doc: nil, get: PyConnectionRefusedError.getClass, castSelf: Cast.asPyConnectionRefusedError))
    insert(type: type, name: "__dict__", value: PyProperty.wrap(name: "__dict__", doc: nil, get: PyConnectionRefusedError.getDict, castSelf: Cast.asPyConnectionRefusedError))

    insert(type: type, name: "__new__", value: PyBuiltinFunction.wrapNew(type: type, doc: nil, fn: PyConnectionRefusedError.pyNew(type:args:kwargs:)))
    insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PyConnectionRefusedError.pyInit(zelf:args:kwargs:)))
  }

  // MARK: - ConnectionResetError

  func fillConnectionResetError() {
    let type = self.connectionResetError
    type.setBuiltinTypeDoc(PyConnectionResetError.doc)
    type.setFlag(.baseExceptionSubclass)
    type.setFlag(.baseType)
    type.setFlag(.default)
    type.setFlag(.hasGC)
    type.setLayout(.PyConnectionResetError)

    insert(type: type, name: "__class__", value: PyProperty.wrap(name: "__class__", doc: nil, get: PyConnectionResetError.getClass, castSelf: Cast.asPyConnectionResetError))
    insert(type: type, name: "__dict__", value: PyProperty.wrap(name: "__dict__", doc: nil, get: PyConnectionResetError.getDict, castSelf: Cast.asPyConnectionResetError))

    insert(type: type, name: "__new__", value: PyBuiltinFunction.wrapNew(type: type, doc: nil, fn: PyConnectionResetError.pyNew(type:args:kwargs:)))
    insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PyConnectionResetError.pyInit(zelf:args:kwargs:)))
  }

  // MARK: - FileExistsError

  func fillFileExistsError() {
    let type = self.fileExistsError
    type.setBuiltinTypeDoc(PyFileExistsError.doc)
    type.setFlag(.baseExceptionSubclass)
    type.setFlag(.baseType)
    type.setFlag(.default)
    type.setFlag(.hasGC)
    type.setLayout(.PyFileExistsError)

    insert(type: type, name: "__class__", value: PyProperty.wrap(name: "__class__", doc: nil, get: PyFileExistsError.getClass, castSelf: Cast.asPyFileExistsError))
    insert(type: type, name: "__dict__", value: PyProperty.wrap(name: "__dict__", doc: nil, get: PyFileExistsError.getDict, castSelf: Cast.asPyFileExistsError))

    insert(type: type, name: "__new__", value: PyBuiltinFunction.wrapNew(type: type, doc: nil, fn: PyFileExistsError.pyNew(type:args:kwargs:)))
    insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PyFileExistsError.pyInit(zelf:args:kwargs:)))
  }

  // MARK: - FileNotFoundError

  func fillFileNotFoundError() {
    let type = self.fileNotFoundError
    type.setBuiltinTypeDoc(PyFileNotFoundError.doc)
    type.setFlag(.baseExceptionSubclass)
    type.setFlag(.baseType)
    type.setFlag(.default)
    type.setFlag(.hasGC)
    type.setLayout(.PyFileNotFoundError)

    insert(type: type, name: "__class__", value: PyProperty.wrap(name: "__class__", doc: nil, get: PyFileNotFoundError.getClass, castSelf: Cast.asPyFileNotFoundError))
    insert(type: type, name: "__dict__", value: PyProperty.wrap(name: "__dict__", doc: nil, get: PyFileNotFoundError.getDict, castSelf: Cast.asPyFileNotFoundError))

    insert(type: type, name: "__new__", value: PyBuiltinFunction.wrapNew(type: type, doc: nil, fn: PyFileNotFoundError.pyNew(type:args:kwargs:)))
    insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PyFileNotFoundError.pyInit(zelf:args:kwargs:)))
  }

  // MARK: - InterruptedError

  func fillInterruptedError() {
    let type = self.interruptedError
    type.setBuiltinTypeDoc(PyInterruptedError.doc)
    type.setFlag(.baseExceptionSubclass)
    type.setFlag(.baseType)
    type.setFlag(.default)
    type.setFlag(.hasGC)
    type.setLayout(.PyInterruptedError)

    insert(type: type, name: "__class__", value: PyProperty.wrap(name: "__class__", doc: nil, get: PyInterruptedError.getClass, castSelf: Cast.asPyInterruptedError))
    insert(type: type, name: "__dict__", value: PyProperty.wrap(name: "__dict__", doc: nil, get: PyInterruptedError.getDict, castSelf: Cast.asPyInterruptedError))

    insert(type: type, name: "__new__", value: PyBuiltinFunction.wrapNew(type: type, doc: nil, fn: PyInterruptedError.pyNew(type:args:kwargs:)))
    insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PyInterruptedError.pyInit(zelf:args:kwargs:)))
  }

  // MARK: - IsADirectoryError

  func fillIsADirectoryError() {
    let type = self.isADirectoryError
    type.setBuiltinTypeDoc(PyIsADirectoryError.doc)
    type.setFlag(.baseExceptionSubclass)
    type.setFlag(.baseType)
    type.setFlag(.default)
    type.setFlag(.hasGC)
    type.setLayout(.PyIsADirectoryError)

    insert(type: type, name: "__class__", value: PyProperty.wrap(name: "__class__", doc: nil, get: PyIsADirectoryError.getClass, castSelf: Cast.asPyIsADirectoryError))
    insert(type: type, name: "__dict__", value: PyProperty.wrap(name: "__dict__", doc: nil, get: PyIsADirectoryError.getDict, castSelf: Cast.asPyIsADirectoryError))

    insert(type: type, name: "__new__", value: PyBuiltinFunction.wrapNew(type: type, doc: nil, fn: PyIsADirectoryError.pyNew(type:args:kwargs:)))
    insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PyIsADirectoryError.pyInit(zelf:args:kwargs:)))
  }

  // MARK: - NotADirectoryError

  func fillNotADirectoryError() {
    let type = self.notADirectoryError
    type.setBuiltinTypeDoc(PyNotADirectoryError.doc)
    type.setFlag(.baseExceptionSubclass)
    type.setFlag(.baseType)
    type.setFlag(.default)
    type.setFlag(.hasGC)
    type.setLayout(.PyNotADirectoryError)

    insert(type: type, name: "__class__", value: PyProperty.wrap(name: "__class__", doc: nil, get: PyNotADirectoryError.getClass, castSelf: Cast.asPyNotADirectoryError))
    insert(type: type, name: "__dict__", value: PyProperty.wrap(name: "__dict__", doc: nil, get: PyNotADirectoryError.getDict, castSelf: Cast.asPyNotADirectoryError))

    insert(type: type, name: "__new__", value: PyBuiltinFunction.wrapNew(type: type, doc: nil, fn: PyNotADirectoryError.pyNew(type:args:kwargs:)))
    insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PyNotADirectoryError.pyInit(zelf:args:kwargs:)))
  }

  // MARK: - PermissionError

  func fillPermissionError() {
    let type = self.permissionError
    type.setBuiltinTypeDoc(PyPermissionError.doc)
    type.setFlag(.baseExceptionSubclass)
    type.setFlag(.baseType)
    type.setFlag(.default)
    type.setFlag(.hasGC)
    type.setLayout(.PyPermissionError)

    insert(type: type, name: "__class__", value: PyProperty.wrap(name: "__class__", doc: nil, get: PyPermissionError.getClass, castSelf: Cast.asPyPermissionError))
    insert(type: type, name: "__dict__", value: PyProperty.wrap(name: "__dict__", doc: nil, get: PyPermissionError.getDict, castSelf: Cast.asPyPermissionError))

    insert(type: type, name: "__new__", value: PyBuiltinFunction.wrapNew(type: type, doc: nil, fn: PyPermissionError.pyNew(type:args:kwargs:)))
    insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PyPermissionError.pyInit(zelf:args:kwargs:)))
  }

  // MARK: - ProcessLookupError

  func fillProcessLookupError() {
    let type = self.processLookupError
    type.setBuiltinTypeDoc(PyProcessLookupError.doc)
    type.setFlag(.baseExceptionSubclass)
    type.setFlag(.baseType)
    type.setFlag(.default)
    type.setFlag(.hasGC)
    type.setLayout(.PyProcessLookupError)

    insert(type: type, name: "__class__", value: PyProperty.wrap(name: "__class__", doc: nil, get: PyProcessLookupError.getClass, castSelf: Cast.asPyProcessLookupError))
    insert(type: type, name: "__dict__", value: PyProperty.wrap(name: "__dict__", doc: nil, get: PyProcessLookupError.getDict, castSelf: Cast.asPyProcessLookupError))

    insert(type: type, name: "__new__", value: PyBuiltinFunction.wrapNew(type: type, doc: nil, fn: PyProcessLookupError.pyNew(type:args:kwargs:)))
    insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PyProcessLookupError.pyInit(zelf:args:kwargs:)))
  }

  // MARK: - TimeoutError

  func fillTimeoutError() {
    let type = self.timeoutError
    type.setBuiltinTypeDoc(PyTimeoutError.doc)
    type.setFlag(.baseExceptionSubclass)
    type.setFlag(.baseType)
    type.setFlag(.default)
    type.setFlag(.hasGC)
    type.setLayout(.PyTimeoutError)

    insert(type: type, name: "__class__", value: PyProperty.wrap(name: "__class__", doc: nil, get: PyTimeoutError.getClass, castSelf: Cast.asPyTimeoutError))
    insert(type: type, name: "__dict__", value: PyProperty.wrap(name: "__dict__", doc: nil, get: PyTimeoutError.getDict, castSelf: Cast.asPyTimeoutError))

    insert(type: type, name: "__new__", value: PyBuiltinFunction.wrapNew(type: type, doc: nil, fn: PyTimeoutError.pyNew(type:args:kwargs:)))
    insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PyTimeoutError.pyInit(zelf:args:kwargs:)))
  }

  // MARK: - ReferenceError

  func fillReferenceError() {
    let type = self.referenceError
    type.setBuiltinTypeDoc(PyReferenceError.doc)
    type.setFlag(.baseExceptionSubclass)
    type.setFlag(.baseType)
    type.setFlag(.default)
    type.setFlag(.hasGC)
    type.setLayout(.PyReferenceError)

    insert(type: type, name: "__class__", value: PyProperty.wrap(name: "__class__", doc: nil, get: PyReferenceError.getClass, castSelf: Cast.asPyReferenceError))
    insert(type: type, name: "__dict__", value: PyProperty.wrap(name: "__dict__", doc: nil, get: PyReferenceError.getDict, castSelf: Cast.asPyReferenceError))

    insert(type: type, name: "__new__", value: PyBuiltinFunction.wrapNew(type: type, doc: nil, fn: PyReferenceError.pyNew(type:args:kwargs:)))
    insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PyReferenceError.pyInit(zelf:args:kwargs:)))
  }

  // MARK: - RuntimeError

  func fillRuntimeError() {
    let type = self.runtimeError
    type.setBuiltinTypeDoc(PyRuntimeError.doc)
    type.setFlag(.baseExceptionSubclass)
    type.setFlag(.baseType)
    type.setFlag(.default)
    type.setFlag(.hasGC)
    type.setLayout(.PyRuntimeError)

    insert(type: type, name: "__class__", value: PyProperty.wrap(name: "__class__", doc: nil, get: PyRuntimeError.getClass, castSelf: Cast.asPyRuntimeError))
    insert(type: type, name: "__dict__", value: PyProperty.wrap(name: "__dict__", doc: nil, get: PyRuntimeError.getDict, castSelf: Cast.asPyRuntimeError))

    insert(type: type, name: "__new__", value: PyBuiltinFunction.wrapNew(type: type, doc: nil, fn: PyRuntimeError.pyNew(type:args:kwargs:)))
    insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PyRuntimeError.pyInit(zelf:args:kwargs:)))
  }

  // MARK: - NotImplementedError

  func fillNotImplementedError() {
    let type = self.notImplementedError
    type.setBuiltinTypeDoc(PyNotImplementedError.doc)
    type.setFlag(.baseExceptionSubclass)
    type.setFlag(.baseType)
    type.setFlag(.default)
    type.setFlag(.hasGC)
    type.setLayout(.PyNotImplementedError)

    insert(type: type, name: "__class__", value: PyProperty.wrap(name: "__class__", doc: nil, get: PyNotImplementedError.getClass, castSelf: Cast.asPyNotImplementedError))
    insert(type: type, name: "__dict__", value: PyProperty.wrap(name: "__dict__", doc: nil, get: PyNotImplementedError.getDict, castSelf: Cast.asPyNotImplementedError))

    insert(type: type, name: "__new__", value: PyBuiltinFunction.wrapNew(type: type, doc: nil, fn: PyNotImplementedError.pyNew(type:args:kwargs:)))
    insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PyNotImplementedError.pyInit(zelf:args:kwargs:)))
  }

  // MARK: - RecursionError

  func fillRecursionError() {
    let type = self.recursionError
    type.setBuiltinTypeDoc(PyRecursionError.doc)
    type.setFlag(.baseExceptionSubclass)
    type.setFlag(.baseType)
    type.setFlag(.default)
    type.setFlag(.hasGC)
    type.setLayout(.PyRecursionError)

    insert(type: type, name: "__class__", value: PyProperty.wrap(name: "__class__", doc: nil, get: PyRecursionError.getClass, castSelf: Cast.asPyRecursionError))
    insert(type: type, name: "__dict__", value: PyProperty.wrap(name: "__dict__", doc: nil, get: PyRecursionError.getDict, castSelf: Cast.asPyRecursionError))

    insert(type: type, name: "__new__", value: PyBuiltinFunction.wrapNew(type: type, doc: nil, fn: PyRecursionError.pyNew(type:args:kwargs:)))
    insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PyRecursionError.pyInit(zelf:args:kwargs:)))
  }

  // MARK: - SyntaxError

  func fillSyntaxError() {
    let type = self.syntaxError
    type.setBuiltinTypeDoc(PySyntaxError.doc)
    type.setFlag(.baseExceptionSubclass)
    type.setFlag(.baseType)
    type.setFlag(.default)
    type.setFlag(.hasGC)
    type.setLayout(.PySyntaxError)

    insert(type: type, name: "__class__", value: PyProperty.wrap(name: "__class__", doc: nil, get: PySyntaxError.getClass, castSelf: Cast.asPySyntaxError))
    insert(type: type, name: "__dict__", value: PyProperty.wrap(name: "__dict__", doc: nil, get: PySyntaxError.getDict, castSelf: Cast.asPySyntaxError))

    insert(type: type, name: "__new__", value: PyBuiltinFunction.wrapNew(type: type, doc: nil, fn: PySyntaxError.pyNew(type:args:kwargs:)))
    insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PySyntaxError.pyInit(zelf:args:kwargs:)))
  }

  // MARK: - IndentationError

  func fillIndentationError() {
    let type = self.indentationError
    type.setBuiltinTypeDoc(PyIndentationError.doc)
    type.setFlag(.baseExceptionSubclass)
    type.setFlag(.baseType)
    type.setFlag(.default)
    type.setFlag(.hasGC)
    type.setLayout(.PyIndentationError)

    insert(type: type, name: "__class__", value: PyProperty.wrap(name: "__class__", doc: nil, get: PyIndentationError.getClass, castSelf: Cast.asPyIndentationError))
    insert(type: type, name: "__dict__", value: PyProperty.wrap(name: "__dict__", doc: nil, get: PyIndentationError.getDict, castSelf: Cast.asPyIndentationError))

    insert(type: type, name: "__new__", value: PyBuiltinFunction.wrapNew(type: type, doc: nil, fn: PyIndentationError.pyNew(type:args:kwargs:)))
    insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PyIndentationError.pyInit(zelf:args:kwargs:)))
  }

  // MARK: - TabError

  func fillTabError() {
    let type = self.tabError
    type.setBuiltinTypeDoc(PyTabError.doc)
    type.setFlag(.baseExceptionSubclass)
    type.setFlag(.baseType)
    type.setFlag(.default)
    type.setFlag(.hasGC)
    type.setLayout(.PyTabError)

    insert(type: type, name: "__class__", value: PyProperty.wrap(name: "__class__", doc: nil, get: PyTabError.getClass, castSelf: Cast.asPyTabError))
    insert(type: type, name: "__dict__", value: PyProperty.wrap(name: "__dict__", doc: nil, get: PyTabError.getDict, castSelf: Cast.asPyTabError))

    insert(type: type, name: "__new__", value: PyBuiltinFunction.wrapNew(type: type, doc: nil, fn: PyTabError.pyNew(type:args:kwargs:)))
    insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PyTabError.pyInit(zelf:args:kwargs:)))
  }

  // MARK: - SystemError

  func fillSystemError() {
    let type = self.systemError
    type.setBuiltinTypeDoc(PySystemError.doc)
    type.setFlag(.baseExceptionSubclass)
    type.setFlag(.baseType)
    type.setFlag(.default)
    type.setFlag(.hasGC)
    type.setLayout(.PySystemError)

    insert(type: type, name: "__class__", value: PyProperty.wrap(name: "__class__", doc: nil, get: PySystemError.getClass, castSelf: Cast.asPySystemError))
    insert(type: type, name: "__dict__", value: PyProperty.wrap(name: "__dict__", doc: nil, get: PySystemError.getDict, castSelf: Cast.asPySystemError))

    insert(type: type, name: "__new__", value: PyBuiltinFunction.wrapNew(type: type, doc: nil, fn: PySystemError.pyNew(type:args:kwargs:)))
    insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PySystemError.pyInit(zelf:args:kwargs:)))
  }

  // MARK: - TypeError

  func fillTypeError() {
    let type = self.typeError
    type.setBuiltinTypeDoc(PyTypeError.doc)
    type.setFlag(.baseExceptionSubclass)
    type.setFlag(.baseType)
    type.setFlag(.default)
    type.setFlag(.hasGC)
    type.setLayout(.PyTypeError)

    insert(type: type, name: "__class__", value: PyProperty.wrap(name: "__class__", doc: nil, get: PyTypeError.getClass, castSelf: Cast.asPyTypeError))
    insert(type: type, name: "__dict__", value: PyProperty.wrap(name: "__dict__", doc: nil, get: PyTypeError.getDict, castSelf: Cast.asPyTypeError))

    insert(type: type, name: "__new__", value: PyBuiltinFunction.wrapNew(type: type, doc: nil, fn: PyTypeError.pyNew(type:args:kwargs:)))
    insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PyTypeError.pyInit(zelf:args:kwargs:)))
  }

  // MARK: - ValueError

  func fillValueError() {
    let type = self.valueError
    type.setBuiltinTypeDoc(PyValueError.doc)
    type.setFlag(.baseExceptionSubclass)
    type.setFlag(.baseType)
    type.setFlag(.default)
    type.setFlag(.hasGC)
    type.setLayout(.PyValueError)

    insert(type: type, name: "__class__", value: PyProperty.wrap(name: "__class__", doc: nil, get: PyValueError.getClass, castSelf: Cast.asPyValueError))
    insert(type: type, name: "__dict__", value: PyProperty.wrap(name: "__dict__", doc: nil, get: PyValueError.getDict, castSelf: Cast.asPyValueError))

    insert(type: type, name: "__new__", value: PyBuiltinFunction.wrapNew(type: type, doc: nil, fn: PyValueError.pyNew(type:args:kwargs:)))
    insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PyValueError.pyInit(zelf:args:kwargs:)))
  }

  // MARK: - UnicodeError

  func fillUnicodeError() {
    let type = self.unicodeError
    type.setBuiltinTypeDoc(PyUnicodeError.doc)
    type.setFlag(.baseExceptionSubclass)
    type.setFlag(.baseType)
    type.setFlag(.default)
    type.setFlag(.hasGC)
    type.setLayout(.PyUnicodeError)

    insert(type: type, name: "__class__", value: PyProperty.wrap(name: "__class__", doc: nil, get: PyUnicodeError.getClass, castSelf: Cast.asPyUnicodeError))
    insert(type: type, name: "__dict__", value: PyProperty.wrap(name: "__dict__", doc: nil, get: PyUnicodeError.getDict, castSelf: Cast.asPyUnicodeError))

    insert(type: type, name: "__new__", value: PyBuiltinFunction.wrapNew(type: type, doc: nil, fn: PyUnicodeError.pyNew(type:args:kwargs:)))
    insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PyUnicodeError.pyInit(zelf:args:kwargs:)))
  }

  // MARK: - UnicodeDecodeError

  func fillUnicodeDecodeError() {
    let type = self.unicodeDecodeError
    type.setBuiltinTypeDoc(PyUnicodeDecodeError.doc)
    type.setFlag(.baseExceptionSubclass)
    type.setFlag(.baseType)
    type.setFlag(.default)
    type.setFlag(.hasGC)
    type.setLayout(.PyUnicodeDecodeError)

    insert(type: type, name: "__class__", value: PyProperty.wrap(name: "__class__", doc: nil, get: PyUnicodeDecodeError.getClass, castSelf: Cast.asPyUnicodeDecodeError))
    insert(type: type, name: "__dict__", value: PyProperty.wrap(name: "__dict__", doc: nil, get: PyUnicodeDecodeError.getDict, castSelf: Cast.asPyUnicodeDecodeError))

    insert(type: type, name: "__new__", value: PyBuiltinFunction.wrapNew(type: type, doc: nil, fn: PyUnicodeDecodeError.pyNew(type:args:kwargs:)))
    insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PyUnicodeDecodeError.pyInit(zelf:args:kwargs:)))
  }

  // MARK: - UnicodeEncodeError

  func fillUnicodeEncodeError() {
    let type = self.unicodeEncodeError
    type.setBuiltinTypeDoc(PyUnicodeEncodeError.doc)
    type.setFlag(.baseExceptionSubclass)
    type.setFlag(.baseType)
    type.setFlag(.default)
    type.setFlag(.hasGC)
    type.setLayout(.PyUnicodeEncodeError)

    insert(type: type, name: "__class__", value: PyProperty.wrap(name: "__class__", doc: nil, get: PyUnicodeEncodeError.getClass, castSelf: Cast.asPyUnicodeEncodeError))
    insert(type: type, name: "__dict__", value: PyProperty.wrap(name: "__dict__", doc: nil, get: PyUnicodeEncodeError.getDict, castSelf: Cast.asPyUnicodeEncodeError))

    insert(type: type, name: "__new__", value: PyBuiltinFunction.wrapNew(type: type, doc: nil, fn: PyUnicodeEncodeError.pyNew(type:args:kwargs:)))
    insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PyUnicodeEncodeError.pyInit(zelf:args:kwargs:)))
  }

  // MARK: - UnicodeTranslateError

  func fillUnicodeTranslateError() {
    let type = self.unicodeTranslateError
    type.setBuiltinTypeDoc(PyUnicodeTranslateError.doc)
    type.setFlag(.baseExceptionSubclass)
    type.setFlag(.baseType)
    type.setFlag(.default)
    type.setFlag(.hasGC)
    type.setLayout(.PyUnicodeTranslateError)

    insert(type: type, name: "__class__", value: PyProperty.wrap(name: "__class__", doc: nil, get: PyUnicodeTranslateError.getClass, castSelf: Cast.asPyUnicodeTranslateError))
    insert(type: type, name: "__dict__", value: PyProperty.wrap(name: "__dict__", doc: nil, get: PyUnicodeTranslateError.getDict, castSelf: Cast.asPyUnicodeTranslateError))

    insert(type: type, name: "__new__", value: PyBuiltinFunction.wrapNew(type: type, doc: nil, fn: PyUnicodeTranslateError.pyNew(type:args:kwargs:)))
    insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PyUnicodeTranslateError.pyInit(zelf:args:kwargs:)))
  }

  // MARK: - Warning

  func fillWarning() {
    let type = self.warning
    type.setBuiltinTypeDoc(PyWarning.doc)
    type.setFlag(.baseExceptionSubclass)
    type.setFlag(.baseType)
    type.setFlag(.default)
    type.setFlag(.hasGC)
    type.setLayout(.PyWarning)

    insert(type: type, name: "__class__", value: PyProperty.wrap(name: "__class__", doc: nil, get: PyWarning.getClass, castSelf: Cast.asPyWarning))
    insert(type: type, name: "__dict__", value: PyProperty.wrap(name: "__dict__", doc: nil, get: PyWarning.getDict, castSelf: Cast.asPyWarning))

    insert(type: type, name: "__new__", value: PyBuiltinFunction.wrapNew(type: type, doc: nil, fn: PyWarning.pyNew(type:args:kwargs:)))
    insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PyWarning.pyInit(zelf:args:kwargs:)))
  }

  // MARK: - DeprecationWarning

  func fillDeprecationWarning() {
    let type = self.deprecationWarning
    type.setBuiltinTypeDoc(PyDeprecationWarning.doc)
    type.setFlag(.baseExceptionSubclass)
    type.setFlag(.baseType)
    type.setFlag(.default)
    type.setFlag(.hasGC)
    type.setLayout(.PyDeprecationWarning)

    insert(type: type, name: "__class__", value: PyProperty.wrap(name: "__class__", doc: nil, get: PyDeprecationWarning.getClass, castSelf: Cast.asPyDeprecationWarning))
    insert(type: type, name: "__dict__", value: PyProperty.wrap(name: "__dict__", doc: nil, get: PyDeprecationWarning.getDict, castSelf: Cast.asPyDeprecationWarning))

    insert(type: type, name: "__new__", value: PyBuiltinFunction.wrapNew(type: type, doc: nil, fn: PyDeprecationWarning.pyNew(type:args:kwargs:)))
    insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PyDeprecationWarning.pyInit(zelf:args:kwargs:)))
  }

  // MARK: - PendingDeprecationWarning

  func fillPendingDeprecationWarning() {
    let type = self.pendingDeprecationWarning
    type.setBuiltinTypeDoc(PyPendingDeprecationWarning.doc)
    type.setFlag(.baseExceptionSubclass)
    type.setFlag(.baseType)
    type.setFlag(.default)
    type.setFlag(.hasGC)
    type.setLayout(.PyPendingDeprecationWarning)

    insert(type: type, name: "__class__", value: PyProperty.wrap(name: "__class__", doc: nil, get: PyPendingDeprecationWarning.getClass, castSelf: Cast.asPyPendingDeprecationWarning))
    insert(type: type, name: "__dict__", value: PyProperty.wrap(name: "__dict__", doc: nil, get: PyPendingDeprecationWarning.getDict, castSelf: Cast.asPyPendingDeprecationWarning))

    insert(type: type, name: "__new__", value: PyBuiltinFunction.wrapNew(type: type, doc: nil, fn: PyPendingDeprecationWarning.pyNew(type:args:kwargs:)))
    insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PyPendingDeprecationWarning.pyInit(zelf:args:kwargs:)))
  }

  // MARK: - RuntimeWarning

  func fillRuntimeWarning() {
    let type = self.runtimeWarning
    type.setBuiltinTypeDoc(PyRuntimeWarning.doc)
    type.setFlag(.baseExceptionSubclass)
    type.setFlag(.baseType)
    type.setFlag(.default)
    type.setFlag(.hasGC)
    type.setLayout(.PyRuntimeWarning)

    insert(type: type, name: "__class__", value: PyProperty.wrap(name: "__class__", doc: nil, get: PyRuntimeWarning.getClass, castSelf: Cast.asPyRuntimeWarning))
    insert(type: type, name: "__dict__", value: PyProperty.wrap(name: "__dict__", doc: nil, get: PyRuntimeWarning.getDict, castSelf: Cast.asPyRuntimeWarning))

    insert(type: type, name: "__new__", value: PyBuiltinFunction.wrapNew(type: type, doc: nil, fn: PyRuntimeWarning.pyNew(type:args:kwargs:)))
    insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PyRuntimeWarning.pyInit(zelf:args:kwargs:)))
  }

  // MARK: - SyntaxWarning

  func fillSyntaxWarning() {
    let type = self.syntaxWarning
    type.setBuiltinTypeDoc(PySyntaxWarning.doc)
    type.setFlag(.baseExceptionSubclass)
    type.setFlag(.baseType)
    type.setFlag(.default)
    type.setFlag(.hasGC)
    type.setLayout(.PySyntaxWarning)

    insert(type: type, name: "__class__", value: PyProperty.wrap(name: "__class__", doc: nil, get: PySyntaxWarning.getClass, castSelf: Cast.asPySyntaxWarning))
    insert(type: type, name: "__dict__", value: PyProperty.wrap(name: "__dict__", doc: nil, get: PySyntaxWarning.getDict, castSelf: Cast.asPySyntaxWarning))

    insert(type: type, name: "__new__", value: PyBuiltinFunction.wrapNew(type: type, doc: nil, fn: PySyntaxWarning.pyNew(type:args:kwargs:)))
    insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PySyntaxWarning.pyInit(zelf:args:kwargs:)))
  }

  // MARK: - UserWarning

  func fillUserWarning() {
    let type = self.userWarning
    type.setBuiltinTypeDoc(PyUserWarning.doc)
    type.setFlag(.baseExceptionSubclass)
    type.setFlag(.baseType)
    type.setFlag(.default)
    type.setFlag(.hasGC)
    type.setLayout(.PyUserWarning)

    insert(type: type, name: "__class__", value: PyProperty.wrap(name: "__class__", doc: nil, get: PyUserWarning.getClass, castSelf: Cast.asPyUserWarning))
    insert(type: type, name: "__dict__", value: PyProperty.wrap(name: "__dict__", doc: nil, get: PyUserWarning.getDict, castSelf: Cast.asPyUserWarning))

    insert(type: type, name: "__new__", value: PyBuiltinFunction.wrapNew(type: type, doc: nil, fn: PyUserWarning.pyNew(type:args:kwargs:)))
    insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PyUserWarning.pyInit(zelf:args:kwargs:)))
  }

  // MARK: - FutureWarning

  func fillFutureWarning() {
    let type = self.futureWarning
    type.setBuiltinTypeDoc(PyFutureWarning.doc)
    type.setFlag(.baseExceptionSubclass)
    type.setFlag(.baseType)
    type.setFlag(.default)
    type.setFlag(.hasGC)
    type.setLayout(.PyFutureWarning)

    insert(type: type, name: "__class__", value: PyProperty.wrap(name: "__class__", doc: nil, get: PyFutureWarning.getClass, castSelf: Cast.asPyFutureWarning))
    insert(type: type, name: "__dict__", value: PyProperty.wrap(name: "__dict__", doc: nil, get: PyFutureWarning.getDict, castSelf: Cast.asPyFutureWarning))

    insert(type: type, name: "__new__", value: PyBuiltinFunction.wrapNew(type: type, doc: nil, fn: PyFutureWarning.pyNew(type:args:kwargs:)))
    insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PyFutureWarning.pyInit(zelf:args:kwargs:)))
  }

  // MARK: - ImportWarning

  func fillImportWarning() {
    let type = self.importWarning
    type.setBuiltinTypeDoc(PyImportWarning.doc)
    type.setFlag(.baseExceptionSubclass)
    type.setFlag(.baseType)
    type.setFlag(.default)
    type.setFlag(.hasGC)
    type.setLayout(.PyImportWarning)

    insert(type: type, name: "__class__", value: PyProperty.wrap(name: "__class__", doc: nil, get: PyImportWarning.getClass, castSelf: Cast.asPyImportWarning))
    insert(type: type, name: "__dict__", value: PyProperty.wrap(name: "__dict__", doc: nil, get: PyImportWarning.getDict, castSelf: Cast.asPyImportWarning))

    insert(type: type, name: "__new__", value: PyBuiltinFunction.wrapNew(type: type, doc: nil, fn: PyImportWarning.pyNew(type:args:kwargs:)))
    insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PyImportWarning.pyInit(zelf:args:kwargs:)))
  }

  // MARK: - UnicodeWarning

  func fillUnicodeWarning() {
    let type = self.unicodeWarning
    type.setBuiltinTypeDoc(PyUnicodeWarning.doc)
    type.setFlag(.baseExceptionSubclass)
    type.setFlag(.baseType)
    type.setFlag(.default)
    type.setFlag(.hasGC)
    type.setLayout(.PyUnicodeWarning)

    insert(type: type, name: "__class__", value: PyProperty.wrap(name: "__class__", doc: nil, get: PyUnicodeWarning.getClass, castSelf: Cast.asPyUnicodeWarning))
    insert(type: type, name: "__dict__", value: PyProperty.wrap(name: "__dict__", doc: nil, get: PyUnicodeWarning.getDict, castSelf: Cast.asPyUnicodeWarning))

    insert(type: type, name: "__new__", value: PyBuiltinFunction.wrapNew(type: type, doc: nil, fn: PyUnicodeWarning.pyNew(type:args:kwargs:)))
    insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PyUnicodeWarning.pyInit(zelf:args:kwargs:)))
  }

  // MARK: - BytesWarning

  func fillBytesWarning() {
    let type = self.bytesWarning
    type.setBuiltinTypeDoc(PyBytesWarning.doc)
    type.setFlag(.baseExceptionSubclass)
    type.setFlag(.baseType)
    type.setFlag(.default)
    type.setFlag(.hasGC)
    type.setLayout(.PyBytesWarning)

    insert(type: type, name: "__class__", value: PyProperty.wrap(name: "__class__", doc: nil, get: PyBytesWarning.getClass, castSelf: Cast.asPyBytesWarning))
    insert(type: type, name: "__dict__", value: PyProperty.wrap(name: "__dict__", doc: nil, get: PyBytesWarning.getDict, castSelf: Cast.asPyBytesWarning))

    insert(type: type, name: "__new__", value: PyBuiltinFunction.wrapNew(type: type, doc: nil, fn: PyBytesWarning.pyNew(type:args:kwargs:)))
    insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PyBytesWarning.pyInit(zelf:args:kwargs:)))
  }

  // MARK: - ResourceWarning

  func fillResourceWarning() {
    let type = self.resourceWarning
    type.setBuiltinTypeDoc(PyResourceWarning.doc)
    type.setFlag(.baseExceptionSubclass)
    type.setFlag(.baseType)
    type.setFlag(.default)
    type.setFlag(.hasGC)
    type.setLayout(.PyResourceWarning)

    insert(type: type, name: "__class__", value: PyProperty.wrap(name: "__class__", doc: nil, get: PyResourceWarning.getClass, castSelf: Cast.asPyResourceWarning))
    insert(type: type, name: "__dict__", value: PyProperty.wrap(name: "__dict__", doc: nil, get: PyResourceWarning.getDict, castSelf: Cast.asPyResourceWarning))

    insert(type: type, name: "__new__", value: PyBuiltinFunction.wrapNew(type: type, doc: nil, fn: PyResourceWarning.pyNew(type:args:kwargs:)))
    insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PyResourceWarning.pyInit(zelf:args:kwargs:)))
  }

}
