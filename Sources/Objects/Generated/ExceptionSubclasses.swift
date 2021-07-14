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

  override public var description: String {
    return self.createDescription(typeName: "PyKeyboardInterrupt")
  }

  /// Type to set in `init`.
  override internal class var pythonType: PyType {
    return Py.errorTypes.keyboardInterrupt
  }

  // sourcery: pyproperty = __class__
  override internal func getClass() -> PyType {
    return self.type
  }

  // sourcery: pyproperty = __dict__
  override internal func getDict() -> PyDict {
    return self.__dict__
  }

  // sourcery: pystaticmethod = __new__
  internal class func pyKeyboardInterruptNew(
    type: PyType,
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyKeyboardInterrupt> {
    let argsTuple = Py.newTuple(elements: args)
    return .value(PyKeyboardInterrupt(args: argsTuple, type: type))
  }

  // sourcery: pymethod = __init__
  internal func pyKeyboardInterruptInit(
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyNone> {
    return super.pyBaseExceptionInit(args: args, kwargs: kwargs)
  }
}

// MARK: - GeneratorExit

// sourcery: pyerrortype = GeneratorExit, default, baseType, hasGC, baseExceptionSubclass
public final class PyGeneratorExit: PyBaseException {

  // sourcery: pytypedoc
  internal static let generatorExitDoc = "Request that a generator exit."

  override public var description: String {
    return self.createDescription(typeName: "PyGeneratorExit")
  }

  /// Type to set in `init`.
  override internal class var pythonType: PyType {
    return Py.errorTypes.generatorExit
  }

  // sourcery: pyproperty = __class__
  override internal func getClass() -> PyType {
    return self.type
  }

  // sourcery: pyproperty = __dict__
  override internal func getDict() -> PyDict {
    return self.__dict__
  }

  // sourcery: pystaticmethod = __new__
  internal class func pyGeneratorExitNew(
    type: PyType,
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyGeneratorExit> {
    let argsTuple = Py.newTuple(elements: args)
    return .value(PyGeneratorExit(args: argsTuple, type: type))
  }

  // sourcery: pymethod = __init__
  internal func pyGeneratorExitInit(
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyNone> {
    return super.pyBaseExceptionInit(args: args, kwargs: kwargs)
  }
}

// MARK: - Exception

// sourcery: pyerrortype = Exception, default, baseType, hasGC, baseExceptionSubclass
public class PyException: PyBaseException {

  // sourcery: pytypedoc
  internal static let exceptionDoc = "Common base class for all non-exit exceptions."

  override public var description: String {
    return self.createDescription(typeName: "PyException")
  }

  /// Type to set in `init`.
  override internal class var pythonType: PyType {
    return Py.errorTypes.exception
  }

  // sourcery: pyproperty = __class__
  override internal func getClass() -> PyType {
    return self.type
  }

  // sourcery: pyproperty = __dict__
  override internal func getDict() -> PyDict {
    return self.__dict__
  }

  // sourcery: pystaticmethod = __new__
  internal class func pyExceptionNew(
    type: PyType,
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyException> {
    let argsTuple = Py.newTuple(elements: args)
    return .value(PyException(args: argsTuple, type: type))
  }

  // sourcery: pymethod = __init__
  internal func pyExceptionInit(
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyNone> {
    return super.pyBaseExceptionInit(args: args, kwargs: kwargs)
  }
}

// MARK: - StopAsyncIteration

// sourcery: pyerrortype = StopAsyncIteration, default, baseType, hasGC, baseExceptionSubclass
public final class PyStopAsyncIteration: PyException {

  // sourcery: pytypedoc
  internal static let stopAsyncIterationDoc = "Signal the end from iterator.__anext__()."

  override public var description: String {
    return self.createDescription(typeName: "PyStopAsyncIteration")
  }

  /// Type to set in `init`.
  override internal class var pythonType: PyType {
    return Py.errorTypes.stopAsyncIteration
  }

  // sourcery: pyproperty = __class__
  override internal func getClass() -> PyType {
    return self.type
  }

  // sourcery: pyproperty = __dict__
  override internal func getDict() -> PyDict {
    return self.__dict__
  }

  // sourcery: pystaticmethod = __new__
  internal class func pyStopAsyncIterationNew(
    type: PyType,
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyStopAsyncIteration> {
    let argsTuple = Py.newTuple(elements: args)
    return .value(PyStopAsyncIteration(args: argsTuple, type: type))
  }

  // sourcery: pymethod = __init__
  internal func pyStopAsyncIterationInit(
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyNone> {
    return super.pyExceptionInit(args: args, kwargs: kwargs)
  }
}

// MARK: - ArithmeticError

// sourcery: pyerrortype = ArithmeticError, default, baseType, hasGC, baseExceptionSubclass
public class PyArithmeticError: PyException {

  // sourcery: pytypedoc
  internal static let arithmeticErrorDoc = "Base class for arithmetic errors."

  override public var description: String {
    return self.createDescription(typeName: "PyArithmeticError")
  }

  /// Type to set in `init`.
  override internal class var pythonType: PyType {
    return Py.errorTypes.arithmeticError
  }

  // sourcery: pyproperty = __class__
  override internal func getClass() -> PyType {
    return self.type
  }

  // sourcery: pyproperty = __dict__
  override internal func getDict() -> PyDict {
    return self.__dict__
  }

  // sourcery: pystaticmethod = __new__
  internal class func pyArithmeticErrorNew(
    type: PyType,
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyArithmeticError> {
    let argsTuple = Py.newTuple(elements: args)
    return .value(PyArithmeticError(args: argsTuple, type: type))
  }

  // sourcery: pymethod = __init__
  internal func pyArithmeticErrorInit(
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyNone> {
    return super.pyExceptionInit(args: args, kwargs: kwargs)
  }
}

// MARK: - FloatingPointError

// sourcery: pyerrortype = FloatingPointError, default, baseType, hasGC, baseExceptionSubclass
public final class PyFloatingPointError: PyArithmeticError {

  // sourcery: pytypedoc
  internal static let floatingPointErrorDoc = "Floating point operation failed."

  override public var description: String {
    return self.createDescription(typeName: "PyFloatingPointError")
  }

  /// Type to set in `init`.
  override internal class var pythonType: PyType {
    return Py.errorTypes.floatingPointError
  }

  // sourcery: pyproperty = __class__
  override internal func getClass() -> PyType {
    return self.type
  }

  // sourcery: pyproperty = __dict__
  override internal func getDict() -> PyDict {
    return self.__dict__
  }

  // sourcery: pystaticmethod = __new__
  internal class func pyFloatingPointErrorNew(
    type: PyType,
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyFloatingPointError> {
    let argsTuple = Py.newTuple(elements: args)
    return .value(PyFloatingPointError(args: argsTuple, type: type))
  }

  // sourcery: pymethod = __init__
  internal func pyFloatingPointErrorInit(
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyNone> {
    return super.pyArithmeticErrorInit(args: args, kwargs: kwargs)
  }
}

// MARK: - OverflowError

// sourcery: pyerrortype = OverflowError, default, baseType, hasGC, baseExceptionSubclass
public final class PyOverflowError: PyArithmeticError {

  // sourcery: pytypedoc
  internal static let overflowErrorDoc = "Result too large to be represented."

  override public var description: String {
    return self.createDescription(typeName: "PyOverflowError")
  }

  /// Type to set in `init`.
  override internal class var pythonType: PyType {
    return Py.errorTypes.overflowError
  }

  // sourcery: pyproperty = __class__
  override internal func getClass() -> PyType {
    return self.type
  }

  // sourcery: pyproperty = __dict__
  override internal func getDict() -> PyDict {
    return self.__dict__
  }

  // sourcery: pystaticmethod = __new__
  internal class func pyOverflowErrorNew(
    type: PyType,
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyOverflowError> {
    let argsTuple = Py.newTuple(elements: args)
    return .value(PyOverflowError(args: argsTuple, type: type))
  }

  // sourcery: pymethod = __init__
  internal func pyOverflowErrorInit(
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyNone> {
    return super.pyArithmeticErrorInit(args: args, kwargs: kwargs)
  }
}

// MARK: - ZeroDivisionError

// sourcery: pyerrortype = ZeroDivisionError, default, baseType, hasGC, baseExceptionSubclass
public final class PyZeroDivisionError: PyArithmeticError {

  // sourcery: pytypedoc
  internal static let zeroDivisionErrorDoc = "Second argument to a division or modulo operation was zero."

  override public var description: String {
    return self.createDescription(typeName: "PyZeroDivisionError")
  }

  /// Type to set in `init`.
  override internal class var pythonType: PyType {
    return Py.errorTypes.zeroDivisionError
  }

  // sourcery: pyproperty = __class__
  override internal func getClass() -> PyType {
    return self.type
  }

  // sourcery: pyproperty = __dict__
  override internal func getDict() -> PyDict {
    return self.__dict__
  }

  // sourcery: pystaticmethod = __new__
  internal class func pyZeroDivisionErrorNew(
    type: PyType,
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyZeroDivisionError> {
    let argsTuple = Py.newTuple(elements: args)
    return .value(PyZeroDivisionError(args: argsTuple, type: type))
  }

  // sourcery: pymethod = __init__
  internal func pyZeroDivisionErrorInit(
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyNone> {
    return super.pyArithmeticErrorInit(args: args, kwargs: kwargs)
  }
}

// MARK: - AssertionError

// sourcery: pyerrortype = AssertionError, default, baseType, hasGC, baseExceptionSubclass
public final class PyAssertionError: PyException {

  // sourcery: pytypedoc
  internal static let assertionErrorDoc = "Assertion failed."

  override public var description: String {
    return self.createDescription(typeName: "PyAssertionError")
  }

  /// Type to set in `init`.
  override internal class var pythonType: PyType {
    return Py.errorTypes.assertionError
  }

  // sourcery: pyproperty = __class__
  override internal func getClass() -> PyType {
    return self.type
  }

  // sourcery: pyproperty = __dict__
  override internal func getDict() -> PyDict {
    return self.__dict__
  }

  // sourcery: pystaticmethod = __new__
  internal class func pyAssertionErrorNew(
    type: PyType,
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyAssertionError> {
    let argsTuple = Py.newTuple(elements: args)
    return .value(PyAssertionError(args: argsTuple, type: type))
  }

  // sourcery: pymethod = __init__
  internal func pyAssertionErrorInit(
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyNone> {
    return super.pyExceptionInit(args: args, kwargs: kwargs)
  }
}

// MARK: - AttributeError

// sourcery: pyerrortype = AttributeError, default, baseType, hasGC, baseExceptionSubclass
public final class PyAttributeError: PyException {

  // sourcery: pytypedoc
  internal static let attributeErrorDoc = "Attribute not found."

  override public var description: String {
    return self.createDescription(typeName: "PyAttributeError")
  }

  /// Type to set in `init`.
  override internal class var pythonType: PyType {
    return Py.errorTypes.attributeError
  }

  // sourcery: pyproperty = __class__
  override internal func getClass() -> PyType {
    return self.type
  }

  // sourcery: pyproperty = __dict__
  override internal func getDict() -> PyDict {
    return self.__dict__
  }

  // sourcery: pystaticmethod = __new__
  internal class func pyAttributeErrorNew(
    type: PyType,
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyAttributeError> {
    let argsTuple = Py.newTuple(elements: args)
    return .value(PyAttributeError(args: argsTuple, type: type))
  }

  // sourcery: pymethod = __init__
  internal func pyAttributeErrorInit(
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyNone> {
    return super.pyExceptionInit(args: args, kwargs: kwargs)
  }
}

// MARK: - BufferError

// sourcery: pyerrortype = BufferError, default, baseType, hasGC, baseExceptionSubclass
public final class PyBufferError: PyException {

  // sourcery: pytypedoc
  internal static let bufferErrorDoc = "Buffer error."

  override public var description: String {
    return self.createDescription(typeName: "PyBufferError")
  }

  /// Type to set in `init`.
  override internal class var pythonType: PyType {
    return Py.errorTypes.bufferError
  }

  // sourcery: pyproperty = __class__
  override internal func getClass() -> PyType {
    return self.type
  }

  // sourcery: pyproperty = __dict__
  override internal func getDict() -> PyDict {
    return self.__dict__
  }

  // sourcery: pystaticmethod = __new__
  internal class func pyBufferErrorNew(
    type: PyType,
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyBufferError> {
    let argsTuple = Py.newTuple(elements: args)
    return .value(PyBufferError(args: argsTuple, type: type))
  }

  // sourcery: pymethod = __init__
  internal func pyBufferErrorInit(
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyNone> {
    return super.pyExceptionInit(args: args, kwargs: kwargs)
  }
}

// MARK: - EOFError

// sourcery: pyerrortype = EOFError, default, baseType, hasGC, baseExceptionSubclass
public final class PyEOFError: PyException {

  // sourcery: pytypedoc
  internal static let eOFErrorDoc = "Read beyond end of file."

  override public var description: String {
    return self.createDescription(typeName: "PyEOFError")
  }

  /// Type to set in `init`.
  override internal class var pythonType: PyType {
    return Py.errorTypes.eofError
  }

  // sourcery: pyproperty = __class__
  override internal func getClass() -> PyType {
    return self.type
  }

  // sourcery: pyproperty = __dict__
  override internal func getDict() -> PyDict {
    return self.__dict__
  }

  // sourcery: pystaticmethod = __new__
  internal class func pyEOFErrorNew(
    type: PyType,
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyEOFError> {
    let argsTuple = Py.newTuple(elements: args)
    return .value(PyEOFError(args: argsTuple, type: type))
  }

  // sourcery: pymethod = __init__
  internal func pyEOFErrorInit(
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyNone> {
    return super.pyExceptionInit(args: args, kwargs: kwargs)
  }
}

// MARK: - ModuleNotFoundError

// sourcery: pyerrortype = ModuleNotFoundError, default, baseType, hasGC, baseExceptionSubclass
public final class PyModuleNotFoundError: PyImportError {

  // sourcery: pytypedoc
  internal static let moduleNotFoundErrorDoc = "Module not found."

  override public var description: String {
    return self.createDescription(typeName: "PyModuleNotFoundError")
  }

  /// Type to set in `init`.
  override internal class var pythonType: PyType {
    return Py.errorTypes.moduleNotFoundError
  }

  // sourcery: pyproperty = __class__
  override internal func getClass() -> PyType {
    return self.type
  }

  // sourcery: pyproperty = __dict__
  override internal func getDict() -> PyDict {
    return self.__dict__
  }

  // sourcery: pystaticmethod = __new__
  internal class func pyModuleNotFoundErrorNew(
    type: PyType,
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyModuleNotFoundError> {
    let argsTuple = Py.newTuple(elements: args)
    return .value(PyModuleNotFoundError(args: argsTuple, type: type))
  }

  // sourcery: pymethod = __init__
  internal func pyModuleNotFoundErrorInit(
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyNone> {
    return super.pyImportErrorInit(args: args, kwargs: kwargs)
  }
}

// MARK: - LookupError

// sourcery: pyerrortype = LookupError, default, baseType, hasGC, baseExceptionSubclass
public class PyLookupError: PyException {

  // sourcery: pytypedoc
  internal static let lookupErrorDoc = "Base class for lookup errors."

  override public var description: String {
    return self.createDescription(typeName: "PyLookupError")
  }

  /// Type to set in `init`.
  override internal class var pythonType: PyType {
    return Py.errorTypes.lookupError
  }

  // sourcery: pyproperty = __class__
  override internal func getClass() -> PyType {
    return self.type
  }

  // sourcery: pyproperty = __dict__
  override internal func getDict() -> PyDict {
    return self.__dict__
  }

  // sourcery: pystaticmethod = __new__
  internal class func pyLookupErrorNew(
    type: PyType,
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyLookupError> {
    let argsTuple = Py.newTuple(elements: args)
    return .value(PyLookupError(args: argsTuple, type: type))
  }

  // sourcery: pymethod = __init__
  internal func pyLookupErrorInit(
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyNone> {
    return super.pyExceptionInit(args: args, kwargs: kwargs)
  }
}

// MARK: - IndexError

// sourcery: pyerrortype = IndexError, default, baseType, hasGC, baseExceptionSubclass
public final class PyIndexError: PyLookupError {

  // sourcery: pytypedoc
  internal static let indexErrorDoc = "Sequence index out of range."

  override public var description: String {
    return self.createDescription(typeName: "PyIndexError")
  }

  /// Type to set in `init`.
  override internal class var pythonType: PyType {
    return Py.errorTypes.indexError
  }

  // sourcery: pyproperty = __class__
  override internal func getClass() -> PyType {
    return self.type
  }

  // sourcery: pyproperty = __dict__
  override internal func getDict() -> PyDict {
    return self.__dict__
  }

  // sourcery: pystaticmethod = __new__
  internal class func pyIndexErrorNew(
    type: PyType,
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyIndexError> {
    let argsTuple = Py.newTuple(elements: args)
    return .value(PyIndexError(args: argsTuple, type: type))
  }

  // sourcery: pymethod = __init__
  internal func pyIndexErrorInit(
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyNone> {
    return super.pyLookupErrorInit(args: args, kwargs: kwargs)
  }
}

// MARK: - MemoryError

// sourcery: pyerrortype = MemoryError, default, baseType, hasGC, baseExceptionSubclass
public final class PyMemoryError: PyException {

  // sourcery: pytypedoc
  internal static let memoryErrorDoc = "Out of memory."

  override public var description: String {
    return self.createDescription(typeName: "PyMemoryError")
  }

  /// Type to set in `init`.
  override internal class var pythonType: PyType {
    return Py.errorTypes.memoryError
  }

  // sourcery: pyproperty = __class__
  override internal func getClass() -> PyType {
    return self.type
  }

  // sourcery: pyproperty = __dict__
  override internal func getDict() -> PyDict {
    return self.__dict__
  }

  // sourcery: pystaticmethod = __new__
  internal class func pyMemoryErrorNew(
    type: PyType,
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyMemoryError> {
    let argsTuple = Py.newTuple(elements: args)
    return .value(PyMemoryError(args: argsTuple, type: type))
  }

  // sourcery: pymethod = __init__
  internal func pyMemoryErrorInit(
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyNone> {
    return super.pyExceptionInit(args: args, kwargs: kwargs)
  }
}

// MARK: - NameError

// sourcery: pyerrortype = NameError, default, baseType, hasGC, baseExceptionSubclass
public class PyNameError: PyException {

  // sourcery: pytypedoc
  internal static let nameErrorDoc = "Name not found globally."

  override public var description: String {
    return self.createDescription(typeName: "PyNameError")
  }

  /// Type to set in `init`.
  override internal class var pythonType: PyType {
    return Py.errorTypes.nameError
  }

  // sourcery: pyproperty = __class__
  override internal func getClass() -> PyType {
    return self.type
  }

  // sourcery: pyproperty = __dict__
  override internal func getDict() -> PyDict {
    return self.__dict__
  }

  // sourcery: pystaticmethod = __new__
  internal class func pyNameErrorNew(
    type: PyType,
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyNameError> {
    let argsTuple = Py.newTuple(elements: args)
    return .value(PyNameError(args: argsTuple, type: type))
  }

  // sourcery: pymethod = __init__
  internal func pyNameErrorInit(
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyNone> {
    return super.pyExceptionInit(args: args, kwargs: kwargs)
  }
}

// MARK: - UnboundLocalError

// sourcery: pyerrortype = UnboundLocalError, default, baseType, hasGC, baseExceptionSubclass
public final class PyUnboundLocalError: PyNameError {

  // sourcery: pytypedoc
  internal static let unboundLocalErrorDoc = "Local name referenced but not bound to a value."

  override public var description: String {
    return self.createDescription(typeName: "PyUnboundLocalError")
  }

  /// Type to set in `init`.
  override internal class var pythonType: PyType {
    return Py.errorTypes.unboundLocalError
  }

  // sourcery: pyproperty = __class__
  override internal func getClass() -> PyType {
    return self.type
  }

  // sourcery: pyproperty = __dict__
  override internal func getDict() -> PyDict {
    return self.__dict__
  }

  // sourcery: pystaticmethod = __new__
  internal class func pyUnboundLocalErrorNew(
    type: PyType,
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyUnboundLocalError> {
    let argsTuple = Py.newTuple(elements: args)
    return .value(PyUnboundLocalError(args: argsTuple, type: type))
  }

  // sourcery: pymethod = __init__
  internal func pyUnboundLocalErrorInit(
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyNone> {
    return super.pyNameErrorInit(args: args, kwargs: kwargs)
  }
}

// MARK: - OSError

// sourcery: pyerrortype = OSError, default, baseType, hasGC, baseExceptionSubclass
public class PyOSError: PyException {

  // sourcery: pytypedoc
  internal static let oSErrorDoc = "Base class for I/O related errors."

  override public var description: String {
    return self.createDescription(typeName: "PyOSError")
  }

  /// Type to set in `init`.
  override internal class var pythonType: PyType {
    return Py.errorTypes.osError
  }

  // sourcery: pyproperty = __class__
  override internal func getClass() -> PyType {
    return self.type
  }

  // sourcery: pyproperty = __dict__
  override internal func getDict() -> PyDict {
    return self.__dict__
  }

  // sourcery: pystaticmethod = __new__
  internal class func pyOSErrorNew(
    type: PyType,
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyOSError> {
    let argsTuple = Py.newTuple(elements: args)
    return .value(PyOSError(args: argsTuple, type: type))
  }

  // sourcery: pymethod = __init__
  internal func pyOSErrorInit(
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyNone> {
    return super.pyExceptionInit(args: args, kwargs: kwargs)
  }
}

// MARK: - BlockingIOError

// sourcery: pyerrortype = BlockingIOError, default, baseType, hasGC, baseExceptionSubclass
public final class PyBlockingIOError: PyOSError {

  // sourcery: pytypedoc
  internal static let blockingIOErrorDoc = "I/O operation would block."

  override public var description: String {
    return self.createDescription(typeName: "PyBlockingIOError")
  }

  /// Type to set in `init`.
  override internal class var pythonType: PyType {
    return Py.errorTypes.blockingIOError
  }

  // sourcery: pyproperty = __class__
  override internal func getClass() -> PyType {
    return self.type
  }

  // sourcery: pyproperty = __dict__
  override internal func getDict() -> PyDict {
    return self.__dict__
  }

  // sourcery: pystaticmethod = __new__
  internal class func pyBlockingIOErrorNew(
    type: PyType,
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyBlockingIOError> {
    let argsTuple = Py.newTuple(elements: args)
    return .value(PyBlockingIOError(args: argsTuple, type: type))
  }

  // sourcery: pymethod = __init__
  internal func pyBlockingIOErrorInit(
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyNone> {
    return super.pyOSErrorInit(args: args, kwargs: kwargs)
  }
}

// MARK: - ChildProcessError

// sourcery: pyerrortype = ChildProcessError, default, baseType, hasGC, baseExceptionSubclass
public final class PyChildProcessError: PyOSError {

  // sourcery: pytypedoc
  internal static let childProcessErrorDoc = "Child process error."

  override public var description: String {
    return self.createDescription(typeName: "PyChildProcessError")
  }

  /// Type to set in `init`.
  override internal class var pythonType: PyType {
    return Py.errorTypes.childProcessError
  }

  // sourcery: pyproperty = __class__
  override internal func getClass() -> PyType {
    return self.type
  }

  // sourcery: pyproperty = __dict__
  override internal func getDict() -> PyDict {
    return self.__dict__
  }

  // sourcery: pystaticmethod = __new__
  internal class func pyChildProcessErrorNew(
    type: PyType,
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyChildProcessError> {
    let argsTuple = Py.newTuple(elements: args)
    return .value(PyChildProcessError(args: argsTuple, type: type))
  }

  // sourcery: pymethod = __init__
  internal func pyChildProcessErrorInit(
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyNone> {
    return super.pyOSErrorInit(args: args, kwargs: kwargs)
  }
}

// MARK: - ConnectionError

// sourcery: pyerrortype = ConnectionError, default, baseType, hasGC, baseExceptionSubclass
public class PyConnectionError: PyOSError {

  // sourcery: pytypedoc
  internal static let connectionErrorDoc = "Connection error."

  override public var description: String {
    return self.createDescription(typeName: "PyConnectionError")
  }

  /// Type to set in `init`.
  override internal class var pythonType: PyType {
    return Py.errorTypes.connectionError
  }

  // sourcery: pyproperty = __class__
  override internal func getClass() -> PyType {
    return self.type
  }

  // sourcery: pyproperty = __dict__
  override internal func getDict() -> PyDict {
    return self.__dict__
  }

  // sourcery: pystaticmethod = __new__
  internal class func pyConnectionErrorNew(
    type: PyType,
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyConnectionError> {
    let argsTuple = Py.newTuple(elements: args)
    return .value(PyConnectionError(args: argsTuple, type: type))
  }

  // sourcery: pymethod = __init__
  internal func pyConnectionErrorInit(
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyNone> {
    return super.pyOSErrorInit(args: args, kwargs: kwargs)
  }
}

// MARK: - BrokenPipeError

// sourcery: pyerrortype = BrokenPipeError, default, baseType, hasGC, baseExceptionSubclass
public final class PyBrokenPipeError: PyConnectionError {

  // sourcery: pytypedoc
  internal static let brokenPipeErrorDoc = "Broken pipe."

  override public var description: String {
    return self.createDescription(typeName: "PyBrokenPipeError")
  }

  /// Type to set in `init`.
  override internal class var pythonType: PyType {
    return Py.errorTypes.brokenPipeError
  }

  // sourcery: pyproperty = __class__
  override internal func getClass() -> PyType {
    return self.type
  }

  // sourcery: pyproperty = __dict__
  override internal func getDict() -> PyDict {
    return self.__dict__
  }

  // sourcery: pystaticmethod = __new__
  internal class func pyBrokenPipeErrorNew(
    type: PyType,
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyBrokenPipeError> {
    let argsTuple = Py.newTuple(elements: args)
    return .value(PyBrokenPipeError(args: argsTuple, type: type))
  }

  // sourcery: pymethod = __init__
  internal func pyBrokenPipeErrorInit(
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyNone> {
    return super.pyConnectionErrorInit(args: args, kwargs: kwargs)
  }
}

// MARK: - ConnectionAbortedError

// sourcery: pyerrortype = ConnectionAbortedError, default, baseType, hasGC, baseExceptionSubclass
public final class PyConnectionAbortedError: PyConnectionError {

  // sourcery: pytypedoc
  internal static let connectionAbortedErrorDoc = "Connection aborted."

  override public var description: String {
    return self.createDescription(typeName: "PyConnectionAbortedError")
  }

  /// Type to set in `init`.
  override internal class var pythonType: PyType {
    return Py.errorTypes.connectionAbortedError
  }

  // sourcery: pyproperty = __class__
  override internal func getClass() -> PyType {
    return self.type
  }

  // sourcery: pyproperty = __dict__
  override internal func getDict() -> PyDict {
    return self.__dict__
  }

  // sourcery: pystaticmethod = __new__
  internal class func pyConnectionAbortedErrorNew(
    type: PyType,
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyConnectionAbortedError> {
    let argsTuple = Py.newTuple(elements: args)
    return .value(PyConnectionAbortedError(args: argsTuple, type: type))
  }

  // sourcery: pymethod = __init__
  internal func pyConnectionAbortedErrorInit(
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyNone> {
    return super.pyConnectionErrorInit(args: args, kwargs: kwargs)
  }
}

// MARK: - ConnectionRefusedError

// sourcery: pyerrortype = ConnectionRefusedError, default, baseType, hasGC, baseExceptionSubclass
public final class PyConnectionRefusedError: PyConnectionError {

  // sourcery: pytypedoc
  internal static let connectionRefusedErrorDoc = "Connection refused."

  override public var description: String {
    return self.createDescription(typeName: "PyConnectionRefusedError")
  }

  /// Type to set in `init`.
  override internal class var pythonType: PyType {
    return Py.errorTypes.connectionRefusedError
  }

  // sourcery: pyproperty = __class__
  override internal func getClass() -> PyType {
    return self.type
  }

  // sourcery: pyproperty = __dict__
  override internal func getDict() -> PyDict {
    return self.__dict__
  }

  // sourcery: pystaticmethod = __new__
  internal class func pyConnectionRefusedErrorNew(
    type: PyType,
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyConnectionRefusedError> {
    let argsTuple = Py.newTuple(elements: args)
    return .value(PyConnectionRefusedError(args: argsTuple, type: type))
  }

  // sourcery: pymethod = __init__
  internal func pyConnectionRefusedErrorInit(
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyNone> {
    return super.pyConnectionErrorInit(args: args, kwargs: kwargs)
  }
}

// MARK: - ConnectionResetError

// sourcery: pyerrortype = ConnectionResetError, default, baseType, hasGC, baseExceptionSubclass
public final class PyConnectionResetError: PyConnectionError {

  // sourcery: pytypedoc
  internal static let connectionResetErrorDoc = "Connection reset."

  override public var description: String {
    return self.createDescription(typeName: "PyConnectionResetError")
  }

  /// Type to set in `init`.
  override internal class var pythonType: PyType {
    return Py.errorTypes.connectionResetError
  }

  // sourcery: pyproperty = __class__
  override internal func getClass() -> PyType {
    return self.type
  }

  // sourcery: pyproperty = __dict__
  override internal func getDict() -> PyDict {
    return self.__dict__
  }

  // sourcery: pystaticmethod = __new__
  internal class func pyConnectionResetErrorNew(
    type: PyType,
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyConnectionResetError> {
    let argsTuple = Py.newTuple(elements: args)
    return .value(PyConnectionResetError(args: argsTuple, type: type))
  }

  // sourcery: pymethod = __init__
  internal func pyConnectionResetErrorInit(
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyNone> {
    return super.pyConnectionErrorInit(args: args, kwargs: kwargs)
  }
}

// MARK: - FileExistsError

// sourcery: pyerrortype = FileExistsError, default, baseType, hasGC, baseExceptionSubclass
public final class PyFileExistsError: PyOSError {

  // sourcery: pytypedoc
  internal static let fileExistsErrorDoc = "File already exists."

  override public var description: String {
    return self.createDescription(typeName: "PyFileExistsError")
  }

  /// Type to set in `init`.
  override internal class var pythonType: PyType {
    return Py.errorTypes.fileExistsError
  }

  // sourcery: pyproperty = __class__
  override internal func getClass() -> PyType {
    return self.type
  }

  // sourcery: pyproperty = __dict__
  override internal func getDict() -> PyDict {
    return self.__dict__
  }

  // sourcery: pystaticmethod = __new__
  internal class func pyFileExistsErrorNew(
    type: PyType,
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyFileExistsError> {
    let argsTuple = Py.newTuple(elements: args)
    return .value(PyFileExistsError(args: argsTuple, type: type))
  }

  // sourcery: pymethod = __init__
  internal func pyFileExistsErrorInit(
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyNone> {
    return super.pyOSErrorInit(args: args, kwargs: kwargs)
  }
}

// MARK: - FileNotFoundError

// sourcery: pyerrortype = FileNotFoundError, default, baseType, hasGC, baseExceptionSubclass
public final class PyFileNotFoundError: PyOSError {

  // sourcery: pytypedoc
  internal static let fileNotFoundErrorDoc = "File not found."

  override public var description: String {
    return self.createDescription(typeName: "PyFileNotFoundError")
  }

  /// Type to set in `init`.
  override internal class var pythonType: PyType {
    return Py.errorTypes.fileNotFoundError
  }

  // sourcery: pyproperty = __class__
  override internal func getClass() -> PyType {
    return self.type
  }

  // sourcery: pyproperty = __dict__
  override internal func getDict() -> PyDict {
    return self.__dict__
  }

  // sourcery: pystaticmethod = __new__
  internal class func pyFileNotFoundErrorNew(
    type: PyType,
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyFileNotFoundError> {
    let argsTuple = Py.newTuple(elements: args)
    return .value(PyFileNotFoundError(args: argsTuple, type: type))
  }

  // sourcery: pymethod = __init__
  internal func pyFileNotFoundErrorInit(
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyNone> {
    return super.pyOSErrorInit(args: args, kwargs: kwargs)
  }
}

// MARK: - InterruptedError

// sourcery: pyerrortype = InterruptedError, default, baseType, hasGC, baseExceptionSubclass
public final class PyInterruptedError: PyOSError {

  // sourcery: pytypedoc
  internal static let interruptedErrorDoc = "Interrupted by signal."

  override public var description: String {
    return self.createDescription(typeName: "PyInterruptedError")
  }

  /// Type to set in `init`.
  override internal class var pythonType: PyType {
    return Py.errorTypes.interruptedError
  }

  // sourcery: pyproperty = __class__
  override internal func getClass() -> PyType {
    return self.type
  }

  // sourcery: pyproperty = __dict__
  override internal func getDict() -> PyDict {
    return self.__dict__
  }

  // sourcery: pystaticmethod = __new__
  internal class func pyInterruptedErrorNew(
    type: PyType,
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyInterruptedError> {
    let argsTuple = Py.newTuple(elements: args)
    return .value(PyInterruptedError(args: argsTuple, type: type))
  }

  // sourcery: pymethod = __init__
  internal func pyInterruptedErrorInit(
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyNone> {
    return super.pyOSErrorInit(args: args, kwargs: kwargs)
  }
}

// MARK: - IsADirectoryError

// sourcery: pyerrortype = IsADirectoryError, default, baseType, hasGC, baseExceptionSubclass
public final class PyIsADirectoryError: PyOSError {

  // sourcery: pytypedoc
  internal static let isADirectoryErrorDoc = "Operation doesn't work on directories."

  override public var description: String {
    return self.createDescription(typeName: "PyIsADirectoryError")
  }

  /// Type to set in `init`.
  override internal class var pythonType: PyType {
    return Py.errorTypes.isADirectoryError
  }

  // sourcery: pyproperty = __class__
  override internal func getClass() -> PyType {
    return self.type
  }

  // sourcery: pyproperty = __dict__
  override internal func getDict() -> PyDict {
    return self.__dict__
  }

  // sourcery: pystaticmethod = __new__
  internal class func pyIsADirectoryErrorNew(
    type: PyType,
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyIsADirectoryError> {
    let argsTuple = Py.newTuple(elements: args)
    return .value(PyIsADirectoryError(args: argsTuple, type: type))
  }

  // sourcery: pymethod = __init__
  internal func pyIsADirectoryErrorInit(
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyNone> {
    return super.pyOSErrorInit(args: args, kwargs: kwargs)
  }
}

// MARK: - NotADirectoryError

// sourcery: pyerrortype = NotADirectoryError, default, baseType, hasGC, baseExceptionSubclass
public final class PyNotADirectoryError: PyOSError {

  // sourcery: pytypedoc
  internal static let notADirectoryErrorDoc = "Operation only works on directories."

  override public var description: String {
    return self.createDescription(typeName: "PyNotADirectoryError")
  }

  /// Type to set in `init`.
  override internal class var pythonType: PyType {
    return Py.errorTypes.notADirectoryError
  }

  // sourcery: pyproperty = __class__
  override internal func getClass() -> PyType {
    return self.type
  }

  // sourcery: pyproperty = __dict__
  override internal func getDict() -> PyDict {
    return self.__dict__
  }

  // sourcery: pystaticmethod = __new__
  internal class func pyNotADirectoryErrorNew(
    type: PyType,
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyNotADirectoryError> {
    let argsTuple = Py.newTuple(elements: args)
    return .value(PyNotADirectoryError(args: argsTuple, type: type))
  }

  // sourcery: pymethod = __init__
  internal func pyNotADirectoryErrorInit(
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyNone> {
    return super.pyOSErrorInit(args: args, kwargs: kwargs)
  }
}

// MARK: - PermissionError

// sourcery: pyerrortype = PermissionError, default, baseType, hasGC, baseExceptionSubclass
public final class PyPermissionError: PyOSError {

  // sourcery: pytypedoc
  internal static let permissionErrorDoc = "Not enough permissions."

  override public var description: String {
    return self.createDescription(typeName: "PyPermissionError")
  }

  /// Type to set in `init`.
  override internal class var pythonType: PyType {
    return Py.errorTypes.permissionError
  }

  // sourcery: pyproperty = __class__
  override internal func getClass() -> PyType {
    return self.type
  }

  // sourcery: pyproperty = __dict__
  override internal func getDict() -> PyDict {
    return self.__dict__
  }

  // sourcery: pystaticmethod = __new__
  internal class func pyPermissionErrorNew(
    type: PyType,
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyPermissionError> {
    let argsTuple = Py.newTuple(elements: args)
    return .value(PyPermissionError(args: argsTuple, type: type))
  }

  // sourcery: pymethod = __init__
  internal func pyPermissionErrorInit(
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyNone> {
    return super.pyOSErrorInit(args: args, kwargs: kwargs)
  }
}

// MARK: - ProcessLookupError

// sourcery: pyerrortype = ProcessLookupError, default, baseType, hasGC, baseExceptionSubclass
public final class PyProcessLookupError: PyOSError {

  // sourcery: pytypedoc
  internal static let processLookupErrorDoc = "Process not found."

  override public var description: String {
    return self.createDescription(typeName: "PyProcessLookupError")
  }

  /// Type to set in `init`.
  override internal class var pythonType: PyType {
    return Py.errorTypes.processLookupError
  }

  // sourcery: pyproperty = __class__
  override internal func getClass() -> PyType {
    return self.type
  }

  // sourcery: pyproperty = __dict__
  override internal func getDict() -> PyDict {
    return self.__dict__
  }

  // sourcery: pystaticmethod = __new__
  internal class func pyProcessLookupErrorNew(
    type: PyType,
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyProcessLookupError> {
    let argsTuple = Py.newTuple(elements: args)
    return .value(PyProcessLookupError(args: argsTuple, type: type))
  }

  // sourcery: pymethod = __init__
  internal func pyProcessLookupErrorInit(
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyNone> {
    return super.pyOSErrorInit(args: args, kwargs: kwargs)
  }
}

// MARK: - TimeoutError

// sourcery: pyerrortype = TimeoutError, default, baseType, hasGC, baseExceptionSubclass
public final class PyTimeoutError: PyOSError {

  // sourcery: pytypedoc
  internal static let timeoutErrorDoc = "Timeout expired."

  override public var description: String {
    return self.createDescription(typeName: "PyTimeoutError")
  }

  /// Type to set in `init`.
  override internal class var pythonType: PyType {
    return Py.errorTypes.timeoutError
  }

  // sourcery: pyproperty = __class__
  override internal func getClass() -> PyType {
    return self.type
  }

  // sourcery: pyproperty = __dict__
  override internal func getDict() -> PyDict {
    return self.__dict__
  }

  // sourcery: pystaticmethod = __new__
  internal class func pyTimeoutErrorNew(
    type: PyType,
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyTimeoutError> {
    let argsTuple = Py.newTuple(elements: args)
    return .value(PyTimeoutError(args: argsTuple, type: type))
  }

  // sourcery: pymethod = __init__
  internal func pyTimeoutErrorInit(
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyNone> {
    return super.pyOSErrorInit(args: args, kwargs: kwargs)
  }
}

// MARK: - ReferenceError

// sourcery: pyerrortype = ReferenceError, default, baseType, hasGC, baseExceptionSubclass
public final class PyReferenceError: PyException {

  // sourcery: pytypedoc
  internal static let referenceErrorDoc = "Weak ref proxy used after referent went away."

  override public var description: String {
    return self.createDescription(typeName: "PyReferenceError")
  }

  /// Type to set in `init`.
  override internal class var pythonType: PyType {
    return Py.errorTypes.referenceError
  }

  // sourcery: pyproperty = __class__
  override internal func getClass() -> PyType {
    return self.type
  }

  // sourcery: pyproperty = __dict__
  override internal func getDict() -> PyDict {
    return self.__dict__
  }

  // sourcery: pystaticmethod = __new__
  internal class func pyReferenceErrorNew(
    type: PyType,
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyReferenceError> {
    let argsTuple = Py.newTuple(elements: args)
    return .value(PyReferenceError(args: argsTuple, type: type))
  }

  // sourcery: pymethod = __init__
  internal func pyReferenceErrorInit(
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyNone> {
    return super.pyExceptionInit(args: args, kwargs: kwargs)
  }
}

// MARK: - RuntimeError

// sourcery: pyerrortype = RuntimeError, default, baseType, hasGC, baseExceptionSubclass
public class PyRuntimeError: PyException {

  // sourcery: pytypedoc
  internal static let runtimeErrorDoc = "Unspecified run-time error."

  override public var description: String {
    return self.createDescription(typeName: "PyRuntimeError")
  }

  /// Type to set in `init`.
  override internal class var pythonType: PyType {
    return Py.errorTypes.runtimeError
  }

  // sourcery: pyproperty = __class__
  override internal func getClass() -> PyType {
    return self.type
  }

  // sourcery: pyproperty = __dict__
  override internal func getDict() -> PyDict {
    return self.__dict__
  }

  // sourcery: pystaticmethod = __new__
  internal class func pyRuntimeErrorNew(
    type: PyType,
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyRuntimeError> {
    let argsTuple = Py.newTuple(elements: args)
    return .value(PyRuntimeError(args: argsTuple, type: type))
  }

  // sourcery: pymethod = __init__
  internal func pyRuntimeErrorInit(
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyNone> {
    return super.pyExceptionInit(args: args, kwargs: kwargs)
  }
}

// MARK: - NotImplementedError

// sourcery: pyerrortype = NotImplementedError, default, baseType, hasGC, baseExceptionSubclass
public final class PyNotImplementedError: PyRuntimeError {

  // sourcery: pytypedoc
  internal static let notImplementedErrorDoc = "Method or function hasn't been implemented yet."

  override public var description: String {
    return self.createDescription(typeName: "PyNotImplementedError")
  }

  /// Type to set in `init`.
  override internal class var pythonType: PyType {
    return Py.errorTypes.notImplementedError
  }

  // sourcery: pyproperty = __class__
  override internal func getClass() -> PyType {
    return self.type
  }

  // sourcery: pyproperty = __dict__
  override internal func getDict() -> PyDict {
    return self.__dict__
  }

  // sourcery: pystaticmethod = __new__
  internal class func pyNotImplementedErrorNew(
    type: PyType,
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyNotImplementedError> {
    let argsTuple = Py.newTuple(elements: args)
    return .value(PyNotImplementedError(args: argsTuple, type: type))
  }

  // sourcery: pymethod = __init__
  internal func pyNotImplementedErrorInit(
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyNone> {
    return super.pyRuntimeErrorInit(args: args, kwargs: kwargs)
  }
}

// MARK: - RecursionError

// sourcery: pyerrortype = RecursionError, default, baseType, hasGC, baseExceptionSubclass
public final class PyRecursionError: PyRuntimeError {

  // sourcery: pytypedoc
  internal static let recursionErrorDoc = "Recursion limit exceeded."

  override public var description: String {
    return self.createDescription(typeName: "PyRecursionError")
  }

  /// Type to set in `init`.
  override internal class var pythonType: PyType {
    return Py.errorTypes.recursionError
  }

  // sourcery: pyproperty = __class__
  override internal func getClass() -> PyType {
    return self.type
  }

  // sourcery: pyproperty = __dict__
  override internal func getDict() -> PyDict {
    return self.__dict__
  }

  // sourcery: pystaticmethod = __new__
  internal class func pyRecursionErrorNew(
    type: PyType,
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyRecursionError> {
    let argsTuple = Py.newTuple(elements: args)
    return .value(PyRecursionError(args: argsTuple, type: type))
  }

  // sourcery: pymethod = __init__
  internal func pyRecursionErrorInit(
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyNone> {
    return super.pyRuntimeErrorInit(args: args, kwargs: kwargs)
  }
}

// MARK: - IndentationError

// sourcery: pyerrortype = IndentationError, default, baseType, hasGC, baseExceptionSubclass
public class PyIndentationError: PySyntaxError {

  // sourcery: pytypedoc
  internal static let indentationErrorDoc = "Improper indentation."

  override public var description: String {
    return self.createDescription(typeName: "PyIndentationError")
  }

  /// Type to set in `init`.
  override internal class var pythonType: PyType {
    return Py.errorTypes.indentationError
  }

  // sourcery: pyproperty = __class__
  override internal func getClass() -> PyType {
    return self.type
  }

  // sourcery: pyproperty = __dict__
  override internal func getDict() -> PyDict {
    return self.__dict__
  }

  // sourcery: pystaticmethod = __new__
  internal class func pyIndentationErrorNew(
    type: PyType,
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyIndentationError> {
    let argsTuple = Py.newTuple(elements: args)
    return .value(PyIndentationError(args: argsTuple, type: type))
  }

  // sourcery: pymethod = __init__
  internal func pyIndentationErrorInit(
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyNone> {
    return super.pySyntaxErrorInit(args: args, kwargs: kwargs)
  }
}

// MARK: - TabError

// sourcery: pyerrortype = TabError, default, baseType, hasGC, baseExceptionSubclass
public final class PyTabError: PyIndentationError {

  // sourcery: pytypedoc
  internal static let tabErrorDoc = "Improper mixture of spaces and tabs."

  override public var description: String {
    return self.createDescription(typeName: "PyTabError")
  }

  /// Type to set in `init`.
  override internal class var pythonType: PyType {
    return Py.errorTypes.tabError
  }

  // sourcery: pyproperty = __class__
  override internal func getClass() -> PyType {
    return self.type
  }

  // sourcery: pyproperty = __dict__
  override internal func getDict() -> PyDict {
    return self.__dict__
  }

  // sourcery: pystaticmethod = __new__
  internal class func pyTabErrorNew(
    type: PyType,
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyTabError> {
    let argsTuple = Py.newTuple(elements: args)
    return .value(PyTabError(args: argsTuple, type: type))
  }

  // sourcery: pymethod = __init__
  internal func pyTabErrorInit(
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyNone> {
    return super.pyIndentationErrorInit(args: args, kwargs: kwargs)
  }
}

// MARK: - SystemError

// sourcery: pyerrortype = SystemError, default, baseType, hasGC, baseExceptionSubclass
public final class PySystemError: PyException {

  // sourcery: pytypedoc
  internal static let systemErrorDoc = "Internal error in the Python interpreter. " +
" " +
"Please report this to the Python maintainer, along with the traceback, " +
"the Python version, and the hardware/OS platform and version."

  override public var description: String {
    return self.createDescription(typeName: "PySystemError")
  }

  /// Type to set in `init`.
  override internal class var pythonType: PyType {
    return Py.errorTypes.systemError
  }

  // sourcery: pyproperty = __class__
  override internal func getClass() -> PyType {
    return self.type
  }

  // sourcery: pyproperty = __dict__
  override internal func getDict() -> PyDict {
    return self.__dict__
  }

  // sourcery: pystaticmethod = __new__
  internal class func pySystemErrorNew(
    type: PyType,
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PySystemError> {
    let argsTuple = Py.newTuple(elements: args)
    return .value(PySystemError(args: argsTuple, type: type))
  }

  // sourcery: pymethod = __init__
  internal func pySystemErrorInit(
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyNone> {
    return super.pyExceptionInit(args: args, kwargs: kwargs)
  }
}

// MARK: - TypeError

// sourcery: pyerrortype = TypeError, default, baseType, hasGC, baseExceptionSubclass
public final class PyTypeError: PyException {

  // sourcery: pytypedoc
  internal static let typeErrorDoc = "Inappropriate argument type."

  override public var description: String {
    return self.createDescription(typeName: "PyTypeError")
  }

  /// Type to set in `init`.
  override internal class var pythonType: PyType {
    return Py.errorTypes.typeError
  }

  // sourcery: pyproperty = __class__
  override internal func getClass() -> PyType {
    return self.type
  }

  // sourcery: pyproperty = __dict__
  override internal func getDict() -> PyDict {
    return self.__dict__
  }

  // sourcery: pystaticmethod = __new__
  internal class func pyTypeErrorNew(
    type: PyType,
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyTypeError> {
    let argsTuple = Py.newTuple(elements: args)
    return .value(PyTypeError(args: argsTuple, type: type))
  }

  // sourcery: pymethod = __init__
  internal func pyTypeErrorInit(
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyNone> {
    return super.pyExceptionInit(args: args, kwargs: kwargs)
  }
}

// MARK: - ValueError

// sourcery: pyerrortype = ValueError, default, baseType, hasGC, baseExceptionSubclass
public class PyValueError: PyException {

  // sourcery: pytypedoc
  internal static let valueErrorDoc = "Inappropriate argument value (of correct type)."

  override public var description: String {
    return self.createDescription(typeName: "PyValueError")
  }

  /// Type to set in `init`.
  override internal class var pythonType: PyType {
    return Py.errorTypes.valueError
  }

  // sourcery: pyproperty = __class__
  override internal func getClass() -> PyType {
    return self.type
  }

  // sourcery: pyproperty = __dict__
  override internal func getDict() -> PyDict {
    return self.__dict__
  }

  // sourcery: pystaticmethod = __new__
  internal class func pyValueErrorNew(
    type: PyType,
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyValueError> {
    let argsTuple = Py.newTuple(elements: args)
    return .value(PyValueError(args: argsTuple, type: type))
  }

  // sourcery: pymethod = __init__
  internal func pyValueErrorInit(
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyNone> {
    return super.pyExceptionInit(args: args, kwargs: kwargs)
  }
}

// MARK: - UnicodeError

// sourcery: pyerrortype = UnicodeError, default, baseType, hasGC, baseExceptionSubclass
public class PyUnicodeError: PyValueError {

  // sourcery: pytypedoc
  internal static let unicodeErrorDoc = "Unicode related error."

  override public var description: String {
    return self.createDescription(typeName: "PyUnicodeError")
  }

  /// Type to set in `init`.
  override internal class var pythonType: PyType {
    return Py.errorTypes.unicodeError
  }

  // sourcery: pyproperty = __class__
  override internal func getClass() -> PyType {
    return self.type
  }

  // sourcery: pyproperty = __dict__
  override internal func getDict() -> PyDict {
    return self.__dict__
  }

  // sourcery: pystaticmethod = __new__
  internal class func pyUnicodeErrorNew(
    type: PyType,
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyUnicodeError> {
    let argsTuple = Py.newTuple(elements: args)
    return .value(PyUnicodeError(args: argsTuple, type: type))
  }

  // sourcery: pymethod = __init__
  internal func pyUnicodeErrorInit(
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyNone> {
    return super.pyValueErrorInit(args: args, kwargs: kwargs)
  }
}

// MARK: - UnicodeDecodeError

// sourcery: pyerrortype = UnicodeDecodeError, default, baseType, hasGC, baseExceptionSubclass
public final class PyUnicodeDecodeError: PyUnicodeError {

  // sourcery: pytypedoc
  internal static let unicodeDecodeErrorDoc = "Unicode decoding error."

  override public var description: String {
    return self.createDescription(typeName: "PyUnicodeDecodeError")
  }

  /// Type to set in `init`.
  override internal class var pythonType: PyType {
    return Py.errorTypes.unicodeDecodeError
  }

  // sourcery: pyproperty = __class__
  override internal func getClass() -> PyType {
    return self.type
  }

  // sourcery: pyproperty = __dict__
  override internal func getDict() -> PyDict {
    return self.__dict__
  }

  // sourcery: pystaticmethod = __new__
  internal class func pyUnicodeDecodeErrorNew(
    type: PyType,
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyUnicodeDecodeError> {
    let argsTuple = Py.newTuple(elements: args)
    return .value(PyUnicodeDecodeError(args: argsTuple, type: type))
  }

  // sourcery: pymethod = __init__
  internal func pyUnicodeDecodeErrorInit(
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyNone> {
    return super.pyUnicodeErrorInit(args: args, kwargs: kwargs)
  }
}

// MARK: - UnicodeEncodeError

// sourcery: pyerrortype = UnicodeEncodeError, default, baseType, hasGC, baseExceptionSubclass
public final class PyUnicodeEncodeError: PyUnicodeError {

  // sourcery: pytypedoc
  internal static let unicodeEncodeErrorDoc = "Unicode encoding error."

  override public var description: String {
    return self.createDescription(typeName: "PyUnicodeEncodeError")
  }

  /// Type to set in `init`.
  override internal class var pythonType: PyType {
    return Py.errorTypes.unicodeEncodeError
  }

  // sourcery: pyproperty = __class__
  override internal func getClass() -> PyType {
    return self.type
  }

  // sourcery: pyproperty = __dict__
  override internal func getDict() -> PyDict {
    return self.__dict__
  }

  // sourcery: pystaticmethod = __new__
  internal class func pyUnicodeEncodeErrorNew(
    type: PyType,
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyUnicodeEncodeError> {
    let argsTuple = Py.newTuple(elements: args)
    return .value(PyUnicodeEncodeError(args: argsTuple, type: type))
  }

  // sourcery: pymethod = __init__
  internal func pyUnicodeEncodeErrorInit(
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyNone> {
    return super.pyUnicodeErrorInit(args: args, kwargs: kwargs)
  }
}

// MARK: - UnicodeTranslateError

// sourcery: pyerrortype = UnicodeTranslateError, default, baseType, hasGC, baseExceptionSubclass
public final class PyUnicodeTranslateError: PyUnicodeError {

  // sourcery: pytypedoc
  internal static let unicodeTranslateErrorDoc = "Unicode translation error."

  override public var description: String {
    return self.createDescription(typeName: "PyUnicodeTranslateError")
  }

  /// Type to set in `init`.
  override internal class var pythonType: PyType {
    return Py.errorTypes.unicodeTranslateError
  }

  // sourcery: pyproperty = __class__
  override internal func getClass() -> PyType {
    return self.type
  }

  // sourcery: pyproperty = __dict__
  override internal func getDict() -> PyDict {
    return self.__dict__
  }

  // sourcery: pystaticmethod = __new__
  internal class func pyUnicodeTranslateErrorNew(
    type: PyType,
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyUnicodeTranslateError> {
    let argsTuple = Py.newTuple(elements: args)
    return .value(PyUnicodeTranslateError(args: argsTuple, type: type))
  }

  // sourcery: pymethod = __init__
  internal func pyUnicodeTranslateErrorInit(
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyNone> {
    return super.pyUnicodeErrorInit(args: args, kwargs: kwargs)
  }
}

// MARK: - Warning

// sourcery: pyerrortype = Warning, default, baseType, hasGC, baseExceptionSubclass
public class PyWarning: PyException {

  // sourcery: pytypedoc
  internal static let warningDoc = "Base class for warning categories."

  override public var description: String {
    return self.createDescription(typeName: "PyWarning")
  }

  /// Type to set in `init`.
  override internal class var pythonType: PyType {
    return Py.errorTypes.warning
  }

  // sourcery: pyproperty = __class__
  override internal func getClass() -> PyType {
    return self.type
  }

  // sourcery: pyproperty = __dict__
  override internal func getDict() -> PyDict {
    return self.__dict__
  }

  // sourcery: pystaticmethod = __new__
  internal class func pyWarningNew(
    type: PyType,
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyWarning> {
    let argsTuple = Py.newTuple(elements: args)
    return .value(PyWarning(args: argsTuple, type: type))
  }

  // sourcery: pymethod = __init__
  internal func pyWarningInit(
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyNone> {
    return super.pyExceptionInit(args: args, kwargs: kwargs)
  }
}

// MARK: - DeprecationWarning

// sourcery: pyerrortype = DeprecationWarning, default, baseType, hasGC, baseExceptionSubclass
public final class PyDeprecationWarning: PyWarning {

  // sourcery: pytypedoc
  internal static let deprecationWarningDoc = "Base class for warnings about deprecated features."

  override public var description: String {
    return self.createDescription(typeName: "PyDeprecationWarning")
  }

  /// Type to set in `init`.
  override internal class var pythonType: PyType {
    return Py.errorTypes.deprecationWarning
  }

  // sourcery: pyproperty = __class__
  override internal func getClass() -> PyType {
    return self.type
  }

  // sourcery: pyproperty = __dict__
  override internal func getDict() -> PyDict {
    return self.__dict__
  }

  // sourcery: pystaticmethod = __new__
  internal class func pyDeprecationWarningNew(
    type: PyType,
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyDeprecationWarning> {
    let argsTuple = Py.newTuple(elements: args)
    return .value(PyDeprecationWarning(args: argsTuple, type: type))
  }

  // sourcery: pymethod = __init__
  internal func pyDeprecationWarningInit(
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyNone> {
    return super.pyWarningInit(args: args, kwargs: kwargs)
  }
}

// MARK: - PendingDeprecationWarning

// sourcery: pyerrortype = PendingDeprecationWarning, default, baseType, hasGC, baseExceptionSubclass
public final class PyPendingDeprecationWarning: PyWarning {

  // sourcery: pytypedoc
  internal static let pendingDeprecationWarningDoc = "Base class for warnings about features which will be deprecated " +
"in the future."

  override public var description: String {
    return self.createDescription(typeName: "PyPendingDeprecationWarning")
  }

  /// Type to set in `init`.
  override internal class var pythonType: PyType {
    return Py.errorTypes.pendingDeprecationWarning
  }

  // sourcery: pyproperty = __class__
  override internal func getClass() -> PyType {
    return self.type
  }

  // sourcery: pyproperty = __dict__
  override internal func getDict() -> PyDict {
    return self.__dict__
  }

  // sourcery: pystaticmethod = __new__
  internal class func pyPendingDeprecationWarningNew(
    type: PyType,
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyPendingDeprecationWarning> {
    let argsTuple = Py.newTuple(elements: args)
    return .value(PyPendingDeprecationWarning(args: argsTuple, type: type))
  }

  // sourcery: pymethod = __init__
  internal func pyPendingDeprecationWarningInit(
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyNone> {
    return super.pyWarningInit(args: args, kwargs: kwargs)
  }
}

// MARK: - RuntimeWarning

// sourcery: pyerrortype = RuntimeWarning, default, baseType, hasGC, baseExceptionSubclass
public final class PyRuntimeWarning: PyWarning {

  // sourcery: pytypedoc
  internal static let runtimeWarningDoc = "Base class for warnings about dubious runtime behavior."

  override public var description: String {
    return self.createDescription(typeName: "PyRuntimeWarning")
  }

  /// Type to set in `init`.
  override internal class var pythonType: PyType {
    return Py.errorTypes.runtimeWarning
  }

  // sourcery: pyproperty = __class__
  override internal func getClass() -> PyType {
    return self.type
  }

  // sourcery: pyproperty = __dict__
  override internal func getDict() -> PyDict {
    return self.__dict__
  }

  // sourcery: pystaticmethod = __new__
  internal class func pyRuntimeWarningNew(
    type: PyType,
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyRuntimeWarning> {
    let argsTuple = Py.newTuple(elements: args)
    return .value(PyRuntimeWarning(args: argsTuple, type: type))
  }

  // sourcery: pymethod = __init__
  internal func pyRuntimeWarningInit(
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyNone> {
    return super.pyWarningInit(args: args, kwargs: kwargs)
  }
}

// MARK: - SyntaxWarning

// sourcery: pyerrortype = SyntaxWarning, default, baseType, hasGC, baseExceptionSubclass
public final class PySyntaxWarning: PyWarning {

  // sourcery: pytypedoc
  internal static let syntaxWarningDoc = "Base class for warnings about dubious syntax."

  override public var description: String {
    return self.createDescription(typeName: "PySyntaxWarning")
  }

  /// Type to set in `init`.
  override internal class var pythonType: PyType {
    return Py.errorTypes.syntaxWarning
  }

  // sourcery: pyproperty = __class__
  override internal func getClass() -> PyType {
    return self.type
  }

  // sourcery: pyproperty = __dict__
  override internal func getDict() -> PyDict {
    return self.__dict__
  }

  // sourcery: pystaticmethod = __new__
  internal class func pySyntaxWarningNew(
    type: PyType,
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PySyntaxWarning> {
    let argsTuple = Py.newTuple(elements: args)
    return .value(PySyntaxWarning(args: argsTuple, type: type))
  }

  // sourcery: pymethod = __init__
  internal func pySyntaxWarningInit(
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyNone> {
    return super.pyWarningInit(args: args, kwargs: kwargs)
  }
}

// MARK: - UserWarning

// sourcery: pyerrortype = UserWarning, default, baseType, hasGC, baseExceptionSubclass
public final class PyUserWarning: PyWarning {

  // sourcery: pytypedoc
  internal static let userWarningDoc = "Base class for warnings generated by user code."

  override public var description: String {
    return self.createDescription(typeName: "PyUserWarning")
  }

  /// Type to set in `init`.
  override internal class var pythonType: PyType {
    return Py.errorTypes.userWarning
  }

  // sourcery: pyproperty = __class__
  override internal func getClass() -> PyType {
    return self.type
  }

  // sourcery: pyproperty = __dict__
  override internal func getDict() -> PyDict {
    return self.__dict__
  }

  // sourcery: pystaticmethod = __new__
  internal class func pyUserWarningNew(
    type: PyType,
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyUserWarning> {
    let argsTuple = Py.newTuple(elements: args)
    return .value(PyUserWarning(args: argsTuple, type: type))
  }

  // sourcery: pymethod = __init__
  internal func pyUserWarningInit(
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyNone> {
    return super.pyWarningInit(args: args, kwargs: kwargs)
  }
}

// MARK: - FutureWarning

// sourcery: pyerrortype = FutureWarning, default, baseType, hasGC, baseExceptionSubclass
public final class PyFutureWarning: PyWarning {

  // sourcery: pytypedoc
  internal static let futureWarningDoc = "Base class for warnings about constructs that will change semantically " +
"in the future."

  override public var description: String {
    return self.createDescription(typeName: "PyFutureWarning")
  }

  /// Type to set in `init`.
  override internal class var pythonType: PyType {
    return Py.errorTypes.futureWarning
  }

  // sourcery: pyproperty = __class__
  override internal func getClass() -> PyType {
    return self.type
  }

  // sourcery: pyproperty = __dict__
  override internal func getDict() -> PyDict {
    return self.__dict__
  }

  // sourcery: pystaticmethod = __new__
  internal class func pyFutureWarningNew(
    type: PyType,
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyFutureWarning> {
    let argsTuple = Py.newTuple(elements: args)
    return .value(PyFutureWarning(args: argsTuple, type: type))
  }

  // sourcery: pymethod = __init__
  internal func pyFutureWarningInit(
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyNone> {
    return super.pyWarningInit(args: args, kwargs: kwargs)
  }
}

// MARK: - ImportWarning

// sourcery: pyerrortype = ImportWarning, default, baseType, hasGC, baseExceptionSubclass
public final class PyImportWarning: PyWarning {

  // sourcery: pytypedoc
  internal static let importWarningDoc = "Base class for warnings about probable mistakes in module imports"

  override public var description: String {
    return self.createDescription(typeName: "PyImportWarning")
  }

  /// Type to set in `init`.
  override internal class var pythonType: PyType {
    return Py.errorTypes.importWarning
  }

  // sourcery: pyproperty = __class__
  override internal func getClass() -> PyType {
    return self.type
  }

  // sourcery: pyproperty = __dict__
  override internal func getDict() -> PyDict {
    return self.__dict__
  }

  // sourcery: pystaticmethod = __new__
  internal class func pyImportWarningNew(
    type: PyType,
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyImportWarning> {
    let argsTuple = Py.newTuple(elements: args)
    return .value(PyImportWarning(args: argsTuple, type: type))
  }

  // sourcery: pymethod = __init__
  internal func pyImportWarningInit(
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyNone> {
    return super.pyWarningInit(args: args, kwargs: kwargs)
  }
}

// MARK: - UnicodeWarning

// sourcery: pyerrortype = UnicodeWarning, default, baseType, hasGC, baseExceptionSubclass
public final class PyUnicodeWarning: PyWarning {

  // sourcery: pytypedoc
  internal static let unicodeWarningDoc = "Base class for warnings about Unicode related problems, mostly " +
"related to conversion problems."

  override public var description: String {
    return self.createDescription(typeName: "PyUnicodeWarning")
  }

  /// Type to set in `init`.
  override internal class var pythonType: PyType {
    return Py.errorTypes.unicodeWarning
  }

  // sourcery: pyproperty = __class__
  override internal func getClass() -> PyType {
    return self.type
  }

  // sourcery: pyproperty = __dict__
  override internal func getDict() -> PyDict {
    return self.__dict__
  }

  // sourcery: pystaticmethod = __new__
  internal class func pyUnicodeWarningNew(
    type: PyType,
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyUnicodeWarning> {
    let argsTuple = Py.newTuple(elements: args)
    return .value(PyUnicodeWarning(args: argsTuple, type: type))
  }

  // sourcery: pymethod = __init__
  internal func pyUnicodeWarningInit(
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyNone> {
    return super.pyWarningInit(args: args, kwargs: kwargs)
  }
}

// MARK: - BytesWarning

// sourcery: pyerrortype = BytesWarning, default, baseType, hasGC, baseExceptionSubclass
public final class PyBytesWarning: PyWarning {

  // sourcery: pytypedoc
  internal static let bytesWarningDoc = "Base class for warnings about bytes and buffer related problems, mostly " +
"related to conversion from str or comparing to str."

  override public var description: String {
    return self.createDescription(typeName: "PyBytesWarning")
  }

  /// Type to set in `init`.
  override internal class var pythonType: PyType {
    return Py.errorTypes.bytesWarning
  }

  // sourcery: pyproperty = __class__
  override internal func getClass() -> PyType {
    return self.type
  }

  // sourcery: pyproperty = __dict__
  override internal func getDict() -> PyDict {
    return self.__dict__
  }

  // sourcery: pystaticmethod = __new__
  internal class func pyBytesWarningNew(
    type: PyType,
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyBytesWarning> {
    let argsTuple = Py.newTuple(elements: args)
    return .value(PyBytesWarning(args: argsTuple, type: type))
  }

  // sourcery: pymethod = __init__
  internal func pyBytesWarningInit(
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyNone> {
    return super.pyWarningInit(args: args, kwargs: kwargs)
  }
}

// MARK: - ResourceWarning

// sourcery: pyerrortype = ResourceWarning, default, baseType, hasGC, baseExceptionSubclass
public final class PyResourceWarning: PyWarning {

  // sourcery: pytypedoc
  internal static let resourceWarningDoc = "Base class for warnings about resource usage."

  override public var description: String {
    return self.createDescription(typeName: "PyResourceWarning")
  }

  /// Type to set in `init`.
  override internal class var pythonType: PyType {
    return Py.errorTypes.resourceWarning
  }

  // sourcery: pyproperty = __class__
  override internal func getClass() -> PyType {
    return self.type
  }

  // sourcery: pyproperty = __dict__
  override internal func getDict() -> PyDict {
    return self.__dict__
  }

  // sourcery: pystaticmethod = __new__
  internal class func pyResourceWarningNew(
    type: PyType,
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyResourceWarning> {
    let argsTuple = Py.newTuple(elements: args)
    return .value(PyResourceWarning(args: argsTuple, type: type))
  }

  // sourcery: pymethod = __init__
  internal func pyResourceWarningInit(
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyNone> {
    return super.pyWarningInit(args: args, kwargs: kwargs)
  }
}

