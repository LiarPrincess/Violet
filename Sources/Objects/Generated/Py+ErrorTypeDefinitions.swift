// ====================================================================================
// Automatically generated from: ./Sources/Objects/Generated/Py+ErrorTypeDefinitions.py
// Use 'make gen' in repository root to regenerate.
// DO NOT EDIT!
// ====================================================================================

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
        py,
        type: typeType,
        name: "BaseException",
        qualname: "BaseException",
        flags: [.hasGCFlag, .instancesHave__dict__Flag, .isBaseExceptionSubclassFlag, .isBaseTypeFlag, .isDefaultFlag],
        base: objectType,
        bases: [objectType],
        mroWithoutSelf: [objectType],
        subclasses: [],
        layout: Py.ErrorTypes.baseExceptionMemoryLayout,
        staticMethods: Py.ErrorTypes.baseExceptionStaticMethods,
        debugFn: PyBaseException.createDebugString(ptr:),
        deinitialize: PyBaseException.deinitialize(ptr:)
      )

      self.systemExit = memory.newType(
        py,
        type: typeType,
        name: "SystemExit",
        qualname: "SystemExit",
        flags: [.hasGCFlag, .instancesHave__dict__Flag, .isBaseExceptionSubclassFlag, .isBaseTypeFlag, .isDefaultFlag],
        base: self.baseException,
        bases: [self.baseException],
        mroWithoutSelf: [self.baseException, objectType],
        subclasses: [],
        layout: Py.ErrorTypes.systemExitMemoryLayout,
        staticMethods: Py.ErrorTypes.systemExitStaticMethods,
        debugFn: PySystemExit.createDebugString(ptr:),
        deinitialize: PySystemExit.deinitialize(ptr:)
      )

      self.keyboardInterrupt = memory.newType(
        py,
        type: typeType,
        name: "KeyboardInterrupt",
        qualname: "KeyboardInterrupt",
        flags: [.hasGCFlag, .instancesHave__dict__Flag, .isBaseExceptionSubclassFlag, .isBaseTypeFlag, .isDefaultFlag],
        base: self.baseException,
        bases: [self.baseException],
        mroWithoutSelf: [self.baseException, objectType],
        subclasses: [],
        layout: Py.ErrorTypes.keyboardInterruptMemoryLayout,
        staticMethods: Py.ErrorTypes.keyboardInterruptStaticMethods,
        debugFn: PyKeyboardInterrupt.createDebugString(ptr:),
        deinitialize: PyKeyboardInterrupt.deinitialize(ptr:)
      )

      self.generatorExit = memory.newType(
        py,
        type: typeType,
        name: "GeneratorExit",
        qualname: "GeneratorExit",
        flags: [.hasGCFlag, .instancesHave__dict__Flag, .isBaseExceptionSubclassFlag, .isBaseTypeFlag, .isDefaultFlag],
        base: self.baseException,
        bases: [self.baseException],
        mroWithoutSelf: [self.baseException, objectType],
        subclasses: [],
        layout: Py.ErrorTypes.generatorExitMemoryLayout,
        staticMethods: Py.ErrorTypes.generatorExitStaticMethods,
        debugFn: PyGeneratorExit.createDebugString(ptr:),
        deinitialize: PyGeneratorExit.deinitialize(ptr:)
      )

      self.exception = memory.newType(
        py,
        type: typeType,
        name: "Exception",
        qualname: "Exception",
        flags: [.hasGCFlag, .instancesHave__dict__Flag, .isBaseExceptionSubclassFlag, .isBaseTypeFlag, .isDefaultFlag],
        base: self.baseException,
        bases: [self.baseException],
        mroWithoutSelf: [self.baseException, objectType],
        subclasses: [],
        layout: Py.ErrorTypes.exceptionMemoryLayout,
        staticMethods: Py.ErrorTypes.exceptionStaticMethods,
        debugFn: PyException.createDebugString(ptr:),
        deinitialize: PyException.deinitialize(ptr:)
      )

      self.stopIteration = memory.newType(
        py,
        type: typeType,
        name: "StopIteration",
        qualname: "StopIteration",
        flags: [.hasGCFlag, .instancesHave__dict__Flag, .isBaseExceptionSubclassFlag, .isBaseTypeFlag, .isDefaultFlag],
        base: self.exception,
        bases: [self.exception],
        mroWithoutSelf: [self.exception, self.baseException, objectType],
        subclasses: [],
        layout: Py.ErrorTypes.stopIterationMemoryLayout,
        staticMethods: Py.ErrorTypes.stopIterationStaticMethods,
        debugFn: PyStopIteration.createDebugString(ptr:),
        deinitialize: PyStopIteration.deinitialize(ptr:)
      )

      self.stopAsyncIteration = memory.newType(
        py,
        type: typeType,
        name: "StopAsyncIteration",
        qualname: "StopAsyncIteration",
        flags: [.hasGCFlag, .instancesHave__dict__Flag, .isBaseExceptionSubclassFlag, .isBaseTypeFlag, .isDefaultFlag],
        base: self.exception,
        bases: [self.exception],
        mroWithoutSelf: [self.exception, self.baseException, objectType],
        subclasses: [],
        layout: Py.ErrorTypes.stopAsyncIterationMemoryLayout,
        staticMethods: Py.ErrorTypes.stopAsyncIterationStaticMethods,
        debugFn: PyStopAsyncIteration.createDebugString(ptr:),
        deinitialize: PyStopAsyncIteration.deinitialize(ptr:)
      )

      self.arithmeticError = memory.newType(
        py,
        type: typeType,
        name: "ArithmeticError",
        qualname: "ArithmeticError",
        flags: [.hasGCFlag, .instancesHave__dict__Flag, .isBaseExceptionSubclassFlag, .isBaseTypeFlag, .isDefaultFlag],
        base: self.exception,
        bases: [self.exception],
        mroWithoutSelf: [self.exception, self.baseException, objectType],
        subclasses: [],
        layout: Py.ErrorTypes.arithmeticErrorMemoryLayout,
        staticMethods: Py.ErrorTypes.arithmeticErrorStaticMethods,
        debugFn: PyArithmeticError.createDebugString(ptr:),
        deinitialize: PyArithmeticError.deinitialize(ptr:)
      )

      self.floatingPointError = memory.newType(
        py,
        type: typeType,
        name: "FloatingPointError",
        qualname: "FloatingPointError",
        flags: [.hasGCFlag, .instancesHave__dict__Flag, .isBaseExceptionSubclassFlag, .isBaseTypeFlag, .isDefaultFlag],
        base: self.arithmeticError,
        bases: [self.arithmeticError],
        mroWithoutSelf: [self.arithmeticError, self.exception, self.baseException, objectType],
        subclasses: [],
        layout: Py.ErrorTypes.floatingPointErrorMemoryLayout,
        staticMethods: Py.ErrorTypes.floatingPointErrorStaticMethods,
        debugFn: PyFloatingPointError.createDebugString(ptr:),
        deinitialize: PyFloatingPointError.deinitialize(ptr:)
      )

      self.overflowError = memory.newType(
        py,
        type: typeType,
        name: "OverflowError",
        qualname: "OverflowError",
        flags: [.hasGCFlag, .instancesHave__dict__Flag, .isBaseExceptionSubclassFlag, .isBaseTypeFlag, .isDefaultFlag],
        base: self.arithmeticError,
        bases: [self.arithmeticError],
        mroWithoutSelf: [self.arithmeticError, self.exception, self.baseException, objectType],
        subclasses: [],
        layout: Py.ErrorTypes.overflowErrorMemoryLayout,
        staticMethods: Py.ErrorTypes.overflowErrorStaticMethods,
        debugFn: PyOverflowError.createDebugString(ptr:),
        deinitialize: PyOverflowError.deinitialize(ptr:)
      )

      self.zeroDivisionError = memory.newType(
        py,
        type: typeType,
        name: "ZeroDivisionError",
        qualname: "ZeroDivisionError",
        flags: [.hasGCFlag, .instancesHave__dict__Flag, .isBaseExceptionSubclassFlag, .isBaseTypeFlag, .isDefaultFlag],
        base: self.arithmeticError,
        bases: [self.arithmeticError],
        mroWithoutSelf: [self.arithmeticError, self.exception, self.baseException, objectType],
        subclasses: [],
        layout: Py.ErrorTypes.zeroDivisionErrorMemoryLayout,
        staticMethods: Py.ErrorTypes.zeroDivisionErrorStaticMethods,
        debugFn: PyZeroDivisionError.createDebugString(ptr:),
        deinitialize: PyZeroDivisionError.deinitialize(ptr:)
      )

      self.assertionError = memory.newType(
        py,
        type: typeType,
        name: "AssertionError",
        qualname: "AssertionError",
        flags: [.hasGCFlag, .instancesHave__dict__Flag, .isBaseExceptionSubclassFlag, .isBaseTypeFlag, .isDefaultFlag],
        base: self.exception,
        bases: [self.exception],
        mroWithoutSelf: [self.exception, self.baseException, objectType],
        subclasses: [],
        layout: Py.ErrorTypes.assertionErrorMemoryLayout,
        staticMethods: Py.ErrorTypes.assertionErrorStaticMethods,
        debugFn: PyAssertionError.createDebugString(ptr:),
        deinitialize: PyAssertionError.deinitialize(ptr:)
      )

      self.attributeError = memory.newType(
        py,
        type: typeType,
        name: "AttributeError",
        qualname: "AttributeError",
        flags: [.hasGCFlag, .instancesHave__dict__Flag, .isBaseExceptionSubclassFlag, .isBaseTypeFlag, .isDefaultFlag],
        base: self.exception,
        bases: [self.exception],
        mroWithoutSelf: [self.exception, self.baseException, objectType],
        subclasses: [],
        layout: Py.ErrorTypes.attributeErrorMemoryLayout,
        staticMethods: Py.ErrorTypes.attributeErrorStaticMethods,
        debugFn: PyAttributeError.createDebugString(ptr:),
        deinitialize: PyAttributeError.deinitialize(ptr:)
      )

      self.bufferError = memory.newType(
        py,
        type: typeType,
        name: "BufferError",
        qualname: "BufferError",
        flags: [.hasGCFlag, .instancesHave__dict__Flag, .isBaseExceptionSubclassFlag, .isBaseTypeFlag, .isDefaultFlag],
        base: self.exception,
        bases: [self.exception],
        mroWithoutSelf: [self.exception, self.baseException, objectType],
        subclasses: [],
        layout: Py.ErrorTypes.bufferErrorMemoryLayout,
        staticMethods: Py.ErrorTypes.bufferErrorStaticMethods,
        debugFn: PyBufferError.createDebugString(ptr:),
        deinitialize: PyBufferError.deinitialize(ptr:)
      )

      self.eofError = memory.newType(
        py,
        type: typeType,
        name: "EOFError",
        qualname: "EOFError",
        flags: [.hasGCFlag, .instancesHave__dict__Flag, .isBaseExceptionSubclassFlag, .isBaseTypeFlag, .isDefaultFlag],
        base: self.exception,
        bases: [self.exception],
        mroWithoutSelf: [self.exception, self.baseException, objectType],
        subclasses: [],
        layout: Py.ErrorTypes.eOFErrorMemoryLayout,
        staticMethods: Py.ErrorTypes.eOFErrorStaticMethods,
        debugFn: PyEOFError.createDebugString(ptr:),
        deinitialize: PyEOFError.deinitialize(ptr:)
      )

      self.importError = memory.newType(
        py,
        type: typeType,
        name: "ImportError",
        qualname: "ImportError",
        flags: [.hasGCFlag, .instancesHave__dict__Flag, .isBaseExceptionSubclassFlag, .isBaseTypeFlag, .isDefaultFlag],
        base: self.exception,
        bases: [self.exception],
        mroWithoutSelf: [self.exception, self.baseException, objectType],
        subclasses: [],
        layout: Py.ErrorTypes.importErrorMemoryLayout,
        staticMethods: Py.ErrorTypes.importErrorStaticMethods,
        debugFn: PyImportError.createDebugString(ptr:),
        deinitialize: PyImportError.deinitialize(ptr:)
      )

      self.moduleNotFoundError = memory.newType(
        py,
        type: typeType,
        name: "ModuleNotFoundError",
        qualname: "ModuleNotFoundError",
        flags: [.hasGCFlag, .instancesHave__dict__Flag, .isBaseExceptionSubclassFlag, .isBaseTypeFlag, .isDefaultFlag],
        base: self.importError,
        bases: [self.importError],
        mroWithoutSelf: [self.importError, self.exception, self.baseException, objectType],
        subclasses: [],
        layout: Py.ErrorTypes.moduleNotFoundErrorMemoryLayout,
        staticMethods: Py.ErrorTypes.moduleNotFoundErrorStaticMethods,
        debugFn: PyModuleNotFoundError.createDebugString(ptr:),
        deinitialize: PyModuleNotFoundError.deinitialize(ptr:)
      )

      self.lookupError = memory.newType(
        py,
        type: typeType,
        name: "LookupError",
        qualname: "LookupError",
        flags: [.hasGCFlag, .instancesHave__dict__Flag, .isBaseExceptionSubclassFlag, .isBaseTypeFlag, .isDefaultFlag],
        base: self.exception,
        bases: [self.exception],
        mroWithoutSelf: [self.exception, self.baseException, objectType],
        subclasses: [],
        layout: Py.ErrorTypes.lookupErrorMemoryLayout,
        staticMethods: Py.ErrorTypes.lookupErrorStaticMethods,
        debugFn: PyLookupError.createDebugString(ptr:),
        deinitialize: PyLookupError.deinitialize(ptr:)
      )

      self.indexError = memory.newType(
        py,
        type: typeType,
        name: "IndexError",
        qualname: "IndexError",
        flags: [.hasGCFlag, .instancesHave__dict__Flag, .isBaseExceptionSubclassFlag, .isBaseTypeFlag, .isDefaultFlag],
        base: self.lookupError,
        bases: [self.lookupError],
        mroWithoutSelf: [self.lookupError, self.exception, self.baseException, objectType],
        subclasses: [],
        layout: Py.ErrorTypes.indexErrorMemoryLayout,
        staticMethods: Py.ErrorTypes.indexErrorStaticMethods,
        debugFn: PyIndexError.createDebugString(ptr:),
        deinitialize: PyIndexError.deinitialize(ptr:)
      )

      self.keyError = memory.newType(
        py,
        type: typeType,
        name: "KeyError",
        qualname: "KeyError",
        flags: [.hasGCFlag, .instancesHave__dict__Flag, .isBaseExceptionSubclassFlag, .isBaseTypeFlag, .isDefaultFlag],
        base: self.lookupError,
        bases: [self.lookupError],
        mroWithoutSelf: [self.lookupError, self.exception, self.baseException, objectType],
        subclasses: [],
        layout: Py.ErrorTypes.keyErrorMemoryLayout,
        staticMethods: Py.ErrorTypes.keyErrorStaticMethods,
        debugFn: PyKeyError.createDebugString(ptr:),
        deinitialize: PyKeyError.deinitialize(ptr:)
      )

      self.memoryError = memory.newType(
        py,
        type: typeType,
        name: "MemoryError",
        qualname: "MemoryError",
        flags: [.hasGCFlag, .instancesHave__dict__Flag, .isBaseExceptionSubclassFlag, .isBaseTypeFlag, .isDefaultFlag],
        base: self.exception,
        bases: [self.exception],
        mroWithoutSelf: [self.exception, self.baseException, objectType],
        subclasses: [],
        layout: Py.ErrorTypes.memoryErrorMemoryLayout,
        staticMethods: Py.ErrorTypes.memoryErrorStaticMethods,
        debugFn: PyMemoryError.createDebugString(ptr:),
        deinitialize: PyMemoryError.deinitialize(ptr:)
      )

      self.nameError = memory.newType(
        py,
        type: typeType,
        name: "NameError",
        qualname: "NameError",
        flags: [.hasGCFlag, .instancesHave__dict__Flag, .isBaseExceptionSubclassFlag, .isBaseTypeFlag, .isDefaultFlag],
        base: self.exception,
        bases: [self.exception],
        mroWithoutSelf: [self.exception, self.baseException, objectType],
        subclasses: [],
        layout: Py.ErrorTypes.nameErrorMemoryLayout,
        staticMethods: Py.ErrorTypes.nameErrorStaticMethods,
        debugFn: PyNameError.createDebugString(ptr:),
        deinitialize: PyNameError.deinitialize(ptr:)
      )

      self.unboundLocalError = memory.newType(
        py,
        type: typeType,
        name: "UnboundLocalError",
        qualname: "UnboundLocalError",
        flags: [.hasGCFlag, .instancesHave__dict__Flag, .isBaseExceptionSubclassFlag, .isBaseTypeFlag, .isDefaultFlag],
        base: self.nameError,
        bases: [self.nameError],
        mroWithoutSelf: [self.nameError, self.exception, self.baseException, objectType],
        subclasses: [],
        layout: Py.ErrorTypes.unboundLocalErrorMemoryLayout,
        staticMethods: Py.ErrorTypes.unboundLocalErrorStaticMethods,
        debugFn: PyUnboundLocalError.createDebugString(ptr:),
        deinitialize: PyUnboundLocalError.deinitialize(ptr:)
      )

      self.osError = memory.newType(
        py,
        type: typeType,
        name: "OSError",
        qualname: "OSError",
        flags: [.hasGCFlag, .instancesHave__dict__Flag, .isBaseExceptionSubclassFlag, .isBaseTypeFlag, .isDefaultFlag],
        base: self.exception,
        bases: [self.exception],
        mroWithoutSelf: [self.exception, self.baseException, objectType],
        subclasses: [],
        layout: Py.ErrorTypes.oSErrorMemoryLayout,
        staticMethods: Py.ErrorTypes.oSErrorStaticMethods,
        debugFn: PyOSError.createDebugString(ptr:),
        deinitialize: PyOSError.deinitialize(ptr:)
      )

      self.blockingIOError = memory.newType(
        py,
        type: typeType,
        name: "BlockingIOError",
        qualname: "BlockingIOError",
        flags: [.hasGCFlag, .instancesHave__dict__Flag, .isBaseExceptionSubclassFlag, .isBaseTypeFlag, .isDefaultFlag],
        base: self.osError,
        bases: [self.osError],
        mroWithoutSelf: [self.osError, self.exception, self.baseException, objectType],
        subclasses: [],
        layout: Py.ErrorTypes.blockingIOErrorMemoryLayout,
        staticMethods: Py.ErrorTypes.blockingIOErrorStaticMethods,
        debugFn: PyBlockingIOError.createDebugString(ptr:),
        deinitialize: PyBlockingIOError.deinitialize(ptr:)
      )

      self.childProcessError = memory.newType(
        py,
        type: typeType,
        name: "ChildProcessError",
        qualname: "ChildProcessError",
        flags: [.hasGCFlag, .instancesHave__dict__Flag, .isBaseExceptionSubclassFlag, .isBaseTypeFlag, .isDefaultFlag],
        base: self.osError,
        bases: [self.osError],
        mroWithoutSelf: [self.osError, self.exception, self.baseException, objectType],
        subclasses: [],
        layout: Py.ErrorTypes.childProcessErrorMemoryLayout,
        staticMethods: Py.ErrorTypes.childProcessErrorStaticMethods,
        debugFn: PyChildProcessError.createDebugString(ptr:),
        deinitialize: PyChildProcessError.deinitialize(ptr:)
      )

      self.connectionError = memory.newType(
        py,
        type: typeType,
        name: "ConnectionError",
        qualname: "ConnectionError",
        flags: [.hasGCFlag, .instancesHave__dict__Flag, .isBaseExceptionSubclassFlag, .isBaseTypeFlag, .isDefaultFlag],
        base: self.osError,
        bases: [self.osError],
        mroWithoutSelf: [self.osError, self.exception, self.baseException, objectType],
        subclasses: [],
        layout: Py.ErrorTypes.connectionErrorMemoryLayout,
        staticMethods: Py.ErrorTypes.connectionErrorStaticMethods,
        debugFn: PyConnectionError.createDebugString(ptr:),
        deinitialize: PyConnectionError.deinitialize(ptr:)
      )

      self.brokenPipeError = memory.newType(
        py,
        type: typeType,
        name: "BrokenPipeError",
        qualname: "BrokenPipeError",
        flags: [.hasGCFlag, .instancesHave__dict__Flag, .isBaseExceptionSubclassFlag, .isBaseTypeFlag, .isDefaultFlag],
        base: self.connectionError,
        bases: [self.connectionError],
        mroWithoutSelf: [self.connectionError, self.osError, self.exception, self.baseException, objectType],
        subclasses: [],
        layout: Py.ErrorTypes.brokenPipeErrorMemoryLayout,
        staticMethods: Py.ErrorTypes.brokenPipeErrorStaticMethods,
        debugFn: PyBrokenPipeError.createDebugString(ptr:),
        deinitialize: PyBrokenPipeError.deinitialize(ptr:)
      )

      self.connectionAbortedError = memory.newType(
        py,
        type: typeType,
        name: "ConnectionAbortedError",
        qualname: "ConnectionAbortedError",
        flags: [.hasGCFlag, .instancesHave__dict__Flag, .isBaseExceptionSubclassFlag, .isBaseTypeFlag, .isDefaultFlag],
        base: self.connectionError,
        bases: [self.connectionError],
        mroWithoutSelf: [self.connectionError, self.osError, self.exception, self.baseException, objectType],
        subclasses: [],
        layout: Py.ErrorTypes.connectionAbortedErrorMemoryLayout,
        staticMethods: Py.ErrorTypes.connectionAbortedErrorStaticMethods,
        debugFn: PyConnectionAbortedError.createDebugString(ptr:),
        deinitialize: PyConnectionAbortedError.deinitialize(ptr:)
      )

      self.connectionRefusedError = memory.newType(
        py,
        type: typeType,
        name: "ConnectionRefusedError",
        qualname: "ConnectionRefusedError",
        flags: [.hasGCFlag, .instancesHave__dict__Flag, .isBaseExceptionSubclassFlag, .isBaseTypeFlag, .isDefaultFlag],
        base: self.connectionError,
        bases: [self.connectionError],
        mroWithoutSelf: [self.connectionError, self.osError, self.exception, self.baseException, objectType],
        subclasses: [],
        layout: Py.ErrorTypes.connectionRefusedErrorMemoryLayout,
        staticMethods: Py.ErrorTypes.connectionRefusedErrorStaticMethods,
        debugFn: PyConnectionRefusedError.createDebugString(ptr:),
        deinitialize: PyConnectionRefusedError.deinitialize(ptr:)
      )

      self.connectionResetError = memory.newType(
        py,
        type: typeType,
        name: "ConnectionResetError",
        qualname: "ConnectionResetError",
        flags: [.hasGCFlag, .instancesHave__dict__Flag, .isBaseExceptionSubclassFlag, .isBaseTypeFlag, .isDefaultFlag],
        base: self.connectionError,
        bases: [self.connectionError],
        mroWithoutSelf: [self.connectionError, self.osError, self.exception, self.baseException, objectType],
        subclasses: [],
        layout: Py.ErrorTypes.connectionResetErrorMemoryLayout,
        staticMethods: Py.ErrorTypes.connectionResetErrorStaticMethods,
        debugFn: PyConnectionResetError.createDebugString(ptr:),
        deinitialize: PyConnectionResetError.deinitialize(ptr:)
      )

      self.fileExistsError = memory.newType(
        py,
        type: typeType,
        name: "FileExistsError",
        qualname: "FileExistsError",
        flags: [.hasGCFlag, .instancesHave__dict__Flag, .isBaseExceptionSubclassFlag, .isBaseTypeFlag, .isDefaultFlag],
        base: self.osError,
        bases: [self.osError],
        mroWithoutSelf: [self.osError, self.exception, self.baseException, objectType],
        subclasses: [],
        layout: Py.ErrorTypes.fileExistsErrorMemoryLayout,
        staticMethods: Py.ErrorTypes.fileExistsErrorStaticMethods,
        debugFn: PyFileExistsError.createDebugString(ptr:),
        deinitialize: PyFileExistsError.deinitialize(ptr:)
      )

      self.fileNotFoundError = memory.newType(
        py,
        type: typeType,
        name: "FileNotFoundError",
        qualname: "FileNotFoundError",
        flags: [.hasGCFlag, .instancesHave__dict__Flag, .isBaseExceptionSubclassFlag, .isBaseTypeFlag, .isDefaultFlag],
        base: self.osError,
        bases: [self.osError],
        mroWithoutSelf: [self.osError, self.exception, self.baseException, objectType],
        subclasses: [],
        layout: Py.ErrorTypes.fileNotFoundErrorMemoryLayout,
        staticMethods: Py.ErrorTypes.fileNotFoundErrorStaticMethods,
        debugFn: PyFileNotFoundError.createDebugString(ptr:),
        deinitialize: PyFileNotFoundError.deinitialize(ptr:)
      )

      self.interruptedError = memory.newType(
        py,
        type: typeType,
        name: "InterruptedError",
        qualname: "InterruptedError",
        flags: [.hasGCFlag, .instancesHave__dict__Flag, .isBaseExceptionSubclassFlag, .isBaseTypeFlag, .isDefaultFlag],
        base: self.osError,
        bases: [self.osError],
        mroWithoutSelf: [self.osError, self.exception, self.baseException, objectType],
        subclasses: [],
        layout: Py.ErrorTypes.interruptedErrorMemoryLayout,
        staticMethods: Py.ErrorTypes.interruptedErrorStaticMethods,
        debugFn: PyInterruptedError.createDebugString(ptr:),
        deinitialize: PyInterruptedError.deinitialize(ptr:)
      )

      self.isADirectoryError = memory.newType(
        py,
        type: typeType,
        name: "IsADirectoryError",
        qualname: "IsADirectoryError",
        flags: [.hasGCFlag, .instancesHave__dict__Flag, .isBaseExceptionSubclassFlag, .isBaseTypeFlag, .isDefaultFlag],
        base: self.osError,
        bases: [self.osError],
        mroWithoutSelf: [self.osError, self.exception, self.baseException, objectType],
        subclasses: [],
        layout: Py.ErrorTypes.isADirectoryErrorMemoryLayout,
        staticMethods: Py.ErrorTypes.isADirectoryErrorStaticMethods,
        debugFn: PyIsADirectoryError.createDebugString(ptr:),
        deinitialize: PyIsADirectoryError.deinitialize(ptr:)
      )

      self.notADirectoryError = memory.newType(
        py,
        type: typeType,
        name: "NotADirectoryError",
        qualname: "NotADirectoryError",
        flags: [.hasGCFlag, .instancesHave__dict__Flag, .isBaseExceptionSubclassFlag, .isBaseTypeFlag, .isDefaultFlag],
        base: self.osError,
        bases: [self.osError],
        mroWithoutSelf: [self.osError, self.exception, self.baseException, objectType],
        subclasses: [],
        layout: Py.ErrorTypes.notADirectoryErrorMemoryLayout,
        staticMethods: Py.ErrorTypes.notADirectoryErrorStaticMethods,
        debugFn: PyNotADirectoryError.createDebugString(ptr:),
        deinitialize: PyNotADirectoryError.deinitialize(ptr:)
      )

      self.permissionError = memory.newType(
        py,
        type: typeType,
        name: "PermissionError",
        qualname: "PermissionError",
        flags: [.hasGCFlag, .instancesHave__dict__Flag, .isBaseExceptionSubclassFlag, .isBaseTypeFlag, .isDefaultFlag],
        base: self.osError,
        bases: [self.osError],
        mroWithoutSelf: [self.osError, self.exception, self.baseException, objectType],
        subclasses: [],
        layout: Py.ErrorTypes.permissionErrorMemoryLayout,
        staticMethods: Py.ErrorTypes.permissionErrorStaticMethods,
        debugFn: PyPermissionError.createDebugString(ptr:),
        deinitialize: PyPermissionError.deinitialize(ptr:)
      )

      self.processLookupError = memory.newType(
        py,
        type: typeType,
        name: "ProcessLookupError",
        qualname: "ProcessLookupError",
        flags: [.hasGCFlag, .instancesHave__dict__Flag, .isBaseExceptionSubclassFlag, .isBaseTypeFlag, .isDefaultFlag],
        base: self.osError,
        bases: [self.osError],
        mroWithoutSelf: [self.osError, self.exception, self.baseException, objectType],
        subclasses: [],
        layout: Py.ErrorTypes.processLookupErrorMemoryLayout,
        staticMethods: Py.ErrorTypes.processLookupErrorStaticMethods,
        debugFn: PyProcessLookupError.createDebugString(ptr:),
        deinitialize: PyProcessLookupError.deinitialize(ptr:)
      )

      self.timeoutError = memory.newType(
        py,
        type: typeType,
        name: "TimeoutError",
        qualname: "TimeoutError",
        flags: [.hasGCFlag, .instancesHave__dict__Flag, .isBaseExceptionSubclassFlag, .isBaseTypeFlag, .isDefaultFlag],
        base: self.osError,
        bases: [self.osError],
        mroWithoutSelf: [self.osError, self.exception, self.baseException, objectType],
        subclasses: [],
        layout: Py.ErrorTypes.timeoutErrorMemoryLayout,
        staticMethods: Py.ErrorTypes.timeoutErrorStaticMethods,
        debugFn: PyTimeoutError.createDebugString(ptr:),
        deinitialize: PyTimeoutError.deinitialize(ptr:)
      )

      self.referenceError = memory.newType(
        py,
        type: typeType,
        name: "ReferenceError",
        qualname: "ReferenceError",
        flags: [.hasGCFlag, .instancesHave__dict__Flag, .isBaseExceptionSubclassFlag, .isBaseTypeFlag, .isDefaultFlag],
        base: self.exception,
        bases: [self.exception],
        mroWithoutSelf: [self.exception, self.baseException, objectType],
        subclasses: [],
        layout: Py.ErrorTypes.referenceErrorMemoryLayout,
        staticMethods: Py.ErrorTypes.referenceErrorStaticMethods,
        debugFn: PyReferenceError.createDebugString(ptr:),
        deinitialize: PyReferenceError.deinitialize(ptr:)
      )

      self.runtimeError = memory.newType(
        py,
        type: typeType,
        name: "RuntimeError",
        qualname: "RuntimeError",
        flags: [.hasGCFlag, .instancesHave__dict__Flag, .isBaseExceptionSubclassFlag, .isBaseTypeFlag, .isDefaultFlag],
        base: self.exception,
        bases: [self.exception],
        mroWithoutSelf: [self.exception, self.baseException, objectType],
        subclasses: [],
        layout: Py.ErrorTypes.runtimeErrorMemoryLayout,
        staticMethods: Py.ErrorTypes.runtimeErrorStaticMethods,
        debugFn: PyRuntimeError.createDebugString(ptr:),
        deinitialize: PyRuntimeError.deinitialize(ptr:)
      )

      self.notImplementedError = memory.newType(
        py,
        type: typeType,
        name: "NotImplementedError",
        qualname: "NotImplementedError",
        flags: [.hasGCFlag, .instancesHave__dict__Flag, .isBaseExceptionSubclassFlag, .isBaseTypeFlag, .isDefaultFlag],
        base: self.runtimeError,
        bases: [self.runtimeError],
        mroWithoutSelf: [self.runtimeError, self.exception, self.baseException, objectType],
        subclasses: [],
        layout: Py.ErrorTypes.notImplementedErrorMemoryLayout,
        staticMethods: Py.ErrorTypes.notImplementedErrorStaticMethods,
        debugFn: PyNotImplementedError.createDebugString(ptr:),
        deinitialize: PyNotImplementedError.deinitialize(ptr:)
      )

      self.recursionError = memory.newType(
        py,
        type: typeType,
        name: "RecursionError",
        qualname: "RecursionError",
        flags: [.hasGCFlag, .instancesHave__dict__Flag, .isBaseExceptionSubclassFlag, .isBaseTypeFlag, .isDefaultFlag],
        base: self.runtimeError,
        bases: [self.runtimeError],
        mroWithoutSelf: [self.runtimeError, self.exception, self.baseException, objectType],
        subclasses: [],
        layout: Py.ErrorTypes.recursionErrorMemoryLayout,
        staticMethods: Py.ErrorTypes.recursionErrorStaticMethods,
        debugFn: PyRecursionError.createDebugString(ptr:),
        deinitialize: PyRecursionError.deinitialize(ptr:)
      )

      self.syntaxError = memory.newType(
        py,
        type: typeType,
        name: "SyntaxError",
        qualname: "SyntaxError",
        flags: [.hasGCFlag, .instancesHave__dict__Flag, .isBaseExceptionSubclassFlag, .isBaseTypeFlag, .isDefaultFlag],
        base: self.exception,
        bases: [self.exception],
        mroWithoutSelf: [self.exception, self.baseException, objectType],
        subclasses: [],
        layout: Py.ErrorTypes.syntaxErrorMemoryLayout,
        staticMethods: Py.ErrorTypes.syntaxErrorStaticMethods,
        debugFn: PySyntaxError.createDebugString(ptr:),
        deinitialize: PySyntaxError.deinitialize(ptr:)
      )

      self.indentationError = memory.newType(
        py,
        type: typeType,
        name: "IndentationError",
        qualname: "IndentationError",
        flags: [.hasGCFlag, .instancesHave__dict__Flag, .isBaseExceptionSubclassFlag, .isBaseTypeFlag, .isDefaultFlag],
        base: self.syntaxError,
        bases: [self.syntaxError],
        mroWithoutSelf: [self.syntaxError, self.exception, self.baseException, objectType],
        subclasses: [],
        layout: Py.ErrorTypes.indentationErrorMemoryLayout,
        staticMethods: Py.ErrorTypes.indentationErrorStaticMethods,
        debugFn: PyIndentationError.createDebugString(ptr:),
        deinitialize: PyIndentationError.deinitialize(ptr:)
      )

      self.tabError = memory.newType(
        py,
        type: typeType,
        name: "TabError",
        qualname: "TabError",
        flags: [.hasGCFlag, .instancesHave__dict__Flag, .isBaseExceptionSubclassFlag, .isBaseTypeFlag, .isDefaultFlag],
        base: self.indentationError,
        bases: [self.indentationError],
        mroWithoutSelf: [self.indentationError, self.syntaxError, self.exception, self.baseException, objectType],
        subclasses: [],
        layout: Py.ErrorTypes.tabErrorMemoryLayout,
        staticMethods: Py.ErrorTypes.tabErrorStaticMethods,
        debugFn: PyTabError.createDebugString(ptr:),
        deinitialize: PyTabError.deinitialize(ptr:)
      )

      self.systemError = memory.newType(
        py,
        type: typeType,
        name: "SystemError",
        qualname: "SystemError",
        flags: [.hasGCFlag, .instancesHave__dict__Flag, .isBaseExceptionSubclassFlag, .isBaseTypeFlag, .isDefaultFlag],
        base: self.exception,
        bases: [self.exception],
        mroWithoutSelf: [self.exception, self.baseException, objectType],
        subclasses: [],
        layout: Py.ErrorTypes.systemErrorMemoryLayout,
        staticMethods: Py.ErrorTypes.systemErrorStaticMethods,
        debugFn: PySystemError.createDebugString(ptr:),
        deinitialize: PySystemError.deinitialize(ptr:)
      )

      self.typeError = memory.newType(
        py,
        type: typeType,
        name: "TypeError",
        qualname: "TypeError",
        flags: [.hasGCFlag, .instancesHave__dict__Flag, .isBaseExceptionSubclassFlag, .isBaseTypeFlag, .isDefaultFlag],
        base: self.exception,
        bases: [self.exception],
        mroWithoutSelf: [self.exception, self.baseException, objectType],
        subclasses: [],
        layout: Py.ErrorTypes.typeErrorMemoryLayout,
        staticMethods: Py.ErrorTypes.typeErrorStaticMethods,
        debugFn: PyTypeError.createDebugString(ptr:),
        deinitialize: PyTypeError.deinitialize(ptr:)
      )

      self.valueError = memory.newType(
        py,
        type: typeType,
        name: "ValueError",
        qualname: "ValueError",
        flags: [.hasGCFlag, .instancesHave__dict__Flag, .isBaseExceptionSubclassFlag, .isBaseTypeFlag, .isDefaultFlag],
        base: self.exception,
        bases: [self.exception],
        mroWithoutSelf: [self.exception, self.baseException, objectType],
        subclasses: [],
        layout: Py.ErrorTypes.valueErrorMemoryLayout,
        staticMethods: Py.ErrorTypes.valueErrorStaticMethods,
        debugFn: PyValueError.createDebugString(ptr:),
        deinitialize: PyValueError.deinitialize(ptr:)
      )

      self.unicodeError = memory.newType(
        py,
        type: typeType,
        name: "UnicodeError",
        qualname: "UnicodeError",
        flags: [.hasGCFlag, .instancesHave__dict__Flag, .isBaseExceptionSubclassFlag, .isBaseTypeFlag, .isDefaultFlag],
        base: self.valueError,
        bases: [self.valueError],
        mroWithoutSelf: [self.valueError, self.exception, self.baseException, objectType],
        subclasses: [],
        layout: Py.ErrorTypes.unicodeErrorMemoryLayout,
        staticMethods: Py.ErrorTypes.unicodeErrorStaticMethods,
        debugFn: PyUnicodeError.createDebugString(ptr:),
        deinitialize: PyUnicodeError.deinitialize(ptr:)
      )

      self.unicodeDecodeError = memory.newType(
        py,
        type: typeType,
        name: "UnicodeDecodeError",
        qualname: "UnicodeDecodeError",
        flags: [.hasGCFlag, .instancesHave__dict__Flag, .isBaseExceptionSubclassFlag, .isBaseTypeFlag, .isDefaultFlag],
        base: self.unicodeError,
        bases: [self.unicodeError],
        mroWithoutSelf: [self.unicodeError, self.valueError, self.exception, self.baseException, objectType],
        subclasses: [],
        layout: Py.ErrorTypes.unicodeDecodeErrorMemoryLayout,
        staticMethods: Py.ErrorTypes.unicodeDecodeErrorStaticMethods,
        debugFn: PyUnicodeDecodeError.createDebugString(ptr:),
        deinitialize: PyUnicodeDecodeError.deinitialize(ptr:)
      )

      self.unicodeEncodeError = memory.newType(
        py,
        type: typeType,
        name: "UnicodeEncodeError",
        qualname: "UnicodeEncodeError",
        flags: [.hasGCFlag, .instancesHave__dict__Flag, .isBaseExceptionSubclassFlag, .isBaseTypeFlag, .isDefaultFlag],
        base: self.unicodeError,
        bases: [self.unicodeError],
        mroWithoutSelf: [self.unicodeError, self.valueError, self.exception, self.baseException, objectType],
        subclasses: [],
        layout: Py.ErrorTypes.unicodeEncodeErrorMemoryLayout,
        staticMethods: Py.ErrorTypes.unicodeEncodeErrorStaticMethods,
        debugFn: PyUnicodeEncodeError.createDebugString(ptr:),
        deinitialize: PyUnicodeEncodeError.deinitialize(ptr:)
      )

      self.unicodeTranslateError = memory.newType(
        py,
        type: typeType,
        name: "UnicodeTranslateError",
        qualname: "UnicodeTranslateError",
        flags: [.hasGCFlag, .instancesHave__dict__Flag, .isBaseExceptionSubclassFlag, .isBaseTypeFlag, .isDefaultFlag],
        base: self.unicodeError,
        bases: [self.unicodeError],
        mroWithoutSelf: [self.unicodeError, self.valueError, self.exception, self.baseException, objectType],
        subclasses: [],
        layout: Py.ErrorTypes.unicodeTranslateErrorMemoryLayout,
        staticMethods: Py.ErrorTypes.unicodeTranslateErrorStaticMethods,
        debugFn: PyUnicodeTranslateError.createDebugString(ptr:),
        deinitialize: PyUnicodeTranslateError.deinitialize(ptr:)
      )

      self.warning = memory.newType(
        py,
        type: typeType,
        name: "Warning",
        qualname: "Warning",
        flags: [.hasGCFlag, .instancesHave__dict__Flag, .isBaseExceptionSubclassFlag, .isBaseTypeFlag, .isDefaultFlag],
        base: self.exception,
        bases: [self.exception],
        mroWithoutSelf: [self.exception, self.baseException, objectType],
        subclasses: [],
        layout: Py.ErrorTypes.warningMemoryLayout,
        staticMethods: Py.ErrorTypes.warningStaticMethods,
        debugFn: PyWarning.createDebugString(ptr:),
        deinitialize: PyWarning.deinitialize(ptr:)
      )

      self.deprecationWarning = memory.newType(
        py,
        type: typeType,
        name: "DeprecationWarning",
        qualname: "DeprecationWarning",
        flags: [.hasGCFlag, .instancesHave__dict__Flag, .isBaseExceptionSubclassFlag, .isBaseTypeFlag, .isDefaultFlag],
        base: self.warning,
        bases: [self.warning],
        mroWithoutSelf: [self.warning, self.exception, self.baseException, objectType],
        subclasses: [],
        layout: Py.ErrorTypes.deprecationWarningMemoryLayout,
        staticMethods: Py.ErrorTypes.deprecationWarningStaticMethods,
        debugFn: PyDeprecationWarning.createDebugString(ptr:),
        deinitialize: PyDeprecationWarning.deinitialize(ptr:)
      )

      self.pendingDeprecationWarning = memory.newType(
        py,
        type: typeType,
        name: "PendingDeprecationWarning",
        qualname: "PendingDeprecationWarning",
        flags: [.hasGCFlag, .instancesHave__dict__Flag, .isBaseExceptionSubclassFlag, .isBaseTypeFlag, .isDefaultFlag],
        base: self.warning,
        bases: [self.warning],
        mroWithoutSelf: [self.warning, self.exception, self.baseException, objectType],
        subclasses: [],
        layout: Py.ErrorTypes.pendingDeprecationWarningMemoryLayout,
        staticMethods: Py.ErrorTypes.pendingDeprecationWarningStaticMethods,
        debugFn: PyPendingDeprecationWarning.createDebugString(ptr:),
        deinitialize: PyPendingDeprecationWarning.deinitialize(ptr:)
      )

      self.runtimeWarning = memory.newType(
        py,
        type: typeType,
        name: "RuntimeWarning",
        qualname: "RuntimeWarning",
        flags: [.hasGCFlag, .instancesHave__dict__Flag, .isBaseExceptionSubclassFlag, .isBaseTypeFlag, .isDefaultFlag],
        base: self.warning,
        bases: [self.warning],
        mroWithoutSelf: [self.warning, self.exception, self.baseException, objectType],
        subclasses: [],
        layout: Py.ErrorTypes.runtimeWarningMemoryLayout,
        staticMethods: Py.ErrorTypes.runtimeWarningStaticMethods,
        debugFn: PyRuntimeWarning.createDebugString(ptr:),
        deinitialize: PyRuntimeWarning.deinitialize(ptr:)
      )

      self.syntaxWarning = memory.newType(
        py,
        type: typeType,
        name: "SyntaxWarning",
        qualname: "SyntaxWarning",
        flags: [.hasGCFlag, .instancesHave__dict__Flag, .isBaseExceptionSubclassFlag, .isBaseTypeFlag, .isDefaultFlag],
        base: self.warning,
        bases: [self.warning],
        mroWithoutSelf: [self.warning, self.exception, self.baseException, objectType],
        subclasses: [],
        layout: Py.ErrorTypes.syntaxWarningMemoryLayout,
        staticMethods: Py.ErrorTypes.syntaxWarningStaticMethods,
        debugFn: PySyntaxWarning.createDebugString(ptr:),
        deinitialize: PySyntaxWarning.deinitialize(ptr:)
      )

      self.userWarning = memory.newType(
        py,
        type: typeType,
        name: "UserWarning",
        qualname: "UserWarning",
        flags: [.hasGCFlag, .instancesHave__dict__Flag, .isBaseExceptionSubclassFlag, .isBaseTypeFlag, .isDefaultFlag],
        base: self.warning,
        bases: [self.warning],
        mroWithoutSelf: [self.warning, self.exception, self.baseException, objectType],
        subclasses: [],
        layout: Py.ErrorTypes.userWarningMemoryLayout,
        staticMethods: Py.ErrorTypes.userWarningStaticMethods,
        debugFn: PyUserWarning.createDebugString(ptr:),
        deinitialize: PyUserWarning.deinitialize(ptr:)
      )

      self.futureWarning = memory.newType(
        py,
        type: typeType,
        name: "FutureWarning",
        qualname: "FutureWarning",
        flags: [.hasGCFlag, .instancesHave__dict__Flag, .isBaseExceptionSubclassFlag, .isBaseTypeFlag, .isDefaultFlag],
        base: self.warning,
        bases: [self.warning],
        mroWithoutSelf: [self.warning, self.exception, self.baseException, objectType],
        subclasses: [],
        layout: Py.ErrorTypes.futureWarningMemoryLayout,
        staticMethods: Py.ErrorTypes.futureWarningStaticMethods,
        debugFn: PyFutureWarning.createDebugString(ptr:),
        deinitialize: PyFutureWarning.deinitialize(ptr:)
      )

      self.importWarning = memory.newType(
        py,
        type: typeType,
        name: "ImportWarning",
        qualname: "ImportWarning",
        flags: [.hasGCFlag, .instancesHave__dict__Flag, .isBaseExceptionSubclassFlag, .isBaseTypeFlag, .isDefaultFlag],
        base: self.warning,
        bases: [self.warning],
        mroWithoutSelf: [self.warning, self.exception, self.baseException, objectType],
        subclasses: [],
        layout: Py.ErrorTypes.importWarningMemoryLayout,
        staticMethods: Py.ErrorTypes.importWarningStaticMethods,
        debugFn: PyImportWarning.createDebugString(ptr:),
        deinitialize: PyImportWarning.deinitialize(ptr:)
      )

      self.unicodeWarning = memory.newType(
        py,
        type: typeType,
        name: "UnicodeWarning",
        qualname: "UnicodeWarning",
        flags: [.hasGCFlag, .instancesHave__dict__Flag, .isBaseExceptionSubclassFlag, .isBaseTypeFlag, .isDefaultFlag],
        base: self.warning,
        bases: [self.warning],
        mroWithoutSelf: [self.warning, self.exception, self.baseException, objectType],
        subclasses: [],
        layout: Py.ErrorTypes.unicodeWarningMemoryLayout,
        staticMethods: Py.ErrorTypes.unicodeWarningStaticMethods,
        debugFn: PyUnicodeWarning.createDebugString(ptr:),
        deinitialize: PyUnicodeWarning.deinitialize(ptr:)
      )

      self.bytesWarning = memory.newType(
        py,
        type: typeType,
        name: "BytesWarning",
        qualname: "BytesWarning",
        flags: [.hasGCFlag, .instancesHave__dict__Flag, .isBaseExceptionSubclassFlag, .isBaseTypeFlag, .isDefaultFlag],
        base: self.warning,
        bases: [self.warning],
        mroWithoutSelf: [self.warning, self.exception, self.baseException, objectType],
        subclasses: [],
        layout: Py.ErrorTypes.bytesWarningMemoryLayout,
        staticMethods: Py.ErrorTypes.bytesWarningStaticMethods,
        debugFn: PyBytesWarning.createDebugString(ptr:),
        deinitialize: PyBytesWarning.deinitialize(ptr:)
      )

      self.resourceWarning = memory.newType(
        py,
        type: typeType,
        name: "ResourceWarning",
        qualname: "ResourceWarning",
        flags: [.hasGCFlag, .instancesHave__dict__Flag, .isBaseExceptionSubclassFlag, .isBaseTypeFlag, .isDefaultFlag],
        base: self.warning,
        bases: [self.warning],
        mroWithoutSelf: [self.warning, self.exception, self.baseException, objectType],
        subclasses: [],
        layout: Py.ErrorTypes.resourceWarningMemoryLayout,
        staticMethods: Py.ErrorTypes.resourceWarningStaticMethods,
        debugFn: PyResourceWarning.createDebugString(ptr:),
        deinitialize: PyResourceWarning.deinitialize(ptr:)
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

    /// Adds `method` to `type.__dict__`.
    private func add(_ py: Py, type: PyType, name: String, method: FunctionWrapper, doc: String?) {
      let builtinFunction = py.newBuiltinFunction(fn: method, module: nil, doc: doc)
      let value = builtinFunction.asObject
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
      let __dict__ = type.header.__dict__
      let interned = py.intern(string: name)

      switch __dict__.set(py, key: interned, value: value) {
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
    }

    internal static let baseExceptionStaticMethods = PyStaticCall.KnownNotOverriddenMethods()
    internal static let baseExceptionMemoryLayout = PyType.MemoryLayout()

    // MARK: - SystemExit

    private func fillSystemExit(_ py: Py) {
      let type = self.systemExit
      type.setBuiltinTypeDoc(py, value: PySystemExit.systemExitDoc)

      let __new__ = FunctionWrapper(type: type, fn: PySystemExit.__new__(_:type:args:kwargs:))
      self.add(py, type: type, name: "__new__", staticMethod: __new__, doc: nil)
      let __init__ = FunctionWrapper(type: type, fn: PySystemExit.__init__(_:zelf:args:kwargs:))
      self.add(py, type: type, name: "__init__", method: __init__, doc: nil)
    }

    internal static let systemExitStaticMethods = PyStaticCall.KnownNotOverriddenMethods()
    internal static let systemExitMemoryLayout = PyType.MemoryLayout()

    // MARK: - KeyboardInterrupt

    private func fillKeyboardInterrupt(_ py: Py) {
      let type = self.keyboardInterrupt
      type.setBuiltinTypeDoc(py, value: PyKeyboardInterrupt.doc)

      let __new__ = FunctionWrapper(type: type, fn: PyKeyboardInterrupt.__new__(_:type:args:kwargs:))
      self.add(py, type: type, name: "__new__", staticMethod: __new__, doc: nil)
      let __init__ = FunctionWrapper(type: type, fn: PyKeyboardInterrupt.__init__(_:zelf:args:kwargs:))
      self.add(py, type: type, name: "__init__", method: __init__, doc: nil)
    }

    internal static let keyboardInterruptStaticMethods = PyStaticCall.KnownNotOverriddenMethods()
    internal static let keyboardInterruptMemoryLayout = PyType.MemoryLayout()

    // MARK: - GeneratorExit

    private func fillGeneratorExit(_ py: Py) {
      let type = self.generatorExit
      type.setBuiltinTypeDoc(py, value: PyGeneratorExit.doc)

      let __new__ = FunctionWrapper(type: type, fn: PyGeneratorExit.__new__(_:type:args:kwargs:))
      self.add(py, type: type, name: "__new__", staticMethod: __new__, doc: nil)
      let __init__ = FunctionWrapper(type: type, fn: PyGeneratorExit.__init__(_:zelf:args:kwargs:))
      self.add(py, type: type, name: "__init__", method: __init__, doc: nil)
    }

    internal static let generatorExitStaticMethods = PyStaticCall.KnownNotOverriddenMethods()
    internal static let generatorExitMemoryLayout = PyType.MemoryLayout()

    // MARK: - Exception

    private func fillException(_ py: Py) {
      let type = self.exception
      type.setBuiltinTypeDoc(py, value: PyException.doc)

      let __new__ = FunctionWrapper(type: type, fn: PyException.__new__(_:type:args:kwargs:))
      self.add(py, type: type, name: "__new__", staticMethod: __new__, doc: nil)
      let __init__ = FunctionWrapper(type: type, fn: PyException.__init__(_:zelf:args:kwargs:))
      self.add(py, type: type, name: "__init__", method: __init__, doc: nil)
    }

    internal static let exceptionStaticMethods = PyStaticCall.KnownNotOverriddenMethods()
    internal static let exceptionMemoryLayout = PyType.MemoryLayout()

    // MARK: - StopIteration

    private func fillStopIteration(_ py: Py) {
      let type = self.stopIteration
      type.setBuiltinTypeDoc(py, value: PyStopIteration.stopIterationDoc)

      let __new__ = FunctionWrapper(type: type, fn: PyStopIteration.__new__(_:type:args:kwargs:))
      self.add(py, type: type, name: "__new__", staticMethod: __new__, doc: nil)
      let __init__ = FunctionWrapper(type: type, fn: PyStopIteration.__init__(_:zelf:args:kwargs:))
      self.add(py, type: type, name: "__init__", method: __init__, doc: nil)
    }

    internal static let stopIterationStaticMethods = PyStaticCall.KnownNotOverriddenMethods()
    internal static let stopIterationMemoryLayout = PyType.MemoryLayout()

    // MARK: - StopAsyncIteration

    private func fillStopAsyncIteration(_ py: Py) {
      let type = self.stopAsyncIteration
      type.setBuiltinTypeDoc(py, value: PyStopAsyncIteration.doc)

      let __new__ = FunctionWrapper(type: type, fn: PyStopAsyncIteration.__new__(_:type:args:kwargs:))
      self.add(py, type: type, name: "__new__", staticMethod: __new__, doc: nil)
      let __init__ = FunctionWrapper(type: type, fn: PyStopAsyncIteration.__init__(_:zelf:args:kwargs:))
      self.add(py, type: type, name: "__init__", method: __init__, doc: nil)
    }

    internal static let stopAsyncIterationStaticMethods = PyStaticCall.KnownNotOverriddenMethods()
    internal static let stopAsyncIterationMemoryLayout = PyType.MemoryLayout()

    // MARK: - ArithmeticError

    private func fillArithmeticError(_ py: Py) {
      let type = self.arithmeticError
      type.setBuiltinTypeDoc(py, value: PyArithmeticError.doc)

      let __new__ = FunctionWrapper(type: type, fn: PyArithmeticError.__new__(_:type:args:kwargs:))
      self.add(py, type: type, name: "__new__", staticMethod: __new__, doc: nil)
      let __init__ = FunctionWrapper(type: type, fn: PyArithmeticError.__init__(_:zelf:args:kwargs:))
      self.add(py, type: type, name: "__init__", method: __init__, doc: nil)
    }

    internal static let arithmeticErrorStaticMethods = PyStaticCall.KnownNotOverriddenMethods()
    internal static let arithmeticErrorMemoryLayout = PyType.MemoryLayout()

    // MARK: - FloatingPointError

    private func fillFloatingPointError(_ py: Py) {
      let type = self.floatingPointError
      type.setBuiltinTypeDoc(py, value: PyFloatingPointError.doc)

      let __new__ = FunctionWrapper(type: type, fn: PyFloatingPointError.__new__(_:type:args:kwargs:))
      self.add(py, type: type, name: "__new__", staticMethod: __new__, doc: nil)
      let __init__ = FunctionWrapper(type: type, fn: PyFloatingPointError.__init__(_:zelf:args:kwargs:))
      self.add(py, type: type, name: "__init__", method: __init__, doc: nil)
    }

    internal static let floatingPointErrorStaticMethods = PyStaticCall.KnownNotOverriddenMethods()
    internal static let floatingPointErrorMemoryLayout = PyType.MemoryLayout()

    // MARK: - OverflowError

    private func fillOverflowError(_ py: Py) {
      let type = self.overflowError
      type.setBuiltinTypeDoc(py, value: PyOverflowError.doc)

      let __new__ = FunctionWrapper(type: type, fn: PyOverflowError.__new__(_:type:args:kwargs:))
      self.add(py, type: type, name: "__new__", staticMethod: __new__, doc: nil)
      let __init__ = FunctionWrapper(type: type, fn: PyOverflowError.__init__(_:zelf:args:kwargs:))
      self.add(py, type: type, name: "__init__", method: __init__, doc: nil)
    }

    internal static let overflowErrorStaticMethods = PyStaticCall.KnownNotOverriddenMethods()
    internal static let overflowErrorMemoryLayout = PyType.MemoryLayout()

    // MARK: - ZeroDivisionError

    private func fillZeroDivisionError(_ py: Py) {
      let type = self.zeroDivisionError
      type.setBuiltinTypeDoc(py, value: PyZeroDivisionError.doc)

      let __new__ = FunctionWrapper(type: type, fn: PyZeroDivisionError.__new__(_:type:args:kwargs:))
      self.add(py, type: type, name: "__new__", staticMethod: __new__, doc: nil)
      let __init__ = FunctionWrapper(type: type, fn: PyZeroDivisionError.__init__(_:zelf:args:kwargs:))
      self.add(py, type: type, name: "__init__", method: __init__, doc: nil)
    }

    internal static let zeroDivisionErrorStaticMethods = PyStaticCall.KnownNotOverriddenMethods()
    internal static let zeroDivisionErrorMemoryLayout = PyType.MemoryLayout()

    // MARK: - AssertionError

    private func fillAssertionError(_ py: Py) {
      let type = self.assertionError
      type.setBuiltinTypeDoc(py, value: PyAssertionError.doc)

      let __new__ = FunctionWrapper(type: type, fn: PyAssertionError.__new__(_:type:args:kwargs:))
      self.add(py, type: type, name: "__new__", staticMethod: __new__, doc: nil)
      let __init__ = FunctionWrapper(type: type, fn: PyAssertionError.__init__(_:zelf:args:kwargs:))
      self.add(py, type: type, name: "__init__", method: __init__, doc: nil)
    }

    internal static let assertionErrorStaticMethods = PyStaticCall.KnownNotOverriddenMethods()
    internal static let assertionErrorMemoryLayout = PyType.MemoryLayout()

    // MARK: - AttributeError

    private func fillAttributeError(_ py: Py) {
      let type = self.attributeError
      type.setBuiltinTypeDoc(py, value: PyAttributeError.doc)

      let __new__ = FunctionWrapper(type: type, fn: PyAttributeError.__new__(_:type:args:kwargs:))
      self.add(py, type: type, name: "__new__", staticMethod: __new__, doc: nil)
      let __init__ = FunctionWrapper(type: type, fn: PyAttributeError.__init__(_:zelf:args:kwargs:))
      self.add(py, type: type, name: "__init__", method: __init__, doc: nil)
    }

    internal static let attributeErrorStaticMethods = PyStaticCall.KnownNotOverriddenMethods()
    internal static let attributeErrorMemoryLayout = PyType.MemoryLayout()

    // MARK: - BufferError

    private func fillBufferError(_ py: Py) {
      let type = self.bufferError
      type.setBuiltinTypeDoc(py, value: PyBufferError.doc)

      let __new__ = FunctionWrapper(type: type, fn: PyBufferError.__new__(_:type:args:kwargs:))
      self.add(py, type: type, name: "__new__", staticMethod: __new__, doc: nil)
      let __init__ = FunctionWrapper(type: type, fn: PyBufferError.__init__(_:zelf:args:kwargs:))
      self.add(py, type: type, name: "__init__", method: __init__, doc: nil)
    }

    internal static let bufferErrorStaticMethods = PyStaticCall.KnownNotOverriddenMethods()
    internal static let bufferErrorMemoryLayout = PyType.MemoryLayout()

    // MARK: - EOFError

    private func fillEOFError(_ py: Py) {
      let type = self.eofError
      type.setBuiltinTypeDoc(py, value: PyEOFError.doc)

      let __new__ = FunctionWrapper(type: type, fn: PyEOFError.__new__(_:type:args:kwargs:))
      self.add(py, type: type, name: "__new__", staticMethod: __new__, doc: nil)
      let __init__ = FunctionWrapper(type: type, fn: PyEOFError.__init__(_:zelf:args:kwargs:))
      self.add(py, type: type, name: "__init__", method: __init__, doc: nil)
    }

    internal static let eOFErrorStaticMethods = PyStaticCall.KnownNotOverriddenMethods()
    internal static let eOFErrorMemoryLayout = PyType.MemoryLayout()

    // MARK: - ImportError

    private func fillImportError(_ py: Py) {
      let type = self.importError
      type.setBuiltinTypeDoc(py, value: PyImportError.importErrorDoc)

      let __new__ = FunctionWrapper(type: type, fn: PyImportError.__new__(_:type:args:kwargs:))
      self.add(py, type: type, name: "__new__", staticMethod: __new__, doc: nil)
      let __init__ = FunctionWrapper(type: type, fn: PyImportError.__init__(_:zelf:args:kwargs:))
      self.add(py, type: type, name: "__init__", method: __init__, doc: nil)
    }

    internal static let importErrorStaticMethods = PyStaticCall.KnownNotOverriddenMethods()
    internal static let importErrorMemoryLayout = PyType.MemoryLayout()

    // MARK: - ModuleNotFoundError

    private func fillModuleNotFoundError(_ py: Py) {
      let type = self.moduleNotFoundError
      type.setBuiltinTypeDoc(py, value: PyModuleNotFoundError.doc)

      let __new__ = FunctionWrapper(type: type, fn: PyModuleNotFoundError.__new__(_:type:args:kwargs:))
      self.add(py, type: type, name: "__new__", staticMethod: __new__, doc: nil)
      let __init__ = FunctionWrapper(type: type, fn: PyModuleNotFoundError.__init__(_:zelf:args:kwargs:))
      self.add(py, type: type, name: "__init__", method: __init__, doc: nil)
    }

    internal static let moduleNotFoundErrorStaticMethods = PyStaticCall.KnownNotOverriddenMethods()
    internal static let moduleNotFoundErrorMemoryLayout = PyType.MemoryLayout()

    // MARK: - LookupError

    private func fillLookupError(_ py: Py) {
      let type = self.lookupError
      type.setBuiltinTypeDoc(py, value: PyLookupError.doc)

      let __new__ = FunctionWrapper(type: type, fn: PyLookupError.__new__(_:type:args:kwargs:))
      self.add(py, type: type, name: "__new__", staticMethod: __new__, doc: nil)
      let __init__ = FunctionWrapper(type: type, fn: PyLookupError.__init__(_:zelf:args:kwargs:))
      self.add(py, type: type, name: "__init__", method: __init__, doc: nil)
    }

    internal static let lookupErrorStaticMethods = PyStaticCall.KnownNotOverriddenMethods()
    internal static let lookupErrorMemoryLayout = PyType.MemoryLayout()

    // MARK: - IndexError

    private func fillIndexError(_ py: Py) {
      let type = self.indexError
      type.setBuiltinTypeDoc(py, value: PyIndexError.doc)

      let __new__ = FunctionWrapper(type: type, fn: PyIndexError.__new__(_:type:args:kwargs:))
      self.add(py, type: type, name: "__new__", staticMethod: __new__, doc: nil)
      let __init__ = FunctionWrapper(type: type, fn: PyIndexError.__init__(_:zelf:args:kwargs:))
      self.add(py, type: type, name: "__init__", method: __init__, doc: nil)
    }

    internal static let indexErrorStaticMethods = PyStaticCall.KnownNotOverriddenMethods()
    internal static let indexErrorMemoryLayout = PyType.MemoryLayout()

    // MARK: - KeyError

    private func fillKeyError(_ py: Py) {
      let type = self.keyError
      type.setBuiltinTypeDoc(py, value: PyKeyError.keyErrorDoc)

      let __new__ = FunctionWrapper(type: type, fn: PyKeyError.__new__(_:type:args:kwargs:))
      self.add(py, type: type, name: "__new__", staticMethod: __new__, doc: nil)
      let __init__ = FunctionWrapper(type: type, fn: PyKeyError.__init__(_:zelf:args:kwargs:))
      self.add(py, type: type, name: "__init__", method: __init__, doc: nil)
    }

    internal static let keyErrorStaticMethods = PyStaticCall.KnownNotOverriddenMethods()
    internal static let keyErrorMemoryLayout = PyType.MemoryLayout()

    // MARK: - MemoryError

    private func fillMemoryError(_ py: Py) {
      let type = self.memoryError
      type.setBuiltinTypeDoc(py, value: PyMemoryError.doc)

      let __new__ = FunctionWrapper(type: type, fn: PyMemoryError.__new__(_:type:args:kwargs:))
      self.add(py, type: type, name: "__new__", staticMethod: __new__, doc: nil)
      let __init__ = FunctionWrapper(type: type, fn: PyMemoryError.__init__(_:zelf:args:kwargs:))
      self.add(py, type: type, name: "__init__", method: __init__, doc: nil)
    }

    internal static let memoryErrorStaticMethods = PyStaticCall.KnownNotOverriddenMethods()
    internal static let memoryErrorMemoryLayout = PyType.MemoryLayout()

    // MARK: - NameError

    private func fillNameError(_ py: Py) {
      let type = self.nameError
      type.setBuiltinTypeDoc(py, value: PyNameError.doc)

      let __new__ = FunctionWrapper(type: type, fn: PyNameError.__new__(_:type:args:kwargs:))
      self.add(py, type: type, name: "__new__", staticMethod: __new__, doc: nil)
      let __init__ = FunctionWrapper(type: type, fn: PyNameError.__init__(_:zelf:args:kwargs:))
      self.add(py, type: type, name: "__init__", method: __init__, doc: nil)
    }

    internal static let nameErrorStaticMethods = PyStaticCall.KnownNotOverriddenMethods()
    internal static let nameErrorMemoryLayout = PyType.MemoryLayout()

    // MARK: - UnboundLocalError

    private func fillUnboundLocalError(_ py: Py) {
      let type = self.unboundLocalError
      type.setBuiltinTypeDoc(py, value: PyUnboundLocalError.doc)

      let __new__ = FunctionWrapper(type: type, fn: PyUnboundLocalError.__new__(_:type:args:kwargs:))
      self.add(py, type: type, name: "__new__", staticMethod: __new__, doc: nil)
      let __init__ = FunctionWrapper(type: type, fn: PyUnboundLocalError.__init__(_:zelf:args:kwargs:))
      self.add(py, type: type, name: "__init__", method: __init__, doc: nil)
    }

    internal static let unboundLocalErrorStaticMethods = PyStaticCall.KnownNotOverriddenMethods()
    internal static let unboundLocalErrorMemoryLayout = PyType.MemoryLayout()

    // MARK: - OSError

    private func fillOSError(_ py: Py) {
      let type = self.osError
      type.setBuiltinTypeDoc(py, value: PyOSError.doc)

      let __new__ = FunctionWrapper(type: type, fn: PyOSError.__new__(_:type:args:kwargs:))
      self.add(py, type: type, name: "__new__", staticMethod: __new__, doc: nil)
      let __init__ = FunctionWrapper(type: type, fn: PyOSError.__init__(_:zelf:args:kwargs:))
      self.add(py, type: type, name: "__init__", method: __init__, doc: nil)
    }

    internal static let oSErrorStaticMethods = PyStaticCall.KnownNotOverriddenMethods()
    internal static let oSErrorMemoryLayout = PyType.MemoryLayout()

    // MARK: - BlockingIOError

    private func fillBlockingIOError(_ py: Py) {
      let type = self.blockingIOError
      type.setBuiltinTypeDoc(py, value: PyBlockingIOError.doc)

      let __new__ = FunctionWrapper(type: type, fn: PyBlockingIOError.__new__(_:type:args:kwargs:))
      self.add(py, type: type, name: "__new__", staticMethod: __new__, doc: nil)
      let __init__ = FunctionWrapper(type: type, fn: PyBlockingIOError.__init__(_:zelf:args:kwargs:))
      self.add(py, type: type, name: "__init__", method: __init__, doc: nil)
    }

    internal static let blockingIOErrorStaticMethods = PyStaticCall.KnownNotOverriddenMethods()
    internal static let blockingIOErrorMemoryLayout = PyType.MemoryLayout()

    // MARK: - ChildProcessError

    private func fillChildProcessError(_ py: Py) {
      let type = self.childProcessError
      type.setBuiltinTypeDoc(py, value: PyChildProcessError.doc)

      let __new__ = FunctionWrapper(type: type, fn: PyChildProcessError.__new__(_:type:args:kwargs:))
      self.add(py, type: type, name: "__new__", staticMethod: __new__, doc: nil)
      let __init__ = FunctionWrapper(type: type, fn: PyChildProcessError.__init__(_:zelf:args:kwargs:))
      self.add(py, type: type, name: "__init__", method: __init__, doc: nil)
    }

    internal static let childProcessErrorStaticMethods = PyStaticCall.KnownNotOverriddenMethods()
    internal static let childProcessErrorMemoryLayout = PyType.MemoryLayout()

    // MARK: - ConnectionError

    private func fillConnectionError(_ py: Py) {
      let type = self.connectionError
      type.setBuiltinTypeDoc(py, value: PyConnectionError.doc)

      let __new__ = FunctionWrapper(type: type, fn: PyConnectionError.__new__(_:type:args:kwargs:))
      self.add(py, type: type, name: "__new__", staticMethod: __new__, doc: nil)
      let __init__ = FunctionWrapper(type: type, fn: PyConnectionError.__init__(_:zelf:args:kwargs:))
      self.add(py, type: type, name: "__init__", method: __init__, doc: nil)
    }

    internal static let connectionErrorStaticMethods = PyStaticCall.KnownNotOverriddenMethods()
    internal static let connectionErrorMemoryLayout = PyType.MemoryLayout()

    // MARK: - BrokenPipeError

    private func fillBrokenPipeError(_ py: Py) {
      let type = self.brokenPipeError
      type.setBuiltinTypeDoc(py, value: PyBrokenPipeError.doc)

      let __new__ = FunctionWrapper(type: type, fn: PyBrokenPipeError.__new__(_:type:args:kwargs:))
      self.add(py, type: type, name: "__new__", staticMethod: __new__, doc: nil)
      let __init__ = FunctionWrapper(type: type, fn: PyBrokenPipeError.__init__(_:zelf:args:kwargs:))
      self.add(py, type: type, name: "__init__", method: __init__, doc: nil)
    }

    internal static let brokenPipeErrorStaticMethods = PyStaticCall.KnownNotOverriddenMethods()
    internal static let brokenPipeErrorMemoryLayout = PyType.MemoryLayout()

    // MARK: - ConnectionAbortedError

    private func fillConnectionAbortedError(_ py: Py) {
      let type = self.connectionAbortedError
      type.setBuiltinTypeDoc(py, value: PyConnectionAbortedError.doc)

      let __new__ = FunctionWrapper(type: type, fn: PyConnectionAbortedError.__new__(_:type:args:kwargs:))
      self.add(py, type: type, name: "__new__", staticMethod: __new__, doc: nil)
      let __init__ = FunctionWrapper(type: type, fn: PyConnectionAbortedError.__init__(_:zelf:args:kwargs:))
      self.add(py, type: type, name: "__init__", method: __init__, doc: nil)
    }

    internal static let connectionAbortedErrorStaticMethods = PyStaticCall.KnownNotOverriddenMethods()
    internal static let connectionAbortedErrorMemoryLayout = PyType.MemoryLayout()

    // MARK: - ConnectionRefusedError

    private func fillConnectionRefusedError(_ py: Py) {
      let type = self.connectionRefusedError
      type.setBuiltinTypeDoc(py, value: PyConnectionRefusedError.doc)

      let __new__ = FunctionWrapper(type: type, fn: PyConnectionRefusedError.__new__(_:type:args:kwargs:))
      self.add(py, type: type, name: "__new__", staticMethod: __new__, doc: nil)
      let __init__ = FunctionWrapper(type: type, fn: PyConnectionRefusedError.__init__(_:zelf:args:kwargs:))
      self.add(py, type: type, name: "__init__", method: __init__, doc: nil)
    }

    internal static let connectionRefusedErrorStaticMethods = PyStaticCall.KnownNotOverriddenMethods()
    internal static let connectionRefusedErrorMemoryLayout = PyType.MemoryLayout()

    // MARK: - ConnectionResetError

    private func fillConnectionResetError(_ py: Py) {
      let type = self.connectionResetError
      type.setBuiltinTypeDoc(py, value: PyConnectionResetError.doc)

      let __new__ = FunctionWrapper(type: type, fn: PyConnectionResetError.__new__(_:type:args:kwargs:))
      self.add(py, type: type, name: "__new__", staticMethod: __new__, doc: nil)
      let __init__ = FunctionWrapper(type: type, fn: PyConnectionResetError.__init__(_:zelf:args:kwargs:))
      self.add(py, type: type, name: "__init__", method: __init__, doc: nil)
    }

    internal static let connectionResetErrorStaticMethods = PyStaticCall.KnownNotOverriddenMethods()
    internal static let connectionResetErrorMemoryLayout = PyType.MemoryLayout()

    // MARK: - FileExistsError

    private func fillFileExistsError(_ py: Py) {
      let type = self.fileExistsError
      type.setBuiltinTypeDoc(py, value: PyFileExistsError.doc)

      let __new__ = FunctionWrapper(type: type, fn: PyFileExistsError.__new__(_:type:args:kwargs:))
      self.add(py, type: type, name: "__new__", staticMethod: __new__, doc: nil)
      let __init__ = FunctionWrapper(type: type, fn: PyFileExistsError.__init__(_:zelf:args:kwargs:))
      self.add(py, type: type, name: "__init__", method: __init__, doc: nil)
    }

    internal static let fileExistsErrorStaticMethods = PyStaticCall.KnownNotOverriddenMethods()
    internal static let fileExistsErrorMemoryLayout = PyType.MemoryLayout()

    // MARK: - FileNotFoundError

    private func fillFileNotFoundError(_ py: Py) {
      let type = self.fileNotFoundError
      type.setBuiltinTypeDoc(py, value: PyFileNotFoundError.doc)

      let __new__ = FunctionWrapper(type: type, fn: PyFileNotFoundError.__new__(_:type:args:kwargs:))
      self.add(py, type: type, name: "__new__", staticMethod: __new__, doc: nil)
      let __init__ = FunctionWrapper(type: type, fn: PyFileNotFoundError.__init__(_:zelf:args:kwargs:))
      self.add(py, type: type, name: "__init__", method: __init__, doc: nil)
    }

    internal static let fileNotFoundErrorStaticMethods = PyStaticCall.KnownNotOverriddenMethods()
    internal static let fileNotFoundErrorMemoryLayout = PyType.MemoryLayout()

    // MARK: - InterruptedError

    private func fillInterruptedError(_ py: Py) {
      let type = self.interruptedError
      type.setBuiltinTypeDoc(py, value: PyInterruptedError.doc)

      let __new__ = FunctionWrapper(type: type, fn: PyInterruptedError.__new__(_:type:args:kwargs:))
      self.add(py, type: type, name: "__new__", staticMethod: __new__, doc: nil)
      let __init__ = FunctionWrapper(type: type, fn: PyInterruptedError.__init__(_:zelf:args:kwargs:))
      self.add(py, type: type, name: "__init__", method: __init__, doc: nil)
    }

    internal static let interruptedErrorStaticMethods = PyStaticCall.KnownNotOverriddenMethods()
    internal static let interruptedErrorMemoryLayout = PyType.MemoryLayout()

    // MARK: - IsADirectoryError

    private func fillIsADirectoryError(_ py: Py) {
      let type = self.isADirectoryError
      type.setBuiltinTypeDoc(py, value: PyIsADirectoryError.doc)

      let __new__ = FunctionWrapper(type: type, fn: PyIsADirectoryError.__new__(_:type:args:kwargs:))
      self.add(py, type: type, name: "__new__", staticMethod: __new__, doc: nil)
      let __init__ = FunctionWrapper(type: type, fn: PyIsADirectoryError.__init__(_:zelf:args:kwargs:))
      self.add(py, type: type, name: "__init__", method: __init__, doc: nil)
    }

    internal static let isADirectoryErrorStaticMethods = PyStaticCall.KnownNotOverriddenMethods()
    internal static let isADirectoryErrorMemoryLayout = PyType.MemoryLayout()

    // MARK: - NotADirectoryError

    private func fillNotADirectoryError(_ py: Py) {
      let type = self.notADirectoryError
      type.setBuiltinTypeDoc(py, value: PyNotADirectoryError.doc)

      let __new__ = FunctionWrapper(type: type, fn: PyNotADirectoryError.__new__(_:type:args:kwargs:))
      self.add(py, type: type, name: "__new__", staticMethod: __new__, doc: nil)
      let __init__ = FunctionWrapper(type: type, fn: PyNotADirectoryError.__init__(_:zelf:args:kwargs:))
      self.add(py, type: type, name: "__init__", method: __init__, doc: nil)
    }

    internal static let notADirectoryErrorStaticMethods = PyStaticCall.KnownNotOverriddenMethods()
    internal static let notADirectoryErrorMemoryLayout = PyType.MemoryLayout()

    // MARK: - PermissionError

    private func fillPermissionError(_ py: Py) {
      let type = self.permissionError
      type.setBuiltinTypeDoc(py, value: PyPermissionError.doc)

      let __new__ = FunctionWrapper(type: type, fn: PyPermissionError.__new__(_:type:args:kwargs:))
      self.add(py, type: type, name: "__new__", staticMethod: __new__, doc: nil)
      let __init__ = FunctionWrapper(type: type, fn: PyPermissionError.__init__(_:zelf:args:kwargs:))
      self.add(py, type: type, name: "__init__", method: __init__, doc: nil)
    }

    internal static let permissionErrorStaticMethods = PyStaticCall.KnownNotOverriddenMethods()
    internal static let permissionErrorMemoryLayout = PyType.MemoryLayout()

    // MARK: - ProcessLookupError

    private func fillProcessLookupError(_ py: Py) {
      let type = self.processLookupError
      type.setBuiltinTypeDoc(py, value: PyProcessLookupError.doc)

      let __new__ = FunctionWrapper(type: type, fn: PyProcessLookupError.__new__(_:type:args:kwargs:))
      self.add(py, type: type, name: "__new__", staticMethod: __new__, doc: nil)
      let __init__ = FunctionWrapper(type: type, fn: PyProcessLookupError.__init__(_:zelf:args:kwargs:))
      self.add(py, type: type, name: "__init__", method: __init__, doc: nil)
    }

    internal static let processLookupErrorStaticMethods = PyStaticCall.KnownNotOverriddenMethods()
    internal static let processLookupErrorMemoryLayout = PyType.MemoryLayout()

    // MARK: - TimeoutError

    private func fillTimeoutError(_ py: Py) {
      let type = self.timeoutError
      type.setBuiltinTypeDoc(py, value: PyTimeoutError.doc)

      let __new__ = FunctionWrapper(type: type, fn: PyTimeoutError.__new__(_:type:args:kwargs:))
      self.add(py, type: type, name: "__new__", staticMethod: __new__, doc: nil)
      let __init__ = FunctionWrapper(type: type, fn: PyTimeoutError.__init__(_:zelf:args:kwargs:))
      self.add(py, type: type, name: "__init__", method: __init__, doc: nil)
    }

    internal static let timeoutErrorStaticMethods = PyStaticCall.KnownNotOverriddenMethods()
    internal static let timeoutErrorMemoryLayout = PyType.MemoryLayout()

    // MARK: - ReferenceError

    private func fillReferenceError(_ py: Py) {
      let type = self.referenceError
      type.setBuiltinTypeDoc(py, value: PyReferenceError.doc)

      let __new__ = FunctionWrapper(type: type, fn: PyReferenceError.__new__(_:type:args:kwargs:))
      self.add(py, type: type, name: "__new__", staticMethod: __new__, doc: nil)
      let __init__ = FunctionWrapper(type: type, fn: PyReferenceError.__init__(_:zelf:args:kwargs:))
      self.add(py, type: type, name: "__init__", method: __init__, doc: nil)
    }

    internal static let referenceErrorStaticMethods = PyStaticCall.KnownNotOverriddenMethods()
    internal static let referenceErrorMemoryLayout = PyType.MemoryLayout()

    // MARK: - RuntimeError

    private func fillRuntimeError(_ py: Py) {
      let type = self.runtimeError
      type.setBuiltinTypeDoc(py, value: PyRuntimeError.doc)

      let __new__ = FunctionWrapper(type: type, fn: PyRuntimeError.__new__(_:type:args:kwargs:))
      self.add(py, type: type, name: "__new__", staticMethod: __new__, doc: nil)
      let __init__ = FunctionWrapper(type: type, fn: PyRuntimeError.__init__(_:zelf:args:kwargs:))
      self.add(py, type: type, name: "__init__", method: __init__, doc: nil)
    }

    internal static let runtimeErrorStaticMethods = PyStaticCall.KnownNotOverriddenMethods()
    internal static let runtimeErrorMemoryLayout = PyType.MemoryLayout()

    // MARK: - NotImplementedError

    private func fillNotImplementedError(_ py: Py) {
      let type = self.notImplementedError
      type.setBuiltinTypeDoc(py, value: PyNotImplementedError.doc)

      let __new__ = FunctionWrapper(type: type, fn: PyNotImplementedError.__new__(_:type:args:kwargs:))
      self.add(py, type: type, name: "__new__", staticMethod: __new__, doc: nil)
      let __init__ = FunctionWrapper(type: type, fn: PyNotImplementedError.__init__(_:zelf:args:kwargs:))
      self.add(py, type: type, name: "__init__", method: __init__, doc: nil)
    }

    internal static let notImplementedErrorStaticMethods = PyStaticCall.KnownNotOverriddenMethods()
    internal static let notImplementedErrorMemoryLayout = PyType.MemoryLayout()

    // MARK: - RecursionError

    private func fillRecursionError(_ py: Py) {
      let type = self.recursionError
      type.setBuiltinTypeDoc(py, value: PyRecursionError.doc)

      let __new__ = FunctionWrapper(type: type, fn: PyRecursionError.__new__(_:type:args:kwargs:))
      self.add(py, type: type, name: "__new__", staticMethod: __new__, doc: nil)
      let __init__ = FunctionWrapper(type: type, fn: PyRecursionError.__init__(_:zelf:args:kwargs:))
      self.add(py, type: type, name: "__init__", method: __init__, doc: nil)
    }

    internal static let recursionErrorStaticMethods = PyStaticCall.KnownNotOverriddenMethods()
    internal static let recursionErrorMemoryLayout = PyType.MemoryLayout()

    // MARK: - SyntaxError

    private func fillSyntaxError(_ py: Py) {
      let type = self.syntaxError
      type.setBuiltinTypeDoc(py, value: PySyntaxError.syntaxErrorDoc)

      let __new__ = FunctionWrapper(type: type, fn: PySyntaxError.__new__(_:type:args:kwargs:))
      self.add(py, type: type, name: "__new__", staticMethod: __new__, doc: nil)
      let __init__ = FunctionWrapper(type: type, fn: PySyntaxError.__init__(_:zelf:args:kwargs:))
      self.add(py, type: type, name: "__init__", method: __init__, doc: nil)
    }

    internal static let syntaxErrorStaticMethods = PyStaticCall.KnownNotOverriddenMethods()
    internal static let syntaxErrorMemoryLayout = PyType.MemoryLayout()

    // MARK: - IndentationError

    private func fillIndentationError(_ py: Py) {
      let type = self.indentationError
      type.setBuiltinTypeDoc(py, value: PyIndentationError.doc)

      let __new__ = FunctionWrapper(type: type, fn: PyIndentationError.__new__(_:type:args:kwargs:))
      self.add(py, type: type, name: "__new__", staticMethod: __new__, doc: nil)
      let __init__ = FunctionWrapper(type: type, fn: PyIndentationError.__init__(_:zelf:args:kwargs:))
      self.add(py, type: type, name: "__init__", method: __init__, doc: nil)
    }

    internal static let indentationErrorStaticMethods = PyStaticCall.KnownNotOverriddenMethods()
    internal static let indentationErrorMemoryLayout = PyType.MemoryLayout()

    // MARK: - TabError

    private func fillTabError(_ py: Py) {
      let type = self.tabError
      type.setBuiltinTypeDoc(py, value: PyTabError.doc)

      let __new__ = FunctionWrapper(type: type, fn: PyTabError.__new__(_:type:args:kwargs:))
      self.add(py, type: type, name: "__new__", staticMethod: __new__, doc: nil)
      let __init__ = FunctionWrapper(type: type, fn: PyTabError.__init__(_:zelf:args:kwargs:))
      self.add(py, type: type, name: "__init__", method: __init__, doc: nil)
    }

    internal static let tabErrorStaticMethods = PyStaticCall.KnownNotOverriddenMethods()
    internal static let tabErrorMemoryLayout = PyType.MemoryLayout()

    // MARK: - SystemError

    private func fillSystemError(_ py: Py) {
      let type = self.systemError
      type.setBuiltinTypeDoc(py, value: PySystemError.doc)

      let __new__ = FunctionWrapper(type: type, fn: PySystemError.__new__(_:type:args:kwargs:))
      self.add(py, type: type, name: "__new__", staticMethod: __new__, doc: nil)
      let __init__ = FunctionWrapper(type: type, fn: PySystemError.__init__(_:zelf:args:kwargs:))
      self.add(py, type: type, name: "__init__", method: __init__, doc: nil)
    }

    internal static let systemErrorStaticMethods = PyStaticCall.KnownNotOverriddenMethods()
    internal static let systemErrorMemoryLayout = PyType.MemoryLayout()

    // MARK: - TypeError

    private func fillTypeError(_ py: Py) {
      let type = self.typeError
      type.setBuiltinTypeDoc(py, value: PyTypeError.doc)

      let __new__ = FunctionWrapper(type: type, fn: PyTypeError.__new__(_:type:args:kwargs:))
      self.add(py, type: type, name: "__new__", staticMethod: __new__, doc: nil)
      let __init__ = FunctionWrapper(type: type, fn: PyTypeError.__init__(_:zelf:args:kwargs:))
      self.add(py, type: type, name: "__init__", method: __init__, doc: nil)
    }

    internal static let typeErrorStaticMethods = PyStaticCall.KnownNotOverriddenMethods()
    internal static let typeErrorMemoryLayout = PyType.MemoryLayout()

    // MARK: - ValueError

    private func fillValueError(_ py: Py) {
      let type = self.valueError
      type.setBuiltinTypeDoc(py, value: PyValueError.doc)

      let __new__ = FunctionWrapper(type: type, fn: PyValueError.__new__(_:type:args:kwargs:))
      self.add(py, type: type, name: "__new__", staticMethod: __new__, doc: nil)
      let __init__ = FunctionWrapper(type: type, fn: PyValueError.__init__(_:zelf:args:kwargs:))
      self.add(py, type: type, name: "__init__", method: __init__, doc: nil)
    }

    internal static let valueErrorStaticMethods = PyStaticCall.KnownNotOverriddenMethods()
    internal static let valueErrorMemoryLayout = PyType.MemoryLayout()

    // MARK: - UnicodeError

    private func fillUnicodeError(_ py: Py) {
      let type = self.unicodeError
      type.setBuiltinTypeDoc(py, value: PyUnicodeError.doc)

      let __new__ = FunctionWrapper(type: type, fn: PyUnicodeError.__new__(_:type:args:kwargs:))
      self.add(py, type: type, name: "__new__", staticMethod: __new__, doc: nil)
      let __init__ = FunctionWrapper(type: type, fn: PyUnicodeError.__init__(_:zelf:args:kwargs:))
      self.add(py, type: type, name: "__init__", method: __init__, doc: nil)
    }

    internal static let unicodeErrorStaticMethods = PyStaticCall.KnownNotOverriddenMethods()
    internal static let unicodeErrorMemoryLayout = PyType.MemoryLayout()

    // MARK: - UnicodeDecodeError

    private func fillUnicodeDecodeError(_ py: Py) {
      let type = self.unicodeDecodeError
      type.setBuiltinTypeDoc(py, value: PyUnicodeDecodeError.doc)

      let __new__ = FunctionWrapper(type: type, fn: PyUnicodeDecodeError.__new__(_:type:args:kwargs:))
      self.add(py, type: type, name: "__new__", staticMethod: __new__, doc: nil)
      let __init__ = FunctionWrapper(type: type, fn: PyUnicodeDecodeError.__init__(_:zelf:args:kwargs:))
      self.add(py, type: type, name: "__init__", method: __init__, doc: nil)
    }

    internal static let unicodeDecodeErrorStaticMethods = PyStaticCall.KnownNotOverriddenMethods()
    internal static let unicodeDecodeErrorMemoryLayout = PyType.MemoryLayout()

    // MARK: - UnicodeEncodeError

    private func fillUnicodeEncodeError(_ py: Py) {
      let type = self.unicodeEncodeError
      type.setBuiltinTypeDoc(py, value: PyUnicodeEncodeError.doc)

      let __new__ = FunctionWrapper(type: type, fn: PyUnicodeEncodeError.__new__(_:type:args:kwargs:))
      self.add(py, type: type, name: "__new__", staticMethod: __new__, doc: nil)
      let __init__ = FunctionWrapper(type: type, fn: PyUnicodeEncodeError.__init__(_:zelf:args:kwargs:))
      self.add(py, type: type, name: "__init__", method: __init__, doc: nil)
    }

    internal static let unicodeEncodeErrorStaticMethods = PyStaticCall.KnownNotOverriddenMethods()
    internal static let unicodeEncodeErrorMemoryLayout = PyType.MemoryLayout()

    // MARK: - UnicodeTranslateError

    private func fillUnicodeTranslateError(_ py: Py) {
      let type = self.unicodeTranslateError
      type.setBuiltinTypeDoc(py, value: PyUnicodeTranslateError.doc)

      let __new__ = FunctionWrapper(type: type, fn: PyUnicodeTranslateError.__new__(_:type:args:kwargs:))
      self.add(py, type: type, name: "__new__", staticMethod: __new__, doc: nil)
      let __init__ = FunctionWrapper(type: type, fn: PyUnicodeTranslateError.__init__(_:zelf:args:kwargs:))
      self.add(py, type: type, name: "__init__", method: __init__, doc: nil)
    }

    internal static let unicodeTranslateErrorStaticMethods = PyStaticCall.KnownNotOverriddenMethods()
    internal static let unicodeTranslateErrorMemoryLayout = PyType.MemoryLayout()

    // MARK: - Warning

    private func fillWarning(_ py: Py) {
      let type = self.warning
      type.setBuiltinTypeDoc(py, value: PyWarning.doc)

      let __new__ = FunctionWrapper(type: type, fn: PyWarning.__new__(_:type:args:kwargs:))
      self.add(py, type: type, name: "__new__", staticMethod: __new__, doc: nil)
      let __init__ = FunctionWrapper(type: type, fn: PyWarning.__init__(_:zelf:args:kwargs:))
      self.add(py, type: type, name: "__init__", method: __init__, doc: nil)
    }

    internal static let warningStaticMethods = PyStaticCall.KnownNotOverriddenMethods()
    internal static let warningMemoryLayout = PyType.MemoryLayout()

    // MARK: - DeprecationWarning

    private func fillDeprecationWarning(_ py: Py) {
      let type = self.deprecationWarning
      type.setBuiltinTypeDoc(py, value: PyDeprecationWarning.doc)

      let __new__ = FunctionWrapper(type: type, fn: PyDeprecationWarning.__new__(_:type:args:kwargs:))
      self.add(py, type: type, name: "__new__", staticMethod: __new__, doc: nil)
      let __init__ = FunctionWrapper(type: type, fn: PyDeprecationWarning.__init__(_:zelf:args:kwargs:))
      self.add(py, type: type, name: "__init__", method: __init__, doc: nil)
    }

    internal static let deprecationWarningStaticMethods = PyStaticCall.KnownNotOverriddenMethods()
    internal static let deprecationWarningMemoryLayout = PyType.MemoryLayout()

    // MARK: - PendingDeprecationWarning

    private func fillPendingDeprecationWarning(_ py: Py) {
      let type = self.pendingDeprecationWarning
      type.setBuiltinTypeDoc(py, value: PyPendingDeprecationWarning.doc)

      let __new__ = FunctionWrapper(type: type, fn: PyPendingDeprecationWarning.__new__(_:type:args:kwargs:))
      self.add(py, type: type, name: "__new__", staticMethod: __new__, doc: nil)
      let __init__ = FunctionWrapper(type: type, fn: PyPendingDeprecationWarning.__init__(_:zelf:args:kwargs:))
      self.add(py, type: type, name: "__init__", method: __init__, doc: nil)
    }

    internal static let pendingDeprecationWarningStaticMethods = PyStaticCall.KnownNotOverriddenMethods()
    internal static let pendingDeprecationWarningMemoryLayout = PyType.MemoryLayout()

    // MARK: - RuntimeWarning

    private func fillRuntimeWarning(_ py: Py) {
      let type = self.runtimeWarning
      type.setBuiltinTypeDoc(py, value: PyRuntimeWarning.doc)

      let __new__ = FunctionWrapper(type: type, fn: PyRuntimeWarning.__new__(_:type:args:kwargs:))
      self.add(py, type: type, name: "__new__", staticMethod: __new__, doc: nil)
      let __init__ = FunctionWrapper(type: type, fn: PyRuntimeWarning.__init__(_:zelf:args:kwargs:))
      self.add(py, type: type, name: "__init__", method: __init__, doc: nil)
    }

    internal static let runtimeWarningStaticMethods = PyStaticCall.KnownNotOverriddenMethods()
    internal static let runtimeWarningMemoryLayout = PyType.MemoryLayout()

    // MARK: - SyntaxWarning

    private func fillSyntaxWarning(_ py: Py) {
      let type = self.syntaxWarning
      type.setBuiltinTypeDoc(py, value: PySyntaxWarning.doc)

      let __new__ = FunctionWrapper(type: type, fn: PySyntaxWarning.__new__(_:type:args:kwargs:))
      self.add(py, type: type, name: "__new__", staticMethod: __new__, doc: nil)
      let __init__ = FunctionWrapper(type: type, fn: PySyntaxWarning.__init__(_:zelf:args:kwargs:))
      self.add(py, type: type, name: "__init__", method: __init__, doc: nil)
    }

    internal static let syntaxWarningStaticMethods = PyStaticCall.KnownNotOverriddenMethods()
    internal static let syntaxWarningMemoryLayout = PyType.MemoryLayout()

    // MARK: - UserWarning

    private func fillUserWarning(_ py: Py) {
      let type = self.userWarning
      type.setBuiltinTypeDoc(py, value: PyUserWarning.doc)

      let __new__ = FunctionWrapper(type: type, fn: PyUserWarning.__new__(_:type:args:kwargs:))
      self.add(py, type: type, name: "__new__", staticMethod: __new__, doc: nil)
      let __init__ = FunctionWrapper(type: type, fn: PyUserWarning.__init__(_:zelf:args:kwargs:))
      self.add(py, type: type, name: "__init__", method: __init__, doc: nil)
    }

    internal static let userWarningStaticMethods = PyStaticCall.KnownNotOverriddenMethods()
    internal static let userWarningMemoryLayout = PyType.MemoryLayout()

    // MARK: - FutureWarning

    private func fillFutureWarning(_ py: Py) {
      let type = self.futureWarning
      type.setBuiltinTypeDoc(py, value: PyFutureWarning.doc)

      let __new__ = FunctionWrapper(type: type, fn: PyFutureWarning.__new__(_:type:args:kwargs:))
      self.add(py, type: type, name: "__new__", staticMethod: __new__, doc: nil)
      let __init__ = FunctionWrapper(type: type, fn: PyFutureWarning.__init__(_:zelf:args:kwargs:))
      self.add(py, type: type, name: "__init__", method: __init__, doc: nil)
    }

    internal static let futureWarningStaticMethods = PyStaticCall.KnownNotOverriddenMethods()
    internal static let futureWarningMemoryLayout = PyType.MemoryLayout()

    // MARK: - ImportWarning

    private func fillImportWarning(_ py: Py) {
      let type = self.importWarning
      type.setBuiltinTypeDoc(py, value: PyImportWarning.doc)

      let __new__ = FunctionWrapper(type: type, fn: PyImportWarning.__new__(_:type:args:kwargs:))
      self.add(py, type: type, name: "__new__", staticMethod: __new__, doc: nil)
      let __init__ = FunctionWrapper(type: type, fn: PyImportWarning.__init__(_:zelf:args:kwargs:))
      self.add(py, type: type, name: "__init__", method: __init__, doc: nil)
    }

    internal static let importWarningStaticMethods = PyStaticCall.KnownNotOverriddenMethods()
    internal static let importWarningMemoryLayout = PyType.MemoryLayout()

    // MARK: - UnicodeWarning

    private func fillUnicodeWarning(_ py: Py) {
      let type = self.unicodeWarning
      type.setBuiltinTypeDoc(py, value: PyUnicodeWarning.doc)

      let __new__ = FunctionWrapper(type: type, fn: PyUnicodeWarning.__new__(_:type:args:kwargs:))
      self.add(py, type: type, name: "__new__", staticMethod: __new__, doc: nil)
      let __init__ = FunctionWrapper(type: type, fn: PyUnicodeWarning.__init__(_:zelf:args:kwargs:))
      self.add(py, type: type, name: "__init__", method: __init__, doc: nil)
    }

    internal static let unicodeWarningStaticMethods = PyStaticCall.KnownNotOverriddenMethods()
    internal static let unicodeWarningMemoryLayout = PyType.MemoryLayout()

    // MARK: - BytesWarning

    private func fillBytesWarning(_ py: Py) {
      let type = self.bytesWarning
      type.setBuiltinTypeDoc(py, value: PyBytesWarning.doc)

      let __new__ = FunctionWrapper(type: type, fn: PyBytesWarning.__new__(_:type:args:kwargs:))
      self.add(py, type: type, name: "__new__", staticMethod: __new__, doc: nil)
      let __init__ = FunctionWrapper(type: type, fn: PyBytesWarning.__init__(_:zelf:args:kwargs:))
      self.add(py, type: type, name: "__init__", method: __init__, doc: nil)
    }

    internal static let bytesWarningStaticMethods = PyStaticCall.KnownNotOverriddenMethods()
    internal static let bytesWarningMemoryLayout = PyType.MemoryLayout()

    // MARK: - ResourceWarning

    private func fillResourceWarning(_ py: Py) {
      let type = self.resourceWarning
      type.setBuiltinTypeDoc(py, value: PyResourceWarning.doc)

      let __new__ = FunctionWrapper(type: type, fn: PyResourceWarning.__new__(_:type:args:kwargs:))
      self.add(py, type: type, name: "__new__", staticMethod: __new__, doc: nil)
      let __init__ = FunctionWrapper(type: type, fn: PyResourceWarning.__init__(_:zelf:args:kwargs:))
      self.add(py, type: type, name: "__init__", method: __init__, doc: nil)
    }

    internal static let resourceWarningStaticMethods = PyStaticCall.KnownNotOverriddenMethods()
    internal static let resourceWarningMemoryLayout = PyType.MemoryLayout()

  }
}
