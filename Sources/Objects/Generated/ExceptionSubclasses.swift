// ================================================================================
// Automatically generated from: ./Sources/Objects/Generated/ExceptionSubclasses.py
// DO NOT EDIT!
// ================================================================================

// swiftlint:disable line_length
// swiftlint:disable trailing_newline
// swiftlint:disable file_length

// In CPython:
// Objects -> exceptions.c
// Lib->test->exception_hierarchy.txt <-- this is amazing
// https://docs.python.org/3.7/library/exceptions.html
// https://docs.python.org/3.7/c-api/exceptions.html

// MARK: - KeyboardInterrupt

// sourcery: pyerrortype = KeyboardInterrupt, default, baseType, hasGC, baseExceptionSubclass
public final class PyKeyboardInterrupt: PyBaseException {

  // sourcery: pytypedoc
  internal static let keyboardInterruptDoc = "Program interrupted by user."

  /// Type to set in `init`.
  override internal class var pythonType: PyType {
    return Py.errorTypes.keyboardInterrupt
  }

  // sourcery: pyproperty = __class__
  internal static func getClass(keyboardInterrupt: PyKeyboardInterrupt) -> PyType {
    return keyboardInterrupt.type
  }

  // sourcery: pyproperty = __dict__
  internal static func getDict(keyboardInterrupt: PyKeyboardInterrupt) -> PyDict {
    return keyboardInterrupt.__dict__
  }

  // sourcery: pystaticmethod = __new__
  internal static func pyKeyboardInterruptNew(
    type: PyType,
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyKeyboardInterrupt> {
    let argsTuple = Py.newTuple(elements: args)
    let result = PyKeyboardInterrupt(args: argsTuple, type: type)
    return .value(result)
  }

  // sourcery: pymethod = __init__
  internal func pyKeyboardInterruptInit(
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyNone> {
    return self.pyBaseExceptionInit(args: args, kwargs: kwargs)
  }
}

// MARK: - GeneratorExit

// sourcery: pyerrortype = GeneratorExit, default, baseType, hasGC, baseExceptionSubclass
public final class PyGeneratorExit: PyBaseException {

  // sourcery: pytypedoc
  internal static let generatorExitDoc = "Request that a generator exit."

  /// Type to set in `init`.
  override internal class var pythonType: PyType {
    return Py.errorTypes.generatorExit
  }

  // sourcery: pyproperty = __class__
  internal static func getClass(generatorExit: PyGeneratorExit) -> PyType {
    return generatorExit.type
  }

  // sourcery: pyproperty = __dict__
  internal static func getDict(generatorExit: PyGeneratorExit) -> PyDict {
    return generatorExit.__dict__
  }

  // sourcery: pystaticmethod = __new__
  internal static func pyGeneratorExitNew(
    type: PyType,
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyGeneratorExit> {
    let argsTuple = Py.newTuple(elements: args)
    let result = PyGeneratorExit(args: argsTuple, type: type)
    return .value(result)
  }

  // sourcery: pymethod = __init__
  internal func pyGeneratorExitInit(
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyNone> {
    return self.pyBaseExceptionInit(args: args, kwargs: kwargs)
  }
}

// MARK: - Exception

// sourcery: pyerrortype = Exception, default, baseType, hasGC, baseExceptionSubclass
public class PyException: PyBaseException {

  // sourcery: pytypedoc
  internal static let exceptionDoc = "Common base class for all non-exit exceptions."

  /// Type to set in `init`.
  override internal class var pythonType: PyType {
    return Py.errorTypes.exception
  }

  // sourcery: pyproperty = __class__
  internal static func getClass(exception: PyException) -> PyType {
    return exception.type
  }

  // sourcery: pyproperty = __dict__
  internal static func getDict(exception: PyException) -> PyDict {
    return exception.__dict__
  }

  // sourcery: pystaticmethod = __new__
  internal static func pyExceptionNew(
    type: PyType,
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyException> {
    let argsTuple = Py.newTuple(elements: args)
    let result = PyException(args: argsTuple, type: type)
    return .value(result)
  }

  // sourcery: pymethod = __init__
  internal func pyExceptionInit(
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyNone> {
    return self.pyBaseExceptionInit(args: args, kwargs: kwargs)
  }
}

// MARK: - StopAsyncIteration

// sourcery: pyerrortype = StopAsyncIteration, default, baseType, hasGC, baseExceptionSubclass
public final class PyStopAsyncIteration: PyException {

  // sourcery: pytypedoc
  internal static let stopAsyncIterationDoc = "Signal the end from iterator.__anext__()."

  /// Type to set in `init`.
  override internal class var pythonType: PyType {
    return Py.errorTypes.stopAsyncIteration
  }

  // sourcery: pyproperty = __class__
  internal static func getClass(stopAsyncIteration: PyStopAsyncIteration) -> PyType {
    return stopAsyncIteration.type
  }

  // sourcery: pyproperty = __dict__
  internal static func getDict(stopAsyncIteration: PyStopAsyncIteration) -> PyDict {
    return stopAsyncIteration.__dict__
  }

  // sourcery: pystaticmethod = __new__
  internal static func pyStopAsyncIterationNew(
    type: PyType,
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyStopAsyncIteration> {
    let argsTuple = Py.newTuple(elements: args)
    let result = PyStopAsyncIteration(args: argsTuple, type: type)
    return .value(result)
  }

  // sourcery: pymethod = __init__
  internal func pyStopAsyncIterationInit(
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyNone> {
    return self.pyExceptionInit(args: args, kwargs: kwargs)
  }
}

// MARK: - ArithmeticError

// sourcery: pyerrortype = ArithmeticError, default, baseType, hasGC, baseExceptionSubclass
public class PyArithmeticError: PyException {

  // sourcery: pytypedoc
  internal static let arithmeticErrorDoc = "Base class for arithmetic errors."

  /// Type to set in `init`.
  override internal class var pythonType: PyType {
    return Py.errorTypes.arithmeticError
  }

  // sourcery: pyproperty = __class__
  internal static func getClass(arithmeticError: PyArithmeticError) -> PyType {
    return arithmeticError.type
  }

  // sourcery: pyproperty = __dict__
  internal static func getDict(arithmeticError: PyArithmeticError) -> PyDict {
    return arithmeticError.__dict__
  }

  // sourcery: pystaticmethod = __new__
  internal static func pyArithmeticErrorNew(
    type: PyType,
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyArithmeticError> {
    let argsTuple = Py.newTuple(elements: args)
    let result = PyArithmeticError(args: argsTuple, type: type)
    return .value(result)
  }

  // sourcery: pymethod = __init__
  internal func pyArithmeticErrorInit(
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyNone> {
    return self.pyExceptionInit(args: args, kwargs: kwargs)
  }
}

// MARK: - FloatingPointError

// sourcery: pyerrortype = FloatingPointError, default, baseType, hasGC, baseExceptionSubclass
public final class PyFloatingPointError: PyArithmeticError {

  // sourcery: pytypedoc
  internal static let floatingPointErrorDoc = "Floating point operation failed."

  /// Type to set in `init`.
  override internal class var pythonType: PyType {
    return Py.errorTypes.floatingPointError
  }

  // sourcery: pyproperty = __class__
  internal static func getClass(floatingPointError: PyFloatingPointError) -> PyType {
    return floatingPointError.type
  }

  // sourcery: pyproperty = __dict__
  internal static func getDict(floatingPointError: PyFloatingPointError) -> PyDict {
    return floatingPointError.__dict__
  }

  // sourcery: pystaticmethod = __new__
  internal static func pyFloatingPointErrorNew(
    type: PyType,
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyFloatingPointError> {
    let argsTuple = Py.newTuple(elements: args)
    let result = PyFloatingPointError(args: argsTuple, type: type)
    return .value(result)
  }

  // sourcery: pymethod = __init__
  internal func pyFloatingPointErrorInit(
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyNone> {
    return self.pyArithmeticErrorInit(args: args, kwargs: kwargs)
  }
}

// MARK: - OverflowError

// sourcery: pyerrortype = OverflowError, default, baseType, hasGC, baseExceptionSubclass
public final class PyOverflowError: PyArithmeticError {

  // sourcery: pytypedoc
  internal static let overflowErrorDoc = "Result too large to be represented."

  /// Type to set in `init`.
  override internal class var pythonType: PyType {
    return Py.errorTypes.overflowError
  }

  // sourcery: pyproperty = __class__
  internal static func getClass(overflowError: PyOverflowError) -> PyType {
    return overflowError.type
  }

  // sourcery: pyproperty = __dict__
  internal static func getDict(overflowError: PyOverflowError) -> PyDict {
    return overflowError.__dict__
  }

  // sourcery: pystaticmethod = __new__
  internal static func pyOverflowErrorNew(
    type: PyType,
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyOverflowError> {
    let argsTuple = Py.newTuple(elements: args)
    let result = PyOverflowError(args: argsTuple, type: type)
    return .value(result)
  }

  // sourcery: pymethod = __init__
  internal func pyOverflowErrorInit(
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyNone> {
    return self.pyArithmeticErrorInit(args: args, kwargs: kwargs)
  }
}

// MARK: - ZeroDivisionError

// sourcery: pyerrortype = ZeroDivisionError, default, baseType, hasGC, baseExceptionSubclass
public final class PyZeroDivisionError: PyArithmeticError {

  // sourcery: pytypedoc
  internal static let zeroDivisionErrorDoc = "Second argument to a division or modulo operation was zero."

  /// Type to set in `init`.
  override internal class var pythonType: PyType {
    return Py.errorTypes.zeroDivisionError
  }

  // sourcery: pyproperty = __class__
  internal static func getClass(zeroDivisionError: PyZeroDivisionError) -> PyType {
    return zeroDivisionError.type
  }

  // sourcery: pyproperty = __dict__
  internal static func getDict(zeroDivisionError: PyZeroDivisionError) -> PyDict {
    return zeroDivisionError.__dict__
  }

  // sourcery: pystaticmethod = __new__
  internal static func pyZeroDivisionErrorNew(
    type: PyType,
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyZeroDivisionError> {
    let argsTuple = Py.newTuple(elements: args)
    let result = PyZeroDivisionError(args: argsTuple, type: type)
    return .value(result)
  }

  // sourcery: pymethod = __init__
  internal func pyZeroDivisionErrorInit(
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyNone> {
    return self.pyArithmeticErrorInit(args: args, kwargs: kwargs)
  }
}

// MARK: - AssertionError

// sourcery: pyerrortype = AssertionError, default, baseType, hasGC, baseExceptionSubclass
public final class PyAssertionError: PyException {

  // sourcery: pytypedoc
  internal static let assertionErrorDoc = "Assertion failed."

  /// Type to set in `init`.
  override internal class var pythonType: PyType {
    return Py.errorTypes.assertionError
  }

  // sourcery: pyproperty = __class__
  internal static func getClass(assertionError: PyAssertionError) -> PyType {
    return assertionError.type
  }

  // sourcery: pyproperty = __dict__
  internal static func getDict(assertionError: PyAssertionError) -> PyDict {
    return assertionError.__dict__
  }

  // sourcery: pystaticmethod = __new__
  internal static func pyAssertionErrorNew(
    type: PyType,
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyAssertionError> {
    let argsTuple = Py.newTuple(elements: args)
    let result = PyAssertionError(args: argsTuple, type: type)
    return .value(result)
  }

  // sourcery: pymethod = __init__
  internal func pyAssertionErrorInit(
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyNone> {
    return self.pyExceptionInit(args: args, kwargs: kwargs)
  }
}

// MARK: - AttributeError

// sourcery: pyerrortype = AttributeError, default, baseType, hasGC, baseExceptionSubclass
public final class PyAttributeError: PyException {

  // sourcery: pytypedoc
  internal static let attributeErrorDoc = "Attribute not found."

  /// Type to set in `init`.
  override internal class var pythonType: PyType {
    return Py.errorTypes.attributeError
  }

  // sourcery: pyproperty = __class__
  internal static func getClass(attributeError: PyAttributeError) -> PyType {
    return attributeError.type
  }

  // sourcery: pyproperty = __dict__
  internal static func getDict(attributeError: PyAttributeError) -> PyDict {
    return attributeError.__dict__
  }

  // sourcery: pystaticmethod = __new__
  internal static func pyAttributeErrorNew(
    type: PyType,
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyAttributeError> {
    let argsTuple = Py.newTuple(elements: args)
    let result = PyAttributeError(args: argsTuple, type: type)
    return .value(result)
  }

  // sourcery: pymethod = __init__
  internal func pyAttributeErrorInit(
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyNone> {
    return self.pyExceptionInit(args: args, kwargs: kwargs)
  }
}

// MARK: - BufferError

// sourcery: pyerrortype = BufferError, default, baseType, hasGC, baseExceptionSubclass
public final class PyBufferError: PyException {

  // sourcery: pytypedoc
  internal static let bufferErrorDoc = "Buffer error."

  /// Type to set in `init`.
  override internal class var pythonType: PyType {
    return Py.errorTypes.bufferError
  }

  // sourcery: pyproperty = __class__
  internal static func getClass(bufferError: PyBufferError) -> PyType {
    return bufferError.type
  }

  // sourcery: pyproperty = __dict__
  internal static func getDict(bufferError: PyBufferError) -> PyDict {
    return bufferError.__dict__
  }

  // sourcery: pystaticmethod = __new__
  internal static func pyBufferErrorNew(
    type: PyType,
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyBufferError> {
    let argsTuple = Py.newTuple(elements: args)
    let result = PyBufferError(args: argsTuple, type: type)
    return .value(result)
  }

  // sourcery: pymethod = __init__
  internal func pyBufferErrorInit(
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyNone> {
    return self.pyExceptionInit(args: args, kwargs: kwargs)
  }
}

// MARK: - EOFError

// sourcery: pyerrortype = EOFError, default, baseType, hasGC, baseExceptionSubclass
public final class PyEOFError: PyException {

  // sourcery: pytypedoc
  internal static let eOFErrorDoc = "Read beyond end of file."

  /// Type to set in `init`.
  override internal class var pythonType: PyType {
    return Py.errorTypes.eofError
  }

  // sourcery: pyproperty = __class__
  internal static func getClass(eOFError: PyEOFError) -> PyType {
    return eOFError.type
  }

  // sourcery: pyproperty = __dict__
  internal static func getDict(eOFError: PyEOFError) -> PyDict {
    return eOFError.__dict__
  }

  // sourcery: pystaticmethod = __new__
  internal static func pyEOFErrorNew(
    type: PyType,
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyEOFError> {
    let argsTuple = Py.newTuple(elements: args)
    let result = PyEOFError(args: argsTuple, type: type)
    return .value(result)
  }

  // sourcery: pymethod = __init__
  internal func pyEOFErrorInit(
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyNone> {
    return self.pyExceptionInit(args: args, kwargs: kwargs)
  }
}

// MARK: - ModuleNotFoundError

// sourcery: pyerrortype = ModuleNotFoundError, default, baseType, hasGC, baseExceptionSubclass
public final class PyModuleNotFoundError: PyImportError {

  // sourcery: pytypedoc
  internal static let moduleNotFoundErrorDoc = "Module not found."

  /// Type to set in `init`.
  override internal class var pythonType: PyType {
    return Py.errorTypes.moduleNotFoundError
  }

  // sourcery: pyproperty = __class__
  internal static func getClass(moduleNotFoundError: PyModuleNotFoundError) -> PyType {
    return moduleNotFoundError.type
  }

  // sourcery: pyproperty = __dict__
  internal static func getDict(moduleNotFoundError: PyModuleNotFoundError) -> PyDict {
    return moduleNotFoundError.__dict__
  }

  // sourcery: pystaticmethod = __new__
  internal static func pyModuleNotFoundErrorNew(
    type: PyType,
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyModuleNotFoundError> {
    let argsTuple = Py.newTuple(elements: args)
    let result = PyModuleNotFoundError(args: argsTuple, type: type)
    return .value(result)
  }

  // sourcery: pymethod = __init__
  internal func pyModuleNotFoundErrorInit(
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyNone> {
    return self.pyImportErrorInit(args: args, kwargs: kwargs)
  }
}

// MARK: - LookupError

// sourcery: pyerrortype = LookupError, default, baseType, hasGC, baseExceptionSubclass
public class PyLookupError: PyException {

  // sourcery: pytypedoc
  internal static let lookupErrorDoc = "Base class for lookup errors."

  /// Type to set in `init`.
  override internal class var pythonType: PyType {
    return Py.errorTypes.lookupError
  }

  // sourcery: pyproperty = __class__
  internal static func getClass(lookupError: PyLookupError) -> PyType {
    return lookupError.type
  }

  // sourcery: pyproperty = __dict__
  internal static func getDict(lookupError: PyLookupError) -> PyDict {
    return lookupError.__dict__
  }

  // sourcery: pystaticmethod = __new__
  internal static func pyLookupErrorNew(
    type: PyType,
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyLookupError> {
    let argsTuple = Py.newTuple(elements: args)
    let result = PyLookupError(args: argsTuple, type: type)
    return .value(result)
  }

  // sourcery: pymethod = __init__
  internal func pyLookupErrorInit(
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyNone> {
    return self.pyExceptionInit(args: args, kwargs: kwargs)
  }
}

// MARK: - IndexError

// sourcery: pyerrortype = IndexError, default, baseType, hasGC, baseExceptionSubclass
public final class PyIndexError: PyLookupError {

  // sourcery: pytypedoc
  internal static let indexErrorDoc = "Sequence index out of range."

  /// Type to set in `init`.
  override internal class var pythonType: PyType {
    return Py.errorTypes.indexError
  }

  // sourcery: pyproperty = __class__
  internal static func getClass(indexError: PyIndexError) -> PyType {
    return indexError.type
  }

  // sourcery: pyproperty = __dict__
  internal static func getDict(indexError: PyIndexError) -> PyDict {
    return indexError.__dict__
  }

  // sourcery: pystaticmethod = __new__
  internal static func pyIndexErrorNew(
    type: PyType,
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyIndexError> {
    let argsTuple = Py.newTuple(elements: args)
    let result = PyIndexError(args: argsTuple, type: type)
    return .value(result)
  }

  // sourcery: pymethod = __init__
  internal func pyIndexErrorInit(
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyNone> {
    return self.pyLookupErrorInit(args: args, kwargs: kwargs)
  }
}

// MARK: - MemoryError

// sourcery: pyerrortype = MemoryError, default, baseType, hasGC, baseExceptionSubclass
public final class PyMemoryError: PyException {

  // sourcery: pytypedoc
  internal static let memoryErrorDoc = "Out of memory."

  /// Type to set in `init`.
  override internal class var pythonType: PyType {
    return Py.errorTypes.memoryError
  }

  // sourcery: pyproperty = __class__
  internal static func getClass(memoryError: PyMemoryError) -> PyType {
    return memoryError.type
  }

  // sourcery: pyproperty = __dict__
  internal static func getDict(memoryError: PyMemoryError) -> PyDict {
    return memoryError.__dict__
  }

  // sourcery: pystaticmethod = __new__
  internal static func pyMemoryErrorNew(
    type: PyType,
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyMemoryError> {
    let argsTuple = Py.newTuple(elements: args)
    let result = PyMemoryError(args: argsTuple, type: type)
    return .value(result)
  }

  // sourcery: pymethod = __init__
  internal func pyMemoryErrorInit(
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyNone> {
    return self.pyExceptionInit(args: args, kwargs: kwargs)
  }
}

// MARK: - NameError

// sourcery: pyerrortype = NameError, default, baseType, hasGC, baseExceptionSubclass
public class PyNameError: PyException {

  // sourcery: pytypedoc
  internal static let nameErrorDoc = "Name not found globally."

  /// Type to set in `init`.
  override internal class var pythonType: PyType {
    return Py.errorTypes.nameError
  }

  // sourcery: pyproperty = __class__
  internal static func getClass(nameError: PyNameError) -> PyType {
    return nameError.type
  }

  // sourcery: pyproperty = __dict__
  internal static func getDict(nameError: PyNameError) -> PyDict {
    return nameError.__dict__
  }

  // sourcery: pystaticmethod = __new__
  internal static func pyNameErrorNew(
    type: PyType,
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyNameError> {
    let argsTuple = Py.newTuple(elements: args)
    let result = PyNameError(args: argsTuple, type: type)
    return .value(result)
  }

  // sourcery: pymethod = __init__
  internal func pyNameErrorInit(
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyNone> {
    return self.pyExceptionInit(args: args, kwargs: kwargs)
  }
}

// MARK: - UnboundLocalError

// sourcery: pyerrortype = UnboundLocalError, default, baseType, hasGC, baseExceptionSubclass
public final class PyUnboundLocalError: PyNameError {

  // sourcery: pytypedoc
  internal static let unboundLocalErrorDoc = "Local name referenced but not bound to a value."

  /// Type to set in `init`.
  override internal class var pythonType: PyType {
    return Py.errorTypes.unboundLocalError
  }

  // sourcery: pyproperty = __class__
  internal static func getClass(unboundLocalError: PyUnboundLocalError) -> PyType {
    return unboundLocalError.type
  }

  // sourcery: pyproperty = __dict__
  internal static func getDict(unboundLocalError: PyUnboundLocalError) -> PyDict {
    return unboundLocalError.__dict__
  }

  // sourcery: pystaticmethod = __new__
  internal static func pyUnboundLocalErrorNew(
    type: PyType,
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyUnboundLocalError> {
    let argsTuple = Py.newTuple(elements: args)
    let result = PyUnboundLocalError(args: argsTuple, type: type)
    return .value(result)
  }

  // sourcery: pymethod = __init__
  internal func pyUnboundLocalErrorInit(
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyNone> {
    return self.pyNameErrorInit(args: args, kwargs: kwargs)
  }
}

// MARK: - OSError

// sourcery: pyerrortype = OSError, default, baseType, hasGC, baseExceptionSubclass
public class PyOSError: PyException {

  // sourcery: pytypedoc
  internal static let oSErrorDoc = "Base class for I/O related errors."

  /// Type to set in `init`.
  override internal class var pythonType: PyType {
    return Py.errorTypes.osError
  }

  // sourcery: pyproperty = __class__
  internal static func getClass(oSError: PyOSError) -> PyType {
    return oSError.type
  }

  // sourcery: pyproperty = __dict__
  internal static func getDict(oSError: PyOSError) -> PyDict {
    return oSError.__dict__
  }

  // sourcery: pystaticmethod = __new__
  internal static func pyOSErrorNew(
    type: PyType,
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyOSError> {
    let argsTuple = Py.newTuple(elements: args)
    let result = PyOSError(args: argsTuple, type: type)
    return .value(result)
  }

  // sourcery: pymethod = __init__
  internal func pyOSErrorInit(
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyNone> {
    return self.pyExceptionInit(args: args, kwargs: kwargs)
  }
}

// MARK: - BlockingIOError

// sourcery: pyerrortype = BlockingIOError, default, baseType, hasGC, baseExceptionSubclass
public final class PyBlockingIOError: PyOSError {

  // sourcery: pytypedoc
  internal static let blockingIOErrorDoc = "I/O operation would block."

  /// Type to set in `init`.
  override internal class var pythonType: PyType {
    return Py.errorTypes.blockingIOError
  }

  // sourcery: pyproperty = __class__
  internal static func getClass(blockingIOError: PyBlockingIOError) -> PyType {
    return blockingIOError.type
  }

  // sourcery: pyproperty = __dict__
  internal static func getDict(blockingIOError: PyBlockingIOError) -> PyDict {
    return blockingIOError.__dict__
  }

  // sourcery: pystaticmethod = __new__
  internal static func pyBlockingIOErrorNew(
    type: PyType,
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyBlockingIOError> {
    let argsTuple = Py.newTuple(elements: args)
    let result = PyBlockingIOError(args: argsTuple, type: type)
    return .value(result)
  }

  // sourcery: pymethod = __init__
  internal func pyBlockingIOErrorInit(
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyNone> {
    return self.pyOSErrorInit(args: args, kwargs: kwargs)
  }
}

// MARK: - ChildProcessError

// sourcery: pyerrortype = ChildProcessError, default, baseType, hasGC, baseExceptionSubclass
public final class PyChildProcessError: PyOSError {

  // sourcery: pytypedoc
  internal static let childProcessErrorDoc = "Child process error."

  /// Type to set in `init`.
  override internal class var pythonType: PyType {
    return Py.errorTypes.childProcessError
  }

  // sourcery: pyproperty = __class__
  internal static func getClass(childProcessError: PyChildProcessError) -> PyType {
    return childProcessError.type
  }

  // sourcery: pyproperty = __dict__
  internal static func getDict(childProcessError: PyChildProcessError) -> PyDict {
    return childProcessError.__dict__
  }

  // sourcery: pystaticmethod = __new__
  internal static func pyChildProcessErrorNew(
    type: PyType,
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyChildProcessError> {
    let argsTuple = Py.newTuple(elements: args)
    let result = PyChildProcessError(args: argsTuple, type: type)
    return .value(result)
  }

  // sourcery: pymethod = __init__
  internal func pyChildProcessErrorInit(
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyNone> {
    return self.pyOSErrorInit(args: args, kwargs: kwargs)
  }
}

// MARK: - ConnectionError

// sourcery: pyerrortype = ConnectionError, default, baseType, hasGC, baseExceptionSubclass
public class PyConnectionError: PyOSError {

  // sourcery: pytypedoc
  internal static let connectionErrorDoc = "Connection error."

  /// Type to set in `init`.
  override internal class var pythonType: PyType {
    return Py.errorTypes.connectionError
  }

  // sourcery: pyproperty = __class__
  internal static func getClass(connectionError: PyConnectionError) -> PyType {
    return connectionError.type
  }

  // sourcery: pyproperty = __dict__
  internal static func getDict(connectionError: PyConnectionError) -> PyDict {
    return connectionError.__dict__
  }

  // sourcery: pystaticmethod = __new__
  internal static func pyConnectionErrorNew(
    type: PyType,
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyConnectionError> {
    let argsTuple = Py.newTuple(elements: args)
    let result = PyConnectionError(args: argsTuple, type: type)
    return .value(result)
  }

  // sourcery: pymethod = __init__
  internal func pyConnectionErrorInit(
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyNone> {
    return self.pyOSErrorInit(args: args, kwargs: kwargs)
  }
}

// MARK: - BrokenPipeError

// sourcery: pyerrortype = BrokenPipeError, default, baseType, hasGC, baseExceptionSubclass
public final class PyBrokenPipeError: PyConnectionError {

  // sourcery: pytypedoc
  internal static let brokenPipeErrorDoc = "Broken pipe."

  /// Type to set in `init`.
  override internal class var pythonType: PyType {
    return Py.errorTypes.brokenPipeError
  }

  // sourcery: pyproperty = __class__
  internal static func getClass(brokenPipeError: PyBrokenPipeError) -> PyType {
    return brokenPipeError.type
  }

  // sourcery: pyproperty = __dict__
  internal static func getDict(brokenPipeError: PyBrokenPipeError) -> PyDict {
    return brokenPipeError.__dict__
  }

  // sourcery: pystaticmethod = __new__
  internal static func pyBrokenPipeErrorNew(
    type: PyType,
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyBrokenPipeError> {
    let argsTuple = Py.newTuple(elements: args)
    let result = PyBrokenPipeError(args: argsTuple, type: type)
    return .value(result)
  }

  // sourcery: pymethod = __init__
  internal func pyBrokenPipeErrorInit(
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyNone> {
    return self.pyConnectionErrorInit(args: args, kwargs: kwargs)
  }
}

// MARK: - ConnectionAbortedError

// sourcery: pyerrortype = ConnectionAbortedError, default, baseType, hasGC, baseExceptionSubclass
public final class PyConnectionAbortedError: PyConnectionError {

  // sourcery: pytypedoc
  internal static let connectionAbortedErrorDoc = "Connection aborted."

  /// Type to set in `init`.
  override internal class var pythonType: PyType {
    return Py.errorTypes.connectionAbortedError
  }

  // sourcery: pyproperty = __class__
  internal static func getClass(connectionAbortedError: PyConnectionAbortedError) -> PyType {
    return connectionAbortedError.type
  }

  // sourcery: pyproperty = __dict__
  internal static func getDict(connectionAbortedError: PyConnectionAbortedError) -> PyDict {
    return connectionAbortedError.__dict__
  }

  // sourcery: pystaticmethod = __new__
  internal static func pyConnectionAbortedErrorNew(
    type: PyType,
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyConnectionAbortedError> {
    let argsTuple = Py.newTuple(elements: args)
    let result = PyConnectionAbortedError(args: argsTuple, type: type)
    return .value(result)
  }

  // sourcery: pymethod = __init__
  internal func pyConnectionAbortedErrorInit(
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyNone> {
    return self.pyConnectionErrorInit(args: args, kwargs: kwargs)
  }
}

// MARK: - ConnectionRefusedError

// sourcery: pyerrortype = ConnectionRefusedError, default, baseType, hasGC, baseExceptionSubclass
public final class PyConnectionRefusedError: PyConnectionError {

  // sourcery: pytypedoc
  internal static let connectionRefusedErrorDoc = "Connection refused."

  /// Type to set in `init`.
  override internal class var pythonType: PyType {
    return Py.errorTypes.connectionRefusedError
  }

  // sourcery: pyproperty = __class__
  internal static func getClass(connectionRefusedError: PyConnectionRefusedError) -> PyType {
    return connectionRefusedError.type
  }

  // sourcery: pyproperty = __dict__
  internal static func getDict(connectionRefusedError: PyConnectionRefusedError) -> PyDict {
    return connectionRefusedError.__dict__
  }

  // sourcery: pystaticmethod = __new__
  internal static func pyConnectionRefusedErrorNew(
    type: PyType,
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyConnectionRefusedError> {
    let argsTuple = Py.newTuple(elements: args)
    let result = PyConnectionRefusedError(args: argsTuple, type: type)
    return .value(result)
  }

  // sourcery: pymethod = __init__
  internal func pyConnectionRefusedErrorInit(
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyNone> {
    return self.pyConnectionErrorInit(args: args, kwargs: kwargs)
  }
}

// MARK: - ConnectionResetError

// sourcery: pyerrortype = ConnectionResetError, default, baseType, hasGC, baseExceptionSubclass
public final class PyConnectionResetError: PyConnectionError {

  // sourcery: pytypedoc
  internal static let connectionResetErrorDoc = "Connection reset."

  /// Type to set in `init`.
  override internal class var pythonType: PyType {
    return Py.errorTypes.connectionResetError
  }

  // sourcery: pyproperty = __class__
  internal static func getClass(connectionResetError: PyConnectionResetError) -> PyType {
    return connectionResetError.type
  }

  // sourcery: pyproperty = __dict__
  internal static func getDict(connectionResetError: PyConnectionResetError) -> PyDict {
    return connectionResetError.__dict__
  }

  // sourcery: pystaticmethod = __new__
  internal static func pyConnectionResetErrorNew(
    type: PyType,
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyConnectionResetError> {
    let argsTuple = Py.newTuple(elements: args)
    let result = PyConnectionResetError(args: argsTuple, type: type)
    return .value(result)
  }

  // sourcery: pymethod = __init__
  internal func pyConnectionResetErrorInit(
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyNone> {
    return self.pyConnectionErrorInit(args: args, kwargs: kwargs)
  }
}

// MARK: - FileExistsError

// sourcery: pyerrortype = FileExistsError, default, baseType, hasGC, baseExceptionSubclass
public final class PyFileExistsError: PyOSError {

  // sourcery: pytypedoc
  internal static let fileExistsErrorDoc = "File already exists."

  /// Type to set in `init`.
  override internal class var pythonType: PyType {
    return Py.errorTypes.fileExistsError
  }

  // sourcery: pyproperty = __class__
  internal static func getClass(fileExistsError: PyFileExistsError) -> PyType {
    return fileExistsError.type
  }

  // sourcery: pyproperty = __dict__
  internal static func getDict(fileExistsError: PyFileExistsError) -> PyDict {
    return fileExistsError.__dict__
  }

  // sourcery: pystaticmethod = __new__
  internal static func pyFileExistsErrorNew(
    type: PyType,
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyFileExistsError> {
    let argsTuple = Py.newTuple(elements: args)
    let result = PyFileExistsError(args: argsTuple, type: type)
    return .value(result)
  }

  // sourcery: pymethod = __init__
  internal func pyFileExistsErrorInit(
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyNone> {
    return self.pyOSErrorInit(args: args, kwargs: kwargs)
  }
}

// MARK: - FileNotFoundError

// sourcery: pyerrortype = FileNotFoundError, default, baseType, hasGC, baseExceptionSubclass
public final class PyFileNotFoundError: PyOSError {

  // sourcery: pytypedoc
  internal static let fileNotFoundErrorDoc = "File not found."

  /// Type to set in `init`.
  override internal class var pythonType: PyType {
    return Py.errorTypes.fileNotFoundError
  }

  // sourcery: pyproperty = __class__
  internal static func getClass(fileNotFoundError: PyFileNotFoundError) -> PyType {
    return fileNotFoundError.type
  }

  // sourcery: pyproperty = __dict__
  internal static func getDict(fileNotFoundError: PyFileNotFoundError) -> PyDict {
    return fileNotFoundError.__dict__
  }

  // sourcery: pystaticmethod = __new__
  internal static func pyFileNotFoundErrorNew(
    type: PyType,
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyFileNotFoundError> {
    let argsTuple = Py.newTuple(elements: args)
    let result = PyFileNotFoundError(args: argsTuple, type: type)
    return .value(result)
  }

  // sourcery: pymethod = __init__
  internal func pyFileNotFoundErrorInit(
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyNone> {
    return self.pyOSErrorInit(args: args, kwargs: kwargs)
  }
}

// MARK: - InterruptedError

// sourcery: pyerrortype = InterruptedError, default, baseType, hasGC, baseExceptionSubclass
public final class PyInterruptedError: PyOSError {

  // sourcery: pytypedoc
  internal static let interruptedErrorDoc = "Interrupted by signal."

  /// Type to set in `init`.
  override internal class var pythonType: PyType {
    return Py.errorTypes.interruptedError
  }

  // sourcery: pyproperty = __class__
  internal static func getClass(interruptedError: PyInterruptedError) -> PyType {
    return interruptedError.type
  }

  // sourcery: pyproperty = __dict__
  internal static func getDict(interruptedError: PyInterruptedError) -> PyDict {
    return interruptedError.__dict__
  }

  // sourcery: pystaticmethod = __new__
  internal static func pyInterruptedErrorNew(
    type: PyType,
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyInterruptedError> {
    let argsTuple = Py.newTuple(elements: args)
    let result = PyInterruptedError(args: argsTuple, type: type)
    return .value(result)
  }

  // sourcery: pymethod = __init__
  internal func pyInterruptedErrorInit(
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyNone> {
    return self.pyOSErrorInit(args: args, kwargs: kwargs)
  }
}

// MARK: - IsADirectoryError

// sourcery: pyerrortype = IsADirectoryError, default, baseType, hasGC, baseExceptionSubclass
public final class PyIsADirectoryError: PyOSError {

  // sourcery: pytypedoc
  internal static let isADirectoryErrorDoc = "Operation doesn't work on directories."

  /// Type to set in `init`.
  override internal class var pythonType: PyType {
    return Py.errorTypes.isADirectoryError
  }

  // sourcery: pyproperty = __class__
  internal static func getClass(isADirectoryError: PyIsADirectoryError) -> PyType {
    return isADirectoryError.type
  }

  // sourcery: pyproperty = __dict__
  internal static func getDict(isADirectoryError: PyIsADirectoryError) -> PyDict {
    return isADirectoryError.__dict__
  }

  // sourcery: pystaticmethod = __new__
  internal static func pyIsADirectoryErrorNew(
    type: PyType,
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyIsADirectoryError> {
    let argsTuple = Py.newTuple(elements: args)
    let result = PyIsADirectoryError(args: argsTuple, type: type)
    return .value(result)
  }

  // sourcery: pymethod = __init__
  internal func pyIsADirectoryErrorInit(
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyNone> {
    return self.pyOSErrorInit(args: args, kwargs: kwargs)
  }
}

// MARK: - NotADirectoryError

// sourcery: pyerrortype = NotADirectoryError, default, baseType, hasGC, baseExceptionSubclass
public final class PyNotADirectoryError: PyOSError {

  // sourcery: pytypedoc
  internal static let notADirectoryErrorDoc = "Operation only works on directories."

  /// Type to set in `init`.
  override internal class var pythonType: PyType {
    return Py.errorTypes.notADirectoryError
  }

  // sourcery: pyproperty = __class__
  internal static func getClass(notADirectoryError: PyNotADirectoryError) -> PyType {
    return notADirectoryError.type
  }

  // sourcery: pyproperty = __dict__
  internal static func getDict(notADirectoryError: PyNotADirectoryError) -> PyDict {
    return notADirectoryError.__dict__
  }

  // sourcery: pystaticmethod = __new__
  internal static func pyNotADirectoryErrorNew(
    type: PyType,
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyNotADirectoryError> {
    let argsTuple = Py.newTuple(elements: args)
    let result = PyNotADirectoryError(args: argsTuple, type: type)
    return .value(result)
  }

  // sourcery: pymethod = __init__
  internal func pyNotADirectoryErrorInit(
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyNone> {
    return self.pyOSErrorInit(args: args, kwargs: kwargs)
  }
}

// MARK: - PermissionError

// sourcery: pyerrortype = PermissionError, default, baseType, hasGC, baseExceptionSubclass
public final class PyPermissionError: PyOSError {

  // sourcery: pytypedoc
  internal static let permissionErrorDoc = "Not enough permissions."

  /// Type to set in `init`.
  override internal class var pythonType: PyType {
    return Py.errorTypes.permissionError
  }

  // sourcery: pyproperty = __class__
  internal static func getClass(permissionError: PyPermissionError) -> PyType {
    return permissionError.type
  }

  // sourcery: pyproperty = __dict__
  internal static func getDict(permissionError: PyPermissionError) -> PyDict {
    return permissionError.__dict__
  }

  // sourcery: pystaticmethod = __new__
  internal static func pyPermissionErrorNew(
    type: PyType,
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyPermissionError> {
    let argsTuple = Py.newTuple(elements: args)
    let result = PyPermissionError(args: argsTuple, type: type)
    return .value(result)
  }

  // sourcery: pymethod = __init__
  internal func pyPermissionErrorInit(
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyNone> {
    return self.pyOSErrorInit(args: args, kwargs: kwargs)
  }
}

// MARK: - ProcessLookupError

// sourcery: pyerrortype = ProcessLookupError, default, baseType, hasGC, baseExceptionSubclass
public final class PyProcessLookupError: PyOSError {

  // sourcery: pytypedoc
  internal static let processLookupErrorDoc = "Process not found."

  /// Type to set in `init`.
  override internal class var pythonType: PyType {
    return Py.errorTypes.processLookupError
  }

  // sourcery: pyproperty = __class__
  internal static func getClass(processLookupError: PyProcessLookupError) -> PyType {
    return processLookupError.type
  }

  // sourcery: pyproperty = __dict__
  internal static func getDict(processLookupError: PyProcessLookupError) -> PyDict {
    return processLookupError.__dict__
  }

  // sourcery: pystaticmethod = __new__
  internal static func pyProcessLookupErrorNew(
    type: PyType,
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyProcessLookupError> {
    let argsTuple = Py.newTuple(elements: args)
    let result = PyProcessLookupError(args: argsTuple, type: type)
    return .value(result)
  }

  // sourcery: pymethod = __init__
  internal func pyProcessLookupErrorInit(
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyNone> {
    return self.pyOSErrorInit(args: args, kwargs: kwargs)
  }
}

// MARK: - TimeoutError

// sourcery: pyerrortype = TimeoutError, default, baseType, hasGC, baseExceptionSubclass
public final class PyTimeoutError: PyOSError {

  // sourcery: pytypedoc
  internal static let timeoutErrorDoc = "Timeout expired."

  /// Type to set in `init`.
  override internal class var pythonType: PyType {
    return Py.errorTypes.timeoutError
  }

  // sourcery: pyproperty = __class__
  internal static func getClass(timeoutError: PyTimeoutError) -> PyType {
    return timeoutError.type
  }

  // sourcery: pyproperty = __dict__
  internal static func getDict(timeoutError: PyTimeoutError) -> PyDict {
    return timeoutError.__dict__
  }

  // sourcery: pystaticmethod = __new__
  internal static func pyTimeoutErrorNew(
    type: PyType,
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyTimeoutError> {
    let argsTuple = Py.newTuple(elements: args)
    let result = PyTimeoutError(args: argsTuple, type: type)
    return .value(result)
  }

  // sourcery: pymethod = __init__
  internal func pyTimeoutErrorInit(
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyNone> {
    return self.pyOSErrorInit(args: args, kwargs: kwargs)
  }
}

// MARK: - ReferenceError

// sourcery: pyerrortype = ReferenceError, default, baseType, hasGC, baseExceptionSubclass
public final class PyReferenceError: PyException {

  // sourcery: pytypedoc
  internal static let referenceErrorDoc = "Weak ref proxy used after referent went away."

  /// Type to set in `init`.
  override internal class var pythonType: PyType {
    return Py.errorTypes.referenceError
  }

  // sourcery: pyproperty = __class__
  internal static func getClass(referenceError: PyReferenceError) -> PyType {
    return referenceError.type
  }

  // sourcery: pyproperty = __dict__
  internal static func getDict(referenceError: PyReferenceError) -> PyDict {
    return referenceError.__dict__
  }

  // sourcery: pystaticmethod = __new__
  internal static func pyReferenceErrorNew(
    type: PyType,
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyReferenceError> {
    let argsTuple = Py.newTuple(elements: args)
    let result = PyReferenceError(args: argsTuple, type: type)
    return .value(result)
  }

  // sourcery: pymethod = __init__
  internal func pyReferenceErrorInit(
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyNone> {
    return self.pyExceptionInit(args: args, kwargs: kwargs)
  }
}

// MARK: - RuntimeError

// sourcery: pyerrortype = RuntimeError, default, baseType, hasGC, baseExceptionSubclass
public class PyRuntimeError: PyException {

  // sourcery: pytypedoc
  internal static let runtimeErrorDoc = "Unspecified run-time error."

  /// Type to set in `init`.
  override internal class var pythonType: PyType {
    return Py.errorTypes.runtimeError
  }

  // sourcery: pyproperty = __class__
  internal static func getClass(runtimeError: PyRuntimeError) -> PyType {
    return runtimeError.type
  }

  // sourcery: pyproperty = __dict__
  internal static func getDict(runtimeError: PyRuntimeError) -> PyDict {
    return runtimeError.__dict__
  }

  // sourcery: pystaticmethod = __new__
  internal static func pyRuntimeErrorNew(
    type: PyType,
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyRuntimeError> {
    let argsTuple = Py.newTuple(elements: args)
    let result = PyRuntimeError(args: argsTuple, type: type)
    return .value(result)
  }

  // sourcery: pymethod = __init__
  internal func pyRuntimeErrorInit(
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyNone> {
    return self.pyExceptionInit(args: args, kwargs: kwargs)
  }
}

// MARK: - NotImplementedError

// sourcery: pyerrortype = NotImplementedError, default, baseType, hasGC, baseExceptionSubclass
public final class PyNotImplementedError: PyRuntimeError {

  // sourcery: pytypedoc
  internal static let notImplementedErrorDoc = "Method or function hasn't been implemented yet."

  /// Type to set in `init`.
  override internal class var pythonType: PyType {
    return Py.errorTypes.notImplementedError
  }

  // sourcery: pyproperty = __class__
  internal static func getClass(notImplementedError: PyNotImplementedError) -> PyType {
    return notImplementedError.type
  }

  // sourcery: pyproperty = __dict__
  internal static func getDict(notImplementedError: PyNotImplementedError) -> PyDict {
    return notImplementedError.__dict__
  }

  // sourcery: pystaticmethod = __new__
  internal static func pyNotImplementedErrorNew(
    type: PyType,
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyNotImplementedError> {
    let argsTuple = Py.newTuple(elements: args)
    let result = PyNotImplementedError(args: argsTuple, type: type)
    return .value(result)
  }

  // sourcery: pymethod = __init__
  internal func pyNotImplementedErrorInit(
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyNone> {
    return self.pyRuntimeErrorInit(args: args, kwargs: kwargs)
  }
}

// MARK: - RecursionError

// sourcery: pyerrortype = RecursionError, default, baseType, hasGC, baseExceptionSubclass
public final class PyRecursionError: PyRuntimeError {

  // sourcery: pytypedoc
  internal static let recursionErrorDoc = "Recursion limit exceeded."

  /// Type to set in `init`.
  override internal class var pythonType: PyType {
    return Py.errorTypes.recursionError
  }

  // sourcery: pyproperty = __class__
  internal static func getClass(recursionError: PyRecursionError) -> PyType {
    return recursionError.type
  }

  // sourcery: pyproperty = __dict__
  internal static func getDict(recursionError: PyRecursionError) -> PyDict {
    return recursionError.__dict__
  }

  // sourcery: pystaticmethod = __new__
  internal static func pyRecursionErrorNew(
    type: PyType,
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyRecursionError> {
    let argsTuple = Py.newTuple(elements: args)
    let result = PyRecursionError(args: argsTuple, type: type)
    return .value(result)
  }

  // sourcery: pymethod = __init__
  internal func pyRecursionErrorInit(
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyNone> {
    return self.pyRuntimeErrorInit(args: args, kwargs: kwargs)
  }
}

// MARK: - IndentationError

// sourcery: pyerrortype = IndentationError, default, baseType, hasGC, baseExceptionSubclass
public class PyIndentationError: PySyntaxError {

  // sourcery: pytypedoc
  internal static let indentationErrorDoc = "Improper indentation."

  /// Type to set in `init`.
  override internal class var pythonType: PyType {
    return Py.errorTypes.indentationError
  }

  // sourcery: pyproperty = __class__
  internal static func getClass(indentationError: PyIndentationError) -> PyType {
    return indentationError.type
  }

  // sourcery: pyproperty = __dict__
  internal static func getDict(indentationError: PyIndentationError) -> PyDict {
    return indentationError.__dict__
  }

  // sourcery: pystaticmethod = __new__
  internal static func pyIndentationErrorNew(
    type: PyType,
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyIndentationError> {
    let argsTuple = Py.newTuple(elements: args)
    let result = PyIndentationError(args: argsTuple, type: type)
    return .value(result)
  }

  // sourcery: pymethod = __init__
  internal func pyIndentationErrorInit(
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyNone> {
    return self.pySyntaxErrorInit(args: args, kwargs: kwargs)
  }
}

// MARK: - TabError

// sourcery: pyerrortype = TabError, default, baseType, hasGC, baseExceptionSubclass
public final class PyTabError: PyIndentationError {

  // sourcery: pytypedoc
  internal static let tabErrorDoc = "Improper mixture of spaces and tabs."

  /// Type to set in `init`.
  override internal class var pythonType: PyType {
    return Py.errorTypes.tabError
  }

  // sourcery: pyproperty = __class__
  internal static func getClass(tabError: PyTabError) -> PyType {
    return tabError.type
  }

  // sourcery: pyproperty = __dict__
  internal static func getDict(tabError: PyTabError) -> PyDict {
    return tabError.__dict__
  }

  // sourcery: pystaticmethod = __new__
  internal static func pyTabErrorNew(
    type: PyType,
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyTabError> {
    let argsTuple = Py.newTuple(elements: args)
    let result = PyTabError(args: argsTuple, type: type)
    return .value(result)
  }

  // sourcery: pymethod = __init__
  internal func pyTabErrorInit(
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyNone> {
    return self.pyIndentationErrorInit(args: args, kwargs: kwargs)
  }
}

// MARK: - SystemError

// sourcery: pyerrortype = SystemError, default, baseType, hasGC, baseExceptionSubclass
public final class PySystemError: PyException {

  // sourcery: pytypedoc
  internal static let systemErrorDoc = "Internal error in the Python interpreter.\n" +
"\n" +
"Please report this to the Python maintainer, along with the traceback,\n" +
"the Python version, and the hardware/OS platform and version."

  /// Type to set in `init`.
  override internal class var pythonType: PyType {
    return Py.errorTypes.systemError
  }

  // sourcery: pyproperty = __class__
  internal static func getClass(systemError: PySystemError) -> PyType {
    return systemError.type
  }

  // sourcery: pyproperty = __dict__
  internal static func getDict(systemError: PySystemError) -> PyDict {
    return systemError.__dict__
  }

  // sourcery: pystaticmethod = __new__
  internal static func pySystemErrorNew(
    type: PyType,
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PySystemError> {
    let argsTuple = Py.newTuple(elements: args)
    let result = PySystemError(args: argsTuple, type: type)
    return .value(result)
  }

  // sourcery: pymethod = __init__
  internal func pySystemErrorInit(
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyNone> {
    return self.pyExceptionInit(args: args, kwargs: kwargs)
  }
}

// MARK: - TypeError

// sourcery: pyerrortype = TypeError, default, baseType, hasGC, baseExceptionSubclass
public final class PyTypeError: PyException {

  // sourcery: pytypedoc
  internal static let typeErrorDoc = "Inappropriate argument type."

  /// Type to set in `init`.
  override internal class var pythonType: PyType {
    return Py.errorTypes.typeError
  }

  // sourcery: pyproperty = __class__
  internal static func getClass(typeError: PyTypeError) -> PyType {
    return typeError.type
  }

  // sourcery: pyproperty = __dict__
  internal static func getDict(typeError: PyTypeError) -> PyDict {
    return typeError.__dict__
  }

  // sourcery: pystaticmethod = __new__
  internal static func pyTypeErrorNew(
    type: PyType,
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyTypeError> {
    let argsTuple = Py.newTuple(elements: args)
    let result = PyTypeError(args: argsTuple, type: type)
    return .value(result)
  }

  // sourcery: pymethod = __init__
  internal func pyTypeErrorInit(
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyNone> {
    return self.pyExceptionInit(args: args, kwargs: kwargs)
  }
}

// MARK: - ValueError

// sourcery: pyerrortype = ValueError, default, baseType, hasGC, baseExceptionSubclass
public class PyValueError: PyException {

  // sourcery: pytypedoc
  internal static let valueErrorDoc = "Inappropriate argument value (of correct type)."

  /// Type to set in `init`.
  override internal class var pythonType: PyType {
    return Py.errorTypes.valueError
  }

  // sourcery: pyproperty = __class__
  internal static func getClass(valueError: PyValueError) -> PyType {
    return valueError.type
  }

  // sourcery: pyproperty = __dict__
  internal static func getDict(valueError: PyValueError) -> PyDict {
    return valueError.__dict__
  }

  // sourcery: pystaticmethod = __new__
  internal static func pyValueErrorNew(
    type: PyType,
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyValueError> {
    let argsTuple = Py.newTuple(elements: args)
    let result = PyValueError(args: argsTuple, type: type)
    return .value(result)
  }

  // sourcery: pymethod = __init__
  internal func pyValueErrorInit(
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyNone> {
    return self.pyExceptionInit(args: args, kwargs: kwargs)
  }
}

// MARK: - UnicodeError

// sourcery: pyerrortype = UnicodeError, default, baseType, hasGC, baseExceptionSubclass
public class PyUnicodeError: PyValueError {

  // sourcery: pytypedoc
  internal static let unicodeErrorDoc = "Unicode related error."

  /// Type to set in `init`.
  override internal class var pythonType: PyType {
    return Py.errorTypes.unicodeError
  }

  // sourcery: pyproperty = __class__
  internal static func getClass(unicodeError: PyUnicodeError) -> PyType {
    return unicodeError.type
  }

  // sourcery: pyproperty = __dict__
  internal static func getDict(unicodeError: PyUnicodeError) -> PyDict {
    return unicodeError.__dict__
  }

  // sourcery: pystaticmethod = __new__
  internal static func pyUnicodeErrorNew(
    type: PyType,
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyUnicodeError> {
    let argsTuple = Py.newTuple(elements: args)
    let result = PyUnicodeError(args: argsTuple, type: type)
    return .value(result)
  }

  // sourcery: pymethod = __init__
  internal func pyUnicodeErrorInit(
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyNone> {
    return self.pyValueErrorInit(args: args, kwargs: kwargs)
  }
}

// MARK: - UnicodeDecodeError

// sourcery: pyerrortype = UnicodeDecodeError, default, baseType, hasGC, baseExceptionSubclass
public final class PyUnicodeDecodeError: PyUnicodeError {

  // sourcery: pytypedoc
  internal static let unicodeDecodeErrorDoc = "Unicode decoding error."

  /// Type to set in `init`.
  override internal class var pythonType: PyType {
    return Py.errorTypes.unicodeDecodeError
  }

  // sourcery: pyproperty = __class__
  internal static func getClass(unicodeDecodeError: PyUnicodeDecodeError) -> PyType {
    return unicodeDecodeError.type
  }

  // sourcery: pyproperty = __dict__
  internal static func getDict(unicodeDecodeError: PyUnicodeDecodeError) -> PyDict {
    return unicodeDecodeError.__dict__
  }

  // sourcery: pystaticmethod = __new__
  internal static func pyUnicodeDecodeErrorNew(
    type: PyType,
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyUnicodeDecodeError> {
    let argsTuple = Py.newTuple(elements: args)
    let result = PyUnicodeDecodeError(args: argsTuple, type: type)
    return .value(result)
  }

  // sourcery: pymethod = __init__
  internal func pyUnicodeDecodeErrorInit(
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyNone> {
    return self.pyUnicodeErrorInit(args: args, kwargs: kwargs)
  }
}

// MARK: - UnicodeEncodeError

// sourcery: pyerrortype = UnicodeEncodeError, default, baseType, hasGC, baseExceptionSubclass
public final class PyUnicodeEncodeError: PyUnicodeError {

  // sourcery: pytypedoc
  internal static let unicodeEncodeErrorDoc = "Unicode encoding error."

  /// Type to set in `init`.
  override internal class var pythonType: PyType {
    return Py.errorTypes.unicodeEncodeError
  }

  // sourcery: pyproperty = __class__
  internal static func getClass(unicodeEncodeError: PyUnicodeEncodeError) -> PyType {
    return unicodeEncodeError.type
  }

  // sourcery: pyproperty = __dict__
  internal static func getDict(unicodeEncodeError: PyUnicodeEncodeError) -> PyDict {
    return unicodeEncodeError.__dict__
  }

  // sourcery: pystaticmethod = __new__
  internal static func pyUnicodeEncodeErrorNew(
    type: PyType,
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyUnicodeEncodeError> {
    let argsTuple = Py.newTuple(elements: args)
    let result = PyUnicodeEncodeError(args: argsTuple, type: type)
    return .value(result)
  }

  // sourcery: pymethod = __init__
  internal func pyUnicodeEncodeErrorInit(
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyNone> {
    return self.pyUnicodeErrorInit(args: args, kwargs: kwargs)
  }
}

// MARK: - UnicodeTranslateError

// sourcery: pyerrortype = UnicodeTranslateError, default, baseType, hasGC, baseExceptionSubclass
public final class PyUnicodeTranslateError: PyUnicodeError {

  // sourcery: pytypedoc
  internal static let unicodeTranslateErrorDoc = "Unicode translation error."

  /// Type to set in `init`.
  override internal class var pythonType: PyType {
    return Py.errorTypes.unicodeTranslateError
  }

  // sourcery: pyproperty = __class__
  internal static func getClass(unicodeTranslateError: PyUnicodeTranslateError) -> PyType {
    return unicodeTranslateError.type
  }

  // sourcery: pyproperty = __dict__
  internal static func getDict(unicodeTranslateError: PyUnicodeTranslateError) -> PyDict {
    return unicodeTranslateError.__dict__
  }

  // sourcery: pystaticmethod = __new__
  internal static func pyUnicodeTranslateErrorNew(
    type: PyType,
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyUnicodeTranslateError> {
    let argsTuple = Py.newTuple(elements: args)
    let result = PyUnicodeTranslateError(args: argsTuple, type: type)
    return .value(result)
  }

  // sourcery: pymethod = __init__
  internal func pyUnicodeTranslateErrorInit(
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyNone> {
    return self.pyUnicodeErrorInit(args: args, kwargs: kwargs)
  }
}

// MARK: - Warning

// sourcery: pyerrortype = Warning, default, baseType, hasGC, baseExceptionSubclass
public class PyWarning: PyException {

  // sourcery: pytypedoc
  internal static let warningDoc = "Base class for warning categories."

  /// Type to set in `init`.
  override internal class var pythonType: PyType {
    return Py.errorTypes.warning
  }

  // sourcery: pyproperty = __class__
  internal static func getClass(warning: PyWarning) -> PyType {
    return warning.type
  }

  // sourcery: pyproperty = __dict__
  internal static func getDict(warning: PyWarning) -> PyDict {
    return warning.__dict__
  }

  // sourcery: pystaticmethod = __new__
  internal static func pyWarningNew(
    type: PyType,
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyWarning> {
    let argsTuple = Py.newTuple(elements: args)
    let result = PyWarning(args: argsTuple, type: type)
    return .value(result)
  }

  // sourcery: pymethod = __init__
  internal func pyWarningInit(
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyNone> {
    return self.pyExceptionInit(args: args, kwargs: kwargs)
  }
}

// MARK: - DeprecationWarning

// sourcery: pyerrortype = DeprecationWarning, default, baseType, hasGC, baseExceptionSubclass
public final class PyDeprecationWarning: PyWarning {

  // sourcery: pytypedoc
  internal static let deprecationWarningDoc = "Base class for warnings about deprecated features."

  /// Type to set in `init`.
  override internal class var pythonType: PyType {
    return Py.errorTypes.deprecationWarning
  }

  // sourcery: pyproperty = __class__
  internal static func getClass(deprecationWarning: PyDeprecationWarning) -> PyType {
    return deprecationWarning.type
  }

  // sourcery: pyproperty = __dict__
  internal static func getDict(deprecationWarning: PyDeprecationWarning) -> PyDict {
    return deprecationWarning.__dict__
  }

  // sourcery: pystaticmethod = __new__
  internal static func pyDeprecationWarningNew(
    type: PyType,
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyDeprecationWarning> {
    let argsTuple = Py.newTuple(elements: args)
    let result = PyDeprecationWarning(args: argsTuple, type: type)
    return .value(result)
  }

  // sourcery: pymethod = __init__
  internal func pyDeprecationWarningInit(
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyNone> {
    return self.pyWarningInit(args: args, kwargs: kwargs)
  }
}

// MARK: - PendingDeprecationWarning

// sourcery: pyerrortype = PendingDeprecationWarning, default, baseType, hasGC, baseExceptionSubclass
public final class PyPendingDeprecationWarning: PyWarning {

  // sourcery: pytypedoc
  internal static let pendingDeprecationWarningDoc = "Base class for warnings about features which will be deprecated\n" +
"in the future."

  /// Type to set in `init`.
  override internal class var pythonType: PyType {
    return Py.errorTypes.pendingDeprecationWarning
  }

  // sourcery: pyproperty = __class__
  internal static func getClass(pendingDeprecationWarning: PyPendingDeprecationWarning) -> PyType {
    return pendingDeprecationWarning.type
  }

  // sourcery: pyproperty = __dict__
  internal static func getDict(pendingDeprecationWarning: PyPendingDeprecationWarning) -> PyDict {
    return pendingDeprecationWarning.__dict__
  }

  // sourcery: pystaticmethod = __new__
  internal static func pyPendingDeprecationWarningNew(
    type: PyType,
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyPendingDeprecationWarning> {
    let argsTuple = Py.newTuple(elements: args)
    let result = PyPendingDeprecationWarning(args: argsTuple, type: type)
    return .value(result)
  }

  // sourcery: pymethod = __init__
  internal func pyPendingDeprecationWarningInit(
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyNone> {
    return self.pyWarningInit(args: args, kwargs: kwargs)
  }
}

// MARK: - RuntimeWarning

// sourcery: pyerrortype = RuntimeWarning, default, baseType, hasGC, baseExceptionSubclass
public final class PyRuntimeWarning: PyWarning {

  // sourcery: pytypedoc
  internal static let runtimeWarningDoc = "Base class for warnings about dubious runtime behavior."

  /// Type to set in `init`.
  override internal class var pythonType: PyType {
    return Py.errorTypes.runtimeWarning
  }

  // sourcery: pyproperty = __class__
  internal static func getClass(runtimeWarning: PyRuntimeWarning) -> PyType {
    return runtimeWarning.type
  }

  // sourcery: pyproperty = __dict__
  internal static func getDict(runtimeWarning: PyRuntimeWarning) -> PyDict {
    return runtimeWarning.__dict__
  }

  // sourcery: pystaticmethod = __new__
  internal static func pyRuntimeWarningNew(
    type: PyType,
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyRuntimeWarning> {
    let argsTuple = Py.newTuple(elements: args)
    let result = PyRuntimeWarning(args: argsTuple, type: type)
    return .value(result)
  }

  // sourcery: pymethod = __init__
  internal func pyRuntimeWarningInit(
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyNone> {
    return self.pyWarningInit(args: args, kwargs: kwargs)
  }
}

// MARK: - SyntaxWarning

// sourcery: pyerrortype = SyntaxWarning, default, baseType, hasGC, baseExceptionSubclass
public final class PySyntaxWarning: PyWarning {

  // sourcery: pytypedoc
  internal static let syntaxWarningDoc = "Base class for warnings about dubious syntax."

  /// Type to set in `init`.
  override internal class var pythonType: PyType {
    return Py.errorTypes.syntaxWarning
  }

  // sourcery: pyproperty = __class__
  internal static func getClass(syntaxWarning: PySyntaxWarning) -> PyType {
    return syntaxWarning.type
  }

  // sourcery: pyproperty = __dict__
  internal static func getDict(syntaxWarning: PySyntaxWarning) -> PyDict {
    return syntaxWarning.__dict__
  }

  // sourcery: pystaticmethod = __new__
  internal static func pySyntaxWarningNew(
    type: PyType,
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PySyntaxWarning> {
    let argsTuple = Py.newTuple(elements: args)
    let result = PySyntaxWarning(args: argsTuple, type: type)
    return .value(result)
  }

  // sourcery: pymethod = __init__
  internal func pySyntaxWarningInit(
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyNone> {
    return self.pyWarningInit(args: args, kwargs: kwargs)
  }
}

// MARK: - UserWarning

// sourcery: pyerrortype = UserWarning, default, baseType, hasGC, baseExceptionSubclass
public final class PyUserWarning: PyWarning {

  // sourcery: pytypedoc
  internal static let userWarningDoc = "Base class for warnings generated by user code."

  /// Type to set in `init`.
  override internal class var pythonType: PyType {
    return Py.errorTypes.userWarning
  }

  // sourcery: pyproperty = __class__
  internal static func getClass(userWarning: PyUserWarning) -> PyType {
    return userWarning.type
  }

  // sourcery: pyproperty = __dict__
  internal static func getDict(userWarning: PyUserWarning) -> PyDict {
    return userWarning.__dict__
  }

  // sourcery: pystaticmethod = __new__
  internal static func pyUserWarningNew(
    type: PyType,
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyUserWarning> {
    let argsTuple = Py.newTuple(elements: args)
    let result = PyUserWarning(args: argsTuple, type: type)
    return .value(result)
  }

  // sourcery: pymethod = __init__
  internal func pyUserWarningInit(
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyNone> {
    return self.pyWarningInit(args: args, kwargs: kwargs)
  }
}

// MARK: - FutureWarning

// sourcery: pyerrortype = FutureWarning, default, baseType, hasGC, baseExceptionSubclass
public final class PyFutureWarning: PyWarning {

  // sourcery: pytypedoc
  internal static let futureWarningDoc = "Base class for warnings about constructs that will change semantically\n" +
"in the future."

  /// Type to set in `init`.
  override internal class var pythonType: PyType {
    return Py.errorTypes.futureWarning
  }

  // sourcery: pyproperty = __class__
  internal static func getClass(futureWarning: PyFutureWarning) -> PyType {
    return futureWarning.type
  }

  // sourcery: pyproperty = __dict__
  internal static func getDict(futureWarning: PyFutureWarning) -> PyDict {
    return futureWarning.__dict__
  }

  // sourcery: pystaticmethod = __new__
  internal static func pyFutureWarningNew(
    type: PyType,
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyFutureWarning> {
    let argsTuple = Py.newTuple(elements: args)
    let result = PyFutureWarning(args: argsTuple, type: type)
    return .value(result)
  }

  // sourcery: pymethod = __init__
  internal func pyFutureWarningInit(
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyNone> {
    return self.pyWarningInit(args: args, kwargs: kwargs)
  }
}

// MARK: - ImportWarning

// sourcery: pyerrortype = ImportWarning, default, baseType, hasGC, baseExceptionSubclass
public final class PyImportWarning: PyWarning {

  // sourcery: pytypedoc
  internal static let importWarningDoc = "Base class for warnings about probable mistakes in module imports"

  /// Type to set in `init`.
  override internal class var pythonType: PyType {
    return Py.errorTypes.importWarning
  }

  // sourcery: pyproperty = __class__
  internal static func getClass(importWarning: PyImportWarning) -> PyType {
    return importWarning.type
  }

  // sourcery: pyproperty = __dict__
  internal static func getDict(importWarning: PyImportWarning) -> PyDict {
    return importWarning.__dict__
  }

  // sourcery: pystaticmethod = __new__
  internal static func pyImportWarningNew(
    type: PyType,
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyImportWarning> {
    let argsTuple = Py.newTuple(elements: args)
    let result = PyImportWarning(args: argsTuple, type: type)
    return .value(result)
  }

  // sourcery: pymethod = __init__
  internal func pyImportWarningInit(
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyNone> {
    return self.pyWarningInit(args: args, kwargs: kwargs)
  }
}

// MARK: - UnicodeWarning

// sourcery: pyerrortype = UnicodeWarning, default, baseType, hasGC, baseExceptionSubclass
public final class PyUnicodeWarning: PyWarning {

  // sourcery: pytypedoc
  internal static let unicodeWarningDoc = "Base class for warnings about Unicode related problems, mostly\n" +
"related to conversion problems."

  /// Type to set in `init`.
  override internal class var pythonType: PyType {
    return Py.errorTypes.unicodeWarning
  }

  // sourcery: pyproperty = __class__
  internal static func getClass(unicodeWarning: PyUnicodeWarning) -> PyType {
    return unicodeWarning.type
  }

  // sourcery: pyproperty = __dict__
  internal static func getDict(unicodeWarning: PyUnicodeWarning) -> PyDict {
    return unicodeWarning.__dict__
  }

  // sourcery: pystaticmethod = __new__
  internal static func pyUnicodeWarningNew(
    type: PyType,
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyUnicodeWarning> {
    let argsTuple = Py.newTuple(elements: args)
    let result = PyUnicodeWarning(args: argsTuple, type: type)
    return .value(result)
  }

  // sourcery: pymethod = __init__
  internal func pyUnicodeWarningInit(
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyNone> {
    return self.pyWarningInit(args: args, kwargs: kwargs)
  }
}

// MARK: - BytesWarning

// sourcery: pyerrortype = BytesWarning, default, baseType, hasGC, baseExceptionSubclass
public final class PyBytesWarning: PyWarning {

  // sourcery: pytypedoc
  internal static let bytesWarningDoc = "Base class for warnings about bytes and buffer related problems, mostly\n" +
"related to conversion from str or comparing to str."

  /// Type to set in `init`.
  override internal class var pythonType: PyType {
    return Py.errorTypes.bytesWarning
  }

  // sourcery: pyproperty = __class__
  internal static func getClass(bytesWarning: PyBytesWarning) -> PyType {
    return bytesWarning.type
  }

  // sourcery: pyproperty = __dict__
  internal static func getDict(bytesWarning: PyBytesWarning) -> PyDict {
    return bytesWarning.__dict__
  }

  // sourcery: pystaticmethod = __new__
  internal static func pyBytesWarningNew(
    type: PyType,
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyBytesWarning> {
    let argsTuple = Py.newTuple(elements: args)
    let result = PyBytesWarning(args: argsTuple, type: type)
    return .value(result)
  }

  // sourcery: pymethod = __init__
  internal func pyBytesWarningInit(
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyNone> {
    return self.pyWarningInit(args: args, kwargs: kwargs)
  }
}

// MARK: - ResourceWarning

// sourcery: pyerrortype = ResourceWarning, default, baseType, hasGC, baseExceptionSubclass
public final class PyResourceWarning: PyWarning {

  // sourcery: pytypedoc
  internal static let resourceWarningDoc = "Base class for warnings about resource usage."

  /// Type to set in `init`.
  override internal class var pythonType: PyType {
    return Py.errorTypes.resourceWarning
  }

  // sourcery: pyproperty = __class__
  internal static func getClass(resourceWarning: PyResourceWarning) -> PyType {
    return resourceWarning.type
  }

  // sourcery: pyproperty = __dict__
  internal static func getDict(resourceWarning: PyResourceWarning) -> PyDict {
    return resourceWarning.__dict__
  }

  // sourcery: pystaticmethod = __new__
  internal static func pyResourceWarningNew(
    type: PyType,
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyResourceWarning> {
    let argsTuple = Py.newTuple(elements: args)
    let result = PyResourceWarning(args: argsTuple, type: type)
    return .value(result)
  }

  // sourcery: pymethod = __init__
  internal func pyResourceWarningInit(
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyNone> {
    return self.pyWarningInit(args: args, kwargs: kwargs)
  }
}

