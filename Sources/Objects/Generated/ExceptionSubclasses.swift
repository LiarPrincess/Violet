// ================================================================================
// Automatically generated from: ./Sources/Objects/Generated/ExceptionSubclasses.py
// Use 'make gen' in repository root to regenerate.
// DO NOT EDIT!
// ================================================================================

// swiftlint:disable line_length
// swiftlint:disable trailing_newline
// swiftlint:disable function_parameter_count
// swiftlint:disable file_length

// In CPython:
// Objects -> exceptions.c
// Lib->test->exception_hierarchy.txt <-- this is amazing
// https://docs.python.org/3.7/library/exceptions.html
// https://docs.python.org/3.7/c-api/exceptions.html

// MARK: - KeyboardInterrupt

// sourcery: pyerrortype = KeyboardInterrupt, pybase = BaseException, isDefault, isBaseType, hasGC
// sourcery: isBaseExceptionSubclass, instancesHave__dict__
public struct PyKeyboardInterrupt: PyErrorMixin {

  // sourcery: pytypedoc
  internal static let doc = "Program interrupted by user."

  public let ptr: RawPtr

  public init(ptr: RawPtr) {
    self.ptr = ptr
  }

  internal func initialize(_ py: Py,
                           type: PyType,
                           args: PyTuple,
                           traceback: PyTraceback? = nil,
                           cause: PyBaseException? = nil,
                           context: PyBaseException? = nil,
                           suppressContext: Bool = PyErrorHeader.defaultSuppressContext) {
    self.initializeBase(py,
                        type: type,
                        args: args,
                        traceback: traceback,
                        cause: cause,
                        context: context,
                        suppressContext: suppressContext)
  }

  // Nothing to do here.
  internal func beforeDeinitialize() { }

  internal static func createDebugString(ptr: RawPtr) -> String {
    let zelf = PyStopIteration(ptr: ptr)
    return "PyKeyboardInterrupt(type: \(zelf.typeName), flags: \(zelf.flags))"
  }

  // sourcery: pyproperty = __class__
  internal static func __class__(_ py: Py, zelf: PyObject) -> PyType {
    return zelf.type
  }

  // sourcery: pyproperty = __dict__
  internal static func __dict__(_ py: Py, zelf: PyObject) -> PyResult<PyObject> {
    guard let zelf = Self.downcast(py, zelf) else {
      return Self.invalidZelfArgument(py, zelf, "__dict__")
    }

    let result = zelf.asBaseException.getDict(py)
    return PyResult(result)
  }

  // sourcery: pystaticmethod = __new__
  internal static func __new__(_ py: Py,
                               type: PyType,
                               args: [PyObject],
                               kwargs: PyDict?) -> PyResult<PyObject> {
    let argsTuple = py.newTuple(elements: args)
    let result = py.memory.newKeyboardInterrupt(py, type: type, args: argsTuple)
    return PyResult(result)
  }

  // sourcery: pymethod = __init__
  internal static func __init__(_ py: Py,
                                zelf: PyObject,
                                args: [PyObject],
                                kwargs: PyDict?) -> PyResult<PyObject> {
    guard let zelf = Self.downcast(py, zelf) else {
      return Self.invalidZelfArgument(py, zelf, "__init__")
    }

    let zelfAsObject = zelf.asObject
    return PyBaseException.__init__(py, zelf: zelfAsObject, args: args, kwargs: kwargs)
  }
}

// MARK: - GeneratorExit

// sourcery: pyerrortype = GeneratorExit, pybase = BaseException, isDefault, isBaseType, hasGC
// sourcery: isBaseExceptionSubclass, instancesHave__dict__
public struct PyGeneratorExit: PyErrorMixin {

  // sourcery: pytypedoc
  internal static let doc = "Request that a generator exit."

  public let ptr: RawPtr

  public init(ptr: RawPtr) {
    self.ptr = ptr
  }

  internal func initialize(_ py: Py,
                           type: PyType,
                           args: PyTuple,
                           traceback: PyTraceback? = nil,
                           cause: PyBaseException? = nil,
                           context: PyBaseException? = nil,
                           suppressContext: Bool = PyErrorHeader.defaultSuppressContext) {
    self.initializeBase(py,
                        type: type,
                        args: args,
                        traceback: traceback,
                        cause: cause,
                        context: context,
                        suppressContext: suppressContext)
  }

  // Nothing to do here.
  internal func beforeDeinitialize() { }

  internal static func createDebugString(ptr: RawPtr) -> String {
    let zelf = PyStopIteration(ptr: ptr)
    return "PyGeneratorExit(type: \(zelf.typeName), flags: \(zelf.flags))"
  }

  // sourcery: pyproperty = __class__
  internal static func __class__(_ py: Py, zelf: PyObject) -> PyType {
    return zelf.type
  }

  // sourcery: pyproperty = __dict__
  internal static func __dict__(_ py: Py, zelf: PyObject) -> PyResult<PyObject> {
    guard let zelf = Self.downcast(py, zelf) else {
      return Self.invalidZelfArgument(py, zelf, "__dict__")
    }

    let result = zelf.asBaseException.getDict(py)
    return PyResult(result)
  }

  // sourcery: pystaticmethod = __new__
  internal static func __new__(_ py: Py,
                               type: PyType,
                               args: [PyObject],
                               kwargs: PyDict?) -> PyResult<PyObject> {
    let argsTuple = py.newTuple(elements: args)
    let result = py.memory.newGeneratorExit(py, type: type, args: argsTuple)
    return PyResult(result)
  }

  // sourcery: pymethod = __init__
  internal static func __init__(_ py: Py,
                                zelf: PyObject,
                                args: [PyObject],
                                kwargs: PyDict?) -> PyResult<PyObject> {
    guard let zelf = Self.downcast(py, zelf) else {
      return Self.invalidZelfArgument(py, zelf, "__init__")
    }

    let zelfAsObject = zelf.asObject
    return PyBaseException.__init__(py, zelf: zelfAsObject, args: args, kwargs: kwargs)
  }
}

// MARK: - Exception

// sourcery: pyerrortype = Exception, pybase = BaseException, isDefault, isBaseType, hasGC
// sourcery: isBaseExceptionSubclass, instancesHave__dict__
public struct PyException: PyErrorMixin {

  // sourcery: pytypedoc
  internal static let doc = "Common base class for all non-exit exceptions."

  public let ptr: RawPtr

  public init(ptr: RawPtr) {
    self.ptr = ptr
  }

  internal func initialize(_ py: Py,
                           type: PyType,
                           args: PyTuple,
                           traceback: PyTraceback? = nil,
                           cause: PyBaseException? = nil,
                           context: PyBaseException? = nil,
                           suppressContext: Bool = PyErrorHeader.defaultSuppressContext) {
    self.initializeBase(py,
                        type: type,
                        args: args,
                        traceback: traceback,
                        cause: cause,
                        context: context,
                        suppressContext: suppressContext)
  }

  // Nothing to do here.
  internal func beforeDeinitialize() { }

  internal static func createDebugString(ptr: RawPtr) -> String {
    let zelf = PyStopIteration(ptr: ptr)
    return "PyException(type: \(zelf.typeName), flags: \(zelf.flags))"
  }

  // sourcery: pyproperty = __class__
  internal static func __class__(_ py: Py, zelf: PyObject) -> PyType {
    return zelf.type
  }

  // sourcery: pyproperty = __dict__
  internal static func __dict__(_ py: Py, zelf: PyObject) -> PyResult<PyObject> {
    guard let zelf = Self.downcast(py, zelf) else {
      return Self.invalidZelfArgument(py, zelf, "__dict__")
    }

    let result = zelf.asBaseException.getDict(py)
    return PyResult(result)
  }

  // sourcery: pystaticmethod = __new__
  internal static func __new__(_ py: Py,
                               type: PyType,
                               args: [PyObject],
                               kwargs: PyDict?) -> PyResult<PyObject> {
    let argsTuple = py.newTuple(elements: args)
    let result = py.memory.newException(py, type: type, args: argsTuple)
    return PyResult(result)
  }

  // sourcery: pymethod = __init__
  internal static func __init__(_ py: Py,
                                zelf: PyObject,
                                args: [PyObject],
                                kwargs: PyDict?) -> PyResult<PyObject> {
    guard let zelf = Self.downcast(py, zelf) else {
      return Self.invalidZelfArgument(py, zelf, "__init__")
    }

    let zelfAsObject = zelf.asObject
    return PyBaseException.__init__(py, zelf: zelfAsObject, args: args, kwargs: kwargs)
  }
}

// MARK: - StopAsyncIteration

// sourcery: pyerrortype = StopAsyncIteration, pybase = Exception, isDefault, isBaseType, hasGC
// sourcery: isBaseExceptionSubclass, instancesHave__dict__
public struct PyStopAsyncIteration: PyErrorMixin {

  // sourcery: pytypedoc
  internal static let doc = "Signal the end from iterator.__anext__()."

  public let ptr: RawPtr

  public init(ptr: RawPtr) {
    self.ptr = ptr
  }

  internal func initialize(_ py: Py,
                           type: PyType,
                           args: PyTuple,
                           traceback: PyTraceback? = nil,
                           cause: PyBaseException? = nil,
                           context: PyBaseException? = nil,
                           suppressContext: Bool = PyErrorHeader.defaultSuppressContext) {
    self.initializeBase(py,
                        type: type,
                        args: args,
                        traceback: traceback,
                        cause: cause,
                        context: context,
                        suppressContext: suppressContext)
  }

  // Nothing to do here.
  internal func beforeDeinitialize() { }

  internal static func createDebugString(ptr: RawPtr) -> String {
    let zelf = PyStopIteration(ptr: ptr)
    return "PyStopAsyncIteration(type: \(zelf.typeName), flags: \(zelf.flags))"
  }

  // sourcery: pyproperty = __class__
  internal static func __class__(_ py: Py, zelf: PyObject) -> PyType {
    return zelf.type
  }

  // sourcery: pyproperty = __dict__
  internal static func __dict__(_ py: Py, zelf: PyObject) -> PyResult<PyObject> {
    guard let zelf = Self.downcast(py, zelf) else {
      return Self.invalidZelfArgument(py, zelf, "__dict__")
    }

    let result = zelf.asBaseException.getDict(py)
    return PyResult(result)
  }

  // sourcery: pystaticmethod = __new__
  internal static func __new__(_ py: Py,
                               type: PyType,
                               args: [PyObject],
                               kwargs: PyDict?) -> PyResult<PyObject> {
    let argsTuple = py.newTuple(elements: args)
    let result = py.memory.newStopAsyncIteration(py, type: type, args: argsTuple)
    return PyResult(result)
  }

  // sourcery: pymethod = __init__
  internal static func __init__(_ py: Py,
                                zelf: PyObject,
                                args: [PyObject],
                                kwargs: PyDict?) -> PyResult<PyObject> {
    guard let zelf = Self.downcast(py, zelf) else {
      return Self.invalidZelfArgument(py, zelf, "__init__")
    }

    let zelfAsObject = zelf.asObject
    return PyException.__init__(py, zelf: zelfAsObject, args: args, kwargs: kwargs)
  }
}

// MARK: - ArithmeticError

// sourcery: pyerrortype = ArithmeticError, pybase = Exception, isDefault, isBaseType, hasGC
// sourcery: isBaseExceptionSubclass, instancesHave__dict__
public struct PyArithmeticError: PyErrorMixin {

  // sourcery: pytypedoc
  internal static let doc = "Base class for arithmetic errors."

  public let ptr: RawPtr

  public init(ptr: RawPtr) {
    self.ptr = ptr
  }

  internal func initialize(_ py: Py,
                           type: PyType,
                           args: PyTuple,
                           traceback: PyTraceback? = nil,
                           cause: PyBaseException? = nil,
                           context: PyBaseException? = nil,
                           suppressContext: Bool = PyErrorHeader.defaultSuppressContext) {
    self.initializeBase(py,
                        type: type,
                        args: args,
                        traceback: traceback,
                        cause: cause,
                        context: context,
                        suppressContext: suppressContext)
  }

  // Nothing to do here.
  internal func beforeDeinitialize() { }

  internal static func createDebugString(ptr: RawPtr) -> String {
    let zelf = PyStopIteration(ptr: ptr)
    return "PyArithmeticError(type: \(zelf.typeName), flags: \(zelf.flags))"
  }

  // sourcery: pyproperty = __class__
  internal static func __class__(_ py: Py, zelf: PyObject) -> PyType {
    return zelf.type
  }

  // sourcery: pyproperty = __dict__
  internal static func __dict__(_ py: Py, zelf: PyObject) -> PyResult<PyObject> {
    guard let zelf = Self.downcast(py, zelf) else {
      return Self.invalidZelfArgument(py, zelf, "__dict__")
    }

    let result = zelf.asBaseException.getDict(py)
    return PyResult(result)
  }

  // sourcery: pystaticmethod = __new__
  internal static func __new__(_ py: Py,
                               type: PyType,
                               args: [PyObject],
                               kwargs: PyDict?) -> PyResult<PyObject> {
    let argsTuple = py.newTuple(elements: args)
    let result = py.memory.newArithmeticError(py, type: type, args: argsTuple)
    return PyResult(result)
  }

  // sourcery: pymethod = __init__
  internal static func __init__(_ py: Py,
                                zelf: PyObject,
                                args: [PyObject],
                                kwargs: PyDict?) -> PyResult<PyObject> {
    guard let zelf = Self.downcast(py, zelf) else {
      return Self.invalidZelfArgument(py, zelf, "__init__")
    }

    let zelfAsObject = zelf.asObject
    return PyException.__init__(py, zelf: zelfAsObject, args: args, kwargs: kwargs)
  }
}

// MARK: - FloatingPointError

// sourcery: pyerrortype = FloatingPointError, pybase = ArithmeticError, isDefault, isBaseType, hasGC
// sourcery: isBaseExceptionSubclass, instancesHave__dict__
public struct PyFloatingPointError: PyErrorMixin {

  // sourcery: pytypedoc
  internal static let doc = "Floating point operation failed."

  public let ptr: RawPtr

  public init(ptr: RawPtr) {
    self.ptr = ptr
  }

  internal func initialize(_ py: Py,
                           type: PyType,
                           args: PyTuple,
                           traceback: PyTraceback? = nil,
                           cause: PyBaseException? = nil,
                           context: PyBaseException? = nil,
                           suppressContext: Bool = PyErrorHeader.defaultSuppressContext) {
    self.initializeBase(py,
                        type: type,
                        args: args,
                        traceback: traceback,
                        cause: cause,
                        context: context,
                        suppressContext: suppressContext)
  }

  // Nothing to do here.
  internal func beforeDeinitialize() { }

  internal static func createDebugString(ptr: RawPtr) -> String {
    let zelf = PyStopIteration(ptr: ptr)
    return "PyFloatingPointError(type: \(zelf.typeName), flags: \(zelf.flags))"
  }

  // sourcery: pyproperty = __class__
  internal static func __class__(_ py: Py, zelf: PyObject) -> PyType {
    return zelf.type
  }

  // sourcery: pyproperty = __dict__
  internal static func __dict__(_ py: Py, zelf: PyObject) -> PyResult<PyObject> {
    guard let zelf = Self.downcast(py, zelf) else {
      return Self.invalidZelfArgument(py, zelf, "__dict__")
    }

    let result = zelf.asBaseException.getDict(py)
    return PyResult(result)
  }

  // sourcery: pystaticmethod = __new__
  internal static func __new__(_ py: Py,
                               type: PyType,
                               args: [PyObject],
                               kwargs: PyDict?) -> PyResult<PyObject> {
    let argsTuple = py.newTuple(elements: args)
    let result = py.memory.newFloatingPointError(py, type: type, args: argsTuple)
    return PyResult(result)
  }

  // sourcery: pymethod = __init__
  internal static func __init__(_ py: Py,
                                zelf: PyObject,
                                args: [PyObject],
                                kwargs: PyDict?) -> PyResult<PyObject> {
    guard let zelf = Self.downcast(py, zelf) else {
      return Self.invalidZelfArgument(py, zelf, "__init__")
    }

    let zelfAsObject = zelf.asObject
    return PyArithmeticError.__init__(py, zelf: zelfAsObject, args: args, kwargs: kwargs)
  }
}

// MARK: - OverflowError

// sourcery: pyerrortype = OverflowError, pybase = ArithmeticError, isDefault, isBaseType, hasGC
// sourcery: isBaseExceptionSubclass, instancesHave__dict__
public struct PyOverflowError: PyErrorMixin {

  // sourcery: pytypedoc
  internal static let doc = "Result too large to be represented."

  public let ptr: RawPtr

  public init(ptr: RawPtr) {
    self.ptr = ptr
  }

  internal func initialize(_ py: Py,
                           type: PyType,
                           args: PyTuple,
                           traceback: PyTraceback? = nil,
                           cause: PyBaseException? = nil,
                           context: PyBaseException? = nil,
                           suppressContext: Bool = PyErrorHeader.defaultSuppressContext) {
    self.initializeBase(py,
                        type: type,
                        args: args,
                        traceback: traceback,
                        cause: cause,
                        context: context,
                        suppressContext: suppressContext)
  }

  // Nothing to do here.
  internal func beforeDeinitialize() { }

  internal static func createDebugString(ptr: RawPtr) -> String {
    let zelf = PyStopIteration(ptr: ptr)
    return "PyOverflowError(type: \(zelf.typeName), flags: \(zelf.flags))"
  }

  // sourcery: pyproperty = __class__
  internal static func __class__(_ py: Py, zelf: PyObject) -> PyType {
    return zelf.type
  }

  // sourcery: pyproperty = __dict__
  internal static func __dict__(_ py: Py, zelf: PyObject) -> PyResult<PyObject> {
    guard let zelf = Self.downcast(py, zelf) else {
      return Self.invalidZelfArgument(py, zelf, "__dict__")
    }

    let result = zelf.asBaseException.getDict(py)
    return PyResult(result)
  }

  // sourcery: pystaticmethod = __new__
  internal static func __new__(_ py: Py,
                               type: PyType,
                               args: [PyObject],
                               kwargs: PyDict?) -> PyResult<PyObject> {
    let argsTuple = py.newTuple(elements: args)
    let result = py.memory.newOverflowError(py, type: type, args: argsTuple)
    return PyResult(result)
  }

  // sourcery: pymethod = __init__
  internal static func __init__(_ py: Py,
                                zelf: PyObject,
                                args: [PyObject],
                                kwargs: PyDict?) -> PyResult<PyObject> {
    guard let zelf = Self.downcast(py, zelf) else {
      return Self.invalidZelfArgument(py, zelf, "__init__")
    }

    let zelfAsObject = zelf.asObject
    return PyArithmeticError.__init__(py, zelf: zelfAsObject, args: args, kwargs: kwargs)
  }
}

// MARK: - ZeroDivisionError

// sourcery: pyerrortype = ZeroDivisionError, pybase = ArithmeticError, isDefault, isBaseType, hasGC
// sourcery: isBaseExceptionSubclass, instancesHave__dict__
public struct PyZeroDivisionError: PyErrorMixin {

  // sourcery: pytypedoc
  internal static let doc = "Second argument to a division or modulo operation was zero."

  public let ptr: RawPtr

  public init(ptr: RawPtr) {
    self.ptr = ptr
  }

  internal func initialize(_ py: Py,
                           type: PyType,
                           args: PyTuple,
                           traceback: PyTraceback? = nil,
                           cause: PyBaseException? = nil,
                           context: PyBaseException? = nil,
                           suppressContext: Bool = PyErrorHeader.defaultSuppressContext) {
    self.initializeBase(py,
                        type: type,
                        args: args,
                        traceback: traceback,
                        cause: cause,
                        context: context,
                        suppressContext: suppressContext)
  }

  // Nothing to do here.
  internal func beforeDeinitialize() { }

  internal static func createDebugString(ptr: RawPtr) -> String {
    let zelf = PyStopIteration(ptr: ptr)
    return "PyZeroDivisionError(type: \(zelf.typeName), flags: \(zelf.flags))"
  }

  // sourcery: pyproperty = __class__
  internal static func __class__(_ py: Py, zelf: PyObject) -> PyType {
    return zelf.type
  }

  // sourcery: pyproperty = __dict__
  internal static func __dict__(_ py: Py, zelf: PyObject) -> PyResult<PyObject> {
    guard let zelf = Self.downcast(py, zelf) else {
      return Self.invalidZelfArgument(py, zelf, "__dict__")
    }

    let result = zelf.asBaseException.getDict(py)
    return PyResult(result)
  }

  // sourcery: pystaticmethod = __new__
  internal static func __new__(_ py: Py,
                               type: PyType,
                               args: [PyObject],
                               kwargs: PyDict?) -> PyResult<PyObject> {
    let argsTuple = py.newTuple(elements: args)
    let result = py.memory.newZeroDivisionError(py, type: type, args: argsTuple)
    return PyResult(result)
  }

  // sourcery: pymethod = __init__
  internal static func __init__(_ py: Py,
                                zelf: PyObject,
                                args: [PyObject],
                                kwargs: PyDict?) -> PyResult<PyObject> {
    guard let zelf = Self.downcast(py, zelf) else {
      return Self.invalidZelfArgument(py, zelf, "__init__")
    }

    let zelfAsObject = zelf.asObject
    return PyArithmeticError.__init__(py, zelf: zelfAsObject, args: args, kwargs: kwargs)
  }
}

// MARK: - AssertionError

// sourcery: pyerrortype = AssertionError, pybase = Exception, isDefault, isBaseType, hasGC
// sourcery: isBaseExceptionSubclass, instancesHave__dict__
public struct PyAssertionError: PyErrorMixin {

  // sourcery: pytypedoc
  internal static let doc = "Assertion failed."

  public let ptr: RawPtr

  public init(ptr: RawPtr) {
    self.ptr = ptr
  }

  internal func initialize(_ py: Py,
                           type: PyType,
                           args: PyTuple,
                           traceback: PyTraceback? = nil,
                           cause: PyBaseException? = nil,
                           context: PyBaseException? = nil,
                           suppressContext: Bool = PyErrorHeader.defaultSuppressContext) {
    self.initializeBase(py,
                        type: type,
                        args: args,
                        traceback: traceback,
                        cause: cause,
                        context: context,
                        suppressContext: suppressContext)
  }

  // Nothing to do here.
  internal func beforeDeinitialize() { }

  internal static func createDebugString(ptr: RawPtr) -> String {
    let zelf = PyStopIteration(ptr: ptr)
    return "PyAssertionError(type: \(zelf.typeName), flags: \(zelf.flags))"
  }

  // sourcery: pyproperty = __class__
  internal static func __class__(_ py: Py, zelf: PyObject) -> PyType {
    return zelf.type
  }

  // sourcery: pyproperty = __dict__
  internal static func __dict__(_ py: Py, zelf: PyObject) -> PyResult<PyObject> {
    guard let zelf = Self.downcast(py, zelf) else {
      return Self.invalidZelfArgument(py, zelf, "__dict__")
    }

    let result = zelf.asBaseException.getDict(py)
    return PyResult(result)
  }

  // sourcery: pystaticmethod = __new__
  internal static func __new__(_ py: Py,
                               type: PyType,
                               args: [PyObject],
                               kwargs: PyDict?) -> PyResult<PyObject> {
    let argsTuple = py.newTuple(elements: args)
    let result = py.memory.newAssertionError(py, type: type, args: argsTuple)
    return PyResult(result)
  }

  // sourcery: pymethod = __init__
  internal static func __init__(_ py: Py,
                                zelf: PyObject,
                                args: [PyObject],
                                kwargs: PyDict?) -> PyResult<PyObject> {
    guard let zelf = Self.downcast(py, zelf) else {
      return Self.invalidZelfArgument(py, zelf, "__init__")
    }

    let zelfAsObject = zelf.asObject
    return PyException.__init__(py, zelf: zelfAsObject, args: args, kwargs: kwargs)
  }
}

// MARK: - AttributeError

// sourcery: pyerrortype = AttributeError, pybase = Exception, isDefault, isBaseType, hasGC
// sourcery: isBaseExceptionSubclass, instancesHave__dict__
public struct PyAttributeError: PyErrorMixin {

  // sourcery: pytypedoc
  internal static let doc = "Attribute not found."

  public let ptr: RawPtr

  public init(ptr: RawPtr) {
    self.ptr = ptr
  }

  internal func initialize(_ py: Py,
                           type: PyType,
                           args: PyTuple,
                           traceback: PyTraceback? = nil,
                           cause: PyBaseException? = nil,
                           context: PyBaseException? = nil,
                           suppressContext: Bool = PyErrorHeader.defaultSuppressContext) {
    self.initializeBase(py,
                        type: type,
                        args: args,
                        traceback: traceback,
                        cause: cause,
                        context: context,
                        suppressContext: suppressContext)
  }

  // Nothing to do here.
  internal func beforeDeinitialize() { }

  internal static func createDebugString(ptr: RawPtr) -> String {
    let zelf = PyStopIteration(ptr: ptr)
    return "PyAttributeError(type: \(zelf.typeName), flags: \(zelf.flags))"
  }

  // sourcery: pyproperty = __class__
  internal static func __class__(_ py: Py, zelf: PyObject) -> PyType {
    return zelf.type
  }

  // sourcery: pyproperty = __dict__
  internal static func __dict__(_ py: Py, zelf: PyObject) -> PyResult<PyObject> {
    guard let zelf = Self.downcast(py, zelf) else {
      return Self.invalidZelfArgument(py, zelf, "__dict__")
    }

    let result = zelf.asBaseException.getDict(py)
    return PyResult(result)
  }

  // sourcery: pystaticmethod = __new__
  internal static func __new__(_ py: Py,
                               type: PyType,
                               args: [PyObject],
                               kwargs: PyDict?) -> PyResult<PyObject> {
    let argsTuple = py.newTuple(elements: args)
    let result = py.memory.newAttributeError(py, type: type, args: argsTuple)
    return PyResult(result)
  }

  // sourcery: pymethod = __init__
  internal static func __init__(_ py: Py,
                                zelf: PyObject,
                                args: [PyObject],
                                kwargs: PyDict?) -> PyResult<PyObject> {
    guard let zelf = Self.downcast(py, zelf) else {
      return Self.invalidZelfArgument(py, zelf, "__init__")
    }

    let zelfAsObject = zelf.asObject
    return PyException.__init__(py, zelf: zelfAsObject, args: args, kwargs: kwargs)
  }
}

// MARK: - BufferError

// sourcery: pyerrortype = BufferError, pybase = Exception, isDefault, isBaseType, hasGC
// sourcery: isBaseExceptionSubclass, instancesHave__dict__
public struct PyBufferError: PyErrorMixin {

  // sourcery: pytypedoc
  internal static let doc = "Buffer error."

  public let ptr: RawPtr

  public init(ptr: RawPtr) {
    self.ptr = ptr
  }

  internal func initialize(_ py: Py,
                           type: PyType,
                           args: PyTuple,
                           traceback: PyTraceback? = nil,
                           cause: PyBaseException? = nil,
                           context: PyBaseException? = nil,
                           suppressContext: Bool = PyErrorHeader.defaultSuppressContext) {
    self.initializeBase(py,
                        type: type,
                        args: args,
                        traceback: traceback,
                        cause: cause,
                        context: context,
                        suppressContext: suppressContext)
  }

  // Nothing to do here.
  internal func beforeDeinitialize() { }

  internal static func createDebugString(ptr: RawPtr) -> String {
    let zelf = PyStopIteration(ptr: ptr)
    return "PyBufferError(type: \(zelf.typeName), flags: \(zelf.flags))"
  }

  // sourcery: pyproperty = __class__
  internal static func __class__(_ py: Py, zelf: PyObject) -> PyType {
    return zelf.type
  }

  // sourcery: pyproperty = __dict__
  internal static func __dict__(_ py: Py, zelf: PyObject) -> PyResult<PyObject> {
    guard let zelf = Self.downcast(py, zelf) else {
      return Self.invalidZelfArgument(py, zelf, "__dict__")
    }

    let result = zelf.asBaseException.getDict(py)
    return PyResult(result)
  }

  // sourcery: pystaticmethod = __new__
  internal static func __new__(_ py: Py,
                               type: PyType,
                               args: [PyObject],
                               kwargs: PyDict?) -> PyResult<PyObject> {
    let argsTuple = py.newTuple(elements: args)
    let result = py.memory.newBufferError(py, type: type, args: argsTuple)
    return PyResult(result)
  }

  // sourcery: pymethod = __init__
  internal static func __init__(_ py: Py,
                                zelf: PyObject,
                                args: [PyObject],
                                kwargs: PyDict?) -> PyResult<PyObject> {
    guard let zelf = Self.downcast(py, zelf) else {
      return Self.invalidZelfArgument(py, zelf, "__init__")
    }

    let zelfAsObject = zelf.asObject
    return PyException.__init__(py, zelf: zelfAsObject, args: args, kwargs: kwargs)
  }
}

// MARK: - EOFError

// sourcery: pyerrortype = EOFError, pybase = Exception, isDefault, isBaseType, hasGC
// sourcery: isBaseExceptionSubclass, instancesHave__dict__
public struct PyEOFError: PyErrorMixin {

  // sourcery: pytypedoc
  internal static let doc = "Read beyond end of file."

  public let ptr: RawPtr

  public init(ptr: RawPtr) {
    self.ptr = ptr
  }

  internal func initialize(_ py: Py,
                           type: PyType,
                           args: PyTuple,
                           traceback: PyTraceback? = nil,
                           cause: PyBaseException? = nil,
                           context: PyBaseException? = nil,
                           suppressContext: Bool = PyErrorHeader.defaultSuppressContext) {
    self.initializeBase(py,
                        type: type,
                        args: args,
                        traceback: traceback,
                        cause: cause,
                        context: context,
                        suppressContext: suppressContext)
  }

  // Nothing to do here.
  internal func beforeDeinitialize() { }

  internal static func createDebugString(ptr: RawPtr) -> String {
    let zelf = PyStopIteration(ptr: ptr)
    return "PyEOFError(type: \(zelf.typeName), flags: \(zelf.flags))"
  }

  // sourcery: pyproperty = __class__
  internal static func __class__(_ py: Py, zelf: PyObject) -> PyType {
    return zelf.type
  }

  // sourcery: pyproperty = __dict__
  internal static func __dict__(_ py: Py, zelf: PyObject) -> PyResult<PyObject> {
    guard let zelf = Self.downcast(py, zelf) else {
      return Self.invalidZelfArgument(py, zelf, "__dict__")
    }

    let result = zelf.asBaseException.getDict(py)
    return PyResult(result)
  }

  // sourcery: pystaticmethod = __new__
  internal static func __new__(_ py: Py,
                               type: PyType,
                               args: [PyObject],
                               kwargs: PyDict?) -> PyResult<PyObject> {
    let argsTuple = py.newTuple(elements: args)
    let result = py.memory.newEOFError(py, type: type, args: argsTuple)
    return PyResult(result)
  }

  // sourcery: pymethod = __init__
  internal static func __init__(_ py: Py,
                                zelf: PyObject,
                                args: [PyObject],
                                kwargs: PyDict?) -> PyResult<PyObject> {
    guard let zelf = Self.downcast(py, zelf) else {
      return Self.invalidZelfArgument(py, zelf, "__init__")
    }

    let zelfAsObject = zelf.asObject
    return PyException.__init__(py, zelf: zelfAsObject, args: args, kwargs: kwargs)
  }
}

// MARK: - ModuleNotFoundError

// sourcery: pyerrortype = ModuleNotFoundError, pybase = ImportError, isDefault, isBaseType, hasGC
// sourcery: isBaseExceptionSubclass, instancesHave__dict__
public struct PyModuleNotFoundError: PyErrorMixin {

  // sourcery: pytypedoc
  internal static let doc = "Module not found."

  public let ptr: RawPtr

  public init(ptr: RawPtr) {
    self.ptr = ptr
  }

  internal func initialize(_ py: Py,
                           type: PyType,
                           msg: PyObject?,
                           moduleName: PyObject?,
                           modulePath: PyObject?,
                           traceback: PyTraceback? = nil,
                           cause: PyBaseException? = nil,
                           context: PyBaseException? = nil,
                           suppressContext: Bool = PyErrorHeader.defaultSuppressContext) {
    self.initializeBase(py,
                        type: type,
                        msg: msg,
                        moduleName: moduleName,
                        modulePath: modulePath,
                        traceback: traceback,
                        cause: cause,
                        context: context,
                        suppressContext: suppressContext)
  }

  internal func initialize(_ py: Py,
                           type: PyType,
                           args: PyTuple,
                           traceback: PyTraceback? = nil,
                           cause: PyBaseException? = nil,
                           context: PyBaseException? = nil,
                           suppressContext: Bool = PyErrorHeader.defaultSuppressContext) {
    self.initializeBase(py,
                        type: type,
                        args: args,
                        traceback: traceback,
                        cause: cause,
                        context: context,
                        suppressContext: suppressContext)
  }

  // Nothing to do here.
  internal func beforeDeinitialize() { }

  internal static func createDebugString(ptr: RawPtr) -> String {
    let zelf = PyStopIteration(ptr: ptr)
    return "PyModuleNotFoundError(type: \(zelf.typeName), flags: \(zelf.flags))"
  }

  // sourcery: pyproperty = __class__
  internal static func __class__(_ py: Py, zelf: PyObject) -> PyType {
    return zelf.type
  }

  // sourcery: pyproperty = __dict__
  internal static func __dict__(_ py: Py, zelf: PyObject) -> PyResult<PyObject> {
    guard let zelf = Self.downcast(py, zelf) else {
      return Self.invalidZelfArgument(py, zelf, "__dict__")
    }

    let result = zelf.asBaseException.getDict(py)
    return PyResult(result)
  }

  // sourcery: pystaticmethod = __new__
  internal static func __new__(_ py: Py,
                               type: PyType,
                               args: [PyObject],
                               kwargs: PyDict?) -> PyResult<PyObject> {
    let argsTuple = py.newTuple(elements: args)
    let result = py.memory.newModuleNotFoundError(py, type: type, args: argsTuple)
    return PyResult(result)
  }

  // sourcery: pymethod = __init__
  internal static func __init__(_ py: Py,
                                zelf: PyObject,
                                args: [PyObject],
                                kwargs: PyDict?) -> PyResult<PyObject> {
    guard let zelf = Self.downcast(py, zelf) else {
      return Self.invalidZelfArgument(py, zelf, "__init__")
    }

    let zelfAsObject = zelf.asObject
    return PyImportError.__init__(py, zelf: zelfAsObject, args: args, kwargs: kwargs)
  }
}

// MARK: - LookupError

// sourcery: pyerrortype = LookupError, pybase = Exception, isDefault, isBaseType, hasGC
// sourcery: isBaseExceptionSubclass, instancesHave__dict__
public struct PyLookupError: PyErrorMixin {

  // sourcery: pytypedoc
  internal static let doc = "Base class for lookup errors."

  public let ptr: RawPtr

  public init(ptr: RawPtr) {
    self.ptr = ptr
  }

  internal func initialize(_ py: Py,
                           type: PyType,
                           args: PyTuple,
                           traceback: PyTraceback? = nil,
                           cause: PyBaseException? = nil,
                           context: PyBaseException? = nil,
                           suppressContext: Bool = PyErrorHeader.defaultSuppressContext) {
    self.initializeBase(py,
                        type: type,
                        args: args,
                        traceback: traceback,
                        cause: cause,
                        context: context,
                        suppressContext: suppressContext)
  }

  // Nothing to do here.
  internal func beforeDeinitialize() { }

  internal static func createDebugString(ptr: RawPtr) -> String {
    let zelf = PyStopIteration(ptr: ptr)
    return "PyLookupError(type: \(zelf.typeName), flags: \(zelf.flags))"
  }

  // sourcery: pyproperty = __class__
  internal static func __class__(_ py: Py, zelf: PyObject) -> PyType {
    return zelf.type
  }

  // sourcery: pyproperty = __dict__
  internal static func __dict__(_ py: Py, zelf: PyObject) -> PyResult<PyObject> {
    guard let zelf = Self.downcast(py, zelf) else {
      return Self.invalidZelfArgument(py, zelf, "__dict__")
    }

    let result = zelf.asBaseException.getDict(py)
    return PyResult(result)
  }

  // sourcery: pystaticmethod = __new__
  internal static func __new__(_ py: Py,
                               type: PyType,
                               args: [PyObject],
                               kwargs: PyDict?) -> PyResult<PyObject> {
    let argsTuple = py.newTuple(elements: args)
    let result = py.memory.newLookupError(py, type: type, args: argsTuple)
    return PyResult(result)
  }

  // sourcery: pymethod = __init__
  internal static func __init__(_ py: Py,
                                zelf: PyObject,
                                args: [PyObject],
                                kwargs: PyDict?) -> PyResult<PyObject> {
    guard let zelf = Self.downcast(py, zelf) else {
      return Self.invalidZelfArgument(py, zelf, "__init__")
    }

    let zelfAsObject = zelf.asObject
    return PyException.__init__(py, zelf: zelfAsObject, args: args, kwargs: kwargs)
  }
}

// MARK: - IndexError

// sourcery: pyerrortype = IndexError, pybase = LookupError, isDefault, isBaseType, hasGC
// sourcery: isBaseExceptionSubclass, instancesHave__dict__
public struct PyIndexError: PyErrorMixin {

  // sourcery: pytypedoc
  internal static let doc = "Sequence index out of range."

  public let ptr: RawPtr

  public init(ptr: RawPtr) {
    self.ptr = ptr
  }

  internal func initialize(_ py: Py,
                           type: PyType,
                           args: PyTuple,
                           traceback: PyTraceback? = nil,
                           cause: PyBaseException? = nil,
                           context: PyBaseException? = nil,
                           suppressContext: Bool = PyErrorHeader.defaultSuppressContext) {
    self.initializeBase(py,
                        type: type,
                        args: args,
                        traceback: traceback,
                        cause: cause,
                        context: context,
                        suppressContext: suppressContext)
  }

  // Nothing to do here.
  internal func beforeDeinitialize() { }

  internal static func createDebugString(ptr: RawPtr) -> String {
    let zelf = PyStopIteration(ptr: ptr)
    return "PyIndexError(type: \(zelf.typeName), flags: \(zelf.flags))"
  }

  // sourcery: pyproperty = __class__
  internal static func __class__(_ py: Py, zelf: PyObject) -> PyType {
    return zelf.type
  }

  // sourcery: pyproperty = __dict__
  internal static func __dict__(_ py: Py, zelf: PyObject) -> PyResult<PyObject> {
    guard let zelf = Self.downcast(py, zelf) else {
      return Self.invalidZelfArgument(py, zelf, "__dict__")
    }

    let result = zelf.asBaseException.getDict(py)
    return PyResult(result)
  }

  // sourcery: pystaticmethod = __new__
  internal static func __new__(_ py: Py,
                               type: PyType,
                               args: [PyObject],
                               kwargs: PyDict?) -> PyResult<PyObject> {
    let argsTuple = py.newTuple(elements: args)
    let result = py.memory.newIndexError(py, type: type, args: argsTuple)
    return PyResult(result)
  }

  // sourcery: pymethod = __init__
  internal static func __init__(_ py: Py,
                                zelf: PyObject,
                                args: [PyObject],
                                kwargs: PyDict?) -> PyResult<PyObject> {
    guard let zelf = Self.downcast(py, zelf) else {
      return Self.invalidZelfArgument(py, zelf, "__init__")
    }

    let zelfAsObject = zelf.asObject
    return PyLookupError.__init__(py, zelf: zelfAsObject, args: args, kwargs: kwargs)
  }
}

// MARK: - MemoryError

// sourcery: pyerrortype = MemoryError, pybase = Exception, isDefault, isBaseType, hasGC
// sourcery: isBaseExceptionSubclass, instancesHave__dict__
public struct PyMemoryError: PyErrorMixin {

  // sourcery: pytypedoc
  internal static let doc = "Out of memory."

  public let ptr: RawPtr

  public init(ptr: RawPtr) {
    self.ptr = ptr
  }

  internal func initialize(_ py: Py,
                           type: PyType,
                           args: PyTuple,
                           traceback: PyTraceback? = nil,
                           cause: PyBaseException? = nil,
                           context: PyBaseException? = nil,
                           suppressContext: Bool = PyErrorHeader.defaultSuppressContext) {
    self.initializeBase(py,
                        type: type,
                        args: args,
                        traceback: traceback,
                        cause: cause,
                        context: context,
                        suppressContext: suppressContext)
  }

  // Nothing to do here.
  internal func beforeDeinitialize() { }

  internal static func createDebugString(ptr: RawPtr) -> String {
    let zelf = PyStopIteration(ptr: ptr)
    return "PyMemoryError(type: \(zelf.typeName), flags: \(zelf.flags))"
  }

  // sourcery: pyproperty = __class__
  internal static func __class__(_ py: Py, zelf: PyObject) -> PyType {
    return zelf.type
  }

  // sourcery: pyproperty = __dict__
  internal static func __dict__(_ py: Py, zelf: PyObject) -> PyResult<PyObject> {
    guard let zelf = Self.downcast(py, zelf) else {
      return Self.invalidZelfArgument(py, zelf, "__dict__")
    }

    let result = zelf.asBaseException.getDict(py)
    return PyResult(result)
  }

  // sourcery: pystaticmethod = __new__
  internal static func __new__(_ py: Py,
                               type: PyType,
                               args: [PyObject],
                               kwargs: PyDict?) -> PyResult<PyObject> {
    let argsTuple = py.newTuple(elements: args)
    let result = py.memory.newMemoryError(py, type: type, args: argsTuple)
    return PyResult(result)
  }

  // sourcery: pymethod = __init__
  internal static func __init__(_ py: Py,
                                zelf: PyObject,
                                args: [PyObject],
                                kwargs: PyDict?) -> PyResult<PyObject> {
    guard let zelf = Self.downcast(py, zelf) else {
      return Self.invalidZelfArgument(py, zelf, "__init__")
    }

    let zelfAsObject = zelf.asObject
    return PyException.__init__(py, zelf: zelfAsObject, args: args, kwargs: kwargs)
  }
}

// MARK: - NameError

// sourcery: pyerrortype = NameError, pybase = Exception, isDefault, isBaseType, hasGC
// sourcery: isBaseExceptionSubclass, instancesHave__dict__
public struct PyNameError: PyErrorMixin {

  // sourcery: pytypedoc
  internal static let doc = "Name not found globally."

  public let ptr: RawPtr

  public init(ptr: RawPtr) {
    self.ptr = ptr
  }

  internal func initialize(_ py: Py,
                           type: PyType,
                           args: PyTuple,
                           traceback: PyTraceback? = nil,
                           cause: PyBaseException? = nil,
                           context: PyBaseException? = nil,
                           suppressContext: Bool = PyErrorHeader.defaultSuppressContext) {
    self.initializeBase(py,
                        type: type,
                        args: args,
                        traceback: traceback,
                        cause: cause,
                        context: context,
                        suppressContext: suppressContext)
  }

  // Nothing to do here.
  internal func beforeDeinitialize() { }

  internal static func createDebugString(ptr: RawPtr) -> String {
    let zelf = PyStopIteration(ptr: ptr)
    return "PyNameError(type: \(zelf.typeName), flags: \(zelf.flags))"
  }

  // sourcery: pyproperty = __class__
  internal static func __class__(_ py: Py, zelf: PyObject) -> PyType {
    return zelf.type
  }

  // sourcery: pyproperty = __dict__
  internal static func __dict__(_ py: Py, zelf: PyObject) -> PyResult<PyObject> {
    guard let zelf = Self.downcast(py, zelf) else {
      return Self.invalidZelfArgument(py, zelf, "__dict__")
    }

    let result = zelf.asBaseException.getDict(py)
    return PyResult(result)
  }

  // sourcery: pystaticmethod = __new__
  internal static func __new__(_ py: Py,
                               type: PyType,
                               args: [PyObject],
                               kwargs: PyDict?) -> PyResult<PyObject> {
    let argsTuple = py.newTuple(elements: args)
    let result = py.memory.newNameError(py, type: type, args: argsTuple)
    return PyResult(result)
  }

  // sourcery: pymethod = __init__
  internal static func __init__(_ py: Py,
                                zelf: PyObject,
                                args: [PyObject],
                                kwargs: PyDict?) -> PyResult<PyObject> {
    guard let zelf = Self.downcast(py, zelf) else {
      return Self.invalidZelfArgument(py, zelf, "__init__")
    }

    let zelfAsObject = zelf.asObject
    return PyException.__init__(py, zelf: zelfAsObject, args: args, kwargs: kwargs)
  }
}

// MARK: - UnboundLocalError

// sourcery: pyerrortype = UnboundLocalError, pybase = NameError, isDefault, isBaseType, hasGC
// sourcery: isBaseExceptionSubclass, instancesHave__dict__
public struct PyUnboundLocalError: PyErrorMixin {

  // sourcery: pytypedoc
  internal static let doc = "Local name referenced but not bound to a value."

  public let ptr: RawPtr

  public init(ptr: RawPtr) {
    self.ptr = ptr
  }

  internal func initialize(_ py: Py,
                           type: PyType,
                           args: PyTuple,
                           traceback: PyTraceback? = nil,
                           cause: PyBaseException? = nil,
                           context: PyBaseException? = nil,
                           suppressContext: Bool = PyErrorHeader.defaultSuppressContext) {
    self.initializeBase(py,
                        type: type,
                        args: args,
                        traceback: traceback,
                        cause: cause,
                        context: context,
                        suppressContext: suppressContext)
  }

  // Nothing to do here.
  internal func beforeDeinitialize() { }

  internal static func createDebugString(ptr: RawPtr) -> String {
    let zelf = PyStopIteration(ptr: ptr)
    return "PyUnboundLocalError(type: \(zelf.typeName), flags: \(zelf.flags))"
  }

  // sourcery: pyproperty = __class__
  internal static func __class__(_ py: Py, zelf: PyObject) -> PyType {
    return zelf.type
  }

  // sourcery: pyproperty = __dict__
  internal static func __dict__(_ py: Py, zelf: PyObject) -> PyResult<PyObject> {
    guard let zelf = Self.downcast(py, zelf) else {
      return Self.invalidZelfArgument(py, zelf, "__dict__")
    }

    let result = zelf.asBaseException.getDict(py)
    return PyResult(result)
  }

  // sourcery: pystaticmethod = __new__
  internal static func __new__(_ py: Py,
                               type: PyType,
                               args: [PyObject],
                               kwargs: PyDict?) -> PyResult<PyObject> {
    let argsTuple = py.newTuple(elements: args)
    let result = py.memory.newUnboundLocalError(py, type: type, args: argsTuple)
    return PyResult(result)
  }

  // sourcery: pymethod = __init__
  internal static func __init__(_ py: Py,
                                zelf: PyObject,
                                args: [PyObject],
                                kwargs: PyDict?) -> PyResult<PyObject> {
    guard let zelf = Self.downcast(py, zelf) else {
      return Self.invalidZelfArgument(py, zelf, "__init__")
    }

    let zelfAsObject = zelf.asObject
    return PyNameError.__init__(py, zelf: zelfAsObject, args: args, kwargs: kwargs)
  }
}

// MARK: - OSError

// sourcery: pyerrortype = OSError, pybase = Exception, isDefault, isBaseType, hasGC
// sourcery: isBaseExceptionSubclass, instancesHave__dict__
public struct PyOSError: PyErrorMixin {

  // sourcery: pytypedoc
  internal static let doc = "Base class for I/O related errors."

  public let ptr: RawPtr

  public init(ptr: RawPtr) {
    self.ptr = ptr
  }

  internal func initialize(_ py: Py,
                           type: PyType,
                           args: PyTuple,
                           traceback: PyTraceback? = nil,
                           cause: PyBaseException? = nil,
                           context: PyBaseException? = nil,
                           suppressContext: Bool = PyErrorHeader.defaultSuppressContext) {
    self.initializeBase(py,
                        type: type,
                        args: args,
                        traceback: traceback,
                        cause: cause,
                        context: context,
                        suppressContext: suppressContext)
  }

  // Nothing to do here.
  internal func beforeDeinitialize() { }

  internal static func createDebugString(ptr: RawPtr) -> String {
    let zelf = PyStopIteration(ptr: ptr)
    return "PyOSError(type: \(zelf.typeName), flags: \(zelf.flags))"
  }

  // sourcery: pyproperty = __class__
  internal static func __class__(_ py: Py, zelf: PyObject) -> PyType {
    return zelf.type
  }

  // sourcery: pyproperty = __dict__
  internal static func __dict__(_ py: Py, zelf: PyObject) -> PyResult<PyObject> {
    guard let zelf = Self.downcast(py, zelf) else {
      return Self.invalidZelfArgument(py, zelf, "__dict__")
    }

    let result = zelf.asBaseException.getDict(py)
    return PyResult(result)
  }

  // sourcery: pystaticmethod = __new__
  internal static func __new__(_ py: Py,
                               type: PyType,
                               args: [PyObject],
                               kwargs: PyDict?) -> PyResult<PyObject> {
    let argsTuple = py.newTuple(elements: args)
    let result = py.memory.newOSError(py, type: type, args: argsTuple)
    return PyResult(result)
  }

  // sourcery: pymethod = __init__
  internal static func __init__(_ py: Py,
                                zelf: PyObject,
                                args: [PyObject],
                                kwargs: PyDict?) -> PyResult<PyObject> {
    guard let zelf = Self.downcast(py, zelf) else {
      return Self.invalidZelfArgument(py, zelf, "__init__")
    }

    let zelfAsObject = zelf.asObject
    return PyException.__init__(py, zelf: zelfAsObject, args: args, kwargs: kwargs)
  }
}

// MARK: - BlockingIOError

// sourcery: pyerrortype = BlockingIOError, pybase = OSError, isDefault, isBaseType, hasGC
// sourcery: isBaseExceptionSubclass, instancesHave__dict__
public struct PyBlockingIOError: PyErrorMixin {

  // sourcery: pytypedoc
  internal static let doc = "I/O operation would block."

  public let ptr: RawPtr

  public init(ptr: RawPtr) {
    self.ptr = ptr
  }

  internal func initialize(_ py: Py,
                           type: PyType,
                           args: PyTuple,
                           traceback: PyTraceback? = nil,
                           cause: PyBaseException? = nil,
                           context: PyBaseException? = nil,
                           suppressContext: Bool = PyErrorHeader.defaultSuppressContext) {
    self.initializeBase(py,
                        type: type,
                        args: args,
                        traceback: traceback,
                        cause: cause,
                        context: context,
                        suppressContext: suppressContext)
  }

  // Nothing to do here.
  internal func beforeDeinitialize() { }

  internal static func createDebugString(ptr: RawPtr) -> String {
    let zelf = PyStopIteration(ptr: ptr)
    return "PyBlockingIOError(type: \(zelf.typeName), flags: \(zelf.flags))"
  }

  // sourcery: pyproperty = __class__
  internal static func __class__(_ py: Py, zelf: PyObject) -> PyType {
    return zelf.type
  }

  // sourcery: pyproperty = __dict__
  internal static func __dict__(_ py: Py, zelf: PyObject) -> PyResult<PyObject> {
    guard let zelf = Self.downcast(py, zelf) else {
      return Self.invalidZelfArgument(py, zelf, "__dict__")
    }

    let result = zelf.asBaseException.getDict(py)
    return PyResult(result)
  }

  // sourcery: pystaticmethod = __new__
  internal static func __new__(_ py: Py,
                               type: PyType,
                               args: [PyObject],
                               kwargs: PyDict?) -> PyResult<PyObject> {
    let argsTuple = py.newTuple(elements: args)
    let result = py.memory.newBlockingIOError(py, type: type, args: argsTuple)
    return PyResult(result)
  }

  // sourcery: pymethod = __init__
  internal static func __init__(_ py: Py,
                                zelf: PyObject,
                                args: [PyObject],
                                kwargs: PyDict?) -> PyResult<PyObject> {
    guard let zelf = Self.downcast(py, zelf) else {
      return Self.invalidZelfArgument(py, zelf, "__init__")
    }

    let zelfAsObject = zelf.asObject
    return PyOSError.__init__(py, zelf: zelfAsObject, args: args, kwargs: kwargs)
  }
}

// MARK: - ChildProcessError

// sourcery: pyerrortype = ChildProcessError, pybase = OSError, isDefault, isBaseType, hasGC
// sourcery: isBaseExceptionSubclass, instancesHave__dict__
public struct PyChildProcessError: PyErrorMixin {

  // sourcery: pytypedoc
  internal static let doc = "Child process error."

  public let ptr: RawPtr

  public init(ptr: RawPtr) {
    self.ptr = ptr
  }

  internal func initialize(_ py: Py,
                           type: PyType,
                           args: PyTuple,
                           traceback: PyTraceback? = nil,
                           cause: PyBaseException? = nil,
                           context: PyBaseException? = nil,
                           suppressContext: Bool = PyErrorHeader.defaultSuppressContext) {
    self.initializeBase(py,
                        type: type,
                        args: args,
                        traceback: traceback,
                        cause: cause,
                        context: context,
                        suppressContext: suppressContext)
  }

  // Nothing to do here.
  internal func beforeDeinitialize() { }

  internal static func createDebugString(ptr: RawPtr) -> String {
    let zelf = PyStopIteration(ptr: ptr)
    return "PyChildProcessError(type: \(zelf.typeName), flags: \(zelf.flags))"
  }

  // sourcery: pyproperty = __class__
  internal static func __class__(_ py: Py, zelf: PyObject) -> PyType {
    return zelf.type
  }

  // sourcery: pyproperty = __dict__
  internal static func __dict__(_ py: Py, zelf: PyObject) -> PyResult<PyObject> {
    guard let zelf = Self.downcast(py, zelf) else {
      return Self.invalidZelfArgument(py, zelf, "__dict__")
    }

    let result = zelf.asBaseException.getDict(py)
    return PyResult(result)
  }

  // sourcery: pystaticmethod = __new__
  internal static func __new__(_ py: Py,
                               type: PyType,
                               args: [PyObject],
                               kwargs: PyDict?) -> PyResult<PyObject> {
    let argsTuple = py.newTuple(elements: args)
    let result = py.memory.newChildProcessError(py, type: type, args: argsTuple)
    return PyResult(result)
  }

  // sourcery: pymethod = __init__
  internal static func __init__(_ py: Py,
                                zelf: PyObject,
                                args: [PyObject],
                                kwargs: PyDict?) -> PyResult<PyObject> {
    guard let zelf = Self.downcast(py, zelf) else {
      return Self.invalidZelfArgument(py, zelf, "__init__")
    }

    let zelfAsObject = zelf.asObject
    return PyOSError.__init__(py, zelf: zelfAsObject, args: args, kwargs: kwargs)
  }
}

// MARK: - ConnectionError

// sourcery: pyerrortype = ConnectionError, pybase = OSError, isDefault, isBaseType, hasGC
// sourcery: isBaseExceptionSubclass, instancesHave__dict__
public struct PyConnectionError: PyErrorMixin {

  // sourcery: pytypedoc
  internal static let doc = "Connection error."

  public let ptr: RawPtr

  public init(ptr: RawPtr) {
    self.ptr = ptr
  }

  internal func initialize(_ py: Py,
                           type: PyType,
                           args: PyTuple,
                           traceback: PyTraceback? = nil,
                           cause: PyBaseException? = nil,
                           context: PyBaseException? = nil,
                           suppressContext: Bool = PyErrorHeader.defaultSuppressContext) {
    self.initializeBase(py,
                        type: type,
                        args: args,
                        traceback: traceback,
                        cause: cause,
                        context: context,
                        suppressContext: suppressContext)
  }

  // Nothing to do here.
  internal func beforeDeinitialize() { }

  internal static func createDebugString(ptr: RawPtr) -> String {
    let zelf = PyStopIteration(ptr: ptr)
    return "PyConnectionError(type: \(zelf.typeName), flags: \(zelf.flags))"
  }

  // sourcery: pyproperty = __class__
  internal static func __class__(_ py: Py, zelf: PyObject) -> PyType {
    return zelf.type
  }

  // sourcery: pyproperty = __dict__
  internal static func __dict__(_ py: Py, zelf: PyObject) -> PyResult<PyObject> {
    guard let zelf = Self.downcast(py, zelf) else {
      return Self.invalidZelfArgument(py, zelf, "__dict__")
    }

    let result = zelf.asBaseException.getDict(py)
    return PyResult(result)
  }

  // sourcery: pystaticmethod = __new__
  internal static func __new__(_ py: Py,
                               type: PyType,
                               args: [PyObject],
                               kwargs: PyDict?) -> PyResult<PyObject> {
    let argsTuple = py.newTuple(elements: args)
    let result = py.memory.newConnectionError(py, type: type, args: argsTuple)
    return PyResult(result)
  }

  // sourcery: pymethod = __init__
  internal static func __init__(_ py: Py,
                                zelf: PyObject,
                                args: [PyObject],
                                kwargs: PyDict?) -> PyResult<PyObject> {
    guard let zelf = Self.downcast(py, zelf) else {
      return Self.invalidZelfArgument(py, zelf, "__init__")
    }

    let zelfAsObject = zelf.asObject
    return PyOSError.__init__(py, zelf: zelfAsObject, args: args, kwargs: kwargs)
  }
}

// MARK: - BrokenPipeError

// sourcery: pyerrortype = BrokenPipeError, pybase = ConnectionError, isDefault, isBaseType, hasGC
// sourcery: isBaseExceptionSubclass, instancesHave__dict__
public struct PyBrokenPipeError: PyErrorMixin {

  // sourcery: pytypedoc
  internal static let doc = "Broken pipe."

  public let ptr: RawPtr

  public init(ptr: RawPtr) {
    self.ptr = ptr
  }

  internal func initialize(_ py: Py,
                           type: PyType,
                           args: PyTuple,
                           traceback: PyTraceback? = nil,
                           cause: PyBaseException? = nil,
                           context: PyBaseException? = nil,
                           suppressContext: Bool = PyErrorHeader.defaultSuppressContext) {
    self.initializeBase(py,
                        type: type,
                        args: args,
                        traceback: traceback,
                        cause: cause,
                        context: context,
                        suppressContext: suppressContext)
  }

  // Nothing to do here.
  internal func beforeDeinitialize() { }

  internal static func createDebugString(ptr: RawPtr) -> String {
    let zelf = PyStopIteration(ptr: ptr)
    return "PyBrokenPipeError(type: \(zelf.typeName), flags: \(zelf.flags))"
  }

  // sourcery: pyproperty = __class__
  internal static func __class__(_ py: Py, zelf: PyObject) -> PyType {
    return zelf.type
  }

  // sourcery: pyproperty = __dict__
  internal static func __dict__(_ py: Py, zelf: PyObject) -> PyResult<PyObject> {
    guard let zelf = Self.downcast(py, zelf) else {
      return Self.invalidZelfArgument(py, zelf, "__dict__")
    }

    let result = zelf.asBaseException.getDict(py)
    return PyResult(result)
  }

  // sourcery: pystaticmethod = __new__
  internal static func __new__(_ py: Py,
                               type: PyType,
                               args: [PyObject],
                               kwargs: PyDict?) -> PyResult<PyObject> {
    let argsTuple = py.newTuple(elements: args)
    let result = py.memory.newBrokenPipeError(py, type: type, args: argsTuple)
    return PyResult(result)
  }

  // sourcery: pymethod = __init__
  internal static func __init__(_ py: Py,
                                zelf: PyObject,
                                args: [PyObject],
                                kwargs: PyDict?) -> PyResult<PyObject> {
    guard let zelf = Self.downcast(py, zelf) else {
      return Self.invalidZelfArgument(py, zelf, "__init__")
    }

    let zelfAsObject = zelf.asObject
    return PyConnectionError.__init__(py, zelf: zelfAsObject, args: args, kwargs: kwargs)
  }
}

// MARK: - ConnectionAbortedError

// sourcery: pyerrortype = ConnectionAbortedError, pybase = ConnectionError, isDefault, isBaseType, hasGC
// sourcery: isBaseExceptionSubclass, instancesHave__dict__
public struct PyConnectionAbortedError: PyErrorMixin {

  // sourcery: pytypedoc
  internal static let doc = "Connection aborted."

  public let ptr: RawPtr

  public init(ptr: RawPtr) {
    self.ptr = ptr
  }

  internal func initialize(_ py: Py,
                           type: PyType,
                           args: PyTuple,
                           traceback: PyTraceback? = nil,
                           cause: PyBaseException? = nil,
                           context: PyBaseException? = nil,
                           suppressContext: Bool = PyErrorHeader.defaultSuppressContext) {
    self.initializeBase(py,
                        type: type,
                        args: args,
                        traceback: traceback,
                        cause: cause,
                        context: context,
                        suppressContext: suppressContext)
  }

  // Nothing to do here.
  internal func beforeDeinitialize() { }

  internal static func createDebugString(ptr: RawPtr) -> String {
    let zelf = PyStopIteration(ptr: ptr)
    return "PyConnectionAbortedError(type: \(zelf.typeName), flags: \(zelf.flags))"
  }

  // sourcery: pyproperty = __class__
  internal static func __class__(_ py: Py, zelf: PyObject) -> PyType {
    return zelf.type
  }

  // sourcery: pyproperty = __dict__
  internal static func __dict__(_ py: Py, zelf: PyObject) -> PyResult<PyObject> {
    guard let zelf = Self.downcast(py, zelf) else {
      return Self.invalidZelfArgument(py, zelf, "__dict__")
    }

    let result = zelf.asBaseException.getDict(py)
    return PyResult(result)
  }

  // sourcery: pystaticmethod = __new__
  internal static func __new__(_ py: Py,
                               type: PyType,
                               args: [PyObject],
                               kwargs: PyDict?) -> PyResult<PyObject> {
    let argsTuple = py.newTuple(elements: args)
    let result = py.memory.newConnectionAbortedError(py, type: type, args: argsTuple)
    return PyResult(result)
  }

  // sourcery: pymethod = __init__
  internal static func __init__(_ py: Py,
                                zelf: PyObject,
                                args: [PyObject],
                                kwargs: PyDict?) -> PyResult<PyObject> {
    guard let zelf = Self.downcast(py, zelf) else {
      return Self.invalidZelfArgument(py, zelf, "__init__")
    }

    let zelfAsObject = zelf.asObject
    return PyConnectionError.__init__(py, zelf: zelfAsObject, args: args, kwargs: kwargs)
  }
}

// MARK: - ConnectionRefusedError

// sourcery: pyerrortype = ConnectionRefusedError, pybase = ConnectionError, isDefault, isBaseType, hasGC
// sourcery: isBaseExceptionSubclass, instancesHave__dict__
public struct PyConnectionRefusedError: PyErrorMixin {

  // sourcery: pytypedoc
  internal static let doc = "Connection refused."

  public let ptr: RawPtr

  public init(ptr: RawPtr) {
    self.ptr = ptr
  }

  internal func initialize(_ py: Py,
                           type: PyType,
                           args: PyTuple,
                           traceback: PyTraceback? = nil,
                           cause: PyBaseException? = nil,
                           context: PyBaseException? = nil,
                           suppressContext: Bool = PyErrorHeader.defaultSuppressContext) {
    self.initializeBase(py,
                        type: type,
                        args: args,
                        traceback: traceback,
                        cause: cause,
                        context: context,
                        suppressContext: suppressContext)
  }

  // Nothing to do here.
  internal func beforeDeinitialize() { }

  internal static func createDebugString(ptr: RawPtr) -> String {
    let zelf = PyStopIteration(ptr: ptr)
    return "PyConnectionRefusedError(type: \(zelf.typeName), flags: \(zelf.flags))"
  }

  // sourcery: pyproperty = __class__
  internal static func __class__(_ py: Py, zelf: PyObject) -> PyType {
    return zelf.type
  }

  // sourcery: pyproperty = __dict__
  internal static func __dict__(_ py: Py, zelf: PyObject) -> PyResult<PyObject> {
    guard let zelf = Self.downcast(py, zelf) else {
      return Self.invalidZelfArgument(py, zelf, "__dict__")
    }

    let result = zelf.asBaseException.getDict(py)
    return PyResult(result)
  }

  // sourcery: pystaticmethod = __new__
  internal static func __new__(_ py: Py,
                               type: PyType,
                               args: [PyObject],
                               kwargs: PyDict?) -> PyResult<PyObject> {
    let argsTuple = py.newTuple(elements: args)
    let result = py.memory.newConnectionRefusedError(py, type: type, args: argsTuple)
    return PyResult(result)
  }

  // sourcery: pymethod = __init__
  internal static func __init__(_ py: Py,
                                zelf: PyObject,
                                args: [PyObject],
                                kwargs: PyDict?) -> PyResult<PyObject> {
    guard let zelf = Self.downcast(py, zelf) else {
      return Self.invalidZelfArgument(py, zelf, "__init__")
    }

    let zelfAsObject = zelf.asObject
    return PyConnectionError.__init__(py, zelf: zelfAsObject, args: args, kwargs: kwargs)
  }
}

// MARK: - ConnectionResetError

// sourcery: pyerrortype = ConnectionResetError, pybase = ConnectionError, isDefault, isBaseType, hasGC
// sourcery: isBaseExceptionSubclass, instancesHave__dict__
public struct PyConnectionResetError: PyErrorMixin {

  // sourcery: pytypedoc
  internal static let doc = "Connection reset."

  public let ptr: RawPtr

  public init(ptr: RawPtr) {
    self.ptr = ptr
  }

  internal func initialize(_ py: Py,
                           type: PyType,
                           args: PyTuple,
                           traceback: PyTraceback? = nil,
                           cause: PyBaseException? = nil,
                           context: PyBaseException? = nil,
                           suppressContext: Bool = PyErrorHeader.defaultSuppressContext) {
    self.initializeBase(py,
                        type: type,
                        args: args,
                        traceback: traceback,
                        cause: cause,
                        context: context,
                        suppressContext: suppressContext)
  }

  // Nothing to do here.
  internal func beforeDeinitialize() { }

  internal static func createDebugString(ptr: RawPtr) -> String {
    let zelf = PyStopIteration(ptr: ptr)
    return "PyConnectionResetError(type: \(zelf.typeName), flags: \(zelf.flags))"
  }

  // sourcery: pyproperty = __class__
  internal static func __class__(_ py: Py, zelf: PyObject) -> PyType {
    return zelf.type
  }

  // sourcery: pyproperty = __dict__
  internal static func __dict__(_ py: Py, zelf: PyObject) -> PyResult<PyObject> {
    guard let zelf = Self.downcast(py, zelf) else {
      return Self.invalidZelfArgument(py, zelf, "__dict__")
    }

    let result = zelf.asBaseException.getDict(py)
    return PyResult(result)
  }

  // sourcery: pystaticmethod = __new__
  internal static func __new__(_ py: Py,
                               type: PyType,
                               args: [PyObject],
                               kwargs: PyDict?) -> PyResult<PyObject> {
    let argsTuple = py.newTuple(elements: args)
    let result = py.memory.newConnectionResetError(py, type: type, args: argsTuple)
    return PyResult(result)
  }

  // sourcery: pymethod = __init__
  internal static func __init__(_ py: Py,
                                zelf: PyObject,
                                args: [PyObject],
                                kwargs: PyDict?) -> PyResult<PyObject> {
    guard let zelf = Self.downcast(py, zelf) else {
      return Self.invalidZelfArgument(py, zelf, "__init__")
    }

    let zelfAsObject = zelf.asObject
    return PyConnectionError.__init__(py, zelf: zelfAsObject, args: args, kwargs: kwargs)
  }
}

// MARK: - FileExistsError

// sourcery: pyerrortype = FileExistsError, pybase = OSError, isDefault, isBaseType, hasGC
// sourcery: isBaseExceptionSubclass, instancesHave__dict__
public struct PyFileExistsError: PyErrorMixin {

  // sourcery: pytypedoc
  internal static let doc = "File already exists."

  public let ptr: RawPtr

  public init(ptr: RawPtr) {
    self.ptr = ptr
  }

  internal func initialize(_ py: Py,
                           type: PyType,
                           args: PyTuple,
                           traceback: PyTraceback? = nil,
                           cause: PyBaseException? = nil,
                           context: PyBaseException? = nil,
                           suppressContext: Bool = PyErrorHeader.defaultSuppressContext) {
    self.initializeBase(py,
                        type: type,
                        args: args,
                        traceback: traceback,
                        cause: cause,
                        context: context,
                        suppressContext: suppressContext)
  }

  // Nothing to do here.
  internal func beforeDeinitialize() { }

  internal static func createDebugString(ptr: RawPtr) -> String {
    let zelf = PyStopIteration(ptr: ptr)
    return "PyFileExistsError(type: \(zelf.typeName), flags: \(zelf.flags))"
  }

  // sourcery: pyproperty = __class__
  internal static func __class__(_ py: Py, zelf: PyObject) -> PyType {
    return zelf.type
  }

  // sourcery: pyproperty = __dict__
  internal static func __dict__(_ py: Py, zelf: PyObject) -> PyResult<PyObject> {
    guard let zelf = Self.downcast(py, zelf) else {
      return Self.invalidZelfArgument(py, zelf, "__dict__")
    }

    let result = zelf.asBaseException.getDict(py)
    return PyResult(result)
  }

  // sourcery: pystaticmethod = __new__
  internal static func __new__(_ py: Py,
                               type: PyType,
                               args: [PyObject],
                               kwargs: PyDict?) -> PyResult<PyObject> {
    let argsTuple = py.newTuple(elements: args)
    let result = py.memory.newFileExistsError(py, type: type, args: argsTuple)
    return PyResult(result)
  }

  // sourcery: pymethod = __init__
  internal static func __init__(_ py: Py,
                                zelf: PyObject,
                                args: [PyObject],
                                kwargs: PyDict?) -> PyResult<PyObject> {
    guard let zelf = Self.downcast(py, zelf) else {
      return Self.invalidZelfArgument(py, zelf, "__init__")
    }

    let zelfAsObject = zelf.asObject
    return PyOSError.__init__(py, zelf: zelfAsObject, args: args, kwargs: kwargs)
  }
}

// MARK: - FileNotFoundError

// sourcery: pyerrortype = FileNotFoundError, pybase = OSError, isDefault, isBaseType, hasGC
// sourcery: isBaseExceptionSubclass, instancesHave__dict__
public struct PyFileNotFoundError: PyErrorMixin {

  // sourcery: pytypedoc
  internal static let doc = "File not found."

  public let ptr: RawPtr

  public init(ptr: RawPtr) {
    self.ptr = ptr
  }

  internal func initialize(_ py: Py,
                           type: PyType,
                           args: PyTuple,
                           traceback: PyTraceback? = nil,
                           cause: PyBaseException? = nil,
                           context: PyBaseException? = nil,
                           suppressContext: Bool = PyErrorHeader.defaultSuppressContext) {
    self.initializeBase(py,
                        type: type,
                        args: args,
                        traceback: traceback,
                        cause: cause,
                        context: context,
                        suppressContext: suppressContext)
  }

  // Nothing to do here.
  internal func beforeDeinitialize() { }

  internal static func createDebugString(ptr: RawPtr) -> String {
    let zelf = PyStopIteration(ptr: ptr)
    return "PyFileNotFoundError(type: \(zelf.typeName), flags: \(zelf.flags))"
  }

  // sourcery: pyproperty = __class__
  internal static func __class__(_ py: Py, zelf: PyObject) -> PyType {
    return zelf.type
  }

  // sourcery: pyproperty = __dict__
  internal static func __dict__(_ py: Py, zelf: PyObject) -> PyResult<PyObject> {
    guard let zelf = Self.downcast(py, zelf) else {
      return Self.invalidZelfArgument(py, zelf, "__dict__")
    }

    let result = zelf.asBaseException.getDict(py)
    return PyResult(result)
  }

  // sourcery: pystaticmethod = __new__
  internal static func __new__(_ py: Py,
                               type: PyType,
                               args: [PyObject],
                               kwargs: PyDict?) -> PyResult<PyObject> {
    let argsTuple = py.newTuple(elements: args)
    let result = py.memory.newFileNotFoundError(py, type: type, args: argsTuple)
    return PyResult(result)
  }

  // sourcery: pymethod = __init__
  internal static func __init__(_ py: Py,
                                zelf: PyObject,
                                args: [PyObject],
                                kwargs: PyDict?) -> PyResult<PyObject> {
    guard let zelf = Self.downcast(py, zelf) else {
      return Self.invalidZelfArgument(py, zelf, "__init__")
    }

    let zelfAsObject = zelf.asObject
    return PyOSError.__init__(py, zelf: zelfAsObject, args: args, kwargs: kwargs)
  }
}

// MARK: - InterruptedError

// sourcery: pyerrortype = InterruptedError, pybase = OSError, isDefault, isBaseType, hasGC
// sourcery: isBaseExceptionSubclass, instancesHave__dict__
public struct PyInterruptedError: PyErrorMixin {

  // sourcery: pytypedoc
  internal static let doc = "Interrupted by signal."

  public let ptr: RawPtr

  public init(ptr: RawPtr) {
    self.ptr = ptr
  }

  internal func initialize(_ py: Py,
                           type: PyType,
                           args: PyTuple,
                           traceback: PyTraceback? = nil,
                           cause: PyBaseException? = nil,
                           context: PyBaseException? = nil,
                           suppressContext: Bool = PyErrorHeader.defaultSuppressContext) {
    self.initializeBase(py,
                        type: type,
                        args: args,
                        traceback: traceback,
                        cause: cause,
                        context: context,
                        suppressContext: suppressContext)
  }

  // Nothing to do here.
  internal func beforeDeinitialize() { }

  internal static func createDebugString(ptr: RawPtr) -> String {
    let zelf = PyStopIteration(ptr: ptr)
    return "PyInterruptedError(type: \(zelf.typeName), flags: \(zelf.flags))"
  }

  // sourcery: pyproperty = __class__
  internal static func __class__(_ py: Py, zelf: PyObject) -> PyType {
    return zelf.type
  }

  // sourcery: pyproperty = __dict__
  internal static func __dict__(_ py: Py, zelf: PyObject) -> PyResult<PyObject> {
    guard let zelf = Self.downcast(py, zelf) else {
      return Self.invalidZelfArgument(py, zelf, "__dict__")
    }

    let result = zelf.asBaseException.getDict(py)
    return PyResult(result)
  }

  // sourcery: pystaticmethod = __new__
  internal static func __new__(_ py: Py,
                               type: PyType,
                               args: [PyObject],
                               kwargs: PyDict?) -> PyResult<PyObject> {
    let argsTuple = py.newTuple(elements: args)
    let result = py.memory.newInterruptedError(py, type: type, args: argsTuple)
    return PyResult(result)
  }

  // sourcery: pymethod = __init__
  internal static func __init__(_ py: Py,
                                zelf: PyObject,
                                args: [PyObject],
                                kwargs: PyDict?) -> PyResult<PyObject> {
    guard let zelf = Self.downcast(py, zelf) else {
      return Self.invalidZelfArgument(py, zelf, "__init__")
    }

    let zelfAsObject = zelf.asObject
    return PyOSError.__init__(py, zelf: zelfAsObject, args: args, kwargs: kwargs)
  }
}

// MARK: - IsADirectoryError

// sourcery: pyerrortype = IsADirectoryError, pybase = OSError, isDefault, isBaseType, hasGC
// sourcery: isBaseExceptionSubclass, instancesHave__dict__
public struct PyIsADirectoryError: PyErrorMixin {

  // sourcery: pytypedoc
  internal static let doc = "Operation doesn't work on directories."

  public let ptr: RawPtr

  public init(ptr: RawPtr) {
    self.ptr = ptr
  }

  internal func initialize(_ py: Py,
                           type: PyType,
                           args: PyTuple,
                           traceback: PyTraceback? = nil,
                           cause: PyBaseException? = nil,
                           context: PyBaseException? = nil,
                           suppressContext: Bool = PyErrorHeader.defaultSuppressContext) {
    self.initializeBase(py,
                        type: type,
                        args: args,
                        traceback: traceback,
                        cause: cause,
                        context: context,
                        suppressContext: suppressContext)
  }

  // Nothing to do here.
  internal func beforeDeinitialize() { }

  internal static func createDebugString(ptr: RawPtr) -> String {
    let zelf = PyStopIteration(ptr: ptr)
    return "PyIsADirectoryError(type: \(zelf.typeName), flags: \(zelf.flags))"
  }

  // sourcery: pyproperty = __class__
  internal static func __class__(_ py: Py, zelf: PyObject) -> PyType {
    return zelf.type
  }

  // sourcery: pyproperty = __dict__
  internal static func __dict__(_ py: Py, zelf: PyObject) -> PyResult<PyObject> {
    guard let zelf = Self.downcast(py, zelf) else {
      return Self.invalidZelfArgument(py, zelf, "__dict__")
    }

    let result = zelf.asBaseException.getDict(py)
    return PyResult(result)
  }

  // sourcery: pystaticmethod = __new__
  internal static func __new__(_ py: Py,
                               type: PyType,
                               args: [PyObject],
                               kwargs: PyDict?) -> PyResult<PyObject> {
    let argsTuple = py.newTuple(elements: args)
    let result = py.memory.newIsADirectoryError(py, type: type, args: argsTuple)
    return PyResult(result)
  }

  // sourcery: pymethod = __init__
  internal static func __init__(_ py: Py,
                                zelf: PyObject,
                                args: [PyObject],
                                kwargs: PyDict?) -> PyResult<PyObject> {
    guard let zelf = Self.downcast(py, zelf) else {
      return Self.invalidZelfArgument(py, zelf, "__init__")
    }

    let zelfAsObject = zelf.asObject
    return PyOSError.__init__(py, zelf: zelfAsObject, args: args, kwargs: kwargs)
  }
}

// MARK: - NotADirectoryError

// sourcery: pyerrortype = NotADirectoryError, pybase = OSError, isDefault, isBaseType, hasGC
// sourcery: isBaseExceptionSubclass, instancesHave__dict__
public struct PyNotADirectoryError: PyErrorMixin {

  // sourcery: pytypedoc
  internal static let doc = "Operation only works on directories."

  public let ptr: RawPtr

  public init(ptr: RawPtr) {
    self.ptr = ptr
  }

  internal func initialize(_ py: Py,
                           type: PyType,
                           args: PyTuple,
                           traceback: PyTraceback? = nil,
                           cause: PyBaseException? = nil,
                           context: PyBaseException? = nil,
                           suppressContext: Bool = PyErrorHeader.defaultSuppressContext) {
    self.initializeBase(py,
                        type: type,
                        args: args,
                        traceback: traceback,
                        cause: cause,
                        context: context,
                        suppressContext: suppressContext)
  }

  // Nothing to do here.
  internal func beforeDeinitialize() { }

  internal static func createDebugString(ptr: RawPtr) -> String {
    let zelf = PyStopIteration(ptr: ptr)
    return "PyNotADirectoryError(type: \(zelf.typeName), flags: \(zelf.flags))"
  }

  // sourcery: pyproperty = __class__
  internal static func __class__(_ py: Py, zelf: PyObject) -> PyType {
    return zelf.type
  }

  // sourcery: pyproperty = __dict__
  internal static func __dict__(_ py: Py, zelf: PyObject) -> PyResult<PyObject> {
    guard let zelf = Self.downcast(py, zelf) else {
      return Self.invalidZelfArgument(py, zelf, "__dict__")
    }

    let result = zelf.asBaseException.getDict(py)
    return PyResult(result)
  }

  // sourcery: pystaticmethod = __new__
  internal static func __new__(_ py: Py,
                               type: PyType,
                               args: [PyObject],
                               kwargs: PyDict?) -> PyResult<PyObject> {
    let argsTuple = py.newTuple(elements: args)
    let result = py.memory.newNotADirectoryError(py, type: type, args: argsTuple)
    return PyResult(result)
  }

  // sourcery: pymethod = __init__
  internal static func __init__(_ py: Py,
                                zelf: PyObject,
                                args: [PyObject],
                                kwargs: PyDict?) -> PyResult<PyObject> {
    guard let zelf = Self.downcast(py, zelf) else {
      return Self.invalidZelfArgument(py, zelf, "__init__")
    }

    let zelfAsObject = zelf.asObject
    return PyOSError.__init__(py, zelf: zelfAsObject, args: args, kwargs: kwargs)
  }
}

// MARK: - PermissionError

// sourcery: pyerrortype = PermissionError, pybase = OSError, isDefault, isBaseType, hasGC
// sourcery: isBaseExceptionSubclass, instancesHave__dict__
public struct PyPermissionError: PyErrorMixin {

  // sourcery: pytypedoc
  internal static let doc = "Not enough permissions."

  public let ptr: RawPtr

  public init(ptr: RawPtr) {
    self.ptr = ptr
  }

  internal func initialize(_ py: Py,
                           type: PyType,
                           args: PyTuple,
                           traceback: PyTraceback? = nil,
                           cause: PyBaseException? = nil,
                           context: PyBaseException? = nil,
                           suppressContext: Bool = PyErrorHeader.defaultSuppressContext) {
    self.initializeBase(py,
                        type: type,
                        args: args,
                        traceback: traceback,
                        cause: cause,
                        context: context,
                        suppressContext: suppressContext)
  }

  // Nothing to do here.
  internal func beforeDeinitialize() { }

  internal static func createDebugString(ptr: RawPtr) -> String {
    let zelf = PyStopIteration(ptr: ptr)
    return "PyPermissionError(type: \(zelf.typeName), flags: \(zelf.flags))"
  }

  // sourcery: pyproperty = __class__
  internal static func __class__(_ py: Py, zelf: PyObject) -> PyType {
    return zelf.type
  }

  // sourcery: pyproperty = __dict__
  internal static func __dict__(_ py: Py, zelf: PyObject) -> PyResult<PyObject> {
    guard let zelf = Self.downcast(py, zelf) else {
      return Self.invalidZelfArgument(py, zelf, "__dict__")
    }

    let result = zelf.asBaseException.getDict(py)
    return PyResult(result)
  }

  // sourcery: pystaticmethod = __new__
  internal static func __new__(_ py: Py,
                               type: PyType,
                               args: [PyObject],
                               kwargs: PyDict?) -> PyResult<PyObject> {
    let argsTuple = py.newTuple(elements: args)
    let result = py.memory.newPermissionError(py, type: type, args: argsTuple)
    return PyResult(result)
  }

  // sourcery: pymethod = __init__
  internal static func __init__(_ py: Py,
                                zelf: PyObject,
                                args: [PyObject],
                                kwargs: PyDict?) -> PyResult<PyObject> {
    guard let zelf = Self.downcast(py, zelf) else {
      return Self.invalidZelfArgument(py, zelf, "__init__")
    }

    let zelfAsObject = zelf.asObject
    return PyOSError.__init__(py, zelf: zelfAsObject, args: args, kwargs: kwargs)
  }
}

// MARK: - ProcessLookupError

// sourcery: pyerrortype = ProcessLookupError, pybase = OSError, isDefault, isBaseType, hasGC
// sourcery: isBaseExceptionSubclass, instancesHave__dict__
public struct PyProcessLookupError: PyErrorMixin {

  // sourcery: pytypedoc
  internal static let doc = "Process not found."

  public let ptr: RawPtr

  public init(ptr: RawPtr) {
    self.ptr = ptr
  }

  internal func initialize(_ py: Py,
                           type: PyType,
                           args: PyTuple,
                           traceback: PyTraceback? = nil,
                           cause: PyBaseException? = nil,
                           context: PyBaseException? = nil,
                           suppressContext: Bool = PyErrorHeader.defaultSuppressContext) {
    self.initializeBase(py,
                        type: type,
                        args: args,
                        traceback: traceback,
                        cause: cause,
                        context: context,
                        suppressContext: suppressContext)
  }

  // Nothing to do here.
  internal func beforeDeinitialize() { }

  internal static func createDebugString(ptr: RawPtr) -> String {
    let zelf = PyStopIteration(ptr: ptr)
    return "PyProcessLookupError(type: \(zelf.typeName), flags: \(zelf.flags))"
  }

  // sourcery: pyproperty = __class__
  internal static func __class__(_ py: Py, zelf: PyObject) -> PyType {
    return zelf.type
  }

  // sourcery: pyproperty = __dict__
  internal static func __dict__(_ py: Py, zelf: PyObject) -> PyResult<PyObject> {
    guard let zelf = Self.downcast(py, zelf) else {
      return Self.invalidZelfArgument(py, zelf, "__dict__")
    }

    let result = zelf.asBaseException.getDict(py)
    return PyResult(result)
  }

  // sourcery: pystaticmethod = __new__
  internal static func __new__(_ py: Py,
                               type: PyType,
                               args: [PyObject],
                               kwargs: PyDict?) -> PyResult<PyObject> {
    let argsTuple = py.newTuple(elements: args)
    let result = py.memory.newProcessLookupError(py, type: type, args: argsTuple)
    return PyResult(result)
  }

  // sourcery: pymethod = __init__
  internal static func __init__(_ py: Py,
                                zelf: PyObject,
                                args: [PyObject],
                                kwargs: PyDict?) -> PyResult<PyObject> {
    guard let zelf = Self.downcast(py, zelf) else {
      return Self.invalidZelfArgument(py, zelf, "__init__")
    }

    let zelfAsObject = zelf.asObject
    return PyOSError.__init__(py, zelf: zelfAsObject, args: args, kwargs: kwargs)
  }
}

// MARK: - TimeoutError

// sourcery: pyerrortype = TimeoutError, pybase = OSError, isDefault, isBaseType, hasGC
// sourcery: isBaseExceptionSubclass, instancesHave__dict__
public struct PyTimeoutError: PyErrorMixin {

  // sourcery: pytypedoc
  internal static let doc = "Timeout expired."

  public let ptr: RawPtr

  public init(ptr: RawPtr) {
    self.ptr = ptr
  }

  internal func initialize(_ py: Py,
                           type: PyType,
                           args: PyTuple,
                           traceback: PyTraceback? = nil,
                           cause: PyBaseException? = nil,
                           context: PyBaseException? = nil,
                           suppressContext: Bool = PyErrorHeader.defaultSuppressContext) {
    self.initializeBase(py,
                        type: type,
                        args: args,
                        traceback: traceback,
                        cause: cause,
                        context: context,
                        suppressContext: suppressContext)
  }

  // Nothing to do here.
  internal func beforeDeinitialize() { }

  internal static func createDebugString(ptr: RawPtr) -> String {
    let zelf = PyStopIteration(ptr: ptr)
    return "PyTimeoutError(type: \(zelf.typeName), flags: \(zelf.flags))"
  }

  // sourcery: pyproperty = __class__
  internal static func __class__(_ py: Py, zelf: PyObject) -> PyType {
    return zelf.type
  }

  // sourcery: pyproperty = __dict__
  internal static func __dict__(_ py: Py, zelf: PyObject) -> PyResult<PyObject> {
    guard let zelf = Self.downcast(py, zelf) else {
      return Self.invalidZelfArgument(py, zelf, "__dict__")
    }

    let result = zelf.asBaseException.getDict(py)
    return PyResult(result)
  }

  // sourcery: pystaticmethod = __new__
  internal static func __new__(_ py: Py,
                               type: PyType,
                               args: [PyObject],
                               kwargs: PyDict?) -> PyResult<PyObject> {
    let argsTuple = py.newTuple(elements: args)
    let result = py.memory.newTimeoutError(py, type: type, args: argsTuple)
    return PyResult(result)
  }

  // sourcery: pymethod = __init__
  internal static func __init__(_ py: Py,
                                zelf: PyObject,
                                args: [PyObject],
                                kwargs: PyDict?) -> PyResult<PyObject> {
    guard let zelf = Self.downcast(py, zelf) else {
      return Self.invalidZelfArgument(py, zelf, "__init__")
    }

    let zelfAsObject = zelf.asObject
    return PyOSError.__init__(py, zelf: zelfAsObject, args: args, kwargs: kwargs)
  }
}

// MARK: - ReferenceError

// sourcery: pyerrortype = ReferenceError, pybase = Exception, isDefault, isBaseType, hasGC
// sourcery: isBaseExceptionSubclass, instancesHave__dict__
public struct PyReferenceError: PyErrorMixin {

  // sourcery: pytypedoc
  internal static let doc = "Weak ref proxy used after referent went away."

  public let ptr: RawPtr

  public init(ptr: RawPtr) {
    self.ptr = ptr
  }

  internal func initialize(_ py: Py,
                           type: PyType,
                           args: PyTuple,
                           traceback: PyTraceback? = nil,
                           cause: PyBaseException? = nil,
                           context: PyBaseException? = nil,
                           suppressContext: Bool = PyErrorHeader.defaultSuppressContext) {
    self.initializeBase(py,
                        type: type,
                        args: args,
                        traceback: traceback,
                        cause: cause,
                        context: context,
                        suppressContext: suppressContext)
  }

  // Nothing to do here.
  internal func beforeDeinitialize() { }

  internal static func createDebugString(ptr: RawPtr) -> String {
    let zelf = PyStopIteration(ptr: ptr)
    return "PyReferenceError(type: \(zelf.typeName), flags: \(zelf.flags))"
  }

  // sourcery: pyproperty = __class__
  internal static func __class__(_ py: Py, zelf: PyObject) -> PyType {
    return zelf.type
  }

  // sourcery: pyproperty = __dict__
  internal static func __dict__(_ py: Py, zelf: PyObject) -> PyResult<PyObject> {
    guard let zelf = Self.downcast(py, zelf) else {
      return Self.invalidZelfArgument(py, zelf, "__dict__")
    }

    let result = zelf.asBaseException.getDict(py)
    return PyResult(result)
  }

  // sourcery: pystaticmethod = __new__
  internal static func __new__(_ py: Py,
                               type: PyType,
                               args: [PyObject],
                               kwargs: PyDict?) -> PyResult<PyObject> {
    let argsTuple = py.newTuple(elements: args)
    let result = py.memory.newReferenceError(py, type: type, args: argsTuple)
    return PyResult(result)
  }

  // sourcery: pymethod = __init__
  internal static func __init__(_ py: Py,
                                zelf: PyObject,
                                args: [PyObject],
                                kwargs: PyDict?) -> PyResult<PyObject> {
    guard let zelf = Self.downcast(py, zelf) else {
      return Self.invalidZelfArgument(py, zelf, "__init__")
    }

    let zelfAsObject = zelf.asObject
    return PyException.__init__(py, zelf: zelfAsObject, args: args, kwargs: kwargs)
  }
}

// MARK: - RuntimeError

// sourcery: pyerrortype = RuntimeError, pybase = Exception, isDefault, isBaseType, hasGC
// sourcery: isBaseExceptionSubclass, instancesHave__dict__
public struct PyRuntimeError: PyErrorMixin {

  // sourcery: pytypedoc
  internal static let doc = "Unspecified run-time error."

  public let ptr: RawPtr

  public init(ptr: RawPtr) {
    self.ptr = ptr
  }

  internal func initialize(_ py: Py,
                           type: PyType,
                           args: PyTuple,
                           traceback: PyTraceback? = nil,
                           cause: PyBaseException? = nil,
                           context: PyBaseException? = nil,
                           suppressContext: Bool = PyErrorHeader.defaultSuppressContext) {
    self.initializeBase(py,
                        type: type,
                        args: args,
                        traceback: traceback,
                        cause: cause,
                        context: context,
                        suppressContext: suppressContext)
  }

  // Nothing to do here.
  internal func beforeDeinitialize() { }

  internal static func createDebugString(ptr: RawPtr) -> String {
    let zelf = PyStopIteration(ptr: ptr)
    return "PyRuntimeError(type: \(zelf.typeName), flags: \(zelf.flags))"
  }

  // sourcery: pyproperty = __class__
  internal static func __class__(_ py: Py, zelf: PyObject) -> PyType {
    return zelf.type
  }

  // sourcery: pyproperty = __dict__
  internal static func __dict__(_ py: Py, zelf: PyObject) -> PyResult<PyObject> {
    guard let zelf = Self.downcast(py, zelf) else {
      return Self.invalidZelfArgument(py, zelf, "__dict__")
    }

    let result = zelf.asBaseException.getDict(py)
    return PyResult(result)
  }

  // sourcery: pystaticmethod = __new__
  internal static func __new__(_ py: Py,
                               type: PyType,
                               args: [PyObject],
                               kwargs: PyDict?) -> PyResult<PyObject> {
    let argsTuple = py.newTuple(elements: args)
    let result = py.memory.newRuntimeError(py, type: type, args: argsTuple)
    return PyResult(result)
  }

  // sourcery: pymethod = __init__
  internal static func __init__(_ py: Py,
                                zelf: PyObject,
                                args: [PyObject],
                                kwargs: PyDict?) -> PyResult<PyObject> {
    guard let zelf = Self.downcast(py, zelf) else {
      return Self.invalidZelfArgument(py, zelf, "__init__")
    }

    let zelfAsObject = zelf.asObject
    return PyException.__init__(py, zelf: zelfAsObject, args: args, kwargs: kwargs)
  }
}

// MARK: - NotImplementedError

// sourcery: pyerrortype = NotImplementedError, pybase = RuntimeError, isDefault, isBaseType, hasGC
// sourcery: isBaseExceptionSubclass, instancesHave__dict__
public struct PyNotImplementedError: PyErrorMixin {

  // sourcery: pytypedoc
  internal static let doc = "Method or function hasn't been implemented yet."

  public let ptr: RawPtr

  public init(ptr: RawPtr) {
    self.ptr = ptr
  }

  internal func initialize(_ py: Py,
                           type: PyType,
                           args: PyTuple,
                           traceback: PyTraceback? = nil,
                           cause: PyBaseException? = nil,
                           context: PyBaseException? = nil,
                           suppressContext: Bool = PyErrorHeader.defaultSuppressContext) {
    self.initializeBase(py,
                        type: type,
                        args: args,
                        traceback: traceback,
                        cause: cause,
                        context: context,
                        suppressContext: suppressContext)
  }

  // Nothing to do here.
  internal func beforeDeinitialize() { }

  internal static func createDebugString(ptr: RawPtr) -> String {
    let zelf = PyStopIteration(ptr: ptr)
    return "PyNotImplementedError(type: \(zelf.typeName), flags: \(zelf.flags))"
  }

  // sourcery: pyproperty = __class__
  internal static func __class__(_ py: Py, zelf: PyObject) -> PyType {
    return zelf.type
  }

  // sourcery: pyproperty = __dict__
  internal static func __dict__(_ py: Py, zelf: PyObject) -> PyResult<PyObject> {
    guard let zelf = Self.downcast(py, zelf) else {
      return Self.invalidZelfArgument(py, zelf, "__dict__")
    }

    let result = zelf.asBaseException.getDict(py)
    return PyResult(result)
  }

  // sourcery: pystaticmethod = __new__
  internal static func __new__(_ py: Py,
                               type: PyType,
                               args: [PyObject],
                               kwargs: PyDict?) -> PyResult<PyObject> {
    let argsTuple = py.newTuple(elements: args)
    let result = py.memory.newNotImplementedError(py, type: type, args: argsTuple)
    return PyResult(result)
  }

  // sourcery: pymethod = __init__
  internal static func __init__(_ py: Py,
                                zelf: PyObject,
                                args: [PyObject],
                                kwargs: PyDict?) -> PyResult<PyObject> {
    guard let zelf = Self.downcast(py, zelf) else {
      return Self.invalidZelfArgument(py, zelf, "__init__")
    }

    let zelfAsObject = zelf.asObject
    return PyRuntimeError.__init__(py, zelf: zelfAsObject, args: args, kwargs: kwargs)
  }
}

// MARK: - RecursionError

// sourcery: pyerrortype = RecursionError, pybase = RuntimeError, isDefault, isBaseType, hasGC
// sourcery: isBaseExceptionSubclass, instancesHave__dict__
public struct PyRecursionError: PyErrorMixin {

  // sourcery: pytypedoc
  internal static let doc = "Recursion limit exceeded."

  public let ptr: RawPtr

  public init(ptr: RawPtr) {
    self.ptr = ptr
  }

  internal func initialize(_ py: Py,
                           type: PyType,
                           args: PyTuple,
                           traceback: PyTraceback? = nil,
                           cause: PyBaseException? = nil,
                           context: PyBaseException? = nil,
                           suppressContext: Bool = PyErrorHeader.defaultSuppressContext) {
    self.initializeBase(py,
                        type: type,
                        args: args,
                        traceback: traceback,
                        cause: cause,
                        context: context,
                        suppressContext: suppressContext)
  }

  // Nothing to do here.
  internal func beforeDeinitialize() { }

  internal static func createDebugString(ptr: RawPtr) -> String {
    let zelf = PyStopIteration(ptr: ptr)
    return "PyRecursionError(type: \(zelf.typeName), flags: \(zelf.flags))"
  }

  // sourcery: pyproperty = __class__
  internal static func __class__(_ py: Py, zelf: PyObject) -> PyType {
    return zelf.type
  }

  // sourcery: pyproperty = __dict__
  internal static func __dict__(_ py: Py, zelf: PyObject) -> PyResult<PyObject> {
    guard let zelf = Self.downcast(py, zelf) else {
      return Self.invalidZelfArgument(py, zelf, "__dict__")
    }

    let result = zelf.asBaseException.getDict(py)
    return PyResult(result)
  }

  // sourcery: pystaticmethod = __new__
  internal static func __new__(_ py: Py,
                               type: PyType,
                               args: [PyObject],
                               kwargs: PyDict?) -> PyResult<PyObject> {
    let argsTuple = py.newTuple(elements: args)
    let result = py.memory.newRecursionError(py, type: type, args: argsTuple)
    return PyResult(result)
  }

  // sourcery: pymethod = __init__
  internal static func __init__(_ py: Py,
                                zelf: PyObject,
                                args: [PyObject],
                                kwargs: PyDict?) -> PyResult<PyObject> {
    guard let zelf = Self.downcast(py, zelf) else {
      return Self.invalidZelfArgument(py, zelf, "__init__")
    }

    let zelfAsObject = zelf.asObject
    return PyRuntimeError.__init__(py, zelf: zelfAsObject, args: args, kwargs: kwargs)
  }
}

// MARK: - IndentationError

// sourcery: pyerrortype = IndentationError, pybase = SyntaxError, isDefault, isBaseType, hasGC
// sourcery: isBaseExceptionSubclass, instancesHave__dict__
public struct PyIndentationError: PyErrorMixin {

  // sourcery: pytypedoc
  internal static let doc = "Improper indentation."

  public let ptr: RawPtr

  public init(ptr: RawPtr) {
    self.ptr = ptr
  }

  internal func initialize(_ py: Py,
                           type: PyType,
                           msg: PyObject?,
                           filename: PyObject?,
                           lineno: PyObject?,
                           offset: PyObject?,
                           text: PyObject?,
                           printFileAndLine: PyObject?,
                           traceback: PyTraceback? = nil,
                           cause: PyBaseException? = nil,
                           context: PyBaseException? = nil,
                           suppressContext: Bool = PyErrorHeader.defaultSuppressContext) {
    self.initializeBase(py,
                        type: type,
                        msg: msg,
                        filename: filename,
                        lineno: lineno,
                        offset: offset,
                        text: text,
                        printFileAndLine: printFileAndLine,
                        traceback: traceback,
                        cause: cause,
                        context: context,
                        suppressContext: suppressContext)
  }

  internal func initialize(_ py: Py,
                           type: PyType,
                           args: PyTuple,
                           traceback: PyTraceback? = nil,
                           cause: PyBaseException? = nil,
                           context: PyBaseException? = nil,
                           suppressContext: Bool = PyErrorHeader.defaultSuppressContext) {
    self.initializeBase(py,
                        type: type,
                        args: args,
                        traceback: traceback,
                        cause: cause,
                        context: context,
                        suppressContext: suppressContext)
  }

  // Nothing to do here.
  internal func beforeDeinitialize() { }

  internal static func createDebugString(ptr: RawPtr) -> String {
    let zelf = PyStopIteration(ptr: ptr)
    return "PyIndentationError(type: \(zelf.typeName), flags: \(zelf.flags))"
  }

  // sourcery: pyproperty = __class__
  internal static func __class__(_ py: Py, zelf: PyObject) -> PyType {
    return zelf.type
  }

  // sourcery: pyproperty = __dict__
  internal static func __dict__(_ py: Py, zelf: PyObject) -> PyResult<PyObject> {
    guard let zelf = Self.downcast(py, zelf) else {
      return Self.invalidZelfArgument(py, zelf, "__dict__")
    }

    let result = zelf.asBaseException.getDict(py)
    return PyResult(result)
  }

  // sourcery: pystaticmethod = __new__
  internal static func __new__(_ py: Py,
                               type: PyType,
                               args: [PyObject],
                               kwargs: PyDict?) -> PyResult<PyObject> {
    let argsTuple = py.newTuple(elements: args)
    let result = py.memory.newIndentationError(py, type: type, args: argsTuple)
    return PyResult(result)
  }

  // sourcery: pymethod = __init__
  internal static func __init__(_ py: Py,
                                zelf: PyObject,
                                args: [PyObject],
                                kwargs: PyDict?) -> PyResult<PyObject> {
    guard let zelf = Self.downcast(py, zelf) else {
      return Self.invalidZelfArgument(py, zelf, "__init__")
    }

    let zelfAsObject = zelf.asObject
    return PySyntaxError.__init__(py, zelf: zelfAsObject, args: args, kwargs: kwargs)
  }
}

// MARK: - TabError

// sourcery: pyerrortype = TabError, pybase = IndentationError, isDefault, isBaseType, hasGC
// sourcery: isBaseExceptionSubclass, instancesHave__dict__
public struct PyTabError: PyErrorMixin {

  // sourcery: pytypedoc
  internal static let doc = "Improper mixture of spaces and tabs."

  public let ptr: RawPtr

  public init(ptr: RawPtr) {
    self.ptr = ptr
  }

  internal func initialize(_ py: Py,
                           type: PyType,
                           msg: PyObject?,
                           filename: PyObject?,
                           lineno: PyObject?,
                           offset: PyObject?,
                           text: PyObject?,
                           printFileAndLine: PyObject?,
                           traceback: PyTraceback? = nil,
                           cause: PyBaseException? = nil,
                           context: PyBaseException? = nil,
                           suppressContext: Bool = PyErrorHeader.defaultSuppressContext) {
    self.initializeBase(py,
                        type: type,
                        msg: msg,
                        filename: filename,
                        lineno: lineno,
                        offset: offset,
                        text: text,
                        printFileAndLine: printFileAndLine,
                        traceback: traceback,
                        cause: cause,
                        context: context,
                        suppressContext: suppressContext)
  }

  internal func initialize(_ py: Py,
                           type: PyType,
                           args: PyTuple,
                           traceback: PyTraceback? = nil,
                           cause: PyBaseException? = nil,
                           context: PyBaseException? = nil,
                           suppressContext: Bool = PyErrorHeader.defaultSuppressContext) {
    self.initializeBase(py,
                        type: type,
                        args: args,
                        traceback: traceback,
                        cause: cause,
                        context: context,
                        suppressContext: suppressContext)
  }

  // Nothing to do here.
  internal func beforeDeinitialize() { }

  internal static func createDebugString(ptr: RawPtr) -> String {
    let zelf = PyStopIteration(ptr: ptr)
    return "PyTabError(type: \(zelf.typeName), flags: \(zelf.flags))"
  }

  // sourcery: pyproperty = __class__
  internal static func __class__(_ py: Py, zelf: PyObject) -> PyType {
    return zelf.type
  }

  // sourcery: pyproperty = __dict__
  internal static func __dict__(_ py: Py, zelf: PyObject) -> PyResult<PyObject> {
    guard let zelf = Self.downcast(py, zelf) else {
      return Self.invalidZelfArgument(py, zelf, "__dict__")
    }

    let result = zelf.asBaseException.getDict(py)
    return PyResult(result)
  }

  // sourcery: pystaticmethod = __new__
  internal static func __new__(_ py: Py,
                               type: PyType,
                               args: [PyObject],
                               kwargs: PyDict?) -> PyResult<PyObject> {
    let argsTuple = py.newTuple(elements: args)
    let result = py.memory.newTabError(py, type: type, args: argsTuple)
    return PyResult(result)
  }

  // sourcery: pymethod = __init__
  internal static func __init__(_ py: Py,
                                zelf: PyObject,
                                args: [PyObject],
                                kwargs: PyDict?) -> PyResult<PyObject> {
    guard let zelf = Self.downcast(py, zelf) else {
      return Self.invalidZelfArgument(py, zelf, "__init__")
    }

    let zelfAsObject = zelf.asObject
    return PyIndentationError.__init__(py, zelf: zelfAsObject, args: args, kwargs: kwargs)
  }
}

// MARK: - SystemError

// sourcery: pyerrortype = SystemError, pybase = Exception, isDefault, isBaseType, hasGC
// sourcery: isBaseExceptionSubclass, instancesHave__dict__
public struct PySystemError: PyErrorMixin {

  // sourcery: pytypedoc
  internal static let doc = "Internal error in the Python interpreter.\n" +
"\n" +
"Please report this to the Python maintainer, along with the traceback,\n" +
"the Python version, and the hardware/OS platform and version."

  public let ptr: RawPtr

  public init(ptr: RawPtr) {
    self.ptr = ptr
  }

  internal func initialize(_ py: Py,
                           type: PyType,
                           args: PyTuple,
                           traceback: PyTraceback? = nil,
                           cause: PyBaseException? = nil,
                           context: PyBaseException? = nil,
                           suppressContext: Bool = PyErrorHeader.defaultSuppressContext) {
    self.initializeBase(py,
                        type: type,
                        args: args,
                        traceback: traceback,
                        cause: cause,
                        context: context,
                        suppressContext: suppressContext)
  }

  // Nothing to do here.
  internal func beforeDeinitialize() { }

  internal static func createDebugString(ptr: RawPtr) -> String {
    let zelf = PyStopIteration(ptr: ptr)
    return "PySystemError(type: \(zelf.typeName), flags: \(zelf.flags))"
  }

  // sourcery: pyproperty = __class__
  internal static func __class__(_ py: Py, zelf: PyObject) -> PyType {
    return zelf.type
  }

  // sourcery: pyproperty = __dict__
  internal static func __dict__(_ py: Py, zelf: PyObject) -> PyResult<PyObject> {
    guard let zelf = Self.downcast(py, zelf) else {
      return Self.invalidZelfArgument(py, zelf, "__dict__")
    }

    let result = zelf.asBaseException.getDict(py)
    return PyResult(result)
  }

  // sourcery: pystaticmethod = __new__
  internal static func __new__(_ py: Py,
                               type: PyType,
                               args: [PyObject],
                               kwargs: PyDict?) -> PyResult<PyObject> {
    let argsTuple = py.newTuple(elements: args)
    let result = py.memory.newSystemError(py, type: type, args: argsTuple)
    return PyResult(result)
  }

  // sourcery: pymethod = __init__
  internal static func __init__(_ py: Py,
                                zelf: PyObject,
                                args: [PyObject],
                                kwargs: PyDict?) -> PyResult<PyObject> {
    guard let zelf = Self.downcast(py, zelf) else {
      return Self.invalidZelfArgument(py, zelf, "__init__")
    }

    let zelfAsObject = zelf.asObject
    return PyException.__init__(py, zelf: zelfAsObject, args: args, kwargs: kwargs)
  }
}

// MARK: - TypeError

// sourcery: pyerrortype = TypeError, pybase = Exception, isDefault, isBaseType, hasGC
// sourcery: isBaseExceptionSubclass, instancesHave__dict__
public struct PyTypeError: PyErrorMixin {

  // sourcery: pytypedoc
  internal static let doc = "Inappropriate argument type."

  public let ptr: RawPtr

  public init(ptr: RawPtr) {
    self.ptr = ptr
  }

  internal func initialize(_ py: Py,
                           type: PyType,
                           args: PyTuple,
                           traceback: PyTraceback? = nil,
                           cause: PyBaseException? = nil,
                           context: PyBaseException? = nil,
                           suppressContext: Bool = PyErrorHeader.defaultSuppressContext) {
    self.initializeBase(py,
                        type: type,
                        args: args,
                        traceback: traceback,
                        cause: cause,
                        context: context,
                        suppressContext: suppressContext)
  }

  // Nothing to do here.
  internal func beforeDeinitialize() { }

  internal static func createDebugString(ptr: RawPtr) -> String {
    let zelf = PyStopIteration(ptr: ptr)
    return "PyTypeError(type: \(zelf.typeName), flags: \(zelf.flags))"
  }

  // sourcery: pyproperty = __class__
  internal static func __class__(_ py: Py, zelf: PyObject) -> PyType {
    return zelf.type
  }

  // sourcery: pyproperty = __dict__
  internal static func __dict__(_ py: Py, zelf: PyObject) -> PyResult<PyObject> {
    guard let zelf = Self.downcast(py, zelf) else {
      return Self.invalidZelfArgument(py, zelf, "__dict__")
    }

    let result = zelf.asBaseException.getDict(py)
    return PyResult(result)
  }

  // sourcery: pystaticmethod = __new__
  internal static func __new__(_ py: Py,
                               type: PyType,
                               args: [PyObject],
                               kwargs: PyDict?) -> PyResult<PyObject> {
    let argsTuple = py.newTuple(elements: args)
    let result = py.memory.newTypeError(py, type: type, args: argsTuple)
    return PyResult(result)
  }

  // sourcery: pymethod = __init__
  internal static func __init__(_ py: Py,
                                zelf: PyObject,
                                args: [PyObject],
                                kwargs: PyDict?) -> PyResult<PyObject> {
    guard let zelf = Self.downcast(py, zelf) else {
      return Self.invalidZelfArgument(py, zelf, "__init__")
    }

    let zelfAsObject = zelf.asObject
    return PyException.__init__(py, zelf: zelfAsObject, args: args, kwargs: kwargs)
  }
}

// MARK: - ValueError

// sourcery: pyerrortype = ValueError, pybase = Exception, isDefault, isBaseType, hasGC
// sourcery: isBaseExceptionSubclass, instancesHave__dict__
public struct PyValueError: PyErrorMixin {

  // sourcery: pytypedoc
  internal static let doc = "Inappropriate argument value (of correct type)."

  public let ptr: RawPtr

  public init(ptr: RawPtr) {
    self.ptr = ptr
  }

  internal func initialize(_ py: Py,
                           type: PyType,
                           args: PyTuple,
                           traceback: PyTraceback? = nil,
                           cause: PyBaseException? = nil,
                           context: PyBaseException? = nil,
                           suppressContext: Bool = PyErrorHeader.defaultSuppressContext) {
    self.initializeBase(py,
                        type: type,
                        args: args,
                        traceback: traceback,
                        cause: cause,
                        context: context,
                        suppressContext: suppressContext)
  }

  // Nothing to do here.
  internal func beforeDeinitialize() { }

  internal static func createDebugString(ptr: RawPtr) -> String {
    let zelf = PyStopIteration(ptr: ptr)
    return "PyValueError(type: \(zelf.typeName), flags: \(zelf.flags))"
  }

  // sourcery: pyproperty = __class__
  internal static func __class__(_ py: Py, zelf: PyObject) -> PyType {
    return zelf.type
  }

  // sourcery: pyproperty = __dict__
  internal static func __dict__(_ py: Py, zelf: PyObject) -> PyResult<PyObject> {
    guard let zelf = Self.downcast(py, zelf) else {
      return Self.invalidZelfArgument(py, zelf, "__dict__")
    }

    let result = zelf.asBaseException.getDict(py)
    return PyResult(result)
  }

  // sourcery: pystaticmethod = __new__
  internal static func __new__(_ py: Py,
                               type: PyType,
                               args: [PyObject],
                               kwargs: PyDict?) -> PyResult<PyObject> {
    let argsTuple = py.newTuple(elements: args)
    let result = py.memory.newValueError(py, type: type, args: argsTuple)
    return PyResult(result)
  }

  // sourcery: pymethod = __init__
  internal static func __init__(_ py: Py,
                                zelf: PyObject,
                                args: [PyObject],
                                kwargs: PyDict?) -> PyResult<PyObject> {
    guard let zelf = Self.downcast(py, zelf) else {
      return Self.invalidZelfArgument(py, zelf, "__init__")
    }

    let zelfAsObject = zelf.asObject
    return PyException.__init__(py, zelf: zelfAsObject, args: args, kwargs: kwargs)
  }
}

// MARK: - UnicodeError

// sourcery: pyerrortype = UnicodeError, pybase = ValueError, isDefault, isBaseType, hasGC
// sourcery: isBaseExceptionSubclass, instancesHave__dict__
public struct PyUnicodeError: PyErrorMixin {

  // sourcery: pytypedoc
  internal static let doc = "Unicode related error."

  public let ptr: RawPtr

  public init(ptr: RawPtr) {
    self.ptr = ptr
  }

  internal func initialize(_ py: Py,
                           type: PyType,
                           args: PyTuple,
                           traceback: PyTraceback? = nil,
                           cause: PyBaseException? = nil,
                           context: PyBaseException? = nil,
                           suppressContext: Bool = PyErrorHeader.defaultSuppressContext) {
    self.initializeBase(py,
                        type: type,
                        args: args,
                        traceback: traceback,
                        cause: cause,
                        context: context,
                        suppressContext: suppressContext)
  }

  // Nothing to do here.
  internal func beforeDeinitialize() { }

  internal static func createDebugString(ptr: RawPtr) -> String {
    let zelf = PyStopIteration(ptr: ptr)
    return "PyUnicodeError(type: \(zelf.typeName), flags: \(zelf.flags))"
  }

  // sourcery: pyproperty = __class__
  internal static func __class__(_ py: Py, zelf: PyObject) -> PyType {
    return zelf.type
  }

  // sourcery: pyproperty = __dict__
  internal static func __dict__(_ py: Py, zelf: PyObject) -> PyResult<PyObject> {
    guard let zelf = Self.downcast(py, zelf) else {
      return Self.invalidZelfArgument(py, zelf, "__dict__")
    }

    let result = zelf.asBaseException.getDict(py)
    return PyResult(result)
  }

  // sourcery: pystaticmethod = __new__
  internal static func __new__(_ py: Py,
                               type: PyType,
                               args: [PyObject],
                               kwargs: PyDict?) -> PyResult<PyObject> {
    let argsTuple = py.newTuple(elements: args)
    let result = py.memory.newUnicodeError(py, type: type, args: argsTuple)
    return PyResult(result)
  }

  // sourcery: pymethod = __init__
  internal static func __init__(_ py: Py,
                                zelf: PyObject,
                                args: [PyObject],
                                kwargs: PyDict?) -> PyResult<PyObject> {
    guard let zelf = Self.downcast(py, zelf) else {
      return Self.invalidZelfArgument(py, zelf, "__init__")
    }

    let zelfAsObject = zelf.asObject
    return PyValueError.__init__(py, zelf: zelfAsObject, args: args, kwargs: kwargs)
  }
}

// MARK: - UnicodeDecodeError

// sourcery: pyerrortype = UnicodeDecodeError, pybase = UnicodeError, isDefault, isBaseType, hasGC
// sourcery: isBaseExceptionSubclass, instancesHave__dict__
public struct PyUnicodeDecodeError: PyErrorMixin {

  // sourcery: pytypedoc
  internal static let doc = "Unicode decoding error."

  public let ptr: RawPtr

  public init(ptr: RawPtr) {
    self.ptr = ptr
  }

  internal func initialize(_ py: Py,
                           type: PyType,
                           args: PyTuple,
                           traceback: PyTraceback? = nil,
                           cause: PyBaseException? = nil,
                           context: PyBaseException? = nil,
                           suppressContext: Bool = PyErrorHeader.defaultSuppressContext) {
    self.initializeBase(py,
                        type: type,
                        args: args,
                        traceback: traceback,
                        cause: cause,
                        context: context,
                        suppressContext: suppressContext)
  }

  // Nothing to do here.
  internal func beforeDeinitialize() { }

  internal static func createDebugString(ptr: RawPtr) -> String {
    let zelf = PyStopIteration(ptr: ptr)
    return "PyUnicodeDecodeError(type: \(zelf.typeName), flags: \(zelf.flags))"
  }

  // sourcery: pyproperty = __class__
  internal static func __class__(_ py: Py, zelf: PyObject) -> PyType {
    return zelf.type
  }

  // sourcery: pyproperty = __dict__
  internal static func __dict__(_ py: Py, zelf: PyObject) -> PyResult<PyObject> {
    guard let zelf = Self.downcast(py, zelf) else {
      return Self.invalidZelfArgument(py, zelf, "__dict__")
    }

    let result = zelf.asBaseException.getDict(py)
    return PyResult(result)
  }

  // sourcery: pystaticmethod = __new__
  internal static func __new__(_ py: Py,
                               type: PyType,
                               args: [PyObject],
                               kwargs: PyDict?) -> PyResult<PyObject> {
    let argsTuple = py.newTuple(elements: args)
    let result = py.memory.newUnicodeDecodeError(py, type: type, args: argsTuple)
    return PyResult(result)
  }

  // sourcery: pymethod = __init__
  internal static func __init__(_ py: Py,
                                zelf: PyObject,
                                args: [PyObject],
                                kwargs: PyDict?) -> PyResult<PyObject> {
    guard let zelf = Self.downcast(py, zelf) else {
      return Self.invalidZelfArgument(py, zelf, "__init__")
    }

    let zelfAsObject = zelf.asObject
    return PyUnicodeError.__init__(py, zelf: zelfAsObject, args: args, kwargs: kwargs)
  }
}

// MARK: - UnicodeEncodeError

// sourcery: pyerrortype = UnicodeEncodeError, pybase = UnicodeError, isDefault, isBaseType, hasGC
// sourcery: isBaseExceptionSubclass, instancesHave__dict__
public struct PyUnicodeEncodeError: PyErrorMixin {

  // sourcery: pytypedoc
  internal static let doc = "Unicode encoding error."

  public let ptr: RawPtr

  public init(ptr: RawPtr) {
    self.ptr = ptr
  }

  internal func initialize(_ py: Py,
                           type: PyType,
                           args: PyTuple,
                           traceback: PyTraceback? = nil,
                           cause: PyBaseException? = nil,
                           context: PyBaseException? = nil,
                           suppressContext: Bool = PyErrorHeader.defaultSuppressContext) {
    self.initializeBase(py,
                        type: type,
                        args: args,
                        traceback: traceback,
                        cause: cause,
                        context: context,
                        suppressContext: suppressContext)
  }

  // Nothing to do here.
  internal func beforeDeinitialize() { }

  internal static func createDebugString(ptr: RawPtr) -> String {
    let zelf = PyStopIteration(ptr: ptr)
    return "PyUnicodeEncodeError(type: \(zelf.typeName), flags: \(zelf.flags))"
  }

  // sourcery: pyproperty = __class__
  internal static func __class__(_ py: Py, zelf: PyObject) -> PyType {
    return zelf.type
  }

  // sourcery: pyproperty = __dict__
  internal static func __dict__(_ py: Py, zelf: PyObject) -> PyResult<PyObject> {
    guard let zelf = Self.downcast(py, zelf) else {
      return Self.invalidZelfArgument(py, zelf, "__dict__")
    }

    let result = zelf.asBaseException.getDict(py)
    return PyResult(result)
  }

  // sourcery: pystaticmethod = __new__
  internal static func __new__(_ py: Py,
                               type: PyType,
                               args: [PyObject],
                               kwargs: PyDict?) -> PyResult<PyObject> {
    let argsTuple = py.newTuple(elements: args)
    let result = py.memory.newUnicodeEncodeError(py, type: type, args: argsTuple)
    return PyResult(result)
  }

  // sourcery: pymethod = __init__
  internal static func __init__(_ py: Py,
                                zelf: PyObject,
                                args: [PyObject],
                                kwargs: PyDict?) -> PyResult<PyObject> {
    guard let zelf = Self.downcast(py, zelf) else {
      return Self.invalidZelfArgument(py, zelf, "__init__")
    }

    let zelfAsObject = zelf.asObject
    return PyUnicodeError.__init__(py, zelf: zelfAsObject, args: args, kwargs: kwargs)
  }
}

// MARK: - UnicodeTranslateError

// sourcery: pyerrortype = UnicodeTranslateError, pybase = UnicodeError, isDefault, isBaseType, hasGC
// sourcery: isBaseExceptionSubclass, instancesHave__dict__
public struct PyUnicodeTranslateError: PyErrorMixin {

  // sourcery: pytypedoc
  internal static let doc = "Unicode translation error."

  public let ptr: RawPtr

  public init(ptr: RawPtr) {
    self.ptr = ptr
  }

  internal func initialize(_ py: Py,
                           type: PyType,
                           args: PyTuple,
                           traceback: PyTraceback? = nil,
                           cause: PyBaseException? = nil,
                           context: PyBaseException? = nil,
                           suppressContext: Bool = PyErrorHeader.defaultSuppressContext) {
    self.initializeBase(py,
                        type: type,
                        args: args,
                        traceback: traceback,
                        cause: cause,
                        context: context,
                        suppressContext: suppressContext)
  }

  // Nothing to do here.
  internal func beforeDeinitialize() { }

  internal static func createDebugString(ptr: RawPtr) -> String {
    let zelf = PyStopIteration(ptr: ptr)
    return "PyUnicodeTranslateError(type: \(zelf.typeName), flags: \(zelf.flags))"
  }

  // sourcery: pyproperty = __class__
  internal static func __class__(_ py: Py, zelf: PyObject) -> PyType {
    return zelf.type
  }

  // sourcery: pyproperty = __dict__
  internal static func __dict__(_ py: Py, zelf: PyObject) -> PyResult<PyObject> {
    guard let zelf = Self.downcast(py, zelf) else {
      return Self.invalidZelfArgument(py, zelf, "__dict__")
    }

    let result = zelf.asBaseException.getDict(py)
    return PyResult(result)
  }

  // sourcery: pystaticmethod = __new__
  internal static func __new__(_ py: Py,
                               type: PyType,
                               args: [PyObject],
                               kwargs: PyDict?) -> PyResult<PyObject> {
    let argsTuple = py.newTuple(elements: args)
    let result = py.memory.newUnicodeTranslateError(py, type: type, args: argsTuple)
    return PyResult(result)
  }

  // sourcery: pymethod = __init__
  internal static func __init__(_ py: Py,
                                zelf: PyObject,
                                args: [PyObject],
                                kwargs: PyDict?) -> PyResult<PyObject> {
    guard let zelf = Self.downcast(py, zelf) else {
      return Self.invalidZelfArgument(py, zelf, "__init__")
    }

    let zelfAsObject = zelf.asObject
    return PyUnicodeError.__init__(py, zelf: zelfAsObject, args: args, kwargs: kwargs)
  }
}

// MARK: - Warning

// sourcery: pyerrortype = Warning, pybase = Exception, isDefault, isBaseType, hasGC
// sourcery: isBaseExceptionSubclass, instancesHave__dict__
public struct PyWarning: PyErrorMixin {

  // sourcery: pytypedoc
  internal static let doc = "Base class for warning categories."

  public let ptr: RawPtr

  public init(ptr: RawPtr) {
    self.ptr = ptr
  }

  internal func initialize(_ py: Py,
                           type: PyType,
                           args: PyTuple,
                           traceback: PyTraceback? = nil,
                           cause: PyBaseException? = nil,
                           context: PyBaseException? = nil,
                           suppressContext: Bool = PyErrorHeader.defaultSuppressContext) {
    self.initializeBase(py,
                        type: type,
                        args: args,
                        traceback: traceback,
                        cause: cause,
                        context: context,
                        suppressContext: suppressContext)
  }

  // Nothing to do here.
  internal func beforeDeinitialize() { }

  internal static func createDebugString(ptr: RawPtr) -> String {
    let zelf = PyStopIteration(ptr: ptr)
    return "PyWarning(type: \(zelf.typeName), flags: \(zelf.flags))"
  }

  // sourcery: pyproperty = __class__
  internal static func __class__(_ py: Py, zelf: PyObject) -> PyType {
    return zelf.type
  }

  // sourcery: pyproperty = __dict__
  internal static func __dict__(_ py: Py, zelf: PyObject) -> PyResult<PyObject> {
    guard let zelf = Self.downcast(py, zelf) else {
      return Self.invalidZelfArgument(py, zelf, "__dict__")
    }

    let result = zelf.asBaseException.getDict(py)
    return PyResult(result)
  }

  // sourcery: pystaticmethod = __new__
  internal static func __new__(_ py: Py,
                               type: PyType,
                               args: [PyObject],
                               kwargs: PyDict?) -> PyResult<PyObject> {
    let argsTuple = py.newTuple(elements: args)
    let result = py.memory.newWarning(py, type: type, args: argsTuple)
    return PyResult(result)
  }

  // sourcery: pymethod = __init__
  internal static func __init__(_ py: Py,
                                zelf: PyObject,
                                args: [PyObject],
                                kwargs: PyDict?) -> PyResult<PyObject> {
    guard let zelf = Self.downcast(py, zelf) else {
      return Self.invalidZelfArgument(py, zelf, "__init__")
    }

    let zelfAsObject = zelf.asObject
    return PyException.__init__(py, zelf: zelfAsObject, args: args, kwargs: kwargs)
  }
}

// MARK: - DeprecationWarning

// sourcery: pyerrortype = DeprecationWarning, pybase = Warning, isDefault, isBaseType, hasGC
// sourcery: isBaseExceptionSubclass, instancesHave__dict__
public struct PyDeprecationWarning: PyErrorMixin {

  // sourcery: pytypedoc
  internal static let doc = "Base class for warnings about deprecated features."

  public let ptr: RawPtr

  public init(ptr: RawPtr) {
    self.ptr = ptr
  }

  internal func initialize(_ py: Py,
                           type: PyType,
                           args: PyTuple,
                           traceback: PyTraceback? = nil,
                           cause: PyBaseException? = nil,
                           context: PyBaseException? = nil,
                           suppressContext: Bool = PyErrorHeader.defaultSuppressContext) {
    self.initializeBase(py,
                        type: type,
                        args: args,
                        traceback: traceback,
                        cause: cause,
                        context: context,
                        suppressContext: suppressContext)
  }

  // Nothing to do here.
  internal func beforeDeinitialize() { }

  internal static func createDebugString(ptr: RawPtr) -> String {
    let zelf = PyStopIteration(ptr: ptr)
    return "PyDeprecationWarning(type: \(zelf.typeName), flags: \(zelf.flags))"
  }

  // sourcery: pyproperty = __class__
  internal static func __class__(_ py: Py, zelf: PyObject) -> PyType {
    return zelf.type
  }

  // sourcery: pyproperty = __dict__
  internal static func __dict__(_ py: Py, zelf: PyObject) -> PyResult<PyObject> {
    guard let zelf = Self.downcast(py, zelf) else {
      return Self.invalidZelfArgument(py, zelf, "__dict__")
    }

    let result = zelf.asBaseException.getDict(py)
    return PyResult(result)
  }

  // sourcery: pystaticmethod = __new__
  internal static func __new__(_ py: Py,
                               type: PyType,
                               args: [PyObject],
                               kwargs: PyDict?) -> PyResult<PyObject> {
    let argsTuple = py.newTuple(elements: args)
    let result = py.memory.newDeprecationWarning(py, type: type, args: argsTuple)
    return PyResult(result)
  }

  // sourcery: pymethod = __init__
  internal static func __init__(_ py: Py,
                                zelf: PyObject,
                                args: [PyObject],
                                kwargs: PyDict?) -> PyResult<PyObject> {
    guard let zelf = Self.downcast(py, zelf) else {
      return Self.invalidZelfArgument(py, zelf, "__init__")
    }

    let zelfAsObject = zelf.asObject
    return PyWarning.__init__(py, zelf: zelfAsObject, args: args, kwargs: kwargs)
  }
}

// MARK: - PendingDeprecationWarning

// sourcery: pyerrortype = PendingDeprecationWarning, pybase = Warning, isDefault, isBaseType, hasGC
// sourcery: isBaseExceptionSubclass, instancesHave__dict__
public struct PyPendingDeprecationWarning: PyErrorMixin {

  // sourcery: pytypedoc
  internal static let doc = "Base class for warnings about features which will be deprecated\n" +
"in the future."

  public let ptr: RawPtr

  public init(ptr: RawPtr) {
    self.ptr = ptr
  }

  internal func initialize(_ py: Py,
                           type: PyType,
                           args: PyTuple,
                           traceback: PyTraceback? = nil,
                           cause: PyBaseException? = nil,
                           context: PyBaseException? = nil,
                           suppressContext: Bool = PyErrorHeader.defaultSuppressContext) {
    self.initializeBase(py,
                        type: type,
                        args: args,
                        traceback: traceback,
                        cause: cause,
                        context: context,
                        suppressContext: suppressContext)
  }

  // Nothing to do here.
  internal func beforeDeinitialize() { }

  internal static func createDebugString(ptr: RawPtr) -> String {
    let zelf = PyStopIteration(ptr: ptr)
    return "PyPendingDeprecationWarning(type: \(zelf.typeName), flags: \(zelf.flags))"
  }

  // sourcery: pyproperty = __class__
  internal static func __class__(_ py: Py, zelf: PyObject) -> PyType {
    return zelf.type
  }

  // sourcery: pyproperty = __dict__
  internal static func __dict__(_ py: Py, zelf: PyObject) -> PyResult<PyObject> {
    guard let zelf = Self.downcast(py, zelf) else {
      return Self.invalidZelfArgument(py, zelf, "__dict__")
    }

    let result = zelf.asBaseException.getDict(py)
    return PyResult(result)
  }

  // sourcery: pystaticmethod = __new__
  internal static func __new__(_ py: Py,
                               type: PyType,
                               args: [PyObject],
                               kwargs: PyDict?) -> PyResult<PyObject> {
    let argsTuple = py.newTuple(elements: args)
    let result = py.memory.newPendingDeprecationWarning(py, type: type, args: argsTuple)
    return PyResult(result)
  }

  // sourcery: pymethod = __init__
  internal static func __init__(_ py: Py,
                                zelf: PyObject,
                                args: [PyObject],
                                kwargs: PyDict?) -> PyResult<PyObject> {
    guard let zelf = Self.downcast(py, zelf) else {
      return Self.invalidZelfArgument(py, zelf, "__init__")
    }

    let zelfAsObject = zelf.asObject
    return PyWarning.__init__(py, zelf: zelfAsObject, args: args, kwargs: kwargs)
  }
}

// MARK: - RuntimeWarning

// sourcery: pyerrortype = RuntimeWarning, pybase = Warning, isDefault, isBaseType, hasGC
// sourcery: isBaseExceptionSubclass, instancesHave__dict__
public struct PyRuntimeWarning: PyErrorMixin {

  // sourcery: pytypedoc
  internal static let doc = "Base class for warnings about dubious runtime behavior."

  public let ptr: RawPtr

  public init(ptr: RawPtr) {
    self.ptr = ptr
  }

  internal func initialize(_ py: Py,
                           type: PyType,
                           args: PyTuple,
                           traceback: PyTraceback? = nil,
                           cause: PyBaseException? = nil,
                           context: PyBaseException? = nil,
                           suppressContext: Bool = PyErrorHeader.defaultSuppressContext) {
    self.initializeBase(py,
                        type: type,
                        args: args,
                        traceback: traceback,
                        cause: cause,
                        context: context,
                        suppressContext: suppressContext)
  }

  // Nothing to do here.
  internal func beforeDeinitialize() { }

  internal static func createDebugString(ptr: RawPtr) -> String {
    let zelf = PyStopIteration(ptr: ptr)
    return "PyRuntimeWarning(type: \(zelf.typeName), flags: \(zelf.flags))"
  }

  // sourcery: pyproperty = __class__
  internal static func __class__(_ py: Py, zelf: PyObject) -> PyType {
    return zelf.type
  }

  // sourcery: pyproperty = __dict__
  internal static func __dict__(_ py: Py, zelf: PyObject) -> PyResult<PyObject> {
    guard let zelf = Self.downcast(py, zelf) else {
      return Self.invalidZelfArgument(py, zelf, "__dict__")
    }

    let result = zelf.asBaseException.getDict(py)
    return PyResult(result)
  }

  // sourcery: pystaticmethod = __new__
  internal static func __new__(_ py: Py,
                               type: PyType,
                               args: [PyObject],
                               kwargs: PyDict?) -> PyResult<PyObject> {
    let argsTuple = py.newTuple(elements: args)
    let result = py.memory.newRuntimeWarning(py, type: type, args: argsTuple)
    return PyResult(result)
  }

  // sourcery: pymethod = __init__
  internal static func __init__(_ py: Py,
                                zelf: PyObject,
                                args: [PyObject],
                                kwargs: PyDict?) -> PyResult<PyObject> {
    guard let zelf = Self.downcast(py, zelf) else {
      return Self.invalidZelfArgument(py, zelf, "__init__")
    }

    let zelfAsObject = zelf.asObject
    return PyWarning.__init__(py, zelf: zelfAsObject, args: args, kwargs: kwargs)
  }
}

// MARK: - SyntaxWarning

// sourcery: pyerrortype = SyntaxWarning, pybase = Warning, isDefault, isBaseType, hasGC
// sourcery: isBaseExceptionSubclass, instancesHave__dict__
public struct PySyntaxWarning: PyErrorMixin {

  // sourcery: pytypedoc
  internal static let doc = "Base class for warnings about dubious syntax."

  public let ptr: RawPtr

  public init(ptr: RawPtr) {
    self.ptr = ptr
  }

  internal func initialize(_ py: Py,
                           type: PyType,
                           args: PyTuple,
                           traceback: PyTraceback? = nil,
                           cause: PyBaseException? = nil,
                           context: PyBaseException? = nil,
                           suppressContext: Bool = PyErrorHeader.defaultSuppressContext) {
    self.initializeBase(py,
                        type: type,
                        args: args,
                        traceback: traceback,
                        cause: cause,
                        context: context,
                        suppressContext: suppressContext)
  }

  // Nothing to do here.
  internal func beforeDeinitialize() { }

  internal static func createDebugString(ptr: RawPtr) -> String {
    let zelf = PyStopIteration(ptr: ptr)
    return "PySyntaxWarning(type: \(zelf.typeName), flags: \(zelf.flags))"
  }

  // sourcery: pyproperty = __class__
  internal static func __class__(_ py: Py, zelf: PyObject) -> PyType {
    return zelf.type
  }

  // sourcery: pyproperty = __dict__
  internal static func __dict__(_ py: Py, zelf: PyObject) -> PyResult<PyObject> {
    guard let zelf = Self.downcast(py, zelf) else {
      return Self.invalidZelfArgument(py, zelf, "__dict__")
    }

    let result = zelf.asBaseException.getDict(py)
    return PyResult(result)
  }

  // sourcery: pystaticmethod = __new__
  internal static func __new__(_ py: Py,
                               type: PyType,
                               args: [PyObject],
                               kwargs: PyDict?) -> PyResult<PyObject> {
    let argsTuple = py.newTuple(elements: args)
    let result = py.memory.newSyntaxWarning(py, type: type, args: argsTuple)
    return PyResult(result)
  }

  // sourcery: pymethod = __init__
  internal static func __init__(_ py: Py,
                                zelf: PyObject,
                                args: [PyObject],
                                kwargs: PyDict?) -> PyResult<PyObject> {
    guard let zelf = Self.downcast(py, zelf) else {
      return Self.invalidZelfArgument(py, zelf, "__init__")
    }

    let zelfAsObject = zelf.asObject
    return PyWarning.__init__(py, zelf: zelfAsObject, args: args, kwargs: kwargs)
  }
}

// MARK: - UserWarning

// sourcery: pyerrortype = UserWarning, pybase = Warning, isDefault, isBaseType, hasGC
// sourcery: isBaseExceptionSubclass, instancesHave__dict__
public struct PyUserWarning: PyErrorMixin {

  // sourcery: pytypedoc
  internal static let doc = "Base class for warnings generated by user code."

  public let ptr: RawPtr

  public init(ptr: RawPtr) {
    self.ptr = ptr
  }

  internal func initialize(_ py: Py,
                           type: PyType,
                           args: PyTuple,
                           traceback: PyTraceback? = nil,
                           cause: PyBaseException? = nil,
                           context: PyBaseException? = nil,
                           suppressContext: Bool = PyErrorHeader.defaultSuppressContext) {
    self.initializeBase(py,
                        type: type,
                        args: args,
                        traceback: traceback,
                        cause: cause,
                        context: context,
                        suppressContext: suppressContext)
  }

  // Nothing to do here.
  internal func beforeDeinitialize() { }

  internal static func createDebugString(ptr: RawPtr) -> String {
    let zelf = PyStopIteration(ptr: ptr)
    return "PyUserWarning(type: \(zelf.typeName), flags: \(zelf.flags))"
  }

  // sourcery: pyproperty = __class__
  internal static func __class__(_ py: Py, zelf: PyObject) -> PyType {
    return zelf.type
  }

  // sourcery: pyproperty = __dict__
  internal static func __dict__(_ py: Py, zelf: PyObject) -> PyResult<PyObject> {
    guard let zelf = Self.downcast(py, zelf) else {
      return Self.invalidZelfArgument(py, zelf, "__dict__")
    }

    let result = zelf.asBaseException.getDict(py)
    return PyResult(result)
  }

  // sourcery: pystaticmethod = __new__
  internal static func __new__(_ py: Py,
                               type: PyType,
                               args: [PyObject],
                               kwargs: PyDict?) -> PyResult<PyObject> {
    let argsTuple = py.newTuple(elements: args)
    let result = py.memory.newUserWarning(py, type: type, args: argsTuple)
    return PyResult(result)
  }

  // sourcery: pymethod = __init__
  internal static func __init__(_ py: Py,
                                zelf: PyObject,
                                args: [PyObject],
                                kwargs: PyDict?) -> PyResult<PyObject> {
    guard let zelf = Self.downcast(py, zelf) else {
      return Self.invalidZelfArgument(py, zelf, "__init__")
    }

    let zelfAsObject = zelf.asObject
    return PyWarning.__init__(py, zelf: zelfAsObject, args: args, kwargs: kwargs)
  }
}

// MARK: - FutureWarning

// sourcery: pyerrortype = FutureWarning, pybase = Warning, isDefault, isBaseType, hasGC
// sourcery: isBaseExceptionSubclass, instancesHave__dict__
public struct PyFutureWarning: PyErrorMixin {

  // sourcery: pytypedoc
  internal static let doc = "Base class for warnings about constructs that will change semantically\n" +
"in the future."

  public let ptr: RawPtr

  public init(ptr: RawPtr) {
    self.ptr = ptr
  }

  internal func initialize(_ py: Py,
                           type: PyType,
                           args: PyTuple,
                           traceback: PyTraceback? = nil,
                           cause: PyBaseException? = nil,
                           context: PyBaseException? = nil,
                           suppressContext: Bool = PyErrorHeader.defaultSuppressContext) {
    self.initializeBase(py,
                        type: type,
                        args: args,
                        traceback: traceback,
                        cause: cause,
                        context: context,
                        suppressContext: suppressContext)
  }

  // Nothing to do here.
  internal func beforeDeinitialize() { }

  internal static func createDebugString(ptr: RawPtr) -> String {
    let zelf = PyStopIteration(ptr: ptr)
    return "PyFutureWarning(type: \(zelf.typeName), flags: \(zelf.flags))"
  }

  // sourcery: pyproperty = __class__
  internal static func __class__(_ py: Py, zelf: PyObject) -> PyType {
    return zelf.type
  }

  // sourcery: pyproperty = __dict__
  internal static func __dict__(_ py: Py, zelf: PyObject) -> PyResult<PyObject> {
    guard let zelf = Self.downcast(py, zelf) else {
      return Self.invalidZelfArgument(py, zelf, "__dict__")
    }

    let result = zelf.asBaseException.getDict(py)
    return PyResult(result)
  }

  // sourcery: pystaticmethod = __new__
  internal static func __new__(_ py: Py,
                               type: PyType,
                               args: [PyObject],
                               kwargs: PyDict?) -> PyResult<PyObject> {
    let argsTuple = py.newTuple(elements: args)
    let result = py.memory.newFutureWarning(py, type: type, args: argsTuple)
    return PyResult(result)
  }

  // sourcery: pymethod = __init__
  internal static func __init__(_ py: Py,
                                zelf: PyObject,
                                args: [PyObject],
                                kwargs: PyDict?) -> PyResult<PyObject> {
    guard let zelf = Self.downcast(py, zelf) else {
      return Self.invalidZelfArgument(py, zelf, "__init__")
    }

    let zelfAsObject = zelf.asObject
    return PyWarning.__init__(py, zelf: zelfAsObject, args: args, kwargs: kwargs)
  }
}

// MARK: - ImportWarning

// sourcery: pyerrortype = ImportWarning, pybase = Warning, isDefault, isBaseType, hasGC
// sourcery: isBaseExceptionSubclass, instancesHave__dict__
public struct PyImportWarning: PyErrorMixin {

  // sourcery: pytypedoc
  internal static let doc = "Base class for warnings about probable mistakes in module imports"

  public let ptr: RawPtr

  public init(ptr: RawPtr) {
    self.ptr = ptr
  }

  internal func initialize(_ py: Py,
                           type: PyType,
                           args: PyTuple,
                           traceback: PyTraceback? = nil,
                           cause: PyBaseException? = nil,
                           context: PyBaseException? = nil,
                           suppressContext: Bool = PyErrorHeader.defaultSuppressContext) {
    self.initializeBase(py,
                        type: type,
                        args: args,
                        traceback: traceback,
                        cause: cause,
                        context: context,
                        suppressContext: suppressContext)
  }

  // Nothing to do here.
  internal func beforeDeinitialize() { }

  internal static func createDebugString(ptr: RawPtr) -> String {
    let zelf = PyStopIteration(ptr: ptr)
    return "PyImportWarning(type: \(zelf.typeName), flags: \(zelf.flags))"
  }

  // sourcery: pyproperty = __class__
  internal static func __class__(_ py: Py, zelf: PyObject) -> PyType {
    return zelf.type
  }

  // sourcery: pyproperty = __dict__
  internal static func __dict__(_ py: Py, zelf: PyObject) -> PyResult<PyObject> {
    guard let zelf = Self.downcast(py, zelf) else {
      return Self.invalidZelfArgument(py, zelf, "__dict__")
    }

    let result = zelf.asBaseException.getDict(py)
    return PyResult(result)
  }

  // sourcery: pystaticmethod = __new__
  internal static func __new__(_ py: Py,
                               type: PyType,
                               args: [PyObject],
                               kwargs: PyDict?) -> PyResult<PyObject> {
    let argsTuple = py.newTuple(elements: args)
    let result = py.memory.newImportWarning(py, type: type, args: argsTuple)
    return PyResult(result)
  }

  // sourcery: pymethod = __init__
  internal static func __init__(_ py: Py,
                                zelf: PyObject,
                                args: [PyObject],
                                kwargs: PyDict?) -> PyResult<PyObject> {
    guard let zelf = Self.downcast(py, zelf) else {
      return Self.invalidZelfArgument(py, zelf, "__init__")
    }

    let zelfAsObject = zelf.asObject
    return PyWarning.__init__(py, zelf: zelfAsObject, args: args, kwargs: kwargs)
  }
}

// MARK: - UnicodeWarning

// sourcery: pyerrortype = UnicodeWarning, pybase = Warning, isDefault, isBaseType, hasGC
// sourcery: isBaseExceptionSubclass, instancesHave__dict__
public struct PyUnicodeWarning: PyErrorMixin {

  // sourcery: pytypedoc
  internal static let doc = "Base class for warnings about Unicode related problems, mostly\n" +
"related to conversion problems."

  public let ptr: RawPtr

  public init(ptr: RawPtr) {
    self.ptr = ptr
  }

  internal func initialize(_ py: Py,
                           type: PyType,
                           args: PyTuple,
                           traceback: PyTraceback? = nil,
                           cause: PyBaseException? = nil,
                           context: PyBaseException? = nil,
                           suppressContext: Bool = PyErrorHeader.defaultSuppressContext) {
    self.initializeBase(py,
                        type: type,
                        args: args,
                        traceback: traceback,
                        cause: cause,
                        context: context,
                        suppressContext: suppressContext)
  }

  // Nothing to do here.
  internal func beforeDeinitialize() { }

  internal static func createDebugString(ptr: RawPtr) -> String {
    let zelf = PyStopIteration(ptr: ptr)
    return "PyUnicodeWarning(type: \(zelf.typeName), flags: \(zelf.flags))"
  }

  // sourcery: pyproperty = __class__
  internal static func __class__(_ py: Py, zelf: PyObject) -> PyType {
    return zelf.type
  }

  // sourcery: pyproperty = __dict__
  internal static func __dict__(_ py: Py, zelf: PyObject) -> PyResult<PyObject> {
    guard let zelf = Self.downcast(py, zelf) else {
      return Self.invalidZelfArgument(py, zelf, "__dict__")
    }

    let result = zelf.asBaseException.getDict(py)
    return PyResult(result)
  }

  // sourcery: pystaticmethod = __new__
  internal static func __new__(_ py: Py,
                               type: PyType,
                               args: [PyObject],
                               kwargs: PyDict?) -> PyResult<PyObject> {
    let argsTuple = py.newTuple(elements: args)
    let result = py.memory.newUnicodeWarning(py, type: type, args: argsTuple)
    return PyResult(result)
  }

  // sourcery: pymethod = __init__
  internal static func __init__(_ py: Py,
                                zelf: PyObject,
                                args: [PyObject],
                                kwargs: PyDict?) -> PyResult<PyObject> {
    guard let zelf = Self.downcast(py, zelf) else {
      return Self.invalidZelfArgument(py, zelf, "__init__")
    }

    let zelfAsObject = zelf.asObject
    return PyWarning.__init__(py, zelf: zelfAsObject, args: args, kwargs: kwargs)
  }
}

// MARK: - BytesWarning

// sourcery: pyerrortype = BytesWarning, pybase = Warning, isDefault, isBaseType, hasGC
// sourcery: isBaseExceptionSubclass, instancesHave__dict__
public struct PyBytesWarning: PyErrorMixin {

  // sourcery: pytypedoc
  internal static let doc = "Base class for warnings about bytes and buffer related problems, mostly\n" +
"related to conversion from str or comparing to str."

  public let ptr: RawPtr

  public init(ptr: RawPtr) {
    self.ptr = ptr
  }

  internal func initialize(_ py: Py,
                           type: PyType,
                           args: PyTuple,
                           traceback: PyTraceback? = nil,
                           cause: PyBaseException? = nil,
                           context: PyBaseException? = nil,
                           suppressContext: Bool = PyErrorHeader.defaultSuppressContext) {
    self.initializeBase(py,
                        type: type,
                        args: args,
                        traceback: traceback,
                        cause: cause,
                        context: context,
                        suppressContext: suppressContext)
  }

  // Nothing to do here.
  internal func beforeDeinitialize() { }

  internal static func createDebugString(ptr: RawPtr) -> String {
    let zelf = PyStopIteration(ptr: ptr)
    return "PyBytesWarning(type: \(zelf.typeName), flags: \(zelf.flags))"
  }

  // sourcery: pyproperty = __class__
  internal static func __class__(_ py: Py, zelf: PyObject) -> PyType {
    return zelf.type
  }

  // sourcery: pyproperty = __dict__
  internal static func __dict__(_ py: Py, zelf: PyObject) -> PyResult<PyObject> {
    guard let zelf = Self.downcast(py, zelf) else {
      return Self.invalidZelfArgument(py, zelf, "__dict__")
    }

    let result = zelf.asBaseException.getDict(py)
    return PyResult(result)
  }

  // sourcery: pystaticmethod = __new__
  internal static func __new__(_ py: Py,
                               type: PyType,
                               args: [PyObject],
                               kwargs: PyDict?) -> PyResult<PyObject> {
    let argsTuple = py.newTuple(elements: args)
    let result = py.memory.newBytesWarning(py, type: type, args: argsTuple)
    return PyResult(result)
  }

  // sourcery: pymethod = __init__
  internal static func __init__(_ py: Py,
                                zelf: PyObject,
                                args: [PyObject],
                                kwargs: PyDict?) -> PyResult<PyObject> {
    guard let zelf = Self.downcast(py, zelf) else {
      return Self.invalidZelfArgument(py, zelf, "__init__")
    }

    let zelfAsObject = zelf.asObject
    return PyWarning.__init__(py, zelf: zelfAsObject, args: args, kwargs: kwargs)
  }
}

// MARK: - ResourceWarning

// sourcery: pyerrortype = ResourceWarning, pybase = Warning, isDefault, isBaseType, hasGC
// sourcery: isBaseExceptionSubclass, instancesHave__dict__
public struct PyResourceWarning: PyErrorMixin {

  // sourcery: pytypedoc
  internal static let doc = "Base class for warnings about resource usage."

  public let ptr: RawPtr

  public init(ptr: RawPtr) {
    self.ptr = ptr
  }

  internal func initialize(_ py: Py,
                           type: PyType,
                           args: PyTuple,
                           traceback: PyTraceback? = nil,
                           cause: PyBaseException? = nil,
                           context: PyBaseException? = nil,
                           suppressContext: Bool = PyErrorHeader.defaultSuppressContext) {
    self.initializeBase(py,
                        type: type,
                        args: args,
                        traceback: traceback,
                        cause: cause,
                        context: context,
                        suppressContext: suppressContext)
  }

  // Nothing to do here.
  internal func beforeDeinitialize() { }

  internal static func createDebugString(ptr: RawPtr) -> String {
    let zelf = PyStopIteration(ptr: ptr)
    return "PyResourceWarning(type: \(zelf.typeName), flags: \(zelf.flags))"
  }

  // sourcery: pyproperty = __class__
  internal static func __class__(_ py: Py, zelf: PyObject) -> PyType {
    return zelf.type
  }

  // sourcery: pyproperty = __dict__
  internal static func __dict__(_ py: Py, zelf: PyObject) -> PyResult<PyObject> {
    guard let zelf = Self.downcast(py, zelf) else {
      return Self.invalidZelfArgument(py, zelf, "__dict__")
    }

    let result = zelf.asBaseException.getDict(py)
    return PyResult(result)
  }

  // sourcery: pystaticmethod = __new__
  internal static func __new__(_ py: Py,
                               type: PyType,
                               args: [PyObject],
                               kwargs: PyDict?) -> PyResult<PyObject> {
    let argsTuple = py.newTuple(elements: args)
    let result = py.memory.newResourceWarning(py, type: type, args: argsTuple)
    return PyResult(result)
  }

  // sourcery: pymethod = __init__
  internal static func __init__(_ py: Py,
                                zelf: PyObject,
                                args: [PyObject],
                                kwargs: PyDict?) -> PyResult<PyObject> {
    guard let zelf = Self.downcast(py, zelf) else {
      return Self.invalidZelfArgument(py, zelf, "__init__")
    }

    let zelfAsObject = zelf.asObject
    return PyWarning.__init__(py, zelf: zelfAsObject, args: args, kwargs: kwargs)
  }
}

