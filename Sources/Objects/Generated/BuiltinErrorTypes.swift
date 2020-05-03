import VioletCore

// swiftlint:disable line_length
// swiftlint:disable function_body_length
// swiftlint:disable trailing_comma
// swiftlint:disable vertical_whitespace_closing_braces
// swiftlint:disable file_length

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
    let interned = Py.intern(name)

    switch dict.set(key: interned, to: value) {
    case .ok:
      break
    case .error(let e):
      let typeName = type.getNameRaw()
      trap("Error when inserting '\(name)' to '\(typeName)' type: \(e)")
    }
  }

  /// Basically:
  /// We hold 'PyObjects' on stack.
  /// We need to call Swift method that needs specific 'self' type.
  /// This method is responsible for downcasting 'PyObject' -> specific Swift type.
  private static func cast<T>(_ object: PyObject,
                              as type: T.Type,
                              typeName: String,
                              methodName: String) -> PyResult<T> {
    if let v = object as? T {
      return .value(v)
    }

    return .typeError(
      "descriptor '\(methodName)' requires a '\(typeName)' object " +
      "but received a '\(object.typeName)'"
    )
  }

  // MARK: - BaseException

  func fillBaseException() {
    let type = self.baseException
    type.setBuiltinTypeDoc(PyBaseException.doc)
    type.setFlag(.baseExceptionSubclass)
    type.setFlag(.baseType)
    type.setFlag(.default)
    type.setFlag(.hasGC)

    self.insert(type: type, name: "__dict__", value: PyProperty.wrap(name: "__dict__", doc: nil, get: PyBaseException.getDict, castSelf: Self.asBaseException))
    self.insert(type: type, name: "__class__", value: PyProperty.wrap(name: "__class__", doc: nil, get: PyBaseException.getClass, castSelf: Self.asBaseException))
    self.insert(type: type, name: "args", value: PyProperty.wrap(name: "args", doc: nil, get: PyBaseException.getArgs, set: PyBaseException.setArgs, castSelf: Self.asBaseException))
    self.insert(type: type, name: "__traceback__", value: PyProperty.wrap(name: "__traceback__", doc: nil, get: PyBaseException.getTraceback, set: PyBaseException.setTraceback, castSelf: Self.asBaseException))
    self.insert(type: type, name: "__cause__", value: PyProperty.wrap(name: "__cause__", doc: PyBaseException.getCauseDoc, get: PyBaseException.getCause, set: PyBaseException.setCause, castSelf: Self.asBaseException))
    self.insert(type: type, name: "__context__", value: PyProperty.wrap(name: "__context__", doc: PyBaseException.getContextDoc, get: PyBaseException.getContext, set: PyBaseException.setContext, castSelf: Self.asBaseException))
    self.insert(type: type, name: "__suppress_context__", value: PyProperty.wrap(name: "__suppress_context__", doc: nil, get: PyBaseException.getSuppressContext, set: PyBaseException.setSuppressContext, castSelf: Self.asBaseException))

    self.insert(type: type, name: "__new__", value: PyStaticMethod.wrapNew(type: type, doc: nil, fn: PyBaseException.pyNew(type:args:kwargs:)))
    self.insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PyBaseException.pyInit(args:kwargs:)))

    self.insert(type: type, name: "__repr__", value: PyBuiltinFunction.wrap(name: "__repr__", doc: nil, fn: PyBaseException.repr, castSelf: Self.asBaseException))
    self.insert(type: type, name: "__str__", value: PyBuiltinFunction.wrap(name: "__str__", doc: nil, fn: PyBaseException.str, castSelf: Self.asBaseException))
    self.insert(type: type, name: "__getattribute__", value: PyBuiltinFunction.wrap(name: "__getattribute__", doc: nil, fn: PyBaseException.getAttribute(name:), castSelf: Self.asBaseException))
    self.insert(type: type, name: "__setattr__", value: PyBuiltinFunction.wrap(name: "__setattr__", doc: nil, fn: PyBaseException.setAttribute(name:value:), castSelf: Self.asBaseException))
    self.insert(type: type, name: "__delattr__", value: PyBuiltinFunction.wrap(name: "__delattr__", doc: nil, fn: PyBaseException.delAttribute(name:), castSelf: Self.asBaseException))
    self.insert(type: type, name: "with_traceback", value: PyBuiltinFunction.wrap(name: "with_traceback", doc: PyBaseException.withTracebackDoc, fn: PyBaseException.withTraceback(traceback:), castSelf: Self.asBaseException))
  }

  private static func asBaseException(_ object: PyObject, methodName: String) -> PyResult<PyBaseException> {
    return Self.cast(
      object,
      as: PyBaseException.self,
      typeName: "BaseException",
      methodName: methodName
    )
  }

  // MARK: - SystemExit

  func fillSystemExit() {
    let type = self.systemExit
    type.setBuiltinTypeDoc(PySystemExit.doc)
    type.setFlag(.baseExceptionSubclass)
    type.setFlag(.baseType)
    type.setFlag(.default)
    type.setFlag(.hasGC)

    self.insert(type: type, name: "__class__", value: PyProperty.wrap(name: "__class__", doc: nil, get: PySystemExit.getClass, castSelf: Self.asSystemExit))
    self.insert(type: type, name: "__dict__", value: PyProperty.wrap(name: "__dict__", doc: nil, get: PySystemExit.getDict, castSelf: Self.asSystemExit))

    self.insert(type: type, name: "__new__", value: PyStaticMethod.wrapNew(type: type, doc: nil, fn: PySystemExit.pyNew(type:args:kwargs:)))
    self.insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PySystemExit.pyInit(args:kwargs:)))
  }

  private static func asSystemExit(_ object: PyObject, methodName: String) -> PyResult<PySystemExit> {
    return Self.cast(
      object,
      as: PySystemExit.self,
      typeName: "SystemExit",
      methodName: methodName
    )
  }

  // MARK: - KeyboardInterrupt

  func fillKeyboardInterrupt() {
    let type = self.keyboardInterrupt
    type.setBuiltinTypeDoc(PyKeyboardInterrupt.doc)
    type.setFlag(.baseExceptionSubclass)
    type.setFlag(.baseType)
    type.setFlag(.default)
    type.setFlag(.hasGC)

    self.insert(type: type, name: "__class__", value: PyProperty.wrap(name: "__class__", doc: nil, get: PyKeyboardInterrupt.getClass, castSelf: Self.asKeyboardInterrupt))
    self.insert(type: type, name: "__dict__", value: PyProperty.wrap(name: "__dict__", doc: nil, get: PyKeyboardInterrupt.getDict, castSelf: Self.asKeyboardInterrupt))

    self.insert(type: type, name: "__new__", value: PyStaticMethod.wrapNew(type: type, doc: nil, fn: PyKeyboardInterrupt.pyNew(type:args:kwargs:)))
    self.insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PyKeyboardInterrupt.pyInit(args:kwargs:)))
  }

  private static func asKeyboardInterrupt(_ object: PyObject, methodName: String) -> PyResult<PyKeyboardInterrupt> {
    return Self.cast(
      object,
      as: PyKeyboardInterrupt.self,
      typeName: "KeyboardInterrupt",
      methodName: methodName
    )
  }

  // MARK: - GeneratorExit

  func fillGeneratorExit() {
    let type = self.generatorExit
    type.setBuiltinTypeDoc(PyGeneratorExit.doc)
    type.setFlag(.baseExceptionSubclass)
    type.setFlag(.baseType)
    type.setFlag(.default)
    type.setFlag(.hasGC)

    self.insert(type: type, name: "__class__", value: PyProperty.wrap(name: "__class__", doc: nil, get: PyGeneratorExit.getClass, castSelf: Self.asGeneratorExit))
    self.insert(type: type, name: "__dict__", value: PyProperty.wrap(name: "__dict__", doc: nil, get: PyGeneratorExit.getDict, castSelf: Self.asGeneratorExit))

    self.insert(type: type, name: "__new__", value: PyStaticMethod.wrapNew(type: type, doc: nil, fn: PyGeneratorExit.pyNew(type:args:kwargs:)))
    self.insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PyGeneratorExit.pyInit(args:kwargs:)))
  }

  private static func asGeneratorExit(_ object: PyObject, methodName: String) -> PyResult<PyGeneratorExit> {
    return Self.cast(
      object,
      as: PyGeneratorExit.self,
      typeName: "GeneratorExit",
      methodName: methodName
    )
  }

  // MARK: - Exception

  func fillException() {
    let type = self.exception
    type.setBuiltinTypeDoc(PyException.doc)
    type.setFlag(.baseExceptionSubclass)
    type.setFlag(.baseType)
    type.setFlag(.default)
    type.setFlag(.hasGC)

    self.insert(type: type, name: "__class__", value: PyProperty.wrap(name: "__class__", doc: nil, get: PyException.getClass, castSelf: Self.asException))
    self.insert(type: type, name: "__dict__", value: PyProperty.wrap(name: "__dict__", doc: nil, get: PyException.getDict, castSelf: Self.asException))

    self.insert(type: type, name: "__new__", value: PyStaticMethod.wrapNew(type: type, doc: nil, fn: PyException.pyNew(type:args:kwargs:)))
    self.insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PyException.pyInit(args:kwargs:)))
  }

  private static func asException(_ object: PyObject, methodName: String) -> PyResult<PyException> {
    return Self.cast(
      object,
      as: PyException.self,
      typeName: "Exception",
      methodName: methodName
    )
  }

  // MARK: - StopIteration

  func fillStopIteration() {
    let type = self.stopIteration
    type.setBuiltinTypeDoc(PyStopIteration.doc)
    type.setFlag(.baseExceptionSubclass)
    type.setFlag(.baseType)
    type.setFlag(.default)
    type.setFlag(.hasGC)

    self.insert(type: type, name: "__class__", value: PyProperty.wrap(name: "__class__", doc: nil, get: PyStopIteration.getClass, castSelf: Self.asStopIteration))
    self.insert(type: type, name: "__dict__", value: PyProperty.wrap(name: "__dict__", doc: nil, get: PyStopIteration.getDict, castSelf: Self.asStopIteration))

    self.insert(type: type, name: "__new__", value: PyStaticMethod.wrapNew(type: type, doc: nil, fn: PyStopIteration.pyNew(type:args:kwargs:)))
    self.insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PyStopIteration.pyInit(args:kwargs:)))
  }

  private static func asStopIteration(_ object: PyObject, methodName: String) -> PyResult<PyStopIteration> {
    return Self.cast(
      object,
      as: PyStopIteration.self,
      typeName: "StopIteration",
      methodName: methodName
    )
  }

  // MARK: - StopAsyncIteration

  func fillStopAsyncIteration() {
    let type = self.stopAsyncIteration
    type.setBuiltinTypeDoc(PyStopAsyncIteration.doc)
    type.setFlag(.baseExceptionSubclass)
    type.setFlag(.baseType)
    type.setFlag(.default)
    type.setFlag(.hasGC)

    self.insert(type: type, name: "__class__", value: PyProperty.wrap(name: "__class__", doc: nil, get: PyStopAsyncIteration.getClass, castSelf: Self.asStopAsyncIteration))
    self.insert(type: type, name: "__dict__", value: PyProperty.wrap(name: "__dict__", doc: nil, get: PyStopAsyncIteration.getDict, castSelf: Self.asStopAsyncIteration))

    self.insert(type: type, name: "__new__", value: PyStaticMethod.wrapNew(type: type, doc: nil, fn: PyStopAsyncIteration.pyNew(type:args:kwargs:)))
    self.insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PyStopAsyncIteration.pyInit(args:kwargs:)))
  }

  private static func asStopAsyncIteration(_ object: PyObject, methodName: String) -> PyResult<PyStopAsyncIteration> {
    return Self.cast(
      object,
      as: PyStopAsyncIteration.self,
      typeName: "StopAsyncIteration",
      methodName: methodName
    )
  }

  // MARK: - ArithmeticError

  func fillArithmeticError() {
    let type = self.arithmeticError
    type.setBuiltinTypeDoc(PyArithmeticError.doc)
    type.setFlag(.baseExceptionSubclass)
    type.setFlag(.baseType)
    type.setFlag(.default)
    type.setFlag(.hasGC)

    self.insert(type: type, name: "__class__", value: PyProperty.wrap(name: "__class__", doc: nil, get: PyArithmeticError.getClass, castSelf: Self.asArithmeticError))
    self.insert(type: type, name: "__dict__", value: PyProperty.wrap(name: "__dict__", doc: nil, get: PyArithmeticError.getDict, castSelf: Self.asArithmeticError))

    self.insert(type: type, name: "__new__", value: PyStaticMethod.wrapNew(type: type, doc: nil, fn: PyArithmeticError.pyNew(type:args:kwargs:)))
    self.insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PyArithmeticError.pyInit(args:kwargs:)))
  }

  private static func asArithmeticError(_ object: PyObject, methodName: String) -> PyResult<PyArithmeticError> {
    return Self.cast(
      object,
      as: PyArithmeticError.self,
      typeName: "ArithmeticError",
      methodName: methodName
    )
  }

  // MARK: - FloatingPointError

  func fillFloatingPointError() {
    let type = self.floatingPointError
    type.setBuiltinTypeDoc(PyFloatingPointError.doc)
    type.setFlag(.baseExceptionSubclass)
    type.setFlag(.baseType)
    type.setFlag(.default)
    type.setFlag(.hasGC)

    self.insert(type: type, name: "__class__", value: PyProperty.wrap(name: "__class__", doc: nil, get: PyFloatingPointError.getClass, castSelf: Self.asFloatingPointError))
    self.insert(type: type, name: "__dict__", value: PyProperty.wrap(name: "__dict__", doc: nil, get: PyFloatingPointError.getDict, castSelf: Self.asFloatingPointError))

    self.insert(type: type, name: "__new__", value: PyStaticMethod.wrapNew(type: type, doc: nil, fn: PyFloatingPointError.pyNew(type:args:kwargs:)))
    self.insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PyFloatingPointError.pyInit(args:kwargs:)))
  }

  private static func asFloatingPointError(_ object: PyObject, methodName: String) -> PyResult<PyFloatingPointError> {
    return Self.cast(
      object,
      as: PyFloatingPointError.self,
      typeName: "FloatingPointError",
      methodName: methodName
    )
  }

  // MARK: - OverflowError

  func fillOverflowError() {
    let type = self.overflowError
    type.setBuiltinTypeDoc(PyOverflowError.doc)
    type.setFlag(.baseExceptionSubclass)
    type.setFlag(.baseType)
    type.setFlag(.default)
    type.setFlag(.hasGC)

    self.insert(type: type, name: "__class__", value: PyProperty.wrap(name: "__class__", doc: nil, get: PyOverflowError.getClass, castSelf: Self.asOverflowError))
    self.insert(type: type, name: "__dict__", value: PyProperty.wrap(name: "__dict__", doc: nil, get: PyOverflowError.getDict, castSelf: Self.asOverflowError))

    self.insert(type: type, name: "__new__", value: PyStaticMethod.wrapNew(type: type, doc: nil, fn: PyOverflowError.pyNew(type:args:kwargs:)))
    self.insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PyOverflowError.pyInit(args:kwargs:)))
  }

  private static func asOverflowError(_ object: PyObject, methodName: String) -> PyResult<PyOverflowError> {
    return Self.cast(
      object,
      as: PyOverflowError.self,
      typeName: "OverflowError",
      methodName: methodName
    )
  }

  // MARK: - ZeroDivisionError

  func fillZeroDivisionError() {
    let type = self.zeroDivisionError
    type.setBuiltinTypeDoc(PyZeroDivisionError.doc)
    type.setFlag(.baseExceptionSubclass)
    type.setFlag(.baseType)
    type.setFlag(.default)
    type.setFlag(.hasGC)

    self.insert(type: type, name: "__class__", value: PyProperty.wrap(name: "__class__", doc: nil, get: PyZeroDivisionError.getClass, castSelf: Self.asZeroDivisionError))
    self.insert(type: type, name: "__dict__", value: PyProperty.wrap(name: "__dict__", doc: nil, get: PyZeroDivisionError.getDict, castSelf: Self.asZeroDivisionError))

    self.insert(type: type, name: "__new__", value: PyStaticMethod.wrapNew(type: type, doc: nil, fn: PyZeroDivisionError.pyNew(type:args:kwargs:)))
    self.insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PyZeroDivisionError.pyInit(args:kwargs:)))
  }

  private static func asZeroDivisionError(_ object: PyObject, methodName: String) -> PyResult<PyZeroDivisionError> {
    return Self.cast(
      object,
      as: PyZeroDivisionError.self,
      typeName: "ZeroDivisionError",
      methodName: methodName
    )
  }

  // MARK: - AssertionError

  func fillAssertionError() {
    let type = self.assertionError
    type.setBuiltinTypeDoc(PyAssertionError.doc)
    type.setFlag(.baseExceptionSubclass)
    type.setFlag(.baseType)
    type.setFlag(.default)
    type.setFlag(.hasGC)

    self.insert(type: type, name: "__class__", value: PyProperty.wrap(name: "__class__", doc: nil, get: PyAssertionError.getClass, castSelf: Self.asAssertionError))
    self.insert(type: type, name: "__dict__", value: PyProperty.wrap(name: "__dict__", doc: nil, get: PyAssertionError.getDict, castSelf: Self.asAssertionError))

    self.insert(type: type, name: "__new__", value: PyStaticMethod.wrapNew(type: type, doc: nil, fn: PyAssertionError.pyNew(type:args:kwargs:)))
    self.insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PyAssertionError.pyInit(args:kwargs:)))
  }

  private static func asAssertionError(_ object: PyObject, methodName: String) -> PyResult<PyAssertionError> {
    return Self.cast(
      object,
      as: PyAssertionError.self,
      typeName: "AssertionError",
      methodName: methodName
    )
  }

  // MARK: - AttributeError

  func fillAttributeError() {
    let type = self.attributeError
    type.setBuiltinTypeDoc(PyAttributeError.doc)
    type.setFlag(.baseExceptionSubclass)
    type.setFlag(.baseType)
    type.setFlag(.default)
    type.setFlag(.hasGC)

    self.insert(type: type, name: "__class__", value: PyProperty.wrap(name: "__class__", doc: nil, get: PyAttributeError.getClass, castSelf: Self.asAttributeError))
    self.insert(type: type, name: "__dict__", value: PyProperty.wrap(name: "__dict__", doc: nil, get: PyAttributeError.getDict, castSelf: Self.asAttributeError))

    self.insert(type: type, name: "__new__", value: PyStaticMethod.wrapNew(type: type, doc: nil, fn: PyAttributeError.pyNew(type:args:kwargs:)))
    self.insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PyAttributeError.pyInit(args:kwargs:)))
  }

  private static func asAttributeError(_ object: PyObject, methodName: String) -> PyResult<PyAttributeError> {
    return Self.cast(
      object,
      as: PyAttributeError.self,
      typeName: "AttributeError",
      methodName: methodName
    )
  }

  // MARK: - BufferError

  func fillBufferError() {
    let type = self.bufferError
    type.setBuiltinTypeDoc(PyBufferError.doc)
    type.setFlag(.baseExceptionSubclass)
    type.setFlag(.baseType)
    type.setFlag(.default)
    type.setFlag(.hasGC)

    self.insert(type: type, name: "__class__", value: PyProperty.wrap(name: "__class__", doc: nil, get: PyBufferError.getClass, castSelf: Self.asBufferError))
    self.insert(type: type, name: "__dict__", value: PyProperty.wrap(name: "__dict__", doc: nil, get: PyBufferError.getDict, castSelf: Self.asBufferError))

    self.insert(type: type, name: "__new__", value: PyStaticMethod.wrapNew(type: type, doc: nil, fn: PyBufferError.pyNew(type:args:kwargs:)))
    self.insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PyBufferError.pyInit(args:kwargs:)))
  }

  private static func asBufferError(_ object: PyObject, methodName: String) -> PyResult<PyBufferError> {
    return Self.cast(
      object,
      as: PyBufferError.self,
      typeName: "BufferError",
      methodName: methodName
    )
  }

  // MARK: - EOFError

  func fillEOFError() {
    let type = self.eofError
    type.setBuiltinTypeDoc(PyEOFError.doc)
    type.setFlag(.baseExceptionSubclass)
    type.setFlag(.baseType)
    type.setFlag(.default)
    type.setFlag(.hasGC)

    self.insert(type: type, name: "__class__", value: PyProperty.wrap(name: "__class__", doc: nil, get: PyEOFError.getClass, castSelf: Self.asEOFError))
    self.insert(type: type, name: "__dict__", value: PyProperty.wrap(name: "__dict__", doc: nil, get: PyEOFError.getDict, castSelf: Self.asEOFError))

    self.insert(type: type, name: "__new__", value: PyStaticMethod.wrapNew(type: type, doc: nil, fn: PyEOFError.pyNew(type:args:kwargs:)))
    self.insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PyEOFError.pyInit(args:kwargs:)))
  }

  private static func asEOFError(_ object: PyObject, methodName: String) -> PyResult<PyEOFError> {
    return Self.cast(
      object,
      as: PyEOFError.self,
      typeName: "EOFError",
      methodName: methodName
    )
  }

  // MARK: - ImportError

  func fillImportError() {
    let type = self.importError
    type.setBuiltinTypeDoc(PyImportError.doc)
    type.setFlag(.baseExceptionSubclass)
    type.setFlag(.baseType)
    type.setFlag(.default)
    type.setFlag(.hasGC)

    self.insert(type: type, name: "__class__", value: PyProperty.wrap(name: "__class__", doc: nil, get: PyImportError.getClass, castSelf: Self.asImportError))
    self.insert(type: type, name: "__dict__", value: PyProperty.wrap(name: "__dict__", doc: nil, get: PyImportError.getDict, castSelf: Self.asImportError))

    self.insert(type: type, name: "__new__", value: PyStaticMethod.wrapNew(type: type, doc: nil, fn: PyImportError.pyNew(type:args:kwargs:)))
    self.insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PyImportError.pyInit(args:kwargs:)))
  }

  private static func asImportError(_ object: PyObject, methodName: String) -> PyResult<PyImportError> {
    return Self.cast(
      object,
      as: PyImportError.self,
      typeName: "ImportError",
      methodName: methodName
    )
  }

  // MARK: - ModuleNotFoundError

  func fillModuleNotFoundError() {
    let type = self.moduleNotFoundError
    type.setBuiltinTypeDoc(PyModuleNotFoundError.doc)
    type.setFlag(.baseExceptionSubclass)
    type.setFlag(.baseType)
    type.setFlag(.default)
    type.setFlag(.hasGC)

    self.insert(type: type, name: "__class__", value: PyProperty.wrap(name: "__class__", doc: nil, get: PyModuleNotFoundError.getClass, castSelf: Self.asModuleNotFoundError))
    self.insert(type: type, name: "__dict__", value: PyProperty.wrap(name: "__dict__", doc: nil, get: PyModuleNotFoundError.getDict, castSelf: Self.asModuleNotFoundError))

    self.insert(type: type, name: "__new__", value: PyStaticMethod.wrapNew(type: type, doc: nil, fn: PyModuleNotFoundError.pyNew(type:args:kwargs:)))
    self.insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PyModuleNotFoundError.pyInit(args:kwargs:)))
  }

  private static func asModuleNotFoundError(_ object: PyObject, methodName: String) -> PyResult<PyModuleNotFoundError> {
    return Self.cast(
      object,
      as: PyModuleNotFoundError.self,
      typeName: "ModuleNotFoundError",
      methodName: methodName
    )
  }

  // MARK: - LookupError

  func fillLookupError() {
    let type = self.lookupError
    type.setBuiltinTypeDoc(PyLookupError.doc)
    type.setFlag(.baseExceptionSubclass)
    type.setFlag(.baseType)
    type.setFlag(.default)
    type.setFlag(.hasGC)

    self.insert(type: type, name: "__class__", value: PyProperty.wrap(name: "__class__", doc: nil, get: PyLookupError.getClass, castSelf: Self.asLookupError))
    self.insert(type: type, name: "__dict__", value: PyProperty.wrap(name: "__dict__", doc: nil, get: PyLookupError.getDict, castSelf: Self.asLookupError))

    self.insert(type: type, name: "__new__", value: PyStaticMethod.wrapNew(type: type, doc: nil, fn: PyLookupError.pyNew(type:args:kwargs:)))
    self.insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PyLookupError.pyInit(args:kwargs:)))
  }

  private static func asLookupError(_ object: PyObject, methodName: String) -> PyResult<PyLookupError> {
    return Self.cast(
      object,
      as: PyLookupError.self,
      typeName: "LookupError",
      methodName: methodName
    )
  }

  // MARK: - IndexError

  func fillIndexError() {
    let type = self.indexError
    type.setBuiltinTypeDoc(PyIndexError.doc)
    type.setFlag(.baseExceptionSubclass)
    type.setFlag(.baseType)
    type.setFlag(.default)
    type.setFlag(.hasGC)

    self.insert(type: type, name: "__class__", value: PyProperty.wrap(name: "__class__", doc: nil, get: PyIndexError.getClass, castSelf: Self.asIndexError))
    self.insert(type: type, name: "__dict__", value: PyProperty.wrap(name: "__dict__", doc: nil, get: PyIndexError.getDict, castSelf: Self.asIndexError))

    self.insert(type: type, name: "__new__", value: PyStaticMethod.wrapNew(type: type, doc: nil, fn: PyIndexError.pyNew(type:args:kwargs:)))
    self.insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PyIndexError.pyInit(args:kwargs:)))
  }

  private static func asIndexError(_ object: PyObject, methodName: String) -> PyResult<PyIndexError> {
    return Self.cast(
      object,
      as: PyIndexError.self,
      typeName: "IndexError",
      methodName: methodName
    )
  }

  // MARK: - KeyError

  func fillKeyError() {
    let type = self.keyError
    type.setBuiltinTypeDoc(PyKeyError.doc)
    type.setFlag(.baseExceptionSubclass)
    type.setFlag(.baseType)
    type.setFlag(.default)
    type.setFlag(.hasGC)

    self.insert(type: type, name: "__class__", value: PyProperty.wrap(name: "__class__", doc: nil, get: PyKeyError.getClass, castSelf: Self.asKeyError))
    self.insert(type: type, name: "__dict__", value: PyProperty.wrap(name: "__dict__", doc: nil, get: PyKeyError.getDict, castSelf: Self.asKeyError))

    self.insert(type: type, name: "__new__", value: PyStaticMethod.wrapNew(type: type, doc: nil, fn: PyKeyError.pyNew(type:args:kwargs:)))
    self.insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PyKeyError.pyInit(args:kwargs:)))
  }

  private static func asKeyError(_ object: PyObject, methodName: String) -> PyResult<PyKeyError> {
    return Self.cast(
      object,
      as: PyKeyError.self,
      typeName: "KeyError",
      methodName: methodName
    )
  }

  // MARK: - MemoryError

  func fillMemoryError() {
    let type = self.memoryError
    type.setBuiltinTypeDoc(PyMemoryError.doc)
    type.setFlag(.baseExceptionSubclass)
    type.setFlag(.baseType)
    type.setFlag(.default)
    type.setFlag(.hasGC)

    self.insert(type: type, name: "__class__", value: PyProperty.wrap(name: "__class__", doc: nil, get: PyMemoryError.getClass, castSelf: Self.asMemoryError))
    self.insert(type: type, name: "__dict__", value: PyProperty.wrap(name: "__dict__", doc: nil, get: PyMemoryError.getDict, castSelf: Self.asMemoryError))

    self.insert(type: type, name: "__new__", value: PyStaticMethod.wrapNew(type: type, doc: nil, fn: PyMemoryError.pyNew(type:args:kwargs:)))
    self.insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PyMemoryError.pyInit(args:kwargs:)))
  }

  private static func asMemoryError(_ object: PyObject, methodName: String) -> PyResult<PyMemoryError> {
    return Self.cast(
      object,
      as: PyMemoryError.self,
      typeName: "MemoryError",
      methodName: methodName
    )
  }

  // MARK: - NameError

  func fillNameError() {
    let type = self.nameError
    type.setBuiltinTypeDoc(PyNameError.doc)
    type.setFlag(.baseExceptionSubclass)
    type.setFlag(.baseType)
    type.setFlag(.default)
    type.setFlag(.hasGC)

    self.insert(type: type, name: "__class__", value: PyProperty.wrap(name: "__class__", doc: nil, get: PyNameError.getClass, castSelf: Self.asNameError))
    self.insert(type: type, name: "__dict__", value: PyProperty.wrap(name: "__dict__", doc: nil, get: PyNameError.getDict, castSelf: Self.asNameError))

    self.insert(type: type, name: "__new__", value: PyStaticMethod.wrapNew(type: type, doc: nil, fn: PyNameError.pyNew(type:args:kwargs:)))
    self.insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PyNameError.pyInit(args:kwargs:)))
  }

  private static func asNameError(_ object: PyObject, methodName: String) -> PyResult<PyNameError> {
    return Self.cast(
      object,
      as: PyNameError.self,
      typeName: "NameError",
      methodName: methodName
    )
  }

  // MARK: - UnboundLocalError

  func fillUnboundLocalError() {
    let type = self.unboundLocalError
    type.setBuiltinTypeDoc(PyUnboundLocalError.doc)
    type.setFlag(.baseExceptionSubclass)
    type.setFlag(.baseType)
    type.setFlag(.default)
    type.setFlag(.hasGC)

    self.insert(type: type, name: "__class__", value: PyProperty.wrap(name: "__class__", doc: nil, get: PyUnboundLocalError.getClass, castSelf: Self.asUnboundLocalError))
    self.insert(type: type, name: "__dict__", value: PyProperty.wrap(name: "__dict__", doc: nil, get: PyUnboundLocalError.getDict, castSelf: Self.asUnboundLocalError))

    self.insert(type: type, name: "__new__", value: PyStaticMethod.wrapNew(type: type, doc: nil, fn: PyUnboundLocalError.pyNew(type:args:kwargs:)))
    self.insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PyUnboundLocalError.pyInit(args:kwargs:)))
  }

  private static func asUnboundLocalError(_ object: PyObject, methodName: String) -> PyResult<PyUnboundLocalError> {
    return Self.cast(
      object,
      as: PyUnboundLocalError.self,
      typeName: "UnboundLocalError",
      methodName: methodName
    )
  }

  // MARK: - OSError

  func fillOSError() {
    let type = self.osError
    type.setBuiltinTypeDoc(PyOSError.doc)
    type.setFlag(.baseExceptionSubclass)
    type.setFlag(.baseType)
    type.setFlag(.default)
    type.setFlag(.hasGC)

    self.insert(type: type, name: "__class__", value: PyProperty.wrap(name: "__class__", doc: nil, get: PyOSError.getClass, castSelf: Self.asOSError))
    self.insert(type: type, name: "__dict__", value: PyProperty.wrap(name: "__dict__", doc: nil, get: PyOSError.getDict, castSelf: Self.asOSError))

    self.insert(type: type, name: "__new__", value: PyStaticMethod.wrapNew(type: type, doc: nil, fn: PyOSError.pyNew(type:args:kwargs:)))
    self.insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PyOSError.pyInit(args:kwargs:)))
  }

  private static func asOSError(_ object: PyObject, methodName: String) -> PyResult<PyOSError> {
    return Self.cast(
      object,
      as: PyOSError.self,
      typeName: "OSError",
      methodName: methodName
    )
  }

  // MARK: - BlockingIOError

  func fillBlockingIOError() {
    let type = self.blockingIOError
    type.setBuiltinTypeDoc(PyBlockingIOError.doc)
    type.setFlag(.baseExceptionSubclass)
    type.setFlag(.baseType)
    type.setFlag(.default)
    type.setFlag(.hasGC)

    self.insert(type: type, name: "__class__", value: PyProperty.wrap(name: "__class__", doc: nil, get: PyBlockingIOError.getClass, castSelf: Self.asBlockingIOError))
    self.insert(type: type, name: "__dict__", value: PyProperty.wrap(name: "__dict__", doc: nil, get: PyBlockingIOError.getDict, castSelf: Self.asBlockingIOError))

    self.insert(type: type, name: "__new__", value: PyStaticMethod.wrapNew(type: type, doc: nil, fn: PyBlockingIOError.pyNew(type:args:kwargs:)))
    self.insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PyBlockingIOError.pyInit(args:kwargs:)))
  }

  private static func asBlockingIOError(_ object: PyObject, methodName: String) -> PyResult<PyBlockingIOError> {
    return Self.cast(
      object,
      as: PyBlockingIOError.self,
      typeName: "BlockingIOError",
      methodName: methodName
    )
  }

  // MARK: - ChildProcessError

  func fillChildProcessError() {
    let type = self.childProcessError
    type.setBuiltinTypeDoc(PyChildProcessError.doc)
    type.setFlag(.baseExceptionSubclass)
    type.setFlag(.baseType)
    type.setFlag(.default)
    type.setFlag(.hasGC)

    self.insert(type: type, name: "__class__", value: PyProperty.wrap(name: "__class__", doc: nil, get: PyChildProcessError.getClass, castSelf: Self.asChildProcessError))
    self.insert(type: type, name: "__dict__", value: PyProperty.wrap(name: "__dict__", doc: nil, get: PyChildProcessError.getDict, castSelf: Self.asChildProcessError))

    self.insert(type: type, name: "__new__", value: PyStaticMethod.wrapNew(type: type, doc: nil, fn: PyChildProcessError.pyNew(type:args:kwargs:)))
    self.insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PyChildProcessError.pyInit(args:kwargs:)))
  }

  private static func asChildProcessError(_ object: PyObject, methodName: String) -> PyResult<PyChildProcessError> {
    return Self.cast(
      object,
      as: PyChildProcessError.self,
      typeName: "ChildProcessError",
      methodName: methodName
    )
  }

  // MARK: - ConnectionError

  func fillConnectionError() {
    let type = self.connectionError
    type.setBuiltinTypeDoc(PyConnectionError.doc)
    type.setFlag(.baseExceptionSubclass)
    type.setFlag(.baseType)
    type.setFlag(.default)
    type.setFlag(.hasGC)

    self.insert(type: type, name: "__class__", value: PyProperty.wrap(name: "__class__", doc: nil, get: PyConnectionError.getClass, castSelf: Self.asConnectionError))
    self.insert(type: type, name: "__dict__", value: PyProperty.wrap(name: "__dict__", doc: nil, get: PyConnectionError.getDict, castSelf: Self.asConnectionError))

    self.insert(type: type, name: "__new__", value: PyStaticMethod.wrapNew(type: type, doc: nil, fn: PyConnectionError.pyNew(type:args:kwargs:)))
    self.insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PyConnectionError.pyInit(args:kwargs:)))
  }

  private static func asConnectionError(_ object: PyObject, methodName: String) -> PyResult<PyConnectionError> {
    return Self.cast(
      object,
      as: PyConnectionError.self,
      typeName: "ConnectionError",
      methodName: methodName
    )
  }

  // MARK: - BrokenPipeError

  func fillBrokenPipeError() {
    let type = self.brokenPipeError
    type.setBuiltinTypeDoc(PyBrokenPipeError.doc)
    type.setFlag(.baseExceptionSubclass)
    type.setFlag(.baseType)
    type.setFlag(.default)
    type.setFlag(.hasGC)

    self.insert(type: type, name: "__class__", value: PyProperty.wrap(name: "__class__", doc: nil, get: PyBrokenPipeError.getClass, castSelf: Self.asBrokenPipeError))
    self.insert(type: type, name: "__dict__", value: PyProperty.wrap(name: "__dict__", doc: nil, get: PyBrokenPipeError.getDict, castSelf: Self.asBrokenPipeError))

    self.insert(type: type, name: "__new__", value: PyStaticMethod.wrapNew(type: type, doc: nil, fn: PyBrokenPipeError.pyNew(type:args:kwargs:)))
    self.insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PyBrokenPipeError.pyInit(args:kwargs:)))
  }

  private static func asBrokenPipeError(_ object: PyObject, methodName: String) -> PyResult<PyBrokenPipeError> {
    return Self.cast(
      object,
      as: PyBrokenPipeError.self,
      typeName: "BrokenPipeError",
      methodName: methodName
    )
  }

  // MARK: - ConnectionAbortedError

  func fillConnectionAbortedError() {
    let type = self.connectionAbortedError
    type.setBuiltinTypeDoc(PyConnectionAbortedError.doc)
    type.setFlag(.baseExceptionSubclass)
    type.setFlag(.baseType)
    type.setFlag(.default)
    type.setFlag(.hasGC)

    self.insert(type: type, name: "__class__", value: PyProperty.wrap(name: "__class__", doc: nil, get: PyConnectionAbortedError.getClass, castSelf: Self.asConnectionAbortedError))
    self.insert(type: type, name: "__dict__", value: PyProperty.wrap(name: "__dict__", doc: nil, get: PyConnectionAbortedError.getDict, castSelf: Self.asConnectionAbortedError))

    self.insert(type: type, name: "__new__", value: PyStaticMethod.wrapNew(type: type, doc: nil, fn: PyConnectionAbortedError.pyNew(type:args:kwargs:)))
    self.insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PyConnectionAbortedError.pyInit(args:kwargs:)))
  }

  private static func asConnectionAbortedError(_ object: PyObject, methodName: String) -> PyResult<PyConnectionAbortedError> {
    return Self.cast(
      object,
      as: PyConnectionAbortedError.self,
      typeName: "ConnectionAbortedError",
      methodName: methodName
    )
  }

  // MARK: - ConnectionRefusedError

  func fillConnectionRefusedError() {
    let type = self.connectionRefusedError
    type.setBuiltinTypeDoc(PyConnectionRefusedError.doc)
    type.setFlag(.baseExceptionSubclass)
    type.setFlag(.baseType)
    type.setFlag(.default)
    type.setFlag(.hasGC)

    self.insert(type: type, name: "__class__", value: PyProperty.wrap(name: "__class__", doc: nil, get: PyConnectionRefusedError.getClass, castSelf: Self.asConnectionRefusedError))
    self.insert(type: type, name: "__dict__", value: PyProperty.wrap(name: "__dict__", doc: nil, get: PyConnectionRefusedError.getDict, castSelf: Self.asConnectionRefusedError))

    self.insert(type: type, name: "__new__", value: PyStaticMethod.wrapNew(type: type, doc: nil, fn: PyConnectionRefusedError.pyNew(type:args:kwargs:)))
    self.insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PyConnectionRefusedError.pyInit(args:kwargs:)))
  }

  private static func asConnectionRefusedError(_ object: PyObject, methodName: String) -> PyResult<PyConnectionRefusedError> {
    return Self.cast(
      object,
      as: PyConnectionRefusedError.self,
      typeName: "ConnectionRefusedError",
      methodName: methodName
    )
  }

  // MARK: - ConnectionResetError

  func fillConnectionResetError() {
    let type = self.connectionResetError
    type.setBuiltinTypeDoc(PyConnectionResetError.doc)
    type.setFlag(.baseExceptionSubclass)
    type.setFlag(.baseType)
    type.setFlag(.default)
    type.setFlag(.hasGC)

    self.insert(type: type, name: "__class__", value: PyProperty.wrap(name: "__class__", doc: nil, get: PyConnectionResetError.getClass, castSelf: Self.asConnectionResetError))
    self.insert(type: type, name: "__dict__", value: PyProperty.wrap(name: "__dict__", doc: nil, get: PyConnectionResetError.getDict, castSelf: Self.asConnectionResetError))

    self.insert(type: type, name: "__new__", value: PyStaticMethod.wrapNew(type: type, doc: nil, fn: PyConnectionResetError.pyNew(type:args:kwargs:)))
    self.insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PyConnectionResetError.pyInit(args:kwargs:)))
  }

  private static func asConnectionResetError(_ object: PyObject, methodName: String) -> PyResult<PyConnectionResetError> {
    return Self.cast(
      object,
      as: PyConnectionResetError.self,
      typeName: "ConnectionResetError",
      methodName: methodName
    )
  }

  // MARK: - FileExistsError

  func fillFileExistsError() {
    let type = self.fileExistsError
    type.setBuiltinTypeDoc(PyFileExistsError.doc)
    type.setFlag(.baseExceptionSubclass)
    type.setFlag(.baseType)
    type.setFlag(.default)
    type.setFlag(.hasGC)

    self.insert(type: type, name: "__class__", value: PyProperty.wrap(name: "__class__", doc: nil, get: PyFileExistsError.getClass, castSelf: Self.asFileExistsError))
    self.insert(type: type, name: "__dict__", value: PyProperty.wrap(name: "__dict__", doc: nil, get: PyFileExistsError.getDict, castSelf: Self.asFileExistsError))

    self.insert(type: type, name: "__new__", value: PyStaticMethod.wrapNew(type: type, doc: nil, fn: PyFileExistsError.pyNew(type:args:kwargs:)))
    self.insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PyFileExistsError.pyInit(args:kwargs:)))
  }

  private static func asFileExistsError(_ object: PyObject, methodName: String) -> PyResult<PyFileExistsError> {
    return Self.cast(
      object,
      as: PyFileExistsError.self,
      typeName: "FileExistsError",
      methodName: methodName
    )
  }

  // MARK: - FileNotFoundError

  func fillFileNotFoundError() {
    let type = self.fileNotFoundError
    type.setBuiltinTypeDoc(PyFileNotFoundError.doc)
    type.setFlag(.baseExceptionSubclass)
    type.setFlag(.baseType)
    type.setFlag(.default)
    type.setFlag(.hasGC)

    self.insert(type: type, name: "__class__", value: PyProperty.wrap(name: "__class__", doc: nil, get: PyFileNotFoundError.getClass, castSelf: Self.asFileNotFoundError))
    self.insert(type: type, name: "__dict__", value: PyProperty.wrap(name: "__dict__", doc: nil, get: PyFileNotFoundError.getDict, castSelf: Self.asFileNotFoundError))

    self.insert(type: type, name: "__new__", value: PyStaticMethod.wrapNew(type: type, doc: nil, fn: PyFileNotFoundError.pyNew(type:args:kwargs:)))
    self.insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PyFileNotFoundError.pyInit(args:kwargs:)))
  }

  private static func asFileNotFoundError(_ object: PyObject, methodName: String) -> PyResult<PyFileNotFoundError> {
    return Self.cast(
      object,
      as: PyFileNotFoundError.self,
      typeName: "FileNotFoundError",
      methodName: methodName
    )
  }

  // MARK: - InterruptedError

  func fillInterruptedError() {
    let type = self.interruptedError
    type.setBuiltinTypeDoc(PyInterruptedError.doc)
    type.setFlag(.baseExceptionSubclass)
    type.setFlag(.baseType)
    type.setFlag(.default)
    type.setFlag(.hasGC)

    self.insert(type: type, name: "__class__", value: PyProperty.wrap(name: "__class__", doc: nil, get: PyInterruptedError.getClass, castSelf: Self.asInterruptedError))
    self.insert(type: type, name: "__dict__", value: PyProperty.wrap(name: "__dict__", doc: nil, get: PyInterruptedError.getDict, castSelf: Self.asInterruptedError))

    self.insert(type: type, name: "__new__", value: PyStaticMethod.wrapNew(type: type, doc: nil, fn: PyInterruptedError.pyNew(type:args:kwargs:)))
    self.insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PyInterruptedError.pyInit(args:kwargs:)))
  }

  private static func asInterruptedError(_ object: PyObject, methodName: String) -> PyResult<PyInterruptedError> {
    return Self.cast(
      object,
      as: PyInterruptedError.self,
      typeName: "InterruptedError",
      methodName: methodName
    )
  }

  // MARK: - IsADirectoryError

  func fillIsADirectoryError() {
    let type = self.isADirectoryError
    type.setBuiltinTypeDoc(PyIsADirectoryError.doc)
    type.setFlag(.baseExceptionSubclass)
    type.setFlag(.baseType)
    type.setFlag(.default)
    type.setFlag(.hasGC)

    self.insert(type: type, name: "__class__", value: PyProperty.wrap(name: "__class__", doc: nil, get: PyIsADirectoryError.getClass, castSelf: Self.asIsADirectoryError))
    self.insert(type: type, name: "__dict__", value: PyProperty.wrap(name: "__dict__", doc: nil, get: PyIsADirectoryError.getDict, castSelf: Self.asIsADirectoryError))

    self.insert(type: type, name: "__new__", value: PyStaticMethod.wrapNew(type: type, doc: nil, fn: PyIsADirectoryError.pyNew(type:args:kwargs:)))
    self.insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PyIsADirectoryError.pyInit(args:kwargs:)))
  }

  private static func asIsADirectoryError(_ object: PyObject, methodName: String) -> PyResult<PyIsADirectoryError> {
    return Self.cast(
      object,
      as: PyIsADirectoryError.self,
      typeName: "IsADirectoryError",
      methodName: methodName
    )
  }

  // MARK: - NotADirectoryError

  func fillNotADirectoryError() {
    let type = self.notADirectoryError
    type.setBuiltinTypeDoc(PyNotADirectoryError.doc)
    type.setFlag(.baseExceptionSubclass)
    type.setFlag(.baseType)
    type.setFlag(.default)
    type.setFlag(.hasGC)

    self.insert(type: type, name: "__class__", value: PyProperty.wrap(name: "__class__", doc: nil, get: PyNotADirectoryError.getClass, castSelf: Self.asNotADirectoryError))
    self.insert(type: type, name: "__dict__", value: PyProperty.wrap(name: "__dict__", doc: nil, get: PyNotADirectoryError.getDict, castSelf: Self.asNotADirectoryError))

    self.insert(type: type, name: "__new__", value: PyStaticMethod.wrapNew(type: type, doc: nil, fn: PyNotADirectoryError.pyNew(type:args:kwargs:)))
    self.insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PyNotADirectoryError.pyInit(args:kwargs:)))
  }

  private static func asNotADirectoryError(_ object: PyObject, methodName: String) -> PyResult<PyNotADirectoryError> {
    return Self.cast(
      object,
      as: PyNotADirectoryError.self,
      typeName: "NotADirectoryError",
      methodName: methodName
    )
  }

  // MARK: - PermissionError

  func fillPermissionError() {
    let type = self.permissionError
    type.setBuiltinTypeDoc(PyPermissionError.doc)
    type.setFlag(.baseExceptionSubclass)
    type.setFlag(.baseType)
    type.setFlag(.default)
    type.setFlag(.hasGC)

    self.insert(type: type, name: "__class__", value: PyProperty.wrap(name: "__class__", doc: nil, get: PyPermissionError.getClass, castSelf: Self.asPermissionError))
    self.insert(type: type, name: "__dict__", value: PyProperty.wrap(name: "__dict__", doc: nil, get: PyPermissionError.getDict, castSelf: Self.asPermissionError))

    self.insert(type: type, name: "__new__", value: PyStaticMethod.wrapNew(type: type, doc: nil, fn: PyPermissionError.pyNew(type:args:kwargs:)))
    self.insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PyPermissionError.pyInit(args:kwargs:)))
  }

  private static func asPermissionError(_ object: PyObject, methodName: String) -> PyResult<PyPermissionError> {
    return Self.cast(
      object,
      as: PyPermissionError.self,
      typeName: "PermissionError",
      methodName: methodName
    )
  }

  // MARK: - ProcessLookupError

  func fillProcessLookupError() {
    let type = self.processLookupError
    type.setBuiltinTypeDoc(PyProcessLookupError.doc)
    type.setFlag(.baseExceptionSubclass)
    type.setFlag(.baseType)
    type.setFlag(.default)
    type.setFlag(.hasGC)

    self.insert(type: type, name: "__class__", value: PyProperty.wrap(name: "__class__", doc: nil, get: PyProcessLookupError.getClass, castSelf: Self.asProcessLookupError))
    self.insert(type: type, name: "__dict__", value: PyProperty.wrap(name: "__dict__", doc: nil, get: PyProcessLookupError.getDict, castSelf: Self.asProcessLookupError))

    self.insert(type: type, name: "__new__", value: PyStaticMethod.wrapNew(type: type, doc: nil, fn: PyProcessLookupError.pyNew(type:args:kwargs:)))
    self.insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PyProcessLookupError.pyInit(args:kwargs:)))
  }

  private static func asProcessLookupError(_ object: PyObject, methodName: String) -> PyResult<PyProcessLookupError> {
    return Self.cast(
      object,
      as: PyProcessLookupError.self,
      typeName: "ProcessLookupError",
      methodName: methodName
    )
  }

  // MARK: - TimeoutError

  func fillTimeoutError() {
    let type = self.timeoutError
    type.setBuiltinTypeDoc(PyTimeoutError.doc)
    type.setFlag(.baseExceptionSubclass)
    type.setFlag(.baseType)
    type.setFlag(.default)
    type.setFlag(.hasGC)

    self.insert(type: type, name: "__class__", value: PyProperty.wrap(name: "__class__", doc: nil, get: PyTimeoutError.getClass, castSelf: Self.asTimeoutError))
    self.insert(type: type, name: "__dict__", value: PyProperty.wrap(name: "__dict__", doc: nil, get: PyTimeoutError.getDict, castSelf: Self.asTimeoutError))

    self.insert(type: type, name: "__new__", value: PyStaticMethod.wrapNew(type: type, doc: nil, fn: PyTimeoutError.pyNew(type:args:kwargs:)))
    self.insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PyTimeoutError.pyInit(args:kwargs:)))
  }

  private static func asTimeoutError(_ object: PyObject, methodName: String) -> PyResult<PyTimeoutError> {
    return Self.cast(
      object,
      as: PyTimeoutError.self,
      typeName: "TimeoutError",
      methodName: methodName
    )
  }

  // MARK: - ReferenceError

  func fillReferenceError() {
    let type = self.referenceError
    type.setBuiltinTypeDoc(PyReferenceError.doc)
    type.setFlag(.baseExceptionSubclass)
    type.setFlag(.baseType)
    type.setFlag(.default)
    type.setFlag(.hasGC)

    self.insert(type: type, name: "__class__", value: PyProperty.wrap(name: "__class__", doc: nil, get: PyReferenceError.getClass, castSelf: Self.asReferenceError))
    self.insert(type: type, name: "__dict__", value: PyProperty.wrap(name: "__dict__", doc: nil, get: PyReferenceError.getDict, castSelf: Self.asReferenceError))

    self.insert(type: type, name: "__new__", value: PyStaticMethod.wrapNew(type: type, doc: nil, fn: PyReferenceError.pyNew(type:args:kwargs:)))
    self.insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PyReferenceError.pyInit(args:kwargs:)))
  }

  private static func asReferenceError(_ object: PyObject, methodName: String) -> PyResult<PyReferenceError> {
    return Self.cast(
      object,
      as: PyReferenceError.self,
      typeName: "ReferenceError",
      methodName: methodName
    )
  }

  // MARK: - RuntimeError

  func fillRuntimeError() {
    let type = self.runtimeError
    type.setBuiltinTypeDoc(PyRuntimeError.doc)
    type.setFlag(.baseExceptionSubclass)
    type.setFlag(.baseType)
    type.setFlag(.default)
    type.setFlag(.hasGC)

    self.insert(type: type, name: "__class__", value: PyProperty.wrap(name: "__class__", doc: nil, get: PyRuntimeError.getClass, castSelf: Self.asRuntimeError))
    self.insert(type: type, name: "__dict__", value: PyProperty.wrap(name: "__dict__", doc: nil, get: PyRuntimeError.getDict, castSelf: Self.asRuntimeError))

    self.insert(type: type, name: "__new__", value: PyStaticMethod.wrapNew(type: type, doc: nil, fn: PyRuntimeError.pyNew(type:args:kwargs:)))
    self.insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PyRuntimeError.pyInit(args:kwargs:)))
  }

  private static func asRuntimeError(_ object: PyObject, methodName: String) -> PyResult<PyRuntimeError> {
    return Self.cast(
      object,
      as: PyRuntimeError.self,
      typeName: "RuntimeError",
      methodName: methodName
    )
  }

  // MARK: - NotImplementedError

  func fillNotImplementedError() {
    let type = self.notImplementedError
    type.setBuiltinTypeDoc(PyNotImplementedError.doc)
    type.setFlag(.baseExceptionSubclass)
    type.setFlag(.baseType)
    type.setFlag(.default)
    type.setFlag(.hasGC)

    self.insert(type: type, name: "__class__", value: PyProperty.wrap(name: "__class__", doc: nil, get: PyNotImplementedError.getClass, castSelf: Self.asNotImplementedError))
    self.insert(type: type, name: "__dict__", value: PyProperty.wrap(name: "__dict__", doc: nil, get: PyNotImplementedError.getDict, castSelf: Self.asNotImplementedError))

    self.insert(type: type, name: "__new__", value: PyStaticMethod.wrapNew(type: type, doc: nil, fn: PyNotImplementedError.pyNew(type:args:kwargs:)))
    self.insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PyNotImplementedError.pyInit(args:kwargs:)))
  }

  private static func asNotImplementedError(_ object: PyObject, methodName: String) -> PyResult<PyNotImplementedError> {
    return Self.cast(
      object,
      as: PyNotImplementedError.self,
      typeName: "NotImplementedError",
      methodName: methodName
    )
  }

  // MARK: - RecursionError

  func fillRecursionError() {
    let type = self.recursionError
    type.setBuiltinTypeDoc(PyRecursionError.doc)
    type.setFlag(.baseExceptionSubclass)
    type.setFlag(.baseType)
    type.setFlag(.default)
    type.setFlag(.hasGC)

    self.insert(type: type, name: "__class__", value: PyProperty.wrap(name: "__class__", doc: nil, get: PyRecursionError.getClass, castSelf: Self.asRecursionError))
    self.insert(type: type, name: "__dict__", value: PyProperty.wrap(name: "__dict__", doc: nil, get: PyRecursionError.getDict, castSelf: Self.asRecursionError))

    self.insert(type: type, name: "__new__", value: PyStaticMethod.wrapNew(type: type, doc: nil, fn: PyRecursionError.pyNew(type:args:kwargs:)))
    self.insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PyRecursionError.pyInit(args:kwargs:)))
  }

  private static func asRecursionError(_ object: PyObject, methodName: String) -> PyResult<PyRecursionError> {
    return Self.cast(
      object,
      as: PyRecursionError.self,
      typeName: "RecursionError",
      methodName: methodName
    )
  }

  // MARK: - SyntaxError

  func fillSyntaxError() {
    let type = self.syntaxError
    type.setBuiltinTypeDoc(PySyntaxError.doc)
    type.setFlag(.baseExceptionSubclass)
    type.setFlag(.baseType)
    type.setFlag(.default)
    type.setFlag(.hasGC)

    self.insert(type: type, name: "__class__", value: PyProperty.wrap(name: "__class__", doc: nil, get: PySyntaxError.getClass, castSelf: Self.asSyntaxError))
    self.insert(type: type, name: "__dict__", value: PyProperty.wrap(name: "__dict__", doc: nil, get: PySyntaxError.getDict, castSelf: Self.asSyntaxError))

    self.insert(type: type, name: "__new__", value: PyStaticMethod.wrapNew(type: type, doc: nil, fn: PySyntaxError.pyNew(type:args:kwargs:)))
    self.insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PySyntaxError.pyInit(args:kwargs:)))
  }

  private static func asSyntaxError(_ object: PyObject, methodName: String) -> PyResult<PySyntaxError> {
    return Self.cast(
      object,
      as: PySyntaxError.self,
      typeName: "SyntaxError",
      methodName: methodName
    )
  }

  // MARK: - IndentationError

  func fillIndentationError() {
    let type = self.indentationError
    type.setBuiltinTypeDoc(PyIndentationError.doc)
    type.setFlag(.baseExceptionSubclass)
    type.setFlag(.baseType)
    type.setFlag(.default)
    type.setFlag(.hasGC)

    self.insert(type: type, name: "__class__", value: PyProperty.wrap(name: "__class__", doc: nil, get: PyIndentationError.getClass, castSelf: Self.asIndentationError))
    self.insert(type: type, name: "__dict__", value: PyProperty.wrap(name: "__dict__", doc: nil, get: PyIndentationError.getDict, castSelf: Self.asIndentationError))

    self.insert(type: type, name: "__new__", value: PyStaticMethod.wrapNew(type: type, doc: nil, fn: PyIndentationError.pyNew(type:args:kwargs:)))
    self.insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PyIndentationError.pyInit(args:kwargs:)))
  }

  private static func asIndentationError(_ object: PyObject, methodName: String) -> PyResult<PyIndentationError> {
    return Self.cast(
      object,
      as: PyIndentationError.self,
      typeName: "IndentationError",
      methodName: methodName
    )
  }

  // MARK: - TabError

  func fillTabError() {
    let type = self.tabError
    type.setBuiltinTypeDoc(PyTabError.doc)
    type.setFlag(.baseExceptionSubclass)
    type.setFlag(.baseType)
    type.setFlag(.default)
    type.setFlag(.hasGC)

    self.insert(type: type, name: "__class__", value: PyProperty.wrap(name: "__class__", doc: nil, get: PyTabError.getClass, castSelf: Self.asTabError))
    self.insert(type: type, name: "__dict__", value: PyProperty.wrap(name: "__dict__", doc: nil, get: PyTabError.getDict, castSelf: Self.asTabError))

    self.insert(type: type, name: "__new__", value: PyStaticMethod.wrapNew(type: type, doc: nil, fn: PyTabError.pyNew(type:args:kwargs:)))
    self.insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PyTabError.pyInit(args:kwargs:)))
  }

  private static func asTabError(_ object: PyObject, methodName: String) -> PyResult<PyTabError> {
    return Self.cast(
      object,
      as: PyTabError.self,
      typeName: "TabError",
      methodName: methodName
    )
  }

  // MARK: - SystemError

  func fillSystemError() {
    let type = self.systemError
    type.setBuiltinTypeDoc(PySystemError.doc)
    type.setFlag(.baseExceptionSubclass)
    type.setFlag(.baseType)
    type.setFlag(.default)
    type.setFlag(.hasGC)

    self.insert(type: type, name: "__class__", value: PyProperty.wrap(name: "__class__", doc: nil, get: PySystemError.getClass, castSelf: Self.asSystemError))
    self.insert(type: type, name: "__dict__", value: PyProperty.wrap(name: "__dict__", doc: nil, get: PySystemError.getDict, castSelf: Self.asSystemError))

    self.insert(type: type, name: "__new__", value: PyStaticMethod.wrapNew(type: type, doc: nil, fn: PySystemError.pyNew(type:args:kwargs:)))
    self.insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PySystemError.pyInit(args:kwargs:)))
  }

  private static func asSystemError(_ object: PyObject, methodName: String) -> PyResult<PySystemError> {
    return Self.cast(
      object,
      as: PySystemError.self,
      typeName: "SystemError",
      methodName: methodName
    )
  }

  // MARK: - TypeError

  func fillTypeError() {
    let type = self.typeError
    type.setBuiltinTypeDoc(PyTypeError.doc)
    type.setFlag(.baseExceptionSubclass)
    type.setFlag(.baseType)
    type.setFlag(.default)
    type.setFlag(.hasGC)

    self.insert(type: type, name: "__class__", value: PyProperty.wrap(name: "__class__", doc: nil, get: PyTypeError.getClass, castSelf: Self.asTypeError))
    self.insert(type: type, name: "__dict__", value: PyProperty.wrap(name: "__dict__", doc: nil, get: PyTypeError.getDict, castSelf: Self.asTypeError))

    self.insert(type: type, name: "__new__", value: PyStaticMethod.wrapNew(type: type, doc: nil, fn: PyTypeError.pyNew(type:args:kwargs:)))
    self.insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PyTypeError.pyInit(args:kwargs:)))
  }

  private static func asTypeError(_ object: PyObject, methodName: String) -> PyResult<PyTypeError> {
    return Self.cast(
      object,
      as: PyTypeError.self,
      typeName: "TypeError",
      methodName: methodName
    )
  }

  // MARK: - ValueError

  func fillValueError() {
    let type = self.valueError
    type.setBuiltinTypeDoc(PyValueError.doc)
    type.setFlag(.baseExceptionSubclass)
    type.setFlag(.baseType)
    type.setFlag(.default)
    type.setFlag(.hasGC)

    self.insert(type: type, name: "__class__", value: PyProperty.wrap(name: "__class__", doc: nil, get: PyValueError.getClass, castSelf: Self.asValueError))
    self.insert(type: type, name: "__dict__", value: PyProperty.wrap(name: "__dict__", doc: nil, get: PyValueError.getDict, castSelf: Self.asValueError))

    self.insert(type: type, name: "__new__", value: PyStaticMethod.wrapNew(type: type, doc: nil, fn: PyValueError.pyNew(type:args:kwargs:)))
    self.insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PyValueError.pyInit(args:kwargs:)))
  }

  private static func asValueError(_ object: PyObject, methodName: String) -> PyResult<PyValueError> {
    return Self.cast(
      object,
      as: PyValueError.self,
      typeName: "ValueError",
      methodName: methodName
    )
  }

  // MARK: - UnicodeError

  func fillUnicodeError() {
    let type = self.unicodeError
    type.setBuiltinTypeDoc(PyUnicodeError.doc)
    type.setFlag(.baseExceptionSubclass)
    type.setFlag(.baseType)
    type.setFlag(.default)
    type.setFlag(.hasGC)

    self.insert(type: type, name: "__class__", value: PyProperty.wrap(name: "__class__", doc: nil, get: PyUnicodeError.getClass, castSelf: Self.asUnicodeError))
    self.insert(type: type, name: "__dict__", value: PyProperty.wrap(name: "__dict__", doc: nil, get: PyUnicodeError.getDict, castSelf: Self.asUnicodeError))

    self.insert(type: type, name: "__new__", value: PyStaticMethod.wrapNew(type: type, doc: nil, fn: PyUnicodeError.pyNew(type:args:kwargs:)))
    self.insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PyUnicodeError.pyInit(args:kwargs:)))
  }

  private static func asUnicodeError(_ object: PyObject, methodName: String) -> PyResult<PyUnicodeError> {
    return Self.cast(
      object,
      as: PyUnicodeError.self,
      typeName: "UnicodeError",
      methodName: methodName
    )
  }

  // MARK: - UnicodeDecodeError

  func fillUnicodeDecodeError() {
    let type = self.unicodeDecodeError
    type.setBuiltinTypeDoc(PyUnicodeDecodeError.doc)
    type.setFlag(.baseExceptionSubclass)
    type.setFlag(.baseType)
    type.setFlag(.default)
    type.setFlag(.hasGC)

    self.insert(type: type, name: "__class__", value: PyProperty.wrap(name: "__class__", doc: nil, get: PyUnicodeDecodeError.getClass, castSelf: Self.asUnicodeDecodeError))
    self.insert(type: type, name: "__dict__", value: PyProperty.wrap(name: "__dict__", doc: nil, get: PyUnicodeDecodeError.getDict, castSelf: Self.asUnicodeDecodeError))

    self.insert(type: type, name: "__new__", value: PyStaticMethod.wrapNew(type: type, doc: nil, fn: PyUnicodeDecodeError.pyNew(type:args:kwargs:)))
    self.insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PyUnicodeDecodeError.pyInit(args:kwargs:)))
  }

  private static func asUnicodeDecodeError(_ object: PyObject, methodName: String) -> PyResult<PyUnicodeDecodeError> {
    return Self.cast(
      object,
      as: PyUnicodeDecodeError.self,
      typeName: "UnicodeDecodeError",
      methodName: methodName
    )
  }

  // MARK: - UnicodeEncodeError

  func fillUnicodeEncodeError() {
    let type = self.unicodeEncodeError
    type.setBuiltinTypeDoc(PyUnicodeEncodeError.doc)
    type.setFlag(.baseExceptionSubclass)
    type.setFlag(.baseType)
    type.setFlag(.default)
    type.setFlag(.hasGC)

    self.insert(type: type, name: "__class__", value: PyProperty.wrap(name: "__class__", doc: nil, get: PyUnicodeEncodeError.getClass, castSelf: Self.asUnicodeEncodeError))
    self.insert(type: type, name: "__dict__", value: PyProperty.wrap(name: "__dict__", doc: nil, get: PyUnicodeEncodeError.getDict, castSelf: Self.asUnicodeEncodeError))

    self.insert(type: type, name: "__new__", value: PyStaticMethod.wrapNew(type: type, doc: nil, fn: PyUnicodeEncodeError.pyNew(type:args:kwargs:)))
    self.insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PyUnicodeEncodeError.pyInit(args:kwargs:)))
  }

  private static func asUnicodeEncodeError(_ object: PyObject, methodName: String) -> PyResult<PyUnicodeEncodeError> {
    return Self.cast(
      object,
      as: PyUnicodeEncodeError.self,
      typeName: "UnicodeEncodeError",
      methodName: methodName
    )
  }

  // MARK: - UnicodeTranslateError

  func fillUnicodeTranslateError() {
    let type = self.unicodeTranslateError
    type.setBuiltinTypeDoc(PyUnicodeTranslateError.doc)
    type.setFlag(.baseExceptionSubclass)
    type.setFlag(.baseType)
    type.setFlag(.default)
    type.setFlag(.hasGC)

    self.insert(type: type, name: "__class__", value: PyProperty.wrap(name: "__class__", doc: nil, get: PyUnicodeTranslateError.getClass, castSelf: Self.asUnicodeTranslateError))
    self.insert(type: type, name: "__dict__", value: PyProperty.wrap(name: "__dict__", doc: nil, get: PyUnicodeTranslateError.getDict, castSelf: Self.asUnicodeTranslateError))

    self.insert(type: type, name: "__new__", value: PyStaticMethod.wrapNew(type: type, doc: nil, fn: PyUnicodeTranslateError.pyNew(type:args:kwargs:)))
    self.insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PyUnicodeTranslateError.pyInit(args:kwargs:)))
  }

  private static func asUnicodeTranslateError(_ object: PyObject, methodName: String) -> PyResult<PyUnicodeTranslateError> {
    return Self.cast(
      object,
      as: PyUnicodeTranslateError.self,
      typeName: "UnicodeTranslateError",
      methodName: methodName
    )
  }

  // MARK: - Warning

  func fillWarning() {
    let type = self.warning
    type.setBuiltinTypeDoc(PyWarning.doc)
    type.setFlag(.baseExceptionSubclass)
    type.setFlag(.baseType)
    type.setFlag(.default)
    type.setFlag(.hasGC)

    self.insert(type: type, name: "__class__", value: PyProperty.wrap(name: "__class__", doc: nil, get: PyWarning.getClass, castSelf: Self.asWarning))
    self.insert(type: type, name: "__dict__", value: PyProperty.wrap(name: "__dict__", doc: nil, get: PyWarning.getDict, castSelf: Self.asWarning))

    self.insert(type: type, name: "__new__", value: PyStaticMethod.wrapNew(type: type, doc: nil, fn: PyWarning.pyNew(type:args:kwargs:)))
    self.insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PyWarning.pyInit(args:kwargs:)))
  }

  private static func asWarning(_ object: PyObject, methodName: String) -> PyResult<PyWarning> {
    return Self.cast(
      object,
      as: PyWarning.self,
      typeName: "Warning",
      methodName: methodName
    )
  }

  // MARK: - DeprecationWarning

  func fillDeprecationWarning() {
    let type = self.deprecationWarning
    type.setBuiltinTypeDoc(PyDeprecationWarning.doc)
    type.setFlag(.baseExceptionSubclass)
    type.setFlag(.baseType)
    type.setFlag(.default)
    type.setFlag(.hasGC)

    self.insert(type: type, name: "__class__", value: PyProperty.wrap(name: "__class__", doc: nil, get: PyDeprecationWarning.getClass, castSelf: Self.asDeprecationWarning))
    self.insert(type: type, name: "__dict__", value: PyProperty.wrap(name: "__dict__", doc: nil, get: PyDeprecationWarning.getDict, castSelf: Self.asDeprecationWarning))

    self.insert(type: type, name: "__new__", value: PyStaticMethod.wrapNew(type: type, doc: nil, fn: PyDeprecationWarning.pyNew(type:args:kwargs:)))
    self.insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PyDeprecationWarning.pyInit(args:kwargs:)))
  }

  private static func asDeprecationWarning(_ object: PyObject, methodName: String) -> PyResult<PyDeprecationWarning> {
    return Self.cast(
      object,
      as: PyDeprecationWarning.self,
      typeName: "DeprecationWarning",
      methodName: methodName
    )
  }

  // MARK: - PendingDeprecationWarning

  func fillPendingDeprecationWarning() {
    let type = self.pendingDeprecationWarning
    type.setBuiltinTypeDoc(PyPendingDeprecationWarning.doc)
    type.setFlag(.baseExceptionSubclass)
    type.setFlag(.baseType)
    type.setFlag(.default)
    type.setFlag(.hasGC)

    self.insert(type: type, name: "__class__", value: PyProperty.wrap(name: "__class__", doc: nil, get: PyPendingDeprecationWarning.getClass, castSelf: Self.asPendingDeprecationWarning))
    self.insert(type: type, name: "__dict__", value: PyProperty.wrap(name: "__dict__", doc: nil, get: PyPendingDeprecationWarning.getDict, castSelf: Self.asPendingDeprecationWarning))

    self.insert(type: type, name: "__new__", value: PyStaticMethod.wrapNew(type: type, doc: nil, fn: PyPendingDeprecationWarning.pyNew(type:args:kwargs:)))
    self.insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PyPendingDeprecationWarning.pyInit(args:kwargs:)))
  }

  private static func asPendingDeprecationWarning(_ object: PyObject, methodName: String) -> PyResult<PyPendingDeprecationWarning> {
    return Self.cast(
      object,
      as: PyPendingDeprecationWarning.self,
      typeName: "PendingDeprecationWarning",
      methodName: methodName
    )
  }

  // MARK: - RuntimeWarning

  func fillRuntimeWarning() {
    let type = self.runtimeWarning
    type.setBuiltinTypeDoc(PyRuntimeWarning.doc)
    type.setFlag(.baseExceptionSubclass)
    type.setFlag(.baseType)
    type.setFlag(.default)
    type.setFlag(.hasGC)

    self.insert(type: type, name: "__class__", value: PyProperty.wrap(name: "__class__", doc: nil, get: PyRuntimeWarning.getClass, castSelf: Self.asRuntimeWarning))
    self.insert(type: type, name: "__dict__", value: PyProperty.wrap(name: "__dict__", doc: nil, get: PyRuntimeWarning.getDict, castSelf: Self.asRuntimeWarning))

    self.insert(type: type, name: "__new__", value: PyStaticMethod.wrapNew(type: type, doc: nil, fn: PyRuntimeWarning.pyNew(type:args:kwargs:)))
    self.insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PyRuntimeWarning.pyInit(args:kwargs:)))
  }

  private static func asRuntimeWarning(_ object: PyObject, methodName: String) -> PyResult<PyRuntimeWarning> {
    return Self.cast(
      object,
      as: PyRuntimeWarning.self,
      typeName: "RuntimeWarning",
      methodName: methodName
    )
  }

  // MARK: - SyntaxWarning

  func fillSyntaxWarning() {
    let type = self.syntaxWarning
    type.setBuiltinTypeDoc(PySyntaxWarning.doc)
    type.setFlag(.baseExceptionSubclass)
    type.setFlag(.baseType)
    type.setFlag(.default)
    type.setFlag(.hasGC)

    self.insert(type: type, name: "__class__", value: PyProperty.wrap(name: "__class__", doc: nil, get: PySyntaxWarning.getClass, castSelf: Self.asSyntaxWarning))
    self.insert(type: type, name: "__dict__", value: PyProperty.wrap(name: "__dict__", doc: nil, get: PySyntaxWarning.getDict, castSelf: Self.asSyntaxWarning))

    self.insert(type: type, name: "__new__", value: PyStaticMethod.wrapNew(type: type, doc: nil, fn: PySyntaxWarning.pyNew(type:args:kwargs:)))
    self.insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PySyntaxWarning.pyInit(args:kwargs:)))
  }

  private static func asSyntaxWarning(_ object: PyObject, methodName: String) -> PyResult<PySyntaxWarning> {
    return Self.cast(
      object,
      as: PySyntaxWarning.self,
      typeName: "SyntaxWarning",
      methodName: methodName
    )
  }

  // MARK: - UserWarning

  func fillUserWarning() {
    let type = self.userWarning
    type.setBuiltinTypeDoc(PyUserWarning.doc)
    type.setFlag(.baseExceptionSubclass)
    type.setFlag(.baseType)
    type.setFlag(.default)
    type.setFlag(.hasGC)

    self.insert(type: type, name: "__class__", value: PyProperty.wrap(name: "__class__", doc: nil, get: PyUserWarning.getClass, castSelf: Self.asUserWarning))
    self.insert(type: type, name: "__dict__", value: PyProperty.wrap(name: "__dict__", doc: nil, get: PyUserWarning.getDict, castSelf: Self.asUserWarning))

    self.insert(type: type, name: "__new__", value: PyStaticMethod.wrapNew(type: type, doc: nil, fn: PyUserWarning.pyNew(type:args:kwargs:)))
    self.insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PyUserWarning.pyInit(args:kwargs:)))
  }

  private static func asUserWarning(_ object: PyObject, methodName: String) -> PyResult<PyUserWarning> {
    return Self.cast(
      object,
      as: PyUserWarning.self,
      typeName: "UserWarning",
      methodName: methodName
    )
  }

  // MARK: - FutureWarning

  func fillFutureWarning() {
    let type = self.futureWarning
    type.setBuiltinTypeDoc(PyFutureWarning.doc)
    type.setFlag(.baseExceptionSubclass)
    type.setFlag(.baseType)
    type.setFlag(.default)
    type.setFlag(.hasGC)

    self.insert(type: type, name: "__class__", value: PyProperty.wrap(name: "__class__", doc: nil, get: PyFutureWarning.getClass, castSelf: Self.asFutureWarning))
    self.insert(type: type, name: "__dict__", value: PyProperty.wrap(name: "__dict__", doc: nil, get: PyFutureWarning.getDict, castSelf: Self.asFutureWarning))

    self.insert(type: type, name: "__new__", value: PyStaticMethod.wrapNew(type: type, doc: nil, fn: PyFutureWarning.pyNew(type:args:kwargs:)))
    self.insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PyFutureWarning.pyInit(args:kwargs:)))
  }

  private static func asFutureWarning(_ object: PyObject, methodName: String) -> PyResult<PyFutureWarning> {
    return Self.cast(
      object,
      as: PyFutureWarning.self,
      typeName: "FutureWarning",
      methodName: methodName
    )
  }

  // MARK: - ImportWarning

  func fillImportWarning() {
    let type = self.importWarning
    type.setBuiltinTypeDoc(PyImportWarning.doc)
    type.setFlag(.baseExceptionSubclass)
    type.setFlag(.baseType)
    type.setFlag(.default)
    type.setFlag(.hasGC)

    self.insert(type: type, name: "__class__", value: PyProperty.wrap(name: "__class__", doc: nil, get: PyImportWarning.getClass, castSelf: Self.asImportWarning))
    self.insert(type: type, name: "__dict__", value: PyProperty.wrap(name: "__dict__", doc: nil, get: PyImportWarning.getDict, castSelf: Self.asImportWarning))

    self.insert(type: type, name: "__new__", value: PyStaticMethod.wrapNew(type: type, doc: nil, fn: PyImportWarning.pyNew(type:args:kwargs:)))
    self.insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PyImportWarning.pyInit(args:kwargs:)))
  }

  private static func asImportWarning(_ object: PyObject, methodName: String) -> PyResult<PyImportWarning> {
    return Self.cast(
      object,
      as: PyImportWarning.self,
      typeName: "ImportWarning",
      methodName: methodName
    )
  }

  // MARK: - UnicodeWarning

  func fillUnicodeWarning() {
    let type = self.unicodeWarning
    type.setBuiltinTypeDoc(PyUnicodeWarning.doc)
    type.setFlag(.baseExceptionSubclass)
    type.setFlag(.baseType)
    type.setFlag(.default)
    type.setFlag(.hasGC)

    self.insert(type: type, name: "__class__", value: PyProperty.wrap(name: "__class__", doc: nil, get: PyUnicodeWarning.getClass, castSelf: Self.asUnicodeWarning))
    self.insert(type: type, name: "__dict__", value: PyProperty.wrap(name: "__dict__", doc: nil, get: PyUnicodeWarning.getDict, castSelf: Self.asUnicodeWarning))

    self.insert(type: type, name: "__new__", value: PyStaticMethod.wrapNew(type: type, doc: nil, fn: PyUnicodeWarning.pyNew(type:args:kwargs:)))
    self.insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PyUnicodeWarning.pyInit(args:kwargs:)))
  }

  private static func asUnicodeWarning(_ object: PyObject, methodName: String) -> PyResult<PyUnicodeWarning> {
    return Self.cast(
      object,
      as: PyUnicodeWarning.self,
      typeName: "UnicodeWarning",
      methodName: methodName
    )
  }

  // MARK: - BytesWarning

  func fillBytesWarning() {
    let type = self.bytesWarning
    type.setBuiltinTypeDoc(PyBytesWarning.doc)
    type.setFlag(.baseExceptionSubclass)
    type.setFlag(.baseType)
    type.setFlag(.default)
    type.setFlag(.hasGC)

    self.insert(type: type, name: "__class__", value: PyProperty.wrap(name: "__class__", doc: nil, get: PyBytesWarning.getClass, castSelf: Self.asBytesWarning))
    self.insert(type: type, name: "__dict__", value: PyProperty.wrap(name: "__dict__", doc: nil, get: PyBytesWarning.getDict, castSelf: Self.asBytesWarning))

    self.insert(type: type, name: "__new__", value: PyStaticMethod.wrapNew(type: type, doc: nil, fn: PyBytesWarning.pyNew(type:args:kwargs:)))
    self.insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PyBytesWarning.pyInit(args:kwargs:)))
  }

  private static func asBytesWarning(_ object: PyObject, methodName: String) -> PyResult<PyBytesWarning> {
    return Self.cast(
      object,
      as: PyBytesWarning.self,
      typeName: "BytesWarning",
      methodName: methodName
    )
  }

  // MARK: - ResourceWarning

  func fillResourceWarning() {
    let type = self.resourceWarning
    type.setBuiltinTypeDoc(PyResourceWarning.doc)
    type.setFlag(.baseExceptionSubclass)
    type.setFlag(.baseType)
    type.setFlag(.default)
    type.setFlag(.hasGC)

    self.insert(type: type, name: "__class__", value: PyProperty.wrap(name: "__class__", doc: nil, get: PyResourceWarning.getClass, castSelf: Self.asResourceWarning))
    self.insert(type: type, name: "__dict__", value: PyProperty.wrap(name: "__dict__", doc: nil, get: PyResourceWarning.getDict, castSelf: Self.asResourceWarning))

    self.insert(type: type, name: "__new__", value: PyStaticMethod.wrapNew(type: type, doc: nil, fn: PyResourceWarning.pyNew(type:args:kwargs:)))
    self.insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: nil, fn: PyResourceWarning.pyInit(args:kwargs:)))
  }

  private static func asResourceWarning(_ object: PyObject, methodName: String) -> PyResult<PyResourceWarning> {
    return Self.cast(
      object,
      as: PyResourceWarning.self,
      typeName: "ResourceWarning",
      methodName: methodName
    )
  }

}
