// ====================================================================================
// Automatically generated from: ./Sources/Objects/Generated/Py+ErrorTypeDefinitions.py
// Use 'make gen' in repository root to regenerate.
// DO NOT EDIT!
// ====================================================================================

import VioletCore

// swiftlint:disable function_parameter_count
// swiftlint:disable line_length
// swiftlint:disable function_body_length
// swiftlint:disable vertical_whitespace_closing_braces
// swiftlint:disable file_length

// In CPython:
// Objects -> exceptions.c
// Lib->test->exception_hierarchy.txt <-- this is amazing
// https://docs.python.org/3.7/library/exceptions.html
// https://docs.python.org/3.7/c-api/exceptions.html

// Just like 'Py.Types' this will be a 2 phase init.
// See 'Py.Types' for reasoning.
extension Py {

  public final class ErrorTypes {

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
    internal init(_ py: Py, typeType: PyType, objectType: PyType) {
      let memory = py.memory

      self.baseException = memory.newType(
        type: typeType,
        name: "BaseException",
        qualname: "BaseException",
        flags: [.hasGCFlag, .instancesHave__dict__Flag, .isBaseExceptionSubclassFlag, .isBaseTypeFlag, .isDefaultFlag],
        base: objectType,
        bases: [objectType],
        mroWithoutSelf: [objectType],
        subclasses: [],
        instanceSizeWithoutTail: PyBaseException.layout.size,
        staticMethods: Py.ErrorTypes.baseExceptionStaticMethods,
        debugFn: PyBaseException.createDebugInfo(ptr:),
        deinitialize: PyBaseException.deinitialize(_:ptr:)
      )

      self.systemExit = memory.newType(
        type: typeType,
        name: "SystemExit",
        qualname: "SystemExit",
        flags: [.hasGCFlag, .instancesHave__dict__Flag, .isBaseExceptionSubclassFlag, .isBaseTypeFlag, .isDefaultFlag],
        base: self.baseException,
        bases: [self.baseException],
        mroWithoutSelf: [self.baseException, objectType],
        subclasses: [],
        instanceSizeWithoutTail: PySystemExit.layout.size,
        staticMethods: Py.ErrorTypes.systemExitStaticMethods,
        debugFn: PySystemExit.createDebugInfo(ptr:),
        deinitialize: PySystemExit.deinitialize(_:ptr:)
      )

      self.keyboardInterrupt = memory.newType(
        type: typeType,
        name: "KeyboardInterrupt",
        qualname: "KeyboardInterrupt",
        flags: [.hasGCFlag, .instancesHave__dict__Flag, .isBaseExceptionSubclassFlag, .isBaseTypeFlag, .isDefaultFlag],
        base: self.baseException,
        bases: [self.baseException],
        mroWithoutSelf: [self.baseException, objectType],
        subclasses: [],
        instanceSizeWithoutTail: PyKeyboardInterrupt.layout.size,
        staticMethods: Py.ErrorTypes.keyboardInterruptStaticMethods,
        debugFn: PyKeyboardInterrupt.createDebugInfo(ptr:),
        deinitialize: PyKeyboardInterrupt.deinitialize(_:ptr:)
      )

      self.generatorExit = memory.newType(
        type: typeType,
        name: "GeneratorExit",
        qualname: "GeneratorExit",
        flags: [.hasGCFlag, .instancesHave__dict__Flag, .isBaseExceptionSubclassFlag, .isBaseTypeFlag, .isDefaultFlag],
        base: self.baseException,
        bases: [self.baseException],
        mroWithoutSelf: [self.baseException, objectType],
        subclasses: [],
        instanceSizeWithoutTail: PyGeneratorExit.layout.size,
        staticMethods: Py.ErrorTypes.generatorExitStaticMethods,
        debugFn: PyGeneratorExit.createDebugInfo(ptr:),
        deinitialize: PyGeneratorExit.deinitialize(_:ptr:)
      )

      self.exception = memory.newType(
        type: typeType,
        name: "Exception",
        qualname: "Exception",
        flags: [.hasGCFlag, .instancesHave__dict__Flag, .isBaseExceptionSubclassFlag, .isBaseTypeFlag, .isDefaultFlag],
        base: self.baseException,
        bases: [self.baseException],
        mroWithoutSelf: [self.baseException, objectType],
        subclasses: [],
        instanceSizeWithoutTail: PyException.layout.size,
        staticMethods: Py.ErrorTypes.exceptionStaticMethods,
        debugFn: PyException.createDebugInfo(ptr:),
        deinitialize: PyException.deinitialize(_:ptr:)
      )

      self.stopIteration = memory.newType(
        type: typeType,
        name: "StopIteration",
        qualname: "StopIteration",
        flags: [.hasGCFlag, .instancesHave__dict__Flag, .isBaseExceptionSubclassFlag, .isBaseTypeFlag, .isDefaultFlag],
        base: self.exception,
        bases: [self.exception],
        mroWithoutSelf: [self.exception, self.baseException, objectType],
        subclasses: [],
        instanceSizeWithoutTail: PyStopIteration.layout.size,
        staticMethods: Py.ErrorTypes.stopIterationStaticMethods,
        debugFn: PyStopIteration.createDebugInfo(ptr:),
        deinitialize: PyStopIteration.deinitialize(_:ptr:)
      )

      self.stopAsyncIteration = memory.newType(
        type: typeType,
        name: "StopAsyncIteration",
        qualname: "StopAsyncIteration",
        flags: [.hasGCFlag, .instancesHave__dict__Flag, .isBaseExceptionSubclassFlag, .isBaseTypeFlag, .isDefaultFlag],
        base: self.exception,
        bases: [self.exception],
        mroWithoutSelf: [self.exception, self.baseException, objectType],
        subclasses: [],
        instanceSizeWithoutTail: PyStopAsyncIteration.layout.size,
        staticMethods: Py.ErrorTypes.stopAsyncIterationStaticMethods,
        debugFn: PyStopAsyncIteration.createDebugInfo(ptr:),
        deinitialize: PyStopAsyncIteration.deinitialize(_:ptr:)
      )

      self.arithmeticError = memory.newType(
        type: typeType,
        name: "ArithmeticError",
        qualname: "ArithmeticError",
        flags: [.hasGCFlag, .instancesHave__dict__Flag, .isBaseExceptionSubclassFlag, .isBaseTypeFlag, .isDefaultFlag],
        base: self.exception,
        bases: [self.exception],
        mroWithoutSelf: [self.exception, self.baseException, objectType],
        subclasses: [],
        instanceSizeWithoutTail: PyArithmeticError.layout.size,
        staticMethods: Py.ErrorTypes.arithmeticErrorStaticMethods,
        debugFn: PyArithmeticError.createDebugInfo(ptr:),
        deinitialize: PyArithmeticError.deinitialize(_:ptr:)
      )

      self.floatingPointError = memory.newType(
        type: typeType,
        name: "FloatingPointError",
        qualname: "FloatingPointError",
        flags: [.hasGCFlag, .instancesHave__dict__Flag, .isBaseExceptionSubclassFlag, .isBaseTypeFlag, .isDefaultFlag],
        base: self.arithmeticError,
        bases: [self.arithmeticError],
        mroWithoutSelf: [self.arithmeticError, self.exception, self.baseException, objectType],
        subclasses: [],
        instanceSizeWithoutTail: PyFloatingPointError.layout.size,
        staticMethods: Py.ErrorTypes.floatingPointErrorStaticMethods,
        debugFn: PyFloatingPointError.createDebugInfo(ptr:),
        deinitialize: PyFloatingPointError.deinitialize(_:ptr:)
      )

      self.overflowError = memory.newType(
        type: typeType,
        name: "OverflowError",
        qualname: "OverflowError",
        flags: [.hasGCFlag, .instancesHave__dict__Flag, .isBaseExceptionSubclassFlag, .isBaseTypeFlag, .isDefaultFlag],
        base: self.arithmeticError,
        bases: [self.arithmeticError],
        mroWithoutSelf: [self.arithmeticError, self.exception, self.baseException, objectType],
        subclasses: [],
        instanceSizeWithoutTail: PyOverflowError.layout.size,
        staticMethods: Py.ErrorTypes.overflowErrorStaticMethods,
        debugFn: PyOverflowError.createDebugInfo(ptr:),
        deinitialize: PyOverflowError.deinitialize(_:ptr:)
      )

      self.zeroDivisionError = memory.newType(
        type: typeType,
        name: "ZeroDivisionError",
        qualname: "ZeroDivisionError",
        flags: [.hasGCFlag, .instancesHave__dict__Flag, .isBaseExceptionSubclassFlag, .isBaseTypeFlag, .isDefaultFlag],
        base: self.arithmeticError,
        bases: [self.arithmeticError],
        mroWithoutSelf: [self.arithmeticError, self.exception, self.baseException, objectType],
        subclasses: [],
        instanceSizeWithoutTail: PyZeroDivisionError.layout.size,
        staticMethods: Py.ErrorTypes.zeroDivisionErrorStaticMethods,
        debugFn: PyZeroDivisionError.createDebugInfo(ptr:),
        deinitialize: PyZeroDivisionError.deinitialize(_:ptr:)
      )

      self.assertionError = memory.newType(
        type: typeType,
        name: "AssertionError",
        qualname: "AssertionError",
        flags: [.hasGCFlag, .instancesHave__dict__Flag, .isBaseExceptionSubclassFlag, .isBaseTypeFlag, .isDefaultFlag],
        base: self.exception,
        bases: [self.exception],
        mroWithoutSelf: [self.exception, self.baseException, objectType],
        subclasses: [],
        instanceSizeWithoutTail: PyAssertionError.layout.size,
        staticMethods: Py.ErrorTypes.assertionErrorStaticMethods,
        debugFn: PyAssertionError.createDebugInfo(ptr:),
        deinitialize: PyAssertionError.deinitialize(_:ptr:)
      )

      self.attributeError = memory.newType(
        type: typeType,
        name: "AttributeError",
        qualname: "AttributeError",
        flags: [.hasGCFlag, .instancesHave__dict__Flag, .isBaseExceptionSubclassFlag, .isBaseTypeFlag, .isDefaultFlag],
        base: self.exception,
        bases: [self.exception],
        mroWithoutSelf: [self.exception, self.baseException, objectType],
        subclasses: [],
        instanceSizeWithoutTail: PyAttributeError.layout.size,
        staticMethods: Py.ErrorTypes.attributeErrorStaticMethods,
        debugFn: PyAttributeError.createDebugInfo(ptr:),
        deinitialize: PyAttributeError.deinitialize(_:ptr:)
      )

      self.bufferError = memory.newType(
        type: typeType,
        name: "BufferError",
        qualname: "BufferError",
        flags: [.hasGCFlag, .instancesHave__dict__Flag, .isBaseExceptionSubclassFlag, .isBaseTypeFlag, .isDefaultFlag],
        base: self.exception,
        bases: [self.exception],
        mroWithoutSelf: [self.exception, self.baseException, objectType],
        subclasses: [],
        instanceSizeWithoutTail: PyBufferError.layout.size,
        staticMethods: Py.ErrorTypes.bufferErrorStaticMethods,
        debugFn: PyBufferError.createDebugInfo(ptr:),
        deinitialize: PyBufferError.deinitialize(_:ptr:)
      )

      self.eofError = memory.newType(
        type: typeType,
        name: "EOFError",
        qualname: "EOFError",
        flags: [.hasGCFlag, .instancesHave__dict__Flag, .isBaseExceptionSubclassFlag, .isBaseTypeFlag, .isDefaultFlag],
        base: self.exception,
        bases: [self.exception],
        mroWithoutSelf: [self.exception, self.baseException, objectType],
        subclasses: [],
        instanceSizeWithoutTail: PyEOFError.layout.size,
        staticMethods: Py.ErrorTypes.eOFErrorStaticMethods,
        debugFn: PyEOFError.createDebugInfo(ptr:),
        deinitialize: PyEOFError.deinitialize(_:ptr:)
      )

      self.importError = memory.newType(
        type: typeType,
        name: "ImportError",
        qualname: "ImportError",
        flags: [.hasGCFlag, .instancesHave__dict__Flag, .isBaseExceptionSubclassFlag, .isBaseTypeFlag, .isDefaultFlag],
        base: self.exception,
        bases: [self.exception],
        mroWithoutSelf: [self.exception, self.baseException, objectType],
        subclasses: [],
        instanceSizeWithoutTail: PyImportError.layout.size,
        staticMethods: Py.ErrorTypes.importErrorStaticMethods,
        debugFn: PyImportError.createDebugInfo(ptr:),
        deinitialize: PyImportError.deinitialize(_:ptr:)
      )

      self.moduleNotFoundError = memory.newType(
        type: typeType,
        name: "ModuleNotFoundError",
        qualname: "ModuleNotFoundError",
        flags: [.hasGCFlag, .instancesHave__dict__Flag, .isBaseExceptionSubclassFlag, .isBaseTypeFlag, .isDefaultFlag],
        base: self.importError,
        bases: [self.importError],
        mroWithoutSelf: [self.importError, self.exception, self.baseException, objectType],
        subclasses: [],
        instanceSizeWithoutTail: PyModuleNotFoundError.layout.size,
        staticMethods: Py.ErrorTypes.moduleNotFoundErrorStaticMethods,
        debugFn: PyModuleNotFoundError.createDebugInfo(ptr:),
        deinitialize: PyModuleNotFoundError.deinitialize(_:ptr:)
      )

      self.lookupError = memory.newType(
        type: typeType,
        name: "LookupError",
        qualname: "LookupError",
        flags: [.hasGCFlag, .instancesHave__dict__Flag, .isBaseExceptionSubclassFlag, .isBaseTypeFlag, .isDefaultFlag],
        base: self.exception,
        bases: [self.exception],
        mroWithoutSelf: [self.exception, self.baseException, objectType],
        subclasses: [],
        instanceSizeWithoutTail: PyLookupError.layout.size,
        staticMethods: Py.ErrorTypes.lookupErrorStaticMethods,
        debugFn: PyLookupError.createDebugInfo(ptr:),
        deinitialize: PyLookupError.deinitialize(_:ptr:)
      )

      self.indexError = memory.newType(
        type: typeType,
        name: "IndexError",
        qualname: "IndexError",
        flags: [.hasGCFlag, .instancesHave__dict__Flag, .isBaseExceptionSubclassFlag, .isBaseTypeFlag, .isDefaultFlag],
        base: self.lookupError,
        bases: [self.lookupError],
        mroWithoutSelf: [self.lookupError, self.exception, self.baseException, objectType],
        subclasses: [],
        instanceSizeWithoutTail: PyIndexError.layout.size,
        staticMethods: Py.ErrorTypes.indexErrorStaticMethods,
        debugFn: PyIndexError.createDebugInfo(ptr:),
        deinitialize: PyIndexError.deinitialize(_:ptr:)
      )

      self.keyError = memory.newType(
        type: typeType,
        name: "KeyError",
        qualname: "KeyError",
        flags: [.hasGCFlag, .instancesHave__dict__Flag, .isBaseExceptionSubclassFlag, .isBaseTypeFlag, .isDefaultFlag],
        base: self.lookupError,
        bases: [self.lookupError],
        mroWithoutSelf: [self.lookupError, self.exception, self.baseException, objectType],
        subclasses: [],
        instanceSizeWithoutTail: PyKeyError.layout.size,
        staticMethods: Py.ErrorTypes.keyErrorStaticMethods,
        debugFn: PyKeyError.createDebugInfo(ptr:),
        deinitialize: PyKeyError.deinitialize(_:ptr:)
      )

      self.memoryError = memory.newType(
        type: typeType,
        name: "MemoryError",
        qualname: "MemoryError",
        flags: [.hasGCFlag, .instancesHave__dict__Flag, .isBaseExceptionSubclassFlag, .isBaseTypeFlag, .isDefaultFlag],
        base: self.exception,
        bases: [self.exception],
        mroWithoutSelf: [self.exception, self.baseException, objectType],
        subclasses: [],
        instanceSizeWithoutTail: PyMemoryError.layout.size,
        staticMethods: Py.ErrorTypes.memoryErrorStaticMethods,
        debugFn: PyMemoryError.createDebugInfo(ptr:),
        deinitialize: PyMemoryError.deinitialize(_:ptr:)
      )

      self.nameError = memory.newType(
        type: typeType,
        name: "NameError",
        qualname: "NameError",
        flags: [.hasGCFlag, .instancesHave__dict__Flag, .isBaseExceptionSubclassFlag, .isBaseTypeFlag, .isDefaultFlag],
        base: self.exception,
        bases: [self.exception],
        mroWithoutSelf: [self.exception, self.baseException, objectType],
        subclasses: [],
        instanceSizeWithoutTail: PyNameError.layout.size,
        staticMethods: Py.ErrorTypes.nameErrorStaticMethods,
        debugFn: PyNameError.createDebugInfo(ptr:),
        deinitialize: PyNameError.deinitialize(_:ptr:)
      )

      self.unboundLocalError = memory.newType(
        type: typeType,
        name: "UnboundLocalError",
        qualname: "UnboundLocalError",
        flags: [.hasGCFlag, .instancesHave__dict__Flag, .isBaseExceptionSubclassFlag, .isBaseTypeFlag, .isDefaultFlag],
        base: self.nameError,
        bases: [self.nameError],
        mroWithoutSelf: [self.nameError, self.exception, self.baseException, objectType],
        subclasses: [],
        instanceSizeWithoutTail: PyUnboundLocalError.layout.size,
        staticMethods: Py.ErrorTypes.unboundLocalErrorStaticMethods,
        debugFn: PyUnboundLocalError.createDebugInfo(ptr:),
        deinitialize: PyUnboundLocalError.deinitialize(_:ptr:)
      )

      self.osError = memory.newType(
        type: typeType,
        name: "OSError",
        qualname: "OSError",
        flags: [.hasGCFlag, .instancesHave__dict__Flag, .isBaseExceptionSubclassFlag, .isBaseTypeFlag, .isDefaultFlag],
        base: self.exception,
        bases: [self.exception],
        mroWithoutSelf: [self.exception, self.baseException, objectType],
        subclasses: [],
        instanceSizeWithoutTail: PyOSError.layout.size,
        staticMethods: Py.ErrorTypes.oSErrorStaticMethods,
        debugFn: PyOSError.createDebugInfo(ptr:),
        deinitialize: PyOSError.deinitialize(_:ptr:)
      )

      self.blockingIOError = memory.newType(
        type: typeType,
        name: "BlockingIOError",
        qualname: "BlockingIOError",
        flags: [.hasGCFlag, .instancesHave__dict__Flag, .isBaseExceptionSubclassFlag, .isBaseTypeFlag, .isDefaultFlag],
        base: self.osError,
        bases: [self.osError],
        mroWithoutSelf: [self.osError, self.exception, self.baseException, objectType],
        subclasses: [],
        instanceSizeWithoutTail: PyBlockingIOError.layout.size,
        staticMethods: Py.ErrorTypes.blockingIOErrorStaticMethods,
        debugFn: PyBlockingIOError.createDebugInfo(ptr:),
        deinitialize: PyBlockingIOError.deinitialize(_:ptr:)
      )

      self.childProcessError = memory.newType(
        type: typeType,
        name: "ChildProcessError",
        qualname: "ChildProcessError",
        flags: [.hasGCFlag, .instancesHave__dict__Flag, .isBaseExceptionSubclassFlag, .isBaseTypeFlag, .isDefaultFlag],
        base: self.osError,
        bases: [self.osError],
        mroWithoutSelf: [self.osError, self.exception, self.baseException, objectType],
        subclasses: [],
        instanceSizeWithoutTail: PyChildProcessError.layout.size,
        staticMethods: Py.ErrorTypes.childProcessErrorStaticMethods,
        debugFn: PyChildProcessError.createDebugInfo(ptr:),
        deinitialize: PyChildProcessError.deinitialize(_:ptr:)
      )

      self.connectionError = memory.newType(
        type: typeType,
        name: "ConnectionError",
        qualname: "ConnectionError",
        flags: [.hasGCFlag, .instancesHave__dict__Flag, .isBaseExceptionSubclassFlag, .isBaseTypeFlag, .isDefaultFlag],
        base: self.osError,
        bases: [self.osError],
        mroWithoutSelf: [self.osError, self.exception, self.baseException, objectType],
        subclasses: [],
        instanceSizeWithoutTail: PyConnectionError.layout.size,
        staticMethods: Py.ErrorTypes.connectionErrorStaticMethods,
        debugFn: PyConnectionError.createDebugInfo(ptr:),
        deinitialize: PyConnectionError.deinitialize(_:ptr:)
      )

      self.brokenPipeError = memory.newType(
        type: typeType,
        name: "BrokenPipeError",
        qualname: "BrokenPipeError",
        flags: [.hasGCFlag, .instancesHave__dict__Flag, .isBaseExceptionSubclassFlag, .isBaseTypeFlag, .isDefaultFlag],
        base: self.connectionError,
        bases: [self.connectionError],
        mroWithoutSelf: [self.connectionError, self.osError, self.exception, self.baseException, objectType],
        subclasses: [],
        instanceSizeWithoutTail: PyBrokenPipeError.layout.size,
        staticMethods: Py.ErrorTypes.brokenPipeErrorStaticMethods,
        debugFn: PyBrokenPipeError.createDebugInfo(ptr:),
        deinitialize: PyBrokenPipeError.deinitialize(_:ptr:)
      )

      self.connectionAbortedError = memory.newType(
        type: typeType,
        name: "ConnectionAbortedError",
        qualname: "ConnectionAbortedError",
        flags: [.hasGCFlag, .instancesHave__dict__Flag, .isBaseExceptionSubclassFlag, .isBaseTypeFlag, .isDefaultFlag],
        base: self.connectionError,
        bases: [self.connectionError],
        mroWithoutSelf: [self.connectionError, self.osError, self.exception, self.baseException, objectType],
        subclasses: [],
        instanceSizeWithoutTail: PyConnectionAbortedError.layout.size,
        staticMethods: Py.ErrorTypes.connectionAbortedErrorStaticMethods,
        debugFn: PyConnectionAbortedError.createDebugInfo(ptr:),
        deinitialize: PyConnectionAbortedError.deinitialize(_:ptr:)
      )

      self.connectionRefusedError = memory.newType(
        type: typeType,
        name: "ConnectionRefusedError",
        qualname: "ConnectionRefusedError",
        flags: [.hasGCFlag, .instancesHave__dict__Flag, .isBaseExceptionSubclassFlag, .isBaseTypeFlag, .isDefaultFlag],
        base: self.connectionError,
        bases: [self.connectionError],
        mroWithoutSelf: [self.connectionError, self.osError, self.exception, self.baseException, objectType],
        subclasses: [],
        instanceSizeWithoutTail: PyConnectionRefusedError.layout.size,
        staticMethods: Py.ErrorTypes.connectionRefusedErrorStaticMethods,
        debugFn: PyConnectionRefusedError.createDebugInfo(ptr:),
        deinitialize: PyConnectionRefusedError.deinitialize(_:ptr:)
      )

      self.connectionResetError = memory.newType(
        type: typeType,
        name: "ConnectionResetError",
        qualname: "ConnectionResetError",
        flags: [.hasGCFlag, .instancesHave__dict__Flag, .isBaseExceptionSubclassFlag, .isBaseTypeFlag, .isDefaultFlag],
        base: self.connectionError,
        bases: [self.connectionError],
        mroWithoutSelf: [self.connectionError, self.osError, self.exception, self.baseException, objectType],
        subclasses: [],
        instanceSizeWithoutTail: PyConnectionResetError.layout.size,
        staticMethods: Py.ErrorTypes.connectionResetErrorStaticMethods,
        debugFn: PyConnectionResetError.createDebugInfo(ptr:),
        deinitialize: PyConnectionResetError.deinitialize(_:ptr:)
      )

      self.fileExistsError = memory.newType(
        type: typeType,
        name: "FileExistsError",
        qualname: "FileExistsError",
        flags: [.hasGCFlag, .instancesHave__dict__Flag, .isBaseExceptionSubclassFlag, .isBaseTypeFlag, .isDefaultFlag],
        base: self.osError,
        bases: [self.osError],
        mroWithoutSelf: [self.osError, self.exception, self.baseException, objectType],
        subclasses: [],
        instanceSizeWithoutTail: PyFileExistsError.layout.size,
        staticMethods: Py.ErrorTypes.fileExistsErrorStaticMethods,
        debugFn: PyFileExistsError.createDebugInfo(ptr:),
        deinitialize: PyFileExistsError.deinitialize(_:ptr:)
      )

      self.fileNotFoundError = memory.newType(
        type: typeType,
        name: "FileNotFoundError",
        qualname: "FileNotFoundError",
        flags: [.hasGCFlag, .instancesHave__dict__Flag, .isBaseExceptionSubclassFlag, .isBaseTypeFlag, .isDefaultFlag],
        base: self.osError,
        bases: [self.osError],
        mroWithoutSelf: [self.osError, self.exception, self.baseException, objectType],
        subclasses: [],
        instanceSizeWithoutTail: PyFileNotFoundError.layout.size,
        staticMethods: Py.ErrorTypes.fileNotFoundErrorStaticMethods,
        debugFn: PyFileNotFoundError.createDebugInfo(ptr:),
        deinitialize: PyFileNotFoundError.deinitialize(_:ptr:)
      )

      self.interruptedError = memory.newType(
        type: typeType,
        name: "InterruptedError",
        qualname: "InterruptedError",
        flags: [.hasGCFlag, .instancesHave__dict__Flag, .isBaseExceptionSubclassFlag, .isBaseTypeFlag, .isDefaultFlag],
        base: self.osError,
        bases: [self.osError],
        mroWithoutSelf: [self.osError, self.exception, self.baseException, objectType],
        subclasses: [],
        instanceSizeWithoutTail: PyInterruptedError.layout.size,
        staticMethods: Py.ErrorTypes.interruptedErrorStaticMethods,
        debugFn: PyInterruptedError.createDebugInfo(ptr:),
        deinitialize: PyInterruptedError.deinitialize(_:ptr:)
      )

      self.isADirectoryError = memory.newType(
        type: typeType,
        name: "IsADirectoryError",
        qualname: "IsADirectoryError",
        flags: [.hasGCFlag, .instancesHave__dict__Flag, .isBaseExceptionSubclassFlag, .isBaseTypeFlag, .isDefaultFlag],
        base: self.osError,
        bases: [self.osError],
        mroWithoutSelf: [self.osError, self.exception, self.baseException, objectType],
        subclasses: [],
        instanceSizeWithoutTail: PyIsADirectoryError.layout.size,
        staticMethods: Py.ErrorTypes.isADirectoryErrorStaticMethods,
        debugFn: PyIsADirectoryError.createDebugInfo(ptr:),
        deinitialize: PyIsADirectoryError.deinitialize(_:ptr:)
      )

      self.notADirectoryError = memory.newType(
        type: typeType,
        name: "NotADirectoryError",
        qualname: "NotADirectoryError",
        flags: [.hasGCFlag, .instancesHave__dict__Flag, .isBaseExceptionSubclassFlag, .isBaseTypeFlag, .isDefaultFlag],
        base: self.osError,
        bases: [self.osError],
        mroWithoutSelf: [self.osError, self.exception, self.baseException, objectType],
        subclasses: [],
        instanceSizeWithoutTail: PyNotADirectoryError.layout.size,
        staticMethods: Py.ErrorTypes.notADirectoryErrorStaticMethods,
        debugFn: PyNotADirectoryError.createDebugInfo(ptr:),
        deinitialize: PyNotADirectoryError.deinitialize(_:ptr:)
      )

      self.permissionError = memory.newType(
        type: typeType,
        name: "PermissionError",
        qualname: "PermissionError",
        flags: [.hasGCFlag, .instancesHave__dict__Flag, .isBaseExceptionSubclassFlag, .isBaseTypeFlag, .isDefaultFlag],
        base: self.osError,
        bases: [self.osError],
        mroWithoutSelf: [self.osError, self.exception, self.baseException, objectType],
        subclasses: [],
        instanceSizeWithoutTail: PyPermissionError.layout.size,
        staticMethods: Py.ErrorTypes.permissionErrorStaticMethods,
        debugFn: PyPermissionError.createDebugInfo(ptr:),
        deinitialize: PyPermissionError.deinitialize(_:ptr:)
      )

      self.processLookupError = memory.newType(
        type: typeType,
        name: "ProcessLookupError",
        qualname: "ProcessLookupError",
        flags: [.hasGCFlag, .instancesHave__dict__Flag, .isBaseExceptionSubclassFlag, .isBaseTypeFlag, .isDefaultFlag],
        base: self.osError,
        bases: [self.osError],
        mroWithoutSelf: [self.osError, self.exception, self.baseException, objectType],
        subclasses: [],
        instanceSizeWithoutTail: PyProcessLookupError.layout.size,
        staticMethods: Py.ErrorTypes.processLookupErrorStaticMethods,
        debugFn: PyProcessLookupError.createDebugInfo(ptr:),
        deinitialize: PyProcessLookupError.deinitialize(_:ptr:)
      )

      self.timeoutError = memory.newType(
        type: typeType,
        name: "TimeoutError",
        qualname: "TimeoutError",
        flags: [.hasGCFlag, .instancesHave__dict__Flag, .isBaseExceptionSubclassFlag, .isBaseTypeFlag, .isDefaultFlag],
        base: self.osError,
        bases: [self.osError],
        mroWithoutSelf: [self.osError, self.exception, self.baseException, objectType],
        subclasses: [],
        instanceSizeWithoutTail: PyTimeoutError.layout.size,
        staticMethods: Py.ErrorTypes.timeoutErrorStaticMethods,
        debugFn: PyTimeoutError.createDebugInfo(ptr:),
        deinitialize: PyTimeoutError.deinitialize(_:ptr:)
      )

      self.referenceError = memory.newType(
        type: typeType,
        name: "ReferenceError",
        qualname: "ReferenceError",
        flags: [.hasGCFlag, .instancesHave__dict__Flag, .isBaseExceptionSubclassFlag, .isBaseTypeFlag, .isDefaultFlag],
        base: self.exception,
        bases: [self.exception],
        mroWithoutSelf: [self.exception, self.baseException, objectType],
        subclasses: [],
        instanceSizeWithoutTail: PyReferenceError.layout.size,
        staticMethods: Py.ErrorTypes.referenceErrorStaticMethods,
        debugFn: PyReferenceError.createDebugInfo(ptr:),
        deinitialize: PyReferenceError.deinitialize(_:ptr:)
      )

      self.runtimeError = memory.newType(
        type: typeType,
        name: "RuntimeError",
        qualname: "RuntimeError",
        flags: [.hasGCFlag, .instancesHave__dict__Flag, .isBaseExceptionSubclassFlag, .isBaseTypeFlag, .isDefaultFlag],
        base: self.exception,
        bases: [self.exception],
        mroWithoutSelf: [self.exception, self.baseException, objectType],
        subclasses: [],
        instanceSizeWithoutTail: PyRuntimeError.layout.size,
        staticMethods: Py.ErrorTypes.runtimeErrorStaticMethods,
        debugFn: PyRuntimeError.createDebugInfo(ptr:),
        deinitialize: PyRuntimeError.deinitialize(_:ptr:)
      )

      self.notImplementedError = memory.newType(
        type: typeType,
        name: "NotImplementedError",
        qualname: "NotImplementedError",
        flags: [.hasGCFlag, .instancesHave__dict__Flag, .isBaseExceptionSubclassFlag, .isBaseTypeFlag, .isDefaultFlag],
        base: self.runtimeError,
        bases: [self.runtimeError],
        mroWithoutSelf: [self.runtimeError, self.exception, self.baseException, objectType],
        subclasses: [],
        instanceSizeWithoutTail: PyNotImplementedError.layout.size,
        staticMethods: Py.ErrorTypes.notImplementedErrorStaticMethods,
        debugFn: PyNotImplementedError.createDebugInfo(ptr:),
        deinitialize: PyNotImplementedError.deinitialize(_:ptr:)
      )

      self.recursionError = memory.newType(
        type: typeType,
        name: "RecursionError",
        qualname: "RecursionError",
        flags: [.hasGCFlag, .instancesHave__dict__Flag, .isBaseExceptionSubclassFlag, .isBaseTypeFlag, .isDefaultFlag],
        base: self.runtimeError,
        bases: [self.runtimeError],
        mroWithoutSelf: [self.runtimeError, self.exception, self.baseException, objectType],
        subclasses: [],
        instanceSizeWithoutTail: PyRecursionError.layout.size,
        staticMethods: Py.ErrorTypes.recursionErrorStaticMethods,
        debugFn: PyRecursionError.createDebugInfo(ptr:),
        deinitialize: PyRecursionError.deinitialize(_:ptr:)
      )

      self.syntaxError = memory.newType(
        type: typeType,
        name: "SyntaxError",
        qualname: "SyntaxError",
        flags: [.hasGCFlag, .instancesHave__dict__Flag, .isBaseExceptionSubclassFlag, .isBaseTypeFlag, .isDefaultFlag],
        base: self.exception,
        bases: [self.exception],
        mroWithoutSelf: [self.exception, self.baseException, objectType],
        subclasses: [],
        instanceSizeWithoutTail: PySyntaxError.layout.size,
        staticMethods: Py.ErrorTypes.syntaxErrorStaticMethods,
        debugFn: PySyntaxError.createDebugInfo(ptr:),
        deinitialize: PySyntaxError.deinitialize(_:ptr:)
      )

      self.indentationError = memory.newType(
        type: typeType,
        name: "IndentationError",
        qualname: "IndentationError",
        flags: [.hasGCFlag, .instancesHave__dict__Flag, .isBaseExceptionSubclassFlag, .isBaseTypeFlag, .isDefaultFlag],
        base: self.syntaxError,
        bases: [self.syntaxError],
        mroWithoutSelf: [self.syntaxError, self.exception, self.baseException, objectType],
        subclasses: [],
        instanceSizeWithoutTail: PyIndentationError.layout.size,
        staticMethods: Py.ErrorTypes.indentationErrorStaticMethods,
        debugFn: PyIndentationError.createDebugInfo(ptr:),
        deinitialize: PyIndentationError.deinitialize(_:ptr:)
      )

      self.tabError = memory.newType(
        type: typeType,
        name: "TabError",
        qualname: "TabError",
        flags: [.hasGCFlag, .instancesHave__dict__Flag, .isBaseExceptionSubclassFlag, .isBaseTypeFlag, .isDefaultFlag],
        base: self.indentationError,
        bases: [self.indentationError],
        mroWithoutSelf: [self.indentationError, self.syntaxError, self.exception, self.baseException, objectType],
        subclasses: [],
        instanceSizeWithoutTail: PyTabError.layout.size,
        staticMethods: Py.ErrorTypes.tabErrorStaticMethods,
        debugFn: PyTabError.createDebugInfo(ptr:),
        deinitialize: PyTabError.deinitialize(_:ptr:)
      )

      self.systemError = memory.newType(
        type: typeType,
        name: "SystemError",
        qualname: "SystemError",
        flags: [.hasGCFlag, .instancesHave__dict__Flag, .isBaseExceptionSubclassFlag, .isBaseTypeFlag, .isDefaultFlag],
        base: self.exception,
        bases: [self.exception],
        mroWithoutSelf: [self.exception, self.baseException, objectType],
        subclasses: [],
        instanceSizeWithoutTail: PySystemError.layout.size,
        staticMethods: Py.ErrorTypes.systemErrorStaticMethods,
        debugFn: PySystemError.createDebugInfo(ptr:),
        deinitialize: PySystemError.deinitialize(_:ptr:)
      )

      self.typeError = memory.newType(
        type: typeType,
        name: "TypeError",
        qualname: "TypeError",
        flags: [.hasGCFlag, .instancesHave__dict__Flag, .isBaseExceptionSubclassFlag, .isBaseTypeFlag, .isDefaultFlag],
        base: self.exception,
        bases: [self.exception],
        mroWithoutSelf: [self.exception, self.baseException, objectType],
        subclasses: [],
        instanceSizeWithoutTail: PyTypeError.layout.size,
        staticMethods: Py.ErrorTypes.typeErrorStaticMethods,
        debugFn: PyTypeError.createDebugInfo(ptr:),
        deinitialize: PyTypeError.deinitialize(_:ptr:)
      )

      self.valueError = memory.newType(
        type: typeType,
        name: "ValueError",
        qualname: "ValueError",
        flags: [.hasGCFlag, .instancesHave__dict__Flag, .isBaseExceptionSubclassFlag, .isBaseTypeFlag, .isDefaultFlag],
        base: self.exception,
        bases: [self.exception],
        mroWithoutSelf: [self.exception, self.baseException, objectType],
        subclasses: [],
        instanceSizeWithoutTail: PyValueError.layout.size,
        staticMethods: Py.ErrorTypes.valueErrorStaticMethods,
        debugFn: PyValueError.createDebugInfo(ptr:),
        deinitialize: PyValueError.deinitialize(_:ptr:)
      )

      self.unicodeError = memory.newType(
        type: typeType,
        name: "UnicodeError",
        qualname: "UnicodeError",
        flags: [.hasGCFlag, .instancesHave__dict__Flag, .isBaseExceptionSubclassFlag, .isBaseTypeFlag, .isDefaultFlag],
        base: self.valueError,
        bases: [self.valueError],
        mroWithoutSelf: [self.valueError, self.exception, self.baseException, objectType],
        subclasses: [],
        instanceSizeWithoutTail: PyUnicodeError.layout.size,
        staticMethods: Py.ErrorTypes.unicodeErrorStaticMethods,
        debugFn: PyUnicodeError.createDebugInfo(ptr:),
        deinitialize: PyUnicodeError.deinitialize(_:ptr:)
      )

      self.unicodeDecodeError = memory.newType(
        type: typeType,
        name: "UnicodeDecodeError",
        qualname: "UnicodeDecodeError",
        flags: [.hasGCFlag, .instancesHave__dict__Flag, .isBaseExceptionSubclassFlag, .isBaseTypeFlag, .isDefaultFlag],
        base: self.unicodeError,
        bases: [self.unicodeError],
        mroWithoutSelf: [self.unicodeError, self.valueError, self.exception, self.baseException, objectType],
        subclasses: [],
        instanceSizeWithoutTail: PyUnicodeDecodeError.layout.size,
        staticMethods: Py.ErrorTypes.unicodeDecodeErrorStaticMethods,
        debugFn: PyUnicodeDecodeError.createDebugInfo(ptr:),
        deinitialize: PyUnicodeDecodeError.deinitialize(_:ptr:)
      )

      self.unicodeEncodeError = memory.newType(
        type: typeType,
        name: "UnicodeEncodeError",
        qualname: "UnicodeEncodeError",
        flags: [.hasGCFlag, .instancesHave__dict__Flag, .isBaseExceptionSubclassFlag, .isBaseTypeFlag, .isDefaultFlag],
        base: self.unicodeError,
        bases: [self.unicodeError],
        mroWithoutSelf: [self.unicodeError, self.valueError, self.exception, self.baseException, objectType],
        subclasses: [],
        instanceSizeWithoutTail: PyUnicodeEncodeError.layout.size,
        staticMethods: Py.ErrorTypes.unicodeEncodeErrorStaticMethods,
        debugFn: PyUnicodeEncodeError.createDebugInfo(ptr:),
        deinitialize: PyUnicodeEncodeError.deinitialize(_:ptr:)
      )

      self.unicodeTranslateError = memory.newType(
        type: typeType,
        name: "UnicodeTranslateError",
        qualname: "UnicodeTranslateError",
        flags: [.hasGCFlag, .instancesHave__dict__Flag, .isBaseExceptionSubclassFlag, .isBaseTypeFlag, .isDefaultFlag],
        base: self.unicodeError,
        bases: [self.unicodeError],
        mroWithoutSelf: [self.unicodeError, self.valueError, self.exception, self.baseException, objectType],
        subclasses: [],
        instanceSizeWithoutTail: PyUnicodeTranslateError.layout.size,
        staticMethods: Py.ErrorTypes.unicodeTranslateErrorStaticMethods,
        debugFn: PyUnicodeTranslateError.createDebugInfo(ptr:),
        deinitialize: PyUnicodeTranslateError.deinitialize(_:ptr:)
      )

      self.warning = memory.newType(
        type: typeType,
        name: "Warning",
        qualname: "Warning",
        flags: [.hasGCFlag, .instancesHave__dict__Flag, .isBaseExceptionSubclassFlag, .isBaseTypeFlag, .isDefaultFlag],
        base: self.exception,
        bases: [self.exception],
        mroWithoutSelf: [self.exception, self.baseException, objectType],
        subclasses: [],
        instanceSizeWithoutTail: PyWarning.layout.size,
        staticMethods: Py.ErrorTypes.warningStaticMethods,
        debugFn: PyWarning.createDebugInfo(ptr:),
        deinitialize: PyWarning.deinitialize(_:ptr:)
      )

      self.deprecationWarning = memory.newType(
        type: typeType,
        name: "DeprecationWarning",
        qualname: "DeprecationWarning",
        flags: [.hasGCFlag, .instancesHave__dict__Flag, .isBaseExceptionSubclassFlag, .isBaseTypeFlag, .isDefaultFlag],
        base: self.warning,
        bases: [self.warning],
        mroWithoutSelf: [self.warning, self.exception, self.baseException, objectType],
        subclasses: [],
        instanceSizeWithoutTail: PyDeprecationWarning.layout.size,
        staticMethods: Py.ErrorTypes.deprecationWarningStaticMethods,
        debugFn: PyDeprecationWarning.createDebugInfo(ptr:),
        deinitialize: PyDeprecationWarning.deinitialize(_:ptr:)
      )

      self.pendingDeprecationWarning = memory.newType(
        type: typeType,
        name: "PendingDeprecationWarning",
        qualname: "PendingDeprecationWarning",
        flags: [.hasGCFlag, .instancesHave__dict__Flag, .isBaseExceptionSubclassFlag, .isBaseTypeFlag, .isDefaultFlag],
        base: self.warning,
        bases: [self.warning],
        mroWithoutSelf: [self.warning, self.exception, self.baseException, objectType],
        subclasses: [],
        instanceSizeWithoutTail: PyPendingDeprecationWarning.layout.size,
        staticMethods: Py.ErrorTypes.pendingDeprecationWarningStaticMethods,
        debugFn: PyPendingDeprecationWarning.createDebugInfo(ptr:),
        deinitialize: PyPendingDeprecationWarning.deinitialize(_:ptr:)
      )

      self.runtimeWarning = memory.newType(
        type: typeType,
        name: "RuntimeWarning",
        qualname: "RuntimeWarning",
        flags: [.hasGCFlag, .instancesHave__dict__Flag, .isBaseExceptionSubclassFlag, .isBaseTypeFlag, .isDefaultFlag],
        base: self.warning,
        bases: [self.warning],
        mroWithoutSelf: [self.warning, self.exception, self.baseException, objectType],
        subclasses: [],
        instanceSizeWithoutTail: PyRuntimeWarning.layout.size,
        staticMethods: Py.ErrorTypes.runtimeWarningStaticMethods,
        debugFn: PyRuntimeWarning.createDebugInfo(ptr:),
        deinitialize: PyRuntimeWarning.deinitialize(_:ptr:)
      )

      self.syntaxWarning = memory.newType(
        type: typeType,
        name: "SyntaxWarning",
        qualname: "SyntaxWarning",
        flags: [.hasGCFlag, .instancesHave__dict__Flag, .isBaseExceptionSubclassFlag, .isBaseTypeFlag, .isDefaultFlag],
        base: self.warning,
        bases: [self.warning],
        mroWithoutSelf: [self.warning, self.exception, self.baseException, objectType],
        subclasses: [],
        instanceSizeWithoutTail: PySyntaxWarning.layout.size,
        staticMethods: Py.ErrorTypes.syntaxWarningStaticMethods,
        debugFn: PySyntaxWarning.createDebugInfo(ptr:),
        deinitialize: PySyntaxWarning.deinitialize(_:ptr:)
      )

      self.userWarning = memory.newType(
        type: typeType,
        name: "UserWarning",
        qualname: "UserWarning",
        flags: [.hasGCFlag, .instancesHave__dict__Flag, .isBaseExceptionSubclassFlag, .isBaseTypeFlag, .isDefaultFlag],
        base: self.warning,
        bases: [self.warning],
        mroWithoutSelf: [self.warning, self.exception, self.baseException, objectType],
        subclasses: [],
        instanceSizeWithoutTail: PyUserWarning.layout.size,
        staticMethods: Py.ErrorTypes.userWarningStaticMethods,
        debugFn: PyUserWarning.createDebugInfo(ptr:),
        deinitialize: PyUserWarning.deinitialize(_:ptr:)
      )

      self.futureWarning = memory.newType(
        type: typeType,
        name: "FutureWarning",
        qualname: "FutureWarning",
        flags: [.hasGCFlag, .instancesHave__dict__Flag, .isBaseExceptionSubclassFlag, .isBaseTypeFlag, .isDefaultFlag],
        base: self.warning,
        bases: [self.warning],
        mroWithoutSelf: [self.warning, self.exception, self.baseException, objectType],
        subclasses: [],
        instanceSizeWithoutTail: PyFutureWarning.layout.size,
        staticMethods: Py.ErrorTypes.futureWarningStaticMethods,
        debugFn: PyFutureWarning.createDebugInfo(ptr:),
        deinitialize: PyFutureWarning.deinitialize(_:ptr:)
      )

      self.importWarning = memory.newType(
        type: typeType,
        name: "ImportWarning",
        qualname: "ImportWarning",
        flags: [.hasGCFlag, .instancesHave__dict__Flag, .isBaseExceptionSubclassFlag, .isBaseTypeFlag, .isDefaultFlag],
        base: self.warning,
        bases: [self.warning],
        mroWithoutSelf: [self.warning, self.exception, self.baseException, objectType],
        subclasses: [],
        instanceSizeWithoutTail: PyImportWarning.layout.size,
        staticMethods: Py.ErrorTypes.importWarningStaticMethods,
        debugFn: PyImportWarning.createDebugInfo(ptr:),
        deinitialize: PyImportWarning.deinitialize(_:ptr:)
      )

      self.unicodeWarning = memory.newType(
        type: typeType,
        name: "UnicodeWarning",
        qualname: "UnicodeWarning",
        flags: [.hasGCFlag, .instancesHave__dict__Flag, .isBaseExceptionSubclassFlag, .isBaseTypeFlag, .isDefaultFlag],
        base: self.warning,
        bases: [self.warning],
        mroWithoutSelf: [self.warning, self.exception, self.baseException, objectType],
        subclasses: [],
        instanceSizeWithoutTail: PyUnicodeWarning.layout.size,
        staticMethods: Py.ErrorTypes.unicodeWarningStaticMethods,
        debugFn: PyUnicodeWarning.createDebugInfo(ptr:),
        deinitialize: PyUnicodeWarning.deinitialize(_:ptr:)
      )

      self.bytesWarning = memory.newType(
        type: typeType,
        name: "BytesWarning",
        qualname: "BytesWarning",
        flags: [.hasGCFlag, .instancesHave__dict__Flag, .isBaseExceptionSubclassFlag, .isBaseTypeFlag, .isDefaultFlag],
        base: self.warning,
        bases: [self.warning],
        mroWithoutSelf: [self.warning, self.exception, self.baseException, objectType],
        subclasses: [],
        instanceSizeWithoutTail: PyBytesWarning.layout.size,
        staticMethods: Py.ErrorTypes.bytesWarningStaticMethods,
        debugFn: PyBytesWarning.createDebugInfo(ptr:),
        deinitialize: PyBytesWarning.deinitialize(_:ptr:)
      )

      self.resourceWarning = memory.newType(
        type: typeType,
        name: "ResourceWarning",
        qualname: "ResourceWarning",
        flags: [.hasGCFlag, .instancesHave__dict__Flag, .isBaseExceptionSubclassFlag, .isBaseTypeFlag, .isDefaultFlag],
        base: self.warning,
        bases: [self.warning],
        mroWithoutSelf: [self.warning, self.exception, self.baseException, objectType],
        subclasses: [],
        instanceSizeWithoutTail: PyResourceWarning.layout.size,
        staticMethods: Py.ErrorTypes.resourceWarningStaticMethods,
        debugFn: PyResourceWarning.createDebugInfo(ptr:),
        deinitialize: PyResourceWarning.deinitialize(_:ptr:)
      )

    }

    // MARK: - Stage 2 - fill __dict__

    /// This function finalizes init of all of the stored types.
    ///
    /// For example it will:
    /// - add `__doc__`
    /// - fill `__dict__`
    internal func fill__dict__(_ py: Py) {
      self.fillBaseException(py)
      self.fillSystemExit(py)
      self.fillKeyboardInterrupt(py)
      self.fillGeneratorExit(py)
      self.fillException(py)
      self.fillStopIteration(py)
      self.fillStopAsyncIteration(py)
      self.fillArithmeticError(py)
      self.fillFloatingPointError(py)
      self.fillOverflowError(py)
      self.fillZeroDivisionError(py)
      self.fillAssertionError(py)
      self.fillAttributeError(py)
      self.fillBufferError(py)
      self.fillEOFError(py)
      self.fillImportError(py)
      self.fillModuleNotFoundError(py)
      self.fillLookupError(py)
      self.fillIndexError(py)
      self.fillKeyError(py)
      self.fillMemoryError(py)
      self.fillNameError(py)
      self.fillUnboundLocalError(py)
      self.fillOSError(py)
      self.fillBlockingIOError(py)
      self.fillChildProcessError(py)
      self.fillConnectionError(py)
      self.fillBrokenPipeError(py)
      self.fillConnectionAbortedError(py)
      self.fillConnectionRefusedError(py)
      self.fillConnectionResetError(py)
      self.fillFileExistsError(py)
      self.fillFileNotFoundError(py)
      self.fillInterruptedError(py)
      self.fillIsADirectoryError(py)
      self.fillNotADirectoryError(py)
      self.fillPermissionError(py)
      self.fillProcessLookupError(py)
      self.fillTimeoutError(py)
      self.fillReferenceError(py)
      self.fillRuntimeError(py)
      self.fillNotImplementedError(py)
      self.fillRecursionError(py)
      self.fillSyntaxError(py)
      self.fillIndentationError(py)
      self.fillTabError(py)
      self.fillSystemError(py)
      self.fillTypeError(py)
      self.fillValueError(py)
      self.fillUnicodeError(py)
      self.fillUnicodeDecodeError(py)
      self.fillUnicodeEncodeError(py)
      self.fillUnicodeTranslateError(py)
      self.fillWarning(py)
      self.fillDeprecationWarning(py)
      self.fillPendingDeprecationWarning(py)
      self.fillRuntimeWarning(py)
      self.fillSyntaxWarning(py)
      self.fillUserWarning(py)
      self.fillFutureWarning(py)
      self.fillImportWarning(py)
      self.fillUnicodeWarning(py)
      self.fillBytesWarning(py)
      self.fillResourceWarning(py)
    }

    // MARK: - Helpers

    /// Adds `property` to `type.__dict__`.
    private func add(_ py: Py, type: PyType, name: String, property get: FunctionWrapper, doc: String?) {
      let property = py.newProperty(get: get, set: nil, del: nil, doc: doc)
      let value = property.asObject
      self.add(py, type: type, name: name, value: value)
    }

    /// Adds `property` to `type.__dict__`.
    private func add(_ py: Py, type: PyType, name: String, property get: FunctionWrapper, setter set: FunctionWrapper, doc: String?) {
      let property = py.newProperty(get: get, set: set, del: nil, doc: doc)
      let value = property.asObject
      self.add(py, type: type, name: name, value: value)
    }

    /// Adds `method` to `type.__dict__`.
    private func add(_ py: Py, type: PyType, name: String, method: FunctionWrapper, doc: String?) {
      let builtinFunction = py.newBuiltinFunction(fn: method, module: nil, doc: doc)
      let value = builtinFunction.asObject
      self.add(py, type: type, name: name, value: value)
    }

    /// Adds `classmethod` to `type.__dict__`.
    private func add(_ py: Py, type: PyType, name: String, classMethod: FunctionWrapper, doc: String?) {
      let builtinFunction = py.newBuiltinFunction(fn: classMethod, module: nil, doc: doc)
      let staticMethod = py.newClassMethod(callable: builtinFunction)
      let value = staticMethod.asObject
      self.add(py, type: type, name: name, value: value)
    }

    /// Adds `staticmethod` to `type.__dict__`.
    private func add(_ py: Py, type: PyType, name: String, staticMethod: FunctionWrapper, doc: String?) {
      let builtinFunction = py.newBuiltinFunction(fn: staticMethod, module: nil, doc: doc)
      let staticMethod = py.newStaticMethod(callable: builtinFunction)
      let value = staticMethod.asObject
      self.add(py, type: type, name: name, value: value)
    }

    /// Adds value to `type.__dict__`.
    private func add(_ py: Py, type: PyType, name: String, value: PyObject) {
      let dict = type.getDict(py)
      let interned = py.intern(string: name)

      switch dict.set(py, key: interned, value: value) {
      case .ok:
        break
      case .error(let e):
        let typeName = type.getNameString()
        trap("Error when adding '\(name)' to '\(typeName)' type: \(e)")
      }
    }

    // MARK: - BaseException

    private func fillBaseException(_ py: Py) {
      let type = self.baseException
      type.setBuiltinTypeDoc(py, value: PyBaseException.doc)

      let __new__ = FunctionWrapper(type: type, fn: PyBaseException.__new__(_:type:args:kwargs:))
      self.add(py, type: type, name: "__new__", staticMethod: __new__, doc: nil)
      let __init__ = FunctionWrapper(type: type, fn: PyBaseException.__init__(_:zelf:args:kwargs:))
      self.add(py, type: type, name: "__init__", method: __init__, doc: nil)

      let __dict__ = FunctionWrapper(name: "__get__", fn: PyBaseException.__dict__(_:zelf:))
      self.add(py, type: type, name: "__dict__", property: __dict__, doc: nil)
      let __class__ = FunctionWrapper(name: "__get__", fn: PyBaseException.__class__(_:zelf:))
      self.add(py, type: type, name: "__class__", property: __class__, doc: nil)
      let argsGet = FunctionWrapper(name: "__get__", fn: PyBaseException.args(_:zelf:))
      let argsSet = FunctionWrapper(name: "__set__", fn: PyBaseException.args(_:zelf:value:))
      self.add(py, type: type, name: "args", property: argsGet, setter: argsSet, doc: nil)
      let __traceback__Get = FunctionWrapper(name: "__get__", fn: PyBaseException.__traceback__(_:zelf:))
      let __traceback__Set = FunctionWrapper(name: "__set__", fn: PyBaseException.__traceback__(_:zelf:value:))
      self.add(py, type: type, name: "__traceback__", property: __traceback__Get, setter: __traceback__Set, doc: nil)
      let __cause__Get = FunctionWrapper(name: "__get__", fn: PyBaseException.__cause__(_:zelf:))
      let __cause__Set = FunctionWrapper(name: "__set__", fn: PyBaseException.__cause__(_:zelf:value:))
      self.add(py, type: type, name: "__cause__", property: __cause__Get, setter: __cause__Set, doc: nil)
      let __context__Get = FunctionWrapper(name: "__get__", fn: PyBaseException.__context__(_:zelf:))
      let __context__Set = FunctionWrapper(name: "__set__", fn: PyBaseException.__context__(_:zelf:value:))
      self.add(py, type: type, name: "__context__", property: __context__Get, setter: __context__Set, doc: nil)
      let __suppress_context__Get = FunctionWrapper(name: "__get__", fn: PyBaseException.__suppress_context__(_:zelf:))
      let __suppress_context__Set = FunctionWrapper(name: "__set__", fn: PyBaseException.__suppress_context__(_:zelf:value:))
      self.add(py, type: type, name: "__suppress_context__", property: __suppress_context__Get, setter: __suppress_context__Set, doc: nil)

      let __repr__ = FunctionWrapper(name: "__repr__", fn: PyBaseException.__repr__(_:zelf:))
      self.add(py, type: type, name: "__repr__", method: __repr__, doc: nil)
      let __str__ = FunctionWrapper(name: "__str__", fn: PyBaseException.__str__(_:zelf:))
      self.add(py, type: type, name: "__str__", method: __str__, doc: nil)
      let __getattribute__ = FunctionWrapper(name: "__getattribute__", fn: PyBaseException.__getattribute__(_:zelf:name:))
      self.add(py, type: type, name: "__getattribute__", method: __getattribute__, doc: nil)
      let __setattr__ = FunctionWrapper(name: "__setattr__", fn: PyBaseException.__setattr__(_:zelf:name:value:))
      self.add(py, type: type, name: "__setattr__", method: __setattr__, doc: nil)
      let __delattr__ = FunctionWrapper(name: "__delattr__", fn: PyBaseException.__delattr__(_:zelf:name:))
      self.add(py, type: type, name: "__delattr__", method: __delattr__, doc: nil)
      let with_traceback = FunctionWrapper(name: "with_traceback", fn: PyBaseException.with_traceback(_:zelf:traceback:))
      self.add(py, type: type, name: "with_traceback", method: with_traceback, doc: PyBaseException.withTracebackDoc)
    }

    internal static var baseExceptionStaticMethods: PyStaticCall.KnownNotOverriddenMethods = {
      var result = Py.Types.objectStaticMethods.copy()
      result.__repr__ = .init(PyBaseException.__repr__(_:zelf:))
      result.__str__ = .init(PyBaseException.__str__(_:zelf:))
      result.__getattribute__ = .init(PyBaseException.__getattribute__(_:zelf:name:))
      result.__setattr__ = .init(PyBaseException.__setattr__(_:zelf:name:value:))
      result.__delattr__ = .init(PyBaseException.__delattr__(_:zelf:name:))
      return result
    }()

    // MARK: - SystemExit

    private func fillSystemExit(_ py: Py) {
      let type = self.systemExit
      type.setBuiltinTypeDoc(py, value: PySystemExit.systemExitDoc)

      let __new__ = FunctionWrapper(type: type, fn: PySystemExit.__new__(_:type:args:kwargs:))
      self.add(py, type: type, name: "__new__", staticMethod: __new__, doc: nil)
      let __init__ = FunctionWrapper(type: type, fn: PySystemExit.__init__(_:zelf:args:kwargs:))
      self.add(py, type: type, name: "__init__", method: __init__, doc: nil)

      let __class__ = FunctionWrapper(name: "__get__", fn: PySystemExit.__class__(_:zelf:))
      self.add(py, type: type, name: "__class__", property: __class__, doc: nil)
      let __dict__ = FunctionWrapper(name: "__get__", fn: PySystemExit.__dict__(_:zelf:))
      self.add(py, type: type, name: "__dict__", property: __dict__, doc: nil)
      let codeGet = FunctionWrapper(name: "__get__", fn: PySystemExit.code(_:zelf:))
      let codeSet = FunctionWrapper(name: "__set__", fn: PySystemExit.code(_:zelf:value:))
      self.add(py, type: type, name: "code", property: codeGet, setter: codeSet, doc: nil)
    }

    // 'SystemExit' does not add any interesting methods to 'BaseException'.
    internal static let systemExitStaticMethods = Py.ErrorTypes.baseExceptionStaticMethods.copy()

    // MARK: - KeyboardInterrupt

    private func fillKeyboardInterrupt(_ py: Py) {
      let type = self.keyboardInterrupt
      type.setBuiltinTypeDoc(py, value: PyKeyboardInterrupt.doc)

      let __new__ = FunctionWrapper(type: type, fn: PyKeyboardInterrupt.__new__(_:type:args:kwargs:))
      self.add(py, type: type, name: "__new__", staticMethod: __new__, doc: nil)
      let __init__ = FunctionWrapper(type: type, fn: PyKeyboardInterrupt.__init__(_:zelf:args:kwargs:))
      self.add(py, type: type, name: "__init__", method: __init__, doc: nil)

      let __class__ = FunctionWrapper(name: "__get__", fn: PyKeyboardInterrupt.__class__(_:zelf:))
      self.add(py, type: type, name: "__class__", property: __class__, doc: nil)
      let __dict__ = FunctionWrapper(name: "__get__", fn: PyKeyboardInterrupt.__dict__(_:zelf:))
      self.add(py, type: type, name: "__dict__", property: __dict__, doc: nil)
    }

    // 'KeyboardInterrupt' does not add any interesting methods to 'BaseException'.
    internal static let keyboardInterruptStaticMethods = Py.ErrorTypes.baseExceptionStaticMethods.copy()

    // MARK: - GeneratorExit

    private func fillGeneratorExit(_ py: Py) {
      let type = self.generatorExit
      type.setBuiltinTypeDoc(py, value: PyGeneratorExit.doc)

      let __new__ = FunctionWrapper(type: type, fn: PyGeneratorExit.__new__(_:type:args:kwargs:))
      self.add(py, type: type, name: "__new__", staticMethod: __new__, doc: nil)
      let __init__ = FunctionWrapper(type: type, fn: PyGeneratorExit.__init__(_:zelf:args:kwargs:))
      self.add(py, type: type, name: "__init__", method: __init__, doc: nil)

      let __class__ = FunctionWrapper(name: "__get__", fn: PyGeneratorExit.__class__(_:zelf:))
      self.add(py, type: type, name: "__class__", property: __class__, doc: nil)
      let __dict__ = FunctionWrapper(name: "__get__", fn: PyGeneratorExit.__dict__(_:zelf:))
      self.add(py, type: type, name: "__dict__", property: __dict__, doc: nil)
    }

    // 'GeneratorExit' does not add any interesting methods to 'BaseException'.
    internal static let generatorExitStaticMethods = Py.ErrorTypes.baseExceptionStaticMethods.copy()

    // MARK: - Exception

    private func fillException(_ py: Py) {
      let type = self.exception
      type.setBuiltinTypeDoc(py, value: PyException.doc)

      let __new__ = FunctionWrapper(type: type, fn: PyException.__new__(_:type:args:kwargs:))
      self.add(py, type: type, name: "__new__", staticMethod: __new__, doc: nil)
      let __init__ = FunctionWrapper(type: type, fn: PyException.__init__(_:zelf:args:kwargs:))
      self.add(py, type: type, name: "__init__", method: __init__, doc: nil)

      let __class__ = FunctionWrapper(name: "__get__", fn: PyException.__class__(_:zelf:))
      self.add(py, type: type, name: "__class__", property: __class__, doc: nil)
      let __dict__ = FunctionWrapper(name: "__get__", fn: PyException.__dict__(_:zelf:))
      self.add(py, type: type, name: "__dict__", property: __dict__, doc: nil)
    }

    // 'Exception' does not add any interesting methods to 'BaseException'.
    internal static let exceptionStaticMethods = Py.ErrorTypes.baseExceptionStaticMethods.copy()

    // MARK: - StopIteration

    private func fillStopIteration(_ py: Py) {
      let type = self.stopIteration
      type.setBuiltinTypeDoc(py, value: PyStopIteration.stopIterationDoc)

      let __new__ = FunctionWrapper(type: type, fn: PyStopIteration.__new__(_:type:args:kwargs:))
      self.add(py, type: type, name: "__new__", staticMethod: __new__, doc: nil)
      let __init__ = FunctionWrapper(type: type, fn: PyStopIteration.__init__(_:zelf:args:kwargs:))
      self.add(py, type: type, name: "__init__", method: __init__, doc: nil)

      let __class__ = FunctionWrapper(name: "__get__", fn: PyStopIteration.__class__(_:zelf:))
      self.add(py, type: type, name: "__class__", property: __class__, doc: nil)
      let __dict__ = FunctionWrapper(name: "__get__", fn: PyStopIteration.__dict__(_:zelf:))
      self.add(py, type: type, name: "__dict__", property: __dict__, doc: nil)
      let valueGet = FunctionWrapper(name: "__get__", fn: PyStopIteration.value(_:zelf:))
      let valueSet = FunctionWrapper(name: "__set__", fn: PyStopIteration.value(_:zelf:value:))
      self.add(py, type: type, name: "value", property: valueGet, setter: valueSet, doc: nil)
    }

    // 'StopIteration' does not add any interesting methods to 'Exception'.
    internal static let stopIterationStaticMethods = Py.ErrorTypes.exceptionStaticMethods.copy()

    // MARK: - StopAsyncIteration

    private func fillStopAsyncIteration(_ py: Py) {
      let type = self.stopAsyncIteration
      type.setBuiltinTypeDoc(py, value: PyStopAsyncIteration.doc)

      let __new__ = FunctionWrapper(type: type, fn: PyStopAsyncIteration.__new__(_:type:args:kwargs:))
      self.add(py, type: type, name: "__new__", staticMethod: __new__, doc: nil)
      let __init__ = FunctionWrapper(type: type, fn: PyStopAsyncIteration.__init__(_:zelf:args:kwargs:))
      self.add(py, type: type, name: "__init__", method: __init__, doc: nil)

      let __class__ = FunctionWrapper(name: "__get__", fn: PyStopAsyncIteration.__class__(_:zelf:))
      self.add(py, type: type, name: "__class__", property: __class__, doc: nil)
      let __dict__ = FunctionWrapper(name: "__get__", fn: PyStopAsyncIteration.__dict__(_:zelf:))
      self.add(py, type: type, name: "__dict__", property: __dict__, doc: nil)
    }

    // 'StopAsyncIteration' does not add any interesting methods to 'Exception'.
    internal static let stopAsyncIterationStaticMethods = Py.ErrorTypes.exceptionStaticMethods.copy()

    // MARK: - ArithmeticError

    private func fillArithmeticError(_ py: Py) {
      let type = self.arithmeticError
      type.setBuiltinTypeDoc(py, value: PyArithmeticError.doc)

      let __new__ = FunctionWrapper(type: type, fn: PyArithmeticError.__new__(_:type:args:kwargs:))
      self.add(py, type: type, name: "__new__", staticMethod: __new__, doc: nil)
      let __init__ = FunctionWrapper(type: type, fn: PyArithmeticError.__init__(_:zelf:args:kwargs:))
      self.add(py, type: type, name: "__init__", method: __init__, doc: nil)

      let __class__ = FunctionWrapper(name: "__get__", fn: PyArithmeticError.__class__(_:zelf:))
      self.add(py, type: type, name: "__class__", property: __class__, doc: nil)
      let __dict__ = FunctionWrapper(name: "__get__", fn: PyArithmeticError.__dict__(_:zelf:))
      self.add(py, type: type, name: "__dict__", property: __dict__, doc: nil)
    }

    // 'ArithmeticError' does not add any interesting methods to 'Exception'.
    internal static let arithmeticErrorStaticMethods = Py.ErrorTypes.exceptionStaticMethods.copy()

    // MARK: - FloatingPointError

    private func fillFloatingPointError(_ py: Py) {
      let type = self.floatingPointError
      type.setBuiltinTypeDoc(py, value: PyFloatingPointError.doc)

      let __new__ = FunctionWrapper(type: type, fn: PyFloatingPointError.__new__(_:type:args:kwargs:))
      self.add(py, type: type, name: "__new__", staticMethod: __new__, doc: nil)
      let __init__ = FunctionWrapper(type: type, fn: PyFloatingPointError.__init__(_:zelf:args:kwargs:))
      self.add(py, type: type, name: "__init__", method: __init__, doc: nil)

      let __class__ = FunctionWrapper(name: "__get__", fn: PyFloatingPointError.__class__(_:zelf:))
      self.add(py, type: type, name: "__class__", property: __class__, doc: nil)
      let __dict__ = FunctionWrapper(name: "__get__", fn: PyFloatingPointError.__dict__(_:zelf:))
      self.add(py, type: type, name: "__dict__", property: __dict__, doc: nil)
    }

    // 'FloatingPointError' does not add any interesting methods to 'ArithmeticError'.
    internal static let floatingPointErrorStaticMethods = Py.ErrorTypes.arithmeticErrorStaticMethods.copy()

    // MARK: - OverflowError

    private func fillOverflowError(_ py: Py) {
      let type = self.overflowError
      type.setBuiltinTypeDoc(py, value: PyOverflowError.doc)

      let __new__ = FunctionWrapper(type: type, fn: PyOverflowError.__new__(_:type:args:kwargs:))
      self.add(py, type: type, name: "__new__", staticMethod: __new__, doc: nil)
      let __init__ = FunctionWrapper(type: type, fn: PyOverflowError.__init__(_:zelf:args:kwargs:))
      self.add(py, type: type, name: "__init__", method: __init__, doc: nil)

      let __class__ = FunctionWrapper(name: "__get__", fn: PyOverflowError.__class__(_:zelf:))
      self.add(py, type: type, name: "__class__", property: __class__, doc: nil)
      let __dict__ = FunctionWrapper(name: "__get__", fn: PyOverflowError.__dict__(_:zelf:))
      self.add(py, type: type, name: "__dict__", property: __dict__, doc: nil)
    }

    // 'OverflowError' does not add any interesting methods to 'ArithmeticError'.
    internal static let overflowErrorStaticMethods = Py.ErrorTypes.arithmeticErrorStaticMethods.copy()

    // MARK: - ZeroDivisionError

    private func fillZeroDivisionError(_ py: Py) {
      let type = self.zeroDivisionError
      type.setBuiltinTypeDoc(py, value: PyZeroDivisionError.doc)

      let __new__ = FunctionWrapper(type: type, fn: PyZeroDivisionError.__new__(_:type:args:kwargs:))
      self.add(py, type: type, name: "__new__", staticMethod: __new__, doc: nil)
      let __init__ = FunctionWrapper(type: type, fn: PyZeroDivisionError.__init__(_:zelf:args:kwargs:))
      self.add(py, type: type, name: "__init__", method: __init__, doc: nil)

      let __class__ = FunctionWrapper(name: "__get__", fn: PyZeroDivisionError.__class__(_:zelf:))
      self.add(py, type: type, name: "__class__", property: __class__, doc: nil)
      let __dict__ = FunctionWrapper(name: "__get__", fn: PyZeroDivisionError.__dict__(_:zelf:))
      self.add(py, type: type, name: "__dict__", property: __dict__, doc: nil)
    }

    // 'ZeroDivisionError' does not add any interesting methods to 'ArithmeticError'.
    internal static let zeroDivisionErrorStaticMethods = Py.ErrorTypes.arithmeticErrorStaticMethods.copy()

    // MARK: - AssertionError

    private func fillAssertionError(_ py: Py) {
      let type = self.assertionError
      type.setBuiltinTypeDoc(py, value: PyAssertionError.doc)

      let __new__ = FunctionWrapper(type: type, fn: PyAssertionError.__new__(_:type:args:kwargs:))
      self.add(py, type: type, name: "__new__", staticMethod: __new__, doc: nil)
      let __init__ = FunctionWrapper(type: type, fn: PyAssertionError.__init__(_:zelf:args:kwargs:))
      self.add(py, type: type, name: "__init__", method: __init__, doc: nil)

      let __class__ = FunctionWrapper(name: "__get__", fn: PyAssertionError.__class__(_:zelf:))
      self.add(py, type: type, name: "__class__", property: __class__, doc: nil)
      let __dict__ = FunctionWrapper(name: "__get__", fn: PyAssertionError.__dict__(_:zelf:))
      self.add(py, type: type, name: "__dict__", property: __dict__, doc: nil)
    }

    // 'AssertionError' does not add any interesting methods to 'Exception'.
    internal static let assertionErrorStaticMethods = Py.ErrorTypes.exceptionStaticMethods.copy()

    // MARK: - AttributeError

    private func fillAttributeError(_ py: Py) {
      let type = self.attributeError
      type.setBuiltinTypeDoc(py, value: PyAttributeError.doc)

      let __new__ = FunctionWrapper(type: type, fn: PyAttributeError.__new__(_:type:args:kwargs:))
      self.add(py, type: type, name: "__new__", staticMethod: __new__, doc: nil)
      let __init__ = FunctionWrapper(type: type, fn: PyAttributeError.__init__(_:zelf:args:kwargs:))
      self.add(py, type: type, name: "__init__", method: __init__, doc: nil)

      let __class__ = FunctionWrapper(name: "__get__", fn: PyAttributeError.__class__(_:zelf:))
      self.add(py, type: type, name: "__class__", property: __class__, doc: nil)
      let __dict__ = FunctionWrapper(name: "__get__", fn: PyAttributeError.__dict__(_:zelf:))
      self.add(py, type: type, name: "__dict__", property: __dict__, doc: nil)
    }

    // 'AttributeError' does not add any interesting methods to 'Exception'.
    internal static let attributeErrorStaticMethods = Py.ErrorTypes.exceptionStaticMethods.copy()

    // MARK: - BufferError

    private func fillBufferError(_ py: Py) {
      let type = self.bufferError
      type.setBuiltinTypeDoc(py, value: PyBufferError.doc)

      let __new__ = FunctionWrapper(type: type, fn: PyBufferError.__new__(_:type:args:kwargs:))
      self.add(py, type: type, name: "__new__", staticMethod: __new__, doc: nil)
      let __init__ = FunctionWrapper(type: type, fn: PyBufferError.__init__(_:zelf:args:kwargs:))
      self.add(py, type: type, name: "__init__", method: __init__, doc: nil)

      let __class__ = FunctionWrapper(name: "__get__", fn: PyBufferError.__class__(_:zelf:))
      self.add(py, type: type, name: "__class__", property: __class__, doc: nil)
      let __dict__ = FunctionWrapper(name: "__get__", fn: PyBufferError.__dict__(_:zelf:))
      self.add(py, type: type, name: "__dict__", property: __dict__, doc: nil)
    }

    // 'BufferError' does not add any interesting methods to 'Exception'.
    internal static let bufferErrorStaticMethods = Py.ErrorTypes.exceptionStaticMethods.copy()

    // MARK: - EOFError

    private func fillEOFError(_ py: Py) {
      let type = self.eofError
      type.setBuiltinTypeDoc(py, value: PyEOFError.doc)

      let __new__ = FunctionWrapper(type: type, fn: PyEOFError.__new__(_:type:args:kwargs:))
      self.add(py, type: type, name: "__new__", staticMethod: __new__, doc: nil)
      let __init__ = FunctionWrapper(type: type, fn: PyEOFError.__init__(_:zelf:args:kwargs:))
      self.add(py, type: type, name: "__init__", method: __init__, doc: nil)

      let __class__ = FunctionWrapper(name: "__get__", fn: PyEOFError.__class__(_:zelf:))
      self.add(py, type: type, name: "__class__", property: __class__, doc: nil)
      let __dict__ = FunctionWrapper(name: "__get__", fn: PyEOFError.__dict__(_:zelf:))
      self.add(py, type: type, name: "__dict__", property: __dict__, doc: nil)
    }

    // 'EOFError' does not add any interesting methods to 'Exception'.
    internal static let eOFErrorStaticMethods = Py.ErrorTypes.exceptionStaticMethods.copy()

    // MARK: - ImportError

    private func fillImportError(_ py: Py) {
      let type = self.importError
      type.setBuiltinTypeDoc(py, value: PyImportError.importErrorDoc)

      let __new__ = FunctionWrapper(type: type, fn: PyImportError.__new__(_:type:args:kwargs:))
      self.add(py, type: type, name: "__new__", staticMethod: __new__, doc: nil)
      let __init__ = FunctionWrapper(type: type, fn: PyImportError.__init__(_:zelf:args:kwargs:))
      self.add(py, type: type, name: "__init__", method: __init__, doc: nil)

      let __class__ = FunctionWrapper(name: "__get__", fn: PyImportError.__class__(_:zelf:))
      self.add(py, type: type, name: "__class__", property: __class__, doc: nil)
      let __dict__ = FunctionWrapper(name: "__get__", fn: PyImportError.__dict__(_:zelf:))
      self.add(py, type: type, name: "__dict__", property: __dict__, doc: nil)
      let msgGet = FunctionWrapper(name: "__get__", fn: PyImportError.msg(_:zelf:))
      let msgSet = FunctionWrapper(name: "__set__", fn: PyImportError.msg(_:zelf:value:))
      self.add(py, type: type, name: "msg", property: msgGet, setter: msgSet, doc: nil)
      let nameGet = FunctionWrapper(name: "__get__", fn: PyImportError.name(_:zelf:))
      let nameSet = FunctionWrapper(name: "__set__", fn: PyImportError.name(_:zelf:value:))
      self.add(py, type: type, name: "name", property: nameGet, setter: nameSet, doc: nil)
      let pathGet = FunctionWrapper(name: "__get__", fn: PyImportError.path(_:zelf:))
      let pathSet = FunctionWrapper(name: "__set__", fn: PyImportError.path(_:zelf:value:))
      self.add(py, type: type, name: "path", property: pathGet, setter: pathSet, doc: nil)

      let __str__ = FunctionWrapper(name: "__str__", fn: PyImportError.__str__(_:zelf:))
      self.add(py, type: type, name: "__str__", method: __str__, doc: nil)
    }

    internal static var importErrorStaticMethods: PyStaticCall.KnownNotOverriddenMethods = {
      var result = Py.ErrorTypes.exceptionStaticMethods.copy()
      result.__str__ = .init(PyImportError.__str__(_:zelf:))
      return result
    }()

    // MARK: - ModuleNotFoundError

    private func fillModuleNotFoundError(_ py: Py) {
      let type = self.moduleNotFoundError
      type.setBuiltinTypeDoc(py, value: PyModuleNotFoundError.doc)

      let __new__ = FunctionWrapper(type: type, fn: PyModuleNotFoundError.__new__(_:type:args:kwargs:))
      self.add(py, type: type, name: "__new__", staticMethod: __new__, doc: nil)
      let __init__ = FunctionWrapper(type: type, fn: PyModuleNotFoundError.__init__(_:zelf:args:kwargs:))
      self.add(py, type: type, name: "__init__", method: __init__, doc: nil)

      let __class__ = FunctionWrapper(name: "__get__", fn: PyModuleNotFoundError.__class__(_:zelf:))
      self.add(py, type: type, name: "__class__", property: __class__, doc: nil)
      let __dict__ = FunctionWrapper(name: "__get__", fn: PyModuleNotFoundError.__dict__(_:zelf:))
      self.add(py, type: type, name: "__dict__", property: __dict__, doc: nil)
    }

    // 'ModuleNotFoundError' does not add any interesting methods to 'ImportError'.
    internal static let moduleNotFoundErrorStaticMethods = Py.ErrorTypes.importErrorStaticMethods.copy()

    // MARK: - LookupError

    private func fillLookupError(_ py: Py) {
      let type = self.lookupError
      type.setBuiltinTypeDoc(py, value: PyLookupError.doc)

      let __new__ = FunctionWrapper(type: type, fn: PyLookupError.__new__(_:type:args:kwargs:))
      self.add(py, type: type, name: "__new__", staticMethod: __new__, doc: nil)
      let __init__ = FunctionWrapper(type: type, fn: PyLookupError.__init__(_:zelf:args:kwargs:))
      self.add(py, type: type, name: "__init__", method: __init__, doc: nil)

      let __class__ = FunctionWrapper(name: "__get__", fn: PyLookupError.__class__(_:zelf:))
      self.add(py, type: type, name: "__class__", property: __class__, doc: nil)
      let __dict__ = FunctionWrapper(name: "__get__", fn: PyLookupError.__dict__(_:zelf:))
      self.add(py, type: type, name: "__dict__", property: __dict__, doc: nil)
    }

    // 'LookupError' does not add any interesting methods to 'Exception'.
    internal static let lookupErrorStaticMethods = Py.ErrorTypes.exceptionStaticMethods.copy()

    // MARK: - IndexError

    private func fillIndexError(_ py: Py) {
      let type = self.indexError
      type.setBuiltinTypeDoc(py, value: PyIndexError.doc)

      let __new__ = FunctionWrapper(type: type, fn: PyIndexError.__new__(_:type:args:kwargs:))
      self.add(py, type: type, name: "__new__", staticMethod: __new__, doc: nil)
      let __init__ = FunctionWrapper(type: type, fn: PyIndexError.__init__(_:zelf:args:kwargs:))
      self.add(py, type: type, name: "__init__", method: __init__, doc: nil)

      let __class__ = FunctionWrapper(name: "__get__", fn: PyIndexError.__class__(_:zelf:))
      self.add(py, type: type, name: "__class__", property: __class__, doc: nil)
      let __dict__ = FunctionWrapper(name: "__get__", fn: PyIndexError.__dict__(_:zelf:))
      self.add(py, type: type, name: "__dict__", property: __dict__, doc: nil)
    }

    // 'IndexError' does not add any interesting methods to 'LookupError'.
    internal static let indexErrorStaticMethods = Py.ErrorTypes.lookupErrorStaticMethods.copy()

    // MARK: - KeyError

    private func fillKeyError(_ py: Py) {
      let type = self.keyError
      type.setBuiltinTypeDoc(py, value: PyKeyError.keyErrorDoc)

      let __new__ = FunctionWrapper(type: type, fn: PyKeyError.__new__(_:type:args:kwargs:))
      self.add(py, type: type, name: "__new__", staticMethod: __new__, doc: nil)
      let __init__ = FunctionWrapper(type: type, fn: PyKeyError.__init__(_:zelf:args:kwargs:))
      self.add(py, type: type, name: "__init__", method: __init__, doc: nil)

      let __class__ = FunctionWrapper(name: "__get__", fn: PyKeyError.__class__(_:zelf:))
      self.add(py, type: type, name: "__class__", property: __class__, doc: nil)
      let __dict__ = FunctionWrapper(name: "__get__", fn: PyKeyError.__dict__(_:zelf:))
      self.add(py, type: type, name: "__dict__", property: __dict__, doc: nil)

      let __str__ = FunctionWrapper(name: "__str__", fn: PyKeyError.__str__(_:zelf:))
      self.add(py, type: type, name: "__str__", method: __str__, doc: nil)
    }

    internal static var keyErrorStaticMethods: PyStaticCall.KnownNotOverriddenMethods = {
      var result = Py.ErrorTypes.lookupErrorStaticMethods.copy()
      result.__str__ = .init(PyKeyError.__str__(_:zelf:))
      return result
    }()

    // MARK: - MemoryError

    private func fillMemoryError(_ py: Py) {
      let type = self.memoryError
      type.setBuiltinTypeDoc(py, value: PyMemoryError.doc)

      let __new__ = FunctionWrapper(type: type, fn: PyMemoryError.__new__(_:type:args:kwargs:))
      self.add(py, type: type, name: "__new__", staticMethod: __new__, doc: nil)
      let __init__ = FunctionWrapper(type: type, fn: PyMemoryError.__init__(_:zelf:args:kwargs:))
      self.add(py, type: type, name: "__init__", method: __init__, doc: nil)

      let __class__ = FunctionWrapper(name: "__get__", fn: PyMemoryError.__class__(_:zelf:))
      self.add(py, type: type, name: "__class__", property: __class__, doc: nil)
      let __dict__ = FunctionWrapper(name: "__get__", fn: PyMemoryError.__dict__(_:zelf:))
      self.add(py, type: type, name: "__dict__", property: __dict__, doc: nil)
    }

    // 'MemoryError' does not add any interesting methods to 'Exception'.
    internal static let memoryErrorStaticMethods = Py.ErrorTypes.exceptionStaticMethods.copy()

    // MARK: - NameError

    private func fillNameError(_ py: Py) {
      let type = self.nameError
      type.setBuiltinTypeDoc(py, value: PyNameError.doc)

      let __new__ = FunctionWrapper(type: type, fn: PyNameError.__new__(_:type:args:kwargs:))
      self.add(py, type: type, name: "__new__", staticMethod: __new__, doc: nil)
      let __init__ = FunctionWrapper(type: type, fn: PyNameError.__init__(_:zelf:args:kwargs:))
      self.add(py, type: type, name: "__init__", method: __init__, doc: nil)

      let __class__ = FunctionWrapper(name: "__get__", fn: PyNameError.__class__(_:zelf:))
      self.add(py, type: type, name: "__class__", property: __class__, doc: nil)
      let __dict__ = FunctionWrapper(name: "__get__", fn: PyNameError.__dict__(_:zelf:))
      self.add(py, type: type, name: "__dict__", property: __dict__, doc: nil)
    }

    // 'NameError' does not add any interesting methods to 'Exception'.
    internal static let nameErrorStaticMethods = Py.ErrorTypes.exceptionStaticMethods.copy()

    // MARK: - UnboundLocalError

    private func fillUnboundLocalError(_ py: Py) {
      let type = self.unboundLocalError
      type.setBuiltinTypeDoc(py, value: PyUnboundLocalError.doc)

      let __new__ = FunctionWrapper(type: type, fn: PyUnboundLocalError.__new__(_:type:args:kwargs:))
      self.add(py, type: type, name: "__new__", staticMethod: __new__, doc: nil)
      let __init__ = FunctionWrapper(type: type, fn: PyUnboundLocalError.__init__(_:zelf:args:kwargs:))
      self.add(py, type: type, name: "__init__", method: __init__, doc: nil)

      let __class__ = FunctionWrapper(name: "__get__", fn: PyUnboundLocalError.__class__(_:zelf:))
      self.add(py, type: type, name: "__class__", property: __class__, doc: nil)
      let __dict__ = FunctionWrapper(name: "__get__", fn: PyUnboundLocalError.__dict__(_:zelf:))
      self.add(py, type: type, name: "__dict__", property: __dict__, doc: nil)
    }

    // 'UnboundLocalError' does not add any interesting methods to 'NameError'.
    internal static let unboundLocalErrorStaticMethods = Py.ErrorTypes.nameErrorStaticMethods.copy()

    // MARK: - OSError

    private func fillOSError(_ py: Py) {
      let type = self.osError
      type.setBuiltinTypeDoc(py, value: PyOSError.doc)

      let __new__ = FunctionWrapper(type: type, fn: PyOSError.__new__(_:type:args:kwargs:))
      self.add(py, type: type, name: "__new__", staticMethod: __new__, doc: nil)
      let __init__ = FunctionWrapper(type: type, fn: PyOSError.__init__(_:zelf:args:kwargs:))
      self.add(py, type: type, name: "__init__", method: __init__, doc: nil)

      let __class__ = FunctionWrapper(name: "__get__", fn: PyOSError.__class__(_:zelf:))
      self.add(py, type: type, name: "__class__", property: __class__, doc: nil)
      let __dict__ = FunctionWrapper(name: "__get__", fn: PyOSError.__dict__(_:zelf:))
      self.add(py, type: type, name: "__dict__", property: __dict__, doc: nil)
    }

    // 'OSError' does not add any interesting methods to 'Exception'.
    internal static let oSErrorStaticMethods = Py.ErrorTypes.exceptionStaticMethods.copy()

    // MARK: - BlockingIOError

    private func fillBlockingIOError(_ py: Py) {
      let type = self.blockingIOError
      type.setBuiltinTypeDoc(py, value: PyBlockingIOError.doc)

      let __new__ = FunctionWrapper(type: type, fn: PyBlockingIOError.__new__(_:type:args:kwargs:))
      self.add(py, type: type, name: "__new__", staticMethod: __new__, doc: nil)
      let __init__ = FunctionWrapper(type: type, fn: PyBlockingIOError.__init__(_:zelf:args:kwargs:))
      self.add(py, type: type, name: "__init__", method: __init__, doc: nil)

      let __class__ = FunctionWrapper(name: "__get__", fn: PyBlockingIOError.__class__(_:zelf:))
      self.add(py, type: type, name: "__class__", property: __class__, doc: nil)
      let __dict__ = FunctionWrapper(name: "__get__", fn: PyBlockingIOError.__dict__(_:zelf:))
      self.add(py, type: type, name: "__dict__", property: __dict__, doc: nil)
    }

    // 'BlockingIOError' does not add any interesting methods to 'OSError'.
    internal static let blockingIOErrorStaticMethods = Py.ErrorTypes.oSErrorStaticMethods.copy()

    // MARK: - ChildProcessError

    private func fillChildProcessError(_ py: Py) {
      let type = self.childProcessError
      type.setBuiltinTypeDoc(py, value: PyChildProcessError.doc)

      let __new__ = FunctionWrapper(type: type, fn: PyChildProcessError.__new__(_:type:args:kwargs:))
      self.add(py, type: type, name: "__new__", staticMethod: __new__, doc: nil)
      let __init__ = FunctionWrapper(type: type, fn: PyChildProcessError.__init__(_:zelf:args:kwargs:))
      self.add(py, type: type, name: "__init__", method: __init__, doc: nil)

      let __class__ = FunctionWrapper(name: "__get__", fn: PyChildProcessError.__class__(_:zelf:))
      self.add(py, type: type, name: "__class__", property: __class__, doc: nil)
      let __dict__ = FunctionWrapper(name: "__get__", fn: PyChildProcessError.__dict__(_:zelf:))
      self.add(py, type: type, name: "__dict__", property: __dict__, doc: nil)
    }

    // 'ChildProcessError' does not add any interesting methods to 'OSError'.
    internal static let childProcessErrorStaticMethods = Py.ErrorTypes.oSErrorStaticMethods.copy()

    // MARK: - ConnectionError

    private func fillConnectionError(_ py: Py) {
      let type = self.connectionError
      type.setBuiltinTypeDoc(py, value: PyConnectionError.doc)

      let __new__ = FunctionWrapper(type: type, fn: PyConnectionError.__new__(_:type:args:kwargs:))
      self.add(py, type: type, name: "__new__", staticMethod: __new__, doc: nil)
      let __init__ = FunctionWrapper(type: type, fn: PyConnectionError.__init__(_:zelf:args:kwargs:))
      self.add(py, type: type, name: "__init__", method: __init__, doc: nil)

      let __class__ = FunctionWrapper(name: "__get__", fn: PyConnectionError.__class__(_:zelf:))
      self.add(py, type: type, name: "__class__", property: __class__, doc: nil)
      let __dict__ = FunctionWrapper(name: "__get__", fn: PyConnectionError.__dict__(_:zelf:))
      self.add(py, type: type, name: "__dict__", property: __dict__, doc: nil)
    }

    // 'ConnectionError' does not add any interesting methods to 'OSError'.
    internal static let connectionErrorStaticMethods = Py.ErrorTypes.oSErrorStaticMethods.copy()

    // MARK: - BrokenPipeError

    private func fillBrokenPipeError(_ py: Py) {
      let type = self.brokenPipeError
      type.setBuiltinTypeDoc(py, value: PyBrokenPipeError.doc)

      let __new__ = FunctionWrapper(type: type, fn: PyBrokenPipeError.__new__(_:type:args:kwargs:))
      self.add(py, type: type, name: "__new__", staticMethod: __new__, doc: nil)
      let __init__ = FunctionWrapper(type: type, fn: PyBrokenPipeError.__init__(_:zelf:args:kwargs:))
      self.add(py, type: type, name: "__init__", method: __init__, doc: nil)

      let __class__ = FunctionWrapper(name: "__get__", fn: PyBrokenPipeError.__class__(_:zelf:))
      self.add(py, type: type, name: "__class__", property: __class__, doc: nil)
      let __dict__ = FunctionWrapper(name: "__get__", fn: PyBrokenPipeError.__dict__(_:zelf:))
      self.add(py, type: type, name: "__dict__", property: __dict__, doc: nil)
    }

    // 'BrokenPipeError' does not add any interesting methods to 'ConnectionError'.
    internal static let brokenPipeErrorStaticMethods = Py.ErrorTypes.connectionErrorStaticMethods.copy()

    // MARK: - ConnectionAbortedError

    private func fillConnectionAbortedError(_ py: Py) {
      let type = self.connectionAbortedError
      type.setBuiltinTypeDoc(py, value: PyConnectionAbortedError.doc)

      let __new__ = FunctionWrapper(type: type, fn: PyConnectionAbortedError.__new__(_:type:args:kwargs:))
      self.add(py, type: type, name: "__new__", staticMethod: __new__, doc: nil)
      let __init__ = FunctionWrapper(type: type, fn: PyConnectionAbortedError.__init__(_:zelf:args:kwargs:))
      self.add(py, type: type, name: "__init__", method: __init__, doc: nil)

      let __class__ = FunctionWrapper(name: "__get__", fn: PyConnectionAbortedError.__class__(_:zelf:))
      self.add(py, type: type, name: "__class__", property: __class__, doc: nil)
      let __dict__ = FunctionWrapper(name: "__get__", fn: PyConnectionAbortedError.__dict__(_:zelf:))
      self.add(py, type: type, name: "__dict__", property: __dict__, doc: nil)
    }

    // 'ConnectionAbortedError' does not add any interesting methods to 'ConnectionError'.
    internal static let connectionAbortedErrorStaticMethods = Py.ErrorTypes.connectionErrorStaticMethods.copy()

    // MARK: - ConnectionRefusedError

    private func fillConnectionRefusedError(_ py: Py) {
      let type = self.connectionRefusedError
      type.setBuiltinTypeDoc(py, value: PyConnectionRefusedError.doc)

      let __new__ = FunctionWrapper(type: type, fn: PyConnectionRefusedError.__new__(_:type:args:kwargs:))
      self.add(py, type: type, name: "__new__", staticMethod: __new__, doc: nil)
      let __init__ = FunctionWrapper(type: type, fn: PyConnectionRefusedError.__init__(_:zelf:args:kwargs:))
      self.add(py, type: type, name: "__init__", method: __init__, doc: nil)

      let __class__ = FunctionWrapper(name: "__get__", fn: PyConnectionRefusedError.__class__(_:zelf:))
      self.add(py, type: type, name: "__class__", property: __class__, doc: nil)
      let __dict__ = FunctionWrapper(name: "__get__", fn: PyConnectionRefusedError.__dict__(_:zelf:))
      self.add(py, type: type, name: "__dict__", property: __dict__, doc: nil)
    }

    // 'ConnectionRefusedError' does not add any interesting methods to 'ConnectionError'.
    internal static let connectionRefusedErrorStaticMethods = Py.ErrorTypes.connectionErrorStaticMethods.copy()

    // MARK: - ConnectionResetError

    private func fillConnectionResetError(_ py: Py) {
      let type = self.connectionResetError
      type.setBuiltinTypeDoc(py, value: PyConnectionResetError.doc)

      let __new__ = FunctionWrapper(type: type, fn: PyConnectionResetError.__new__(_:type:args:kwargs:))
      self.add(py, type: type, name: "__new__", staticMethod: __new__, doc: nil)
      let __init__ = FunctionWrapper(type: type, fn: PyConnectionResetError.__init__(_:zelf:args:kwargs:))
      self.add(py, type: type, name: "__init__", method: __init__, doc: nil)

      let __class__ = FunctionWrapper(name: "__get__", fn: PyConnectionResetError.__class__(_:zelf:))
      self.add(py, type: type, name: "__class__", property: __class__, doc: nil)
      let __dict__ = FunctionWrapper(name: "__get__", fn: PyConnectionResetError.__dict__(_:zelf:))
      self.add(py, type: type, name: "__dict__", property: __dict__, doc: nil)
    }

    // 'ConnectionResetError' does not add any interesting methods to 'ConnectionError'.
    internal static let connectionResetErrorStaticMethods = Py.ErrorTypes.connectionErrorStaticMethods.copy()

    // MARK: - FileExistsError

    private func fillFileExistsError(_ py: Py) {
      let type = self.fileExistsError
      type.setBuiltinTypeDoc(py, value: PyFileExistsError.doc)

      let __new__ = FunctionWrapper(type: type, fn: PyFileExistsError.__new__(_:type:args:kwargs:))
      self.add(py, type: type, name: "__new__", staticMethod: __new__, doc: nil)
      let __init__ = FunctionWrapper(type: type, fn: PyFileExistsError.__init__(_:zelf:args:kwargs:))
      self.add(py, type: type, name: "__init__", method: __init__, doc: nil)

      let __class__ = FunctionWrapper(name: "__get__", fn: PyFileExistsError.__class__(_:zelf:))
      self.add(py, type: type, name: "__class__", property: __class__, doc: nil)
      let __dict__ = FunctionWrapper(name: "__get__", fn: PyFileExistsError.__dict__(_:zelf:))
      self.add(py, type: type, name: "__dict__", property: __dict__, doc: nil)
    }

    // 'FileExistsError' does not add any interesting methods to 'OSError'.
    internal static let fileExistsErrorStaticMethods = Py.ErrorTypes.oSErrorStaticMethods.copy()

    // MARK: - FileNotFoundError

    private func fillFileNotFoundError(_ py: Py) {
      let type = self.fileNotFoundError
      type.setBuiltinTypeDoc(py, value: PyFileNotFoundError.doc)

      let __new__ = FunctionWrapper(type: type, fn: PyFileNotFoundError.__new__(_:type:args:kwargs:))
      self.add(py, type: type, name: "__new__", staticMethod: __new__, doc: nil)
      let __init__ = FunctionWrapper(type: type, fn: PyFileNotFoundError.__init__(_:zelf:args:kwargs:))
      self.add(py, type: type, name: "__init__", method: __init__, doc: nil)

      let __class__ = FunctionWrapper(name: "__get__", fn: PyFileNotFoundError.__class__(_:zelf:))
      self.add(py, type: type, name: "__class__", property: __class__, doc: nil)
      let __dict__ = FunctionWrapper(name: "__get__", fn: PyFileNotFoundError.__dict__(_:zelf:))
      self.add(py, type: type, name: "__dict__", property: __dict__, doc: nil)
    }

    // 'FileNotFoundError' does not add any interesting methods to 'OSError'.
    internal static let fileNotFoundErrorStaticMethods = Py.ErrorTypes.oSErrorStaticMethods.copy()

    // MARK: - InterruptedError

    private func fillInterruptedError(_ py: Py) {
      let type = self.interruptedError
      type.setBuiltinTypeDoc(py, value: PyInterruptedError.doc)

      let __new__ = FunctionWrapper(type: type, fn: PyInterruptedError.__new__(_:type:args:kwargs:))
      self.add(py, type: type, name: "__new__", staticMethod: __new__, doc: nil)
      let __init__ = FunctionWrapper(type: type, fn: PyInterruptedError.__init__(_:zelf:args:kwargs:))
      self.add(py, type: type, name: "__init__", method: __init__, doc: nil)

      let __class__ = FunctionWrapper(name: "__get__", fn: PyInterruptedError.__class__(_:zelf:))
      self.add(py, type: type, name: "__class__", property: __class__, doc: nil)
      let __dict__ = FunctionWrapper(name: "__get__", fn: PyInterruptedError.__dict__(_:zelf:))
      self.add(py, type: type, name: "__dict__", property: __dict__, doc: nil)
    }

    // 'InterruptedError' does not add any interesting methods to 'OSError'.
    internal static let interruptedErrorStaticMethods = Py.ErrorTypes.oSErrorStaticMethods.copy()

    // MARK: - IsADirectoryError

    private func fillIsADirectoryError(_ py: Py) {
      let type = self.isADirectoryError
      type.setBuiltinTypeDoc(py, value: PyIsADirectoryError.doc)

      let __new__ = FunctionWrapper(type: type, fn: PyIsADirectoryError.__new__(_:type:args:kwargs:))
      self.add(py, type: type, name: "__new__", staticMethod: __new__, doc: nil)
      let __init__ = FunctionWrapper(type: type, fn: PyIsADirectoryError.__init__(_:zelf:args:kwargs:))
      self.add(py, type: type, name: "__init__", method: __init__, doc: nil)

      let __class__ = FunctionWrapper(name: "__get__", fn: PyIsADirectoryError.__class__(_:zelf:))
      self.add(py, type: type, name: "__class__", property: __class__, doc: nil)
      let __dict__ = FunctionWrapper(name: "__get__", fn: PyIsADirectoryError.__dict__(_:zelf:))
      self.add(py, type: type, name: "__dict__", property: __dict__, doc: nil)
    }

    // 'IsADirectoryError' does not add any interesting methods to 'OSError'.
    internal static let isADirectoryErrorStaticMethods = Py.ErrorTypes.oSErrorStaticMethods.copy()

    // MARK: - NotADirectoryError

    private func fillNotADirectoryError(_ py: Py) {
      let type = self.notADirectoryError
      type.setBuiltinTypeDoc(py, value: PyNotADirectoryError.doc)

      let __new__ = FunctionWrapper(type: type, fn: PyNotADirectoryError.__new__(_:type:args:kwargs:))
      self.add(py, type: type, name: "__new__", staticMethod: __new__, doc: nil)
      let __init__ = FunctionWrapper(type: type, fn: PyNotADirectoryError.__init__(_:zelf:args:kwargs:))
      self.add(py, type: type, name: "__init__", method: __init__, doc: nil)

      let __class__ = FunctionWrapper(name: "__get__", fn: PyNotADirectoryError.__class__(_:zelf:))
      self.add(py, type: type, name: "__class__", property: __class__, doc: nil)
      let __dict__ = FunctionWrapper(name: "__get__", fn: PyNotADirectoryError.__dict__(_:zelf:))
      self.add(py, type: type, name: "__dict__", property: __dict__, doc: nil)
    }

    // 'NotADirectoryError' does not add any interesting methods to 'OSError'.
    internal static let notADirectoryErrorStaticMethods = Py.ErrorTypes.oSErrorStaticMethods.copy()

    // MARK: - PermissionError

    private func fillPermissionError(_ py: Py) {
      let type = self.permissionError
      type.setBuiltinTypeDoc(py, value: PyPermissionError.doc)

      let __new__ = FunctionWrapper(type: type, fn: PyPermissionError.__new__(_:type:args:kwargs:))
      self.add(py, type: type, name: "__new__", staticMethod: __new__, doc: nil)
      let __init__ = FunctionWrapper(type: type, fn: PyPermissionError.__init__(_:zelf:args:kwargs:))
      self.add(py, type: type, name: "__init__", method: __init__, doc: nil)

      let __class__ = FunctionWrapper(name: "__get__", fn: PyPermissionError.__class__(_:zelf:))
      self.add(py, type: type, name: "__class__", property: __class__, doc: nil)
      let __dict__ = FunctionWrapper(name: "__get__", fn: PyPermissionError.__dict__(_:zelf:))
      self.add(py, type: type, name: "__dict__", property: __dict__, doc: nil)
    }

    // 'PermissionError' does not add any interesting methods to 'OSError'.
    internal static let permissionErrorStaticMethods = Py.ErrorTypes.oSErrorStaticMethods.copy()

    // MARK: - ProcessLookupError

    private func fillProcessLookupError(_ py: Py) {
      let type = self.processLookupError
      type.setBuiltinTypeDoc(py, value: PyProcessLookupError.doc)

      let __new__ = FunctionWrapper(type: type, fn: PyProcessLookupError.__new__(_:type:args:kwargs:))
      self.add(py, type: type, name: "__new__", staticMethod: __new__, doc: nil)
      let __init__ = FunctionWrapper(type: type, fn: PyProcessLookupError.__init__(_:zelf:args:kwargs:))
      self.add(py, type: type, name: "__init__", method: __init__, doc: nil)

      let __class__ = FunctionWrapper(name: "__get__", fn: PyProcessLookupError.__class__(_:zelf:))
      self.add(py, type: type, name: "__class__", property: __class__, doc: nil)
      let __dict__ = FunctionWrapper(name: "__get__", fn: PyProcessLookupError.__dict__(_:zelf:))
      self.add(py, type: type, name: "__dict__", property: __dict__, doc: nil)
    }

    // 'ProcessLookupError' does not add any interesting methods to 'OSError'.
    internal static let processLookupErrorStaticMethods = Py.ErrorTypes.oSErrorStaticMethods.copy()

    // MARK: - TimeoutError

    private func fillTimeoutError(_ py: Py) {
      let type = self.timeoutError
      type.setBuiltinTypeDoc(py, value: PyTimeoutError.doc)

      let __new__ = FunctionWrapper(type: type, fn: PyTimeoutError.__new__(_:type:args:kwargs:))
      self.add(py, type: type, name: "__new__", staticMethod: __new__, doc: nil)
      let __init__ = FunctionWrapper(type: type, fn: PyTimeoutError.__init__(_:zelf:args:kwargs:))
      self.add(py, type: type, name: "__init__", method: __init__, doc: nil)

      let __class__ = FunctionWrapper(name: "__get__", fn: PyTimeoutError.__class__(_:zelf:))
      self.add(py, type: type, name: "__class__", property: __class__, doc: nil)
      let __dict__ = FunctionWrapper(name: "__get__", fn: PyTimeoutError.__dict__(_:zelf:))
      self.add(py, type: type, name: "__dict__", property: __dict__, doc: nil)
    }

    // 'TimeoutError' does not add any interesting methods to 'OSError'.
    internal static let timeoutErrorStaticMethods = Py.ErrorTypes.oSErrorStaticMethods.copy()

    // MARK: - ReferenceError

    private func fillReferenceError(_ py: Py) {
      let type = self.referenceError
      type.setBuiltinTypeDoc(py, value: PyReferenceError.doc)

      let __new__ = FunctionWrapper(type: type, fn: PyReferenceError.__new__(_:type:args:kwargs:))
      self.add(py, type: type, name: "__new__", staticMethod: __new__, doc: nil)
      let __init__ = FunctionWrapper(type: type, fn: PyReferenceError.__init__(_:zelf:args:kwargs:))
      self.add(py, type: type, name: "__init__", method: __init__, doc: nil)

      let __class__ = FunctionWrapper(name: "__get__", fn: PyReferenceError.__class__(_:zelf:))
      self.add(py, type: type, name: "__class__", property: __class__, doc: nil)
      let __dict__ = FunctionWrapper(name: "__get__", fn: PyReferenceError.__dict__(_:zelf:))
      self.add(py, type: type, name: "__dict__", property: __dict__, doc: nil)
    }

    // 'ReferenceError' does not add any interesting methods to 'Exception'.
    internal static let referenceErrorStaticMethods = Py.ErrorTypes.exceptionStaticMethods.copy()

    // MARK: - RuntimeError

    private func fillRuntimeError(_ py: Py) {
      let type = self.runtimeError
      type.setBuiltinTypeDoc(py, value: PyRuntimeError.doc)

      let __new__ = FunctionWrapper(type: type, fn: PyRuntimeError.__new__(_:type:args:kwargs:))
      self.add(py, type: type, name: "__new__", staticMethod: __new__, doc: nil)
      let __init__ = FunctionWrapper(type: type, fn: PyRuntimeError.__init__(_:zelf:args:kwargs:))
      self.add(py, type: type, name: "__init__", method: __init__, doc: nil)

      let __class__ = FunctionWrapper(name: "__get__", fn: PyRuntimeError.__class__(_:zelf:))
      self.add(py, type: type, name: "__class__", property: __class__, doc: nil)
      let __dict__ = FunctionWrapper(name: "__get__", fn: PyRuntimeError.__dict__(_:zelf:))
      self.add(py, type: type, name: "__dict__", property: __dict__, doc: nil)
    }

    // 'RuntimeError' does not add any interesting methods to 'Exception'.
    internal static let runtimeErrorStaticMethods = Py.ErrorTypes.exceptionStaticMethods.copy()

    // MARK: - NotImplementedError

    private func fillNotImplementedError(_ py: Py) {
      let type = self.notImplementedError
      type.setBuiltinTypeDoc(py, value: PyNotImplementedError.doc)

      let __new__ = FunctionWrapper(type: type, fn: PyNotImplementedError.__new__(_:type:args:kwargs:))
      self.add(py, type: type, name: "__new__", staticMethod: __new__, doc: nil)
      let __init__ = FunctionWrapper(type: type, fn: PyNotImplementedError.__init__(_:zelf:args:kwargs:))
      self.add(py, type: type, name: "__init__", method: __init__, doc: nil)

      let __class__ = FunctionWrapper(name: "__get__", fn: PyNotImplementedError.__class__(_:zelf:))
      self.add(py, type: type, name: "__class__", property: __class__, doc: nil)
      let __dict__ = FunctionWrapper(name: "__get__", fn: PyNotImplementedError.__dict__(_:zelf:))
      self.add(py, type: type, name: "__dict__", property: __dict__, doc: nil)
    }

    // 'NotImplementedError' does not add any interesting methods to 'RuntimeError'.
    internal static let notImplementedErrorStaticMethods = Py.ErrorTypes.runtimeErrorStaticMethods.copy()

    // MARK: - RecursionError

    private func fillRecursionError(_ py: Py) {
      let type = self.recursionError
      type.setBuiltinTypeDoc(py, value: PyRecursionError.doc)

      let __new__ = FunctionWrapper(type: type, fn: PyRecursionError.__new__(_:type:args:kwargs:))
      self.add(py, type: type, name: "__new__", staticMethod: __new__, doc: nil)
      let __init__ = FunctionWrapper(type: type, fn: PyRecursionError.__init__(_:zelf:args:kwargs:))
      self.add(py, type: type, name: "__init__", method: __init__, doc: nil)

      let __class__ = FunctionWrapper(name: "__get__", fn: PyRecursionError.__class__(_:zelf:))
      self.add(py, type: type, name: "__class__", property: __class__, doc: nil)
      let __dict__ = FunctionWrapper(name: "__get__", fn: PyRecursionError.__dict__(_:zelf:))
      self.add(py, type: type, name: "__dict__", property: __dict__, doc: nil)
    }

    // 'RecursionError' does not add any interesting methods to 'RuntimeError'.
    internal static let recursionErrorStaticMethods = Py.ErrorTypes.runtimeErrorStaticMethods.copy()

    // MARK: - SyntaxError

    private func fillSyntaxError(_ py: Py) {
      let type = self.syntaxError
      type.setBuiltinTypeDoc(py, value: PySyntaxError.syntaxErrorDoc)

      let __new__ = FunctionWrapper(type: type, fn: PySyntaxError.__new__(_:type:args:kwargs:))
      self.add(py, type: type, name: "__new__", staticMethod: __new__, doc: nil)
      let __init__ = FunctionWrapper(type: type, fn: PySyntaxError.__init__(_:zelf:args:kwargs:))
      self.add(py, type: type, name: "__init__", method: __init__, doc: nil)

      let __class__ = FunctionWrapper(name: "__get__", fn: PySyntaxError.__class__(_:zelf:))
      self.add(py, type: type, name: "__class__", property: __class__, doc: nil)
      let __dict__ = FunctionWrapper(name: "__get__", fn: PySyntaxError.__dict__(_:zelf:))
      self.add(py, type: type, name: "__dict__", property: __dict__, doc: nil)
      let msgGet = FunctionWrapper(name: "__get__", fn: PySyntaxError.msg(_:zelf:))
      let msgSet = FunctionWrapper(name: "__set__", fn: PySyntaxError.msg(_:zelf:value:))
      self.add(py, type: type, name: "msg", property: msgGet, setter: msgSet, doc: nil)
      let filenameGet = FunctionWrapper(name: "__get__", fn: PySyntaxError.filename(_:zelf:))
      let filenameSet = FunctionWrapper(name: "__set__", fn: PySyntaxError.filename(_:zelf:value:))
      self.add(py, type: type, name: "filename", property: filenameGet, setter: filenameSet, doc: nil)
      let linenoGet = FunctionWrapper(name: "__get__", fn: PySyntaxError.lineno(_:zelf:))
      let linenoSet = FunctionWrapper(name: "__set__", fn: PySyntaxError.lineno(_:zelf:value:))
      self.add(py, type: type, name: "lineno", property: linenoGet, setter: linenoSet, doc: nil)
      let offsetGet = FunctionWrapper(name: "__get__", fn: PySyntaxError.offset(_:zelf:))
      let offsetSet = FunctionWrapper(name: "__set__", fn: PySyntaxError.offset(_:zelf:value:))
      self.add(py, type: type, name: "offset", property: offsetGet, setter: offsetSet, doc: nil)
      let textGet = FunctionWrapper(name: "__get__", fn: PySyntaxError.text(_:zelf:))
      let textSet = FunctionWrapper(name: "__set__", fn: PySyntaxError.text(_:zelf:value:))
      self.add(py, type: type, name: "text", property: textGet, setter: textSet, doc: nil)
      let print_file_and_lineGet = FunctionWrapper(name: "__get__", fn: PySyntaxError.print_file_and_line(_:zelf:))
      let print_file_and_lineSet = FunctionWrapper(name: "__set__", fn: PySyntaxError.print_file_and_line(_:zelf:value:))
      self.add(py, type: type, name: "print_file_and_line", property: print_file_and_lineGet, setter: print_file_and_lineSet, doc: nil)

      let __str__ = FunctionWrapper(name: "__str__", fn: PySyntaxError.__str__(_:zelf:))
      self.add(py, type: type, name: "__str__", method: __str__, doc: nil)
    }

    internal static var syntaxErrorStaticMethods: PyStaticCall.KnownNotOverriddenMethods = {
      var result = Py.ErrorTypes.exceptionStaticMethods.copy()
      result.__str__ = .init(PySyntaxError.__str__(_:zelf:))
      return result
    }()

    // MARK: - IndentationError

    private func fillIndentationError(_ py: Py) {
      let type = self.indentationError
      type.setBuiltinTypeDoc(py, value: PyIndentationError.doc)

      let __new__ = FunctionWrapper(type: type, fn: PyIndentationError.__new__(_:type:args:kwargs:))
      self.add(py, type: type, name: "__new__", staticMethod: __new__, doc: nil)
      let __init__ = FunctionWrapper(type: type, fn: PyIndentationError.__init__(_:zelf:args:kwargs:))
      self.add(py, type: type, name: "__init__", method: __init__, doc: nil)

      let __class__ = FunctionWrapper(name: "__get__", fn: PyIndentationError.__class__(_:zelf:))
      self.add(py, type: type, name: "__class__", property: __class__, doc: nil)
      let __dict__ = FunctionWrapper(name: "__get__", fn: PyIndentationError.__dict__(_:zelf:))
      self.add(py, type: type, name: "__dict__", property: __dict__, doc: nil)
    }

    // 'IndentationError' does not add any interesting methods to 'SyntaxError'.
    internal static let indentationErrorStaticMethods = Py.ErrorTypes.syntaxErrorStaticMethods.copy()

    // MARK: - TabError

    private func fillTabError(_ py: Py) {
      let type = self.tabError
      type.setBuiltinTypeDoc(py, value: PyTabError.doc)

      let __new__ = FunctionWrapper(type: type, fn: PyTabError.__new__(_:type:args:kwargs:))
      self.add(py, type: type, name: "__new__", staticMethod: __new__, doc: nil)
      let __init__ = FunctionWrapper(type: type, fn: PyTabError.__init__(_:zelf:args:kwargs:))
      self.add(py, type: type, name: "__init__", method: __init__, doc: nil)

      let __class__ = FunctionWrapper(name: "__get__", fn: PyTabError.__class__(_:zelf:))
      self.add(py, type: type, name: "__class__", property: __class__, doc: nil)
      let __dict__ = FunctionWrapper(name: "__get__", fn: PyTabError.__dict__(_:zelf:))
      self.add(py, type: type, name: "__dict__", property: __dict__, doc: nil)
    }

    // 'TabError' does not add any interesting methods to 'IndentationError'.
    internal static let tabErrorStaticMethods = Py.ErrorTypes.indentationErrorStaticMethods.copy()

    // MARK: - SystemError

    private func fillSystemError(_ py: Py) {
      let type = self.systemError
      type.setBuiltinTypeDoc(py, value: PySystemError.doc)

      let __new__ = FunctionWrapper(type: type, fn: PySystemError.__new__(_:type:args:kwargs:))
      self.add(py, type: type, name: "__new__", staticMethod: __new__, doc: nil)
      let __init__ = FunctionWrapper(type: type, fn: PySystemError.__init__(_:zelf:args:kwargs:))
      self.add(py, type: type, name: "__init__", method: __init__, doc: nil)

      let __class__ = FunctionWrapper(name: "__get__", fn: PySystemError.__class__(_:zelf:))
      self.add(py, type: type, name: "__class__", property: __class__, doc: nil)
      let __dict__ = FunctionWrapper(name: "__get__", fn: PySystemError.__dict__(_:zelf:))
      self.add(py, type: type, name: "__dict__", property: __dict__, doc: nil)
    }

    // 'SystemError' does not add any interesting methods to 'Exception'.
    internal static let systemErrorStaticMethods = Py.ErrorTypes.exceptionStaticMethods.copy()

    // MARK: - TypeError

    private func fillTypeError(_ py: Py) {
      let type = self.typeError
      type.setBuiltinTypeDoc(py, value: PyTypeError.doc)

      let __new__ = FunctionWrapper(type: type, fn: PyTypeError.__new__(_:type:args:kwargs:))
      self.add(py, type: type, name: "__new__", staticMethod: __new__, doc: nil)
      let __init__ = FunctionWrapper(type: type, fn: PyTypeError.__init__(_:zelf:args:kwargs:))
      self.add(py, type: type, name: "__init__", method: __init__, doc: nil)

      let __class__ = FunctionWrapper(name: "__get__", fn: PyTypeError.__class__(_:zelf:))
      self.add(py, type: type, name: "__class__", property: __class__, doc: nil)
      let __dict__ = FunctionWrapper(name: "__get__", fn: PyTypeError.__dict__(_:zelf:))
      self.add(py, type: type, name: "__dict__", property: __dict__, doc: nil)
    }

    // 'TypeError' does not add any interesting methods to 'Exception'.
    internal static let typeErrorStaticMethods = Py.ErrorTypes.exceptionStaticMethods.copy()

    // MARK: - ValueError

    private func fillValueError(_ py: Py) {
      let type = self.valueError
      type.setBuiltinTypeDoc(py, value: PyValueError.doc)

      let __new__ = FunctionWrapper(type: type, fn: PyValueError.__new__(_:type:args:kwargs:))
      self.add(py, type: type, name: "__new__", staticMethod: __new__, doc: nil)
      let __init__ = FunctionWrapper(type: type, fn: PyValueError.__init__(_:zelf:args:kwargs:))
      self.add(py, type: type, name: "__init__", method: __init__, doc: nil)

      let __class__ = FunctionWrapper(name: "__get__", fn: PyValueError.__class__(_:zelf:))
      self.add(py, type: type, name: "__class__", property: __class__, doc: nil)
      let __dict__ = FunctionWrapper(name: "__get__", fn: PyValueError.__dict__(_:zelf:))
      self.add(py, type: type, name: "__dict__", property: __dict__, doc: nil)
    }

    // 'ValueError' does not add any interesting methods to 'Exception'.
    internal static let valueErrorStaticMethods = Py.ErrorTypes.exceptionStaticMethods.copy()

    // MARK: - UnicodeError

    private func fillUnicodeError(_ py: Py) {
      let type = self.unicodeError
      type.setBuiltinTypeDoc(py, value: PyUnicodeError.doc)

      let __new__ = FunctionWrapper(type: type, fn: PyUnicodeError.__new__(_:type:args:kwargs:))
      self.add(py, type: type, name: "__new__", staticMethod: __new__, doc: nil)
      let __init__ = FunctionWrapper(type: type, fn: PyUnicodeError.__init__(_:zelf:args:kwargs:))
      self.add(py, type: type, name: "__init__", method: __init__, doc: nil)

      let __class__ = FunctionWrapper(name: "__get__", fn: PyUnicodeError.__class__(_:zelf:))
      self.add(py, type: type, name: "__class__", property: __class__, doc: nil)
      let __dict__ = FunctionWrapper(name: "__get__", fn: PyUnicodeError.__dict__(_:zelf:))
      self.add(py, type: type, name: "__dict__", property: __dict__, doc: nil)
    }

    // 'UnicodeError' does not add any interesting methods to 'ValueError'.
    internal static let unicodeErrorStaticMethods = Py.ErrorTypes.valueErrorStaticMethods.copy()

    // MARK: - UnicodeDecodeError

    private func fillUnicodeDecodeError(_ py: Py) {
      let type = self.unicodeDecodeError
      type.setBuiltinTypeDoc(py, value: PyUnicodeDecodeError.doc)

      let __new__ = FunctionWrapper(type: type, fn: PyUnicodeDecodeError.__new__(_:type:args:kwargs:))
      self.add(py, type: type, name: "__new__", staticMethod: __new__, doc: nil)
      let __init__ = FunctionWrapper(type: type, fn: PyUnicodeDecodeError.__init__(_:zelf:args:kwargs:))
      self.add(py, type: type, name: "__init__", method: __init__, doc: nil)

      let __class__ = FunctionWrapper(name: "__get__", fn: PyUnicodeDecodeError.__class__(_:zelf:))
      self.add(py, type: type, name: "__class__", property: __class__, doc: nil)
      let __dict__ = FunctionWrapper(name: "__get__", fn: PyUnicodeDecodeError.__dict__(_:zelf:))
      self.add(py, type: type, name: "__dict__", property: __dict__, doc: nil)
    }

    // 'UnicodeDecodeError' does not add any interesting methods to 'UnicodeError'.
    internal static let unicodeDecodeErrorStaticMethods = Py.ErrorTypes.unicodeErrorStaticMethods.copy()

    // MARK: - UnicodeEncodeError

    private func fillUnicodeEncodeError(_ py: Py) {
      let type = self.unicodeEncodeError
      type.setBuiltinTypeDoc(py, value: PyUnicodeEncodeError.doc)

      let __new__ = FunctionWrapper(type: type, fn: PyUnicodeEncodeError.__new__(_:type:args:kwargs:))
      self.add(py, type: type, name: "__new__", staticMethod: __new__, doc: nil)
      let __init__ = FunctionWrapper(type: type, fn: PyUnicodeEncodeError.__init__(_:zelf:args:kwargs:))
      self.add(py, type: type, name: "__init__", method: __init__, doc: nil)

      let __class__ = FunctionWrapper(name: "__get__", fn: PyUnicodeEncodeError.__class__(_:zelf:))
      self.add(py, type: type, name: "__class__", property: __class__, doc: nil)
      let __dict__ = FunctionWrapper(name: "__get__", fn: PyUnicodeEncodeError.__dict__(_:zelf:))
      self.add(py, type: type, name: "__dict__", property: __dict__, doc: nil)
    }

    // 'UnicodeEncodeError' does not add any interesting methods to 'UnicodeError'.
    internal static let unicodeEncodeErrorStaticMethods = Py.ErrorTypes.unicodeErrorStaticMethods.copy()

    // MARK: - UnicodeTranslateError

    private func fillUnicodeTranslateError(_ py: Py) {
      let type = self.unicodeTranslateError
      type.setBuiltinTypeDoc(py, value: PyUnicodeTranslateError.doc)

      let __new__ = FunctionWrapper(type: type, fn: PyUnicodeTranslateError.__new__(_:type:args:kwargs:))
      self.add(py, type: type, name: "__new__", staticMethod: __new__, doc: nil)
      let __init__ = FunctionWrapper(type: type, fn: PyUnicodeTranslateError.__init__(_:zelf:args:kwargs:))
      self.add(py, type: type, name: "__init__", method: __init__, doc: nil)

      let __class__ = FunctionWrapper(name: "__get__", fn: PyUnicodeTranslateError.__class__(_:zelf:))
      self.add(py, type: type, name: "__class__", property: __class__, doc: nil)
      let __dict__ = FunctionWrapper(name: "__get__", fn: PyUnicodeTranslateError.__dict__(_:zelf:))
      self.add(py, type: type, name: "__dict__", property: __dict__, doc: nil)
    }

    // 'UnicodeTranslateError' does not add any interesting methods to 'UnicodeError'.
    internal static let unicodeTranslateErrorStaticMethods = Py.ErrorTypes.unicodeErrorStaticMethods.copy()

    // MARK: - Warning

    private func fillWarning(_ py: Py) {
      let type = self.warning
      type.setBuiltinTypeDoc(py, value: PyWarning.doc)

      let __new__ = FunctionWrapper(type: type, fn: PyWarning.__new__(_:type:args:kwargs:))
      self.add(py, type: type, name: "__new__", staticMethod: __new__, doc: nil)
      let __init__ = FunctionWrapper(type: type, fn: PyWarning.__init__(_:zelf:args:kwargs:))
      self.add(py, type: type, name: "__init__", method: __init__, doc: nil)

      let __class__ = FunctionWrapper(name: "__get__", fn: PyWarning.__class__(_:zelf:))
      self.add(py, type: type, name: "__class__", property: __class__, doc: nil)
      let __dict__ = FunctionWrapper(name: "__get__", fn: PyWarning.__dict__(_:zelf:))
      self.add(py, type: type, name: "__dict__", property: __dict__, doc: nil)
    }

    // 'Warning' does not add any interesting methods to 'Exception'.
    internal static let warningStaticMethods = Py.ErrorTypes.exceptionStaticMethods.copy()

    // MARK: - DeprecationWarning

    private func fillDeprecationWarning(_ py: Py) {
      let type = self.deprecationWarning
      type.setBuiltinTypeDoc(py, value: PyDeprecationWarning.doc)

      let __new__ = FunctionWrapper(type: type, fn: PyDeprecationWarning.__new__(_:type:args:kwargs:))
      self.add(py, type: type, name: "__new__", staticMethod: __new__, doc: nil)
      let __init__ = FunctionWrapper(type: type, fn: PyDeprecationWarning.__init__(_:zelf:args:kwargs:))
      self.add(py, type: type, name: "__init__", method: __init__, doc: nil)

      let __class__ = FunctionWrapper(name: "__get__", fn: PyDeprecationWarning.__class__(_:zelf:))
      self.add(py, type: type, name: "__class__", property: __class__, doc: nil)
      let __dict__ = FunctionWrapper(name: "__get__", fn: PyDeprecationWarning.__dict__(_:zelf:))
      self.add(py, type: type, name: "__dict__", property: __dict__, doc: nil)
    }

    // 'DeprecationWarning' does not add any interesting methods to 'Warning'.
    internal static let deprecationWarningStaticMethods = Py.ErrorTypes.warningStaticMethods.copy()

    // MARK: - PendingDeprecationWarning

    private func fillPendingDeprecationWarning(_ py: Py) {
      let type = self.pendingDeprecationWarning
      type.setBuiltinTypeDoc(py, value: PyPendingDeprecationWarning.doc)

      let __new__ = FunctionWrapper(type: type, fn: PyPendingDeprecationWarning.__new__(_:type:args:kwargs:))
      self.add(py, type: type, name: "__new__", staticMethod: __new__, doc: nil)
      let __init__ = FunctionWrapper(type: type, fn: PyPendingDeprecationWarning.__init__(_:zelf:args:kwargs:))
      self.add(py, type: type, name: "__init__", method: __init__, doc: nil)

      let __class__ = FunctionWrapper(name: "__get__", fn: PyPendingDeprecationWarning.__class__(_:zelf:))
      self.add(py, type: type, name: "__class__", property: __class__, doc: nil)
      let __dict__ = FunctionWrapper(name: "__get__", fn: PyPendingDeprecationWarning.__dict__(_:zelf:))
      self.add(py, type: type, name: "__dict__", property: __dict__, doc: nil)
    }

    // 'PendingDeprecationWarning' does not add any interesting methods to 'Warning'.
    internal static let pendingDeprecationWarningStaticMethods = Py.ErrorTypes.warningStaticMethods.copy()

    // MARK: - RuntimeWarning

    private func fillRuntimeWarning(_ py: Py) {
      let type = self.runtimeWarning
      type.setBuiltinTypeDoc(py, value: PyRuntimeWarning.doc)

      let __new__ = FunctionWrapper(type: type, fn: PyRuntimeWarning.__new__(_:type:args:kwargs:))
      self.add(py, type: type, name: "__new__", staticMethod: __new__, doc: nil)
      let __init__ = FunctionWrapper(type: type, fn: PyRuntimeWarning.__init__(_:zelf:args:kwargs:))
      self.add(py, type: type, name: "__init__", method: __init__, doc: nil)

      let __class__ = FunctionWrapper(name: "__get__", fn: PyRuntimeWarning.__class__(_:zelf:))
      self.add(py, type: type, name: "__class__", property: __class__, doc: nil)
      let __dict__ = FunctionWrapper(name: "__get__", fn: PyRuntimeWarning.__dict__(_:zelf:))
      self.add(py, type: type, name: "__dict__", property: __dict__, doc: nil)
    }

    // 'RuntimeWarning' does not add any interesting methods to 'Warning'.
    internal static let runtimeWarningStaticMethods = Py.ErrorTypes.warningStaticMethods.copy()

    // MARK: - SyntaxWarning

    private func fillSyntaxWarning(_ py: Py) {
      let type = self.syntaxWarning
      type.setBuiltinTypeDoc(py, value: PySyntaxWarning.doc)

      let __new__ = FunctionWrapper(type: type, fn: PySyntaxWarning.__new__(_:type:args:kwargs:))
      self.add(py, type: type, name: "__new__", staticMethod: __new__, doc: nil)
      let __init__ = FunctionWrapper(type: type, fn: PySyntaxWarning.__init__(_:zelf:args:kwargs:))
      self.add(py, type: type, name: "__init__", method: __init__, doc: nil)

      let __class__ = FunctionWrapper(name: "__get__", fn: PySyntaxWarning.__class__(_:zelf:))
      self.add(py, type: type, name: "__class__", property: __class__, doc: nil)
      let __dict__ = FunctionWrapper(name: "__get__", fn: PySyntaxWarning.__dict__(_:zelf:))
      self.add(py, type: type, name: "__dict__", property: __dict__, doc: nil)
    }

    // 'SyntaxWarning' does not add any interesting methods to 'Warning'.
    internal static let syntaxWarningStaticMethods = Py.ErrorTypes.warningStaticMethods.copy()

    // MARK: - UserWarning

    private func fillUserWarning(_ py: Py) {
      let type = self.userWarning
      type.setBuiltinTypeDoc(py, value: PyUserWarning.doc)

      let __new__ = FunctionWrapper(type: type, fn: PyUserWarning.__new__(_:type:args:kwargs:))
      self.add(py, type: type, name: "__new__", staticMethod: __new__, doc: nil)
      let __init__ = FunctionWrapper(type: type, fn: PyUserWarning.__init__(_:zelf:args:kwargs:))
      self.add(py, type: type, name: "__init__", method: __init__, doc: nil)

      let __class__ = FunctionWrapper(name: "__get__", fn: PyUserWarning.__class__(_:zelf:))
      self.add(py, type: type, name: "__class__", property: __class__, doc: nil)
      let __dict__ = FunctionWrapper(name: "__get__", fn: PyUserWarning.__dict__(_:zelf:))
      self.add(py, type: type, name: "__dict__", property: __dict__, doc: nil)
    }

    // 'UserWarning' does not add any interesting methods to 'Warning'.
    internal static let userWarningStaticMethods = Py.ErrorTypes.warningStaticMethods.copy()

    // MARK: - FutureWarning

    private func fillFutureWarning(_ py: Py) {
      let type = self.futureWarning
      type.setBuiltinTypeDoc(py, value: PyFutureWarning.doc)

      let __new__ = FunctionWrapper(type: type, fn: PyFutureWarning.__new__(_:type:args:kwargs:))
      self.add(py, type: type, name: "__new__", staticMethod: __new__, doc: nil)
      let __init__ = FunctionWrapper(type: type, fn: PyFutureWarning.__init__(_:zelf:args:kwargs:))
      self.add(py, type: type, name: "__init__", method: __init__, doc: nil)

      let __class__ = FunctionWrapper(name: "__get__", fn: PyFutureWarning.__class__(_:zelf:))
      self.add(py, type: type, name: "__class__", property: __class__, doc: nil)
      let __dict__ = FunctionWrapper(name: "__get__", fn: PyFutureWarning.__dict__(_:zelf:))
      self.add(py, type: type, name: "__dict__", property: __dict__, doc: nil)
    }

    // 'FutureWarning' does not add any interesting methods to 'Warning'.
    internal static let futureWarningStaticMethods = Py.ErrorTypes.warningStaticMethods.copy()

    // MARK: - ImportWarning

    private func fillImportWarning(_ py: Py) {
      let type = self.importWarning
      type.setBuiltinTypeDoc(py, value: PyImportWarning.doc)

      let __new__ = FunctionWrapper(type: type, fn: PyImportWarning.__new__(_:type:args:kwargs:))
      self.add(py, type: type, name: "__new__", staticMethod: __new__, doc: nil)
      let __init__ = FunctionWrapper(type: type, fn: PyImportWarning.__init__(_:zelf:args:kwargs:))
      self.add(py, type: type, name: "__init__", method: __init__, doc: nil)

      let __class__ = FunctionWrapper(name: "__get__", fn: PyImportWarning.__class__(_:zelf:))
      self.add(py, type: type, name: "__class__", property: __class__, doc: nil)
      let __dict__ = FunctionWrapper(name: "__get__", fn: PyImportWarning.__dict__(_:zelf:))
      self.add(py, type: type, name: "__dict__", property: __dict__, doc: nil)
    }

    // 'ImportWarning' does not add any interesting methods to 'Warning'.
    internal static let importWarningStaticMethods = Py.ErrorTypes.warningStaticMethods.copy()

    // MARK: - UnicodeWarning

    private func fillUnicodeWarning(_ py: Py) {
      let type = self.unicodeWarning
      type.setBuiltinTypeDoc(py, value: PyUnicodeWarning.doc)

      let __new__ = FunctionWrapper(type: type, fn: PyUnicodeWarning.__new__(_:type:args:kwargs:))
      self.add(py, type: type, name: "__new__", staticMethod: __new__, doc: nil)
      let __init__ = FunctionWrapper(type: type, fn: PyUnicodeWarning.__init__(_:zelf:args:kwargs:))
      self.add(py, type: type, name: "__init__", method: __init__, doc: nil)

      let __class__ = FunctionWrapper(name: "__get__", fn: PyUnicodeWarning.__class__(_:zelf:))
      self.add(py, type: type, name: "__class__", property: __class__, doc: nil)
      let __dict__ = FunctionWrapper(name: "__get__", fn: PyUnicodeWarning.__dict__(_:zelf:))
      self.add(py, type: type, name: "__dict__", property: __dict__, doc: nil)
    }

    // 'UnicodeWarning' does not add any interesting methods to 'Warning'.
    internal static let unicodeWarningStaticMethods = Py.ErrorTypes.warningStaticMethods.copy()

    // MARK: - BytesWarning

    private func fillBytesWarning(_ py: Py) {
      let type = self.bytesWarning
      type.setBuiltinTypeDoc(py, value: PyBytesWarning.doc)

      let __new__ = FunctionWrapper(type: type, fn: PyBytesWarning.__new__(_:type:args:kwargs:))
      self.add(py, type: type, name: "__new__", staticMethod: __new__, doc: nil)
      let __init__ = FunctionWrapper(type: type, fn: PyBytesWarning.__init__(_:zelf:args:kwargs:))
      self.add(py, type: type, name: "__init__", method: __init__, doc: nil)

      let __class__ = FunctionWrapper(name: "__get__", fn: PyBytesWarning.__class__(_:zelf:))
      self.add(py, type: type, name: "__class__", property: __class__, doc: nil)
      let __dict__ = FunctionWrapper(name: "__get__", fn: PyBytesWarning.__dict__(_:zelf:))
      self.add(py, type: type, name: "__dict__", property: __dict__, doc: nil)
    }

    // 'BytesWarning' does not add any interesting methods to 'Warning'.
    internal static let bytesWarningStaticMethods = Py.ErrorTypes.warningStaticMethods.copy()

    // MARK: - ResourceWarning

    private func fillResourceWarning(_ py: Py) {
      let type = self.resourceWarning
      type.setBuiltinTypeDoc(py, value: PyResourceWarning.doc)

      let __new__ = FunctionWrapper(type: type, fn: PyResourceWarning.__new__(_:type:args:kwargs:))
      self.add(py, type: type, name: "__new__", staticMethod: __new__, doc: nil)
      let __init__ = FunctionWrapper(type: type, fn: PyResourceWarning.__init__(_:zelf:args:kwargs:))
      self.add(py, type: type, name: "__init__", method: __init__, doc: nil)

      let __class__ = FunctionWrapper(name: "__get__", fn: PyResourceWarning.__class__(_:zelf:))
      self.add(py, type: type, name: "__class__", property: __class__, doc: nil)
      let __dict__ = FunctionWrapper(name: "__get__", fn: PyResourceWarning.__dict__(_:zelf:))
      self.add(py, type: type, name: "__dict__", property: __dict__, doc: nil)
    }

    // 'ResourceWarning' does not add any interesting methods to 'Warning'.
    internal static let resourceWarningStaticMethods = Py.ErrorTypes.warningStaticMethods.copy()

  }
}
