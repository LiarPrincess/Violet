// ==============================================================================
// Automatically generated from: ./Sources/Objects/Generated/BuiltinErrorTypes.py
// DO NOT EDIT!
// ==============================================================================

import VioletCore

// swiftlint:disable line_length
// swiftlint:disable function_body_length
// swiftlint:disable trailing_comma
// swiftlint:disable vertical_whitespace_closing_braces
// swiftlint:disable file_length

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
    self.baseException = PyType.initBuiltinType(name: "BaseException", type: types.type, base: types.object, layout: .PyBaseException)
    self.systemExit = PyType.initBuiltinType(name: "SystemExit", type: types.type, base: self.baseException, layout: .PySystemExit)
    self.keyboardInterrupt = PyType.initBuiltinType(name: "KeyboardInterrupt", type: types.type, base: self.baseException, layout: .PyKeyboardInterrupt)
    self.generatorExit = PyType.initBuiltinType(name: "GeneratorExit", type: types.type, base: self.baseException, layout: .PyGeneratorExit)
    self.exception = PyType.initBuiltinType(name: "Exception", type: types.type, base: self.baseException, layout: .PyException)
    self.stopIteration = PyType.initBuiltinType(name: "StopIteration", type: types.type, base: self.exception, layout: .PyStopIteration)
    self.stopAsyncIteration = PyType.initBuiltinType(name: "StopAsyncIteration", type: types.type, base: self.exception, layout: .PyStopAsyncIteration)
    self.arithmeticError = PyType.initBuiltinType(name: "ArithmeticError", type: types.type, base: self.exception, layout: .PyArithmeticError)
    self.floatingPointError = PyType.initBuiltinType(name: "FloatingPointError", type: types.type, base: self.arithmeticError, layout: .PyFloatingPointError)
    self.overflowError = PyType.initBuiltinType(name: "OverflowError", type: types.type, base: self.arithmeticError, layout: .PyOverflowError)
    self.zeroDivisionError = PyType.initBuiltinType(name: "ZeroDivisionError", type: types.type, base: self.arithmeticError, layout: .PyZeroDivisionError)
    self.assertionError = PyType.initBuiltinType(name: "AssertionError", type: types.type, base: self.exception, layout: .PyAssertionError)
    self.attributeError = PyType.initBuiltinType(name: "AttributeError", type: types.type, base: self.exception, layout: .PyAttributeError)
    self.bufferError = PyType.initBuiltinType(name: "BufferError", type: types.type, base: self.exception, layout: .PyBufferError)
    self.eofError = PyType.initBuiltinType(name: "EOFError", type: types.type, base: self.exception, layout: .PyEOFError)
    self.importError = PyType.initBuiltinType(name: "ImportError", type: types.type, base: self.exception, layout: .PyImportError)
    self.moduleNotFoundError = PyType.initBuiltinType(name: "ModuleNotFoundError", type: types.type, base: self.importError, layout: .PyModuleNotFoundError)
    self.lookupError = PyType.initBuiltinType(name: "LookupError", type: types.type, base: self.exception, layout: .PyLookupError)
    self.indexError = PyType.initBuiltinType(name: "IndexError", type: types.type, base: self.lookupError, layout: .PyIndexError)
    self.keyError = PyType.initBuiltinType(name: "KeyError", type: types.type, base: self.lookupError, layout: .PyKeyError)
    self.memoryError = PyType.initBuiltinType(name: "MemoryError", type: types.type, base: self.exception, layout: .PyMemoryError)
    self.nameError = PyType.initBuiltinType(name: "NameError", type: types.type, base: self.exception, layout: .PyNameError)
    self.unboundLocalError = PyType.initBuiltinType(name: "UnboundLocalError", type: types.type, base: self.nameError, layout: .PyUnboundLocalError)
    self.osError = PyType.initBuiltinType(name: "OSError", type: types.type, base: self.exception, layout: .PyOSError)
    self.blockingIOError = PyType.initBuiltinType(name: "BlockingIOError", type: types.type, base: self.osError, layout: .PyBlockingIOError)
    self.childProcessError = PyType.initBuiltinType(name: "ChildProcessError", type: types.type, base: self.osError, layout: .PyChildProcessError)
    self.connectionError = PyType.initBuiltinType(name: "ConnectionError", type: types.type, base: self.osError, layout: .PyConnectionError)
    self.brokenPipeError = PyType.initBuiltinType(name: "BrokenPipeError", type: types.type, base: self.connectionError, layout: .PyBrokenPipeError)
    self.connectionAbortedError = PyType.initBuiltinType(name: "ConnectionAbortedError", type: types.type, base: self.connectionError, layout: .PyConnectionAbortedError)
    self.connectionRefusedError = PyType.initBuiltinType(name: "ConnectionRefusedError", type: types.type, base: self.connectionError, layout: .PyConnectionRefusedError)
    self.connectionResetError = PyType.initBuiltinType(name: "ConnectionResetError", type: types.type, base: self.connectionError, layout: .PyConnectionResetError)
    self.fileExistsError = PyType.initBuiltinType(name: "FileExistsError", type: types.type, base: self.osError, layout: .PyFileExistsError)
    self.fileNotFoundError = PyType.initBuiltinType(name: "FileNotFoundError", type: types.type, base: self.osError, layout: .PyFileNotFoundError)
    self.interruptedError = PyType.initBuiltinType(name: "InterruptedError", type: types.type, base: self.osError, layout: .PyInterruptedError)
    self.isADirectoryError = PyType.initBuiltinType(name: "IsADirectoryError", type: types.type, base: self.osError, layout: .PyIsADirectoryError)
    self.notADirectoryError = PyType.initBuiltinType(name: "NotADirectoryError", type: types.type, base: self.osError, layout: .PyNotADirectoryError)
    self.permissionError = PyType.initBuiltinType(name: "PermissionError", type: types.type, base: self.osError, layout: .PyPermissionError)
    self.processLookupError = PyType.initBuiltinType(name: "ProcessLookupError", type: types.type, base: self.osError, layout: .PyProcessLookupError)
    self.timeoutError = PyType.initBuiltinType(name: "TimeoutError", type: types.type, base: self.osError, layout: .PyTimeoutError)
    self.referenceError = PyType.initBuiltinType(name: "ReferenceError", type: types.type, base: self.exception, layout: .PyReferenceError)
    self.runtimeError = PyType.initBuiltinType(name: "RuntimeError", type: types.type, base: self.exception, layout: .PyRuntimeError)
    self.notImplementedError = PyType.initBuiltinType(name: "NotImplementedError", type: types.type, base: self.runtimeError, layout: .PyNotImplementedError)
    self.recursionError = PyType.initBuiltinType(name: "RecursionError", type: types.type, base: self.runtimeError, layout: .PyRecursionError)
    self.syntaxError = PyType.initBuiltinType(name: "SyntaxError", type: types.type, base: self.exception, layout: .PySyntaxError)
    self.indentationError = PyType.initBuiltinType(name: "IndentationError", type: types.type, base: self.syntaxError, layout: .PyIndentationError)
    self.tabError = PyType.initBuiltinType(name: "TabError", type: types.type, base: self.indentationError, layout: .PyTabError)
    self.systemError = PyType.initBuiltinType(name: "SystemError", type: types.type, base: self.exception, layout: .PySystemError)
    self.typeError = PyType.initBuiltinType(name: "TypeError", type: types.type, base: self.exception, layout: .PyTypeError)
    self.valueError = PyType.initBuiltinType(name: "ValueError", type: types.type, base: self.exception, layout: .PyValueError)
    self.unicodeError = PyType.initBuiltinType(name: "UnicodeError", type: types.type, base: self.valueError, layout: .PyUnicodeError)
    self.unicodeDecodeError = PyType.initBuiltinType(name: "UnicodeDecodeError", type: types.type, base: self.unicodeError, layout: .PyUnicodeDecodeError)
    self.unicodeEncodeError = PyType.initBuiltinType(name: "UnicodeEncodeError", type: types.type, base: self.unicodeError, layout: .PyUnicodeEncodeError)
    self.unicodeTranslateError = PyType.initBuiltinType(name: "UnicodeTranslateError", type: types.type, base: self.unicodeError, layout: .PyUnicodeTranslateError)
    self.warning = PyType.initBuiltinType(name: "Warning", type: types.type, base: self.exception, layout: .PyWarning)
    self.deprecationWarning = PyType.initBuiltinType(name: "DeprecationWarning", type: types.type, base: self.warning, layout: .PyDeprecationWarning)
    self.pendingDeprecationWarning = PyType.initBuiltinType(name: "PendingDeprecationWarning", type: types.type, base: self.warning, layout: .PyPendingDeprecationWarning)
    self.runtimeWarning = PyType.initBuiltinType(name: "RuntimeWarning", type: types.type, base: self.warning, layout: .PyRuntimeWarning)
    self.syntaxWarning = PyType.initBuiltinType(name: "SyntaxWarning", type: types.type, base: self.warning, layout: .PySyntaxWarning)
    self.userWarning = PyType.initBuiltinType(name: "UserWarning", type: types.type, base: self.warning, layout: .PyUserWarning)
    self.futureWarning = PyType.initBuiltinType(name: "FutureWarning", type: types.type, base: self.warning, layout: .PyFutureWarning)
    self.importWarning = PyType.initBuiltinType(name: "ImportWarning", type: types.type, base: self.warning, layout: .PyImportWarning)
    self.unicodeWarning = PyType.initBuiltinType(name: "UnicodeWarning", type: types.type, base: self.warning, layout: .PyUnicodeWarning)
    self.bytesWarning = PyType.initBuiltinType(name: "BytesWarning", type: types.type, base: self.warning, layout: .PyBytesWarning)
    self.resourceWarning = PyType.initBuiltinType(name: "ResourceWarning", type: types.type, base: self.warning, layout: .PyResourceWarning)
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

  // MARK: - Helpers

  /// Insert value to type '__dict__'.
  private func insert(type: PyType, name: String, value: PyObject) {
    let dict = type.getDict()
    let interned = Py.intern(string: name)

    switch dict.set(key: interned, to: value) {
    case .ok:
      break
    case .error(let e):
      let typeName = type.getNameString()
      trap("Error when inserting '\(name)' to '\(typeName)' type: \(e)")
    }
  }

  // MARK: - BaseException

  private func fillBaseException() {
    let type = self.baseException
    type.setBuiltinTypeDoc(PyBaseException.doc)
    type.flags.set(PyType.baseExceptionSubclassFlag)
    type.flags.set(PyType.baseTypeFlag)
    type.flags.set(PyType.defaultFlag)
    type.flags.set(PyType.hasGCFlag)

    self.insert(type: type, name: "__dict__", value: PyProperty.wrap(doc: nil, get: PyBaseException.getDict, castSelf: Self.asBaseException))
    self.insert(type: type, name: "__class__", value: PyProperty.wrap(doc: nil, get: PyBaseException.getClass, castSelf: Self.asBaseException))
    self.insert(type: type, name: "args", value: PyProperty.wrap(doc: nil, get: PyBaseException.getArgs, set: PyBaseException.setArgs, castSelf: Self.asBaseException))
    self.insert(type: type, name: "__traceback__", value: PyProperty.wrap(doc: nil, get: PyBaseException.getTraceback, set: PyBaseException.setTraceback, castSelf: Self.asBaseException))
    self.insert(type: type, name: "__cause__", value: PyProperty.wrap(doc: PyBaseException.getCauseDoc, get: PyBaseException.getCause, set: PyBaseException.setCause, castSelf: Self.asBaseException))
    self.insert(type: type, name: "__context__", value: PyProperty.wrap(doc: PyBaseException.getContextDoc, get: PyBaseException.getContext, set: PyBaseException.setContext, castSelf: Self.asBaseException))
    self.insert(type: type, name: "__suppress_context__", value: PyProperty.wrap(doc: nil, get: PyBaseException.getSuppressContext, set: PyBaseException.setSuppressContext, castSelf: Self.asBaseException))

    self.insert(type: type, name: "__new__", value: PyStaticMethod.wrapNew(type: type, doc: nil, fn: PyBaseException.pyBaseExceptionNew(type:args:kwargs:)))
    self.insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PyBaseException.pyBaseExceptionInit(args:kwargs:), castSelf: Self.asBaseExceptionOptional))

    self.insert(type: type, name: "__repr__", value: PyBuiltinFunction.wrap(name: "__repr__", doc: nil, fn: PyBaseException.repr, castSelf: Self.asBaseException))
    self.insert(type: type, name: "__str__", value: PyBuiltinFunction.wrap(name: "__str__", doc: nil, fn: PyBaseException.str(baseException:), castSelf: Self.asBaseException))
    self.insert(type: type, name: "__getattribute__", value: PyBuiltinFunction.wrap(name: "__getattribute__", doc: nil, fn: PyBaseException.getAttribute(name:), castSelf: Self.asBaseException))
    self.insert(type: type, name: "__setattr__", value: PyBuiltinFunction.wrap(name: "__setattr__", doc: nil, fn: PyBaseException.setAttribute(name:value:), castSelf: Self.asBaseException))
    self.insert(type: type, name: "__delattr__", value: PyBuiltinFunction.wrap(name: "__delattr__", doc: nil, fn: PyBaseException.delAttribute(name:), castSelf: Self.asBaseException))
    self.insert(type: type, name: "with_traceback", value: PyBuiltinFunction.wrap(name: "with_traceback", doc: PyBaseException.withTracebackDoc, fn: PyBaseException.withTraceback(traceback:), castSelf: Self.asBaseException))
  }

  private static func asBaseException(functionName: String, object: PyObject) -> PyResult<PyBaseException> {
    switch PyCast.asBaseException(object) {
    case .some(let o):
        return .value(o)
    case .none:
      return .typeError(
        "descriptor '\(functionName)' requires a 'BaseException' object " +
        "but received a '\(object.typeName)'"
      )
    }
  }

  private static func asBaseExceptionOptional(object: PyObject) -> PyBaseException? {
    return PyCast.asBaseException(object)
  }

  // MARK: - SystemExit

  private func fillSystemExit() {
    let type = self.systemExit
    type.setBuiltinTypeDoc(PySystemExit.doc)
    type.flags.set(PyType.baseExceptionSubclassFlag)
    type.flags.set(PyType.baseTypeFlag)
    type.flags.set(PyType.defaultFlag)
    type.flags.set(PyType.hasGCFlag)

    self.insert(type: type, name: "__class__", value: PyProperty.wrap(doc: nil, get: PySystemExit.getClass, castSelf: Self.asSystemExit))
    self.insert(type: type, name: "__dict__", value: PyProperty.wrap(doc: nil, get: PySystemExit.getDict, castSelf: Self.asSystemExit))
    self.insert(type: type, name: "code", value: PyProperty.wrap(doc: nil, get: PySystemExit.getCode, set: PySystemExit.setCode, castSelf: Self.asSystemExit))

    self.insert(type: type, name: "__new__", value: PyStaticMethod.wrapNew(type: type, doc: nil, fn: PySystemExit.pySystemExitNew(type:args:kwargs:)))
    self.insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PySystemExit.pySystemExitInit(args:kwargs:), castSelf: Self.asSystemExitOptional))
  }

  private static func asSystemExit(functionName: String, object: PyObject) -> PyResult<PySystemExit> {
    switch PyCast.asSystemExit(object) {
    case .some(let o):
        return .value(o)
    case .none:
      return .typeError(
        "descriptor '\(functionName)' requires a 'SystemExit' object " +
        "but received a '\(object.typeName)'"
      )
    }
  }

  private static func asSystemExitOptional(object: PyObject) -> PySystemExit? {
    return PyCast.asSystemExit(object)
  }

  // MARK: - KeyboardInterrupt

  private func fillKeyboardInterrupt() {
    let type = self.keyboardInterrupt
    type.setBuiltinTypeDoc(PyKeyboardInterrupt.doc)
    type.flags.set(PyType.baseExceptionSubclassFlag)
    type.flags.set(PyType.baseTypeFlag)
    type.flags.set(PyType.defaultFlag)
    type.flags.set(PyType.hasGCFlag)

    self.insert(type: type, name: "__class__", value: PyProperty.wrap(doc: nil, get: PyKeyboardInterrupt.getClass, castSelf: Self.asKeyboardInterrupt))
    self.insert(type: type, name: "__dict__", value: PyProperty.wrap(doc: nil, get: PyKeyboardInterrupt.getDict, castSelf: Self.asKeyboardInterrupt))

    self.insert(type: type, name: "__new__", value: PyStaticMethod.wrapNew(type: type, doc: nil, fn: PyKeyboardInterrupt.pyKeyboardInterruptNew(type:args:kwargs:)))
    self.insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PyKeyboardInterrupt.pyKeyboardInterruptInit(args:kwargs:), castSelf: Self.asKeyboardInterruptOptional))
  }

  private static func asKeyboardInterrupt(functionName: String, object: PyObject) -> PyResult<PyKeyboardInterrupt> {
    switch PyCast.asKeyboardInterrupt(object) {
    case .some(let o):
        return .value(o)
    case .none:
      return .typeError(
        "descriptor '\(functionName)' requires a 'KeyboardInterrupt' object " +
        "but received a '\(object.typeName)'"
      )
    }
  }

  private static func asKeyboardInterruptOptional(object: PyObject) -> PyKeyboardInterrupt? {
    return PyCast.asKeyboardInterrupt(object)
  }

  // MARK: - GeneratorExit

  private func fillGeneratorExit() {
    let type = self.generatorExit
    type.setBuiltinTypeDoc(PyGeneratorExit.doc)
    type.flags.set(PyType.baseExceptionSubclassFlag)
    type.flags.set(PyType.baseTypeFlag)
    type.flags.set(PyType.defaultFlag)
    type.flags.set(PyType.hasGCFlag)

    self.insert(type: type, name: "__class__", value: PyProperty.wrap(doc: nil, get: PyGeneratorExit.getClass, castSelf: Self.asGeneratorExit))
    self.insert(type: type, name: "__dict__", value: PyProperty.wrap(doc: nil, get: PyGeneratorExit.getDict, castSelf: Self.asGeneratorExit))

    self.insert(type: type, name: "__new__", value: PyStaticMethod.wrapNew(type: type, doc: nil, fn: PyGeneratorExit.pyGeneratorExitNew(type:args:kwargs:)))
    self.insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PyGeneratorExit.pyGeneratorExitInit(args:kwargs:), castSelf: Self.asGeneratorExitOptional))
  }

  private static func asGeneratorExit(functionName: String, object: PyObject) -> PyResult<PyGeneratorExit> {
    switch PyCast.asGeneratorExit(object) {
    case .some(let o):
        return .value(o)
    case .none:
      return .typeError(
        "descriptor '\(functionName)' requires a 'GeneratorExit' object " +
        "but received a '\(object.typeName)'"
      )
    }
  }

  private static func asGeneratorExitOptional(object: PyObject) -> PyGeneratorExit? {
    return PyCast.asGeneratorExit(object)
  }

  // MARK: - Exception

  private func fillException() {
    let type = self.exception
    type.setBuiltinTypeDoc(PyException.doc)
    type.flags.set(PyType.baseExceptionSubclassFlag)
    type.flags.set(PyType.baseTypeFlag)
    type.flags.set(PyType.defaultFlag)
    type.flags.set(PyType.hasGCFlag)

    self.insert(type: type, name: "__class__", value: PyProperty.wrap(doc: nil, get: PyException.getClass, castSelf: Self.asException))
    self.insert(type: type, name: "__dict__", value: PyProperty.wrap(doc: nil, get: PyException.getDict, castSelf: Self.asException))

    self.insert(type: type, name: "__new__", value: PyStaticMethod.wrapNew(type: type, doc: nil, fn: PyException.pyExceptionNew(type:args:kwargs:)))
    self.insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PyException.pyExceptionInit(args:kwargs:), castSelf: Self.asExceptionOptional))
  }

  private static func asException(functionName: String, object: PyObject) -> PyResult<PyException> {
    switch PyCast.asException(object) {
    case .some(let o):
        return .value(o)
    case .none:
      return .typeError(
        "descriptor '\(functionName)' requires a 'Exception' object " +
        "but received a '\(object.typeName)'"
      )
    }
  }

  private static func asExceptionOptional(object: PyObject) -> PyException? {
    return PyCast.asException(object)
  }

  // MARK: - StopIteration

  private func fillStopIteration() {
    let type = self.stopIteration
    type.setBuiltinTypeDoc(PyStopIteration.doc)
    type.flags.set(PyType.baseExceptionSubclassFlag)
    type.flags.set(PyType.baseTypeFlag)
    type.flags.set(PyType.defaultFlag)
    type.flags.set(PyType.hasGCFlag)

    self.insert(type: type, name: "__class__", value: PyProperty.wrap(doc: nil, get: PyStopIteration.getClass, castSelf: Self.asStopIteration))
    self.insert(type: type, name: "__dict__", value: PyProperty.wrap(doc: nil, get: PyStopIteration.getDict, castSelf: Self.asStopIteration))
    self.insert(type: type, name: "value", value: PyProperty.wrap(doc: nil, get: PyStopIteration.getValue, set: PyStopIteration.setValue, castSelf: Self.asStopIteration))

    self.insert(type: type, name: "__new__", value: PyStaticMethod.wrapNew(type: type, doc: nil, fn: PyStopIteration.pyStopIterationNew(type:args:kwargs:)))
    self.insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PyStopIteration.pyStopIterationInit(args:kwargs:), castSelf: Self.asStopIterationOptional))
  }

  private static func asStopIteration(functionName: String, object: PyObject) -> PyResult<PyStopIteration> {
    switch PyCast.asStopIteration(object) {
    case .some(let o):
        return .value(o)
    case .none:
      return .typeError(
        "descriptor '\(functionName)' requires a 'StopIteration' object " +
        "but received a '\(object.typeName)'"
      )
    }
  }

  private static func asStopIterationOptional(object: PyObject) -> PyStopIteration? {
    return PyCast.asStopIteration(object)
  }

  // MARK: - StopAsyncIteration

  private func fillStopAsyncIteration() {
    let type = self.stopAsyncIteration
    type.setBuiltinTypeDoc(PyStopAsyncIteration.doc)
    type.flags.set(PyType.baseExceptionSubclassFlag)
    type.flags.set(PyType.baseTypeFlag)
    type.flags.set(PyType.defaultFlag)
    type.flags.set(PyType.hasGCFlag)

    self.insert(type: type, name: "__class__", value: PyProperty.wrap(doc: nil, get: PyStopAsyncIteration.getClass, castSelf: Self.asStopAsyncIteration))
    self.insert(type: type, name: "__dict__", value: PyProperty.wrap(doc: nil, get: PyStopAsyncIteration.getDict, castSelf: Self.asStopAsyncIteration))

    self.insert(type: type, name: "__new__", value: PyStaticMethod.wrapNew(type: type, doc: nil, fn: PyStopAsyncIteration.pyStopAsyncIterationNew(type:args:kwargs:)))
    self.insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PyStopAsyncIteration.pyStopAsyncIterationInit(args:kwargs:), castSelf: Self.asStopAsyncIterationOptional))
  }

  private static func asStopAsyncIteration(functionName: String, object: PyObject) -> PyResult<PyStopAsyncIteration> {
    switch PyCast.asStopAsyncIteration(object) {
    case .some(let o):
        return .value(o)
    case .none:
      return .typeError(
        "descriptor '\(functionName)' requires a 'StopAsyncIteration' object " +
        "but received a '\(object.typeName)'"
      )
    }
  }

  private static func asStopAsyncIterationOptional(object: PyObject) -> PyStopAsyncIteration? {
    return PyCast.asStopAsyncIteration(object)
  }

  // MARK: - ArithmeticError

  private func fillArithmeticError() {
    let type = self.arithmeticError
    type.setBuiltinTypeDoc(PyArithmeticError.doc)
    type.flags.set(PyType.baseExceptionSubclassFlag)
    type.flags.set(PyType.baseTypeFlag)
    type.flags.set(PyType.defaultFlag)
    type.flags.set(PyType.hasGCFlag)

    self.insert(type: type, name: "__class__", value: PyProperty.wrap(doc: nil, get: PyArithmeticError.getClass, castSelf: Self.asArithmeticError))
    self.insert(type: type, name: "__dict__", value: PyProperty.wrap(doc: nil, get: PyArithmeticError.getDict, castSelf: Self.asArithmeticError))

    self.insert(type: type, name: "__new__", value: PyStaticMethod.wrapNew(type: type, doc: nil, fn: PyArithmeticError.pyArithmeticErrorNew(type:args:kwargs:)))
    self.insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PyArithmeticError.pyArithmeticErrorInit(args:kwargs:), castSelf: Self.asArithmeticErrorOptional))
  }

  private static func asArithmeticError(functionName: String, object: PyObject) -> PyResult<PyArithmeticError> {
    switch PyCast.asArithmeticError(object) {
    case .some(let o):
        return .value(o)
    case .none:
      return .typeError(
        "descriptor '\(functionName)' requires a 'ArithmeticError' object " +
        "but received a '\(object.typeName)'"
      )
    }
  }

  private static func asArithmeticErrorOptional(object: PyObject) -> PyArithmeticError? {
    return PyCast.asArithmeticError(object)
  }

  // MARK: - FloatingPointError

  private func fillFloatingPointError() {
    let type = self.floatingPointError
    type.setBuiltinTypeDoc(PyFloatingPointError.doc)
    type.flags.set(PyType.baseExceptionSubclassFlag)
    type.flags.set(PyType.baseTypeFlag)
    type.flags.set(PyType.defaultFlag)
    type.flags.set(PyType.hasGCFlag)

    self.insert(type: type, name: "__class__", value: PyProperty.wrap(doc: nil, get: PyFloatingPointError.getClass, castSelf: Self.asFloatingPointError))
    self.insert(type: type, name: "__dict__", value: PyProperty.wrap(doc: nil, get: PyFloatingPointError.getDict, castSelf: Self.asFloatingPointError))

    self.insert(type: type, name: "__new__", value: PyStaticMethod.wrapNew(type: type, doc: nil, fn: PyFloatingPointError.pyFloatingPointErrorNew(type:args:kwargs:)))
    self.insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PyFloatingPointError.pyFloatingPointErrorInit(args:kwargs:), castSelf: Self.asFloatingPointErrorOptional))
  }

  private static func asFloatingPointError(functionName: String, object: PyObject) -> PyResult<PyFloatingPointError> {
    switch PyCast.asFloatingPointError(object) {
    case .some(let o):
        return .value(o)
    case .none:
      return .typeError(
        "descriptor '\(functionName)' requires a 'FloatingPointError' object " +
        "but received a '\(object.typeName)'"
      )
    }
  }

  private static func asFloatingPointErrorOptional(object: PyObject) -> PyFloatingPointError? {
    return PyCast.asFloatingPointError(object)
  }

  // MARK: - OverflowError

  private func fillOverflowError() {
    let type = self.overflowError
    type.setBuiltinTypeDoc(PyOverflowError.doc)
    type.flags.set(PyType.baseExceptionSubclassFlag)
    type.flags.set(PyType.baseTypeFlag)
    type.flags.set(PyType.defaultFlag)
    type.flags.set(PyType.hasGCFlag)

    self.insert(type: type, name: "__class__", value: PyProperty.wrap(doc: nil, get: PyOverflowError.getClass, castSelf: Self.asOverflowError))
    self.insert(type: type, name: "__dict__", value: PyProperty.wrap(doc: nil, get: PyOverflowError.getDict, castSelf: Self.asOverflowError))

    self.insert(type: type, name: "__new__", value: PyStaticMethod.wrapNew(type: type, doc: nil, fn: PyOverflowError.pyOverflowErrorNew(type:args:kwargs:)))
    self.insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PyOverflowError.pyOverflowErrorInit(args:kwargs:), castSelf: Self.asOverflowErrorOptional))
  }

  private static func asOverflowError(functionName: String, object: PyObject) -> PyResult<PyOverflowError> {
    switch PyCast.asOverflowError(object) {
    case .some(let o):
        return .value(o)
    case .none:
      return .typeError(
        "descriptor '\(functionName)' requires a 'OverflowError' object " +
        "but received a '\(object.typeName)'"
      )
    }
  }

  private static func asOverflowErrorOptional(object: PyObject) -> PyOverflowError? {
    return PyCast.asOverflowError(object)
  }

  // MARK: - ZeroDivisionError

  private func fillZeroDivisionError() {
    let type = self.zeroDivisionError
    type.setBuiltinTypeDoc(PyZeroDivisionError.doc)
    type.flags.set(PyType.baseExceptionSubclassFlag)
    type.flags.set(PyType.baseTypeFlag)
    type.flags.set(PyType.defaultFlag)
    type.flags.set(PyType.hasGCFlag)

    self.insert(type: type, name: "__class__", value: PyProperty.wrap(doc: nil, get: PyZeroDivisionError.getClass, castSelf: Self.asZeroDivisionError))
    self.insert(type: type, name: "__dict__", value: PyProperty.wrap(doc: nil, get: PyZeroDivisionError.getDict, castSelf: Self.asZeroDivisionError))

    self.insert(type: type, name: "__new__", value: PyStaticMethod.wrapNew(type: type, doc: nil, fn: PyZeroDivisionError.pyZeroDivisionErrorNew(type:args:kwargs:)))
    self.insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PyZeroDivisionError.pyZeroDivisionErrorInit(args:kwargs:), castSelf: Self.asZeroDivisionErrorOptional))
  }

  private static func asZeroDivisionError(functionName: String, object: PyObject) -> PyResult<PyZeroDivisionError> {
    switch PyCast.asZeroDivisionError(object) {
    case .some(let o):
        return .value(o)
    case .none:
      return .typeError(
        "descriptor '\(functionName)' requires a 'ZeroDivisionError' object " +
        "but received a '\(object.typeName)'"
      )
    }
  }

  private static func asZeroDivisionErrorOptional(object: PyObject) -> PyZeroDivisionError? {
    return PyCast.asZeroDivisionError(object)
  }

  // MARK: - AssertionError

  private func fillAssertionError() {
    let type = self.assertionError
    type.setBuiltinTypeDoc(PyAssertionError.doc)
    type.flags.set(PyType.baseExceptionSubclassFlag)
    type.flags.set(PyType.baseTypeFlag)
    type.flags.set(PyType.defaultFlag)
    type.flags.set(PyType.hasGCFlag)

    self.insert(type: type, name: "__class__", value: PyProperty.wrap(doc: nil, get: PyAssertionError.getClass, castSelf: Self.asAssertionError))
    self.insert(type: type, name: "__dict__", value: PyProperty.wrap(doc: nil, get: PyAssertionError.getDict, castSelf: Self.asAssertionError))

    self.insert(type: type, name: "__new__", value: PyStaticMethod.wrapNew(type: type, doc: nil, fn: PyAssertionError.pyAssertionErrorNew(type:args:kwargs:)))
    self.insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PyAssertionError.pyAssertionErrorInit(args:kwargs:), castSelf: Self.asAssertionErrorOptional))
  }

  private static func asAssertionError(functionName: String, object: PyObject) -> PyResult<PyAssertionError> {
    switch PyCast.asAssertionError(object) {
    case .some(let o):
        return .value(o)
    case .none:
      return .typeError(
        "descriptor '\(functionName)' requires a 'AssertionError' object " +
        "but received a '\(object.typeName)'"
      )
    }
  }

  private static func asAssertionErrorOptional(object: PyObject) -> PyAssertionError? {
    return PyCast.asAssertionError(object)
  }

  // MARK: - AttributeError

  private func fillAttributeError() {
    let type = self.attributeError
    type.setBuiltinTypeDoc(PyAttributeError.doc)
    type.flags.set(PyType.baseExceptionSubclassFlag)
    type.flags.set(PyType.baseTypeFlag)
    type.flags.set(PyType.defaultFlag)
    type.flags.set(PyType.hasGCFlag)

    self.insert(type: type, name: "__class__", value: PyProperty.wrap(doc: nil, get: PyAttributeError.getClass, castSelf: Self.asAttributeError))
    self.insert(type: type, name: "__dict__", value: PyProperty.wrap(doc: nil, get: PyAttributeError.getDict, castSelf: Self.asAttributeError))

    self.insert(type: type, name: "__new__", value: PyStaticMethod.wrapNew(type: type, doc: nil, fn: PyAttributeError.pyAttributeErrorNew(type:args:kwargs:)))
    self.insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PyAttributeError.pyAttributeErrorInit(args:kwargs:), castSelf: Self.asAttributeErrorOptional))
  }

  private static func asAttributeError(functionName: String, object: PyObject) -> PyResult<PyAttributeError> {
    switch PyCast.asAttributeError(object) {
    case .some(let o):
        return .value(o)
    case .none:
      return .typeError(
        "descriptor '\(functionName)' requires a 'AttributeError' object " +
        "but received a '\(object.typeName)'"
      )
    }
  }

  private static func asAttributeErrorOptional(object: PyObject) -> PyAttributeError? {
    return PyCast.asAttributeError(object)
  }

  // MARK: - BufferError

  private func fillBufferError() {
    let type = self.bufferError
    type.setBuiltinTypeDoc(PyBufferError.doc)
    type.flags.set(PyType.baseExceptionSubclassFlag)
    type.flags.set(PyType.baseTypeFlag)
    type.flags.set(PyType.defaultFlag)
    type.flags.set(PyType.hasGCFlag)

    self.insert(type: type, name: "__class__", value: PyProperty.wrap(doc: nil, get: PyBufferError.getClass, castSelf: Self.asBufferError))
    self.insert(type: type, name: "__dict__", value: PyProperty.wrap(doc: nil, get: PyBufferError.getDict, castSelf: Self.asBufferError))

    self.insert(type: type, name: "__new__", value: PyStaticMethod.wrapNew(type: type, doc: nil, fn: PyBufferError.pyBufferErrorNew(type:args:kwargs:)))
    self.insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PyBufferError.pyBufferErrorInit(args:kwargs:), castSelf: Self.asBufferErrorOptional))
  }

  private static func asBufferError(functionName: String, object: PyObject) -> PyResult<PyBufferError> {
    switch PyCast.asBufferError(object) {
    case .some(let o):
        return .value(o)
    case .none:
      return .typeError(
        "descriptor '\(functionName)' requires a 'BufferError' object " +
        "but received a '\(object.typeName)'"
      )
    }
  }

  private static func asBufferErrorOptional(object: PyObject) -> PyBufferError? {
    return PyCast.asBufferError(object)
  }

  // MARK: - EOFError

  private func fillEOFError() {
    let type = self.eofError
    type.setBuiltinTypeDoc(PyEOFError.doc)
    type.flags.set(PyType.baseExceptionSubclassFlag)
    type.flags.set(PyType.baseTypeFlag)
    type.flags.set(PyType.defaultFlag)
    type.flags.set(PyType.hasGCFlag)

    self.insert(type: type, name: "__class__", value: PyProperty.wrap(doc: nil, get: PyEOFError.getClass, castSelf: Self.asEOFError))
    self.insert(type: type, name: "__dict__", value: PyProperty.wrap(doc: nil, get: PyEOFError.getDict, castSelf: Self.asEOFError))

    self.insert(type: type, name: "__new__", value: PyStaticMethod.wrapNew(type: type, doc: nil, fn: PyEOFError.pyEOFErrorNew(type:args:kwargs:)))
    self.insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PyEOFError.pyEOFErrorInit(args:kwargs:), castSelf: Self.asEOFErrorOptional))
  }

  private static func asEOFError(functionName: String, object: PyObject) -> PyResult<PyEOFError> {
    switch PyCast.asEOFError(object) {
    case .some(let o):
        return .value(o)
    case .none:
      return .typeError(
        "descriptor '\(functionName)' requires a 'EOFError' object " +
        "but received a '\(object.typeName)'"
      )
    }
  }

  private static func asEOFErrorOptional(object: PyObject) -> PyEOFError? {
    return PyCast.asEOFError(object)
  }

  // MARK: - ImportError

  private func fillImportError() {
    let type = self.importError
    type.setBuiltinTypeDoc(PyImportError.doc)
    type.flags.set(PyType.baseExceptionSubclassFlag)
    type.flags.set(PyType.baseTypeFlag)
    type.flags.set(PyType.defaultFlag)
    type.flags.set(PyType.hasGCFlag)

    self.insert(type: type, name: "__class__", value: PyProperty.wrap(doc: nil, get: PyImportError.getClass, castSelf: Self.asImportError))
    self.insert(type: type, name: "__dict__", value: PyProperty.wrap(doc: nil, get: PyImportError.getDict, castSelf: Self.asImportError))
    self.insert(type: type, name: "msg", value: PyProperty.wrap(doc: nil, get: PyImportError.getMsg, set: PyImportError.setMsg, castSelf: Self.asImportError))
    self.insert(type: type, name: "name", value: PyProperty.wrap(doc: nil, get: PyImportError.getName, set: PyImportError.setName, castSelf: Self.asImportError))
    self.insert(type: type, name: "path", value: PyProperty.wrap(doc: nil, get: PyImportError.getPath, set: PyImportError.setPath, castSelf: Self.asImportError))

    self.insert(type: type, name: "__new__", value: PyStaticMethod.wrapNew(type: type, doc: nil, fn: PyImportError.pyImportErrorNew(type:args:kwargs:)))
    self.insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PyImportError.pyImportErrorInit(args:kwargs:), castSelf: Self.asImportErrorOptional))

    self.insert(type: type, name: "__str__", value: PyBuiltinFunction.wrap(name: "__str__", doc: nil, fn: PyImportError.str(importError:), castSelf: Self.asImportError))
  }

  private static func asImportError(functionName: String, object: PyObject) -> PyResult<PyImportError> {
    switch PyCast.asImportError(object) {
    case .some(let o):
        return .value(o)
    case .none:
      return .typeError(
        "descriptor '\(functionName)' requires a 'ImportError' object " +
        "but received a '\(object.typeName)'"
      )
    }
  }

  private static func asImportErrorOptional(object: PyObject) -> PyImportError? {
    return PyCast.asImportError(object)
  }

  // MARK: - ModuleNotFoundError

  private func fillModuleNotFoundError() {
    let type = self.moduleNotFoundError
    type.setBuiltinTypeDoc(PyModuleNotFoundError.doc)
    type.flags.set(PyType.baseExceptionSubclassFlag)
    type.flags.set(PyType.baseTypeFlag)
    type.flags.set(PyType.defaultFlag)
    type.flags.set(PyType.hasGCFlag)

    self.insert(type: type, name: "__class__", value: PyProperty.wrap(doc: nil, get: PyModuleNotFoundError.getClass, castSelf: Self.asModuleNotFoundError))
    self.insert(type: type, name: "__dict__", value: PyProperty.wrap(doc: nil, get: PyModuleNotFoundError.getDict, castSelf: Self.asModuleNotFoundError))

    self.insert(type: type, name: "__new__", value: PyStaticMethod.wrapNew(type: type, doc: nil, fn: PyModuleNotFoundError.pyModuleNotFoundErrorNew(type:args:kwargs:)))
    self.insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PyModuleNotFoundError.pyModuleNotFoundErrorInit(args:kwargs:), castSelf: Self.asModuleNotFoundErrorOptional))
  }

  private static func asModuleNotFoundError(functionName: String, object: PyObject) -> PyResult<PyModuleNotFoundError> {
    switch PyCast.asModuleNotFoundError(object) {
    case .some(let o):
        return .value(o)
    case .none:
      return .typeError(
        "descriptor '\(functionName)' requires a 'ModuleNotFoundError' object " +
        "but received a '\(object.typeName)'"
      )
    }
  }

  private static func asModuleNotFoundErrorOptional(object: PyObject) -> PyModuleNotFoundError? {
    return PyCast.asModuleNotFoundError(object)
  }

  // MARK: - LookupError

  private func fillLookupError() {
    let type = self.lookupError
    type.setBuiltinTypeDoc(PyLookupError.doc)
    type.flags.set(PyType.baseExceptionSubclassFlag)
    type.flags.set(PyType.baseTypeFlag)
    type.flags.set(PyType.defaultFlag)
    type.flags.set(PyType.hasGCFlag)

    self.insert(type: type, name: "__class__", value: PyProperty.wrap(doc: nil, get: PyLookupError.getClass, castSelf: Self.asLookupError))
    self.insert(type: type, name: "__dict__", value: PyProperty.wrap(doc: nil, get: PyLookupError.getDict, castSelf: Self.asLookupError))

    self.insert(type: type, name: "__new__", value: PyStaticMethod.wrapNew(type: type, doc: nil, fn: PyLookupError.pyLookupErrorNew(type:args:kwargs:)))
    self.insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PyLookupError.pyLookupErrorInit(args:kwargs:), castSelf: Self.asLookupErrorOptional))
  }

  private static func asLookupError(functionName: String, object: PyObject) -> PyResult<PyLookupError> {
    switch PyCast.asLookupError(object) {
    case .some(let o):
        return .value(o)
    case .none:
      return .typeError(
        "descriptor '\(functionName)' requires a 'LookupError' object " +
        "but received a '\(object.typeName)'"
      )
    }
  }

  private static func asLookupErrorOptional(object: PyObject) -> PyLookupError? {
    return PyCast.asLookupError(object)
  }

  // MARK: - IndexError

  private func fillIndexError() {
    let type = self.indexError
    type.setBuiltinTypeDoc(PyIndexError.doc)
    type.flags.set(PyType.baseExceptionSubclassFlag)
    type.flags.set(PyType.baseTypeFlag)
    type.flags.set(PyType.defaultFlag)
    type.flags.set(PyType.hasGCFlag)

    self.insert(type: type, name: "__class__", value: PyProperty.wrap(doc: nil, get: PyIndexError.getClass, castSelf: Self.asIndexError))
    self.insert(type: type, name: "__dict__", value: PyProperty.wrap(doc: nil, get: PyIndexError.getDict, castSelf: Self.asIndexError))

    self.insert(type: type, name: "__new__", value: PyStaticMethod.wrapNew(type: type, doc: nil, fn: PyIndexError.pyIndexErrorNew(type:args:kwargs:)))
    self.insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PyIndexError.pyIndexErrorInit(args:kwargs:), castSelf: Self.asIndexErrorOptional))
  }

  private static func asIndexError(functionName: String, object: PyObject) -> PyResult<PyIndexError> {
    switch PyCast.asIndexError(object) {
    case .some(let o):
        return .value(o)
    case .none:
      return .typeError(
        "descriptor '\(functionName)' requires a 'IndexError' object " +
        "but received a '\(object.typeName)'"
      )
    }
  }

  private static func asIndexErrorOptional(object: PyObject) -> PyIndexError? {
    return PyCast.asIndexError(object)
  }

  // MARK: - KeyError

  private func fillKeyError() {
    let type = self.keyError
    type.setBuiltinTypeDoc(PyKeyError.doc)
    type.flags.set(PyType.baseExceptionSubclassFlag)
    type.flags.set(PyType.baseTypeFlag)
    type.flags.set(PyType.defaultFlag)
    type.flags.set(PyType.hasGCFlag)

    self.insert(type: type, name: "__class__", value: PyProperty.wrap(doc: nil, get: PyKeyError.getClass, castSelf: Self.asKeyError))
    self.insert(type: type, name: "__dict__", value: PyProperty.wrap(doc: nil, get: PyKeyError.getDict, castSelf: Self.asKeyError))

    self.insert(type: type, name: "__new__", value: PyStaticMethod.wrapNew(type: type, doc: nil, fn: PyKeyError.pyKeyErrorNew(type:args:kwargs:)))
    self.insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PyKeyError.pyKeyErrorInit(args:kwargs:), castSelf: Self.asKeyErrorOptional))

    self.insert(type: type, name: "__str__", value: PyBuiltinFunction.wrap(name: "__str__", doc: nil, fn: PyKeyError.str(keyError:), castSelf: Self.asKeyError))
  }

  private static func asKeyError(functionName: String, object: PyObject) -> PyResult<PyKeyError> {
    switch PyCast.asKeyError(object) {
    case .some(let o):
        return .value(o)
    case .none:
      return .typeError(
        "descriptor '\(functionName)' requires a 'KeyError' object " +
        "but received a '\(object.typeName)'"
      )
    }
  }

  private static func asKeyErrorOptional(object: PyObject) -> PyKeyError? {
    return PyCast.asKeyError(object)
  }

  // MARK: - MemoryError

  private func fillMemoryError() {
    let type = self.memoryError
    type.setBuiltinTypeDoc(PyMemoryError.doc)
    type.flags.set(PyType.baseExceptionSubclassFlag)
    type.flags.set(PyType.baseTypeFlag)
    type.flags.set(PyType.defaultFlag)
    type.flags.set(PyType.hasGCFlag)

    self.insert(type: type, name: "__class__", value: PyProperty.wrap(doc: nil, get: PyMemoryError.getClass, castSelf: Self.asMemoryError))
    self.insert(type: type, name: "__dict__", value: PyProperty.wrap(doc: nil, get: PyMemoryError.getDict, castSelf: Self.asMemoryError))

    self.insert(type: type, name: "__new__", value: PyStaticMethod.wrapNew(type: type, doc: nil, fn: PyMemoryError.pyMemoryErrorNew(type:args:kwargs:)))
    self.insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PyMemoryError.pyMemoryErrorInit(args:kwargs:), castSelf: Self.asMemoryErrorOptional))
  }

  private static func asMemoryError(functionName: String, object: PyObject) -> PyResult<PyMemoryError> {
    switch PyCast.asMemoryError(object) {
    case .some(let o):
        return .value(o)
    case .none:
      return .typeError(
        "descriptor '\(functionName)' requires a 'MemoryError' object " +
        "but received a '\(object.typeName)'"
      )
    }
  }

  private static func asMemoryErrorOptional(object: PyObject) -> PyMemoryError? {
    return PyCast.asMemoryError(object)
  }

  // MARK: - NameError

  private func fillNameError() {
    let type = self.nameError
    type.setBuiltinTypeDoc(PyNameError.doc)
    type.flags.set(PyType.baseExceptionSubclassFlag)
    type.flags.set(PyType.baseTypeFlag)
    type.flags.set(PyType.defaultFlag)
    type.flags.set(PyType.hasGCFlag)

    self.insert(type: type, name: "__class__", value: PyProperty.wrap(doc: nil, get: PyNameError.getClass, castSelf: Self.asNameError))
    self.insert(type: type, name: "__dict__", value: PyProperty.wrap(doc: nil, get: PyNameError.getDict, castSelf: Self.asNameError))

    self.insert(type: type, name: "__new__", value: PyStaticMethod.wrapNew(type: type, doc: nil, fn: PyNameError.pyNameErrorNew(type:args:kwargs:)))
    self.insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PyNameError.pyNameErrorInit(args:kwargs:), castSelf: Self.asNameErrorOptional))
  }

  private static func asNameError(functionName: String, object: PyObject) -> PyResult<PyNameError> {
    switch PyCast.asNameError(object) {
    case .some(let o):
        return .value(o)
    case .none:
      return .typeError(
        "descriptor '\(functionName)' requires a 'NameError' object " +
        "but received a '\(object.typeName)'"
      )
    }
  }

  private static func asNameErrorOptional(object: PyObject) -> PyNameError? {
    return PyCast.asNameError(object)
  }

  // MARK: - UnboundLocalError

  private func fillUnboundLocalError() {
    let type = self.unboundLocalError
    type.setBuiltinTypeDoc(PyUnboundLocalError.doc)
    type.flags.set(PyType.baseExceptionSubclassFlag)
    type.flags.set(PyType.baseTypeFlag)
    type.flags.set(PyType.defaultFlag)
    type.flags.set(PyType.hasGCFlag)

    self.insert(type: type, name: "__class__", value: PyProperty.wrap(doc: nil, get: PyUnboundLocalError.getClass, castSelf: Self.asUnboundLocalError))
    self.insert(type: type, name: "__dict__", value: PyProperty.wrap(doc: nil, get: PyUnboundLocalError.getDict, castSelf: Self.asUnboundLocalError))

    self.insert(type: type, name: "__new__", value: PyStaticMethod.wrapNew(type: type, doc: nil, fn: PyUnboundLocalError.pyUnboundLocalErrorNew(type:args:kwargs:)))
    self.insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PyUnboundLocalError.pyUnboundLocalErrorInit(args:kwargs:), castSelf: Self.asUnboundLocalErrorOptional))
  }

  private static func asUnboundLocalError(functionName: String, object: PyObject) -> PyResult<PyUnboundLocalError> {
    switch PyCast.asUnboundLocalError(object) {
    case .some(let o):
        return .value(o)
    case .none:
      return .typeError(
        "descriptor '\(functionName)' requires a 'UnboundLocalError' object " +
        "but received a '\(object.typeName)'"
      )
    }
  }

  private static func asUnboundLocalErrorOptional(object: PyObject) -> PyUnboundLocalError? {
    return PyCast.asUnboundLocalError(object)
  }

  // MARK: - OSError

  private func fillOSError() {
    let type = self.osError
    type.setBuiltinTypeDoc(PyOSError.doc)
    type.flags.set(PyType.baseExceptionSubclassFlag)
    type.flags.set(PyType.baseTypeFlag)
    type.flags.set(PyType.defaultFlag)
    type.flags.set(PyType.hasGCFlag)

    self.insert(type: type, name: "__class__", value: PyProperty.wrap(doc: nil, get: PyOSError.getClass, castSelf: Self.asOSError))
    self.insert(type: type, name: "__dict__", value: PyProperty.wrap(doc: nil, get: PyOSError.getDict, castSelf: Self.asOSError))

    self.insert(type: type, name: "__new__", value: PyStaticMethod.wrapNew(type: type, doc: nil, fn: PyOSError.pyOSErrorNew(type:args:kwargs:)))
    self.insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PyOSError.pyOSErrorInit(args:kwargs:), castSelf: Self.asOSErrorOptional))
  }

  private static func asOSError(functionName: String, object: PyObject) -> PyResult<PyOSError> {
    switch PyCast.asOSError(object) {
    case .some(let o):
        return .value(o)
    case .none:
      return .typeError(
        "descriptor '\(functionName)' requires a 'OSError' object " +
        "but received a '\(object.typeName)'"
      )
    }
  }

  private static func asOSErrorOptional(object: PyObject) -> PyOSError? {
    return PyCast.asOSError(object)
  }

  // MARK: - BlockingIOError

  private func fillBlockingIOError() {
    let type = self.blockingIOError
    type.setBuiltinTypeDoc(PyBlockingIOError.doc)
    type.flags.set(PyType.baseExceptionSubclassFlag)
    type.flags.set(PyType.baseTypeFlag)
    type.flags.set(PyType.defaultFlag)
    type.flags.set(PyType.hasGCFlag)

    self.insert(type: type, name: "__class__", value: PyProperty.wrap(doc: nil, get: PyBlockingIOError.getClass, castSelf: Self.asBlockingIOError))
    self.insert(type: type, name: "__dict__", value: PyProperty.wrap(doc: nil, get: PyBlockingIOError.getDict, castSelf: Self.asBlockingIOError))

    self.insert(type: type, name: "__new__", value: PyStaticMethod.wrapNew(type: type, doc: nil, fn: PyBlockingIOError.pyBlockingIOErrorNew(type:args:kwargs:)))
    self.insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PyBlockingIOError.pyBlockingIOErrorInit(args:kwargs:), castSelf: Self.asBlockingIOErrorOptional))
  }

  private static func asBlockingIOError(functionName: String, object: PyObject) -> PyResult<PyBlockingIOError> {
    switch PyCast.asBlockingIOError(object) {
    case .some(let o):
        return .value(o)
    case .none:
      return .typeError(
        "descriptor '\(functionName)' requires a 'BlockingIOError' object " +
        "but received a '\(object.typeName)'"
      )
    }
  }

  private static func asBlockingIOErrorOptional(object: PyObject) -> PyBlockingIOError? {
    return PyCast.asBlockingIOError(object)
  }

  // MARK: - ChildProcessError

  private func fillChildProcessError() {
    let type = self.childProcessError
    type.setBuiltinTypeDoc(PyChildProcessError.doc)
    type.flags.set(PyType.baseExceptionSubclassFlag)
    type.flags.set(PyType.baseTypeFlag)
    type.flags.set(PyType.defaultFlag)
    type.flags.set(PyType.hasGCFlag)

    self.insert(type: type, name: "__class__", value: PyProperty.wrap(doc: nil, get: PyChildProcessError.getClass, castSelf: Self.asChildProcessError))
    self.insert(type: type, name: "__dict__", value: PyProperty.wrap(doc: nil, get: PyChildProcessError.getDict, castSelf: Self.asChildProcessError))

    self.insert(type: type, name: "__new__", value: PyStaticMethod.wrapNew(type: type, doc: nil, fn: PyChildProcessError.pyChildProcessErrorNew(type:args:kwargs:)))
    self.insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PyChildProcessError.pyChildProcessErrorInit(args:kwargs:), castSelf: Self.asChildProcessErrorOptional))
  }

  private static func asChildProcessError(functionName: String, object: PyObject) -> PyResult<PyChildProcessError> {
    switch PyCast.asChildProcessError(object) {
    case .some(let o):
        return .value(o)
    case .none:
      return .typeError(
        "descriptor '\(functionName)' requires a 'ChildProcessError' object " +
        "but received a '\(object.typeName)'"
      )
    }
  }

  private static func asChildProcessErrorOptional(object: PyObject) -> PyChildProcessError? {
    return PyCast.asChildProcessError(object)
  }

  // MARK: - ConnectionError

  private func fillConnectionError() {
    let type = self.connectionError
    type.setBuiltinTypeDoc(PyConnectionError.doc)
    type.flags.set(PyType.baseExceptionSubclassFlag)
    type.flags.set(PyType.baseTypeFlag)
    type.flags.set(PyType.defaultFlag)
    type.flags.set(PyType.hasGCFlag)

    self.insert(type: type, name: "__class__", value: PyProperty.wrap(doc: nil, get: PyConnectionError.getClass, castSelf: Self.asConnectionError))
    self.insert(type: type, name: "__dict__", value: PyProperty.wrap(doc: nil, get: PyConnectionError.getDict, castSelf: Self.asConnectionError))

    self.insert(type: type, name: "__new__", value: PyStaticMethod.wrapNew(type: type, doc: nil, fn: PyConnectionError.pyConnectionErrorNew(type:args:kwargs:)))
    self.insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PyConnectionError.pyConnectionErrorInit(args:kwargs:), castSelf: Self.asConnectionErrorOptional))
  }

  private static func asConnectionError(functionName: String, object: PyObject) -> PyResult<PyConnectionError> {
    switch PyCast.asConnectionError(object) {
    case .some(let o):
        return .value(o)
    case .none:
      return .typeError(
        "descriptor '\(functionName)' requires a 'ConnectionError' object " +
        "but received a '\(object.typeName)'"
      )
    }
  }

  private static func asConnectionErrorOptional(object: PyObject) -> PyConnectionError? {
    return PyCast.asConnectionError(object)
  }

  // MARK: - BrokenPipeError

  private func fillBrokenPipeError() {
    let type = self.brokenPipeError
    type.setBuiltinTypeDoc(PyBrokenPipeError.doc)
    type.flags.set(PyType.baseExceptionSubclassFlag)
    type.flags.set(PyType.baseTypeFlag)
    type.flags.set(PyType.defaultFlag)
    type.flags.set(PyType.hasGCFlag)

    self.insert(type: type, name: "__class__", value: PyProperty.wrap(doc: nil, get: PyBrokenPipeError.getClass, castSelf: Self.asBrokenPipeError))
    self.insert(type: type, name: "__dict__", value: PyProperty.wrap(doc: nil, get: PyBrokenPipeError.getDict, castSelf: Self.asBrokenPipeError))

    self.insert(type: type, name: "__new__", value: PyStaticMethod.wrapNew(type: type, doc: nil, fn: PyBrokenPipeError.pyBrokenPipeErrorNew(type:args:kwargs:)))
    self.insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PyBrokenPipeError.pyBrokenPipeErrorInit(args:kwargs:), castSelf: Self.asBrokenPipeErrorOptional))
  }

  private static func asBrokenPipeError(functionName: String, object: PyObject) -> PyResult<PyBrokenPipeError> {
    switch PyCast.asBrokenPipeError(object) {
    case .some(let o):
        return .value(o)
    case .none:
      return .typeError(
        "descriptor '\(functionName)' requires a 'BrokenPipeError' object " +
        "but received a '\(object.typeName)'"
      )
    }
  }

  private static func asBrokenPipeErrorOptional(object: PyObject) -> PyBrokenPipeError? {
    return PyCast.asBrokenPipeError(object)
  }

  // MARK: - ConnectionAbortedError

  private func fillConnectionAbortedError() {
    let type = self.connectionAbortedError
    type.setBuiltinTypeDoc(PyConnectionAbortedError.doc)
    type.flags.set(PyType.baseExceptionSubclassFlag)
    type.flags.set(PyType.baseTypeFlag)
    type.flags.set(PyType.defaultFlag)
    type.flags.set(PyType.hasGCFlag)

    self.insert(type: type, name: "__class__", value: PyProperty.wrap(doc: nil, get: PyConnectionAbortedError.getClass, castSelf: Self.asConnectionAbortedError))
    self.insert(type: type, name: "__dict__", value: PyProperty.wrap(doc: nil, get: PyConnectionAbortedError.getDict, castSelf: Self.asConnectionAbortedError))

    self.insert(type: type, name: "__new__", value: PyStaticMethod.wrapNew(type: type, doc: nil, fn: PyConnectionAbortedError.pyConnectionAbortedErrorNew(type:args:kwargs:)))
    self.insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PyConnectionAbortedError.pyConnectionAbortedErrorInit(args:kwargs:), castSelf: Self.asConnectionAbortedErrorOptional))
  }

  private static func asConnectionAbortedError(functionName: String, object: PyObject) -> PyResult<PyConnectionAbortedError> {
    switch PyCast.asConnectionAbortedError(object) {
    case .some(let o):
        return .value(o)
    case .none:
      return .typeError(
        "descriptor '\(functionName)' requires a 'ConnectionAbortedError' object " +
        "but received a '\(object.typeName)'"
      )
    }
  }

  private static func asConnectionAbortedErrorOptional(object: PyObject) -> PyConnectionAbortedError? {
    return PyCast.asConnectionAbortedError(object)
  }

  // MARK: - ConnectionRefusedError

  private func fillConnectionRefusedError() {
    let type = self.connectionRefusedError
    type.setBuiltinTypeDoc(PyConnectionRefusedError.doc)
    type.flags.set(PyType.baseExceptionSubclassFlag)
    type.flags.set(PyType.baseTypeFlag)
    type.flags.set(PyType.defaultFlag)
    type.flags.set(PyType.hasGCFlag)

    self.insert(type: type, name: "__class__", value: PyProperty.wrap(doc: nil, get: PyConnectionRefusedError.getClass, castSelf: Self.asConnectionRefusedError))
    self.insert(type: type, name: "__dict__", value: PyProperty.wrap(doc: nil, get: PyConnectionRefusedError.getDict, castSelf: Self.asConnectionRefusedError))

    self.insert(type: type, name: "__new__", value: PyStaticMethod.wrapNew(type: type, doc: nil, fn: PyConnectionRefusedError.pyConnectionRefusedErrorNew(type:args:kwargs:)))
    self.insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PyConnectionRefusedError.pyConnectionRefusedErrorInit(args:kwargs:), castSelf: Self.asConnectionRefusedErrorOptional))
  }

  private static func asConnectionRefusedError(functionName: String, object: PyObject) -> PyResult<PyConnectionRefusedError> {
    switch PyCast.asConnectionRefusedError(object) {
    case .some(let o):
        return .value(o)
    case .none:
      return .typeError(
        "descriptor '\(functionName)' requires a 'ConnectionRefusedError' object " +
        "but received a '\(object.typeName)'"
      )
    }
  }

  private static func asConnectionRefusedErrorOptional(object: PyObject) -> PyConnectionRefusedError? {
    return PyCast.asConnectionRefusedError(object)
  }

  // MARK: - ConnectionResetError

  private func fillConnectionResetError() {
    let type = self.connectionResetError
    type.setBuiltinTypeDoc(PyConnectionResetError.doc)
    type.flags.set(PyType.baseExceptionSubclassFlag)
    type.flags.set(PyType.baseTypeFlag)
    type.flags.set(PyType.defaultFlag)
    type.flags.set(PyType.hasGCFlag)

    self.insert(type: type, name: "__class__", value: PyProperty.wrap(doc: nil, get: PyConnectionResetError.getClass, castSelf: Self.asConnectionResetError))
    self.insert(type: type, name: "__dict__", value: PyProperty.wrap(doc: nil, get: PyConnectionResetError.getDict, castSelf: Self.asConnectionResetError))

    self.insert(type: type, name: "__new__", value: PyStaticMethod.wrapNew(type: type, doc: nil, fn: PyConnectionResetError.pyConnectionResetErrorNew(type:args:kwargs:)))
    self.insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PyConnectionResetError.pyConnectionResetErrorInit(args:kwargs:), castSelf: Self.asConnectionResetErrorOptional))
  }

  private static func asConnectionResetError(functionName: String, object: PyObject) -> PyResult<PyConnectionResetError> {
    switch PyCast.asConnectionResetError(object) {
    case .some(let o):
        return .value(o)
    case .none:
      return .typeError(
        "descriptor '\(functionName)' requires a 'ConnectionResetError' object " +
        "but received a '\(object.typeName)'"
      )
    }
  }

  private static func asConnectionResetErrorOptional(object: PyObject) -> PyConnectionResetError? {
    return PyCast.asConnectionResetError(object)
  }

  // MARK: - FileExistsError

  private func fillFileExistsError() {
    let type = self.fileExistsError
    type.setBuiltinTypeDoc(PyFileExistsError.doc)
    type.flags.set(PyType.baseExceptionSubclassFlag)
    type.flags.set(PyType.baseTypeFlag)
    type.flags.set(PyType.defaultFlag)
    type.flags.set(PyType.hasGCFlag)

    self.insert(type: type, name: "__class__", value: PyProperty.wrap(doc: nil, get: PyFileExistsError.getClass, castSelf: Self.asFileExistsError))
    self.insert(type: type, name: "__dict__", value: PyProperty.wrap(doc: nil, get: PyFileExistsError.getDict, castSelf: Self.asFileExistsError))

    self.insert(type: type, name: "__new__", value: PyStaticMethod.wrapNew(type: type, doc: nil, fn: PyFileExistsError.pyFileExistsErrorNew(type:args:kwargs:)))
    self.insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PyFileExistsError.pyFileExistsErrorInit(args:kwargs:), castSelf: Self.asFileExistsErrorOptional))
  }

  private static func asFileExistsError(functionName: String, object: PyObject) -> PyResult<PyFileExistsError> {
    switch PyCast.asFileExistsError(object) {
    case .some(let o):
        return .value(o)
    case .none:
      return .typeError(
        "descriptor '\(functionName)' requires a 'FileExistsError' object " +
        "but received a '\(object.typeName)'"
      )
    }
  }

  private static func asFileExistsErrorOptional(object: PyObject) -> PyFileExistsError? {
    return PyCast.asFileExistsError(object)
  }

  // MARK: - FileNotFoundError

  private func fillFileNotFoundError() {
    let type = self.fileNotFoundError
    type.setBuiltinTypeDoc(PyFileNotFoundError.doc)
    type.flags.set(PyType.baseExceptionSubclassFlag)
    type.flags.set(PyType.baseTypeFlag)
    type.flags.set(PyType.defaultFlag)
    type.flags.set(PyType.hasGCFlag)

    self.insert(type: type, name: "__class__", value: PyProperty.wrap(doc: nil, get: PyFileNotFoundError.getClass, castSelf: Self.asFileNotFoundError))
    self.insert(type: type, name: "__dict__", value: PyProperty.wrap(doc: nil, get: PyFileNotFoundError.getDict, castSelf: Self.asFileNotFoundError))

    self.insert(type: type, name: "__new__", value: PyStaticMethod.wrapNew(type: type, doc: nil, fn: PyFileNotFoundError.pyFileNotFoundErrorNew(type:args:kwargs:)))
    self.insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PyFileNotFoundError.pyFileNotFoundErrorInit(args:kwargs:), castSelf: Self.asFileNotFoundErrorOptional))
  }

  private static func asFileNotFoundError(functionName: String, object: PyObject) -> PyResult<PyFileNotFoundError> {
    switch PyCast.asFileNotFoundError(object) {
    case .some(let o):
        return .value(o)
    case .none:
      return .typeError(
        "descriptor '\(functionName)' requires a 'FileNotFoundError' object " +
        "but received a '\(object.typeName)'"
      )
    }
  }

  private static func asFileNotFoundErrorOptional(object: PyObject) -> PyFileNotFoundError? {
    return PyCast.asFileNotFoundError(object)
  }

  // MARK: - InterruptedError

  private func fillInterruptedError() {
    let type = self.interruptedError
    type.setBuiltinTypeDoc(PyInterruptedError.doc)
    type.flags.set(PyType.baseExceptionSubclassFlag)
    type.flags.set(PyType.baseTypeFlag)
    type.flags.set(PyType.defaultFlag)
    type.flags.set(PyType.hasGCFlag)

    self.insert(type: type, name: "__class__", value: PyProperty.wrap(doc: nil, get: PyInterruptedError.getClass, castSelf: Self.asInterruptedError))
    self.insert(type: type, name: "__dict__", value: PyProperty.wrap(doc: nil, get: PyInterruptedError.getDict, castSelf: Self.asInterruptedError))

    self.insert(type: type, name: "__new__", value: PyStaticMethod.wrapNew(type: type, doc: nil, fn: PyInterruptedError.pyInterruptedErrorNew(type:args:kwargs:)))
    self.insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PyInterruptedError.pyInterruptedErrorInit(args:kwargs:), castSelf: Self.asInterruptedErrorOptional))
  }

  private static func asInterruptedError(functionName: String, object: PyObject) -> PyResult<PyInterruptedError> {
    switch PyCast.asInterruptedError(object) {
    case .some(let o):
        return .value(o)
    case .none:
      return .typeError(
        "descriptor '\(functionName)' requires a 'InterruptedError' object " +
        "but received a '\(object.typeName)'"
      )
    }
  }

  private static func asInterruptedErrorOptional(object: PyObject) -> PyInterruptedError? {
    return PyCast.asInterruptedError(object)
  }

  // MARK: - IsADirectoryError

  private func fillIsADirectoryError() {
    let type = self.isADirectoryError
    type.setBuiltinTypeDoc(PyIsADirectoryError.doc)
    type.flags.set(PyType.baseExceptionSubclassFlag)
    type.flags.set(PyType.baseTypeFlag)
    type.flags.set(PyType.defaultFlag)
    type.flags.set(PyType.hasGCFlag)

    self.insert(type: type, name: "__class__", value: PyProperty.wrap(doc: nil, get: PyIsADirectoryError.getClass, castSelf: Self.asIsADirectoryError))
    self.insert(type: type, name: "__dict__", value: PyProperty.wrap(doc: nil, get: PyIsADirectoryError.getDict, castSelf: Self.asIsADirectoryError))

    self.insert(type: type, name: "__new__", value: PyStaticMethod.wrapNew(type: type, doc: nil, fn: PyIsADirectoryError.pyIsADirectoryErrorNew(type:args:kwargs:)))
    self.insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PyIsADirectoryError.pyIsADirectoryErrorInit(args:kwargs:), castSelf: Self.asIsADirectoryErrorOptional))
  }

  private static func asIsADirectoryError(functionName: String, object: PyObject) -> PyResult<PyIsADirectoryError> {
    switch PyCast.asIsADirectoryError(object) {
    case .some(let o):
        return .value(o)
    case .none:
      return .typeError(
        "descriptor '\(functionName)' requires a 'IsADirectoryError' object " +
        "but received a '\(object.typeName)'"
      )
    }
  }

  private static func asIsADirectoryErrorOptional(object: PyObject) -> PyIsADirectoryError? {
    return PyCast.asIsADirectoryError(object)
  }

  // MARK: - NotADirectoryError

  private func fillNotADirectoryError() {
    let type = self.notADirectoryError
    type.setBuiltinTypeDoc(PyNotADirectoryError.doc)
    type.flags.set(PyType.baseExceptionSubclassFlag)
    type.flags.set(PyType.baseTypeFlag)
    type.flags.set(PyType.defaultFlag)
    type.flags.set(PyType.hasGCFlag)

    self.insert(type: type, name: "__class__", value: PyProperty.wrap(doc: nil, get: PyNotADirectoryError.getClass, castSelf: Self.asNotADirectoryError))
    self.insert(type: type, name: "__dict__", value: PyProperty.wrap(doc: nil, get: PyNotADirectoryError.getDict, castSelf: Self.asNotADirectoryError))

    self.insert(type: type, name: "__new__", value: PyStaticMethod.wrapNew(type: type, doc: nil, fn: PyNotADirectoryError.pyNotADirectoryErrorNew(type:args:kwargs:)))
    self.insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PyNotADirectoryError.pyNotADirectoryErrorInit(args:kwargs:), castSelf: Self.asNotADirectoryErrorOptional))
  }

  private static func asNotADirectoryError(functionName: String, object: PyObject) -> PyResult<PyNotADirectoryError> {
    switch PyCast.asNotADirectoryError(object) {
    case .some(let o):
        return .value(o)
    case .none:
      return .typeError(
        "descriptor '\(functionName)' requires a 'NotADirectoryError' object " +
        "but received a '\(object.typeName)'"
      )
    }
  }

  private static func asNotADirectoryErrorOptional(object: PyObject) -> PyNotADirectoryError? {
    return PyCast.asNotADirectoryError(object)
  }

  // MARK: - PermissionError

  private func fillPermissionError() {
    let type = self.permissionError
    type.setBuiltinTypeDoc(PyPermissionError.doc)
    type.flags.set(PyType.baseExceptionSubclassFlag)
    type.flags.set(PyType.baseTypeFlag)
    type.flags.set(PyType.defaultFlag)
    type.flags.set(PyType.hasGCFlag)

    self.insert(type: type, name: "__class__", value: PyProperty.wrap(doc: nil, get: PyPermissionError.getClass, castSelf: Self.asPermissionError))
    self.insert(type: type, name: "__dict__", value: PyProperty.wrap(doc: nil, get: PyPermissionError.getDict, castSelf: Self.asPermissionError))

    self.insert(type: type, name: "__new__", value: PyStaticMethod.wrapNew(type: type, doc: nil, fn: PyPermissionError.pyPermissionErrorNew(type:args:kwargs:)))
    self.insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PyPermissionError.pyPermissionErrorInit(args:kwargs:), castSelf: Self.asPermissionErrorOptional))
  }

  private static func asPermissionError(functionName: String, object: PyObject) -> PyResult<PyPermissionError> {
    switch PyCast.asPermissionError(object) {
    case .some(let o):
        return .value(o)
    case .none:
      return .typeError(
        "descriptor '\(functionName)' requires a 'PermissionError' object " +
        "but received a '\(object.typeName)'"
      )
    }
  }

  private static func asPermissionErrorOptional(object: PyObject) -> PyPermissionError? {
    return PyCast.asPermissionError(object)
  }

  // MARK: - ProcessLookupError

  private func fillProcessLookupError() {
    let type = self.processLookupError
    type.setBuiltinTypeDoc(PyProcessLookupError.doc)
    type.flags.set(PyType.baseExceptionSubclassFlag)
    type.flags.set(PyType.baseTypeFlag)
    type.flags.set(PyType.defaultFlag)
    type.flags.set(PyType.hasGCFlag)

    self.insert(type: type, name: "__class__", value: PyProperty.wrap(doc: nil, get: PyProcessLookupError.getClass, castSelf: Self.asProcessLookupError))
    self.insert(type: type, name: "__dict__", value: PyProperty.wrap(doc: nil, get: PyProcessLookupError.getDict, castSelf: Self.asProcessLookupError))

    self.insert(type: type, name: "__new__", value: PyStaticMethod.wrapNew(type: type, doc: nil, fn: PyProcessLookupError.pyProcessLookupErrorNew(type:args:kwargs:)))
    self.insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PyProcessLookupError.pyProcessLookupErrorInit(args:kwargs:), castSelf: Self.asProcessLookupErrorOptional))
  }

  private static func asProcessLookupError(functionName: String, object: PyObject) -> PyResult<PyProcessLookupError> {
    switch PyCast.asProcessLookupError(object) {
    case .some(let o):
        return .value(o)
    case .none:
      return .typeError(
        "descriptor '\(functionName)' requires a 'ProcessLookupError' object " +
        "but received a '\(object.typeName)'"
      )
    }
  }

  private static func asProcessLookupErrorOptional(object: PyObject) -> PyProcessLookupError? {
    return PyCast.asProcessLookupError(object)
  }

  // MARK: - TimeoutError

  private func fillTimeoutError() {
    let type = self.timeoutError
    type.setBuiltinTypeDoc(PyTimeoutError.doc)
    type.flags.set(PyType.baseExceptionSubclassFlag)
    type.flags.set(PyType.baseTypeFlag)
    type.flags.set(PyType.defaultFlag)
    type.flags.set(PyType.hasGCFlag)

    self.insert(type: type, name: "__class__", value: PyProperty.wrap(doc: nil, get: PyTimeoutError.getClass, castSelf: Self.asTimeoutError))
    self.insert(type: type, name: "__dict__", value: PyProperty.wrap(doc: nil, get: PyTimeoutError.getDict, castSelf: Self.asTimeoutError))

    self.insert(type: type, name: "__new__", value: PyStaticMethod.wrapNew(type: type, doc: nil, fn: PyTimeoutError.pyTimeoutErrorNew(type:args:kwargs:)))
    self.insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PyTimeoutError.pyTimeoutErrorInit(args:kwargs:), castSelf: Self.asTimeoutErrorOptional))
  }

  private static func asTimeoutError(functionName: String, object: PyObject) -> PyResult<PyTimeoutError> {
    switch PyCast.asTimeoutError(object) {
    case .some(let o):
        return .value(o)
    case .none:
      return .typeError(
        "descriptor '\(functionName)' requires a 'TimeoutError' object " +
        "but received a '\(object.typeName)'"
      )
    }
  }

  private static func asTimeoutErrorOptional(object: PyObject) -> PyTimeoutError? {
    return PyCast.asTimeoutError(object)
  }

  // MARK: - ReferenceError

  private func fillReferenceError() {
    let type = self.referenceError
    type.setBuiltinTypeDoc(PyReferenceError.doc)
    type.flags.set(PyType.baseExceptionSubclassFlag)
    type.flags.set(PyType.baseTypeFlag)
    type.flags.set(PyType.defaultFlag)
    type.flags.set(PyType.hasGCFlag)

    self.insert(type: type, name: "__class__", value: PyProperty.wrap(doc: nil, get: PyReferenceError.getClass, castSelf: Self.asReferenceError))
    self.insert(type: type, name: "__dict__", value: PyProperty.wrap(doc: nil, get: PyReferenceError.getDict, castSelf: Self.asReferenceError))

    self.insert(type: type, name: "__new__", value: PyStaticMethod.wrapNew(type: type, doc: nil, fn: PyReferenceError.pyReferenceErrorNew(type:args:kwargs:)))
    self.insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PyReferenceError.pyReferenceErrorInit(args:kwargs:), castSelf: Self.asReferenceErrorOptional))
  }

  private static func asReferenceError(functionName: String, object: PyObject) -> PyResult<PyReferenceError> {
    switch PyCast.asReferenceError(object) {
    case .some(let o):
        return .value(o)
    case .none:
      return .typeError(
        "descriptor '\(functionName)' requires a 'ReferenceError' object " +
        "but received a '\(object.typeName)'"
      )
    }
  }

  private static func asReferenceErrorOptional(object: PyObject) -> PyReferenceError? {
    return PyCast.asReferenceError(object)
  }

  // MARK: - RuntimeError

  private func fillRuntimeError() {
    let type = self.runtimeError
    type.setBuiltinTypeDoc(PyRuntimeError.doc)
    type.flags.set(PyType.baseExceptionSubclassFlag)
    type.flags.set(PyType.baseTypeFlag)
    type.flags.set(PyType.defaultFlag)
    type.flags.set(PyType.hasGCFlag)

    self.insert(type: type, name: "__class__", value: PyProperty.wrap(doc: nil, get: PyRuntimeError.getClass, castSelf: Self.asRuntimeError))
    self.insert(type: type, name: "__dict__", value: PyProperty.wrap(doc: nil, get: PyRuntimeError.getDict, castSelf: Self.asRuntimeError))

    self.insert(type: type, name: "__new__", value: PyStaticMethod.wrapNew(type: type, doc: nil, fn: PyRuntimeError.pyRuntimeErrorNew(type:args:kwargs:)))
    self.insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PyRuntimeError.pyRuntimeErrorInit(args:kwargs:), castSelf: Self.asRuntimeErrorOptional))
  }

  private static func asRuntimeError(functionName: String, object: PyObject) -> PyResult<PyRuntimeError> {
    switch PyCast.asRuntimeError(object) {
    case .some(let o):
        return .value(o)
    case .none:
      return .typeError(
        "descriptor '\(functionName)' requires a 'RuntimeError' object " +
        "but received a '\(object.typeName)'"
      )
    }
  }

  private static func asRuntimeErrorOptional(object: PyObject) -> PyRuntimeError? {
    return PyCast.asRuntimeError(object)
  }

  // MARK: - NotImplementedError

  private func fillNotImplementedError() {
    let type = self.notImplementedError
    type.setBuiltinTypeDoc(PyNotImplementedError.doc)
    type.flags.set(PyType.baseExceptionSubclassFlag)
    type.flags.set(PyType.baseTypeFlag)
    type.flags.set(PyType.defaultFlag)
    type.flags.set(PyType.hasGCFlag)

    self.insert(type: type, name: "__class__", value: PyProperty.wrap(doc: nil, get: PyNotImplementedError.getClass, castSelf: Self.asNotImplementedError))
    self.insert(type: type, name: "__dict__", value: PyProperty.wrap(doc: nil, get: PyNotImplementedError.getDict, castSelf: Self.asNotImplementedError))

    self.insert(type: type, name: "__new__", value: PyStaticMethod.wrapNew(type: type, doc: nil, fn: PyNotImplementedError.pyNotImplementedErrorNew(type:args:kwargs:)))
    self.insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PyNotImplementedError.pyNotImplementedErrorInit(args:kwargs:), castSelf: Self.asNotImplementedErrorOptional))
  }

  private static func asNotImplementedError(functionName: String, object: PyObject) -> PyResult<PyNotImplementedError> {
    switch PyCast.asNotImplementedError(object) {
    case .some(let o):
        return .value(o)
    case .none:
      return .typeError(
        "descriptor '\(functionName)' requires a 'NotImplementedError' object " +
        "but received a '\(object.typeName)'"
      )
    }
  }

  private static func asNotImplementedErrorOptional(object: PyObject) -> PyNotImplementedError? {
    return PyCast.asNotImplementedError(object)
  }

  // MARK: - RecursionError

  private func fillRecursionError() {
    let type = self.recursionError
    type.setBuiltinTypeDoc(PyRecursionError.doc)
    type.flags.set(PyType.baseExceptionSubclassFlag)
    type.flags.set(PyType.baseTypeFlag)
    type.flags.set(PyType.defaultFlag)
    type.flags.set(PyType.hasGCFlag)

    self.insert(type: type, name: "__class__", value: PyProperty.wrap(doc: nil, get: PyRecursionError.getClass, castSelf: Self.asRecursionError))
    self.insert(type: type, name: "__dict__", value: PyProperty.wrap(doc: nil, get: PyRecursionError.getDict, castSelf: Self.asRecursionError))

    self.insert(type: type, name: "__new__", value: PyStaticMethod.wrapNew(type: type, doc: nil, fn: PyRecursionError.pyRecursionErrorNew(type:args:kwargs:)))
    self.insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PyRecursionError.pyRecursionErrorInit(args:kwargs:), castSelf: Self.asRecursionErrorOptional))
  }

  private static func asRecursionError(functionName: String, object: PyObject) -> PyResult<PyRecursionError> {
    switch PyCast.asRecursionError(object) {
    case .some(let o):
        return .value(o)
    case .none:
      return .typeError(
        "descriptor '\(functionName)' requires a 'RecursionError' object " +
        "but received a '\(object.typeName)'"
      )
    }
  }

  private static func asRecursionErrorOptional(object: PyObject) -> PyRecursionError? {
    return PyCast.asRecursionError(object)
  }

  // MARK: - SyntaxError

  private func fillSyntaxError() {
    let type = self.syntaxError
    type.setBuiltinTypeDoc(PySyntaxError.doc)
    type.flags.set(PyType.baseExceptionSubclassFlag)
    type.flags.set(PyType.baseTypeFlag)
    type.flags.set(PyType.defaultFlag)
    type.flags.set(PyType.hasGCFlag)

    self.insert(type: type, name: "__class__", value: PyProperty.wrap(doc: nil, get: PySyntaxError.getClass, castSelf: Self.asSyntaxError))
    self.insert(type: type, name: "__dict__", value: PyProperty.wrap(doc: nil, get: PySyntaxError.getDict, castSelf: Self.asSyntaxError))
    self.insert(type: type, name: "msg", value: PyProperty.wrap(doc: nil, get: PySyntaxError.getMsg, set: PySyntaxError.setMsg, castSelf: Self.asSyntaxError))
    self.insert(type: type, name: "filename", value: PyProperty.wrap(doc: nil, get: PySyntaxError.getFilename, set: PySyntaxError.setFilename, castSelf: Self.asSyntaxError))
    self.insert(type: type, name: "lineno", value: PyProperty.wrap(doc: nil, get: PySyntaxError.getLineno, set: PySyntaxError.setLineno, castSelf: Self.asSyntaxError))
    self.insert(type: type, name: "offset", value: PyProperty.wrap(doc: nil, get: PySyntaxError.getOffset, set: PySyntaxError.setOffset, castSelf: Self.asSyntaxError))
    self.insert(type: type, name: "text", value: PyProperty.wrap(doc: nil, get: PySyntaxError.getText, set: PySyntaxError.setText, castSelf: Self.asSyntaxError))
    self.insert(type: type, name: "print_file_and_line", value: PyProperty.wrap(doc: nil, get: PySyntaxError.getPrintFileAndLine, set: PySyntaxError.setPrintFileAndLine, castSelf: Self.asSyntaxError))

    self.insert(type: type, name: "__new__", value: PyStaticMethod.wrapNew(type: type, doc: nil, fn: PySyntaxError.pySyntaxErrorNew(type:args:kwargs:)))
    self.insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PySyntaxError.pySyntaxErrorInit(args:kwargs:), castSelf: Self.asSyntaxErrorOptional))

    self.insert(type: type, name: "__str__", value: PyBuiltinFunction.wrap(name: "__str__", doc: nil, fn: PySyntaxError.str(syntaxError:), castSelf: Self.asSyntaxError))
  }

  private static func asSyntaxError(functionName: String, object: PyObject) -> PyResult<PySyntaxError> {
    switch PyCast.asSyntaxError(object) {
    case .some(let o):
        return .value(o)
    case .none:
      return .typeError(
        "descriptor '\(functionName)' requires a 'SyntaxError' object " +
        "but received a '\(object.typeName)'"
      )
    }
  }

  private static func asSyntaxErrorOptional(object: PyObject) -> PySyntaxError? {
    return PyCast.asSyntaxError(object)
  }

  // MARK: - IndentationError

  private func fillIndentationError() {
    let type = self.indentationError
    type.setBuiltinTypeDoc(PyIndentationError.doc)
    type.flags.set(PyType.baseExceptionSubclassFlag)
    type.flags.set(PyType.baseTypeFlag)
    type.flags.set(PyType.defaultFlag)
    type.flags.set(PyType.hasGCFlag)

    self.insert(type: type, name: "__class__", value: PyProperty.wrap(doc: nil, get: PyIndentationError.getClass, castSelf: Self.asIndentationError))
    self.insert(type: type, name: "__dict__", value: PyProperty.wrap(doc: nil, get: PyIndentationError.getDict, castSelf: Self.asIndentationError))

    self.insert(type: type, name: "__new__", value: PyStaticMethod.wrapNew(type: type, doc: nil, fn: PyIndentationError.pyIndentationErrorNew(type:args:kwargs:)))
    self.insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PyIndentationError.pyIndentationErrorInit(args:kwargs:), castSelf: Self.asIndentationErrorOptional))
  }

  private static func asIndentationError(functionName: String, object: PyObject) -> PyResult<PyIndentationError> {
    switch PyCast.asIndentationError(object) {
    case .some(let o):
        return .value(o)
    case .none:
      return .typeError(
        "descriptor '\(functionName)' requires a 'IndentationError' object " +
        "but received a '\(object.typeName)'"
      )
    }
  }

  private static func asIndentationErrorOptional(object: PyObject) -> PyIndentationError? {
    return PyCast.asIndentationError(object)
  }

  // MARK: - TabError

  private func fillTabError() {
    let type = self.tabError
    type.setBuiltinTypeDoc(PyTabError.doc)
    type.flags.set(PyType.baseExceptionSubclassFlag)
    type.flags.set(PyType.baseTypeFlag)
    type.flags.set(PyType.defaultFlag)
    type.flags.set(PyType.hasGCFlag)

    self.insert(type: type, name: "__class__", value: PyProperty.wrap(doc: nil, get: PyTabError.getClass, castSelf: Self.asTabError))
    self.insert(type: type, name: "__dict__", value: PyProperty.wrap(doc: nil, get: PyTabError.getDict, castSelf: Self.asTabError))

    self.insert(type: type, name: "__new__", value: PyStaticMethod.wrapNew(type: type, doc: nil, fn: PyTabError.pyTabErrorNew(type:args:kwargs:)))
    self.insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PyTabError.pyTabErrorInit(args:kwargs:), castSelf: Self.asTabErrorOptional))
  }

  private static func asTabError(functionName: String, object: PyObject) -> PyResult<PyTabError> {
    switch PyCast.asTabError(object) {
    case .some(let o):
        return .value(o)
    case .none:
      return .typeError(
        "descriptor '\(functionName)' requires a 'TabError' object " +
        "but received a '\(object.typeName)'"
      )
    }
  }

  private static func asTabErrorOptional(object: PyObject) -> PyTabError? {
    return PyCast.asTabError(object)
  }

  // MARK: - SystemError

  private func fillSystemError() {
    let type = self.systemError
    type.setBuiltinTypeDoc(PySystemError.doc)
    type.flags.set(PyType.baseExceptionSubclassFlag)
    type.flags.set(PyType.baseTypeFlag)
    type.flags.set(PyType.defaultFlag)
    type.flags.set(PyType.hasGCFlag)

    self.insert(type: type, name: "__class__", value: PyProperty.wrap(doc: nil, get: PySystemError.getClass, castSelf: Self.asSystemError))
    self.insert(type: type, name: "__dict__", value: PyProperty.wrap(doc: nil, get: PySystemError.getDict, castSelf: Self.asSystemError))

    self.insert(type: type, name: "__new__", value: PyStaticMethod.wrapNew(type: type, doc: nil, fn: PySystemError.pySystemErrorNew(type:args:kwargs:)))
    self.insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PySystemError.pySystemErrorInit(args:kwargs:), castSelf: Self.asSystemErrorOptional))
  }

  private static func asSystemError(functionName: String, object: PyObject) -> PyResult<PySystemError> {
    switch PyCast.asSystemError(object) {
    case .some(let o):
        return .value(o)
    case .none:
      return .typeError(
        "descriptor '\(functionName)' requires a 'SystemError' object " +
        "but received a '\(object.typeName)'"
      )
    }
  }

  private static func asSystemErrorOptional(object: PyObject) -> PySystemError? {
    return PyCast.asSystemError(object)
  }

  // MARK: - TypeError

  private func fillTypeError() {
    let type = self.typeError
    type.setBuiltinTypeDoc(PyTypeError.doc)
    type.flags.set(PyType.baseExceptionSubclassFlag)
    type.flags.set(PyType.baseTypeFlag)
    type.flags.set(PyType.defaultFlag)
    type.flags.set(PyType.hasGCFlag)

    self.insert(type: type, name: "__class__", value: PyProperty.wrap(doc: nil, get: PyTypeError.getClass, castSelf: Self.asTypeError))
    self.insert(type: type, name: "__dict__", value: PyProperty.wrap(doc: nil, get: PyTypeError.getDict, castSelf: Self.asTypeError))

    self.insert(type: type, name: "__new__", value: PyStaticMethod.wrapNew(type: type, doc: nil, fn: PyTypeError.pyTypeErrorNew(type:args:kwargs:)))
    self.insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PyTypeError.pyTypeErrorInit(args:kwargs:), castSelf: Self.asTypeErrorOptional))
  }

  private static func asTypeError(functionName: String, object: PyObject) -> PyResult<PyTypeError> {
    switch PyCast.asTypeError(object) {
    case .some(let o):
        return .value(o)
    case .none:
      return .typeError(
        "descriptor '\(functionName)' requires a 'TypeError' object " +
        "but received a '\(object.typeName)'"
      )
    }
  }

  private static func asTypeErrorOptional(object: PyObject) -> PyTypeError? {
    return PyCast.asTypeError(object)
  }

  // MARK: - ValueError

  private func fillValueError() {
    let type = self.valueError
    type.setBuiltinTypeDoc(PyValueError.doc)
    type.flags.set(PyType.baseExceptionSubclassFlag)
    type.flags.set(PyType.baseTypeFlag)
    type.flags.set(PyType.defaultFlag)
    type.flags.set(PyType.hasGCFlag)

    self.insert(type: type, name: "__class__", value: PyProperty.wrap(doc: nil, get: PyValueError.getClass, castSelf: Self.asValueError))
    self.insert(type: type, name: "__dict__", value: PyProperty.wrap(doc: nil, get: PyValueError.getDict, castSelf: Self.asValueError))

    self.insert(type: type, name: "__new__", value: PyStaticMethod.wrapNew(type: type, doc: nil, fn: PyValueError.pyValueErrorNew(type:args:kwargs:)))
    self.insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PyValueError.pyValueErrorInit(args:kwargs:), castSelf: Self.asValueErrorOptional))
  }

  private static func asValueError(functionName: String, object: PyObject) -> PyResult<PyValueError> {
    switch PyCast.asValueError(object) {
    case .some(let o):
        return .value(o)
    case .none:
      return .typeError(
        "descriptor '\(functionName)' requires a 'ValueError' object " +
        "but received a '\(object.typeName)'"
      )
    }
  }

  private static func asValueErrorOptional(object: PyObject) -> PyValueError? {
    return PyCast.asValueError(object)
  }

  // MARK: - UnicodeError

  private func fillUnicodeError() {
    let type = self.unicodeError
    type.setBuiltinTypeDoc(PyUnicodeError.doc)
    type.flags.set(PyType.baseExceptionSubclassFlag)
    type.flags.set(PyType.baseTypeFlag)
    type.flags.set(PyType.defaultFlag)
    type.flags.set(PyType.hasGCFlag)

    self.insert(type: type, name: "__class__", value: PyProperty.wrap(doc: nil, get: PyUnicodeError.getClass, castSelf: Self.asUnicodeError))
    self.insert(type: type, name: "__dict__", value: PyProperty.wrap(doc: nil, get: PyUnicodeError.getDict, castSelf: Self.asUnicodeError))

    self.insert(type: type, name: "__new__", value: PyStaticMethod.wrapNew(type: type, doc: nil, fn: PyUnicodeError.pyUnicodeErrorNew(type:args:kwargs:)))
    self.insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PyUnicodeError.pyUnicodeErrorInit(args:kwargs:), castSelf: Self.asUnicodeErrorOptional))
  }

  private static func asUnicodeError(functionName: String, object: PyObject) -> PyResult<PyUnicodeError> {
    switch PyCast.asUnicodeError(object) {
    case .some(let o):
        return .value(o)
    case .none:
      return .typeError(
        "descriptor '\(functionName)' requires a 'UnicodeError' object " +
        "but received a '\(object.typeName)'"
      )
    }
  }

  private static func asUnicodeErrorOptional(object: PyObject) -> PyUnicodeError? {
    return PyCast.asUnicodeError(object)
  }

  // MARK: - UnicodeDecodeError

  private func fillUnicodeDecodeError() {
    let type = self.unicodeDecodeError
    type.setBuiltinTypeDoc(PyUnicodeDecodeError.doc)
    type.flags.set(PyType.baseExceptionSubclassFlag)
    type.flags.set(PyType.baseTypeFlag)
    type.flags.set(PyType.defaultFlag)
    type.flags.set(PyType.hasGCFlag)

    self.insert(type: type, name: "__class__", value: PyProperty.wrap(doc: nil, get: PyUnicodeDecodeError.getClass, castSelf: Self.asUnicodeDecodeError))
    self.insert(type: type, name: "__dict__", value: PyProperty.wrap(doc: nil, get: PyUnicodeDecodeError.getDict, castSelf: Self.asUnicodeDecodeError))

    self.insert(type: type, name: "__new__", value: PyStaticMethod.wrapNew(type: type, doc: nil, fn: PyUnicodeDecodeError.pyUnicodeDecodeErrorNew(type:args:kwargs:)))
    self.insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PyUnicodeDecodeError.pyUnicodeDecodeErrorInit(args:kwargs:), castSelf: Self.asUnicodeDecodeErrorOptional))
  }

  private static func asUnicodeDecodeError(functionName: String, object: PyObject) -> PyResult<PyUnicodeDecodeError> {
    switch PyCast.asUnicodeDecodeError(object) {
    case .some(let o):
        return .value(o)
    case .none:
      return .typeError(
        "descriptor '\(functionName)' requires a 'UnicodeDecodeError' object " +
        "but received a '\(object.typeName)'"
      )
    }
  }

  private static func asUnicodeDecodeErrorOptional(object: PyObject) -> PyUnicodeDecodeError? {
    return PyCast.asUnicodeDecodeError(object)
  }

  // MARK: - UnicodeEncodeError

  private func fillUnicodeEncodeError() {
    let type = self.unicodeEncodeError
    type.setBuiltinTypeDoc(PyUnicodeEncodeError.doc)
    type.flags.set(PyType.baseExceptionSubclassFlag)
    type.flags.set(PyType.baseTypeFlag)
    type.flags.set(PyType.defaultFlag)
    type.flags.set(PyType.hasGCFlag)

    self.insert(type: type, name: "__class__", value: PyProperty.wrap(doc: nil, get: PyUnicodeEncodeError.getClass, castSelf: Self.asUnicodeEncodeError))
    self.insert(type: type, name: "__dict__", value: PyProperty.wrap(doc: nil, get: PyUnicodeEncodeError.getDict, castSelf: Self.asUnicodeEncodeError))

    self.insert(type: type, name: "__new__", value: PyStaticMethod.wrapNew(type: type, doc: nil, fn: PyUnicodeEncodeError.pyUnicodeEncodeErrorNew(type:args:kwargs:)))
    self.insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PyUnicodeEncodeError.pyUnicodeEncodeErrorInit(args:kwargs:), castSelf: Self.asUnicodeEncodeErrorOptional))
  }

  private static func asUnicodeEncodeError(functionName: String, object: PyObject) -> PyResult<PyUnicodeEncodeError> {
    switch PyCast.asUnicodeEncodeError(object) {
    case .some(let o):
        return .value(o)
    case .none:
      return .typeError(
        "descriptor '\(functionName)' requires a 'UnicodeEncodeError' object " +
        "but received a '\(object.typeName)'"
      )
    }
  }

  private static func asUnicodeEncodeErrorOptional(object: PyObject) -> PyUnicodeEncodeError? {
    return PyCast.asUnicodeEncodeError(object)
  }

  // MARK: - UnicodeTranslateError

  private func fillUnicodeTranslateError() {
    let type = self.unicodeTranslateError
    type.setBuiltinTypeDoc(PyUnicodeTranslateError.doc)
    type.flags.set(PyType.baseExceptionSubclassFlag)
    type.flags.set(PyType.baseTypeFlag)
    type.flags.set(PyType.defaultFlag)
    type.flags.set(PyType.hasGCFlag)

    self.insert(type: type, name: "__class__", value: PyProperty.wrap(doc: nil, get: PyUnicodeTranslateError.getClass, castSelf: Self.asUnicodeTranslateError))
    self.insert(type: type, name: "__dict__", value: PyProperty.wrap(doc: nil, get: PyUnicodeTranslateError.getDict, castSelf: Self.asUnicodeTranslateError))

    self.insert(type: type, name: "__new__", value: PyStaticMethod.wrapNew(type: type, doc: nil, fn: PyUnicodeTranslateError.pyUnicodeTranslateErrorNew(type:args:kwargs:)))
    self.insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PyUnicodeTranslateError.pyUnicodeTranslateErrorInit(args:kwargs:), castSelf: Self.asUnicodeTranslateErrorOptional))
  }

  private static func asUnicodeTranslateError(functionName: String, object: PyObject) -> PyResult<PyUnicodeTranslateError> {
    switch PyCast.asUnicodeTranslateError(object) {
    case .some(let o):
        return .value(o)
    case .none:
      return .typeError(
        "descriptor '\(functionName)' requires a 'UnicodeTranslateError' object " +
        "but received a '\(object.typeName)'"
      )
    }
  }

  private static func asUnicodeTranslateErrorOptional(object: PyObject) -> PyUnicodeTranslateError? {
    return PyCast.asUnicodeTranslateError(object)
  }

  // MARK: - Warning

  private func fillWarning() {
    let type = self.warning
    type.setBuiltinTypeDoc(PyWarning.doc)
    type.flags.set(PyType.baseExceptionSubclassFlag)
    type.flags.set(PyType.baseTypeFlag)
    type.flags.set(PyType.defaultFlag)
    type.flags.set(PyType.hasGCFlag)

    self.insert(type: type, name: "__class__", value: PyProperty.wrap(doc: nil, get: PyWarning.getClass, castSelf: Self.asWarning))
    self.insert(type: type, name: "__dict__", value: PyProperty.wrap(doc: nil, get: PyWarning.getDict, castSelf: Self.asWarning))

    self.insert(type: type, name: "__new__", value: PyStaticMethod.wrapNew(type: type, doc: nil, fn: PyWarning.pyWarningNew(type:args:kwargs:)))
    self.insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PyWarning.pyWarningInit(args:kwargs:), castSelf: Self.asWarningOptional))
  }

  private static func asWarning(functionName: String, object: PyObject) -> PyResult<PyWarning> {
    switch PyCast.asWarning(object) {
    case .some(let o):
        return .value(o)
    case .none:
      return .typeError(
        "descriptor '\(functionName)' requires a 'Warning' object " +
        "but received a '\(object.typeName)'"
      )
    }
  }

  private static func asWarningOptional(object: PyObject) -> PyWarning? {
    return PyCast.asWarning(object)
  }

  // MARK: - DeprecationWarning

  private func fillDeprecationWarning() {
    let type = self.deprecationWarning
    type.setBuiltinTypeDoc(PyDeprecationWarning.doc)
    type.flags.set(PyType.baseExceptionSubclassFlag)
    type.flags.set(PyType.baseTypeFlag)
    type.flags.set(PyType.defaultFlag)
    type.flags.set(PyType.hasGCFlag)

    self.insert(type: type, name: "__class__", value: PyProperty.wrap(doc: nil, get: PyDeprecationWarning.getClass, castSelf: Self.asDeprecationWarning))
    self.insert(type: type, name: "__dict__", value: PyProperty.wrap(doc: nil, get: PyDeprecationWarning.getDict, castSelf: Self.asDeprecationWarning))

    self.insert(type: type, name: "__new__", value: PyStaticMethod.wrapNew(type: type, doc: nil, fn: PyDeprecationWarning.pyDeprecationWarningNew(type:args:kwargs:)))
    self.insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PyDeprecationWarning.pyDeprecationWarningInit(args:kwargs:), castSelf: Self.asDeprecationWarningOptional))
  }

  private static func asDeprecationWarning(functionName: String, object: PyObject) -> PyResult<PyDeprecationWarning> {
    switch PyCast.asDeprecationWarning(object) {
    case .some(let o):
        return .value(o)
    case .none:
      return .typeError(
        "descriptor '\(functionName)' requires a 'DeprecationWarning' object " +
        "but received a '\(object.typeName)'"
      )
    }
  }

  private static func asDeprecationWarningOptional(object: PyObject) -> PyDeprecationWarning? {
    return PyCast.asDeprecationWarning(object)
  }

  // MARK: - PendingDeprecationWarning

  private func fillPendingDeprecationWarning() {
    let type = self.pendingDeprecationWarning
    type.setBuiltinTypeDoc(PyPendingDeprecationWarning.doc)
    type.flags.set(PyType.baseExceptionSubclassFlag)
    type.flags.set(PyType.baseTypeFlag)
    type.flags.set(PyType.defaultFlag)
    type.flags.set(PyType.hasGCFlag)

    self.insert(type: type, name: "__class__", value: PyProperty.wrap(doc: nil, get: PyPendingDeprecationWarning.getClass, castSelf: Self.asPendingDeprecationWarning))
    self.insert(type: type, name: "__dict__", value: PyProperty.wrap(doc: nil, get: PyPendingDeprecationWarning.getDict, castSelf: Self.asPendingDeprecationWarning))

    self.insert(type: type, name: "__new__", value: PyStaticMethod.wrapNew(type: type, doc: nil, fn: PyPendingDeprecationWarning.pyPendingDeprecationWarningNew(type:args:kwargs:)))
    self.insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PyPendingDeprecationWarning.pyPendingDeprecationWarningInit(args:kwargs:), castSelf: Self.asPendingDeprecationWarningOptional))
  }

  private static func asPendingDeprecationWarning(functionName: String, object: PyObject) -> PyResult<PyPendingDeprecationWarning> {
    switch PyCast.asPendingDeprecationWarning(object) {
    case .some(let o):
        return .value(o)
    case .none:
      return .typeError(
        "descriptor '\(functionName)' requires a 'PendingDeprecationWarning' object " +
        "but received a '\(object.typeName)'"
      )
    }
  }

  private static func asPendingDeprecationWarningOptional(object: PyObject) -> PyPendingDeprecationWarning? {
    return PyCast.asPendingDeprecationWarning(object)
  }

  // MARK: - RuntimeWarning

  private func fillRuntimeWarning() {
    let type = self.runtimeWarning
    type.setBuiltinTypeDoc(PyRuntimeWarning.doc)
    type.flags.set(PyType.baseExceptionSubclassFlag)
    type.flags.set(PyType.baseTypeFlag)
    type.flags.set(PyType.defaultFlag)
    type.flags.set(PyType.hasGCFlag)

    self.insert(type: type, name: "__class__", value: PyProperty.wrap(doc: nil, get: PyRuntimeWarning.getClass, castSelf: Self.asRuntimeWarning))
    self.insert(type: type, name: "__dict__", value: PyProperty.wrap(doc: nil, get: PyRuntimeWarning.getDict, castSelf: Self.asRuntimeWarning))

    self.insert(type: type, name: "__new__", value: PyStaticMethod.wrapNew(type: type, doc: nil, fn: PyRuntimeWarning.pyRuntimeWarningNew(type:args:kwargs:)))
    self.insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PyRuntimeWarning.pyRuntimeWarningInit(args:kwargs:), castSelf: Self.asRuntimeWarningOptional))
  }

  private static func asRuntimeWarning(functionName: String, object: PyObject) -> PyResult<PyRuntimeWarning> {
    switch PyCast.asRuntimeWarning(object) {
    case .some(let o):
        return .value(o)
    case .none:
      return .typeError(
        "descriptor '\(functionName)' requires a 'RuntimeWarning' object " +
        "but received a '\(object.typeName)'"
      )
    }
  }

  private static func asRuntimeWarningOptional(object: PyObject) -> PyRuntimeWarning? {
    return PyCast.asRuntimeWarning(object)
  }

  // MARK: - SyntaxWarning

  private func fillSyntaxWarning() {
    let type = self.syntaxWarning
    type.setBuiltinTypeDoc(PySyntaxWarning.doc)
    type.flags.set(PyType.baseExceptionSubclassFlag)
    type.flags.set(PyType.baseTypeFlag)
    type.flags.set(PyType.defaultFlag)
    type.flags.set(PyType.hasGCFlag)

    self.insert(type: type, name: "__class__", value: PyProperty.wrap(doc: nil, get: PySyntaxWarning.getClass, castSelf: Self.asSyntaxWarning))
    self.insert(type: type, name: "__dict__", value: PyProperty.wrap(doc: nil, get: PySyntaxWarning.getDict, castSelf: Self.asSyntaxWarning))

    self.insert(type: type, name: "__new__", value: PyStaticMethod.wrapNew(type: type, doc: nil, fn: PySyntaxWarning.pySyntaxWarningNew(type:args:kwargs:)))
    self.insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PySyntaxWarning.pySyntaxWarningInit(args:kwargs:), castSelf: Self.asSyntaxWarningOptional))
  }

  private static func asSyntaxWarning(functionName: String, object: PyObject) -> PyResult<PySyntaxWarning> {
    switch PyCast.asSyntaxWarning(object) {
    case .some(let o):
        return .value(o)
    case .none:
      return .typeError(
        "descriptor '\(functionName)' requires a 'SyntaxWarning' object " +
        "but received a '\(object.typeName)'"
      )
    }
  }

  private static func asSyntaxWarningOptional(object: PyObject) -> PySyntaxWarning? {
    return PyCast.asSyntaxWarning(object)
  }

  // MARK: - UserWarning

  private func fillUserWarning() {
    let type = self.userWarning
    type.setBuiltinTypeDoc(PyUserWarning.doc)
    type.flags.set(PyType.baseExceptionSubclassFlag)
    type.flags.set(PyType.baseTypeFlag)
    type.flags.set(PyType.defaultFlag)
    type.flags.set(PyType.hasGCFlag)

    self.insert(type: type, name: "__class__", value: PyProperty.wrap(doc: nil, get: PyUserWarning.getClass, castSelf: Self.asUserWarning))
    self.insert(type: type, name: "__dict__", value: PyProperty.wrap(doc: nil, get: PyUserWarning.getDict, castSelf: Self.asUserWarning))

    self.insert(type: type, name: "__new__", value: PyStaticMethod.wrapNew(type: type, doc: nil, fn: PyUserWarning.pyUserWarningNew(type:args:kwargs:)))
    self.insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PyUserWarning.pyUserWarningInit(args:kwargs:), castSelf: Self.asUserWarningOptional))
  }

  private static func asUserWarning(functionName: String, object: PyObject) -> PyResult<PyUserWarning> {
    switch PyCast.asUserWarning(object) {
    case .some(let o):
        return .value(o)
    case .none:
      return .typeError(
        "descriptor '\(functionName)' requires a 'UserWarning' object " +
        "but received a '\(object.typeName)'"
      )
    }
  }

  private static func asUserWarningOptional(object: PyObject) -> PyUserWarning? {
    return PyCast.asUserWarning(object)
  }

  // MARK: - FutureWarning

  private func fillFutureWarning() {
    let type = self.futureWarning
    type.setBuiltinTypeDoc(PyFutureWarning.doc)
    type.flags.set(PyType.baseExceptionSubclassFlag)
    type.flags.set(PyType.baseTypeFlag)
    type.flags.set(PyType.defaultFlag)
    type.flags.set(PyType.hasGCFlag)

    self.insert(type: type, name: "__class__", value: PyProperty.wrap(doc: nil, get: PyFutureWarning.getClass, castSelf: Self.asFutureWarning))
    self.insert(type: type, name: "__dict__", value: PyProperty.wrap(doc: nil, get: PyFutureWarning.getDict, castSelf: Self.asFutureWarning))

    self.insert(type: type, name: "__new__", value: PyStaticMethod.wrapNew(type: type, doc: nil, fn: PyFutureWarning.pyFutureWarningNew(type:args:kwargs:)))
    self.insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PyFutureWarning.pyFutureWarningInit(args:kwargs:), castSelf: Self.asFutureWarningOptional))
  }

  private static func asFutureWarning(functionName: String, object: PyObject) -> PyResult<PyFutureWarning> {
    switch PyCast.asFutureWarning(object) {
    case .some(let o):
        return .value(o)
    case .none:
      return .typeError(
        "descriptor '\(functionName)' requires a 'FutureWarning' object " +
        "but received a '\(object.typeName)'"
      )
    }
  }

  private static func asFutureWarningOptional(object: PyObject) -> PyFutureWarning? {
    return PyCast.asFutureWarning(object)
  }

  // MARK: - ImportWarning

  private func fillImportWarning() {
    let type = self.importWarning
    type.setBuiltinTypeDoc(PyImportWarning.doc)
    type.flags.set(PyType.baseExceptionSubclassFlag)
    type.flags.set(PyType.baseTypeFlag)
    type.flags.set(PyType.defaultFlag)
    type.flags.set(PyType.hasGCFlag)

    self.insert(type: type, name: "__class__", value: PyProperty.wrap(doc: nil, get: PyImportWarning.getClass, castSelf: Self.asImportWarning))
    self.insert(type: type, name: "__dict__", value: PyProperty.wrap(doc: nil, get: PyImportWarning.getDict, castSelf: Self.asImportWarning))

    self.insert(type: type, name: "__new__", value: PyStaticMethod.wrapNew(type: type, doc: nil, fn: PyImportWarning.pyImportWarningNew(type:args:kwargs:)))
    self.insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PyImportWarning.pyImportWarningInit(args:kwargs:), castSelf: Self.asImportWarningOptional))
  }

  private static func asImportWarning(functionName: String, object: PyObject) -> PyResult<PyImportWarning> {
    switch PyCast.asImportWarning(object) {
    case .some(let o):
        return .value(o)
    case .none:
      return .typeError(
        "descriptor '\(functionName)' requires a 'ImportWarning' object " +
        "but received a '\(object.typeName)'"
      )
    }
  }

  private static func asImportWarningOptional(object: PyObject) -> PyImportWarning? {
    return PyCast.asImportWarning(object)
  }

  // MARK: - UnicodeWarning

  private func fillUnicodeWarning() {
    let type = self.unicodeWarning
    type.setBuiltinTypeDoc(PyUnicodeWarning.doc)
    type.flags.set(PyType.baseExceptionSubclassFlag)
    type.flags.set(PyType.baseTypeFlag)
    type.flags.set(PyType.defaultFlag)
    type.flags.set(PyType.hasGCFlag)

    self.insert(type: type, name: "__class__", value: PyProperty.wrap(doc: nil, get: PyUnicodeWarning.getClass, castSelf: Self.asUnicodeWarning))
    self.insert(type: type, name: "__dict__", value: PyProperty.wrap(doc: nil, get: PyUnicodeWarning.getDict, castSelf: Self.asUnicodeWarning))

    self.insert(type: type, name: "__new__", value: PyStaticMethod.wrapNew(type: type, doc: nil, fn: PyUnicodeWarning.pyUnicodeWarningNew(type:args:kwargs:)))
    self.insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PyUnicodeWarning.pyUnicodeWarningInit(args:kwargs:), castSelf: Self.asUnicodeWarningOptional))
  }

  private static func asUnicodeWarning(functionName: String, object: PyObject) -> PyResult<PyUnicodeWarning> {
    switch PyCast.asUnicodeWarning(object) {
    case .some(let o):
        return .value(o)
    case .none:
      return .typeError(
        "descriptor '\(functionName)' requires a 'UnicodeWarning' object " +
        "but received a '\(object.typeName)'"
      )
    }
  }

  private static func asUnicodeWarningOptional(object: PyObject) -> PyUnicodeWarning? {
    return PyCast.asUnicodeWarning(object)
  }

  // MARK: - BytesWarning

  private func fillBytesWarning() {
    let type = self.bytesWarning
    type.setBuiltinTypeDoc(PyBytesWarning.doc)
    type.flags.set(PyType.baseExceptionSubclassFlag)
    type.flags.set(PyType.baseTypeFlag)
    type.flags.set(PyType.defaultFlag)
    type.flags.set(PyType.hasGCFlag)

    self.insert(type: type, name: "__class__", value: PyProperty.wrap(doc: nil, get: PyBytesWarning.getClass, castSelf: Self.asBytesWarning))
    self.insert(type: type, name: "__dict__", value: PyProperty.wrap(doc: nil, get: PyBytesWarning.getDict, castSelf: Self.asBytesWarning))

    self.insert(type: type, name: "__new__", value: PyStaticMethod.wrapNew(type: type, doc: nil, fn: PyBytesWarning.pyBytesWarningNew(type:args:kwargs:)))
    self.insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PyBytesWarning.pyBytesWarningInit(args:kwargs:), castSelf: Self.asBytesWarningOptional))
  }

  private static func asBytesWarning(functionName: String, object: PyObject) -> PyResult<PyBytesWarning> {
    switch PyCast.asBytesWarning(object) {
    case .some(let o):
        return .value(o)
    case .none:
      return .typeError(
        "descriptor '\(functionName)' requires a 'BytesWarning' object " +
        "but received a '\(object.typeName)'"
      )
    }
  }

  private static func asBytesWarningOptional(object: PyObject) -> PyBytesWarning? {
    return PyCast.asBytesWarning(object)
  }

  // MARK: - ResourceWarning

  private func fillResourceWarning() {
    let type = self.resourceWarning
    type.setBuiltinTypeDoc(PyResourceWarning.doc)
    type.flags.set(PyType.baseExceptionSubclassFlag)
    type.flags.set(PyType.baseTypeFlag)
    type.flags.set(PyType.defaultFlag)
    type.flags.set(PyType.hasGCFlag)

    self.insert(type: type, name: "__class__", value: PyProperty.wrap(doc: nil, get: PyResourceWarning.getClass, castSelf: Self.asResourceWarning))
    self.insert(type: type, name: "__dict__", value: PyProperty.wrap(doc: nil, get: PyResourceWarning.getDict, castSelf: Self.asResourceWarning))

    self.insert(type: type, name: "__new__", value: PyStaticMethod.wrapNew(type: type, doc: nil, fn: PyResourceWarning.pyResourceWarningNew(type:args:kwargs:)))
    self.insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PyResourceWarning.pyResourceWarningInit(args:kwargs:), castSelf: Self.asResourceWarningOptional))
  }

  private static func asResourceWarning(functionName: String, object: PyObject) -> PyResult<PyResourceWarning> {
    switch PyCast.asResourceWarning(object) {
    case .some(let o):
        return .value(o)
    case .none:
      return .typeError(
        "descriptor '\(functionName)' requires a 'ResourceWarning' object " +
        "but received a '\(object.typeName)'"
      )
    }
  }

  private static func asResourceWarningOptional(object: PyObject) -> PyResourceWarning? {
    return PyCast.asResourceWarning(object)
  }

}
