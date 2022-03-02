// =====================================================================================
// Automatically generated from: ./Sources/Objects/Generated2/Py+ErrorTypeDefinitions.py
// Use 'make gen' in repository root to regenerate.
// DO NOT EDIT!
// =====================================================================================

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

    /// Adds value to `type.__dict__`.
    private func add<T: PyObjectMixin>(_ py: Py, type: PyType, name: String, value: T) {
      let __dict__ = type.header.__dict__
      let interned = py.intern(string: name)

      switch __dict__.set(key: interned, to: value.asObject) {
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
      type.setBuiltinTypeDoc(PyBaseException.doc)
    }

    internal static let baseExceptionStaticMethods = PyStaticCall.KnownNotOverriddenMethods()
    internal static let baseExceptionMemoryLayout = PyType.MemoryLayout()

    // MARK: - SystemExit

    private func fillSystemExit(_ py: Py) {
      let type = self.systemExit
      type.setBuiltinTypeDoc(PySystemExit.systemExitDoc)
    }

    internal static let systemExitStaticMethods = PyStaticCall.KnownNotOverriddenMethods()
    internal static let systemExitMemoryLayout = PyType.MemoryLayout()

    // MARK: - KeyboardInterrupt

    private func fillKeyboardInterrupt(_ py: Py) {
      let type = self.keyboardInterrupt
      type.setBuiltinTypeDoc(PyKeyboardInterrupt.doc)
    }

    internal static let keyboardInterruptStaticMethods = PyStaticCall.KnownNotOverriddenMethods()
    internal static let keyboardInterruptMemoryLayout = PyType.MemoryLayout()

    // MARK: - GeneratorExit

    private func fillGeneratorExit(_ py: Py) {
      let type = self.generatorExit
      type.setBuiltinTypeDoc(PyGeneratorExit.doc)
    }

    internal static let generatorExitStaticMethods = PyStaticCall.KnownNotOverriddenMethods()
    internal static let generatorExitMemoryLayout = PyType.MemoryLayout()

    // MARK: - Exception

    private func fillException(_ py: Py) {
      let type = self.exception
      type.setBuiltinTypeDoc(PyException.doc)
    }

    internal static let exceptionStaticMethods = PyStaticCall.KnownNotOverriddenMethods()
    internal static let exceptionMemoryLayout = PyType.MemoryLayout()

    // MARK: - StopIteration

    private func fillStopIteration(_ py: Py) {
      let type = self.stopIteration
      type.setBuiltinTypeDoc(PyStopIteration.stopIterationDoc)
    }

    internal static let stopIterationStaticMethods = PyStaticCall.KnownNotOverriddenMethods()
    internal static let stopIterationMemoryLayout = PyType.MemoryLayout()

    // MARK: - StopAsyncIteration

    private func fillStopAsyncIteration(_ py: Py) {
      let type = self.stopAsyncIteration
      type.setBuiltinTypeDoc(PyStopAsyncIteration.doc)
    }

    internal static let stopAsyncIterationStaticMethods = PyStaticCall.KnownNotOverriddenMethods()
    internal static let stopAsyncIterationMemoryLayout = PyType.MemoryLayout()

    // MARK: - ArithmeticError

    private func fillArithmeticError(_ py: Py) {
      let type = self.arithmeticError
      type.setBuiltinTypeDoc(PyArithmeticError.doc)
    }

    internal static let arithmeticErrorStaticMethods = PyStaticCall.KnownNotOverriddenMethods()
    internal static let arithmeticErrorMemoryLayout = PyType.MemoryLayout()

    // MARK: - FloatingPointError

    private func fillFloatingPointError(_ py: Py) {
      let type = self.floatingPointError
      type.setBuiltinTypeDoc(PyFloatingPointError.doc)
    }

    internal static let floatingPointErrorStaticMethods = PyStaticCall.KnownNotOverriddenMethods()
    internal static let floatingPointErrorMemoryLayout = PyType.MemoryLayout()

    // MARK: - OverflowError

    private func fillOverflowError(_ py: Py) {
      let type = self.overflowError
      type.setBuiltinTypeDoc(PyOverflowError.doc)
    }

    internal static let overflowErrorStaticMethods = PyStaticCall.KnownNotOverriddenMethods()
    internal static let overflowErrorMemoryLayout = PyType.MemoryLayout()

    // MARK: - ZeroDivisionError

    private func fillZeroDivisionError(_ py: Py) {
      let type = self.zeroDivisionError
      type.setBuiltinTypeDoc(PyZeroDivisionError.doc)
    }

    internal static let zeroDivisionErrorStaticMethods = PyStaticCall.KnownNotOverriddenMethods()
    internal static let zeroDivisionErrorMemoryLayout = PyType.MemoryLayout()

    // MARK: - AssertionError

    private func fillAssertionError(_ py: Py) {
      let type = self.assertionError
      type.setBuiltinTypeDoc(PyAssertionError.doc)
    }

    internal static let assertionErrorStaticMethods = PyStaticCall.KnownNotOverriddenMethods()
    internal static let assertionErrorMemoryLayout = PyType.MemoryLayout()

    // MARK: - AttributeError

    private func fillAttributeError(_ py: Py) {
      let type = self.attributeError
      type.setBuiltinTypeDoc(PyAttributeError.doc)
    }

    internal static let attributeErrorStaticMethods = PyStaticCall.KnownNotOverriddenMethods()
    internal static let attributeErrorMemoryLayout = PyType.MemoryLayout()

    // MARK: - BufferError

    private func fillBufferError(_ py: Py) {
      let type = self.bufferError
      type.setBuiltinTypeDoc(PyBufferError.doc)
    }

    internal static let bufferErrorStaticMethods = PyStaticCall.KnownNotOverriddenMethods()
    internal static let bufferErrorMemoryLayout = PyType.MemoryLayout()

    // MARK: - EOFError

    private func fillEOFError(_ py: Py) {
      let type = self.eofError
      type.setBuiltinTypeDoc(PyEOFError.doc)
    }

    internal static let eOFErrorStaticMethods = PyStaticCall.KnownNotOverriddenMethods()
    internal static let eOFErrorMemoryLayout = PyType.MemoryLayout()

    // MARK: - ImportError

    private func fillImportError(_ py: Py) {
      let type = self.importError
      type.setBuiltinTypeDoc(PyImportError.importErrorDoc)
    }

    internal static let importErrorStaticMethods = PyStaticCall.KnownNotOverriddenMethods()
    internal static let importErrorMemoryLayout = PyType.MemoryLayout()

    // MARK: - ModuleNotFoundError

    private func fillModuleNotFoundError(_ py: Py) {
      let type = self.moduleNotFoundError
      type.setBuiltinTypeDoc(PyModuleNotFoundError.doc)
    }

    internal static let moduleNotFoundErrorStaticMethods = PyStaticCall.KnownNotOverriddenMethods()
    internal static let moduleNotFoundErrorMemoryLayout = PyType.MemoryLayout()

    // MARK: - LookupError

    private func fillLookupError(_ py: Py) {
      let type = self.lookupError
      type.setBuiltinTypeDoc(PyLookupError.doc)
    }

    internal static let lookupErrorStaticMethods = PyStaticCall.KnownNotOverriddenMethods()
    internal static let lookupErrorMemoryLayout = PyType.MemoryLayout()

    // MARK: - IndexError

    private func fillIndexError(_ py: Py) {
      let type = self.indexError
      type.setBuiltinTypeDoc(PyIndexError.doc)
    }

    internal static let indexErrorStaticMethods = PyStaticCall.KnownNotOverriddenMethods()
    internal static let indexErrorMemoryLayout = PyType.MemoryLayout()

    // MARK: - KeyError

    private func fillKeyError(_ py: Py) {
      let type = self.keyError
      type.setBuiltinTypeDoc(PyKeyError.keyErrorDoc)
    }

    internal static let keyErrorStaticMethods = PyStaticCall.KnownNotOverriddenMethods()
    internal static let keyErrorMemoryLayout = PyType.MemoryLayout()

    // MARK: - MemoryError

    private func fillMemoryError(_ py: Py) {
      let type = self.memoryError
      type.setBuiltinTypeDoc(PyMemoryError.doc)
    }

    internal static let memoryErrorStaticMethods = PyStaticCall.KnownNotOverriddenMethods()
    internal static let memoryErrorMemoryLayout = PyType.MemoryLayout()

    // MARK: - NameError

    private func fillNameError(_ py: Py) {
      let type = self.nameError
      type.setBuiltinTypeDoc(PyNameError.doc)
    }

    internal static let nameErrorStaticMethods = PyStaticCall.KnownNotOverriddenMethods()
    internal static let nameErrorMemoryLayout = PyType.MemoryLayout()

    // MARK: - UnboundLocalError

    private func fillUnboundLocalError(_ py: Py) {
      let type = self.unboundLocalError
      type.setBuiltinTypeDoc(PyUnboundLocalError.doc)
    }

    internal static let unboundLocalErrorStaticMethods = PyStaticCall.KnownNotOverriddenMethods()
    internal static let unboundLocalErrorMemoryLayout = PyType.MemoryLayout()

    // MARK: - OSError

    private func fillOSError(_ py: Py) {
      let type = self.osError
      type.setBuiltinTypeDoc(PyOSError.doc)
    }

    internal static let oSErrorStaticMethods = PyStaticCall.KnownNotOverriddenMethods()
    internal static let oSErrorMemoryLayout = PyType.MemoryLayout()

    // MARK: - BlockingIOError

    private func fillBlockingIOError(_ py: Py) {
      let type = self.blockingIOError
      type.setBuiltinTypeDoc(PyBlockingIOError.doc)
    }

    internal static let blockingIOErrorStaticMethods = PyStaticCall.KnownNotOverriddenMethods()
    internal static let blockingIOErrorMemoryLayout = PyType.MemoryLayout()

    // MARK: - ChildProcessError

    private func fillChildProcessError(_ py: Py) {
      let type = self.childProcessError
      type.setBuiltinTypeDoc(PyChildProcessError.doc)
    }

    internal static let childProcessErrorStaticMethods = PyStaticCall.KnownNotOverriddenMethods()
    internal static let childProcessErrorMemoryLayout = PyType.MemoryLayout()

    // MARK: - ConnectionError

    private func fillConnectionError(_ py: Py) {
      let type = self.connectionError
      type.setBuiltinTypeDoc(PyConnectionError.doc)
    }

    internal static let connectionErrorStaticMethods = PyStaticCall.KnownNotOverriddenMethods()
    internal static let connectionErrorMemoryLayout = PyType.MemoryLayout()

    // MARK: - BrokenPipeError

    private func fillBrokenPipeError(_ py: Py) {
      let type = self.brokenPipeError
      type.setBuiltinTypeDoc(PyBrokenPipeError.doc)
    }

    internal static let brokenPipeErrorStaticMethods = PyStaticCall.KnownNotOverriddenMethods()
    internal static let brokenPipeErrorMemoryLayout = PyType.MemoryLayout()

    // MARK: - ConnectionAbortedError

    private func fillConnectionAbortedError(_ py: Py) {
      let type = self.connectionAbortedError
      type.setBuiltinTypeDoc(PyConnectionAbortedError.doc)
    }

    internal static let connectionAbortedErrorStaticMethods = PyStaticCall.KnownNotOverriddenMethods()
    internal static let connectionAbortedErrorMemoryLayout = PyType.MemoryLayout()

    // MARK: - ConnectionRefusedError

    private func fillConnectionRefusedError(_ py: Py) {
      let type = self.connectionRefusedError
      type.setBuiltinTypeDoc(PyConnectionRefusedError.doc)
    }

    internal static let connectionRefusedErrorStaticMethods = PyStaticCall.KnownNotOverriddenMethods()
    internal static let connectionRefusedErrorMemoryLayout = PyType.MemoryLayout()

    // MARK: - ConnectionResetError

    private func fillConnectionResetError(_ py: Py) {
      let type = self.connectionResetError
      type.setBuiltinTypeDoc(PyConnectionResetError.doc)
    }

    internal static let connectionResetErrorStaticMethods = PyStaticCall.KnownNotOverriddenMethods()
    internal static let connectionResetErrorMemoryLayout = PyType.MemoryLayout()

    // MARK: - FileExistsError

    private func fillFileExistsError(_ py: Py) {
      let type = self.fileExistsError
      type.setBuiltinTypeDoc(PyFileExistsError.doc)
    }

    internal static let fileExistsErrorStaticMethods = PyStaticCall.KnownNotOverriddenMethods()
    internal static let fileExistsErrorMemoryLayout = PyType.MemoryLayout()

    // MARK: - FileNotFoundError

    private func fillFileNotFoundError(_ py: Py) {
      let type = self.fileNotFoundError
      type.setBuiltinTypeDoc(PyFileNotFoundError.doc)
    }

    internal static let fileNotFoundErrorStaticMethods = PyStaticCall.KnownNotOverriddenMethods()
    internal static let fileNotFoundErrorMemoryLayout = PyType.MemoryLayout()

    // MARK: - InterruptedError

    private func fillInterruptedError(_ py: Py) {
      let type = self.interruptedError
      type.setBuiltinTypeDoc(PyInterruptedError.doc)
    }

    internal static let interruptedErrorStaticMethods = PyStaticCall.KnownNotOverriddenMethods()
    internal static let interruptedErrorMemoryLayout = PyType.MemoryLayout()

    // MARK: - IsADirectoryError

    private func fillIsADirectoryError(_ py: Py) {
      let type = self.isADirectoryError
      type.setBuiltinTypeDoc(PyIsADirectoryError.doc)
    }

    internal static let isADirectoryErrorStaticMethods = PyStaticCall.KnownNotOverriddenMethods()
    internal static let isADirectoryErrorMemoryLayout = PyType.MemoryLayout()

    // MARK: - NotADirectoryError

    private func fillNotADirectoryError(_ py: Py) {
      let type = self.notADirectoryError
      type.setBuiltinTypeDoc(PyNotADirectoryError.doc)
    }

    internal static let notADirectoryErrorStaticMethods = PyStaticCall.KnownNotOverriddenMethods()
    internal static let notADirectoryErrorMemoryLayout = PyType.MemoryLayout()

    // MARK: - PermissionError

    private func fillPermissionError(_ py: Py) {
      let type = self.permissionError
      type.setBuiltinTypeDoc(PyPermissionError.doc)
    }

    internal static let permissionErrorStaticMethods = PyStaticCall.KnownNotOverriddenMethods()
    internal static let permissionErrorMemoryLayout = PyType.MemoryLayout()

    // MARK: - ProcessLookupError

    private func fillProcessLookupError(_ py: Py) {
      let type = self.processLookupError
      type.setBuiltinTypeDoc(PyProcessLookupError.doc)
    }

    internal static let processLookupErrorStaticMethods = PyStaticCall.KnownNotOverriddenMethods()
    internal static let processLookupErrorMemoryLayout = PyType.MemoryLayout()

    // MARK: - TimeoutError

    private func fillTimeoutError(_ py: Py) {
      let type = self.timeoutError
      type.setBuiltinTypeDoc(PyTimeoutError.doc)
    }

    internal static let timeoutErrorStaticMethods = PyStaticCall.KnownNotOverriddenMethods()
    internal static let timeoutErrorMemoryLayout = PyType.MemoryLayout()

    // MARK: - ReferenceError

    private func fillReferenceError(_ py: Py) {
      let type = self.referenceError
      type.setBuiltinTypeDoc(PyReferenceError.doc)
    }

    internal static let referenceErrorStaticMethods = PyStaticCall.KnownNotOverriddenMethods()
    internal static let referenceErrorMemoryLayout = PyType.MemoryLayout()

    // MARK: - RuntimeError

    private func fillRuntimeError(_ py: Py) {
      let type = self.runtimeError
      type.setBuiltinTypeDoc(PyRuntimeError.doc)
    }

    internal static let runtimeErrorStaticMethods = PyStaticCall.KnownNotOverriddenMethods()
    internal static let runtimeErrorMemoryLayout = PyType.MemoryLayout()

    // MARK: - NotImplementedError

    private func fillNotImplementedError(_ py: Py) {
      let type = self.notImplementedError
      type.setBuiltinTypeDoc(PyNotImplementedError.doc)
    }

    internal static let notImplementedErrorStaticMethods = PyStaticCall.KnownNotOverriddenMethods()
    internal static let notImplementedErrorMemoryLayout = PyType.MemoryLayout()

    // MARK: - RecursionError

    private func fillRecursionError(_ py: Py) {
      let type = self.recursionError
      type.setBuiltinTypeDoc(PyRecursionError.doc)
    }

    internal static let recursionErrorStaticMethods = PyStaticCall.KnownNotOverriddenMethods()
    internal static let recursionErrorMemoryLayout = PyType.MemoryLayout()

    // MARK: - SyntaxError

    private func fillSyntaxError(_ py: Py) {
      let type = self.syntaxError
      type.setBuiltinTypeDoc(PySyntaxError.syntaxErrorDoc)
    }

    internal static let syntaxErrorStaticMethods = PyStaticCall.KnownNotOverriddenMethods()
    internal static let syntaxErrorMemoryLayout = PyType.MemoryLayout()

    // MARK: - IndentationError

    private func fillIndentationError(_ py: Py) {
      let type = self.indentationError
      type.setBuiltinTypeDoc(PyIndentationError.doc)
    }

    internal static let indentationErrorStaticMethods = PyStaticCall.KnownNotOverriddenMethods()
    internal static let indentationErrorMemoryLayout = PyType.MemoryLayout()

    // MARK: - TabError

    private func fillTabError(_ py: Py) {
      let type = self.tabError
      type.setBuiltinTypeDoc(PyTabError.doc)
    }

    internal static let tabErrorStaticMethods = PyStaticCall.KnownNotOverriddenMethods()
    internal static let tabErrorMemoryLayout = PyType.MemoryLayout()

    // MARK: - SystemError

    private func fillSystemError(_ py: Py) {
      let type = self.systemError
      type.setBuiltinTypeDoc(PySystemError.doc)
    }

    internal static let systemErrorStaticMethods = PyStaticCall.KnownNotOverriddenMethods()
    internal static let systemErrorMemoryLayout = PyType.MemoryLayout()

    // MARK: - TypeError

    private func fillTypeError(_ py: Py) {
      let type = self.typeError
      type.setBuiltinTypeDoc(PyTypeError.doc)
    }

    internal static let typeErrorStaticMethods = PyStaticCall.KnownNotOverriddenMethods()
    internal static let typeErrorMemoryLayout = PyType.MemoryLayout()

    // MARK: - ValueError

    private func fillValueError(_ py: Py) {
      let type = self.valueError
      type.setBuiltinTypeDoc(PyValueError.doc)
    }

    internal static let valueErrorStaticMethods = PyStaticCall.KnownNotOverriddenMethods()
    internal static let valueErrorMemoryLayout = PyType.MemoryLayout()

    // MARK: - UnicodeError

    private func fillUnicodeError(_ py: Py) {
      let type = self.unicodeError
      type.setBuiltinTypeDoc(PyUnicodeError.doc)
    }

    internal static let unicodeErrorStaticMethods = PyStaticCall.KnownNotOverriddenMethods()
    internal static let unicodeErrorMemoryLayout = PyType.MemoryLayout()

    // MARK: - UnicodeDecodeError

    private func fillUnicodeDecodeError(_ py: Py) {
      let type = self.unicodeDecodeError
      type.setBuiltinTypeDoc(PyUnicodeDecodeError.doc)
    }

    internal static let unicodeDecodeErrorStaticMethods = PyStaticCall.KnownNotOverriddenMethods()
    internal static let unicodeDecodeErrorMemoryLayout = PyType.MemoryLayout()

    // MARK: - UnicodeEncodeError

    private func fillUnicodeEncodeError(_ py: Py) {
      let type = self.unicodeEncodeError
      type.setBuiltinTypeDoc(PyUnicodeEncodeError.doc)
    }

    internal static let unicodeEncodeErrorStaticMethods = PyStaticCall.KnownNotOverriddenMethods()
    internal static let unicodeEncodeErrorMemoryLayout = PyType.MemoryLayout()

    // MARK: - UnicodeTranslateError

    private func fillUnicodeTranslateError(_ py: Py) {
      let type = self.unicodeTranslateError
      type.setBuiltinTypeDoc(PyUnicodeTranslateError.doc)
    }

    internal static let unicodeTranslateErrorStaticMethods = PyStaticCall.KnownNotOverriddenMethods()
    internal static let unicodeTranslateErrorMemoryLayout = PyType.MemoryLayout()

    // MARK: - Warning

    private func fillWarning(_ py: Py) {
      let type = self.warning
      type.setBuiltinTypeDoc(PyWarning.doc)
    }

    internal static let warningStaticMethods = PyStaticCall.KnownNotOverriddenMethods()
    internal static let warningMemoryLayout = PyType.MemoryLayout()

    // MARK: - DeprecationWarning

    private func fillDeprecationWarning(_ py: Py) {
      let type = self.deprecationWarning
      type.setBuiltinTypeDoc(PyDeprecationWarning.doc)
    }

    internal static let deprecationWarningStaticMethods = PyStaticCall.KnownNotOverriddenMethods()
    internal static let deprecationWarningMemoryLayout = PyType.MemoryLayout()

    // MARK: - PendingDeprecationWarning

    private func fillPendingDeprecationWarning(_ py: Py) {
      let type = self.pendingDeprecationWarning
      type.setBuiltinTypeDoc(PyPendingDeprecationWarning.doc)
    }

    internal static let pendingDeprecationWarningStaticMethods = PyStaticCall.KnownNotOverriddenMethods()
    internal static let pendingDeprecationWarningMemoryLayout = PyType.MemoryLayout()

    // MARK: - RuntimeWarning

    private func fillRuntimeWarning(_ py: Py) {
      let type = self.runtimeWarning
      type.setBuiltinTypeDoc(PyRuntimeWarning.doc)
    }

    internal static let runtimeWarningStaticMethods = PyStaticCall.KnownNotOverriddenMethods()
    internal static let runtimeWarningMemoryLayout = PyType.MemoryLayout()

    // MARK: - SyntaxWarning

    private func fillSyntaxWarning(_ py: Py) {
      let type = self.syntaxWarning
      type.setBuiltinTypeDoc(PySyntaxWarning.doc)
    }

    internal static let syntaxWarningStaticMethods = PyStaticCall.KnownNotOverriddenMethods()
    internal static let syntaxWarningMemoryLayout = PyType.MemoryLayout()

    // MARK: - UserWarning

    private func fillUserWarning(_ py: Py) {
      let type = self.userWarning
      type.setBuiltinTypeDoc(PyUserWarning.doc)
    }

    internal static let userWarningStaticMethods = PyStaticCall.KnownNotOverriddenMethods()
    internal static let userWarningMemoryLayout = PyType.MemoryLayout()

    // MARK: - FutureWarning

    private func fillFutureWarning(_ py: Py) {
      let type = self.futureWarning
      type.setBuiltinTypeDoc(PyFutureWarning.doc)
    }

    internal static let futureWarningStaticMethods = PyStaticCall.KnownNotOverriddenMethods()
    internal static let futureWarningMemoryLayout = PyType.MemoryLayout()

    // MARK: - ImportWarning

    private func fillImportWarning(_ py: Py) {
      let type = self.importWarning
      type.setBuiltinTypeDoc(PyImportWarning.doc)
    }

    internal static let importWarningStaticMethods = PyStaticCall.KnownNotOverriddenMethods()
    internal static let importWarningMemoryLayout = PyType.MemoryLayout()

    // MARK: - UnicodeWarning

    private func fillUnicodeWarning(_ py: Py) {
      let type = self.unicodeWarning
      type.setBuiltinTypeDoc(PyUnicodeWarning.doc)
    }

    internal static let unicodeWarningStaticMethods = PyStaticCall.KnownNotOverriddenMethods()
    internal static let unicodeWarningMemoryLayout = PyType.MemoryLayout()

    // MARK: - BytesWarning

    private func fillBytesWarning(_ py: Py) {
      let type = self.bytesWarning
      type.setBuiltinTypeDoc(PyBytesWarning.doc)
    }

    internal static let bytesWarningStaticMethods = PyStaticCall.KnownNotOverriddenMethods()
    internal static let bytesWarningMemoryLayout = PyType.MemoryLayout()

    // MARK: - ResourceWarning

    private func fillResourceWarning(_ py: Py) {
      let type = self.resourceWarning
      type.setBuiltinTypeDoc(PyResourceWarning.doc)
    }

    internal static let resourceWarningStaticMethods = PyStaticCall.KnownNotOverriddenMethods()
    internal static let resourceWarningMemoryLayout = PyType.MemoryLayout()

  }
}
