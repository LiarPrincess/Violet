// swiftlint:disable line_length
// swiftlint:disable trailing_newline
// swiftlint:disable file_length

// Please note that this file was automatically generated. DO NOT EDIT!
// The same goes for other files in 'Generated' directory.

// In CPython:
// Objects -> exceptions.c
// Lib->test->exception_hierarchy.txt <-- this is amazing
// https://docs.python.org/3.7/library/exceptions.html
// https://docs.python.org/3.7/c-api/exceptions.html

// MARK: - SystemExit

// sourcery: pyerrortype = SystemExit, default, baseType, hasGC, baseExceptionSubclass
public final class PySystemExit: PyBaseException {

  override internal class var doc: String {
    return "Request to exit from the interpreter."
  }

  override public var description: String {
    let msg = self.message.map { "msg: \($0)" } ?? ""
    return "PySystemExit(\(msg))"
  }

  /// Type to set in `init`.
  override internal class var pythonType: PyType {
    return Py.errorTypes.systemExit
  }

   // sourcery: pyproperty = __class__
   override public func getClass() -> PyType {
     return self.type
   }

   // sourcery: pyproperty = __dict__
   override public func getDict() -> PyDict {
     return self.__dict__
   }

  // sourcery: pystaticmethod = __new__
  override internal class func pyNew(type: PyType,
                                     args: [PyObject],
                                     kwargs: PyDict?) -> PyResult<PyBaseException> {
    let argsTuple = Py.newTuple(args)
    return .value(PySystemExit(args: argsTuple, type: type))
  }

  // sourcery: pymethod = __init__
  override internal func pyInit(args: [PyObject], kwargs: PyDict?) -> PyResult<PyNone> {
    return super.pyInit(args: args, kwargs: kwargs)
  }
}

// MARK: - KeyboardInterrupt

// sourcery: pyerrortype = KeyboardInterrupt, default, baseType, hasGC, baseExceptionSubclass
public final class PyKeyboardInterrupt: PyBaseException {

  override internal class var doc: String {
    return "Program interrupted by user."
  }

  override public var description: String {
    let msg = self.message.map { "msg: \($0)" } ?? ""
    return "PyKeyboardInterrupt(\(msg))"
  }

  /// Type to set in `init`.
  override internal class var pythonType: PyType {
    return Py.errorTypes.keyboardInterrupt
  }

   // sourcery: pyproperty = __class__
   override public func getClass() -> PyType {
     return self.type
   }

   // sourcery: pyproperty = __dict__
   override public func getDict() -> PyDict {
     return self.__dict__
   }

  // sourcery: pystaticmethod = __new__
  override internal class func pyNew(type: PyType,
                                     args: [PyObject],
                                     kwargs: PyDict?) -> PyResult<PyBaseException> {
    let argsTuple = Py.newTuple(args)
    return .value(PyKeyboardInterrupt(args: argsTuple, type: type))
  }

  // sourcery: pymethod = __init__
  override internal func pyInit(args: [PyObject], kwargs: PyDict?) -> PyResult<PyNone> {
    return super.pyInit(args: args, kwargs: kwargs)
  }
}

// MARK: - GeneratorExit

// sourcery: pyerrortype = GeneratorExit, default, baseType, hasGC, baseExceptionSubclass
public final class PyGeneratorExit: PyBaseException {

  override internal class var doc: String {
    return "Request that a generator exit."
  }

  override public var description: String {
    let msg = self.message.map { "msg: \($0)" } ?? ""
    return "PyGeneratorExit(\(msg))"
  }

  /// Type to set in `init`.
  override internal class var pythonType: PyType {
    return Py.errorTypes.generatorExit
  }

   // sourcery: pyproperty = __class__
   override public func getClass() -> PyType {
     return self.type
   }

   // sourcery: pyproperty = __dict__
   override public func getDict() -> PyDict {
     return self.__dict__
   }

  // sourcery: pystaticmethod = __new__
  override internal class func pyNew(type: PyType,
                                     args: [PyObject],
                                     kwargs: PyDict?) -> PyResult<PyBaseException> {
    let argsTuple = Py.newTuple(args)
    return .value(PyGeneratorExit(args: argsTuple, type: type))
  }

  // sourcery: pymethod = __init__
  override internal func pyInit(args: [PyObject], kwargs: PyDict?) -> PyResult<PyNone> {
    return super.pyInit(args: args, kwargs: kwargs)
  }
}

// MARK: - Exception

// sourcery: pyerrortype = Exception, default, baseType, hasGC, baseExceptionSubclass
public class PyException: PyBaseException {

  override internal class var doc: String {
    return "Common base class for all non-exit exceptions."
  }

  override public var description: String {
    let msg = self.message.map { "msg: \($0)" } ?? ""
    return "PyException(\(msg))"
  }

  /// Type to set in `init`.
  override internal class var pythonType: PyType {
    return Py.errorTypes.exception
  }

   // sourcery: pyproperty = __class__
   override public func getClass() -> PyType {
     return self.type
   }

   // sourcery: pyproperty = __dict__
   override public func getDict() -> PyDict {
     return self.__dict__
   }

  // sourcery: pystaticmethod = __new__
  override internal class func pyNew(type: PyType,
                                     args: [PyObject],
                                     kwargs: PyDict?) -> PyResult<PyBaseException> {
    let argsTuple = Py.newTuple(args)
    return .value(PyException(args: argsTuple, type: type))
  }

  // sourcery: pymethod = __init__
  override internal func pyInit(args: [PyObject], kwargs: PyDict?) -> PyResult<PyNone> {
    return super.pyInit(args: args, kwargs: kwargs)
  }
}

// MARK: - StopIteration

// sourcery: pyerrortype = StopIteration, default, baseType, hasGC, baseExceptionSubclass
public final class PyStopIteration: PyException {

  override internal class var doc: String {
    return "Signal the end from iterator.__next__()."
  }

  override public var description: String {
    let msg = self.message.map { "msg: \($0)" } ?? ""
    return "PyStopIteration(\(msg))"
  }

  /// Type to set in `init`.
  override internal class var pythonType: PyType {
    return Py.errorTypes.stopIteration
  }

  private var value: PyObject

  internal convenience init(value: PyObject,
                            traceback: PyTraceback? = nil,
                            cause: PyBaseException? = nil,
                            context: PyBaseException? = nil,
                            suppressContext: Bool = false,
                            type: PyType? = nil) {
    let args = Py.newTuple(value)
    self.init(args: args,
              traceback: traceback,
              cause: cause,
              context: context,
              suppressContext: suppressContext,
              type: type)
  }

  override internal init(args: PyTuple,
                         traceback: PyTraceback? = nil,
                         cause: PyBaseException? = nil,
                         context: PyBaseException? = nil,
                         suppressContext: Bool = false,
                         type: PyType? = nil) {
    self.value = args.elements.first ?? Py.none
    super.init(args: args,
               traceback: traceback,
               cause: cause,
               context: context,
               suppressContext: suppressContext,
               type: type)
  }

   // sourcery: pyproperty = __class__
   override public func getClass() -> PyType {
     return self.type
   }

   // sourcery: pyproperty = __dict__
   override public func getDict() -> PyDict {
     return self.__dict__
   }

  // sourcery: pyproperty = value, setter = setValue
  public func getValue() -> PyObject {
    return self.value
  }

  public func setValue(_ value: PyObject) -> PyResult<Void> {
    self.value = value
    return .value()
  }

  // sourcery: pystaticmethod = __new__
  override internal class func pyNew(type: PyType,
                                     args: [PyObject],
                                     kwargs: PyDict?) -> PyResult<PyBaseException> {
    let argsTuple = Py.newTuple(args)
    return .value(PyStopIteration(args: argsTuple, type: type))
  }

  // sourcery: pymethod = __init__
  override internal func pyInit(args: [PyObject], kwargs: PyDict?) -> PyResult<PyNone> {
    self.value = args.first ?? Py.none
    return super.pyInit(args: args, kwargs: kwargs)
  }
}

// MARK: - StopAsyncIteration

// sourcery: pyerrortype = StopAsyncIteration, default, baseType, hasGC, baseExceptionSubclass
public final class PyStopAsyncIteration: PyException {

  override internal class var doc: String {
    return "Signal the end from iterator.__anext__()."
  }

  override public var description: String {
    let msg = self.message.map { "msg: \($0)" } ?? ""
    return "PyStopAsyncIteration(\(msg))"
  }

  /// Type to set in `init`.
  override internal class var pythonType: PyType {
    return Py.errorTypes.stopAsyncIteration
  }

   // sourcery: pyproperty = __class__
   override public func getClass() -> PyType {
     return self.type
   }

   // sourcery: pyproperty = __dict__
   override public func getDict() -> PyDict {
     return self.__dict__
   }

  // sourcery: pystaticmethod = __new__
  override internal class func pyNew(type: PyType,
                                     args: [PyObject],
                                     kwargs: PyDict?) -> PyResult<PyBaseException> {
    let argsTuple = Py.newTuple(args)
    return .value(PyStopAsyncIteration(args: argsTuple, type: type))
  }

  // sourcery: pymethod = __init__
  override internal func pyInit(args: [PyObject], kwargs: PyDict?) -> PyResult<PyNone> {
    return super.pyInit(args: args, kwargs: kwargs)
  }
}

// MARK: - ArithmeticError

// sourcery: pyerrortype = ArithmeticError, default, baseType, hasGC, baseExceptionSubclass
public class PyArithmeticError: PyException {

  override internal class var doc: String {
    return "Base class for arithmetic errors."
  }

  override public var description: String {
    let msg = self.message.map { "msg: \($0)" } ?? ""
    return "PyArithmeticError(\(msg))"
  }

  /// Type to set in `init`.
  override internal class var pythonType: PyType {
    return Py.errorTypes.arithmeticError
  }

   // sourcery: pyproperty = __class__
   override public func getClass() -> PyType {
     return self.type
   }

   // sourcery: pyproperty = __dict__
   override public func getDict() -> PyDict {
     return self.__dict__
   }

  // sourcery: pystaticmethod = __new__
  override internal class func pyNew(type: PyType,
                                     args: [PyObject],
                                     kwargs: PyDict?) -> PyResult<PyBaseException> {
    let argsTuple = Py.newTuple(args)
    return .value(PyArithmeticError(args: argsTuple, type: type))
  }

  // sourcery: pymethod = __init__
  override internal func pyInit(args: [PyObject], kwargs: PyDict?) -> PyResult<PyNone> {
    return super.pyInit(args: args, kwargs: kwargs)
  }
}

// MARK: - FloatingPointError

// sourcery: pyerrortype = FloatingPointError, default, baseType, hasGC, baseExceptionSubclass
public final class PyFloatingPointError: PyArithmeticError {

  override internal class var doc: String {
    return "Floating point operation failed."
  }

  override public var description: String {
    let msg = self.message.map { "msg: \($0)" } ?? ""
    return "PyFloatingPointError(\(msg))"
  }

  /// Type to set in `init`.
  override internal class var pythonType: PyType {
    return Py.errorTypes.floatingPointError
  }

   // sourcery: pyproperty = __class__
   override public func getClass() -> PyType {
     return self.type
   }

   // sourcery: pyproperty = __dict__
   override public func getDict() -> PyDict {
     return self.__dict__
   }

  // sourcery: pystaticmethod = __new__
  override internal class func pyNew(type: PyType,
                                     args: [PyObject],
                                     kwargs: PyDict?) -> PyResult<PyBaseException> {
    let argsTuple = Py.newTuple(args)
    return .value(PyFloatingPointError(args: argsTuple, type: type))
  }

  // sourcery: pymethod = __init__
  override internal func pyInit(args: [PyObject], kwargs: PyDict?) -> PyResult<PyNone> {
    return super.pyInit(args: args, kwargs: kwargs)
  }
}

// MARK: - OverflowError

// sourcery: pyerrortype = OverflowError, default, baseType, hasGC, baseExceptionSubclass
public final class PyOverflowError: PyArithmeticError {

  override internal class var doc: String {
    return "Result too large to be represented."
  }

  override public var description: String {
    let msg = self.message.map { "msg: \($0)" } ?? ""
    return "PyOverflowError(\(msg))"
  }

  /// Type to set in `init`.
  override internal class var pythonType: PyType {
    return Py.errorTypes.overflowError
  }

   // sourcery: pyproperty = __class__
   override public func getClass() -> PyType {
     return self.type
   }

   // sourcery: pyproperty = __dict__
   override public func getDict() -> PyDict {
     return self.__dict__
   }

  // sourcery: pystaticmethod = __new__
  override internal class func pyNew(type: PyType,
                                     args: [PyObject],
                                     kwargs: PyDict?) -> PyResult<PyBaseException> {
    let argsTuple = Py.newTuple(args)
    return .value(PyOverflowError(args: argsTuple, type: type))
  }

  // sourcery: pymethod = __init__
  override internal func pyInit(args: [PyObject], kwargs: PyDict?) -> PyResult<PyNone> {
    return super.pyInit(args: args, kwargs: kwargs)
  }
}

// MARK: - ZeroDivisionError

// sourcery: pyerrortype = ZeroDivisionError, default, baseType, hasGC, baseExceptionSubclass
public final class PyZeroDivisionError: PyArithmeticError {

  override internal class var doc: String {
    return "Second argument to a division or modulo operation was zero."
  }

  override public var description: String {
    let msg = self.message.map { "msg: \($0)" } ?? ""
    return "PyZeroDivisionError(\(msg))"
  }

  /// Type to set in `init`.
  override internal class var pythonType: PyType {
    return Py.errorTypes.zeroDivisionError
  }

   // sourcery: pyproperty = __class__
   override public func getClass() -> PyType {
     return self.type
   }

   // sourcery: pyproperty = __dict__
   override public func getDict() -> PyDict {
     return self.__dict__
   }

  // sourcery: pystaticmethod = __new__
  override internal class func pyNew(type: PyType,
                                     args: [PyObject],
                                     kwargs: PyDict?) -> PyResult<PyBaseException> {
    let argsTuple = Py.newTuple(args)
    return .value(PyZeroDivisionError(args: argsTuple, type: type))
  }

  // sourcery: pymethod = __init__
  override internal func pyInit(args: [PyObject], kwargs: PyDict?) -> PyResult<PyNone> {
    return super.pyInit(args: args, kwargs: kwargs)
  }
}

// MARK: - AssertionError

// sourcery: pyerrortype = AssertionError, default, baseType, hasGC, baseExceptionSubclass
public final class PyAssertionError: PyException {

  override internal class var doc: String {
    return "Assertion failed."
  }

  override public var description: String {
    let msg = self.message.map { "msg: \($0)" } ?? ""
    return "PyAssertionError(\(msg))"
  }

  /// Type to set in `init`.
  override internal class var pythonType: PyType {
    return Py.errorTypes.assertionError
  }

   // sourcery: pyproperty = __class__
   override public func getClass() -> PyType {
     return self.type
   }

   // sourcery: pyproperty = __dict__
   override public func getDict() -> PyDict {
     return self.__dict__
   }

  // sourcery: pystaticmethod = __new__
  override internal class func pyNew(type: PyType,
                                     args: [PyObject],
                                     kwargs: PyDict?) -> PyResult<PyBaseException> {
    let argsTuple = Py.newTuple(args)
    return .value(PyAssertionError(args: argsTuple, type: type))
  }

  // sourcery: pymethod = __init__
  override internal func pyInit(args: [PyObject], kwargs: PyDict?) -> PyResult<PyNone> {
    return super.pyInit(args: args, kwargs: kwargs)
  }
}

// MARK: - AttributeError

// sourcery: pyerrortype = AttributeError, default, baseType, hasGC, baseExceptionSubclass
public final class PyAttributeError: PyException {

  override internal class var doc: String {
    return "Attribute not found."
  }

  override public var description: String {
    let msg = self.message.map { "msg: \($0)" } ?? ""
    return "PyAttributeError(\(msg))"
  }

  /// Type to set in `init`.
  override internal class var pythonType: PyType {
    return Py.errorTypes.attributeError
  }

   // sourcery: pyproperty = __class__
   override public func getClass() -> PyType {
     return self.type
   }

   // sourcery: pyproperty = __dict__
   override public func getDict() -> PyDict {
     return self.__dict__
   }

  // sourcery: pystaticmethod = __new__
  override internal class func pyNew(type: PyType,
                                     args: [PyObject],
                                     kwargs: PyDict?) -> PyResult<PyBaseException> {
    let argsTuple = Py.newTuple(args)
    return .value(PyAttributeError(args: argsTuple, type: type))
  }

  // sourcery: pymethod = __init__
  override internal func pyInit(args: [PyObject], kwargs: PyDict?) -> PyResult<PyNone> {
    return super.pyInit(args: args, kwargs: kwargs)
  }
}

// MARK: - BufferError

// sourcery: pyerrortype = BufferError, default, baseType, hasGC, baseExceptionSubclass
public final class PyBufferError: PyException {

  override internal class var doc: String {
    return "Buffer error."
  }

  override public var description: String {
    let msg = self.message.map { "msg: \($0)" } ?? ""
    return "PyBufferError(\(msg))"
  }

  /// Type to set in `init`.
  override internal class var pythonType: PyType {
    return Py.errorTypes.bufferError
  }

   // sourcery: pyproperty = __class__
   override public func getClass() -> PyType {
     return self.type
   }

   // sourcery: pyproperty = __dict__
   override public func getDict() -> PyDict {
     return self.__dict__
   }

  // sourcery: pystaticmethod = __new__
  override internal class func pyNew(type: PyType,
                                     args: [PyObject],
                                     kwargs: PyDict?) -> PyResult<PyBaseException> {
    let argsTuple = Py.newTuple(args)
    return .value(PyBufferError(args: argsTuple, type: type))
  }

  // sourcery: pymethod = __init__
  override internal func pyInit(args: [PyObject], kwargs: PyDict?) -> PyResult<PyNone> {
    return super.pyInit(args: args, kwargs: kwargs)
  }
}

// MARK: - EOFError

// sourcery: pyerrortype = EOFError, default, baseType, hasGC, baseExceptionSubclass
public final class PyEOFError: PyException {

  override internal class var doc: String {
    return "Read beyond end of file."
  }

  override public var description: String {
    let msg = self.message.map { "msg: \($0)" } ?? ""
    return "PyEOFError(\(msg))"
  }

  /// Type to set in `init`.
  override internal class var pythonType: PyType {
    return Py.errorTypes.eofError
  }

   // sourcery: pyproperty = __class__
   override public func getClass() -> PyType {
     return self.type
   }

   // sourcery: pyproperty = __dict__
   override public func getDict() -> PyDict {
     return self.__dict__
   }

  // sourcery: pystaticmethod = __new__
  override internal class func pyNew(type: PyType,
                                     args: [PyObject],
                                     kwargs: PyDict?) -> PyResult<PyBaseException> {
    let argsTuple = Py.newTuple(args)
    return .value(PyEOFError(args: argsTuple, type: type))
  }

  // sourcery: pymethod = __init__
  override internal func pyInit(args: [PyObject], kwargs: PyDict?) -> PyResult<PyNone> {
    return super.pyInit(args: args, kwargs: kwargs)
  }
}

// MARK: - ImportError

// sourcery: pyerrortype = ImportError, default, baseType, hasGC, baseExceptionSubclass
public class PyImportError: PyException {

  override internal class var doc: String {
    return "Import can't find module, or can't find name in module."
  }

  override public var description: String {
    let msg = self.message.map { "msg: \($0)" } ?? ""
    return "PyImportError(\(msg))"
  }

  /// Type to set in `init`.
  override internal class var pythonType: PyType {
    return Py.errorTypes.importError
  }

   // sourcery: pyproperty = __class__
   override public func getClass() -> PyType {
     return self.type
   }

   // sourcery: pyproperty = __dict__
   override public func getDict() -> PyDict {
     return self.__dict__
   }

  // sourcery: pystaticmethod = __new__
  override internal class func pyNew(type: PyType,
                                     args: [PyObject],
                                     kwargs: PyDict?) -> PyResult<PyBaseException> {
    let argsTuple = Py.newTuple(args)
    return .value(PyImportError(args: argsTuple, type: type))
  }

  // sourcery: pymethod = __init__
  override internal func pyInit(args: [PyObject], kwargs: PyDict?) -> PyResult<PyNone> {
    return super.pyInit(args: args, kwargs: kwargs)
  }
}

// MARK: - ModuleNotFoundError

// sourcery: pyerrortype = ModuleNotFoundError, default, baseType, hasGC, baseExceptionSubclass
public final class PyModuleNotFoundError: PyImportError {

  override internal class var doc: String {
    return "Module not found."
  }

  override public var description: String {
    let msg = self.message.map { "msg: \($0)" } ?? ""
    return "PyModuleNotFoundError(\(msg))"
  }

  /// Type to set in `init`.
  override internal class var pythonType: PyType {
    return Py.errorTypes.moduleNotFoundError
  }

   // sourcery: pyproperty = __class__
   override public func getClass() -> PyType {
     return self.type
   }

   // sourcery: pyproperty = __dict__
   override public func getDict() -> PyDict {
     return self.__dict__
   }

  // sourcery: pystaticmethod = __new__
  override internal class func pyNew(type: PyType,
                                     args: [PyObject],
                                     kwargs: PyDict?) -> PyResult<PyBaseException> {
    let argsTuple = Py.newTuple(args)
    return .value(PyModuleNotFoundError(args: argsTuple, type: type))
  }

  // sourcery: pymethod = __init__
  override internal func pyInit(args: [PyObject], kwargs: PyDict?) -> PyResult<PyNone> {
    return super.pyInit(args: args, kwargs: kwargs)
  }
}

// MARK: - LookupError

// sourcery: pyerrortype = LookupError, default, baseType, hasGC, baseExceptionSubclass
public class PyLookupError: PyException {

  override internal class var doc: String {
    return "Base class for lookup errors."
  }

  override public var description: String {
    let msg = self.message.map { "msg: \($0)" } ?? ""
    return "PyLookupError(\(msg))"
  }

  /// Type to set in `init`.
  override internal class var pythonType: PyType {
    return Py.errorTypes.lookupError
  }

   // sourcery: pyproperty = __class__
   override public func getClass() -> PyType {
     return self.type
   }

   // sourcery: pyproperty = __dict__
   override public func getDict() -> PyDict {
     return self.__dict__
   }

  // sourcery: pystaticmethod = __new__
  override internal class func pyNew(type: PyType,
                                     args: [PyObject],
                                     kwargs: PyDict?) -> PyResult<PyBaseException> {
    let argsTuple = Py.newTuple(args)
    return .value(PyLookupError(args: argsTuple, type: type))
  }

  // sourcery: pymethod = __init__
  override internal func pyInit(args: [PyObject], kwargs: PyDict?) -> PyResult<PyNone> {
    return super.pyInit(args: args, kwargs: kwargs)
  }
}

// MARK: - IndexError

// sourcery: pyerrortype = IndexError, default, baseType, hasGC, baseExceptionSubclass
public final class PyIndexError: PyLookupError {

  override internal class var doc: String {
    return "Sequence index out of range."
  }

  override public var description: String {
    let msg = self.message.map { "msg: \($0)" } ?? ""
    return "PyIndexError(\(msg))"
  }

  /// Type to set in `init`.
  override internal class var pythonType: PyType {
    return Py.errorTypes.indexError
  }

   // sourcery: pyproperty = __class__
   override public func getClass() -> PyType {
     return self.type
   }

   // sourcery: pyproperty = __dict__
   override public func getDict() -> PyDict {
     return self.__dict__
   }

  // sourcery: pystaticmethod = __new__
  override internal class func pyNew(type: PyType,
                                     args: [PyObject],
                                     kwargs: PyDict?) -> PyResult<PyBaseException> {
    let argsTuple = Py.newTuple(args)
    return .value(PyIndexError(args: argsTuple, type: type))
  }

  // sourcery: pymethod = __init__
  override internal func pyInit(args: [PyObject], kwargs: PyDict?) -> PyResult<PyNone> {
    return super.pyInit(args: args, kwargs: kwargs)
  }
}

// MARK: - KeyError

// sourcery: pyerrortype = KeyError, default, baseType, hasGC, baseExceptionSubclass
public final class PyKeyError: PyLookupError {

  override internal class var doc: String {
    return "Mapping key not found."
  }

  override public var description: String {
    let msg = self.message.map { "msg: \($0)" } ?? ""
    return "PyKeyError(\(msg))"
  }

  /// Type to set in `init`.
  override internal class var pythonType: PyType {
    return Py.errorTypes.keyError
  }

   // sourcery: pyproperty = __class__
   override public func getClass() -> PyType {
     return self.type
   }

   // sourcery: pyproperty = __dict__
   override public func getDict() -> PyDict {
     return self.__dict__
   }

  // sourcery: pymethod = __str__
  override public func str() -> PyResult<String> {
    // If args is a tuple of exactly one item, apply repr to args[0].
    // This is done so that e.g. the exception raised by {{}}[''] prints
    //     KeyError: ''
    // rather than the confusing
    //     KeyError
    // alone.  The downside is that if KeyError is raised with an explanatory
    // string, that string will be displayed in quotes.  Too bad.
    // If args is anything else, use the default BaseException__str__().

    let args = self.getArgs()

    switch args.getLength() {
    case 1:
      let first = args.elements[0]
      return Py.repr(object: first)
    default:
      return super.str()
    }
  }

  // sourcery: pystaticmethod = __new__
  override internal class func pyNew(type: PyType,
                                     args: [PyObject],
                                     kwargs: PyDict?) -> PyResult<PyBaseException> {
    let argsTuple = Py.newTuple(args)
    return .value(PyKeyError(args: argsTuple, type: type))
  }

  // sourcery: pymethod = __init__
  override internal func pyInit(args: [PyObject], kwargs: PyDict?) -> PyResult<PyNone> {
    return super.pyInit(args: args, kwargs: kwargs)
  }
}

// MARK: - MemoryError

// sourcery: pyerrortype = MemoryError, default, baseType, hasGC, baseExceptionSubclass
public final class PyMemoryError: PyException {

  override internal class var doc: String {
    return "Out of memory."
  }

  override public var description: String {
    let msg = self.message.map { "msg: \($0)" } ?? ""
    return "PyMemoryError(\(msg))"
  }

  /// Type to set in `init`.
  override internal class var pythonType: PyType {
    return Py.errorTypes.memoryError
  }

   // sourcery: pyproperty = __class__
   override public func getClass() -> PyType {
     return self.type
   }

   // sourcery: pyproperty = __dict__
   override public func getDict() -> PyDict {
     return self.__dict__
   }

  // sourcery: pystaticmethod = __new__
  override internal class func pyNew(type: PyType,
                                     args: [PyObject],
                                     kwargs: PyDict?) -> PyResult<PyBaseException> {
    let argsTuple = Py.newTuple(args)
    return .value(PyMemoryError(args: argsTuple, type: type))
  }

  // sourcery: pymethod = __init__
  override internal func pyInit(args: [PyObject], kwargs: PyDict?) -> PyResult<PyNone> {
    return super.pyInit(args: args, kwargs: kwargs)
  }
}

// MARK: - NameError

// sourcery: pyerrortype = NameError, default, baseType, hasGC, baseExceptionSubclass
public class PyNameError: PyException {

  override internal class var doc: String {
    return "Name not found globally."
  }

  override public var description: String {
    let msg = self.message.map { "msg: \($0)" } ?? ""
    return "PyNameError(\(msg))"
  }

  /// Type to set in `init`.
  override internal class var pythonType: PyType {
    return Py.errorTypes.nameError
  }

   // sourcery: pyproperty = __class__
   override public func getClass() -> PyType {
     return self.type
   }

   // sourcery: pyproperty = __dict__
   override public func getDict() -> PyDict {
     return self.__dict__
   }

  // sourcery: pystaticmethod = __new__
  override internal class func pyNew(type: PyType,
                                     args: [PyObject],
                                     kwargs: PyDict?) -> PyResult<PyBaseException> {
    let argsTuple = Py.newTuple(args)
    return .value(PyNameError(args: argsTuple, type: type))
  }

  // sourcery: pymethod = __init__
  override internal func pyInit(args: [PyObject], kwargs: PyDict?) -> PyResult<PyNone> {
    return super.pyInit(args: args, kwargs: kwargs)
  }
}

// MARK: - UnboundLocalError

// sourcery: pyerrortype = UnboundLocalError, default, baseType, hasGC, baseExceptionSubclass
public final class PyUnboundLocalError: PyNameError {

  override internal class var doc: String {
    return "Local name referenced but not bound to a value."
  }

  override public var description: String {
    let msg = self.message.map { "msg: \($0)" } ?? ""
    return "PyUnboundLocalError(\(msg))"
  }

  /// Type to set in `init`.
  override internal class var pythonType: PyType {
    return Py.errorTypes.unboundLocalError
  }

   // sourcery: pyproperty = __class__
   override public func getClass() -> PyType {
     return self.type
   }

   // sourcery: pyproperty = __dict__
   override public func getDict() -> PyDict {
     return self.__dict__
   }

  // sourcery: pystaticmethod = __new__
  override internal class func pyNew(type: PyType,
                                     args: [PyObject],
                                     kwargs: PyDict?) -> PyResult<PyBaseException> {
    let argsTuple = Py.newTuple(args)
    return .value(PyUnboundLocalError(args: argsTuple, type: type))
  }

  // sourcery: pymethod = __init__
  override internal func pyInit(args: [PyObject], kwargs: PyDict?) -> PyResult<PyNone> {
    return super.pyInit(args: args, kwargs: kwargs)
  }
}

// MARK: - OSError

// sourcery: pyerrortype = OSError, default, baseType, hasGC, baseExceptionSubclass
public class PyOSError: PyException {

  override internal class var doc: String {
    return "Base class for I/O related errors."
  }

  override public var description: String {
    let msg = self.message.map { "msg: \($0)" } ?? ""
    return "PyOSError(\(msg))"
  }

  /// Type to set in `init`.
  override internal class var pythonType: PyType {
    return Py.errorTypes.osError
  }

   // sourcery: pyproperty = __class__
   override public func getClass() -> PyType {
     return self.type
   }

   // sourcery: pyproperty = __dict__
   override public func getDict() -> PyDict {
     return self.__dict__
   }

  // sourcery: pystaticmethod = __new__
  override internal class func pyNew(type: PyType,
                                     args: [PyObject],
                                     kwargs: PyDict?) -> PyResult<PyBaseException> {
    let argsTuple = Py.newTuple(args)
    return .value(PyOSError(args: argsTuple, type: type))
  }

  // sourcery: pymethod = __init__
  override internal func pyInit(args: [PyObject], kwargs: PyDict?) -> PyResult<PyNone> {
    return super.pyInit(args: args, kwargs: kwargs)
  }
}

// MARK: - BlockingIOError

// sourcery: pyerrortype = BlockingIOError, default, baseType, hasGC, baseExceptionSubclass
public final class PyBlockingIOError: PyOSError {

  override internal class var doc: String {
    return "I/O operation would block."
  }

  override public var description: String {
    let msg = self.message.map { "msg: \($0)" } ?? ""
    return "PyBlockingIOError(\(msg))"
  }

  /// Type to set in `init`.
  override internal class var pythonType: PyType {
    return Py.errorTypes.blockingIOError
  }

   // sourcery: pyproperty = __class__
   override public func getClass() -> PyType {
     return self.type
   }

   // sourcery: pyproperty = __dict__
   override public func getDict() -> PyDict {
     return self.__dict__
   }

  // sourcery: pystaticmethod = __new__
  override internal class func pyNew(type: PyType,
                                     args: [PyObject],
                                     kwargs: PyDict?) -> PyResult<PyBaseException> {
    let argsTuple = Py.newTuple(args)
    return .value(PyBlockingIOError(args: argsTuple, type: type))
  }

  // sourcery: pymethod = __init__
  override internal func pyInit(args: [PyObject], kwargs: PyDict?) -> PyResult<PyNone> {
    return super.pyInit(args: args, kwargs: kwargs)
  }
}

// MARK: - ChildProcessError

// sourcery: pyerrortype = ChildProcessError, default, baseType, hasGC, baseExceptionSubclass
public final class PyChildProcessError: PyOSError {

  override internal class var doc: String {
    return "Child process error."
  }

  override public var description: String {
    let msg = self.message.map { "msg: \($0)" } ?? ""
    return "PyChildProcessError(\(msg))"
  }

  /// Type to set in `init`.
  override internal class var pythonType: PyType {
    return Py.errorTypes.childProcessError
  }

   // sourcery: pyproperty = __class__
   override public func getClass() -> PyType {
     return self.type
   }

   // sourcery: pyproperty = __dict__
   override public func getDict() -> PyDict {
     return self.__dict__
   }

  // sourcery: pystaticmethod = __new__
  override internal class func pyNew(type: PyType,
                                     args: [PyObject],
                                     kwargs: PyDict?) -> PyResult<PyBaseException> {
    let argsTuple = Py.newTuple(args)
    return .value(PyChildProcessError(args: argsTuple, type: type))
  }

  // sourcery: pymethod = __init__
  override internal func pyInit(args: [PyObject], kwargs: PyDict?) -> PyResult<PyNone> {
    return super.pyInit(args: args, kwargs: kwargs)
  }
}

// MARK: - ConnectionError

// sourcery: pyerrortype = ConnectionError, default, baseType, hasGC, baseExceptionSubclass
public class PyConnectionError: PyOSError {

  override internal class var doc: String {
    return "Connection error."
  }

  override public var description: String {
    let msg = self.message.map { "msg: \($0)" } ?? ""
    return "PyConnectionError(\(msg))"
  }

  /// Type to set in `init`.
  override internal class var pythonType: PyType {
    return Py.errorTypes.connectionError
  }

   // sourcery: pyproperty = __class__
   override public func getClass() -> PyType {
     return self.type
   }

   // sourcery: pyproperty = __dict__
   override public func getDict() -> PyDict {
     return self.__dict__
   }

  // sourcery: pystaticmethod = __new__
  override internal class func pyNew(type: PyType,
                                     args: [PyObject],
                                     kwargs: PyDict?) -> PyResult<PyBaseException> {
    let argsTuple = Py.newTuple(args)
    return .value(PyConnectionError(args: argsTuple, type: type))
  }

  // sourcery: pymethod = __init__
  override internal func pyInit(args: [PyObject], kwargs: PyDict?) -> PyResult<PyNone> {
    return super.pyInit(args: args, kwargs: kwargs)
  }
}

// MARK: - BrokenPipeError

// sourcery: pyerrortype = BrokenPipeError, default, baseType, hasGC, baseExceptionSubclass
public final class PyBrokenPipeError: PyConnectionError {

  override internal class var doc: String {
    return "Broken pipe."
  }

  override public var description: String {
    let msg = self.message.map { "msg: \($0)" } ?? ""
    return "PyBrokenPipeError(\(msg))"
  }

  /// Type to set in `init`.
  override internal class var pythonType: PyType {
    return Py.errorTypes.brokenPipeError
  }

   // sourcery: pyproperty = __class__
   override public func getClass() -> PyType {
     return self.type
   }

   // sourcery: pyproperty = __dict__
   override public func getDict() -> PyDict {
     return self.__dict__
   }

  // sourcery: pystaticmethod = __new__
  override internal class func pyNew(type: PyType,
                                     args: [PyObject],
                                     kwargs: PyDict?) -> PyResult<PyBaseException> {
    let argsTuple = Py.newTuple(args)
    return .value(PyBrokenPipeError(args: argsTuple, type: type))
  }

  // sourcery: pymethod = __init__
  override internal func pyInit(args: [PyObject], kwargs: PyDict?) -> PyResult<PyNone> {
    return super.pyInit(args: args, kwargs: kwargs)
  }
}

// MARK: - ConnectionAbortedError

// sourcery: pyerrortype = ConnectionAbortedError, default, baseType, hasGC, baseExceptionSubclass
public final class PyConnectionAbortedError: PyConnectionError {

  override internal class var doc: String {
    return "Connection aborted."
  }

  override public var description: String {
    let msg = self.message.map { "msg: \($0)" } ?? ""
    return "PyConnectionAbortedError(\(msg))"
  }

  /// Type to set in `init`.
  override internal class var pythonType: PyType {
    return Py.errorTypes.connectionAbortedError
  }

   // sourcery: pyproperty = __class__
   override public func getClass() -> PyType {
     return self.type
   }

   // sourcery: pyproperty = __dict__
   override public func getDict() -> PyDict {
     return self.__dict__
   }

  // sourcery: pystaticmethod = __new__
  override internal class func pyNew(type: PyType,
                                     args: [PyObject],
                                     kwargs: PyDict?) -> PyResult<PyBaseException> {
    let argsTuple = Py.newTuple(args)
    return .value(PyConnectionAbortedError(args: argsTuple, type: type))
  }

  // sourcery: pymethod = __init__
  override internal func pyInit(args: [PyObject], kwargs: PyDict?) -> PyResult<PyNone> {
    return super.pyInit(args: args, kwargs: kwargs)
  }
}

// MARK: - ConnectionRefusedError

// sourcery: pyerrortype = ConnectionRefusedError, default, baseType, hasGC, baseExceptionSubclass
public final class PyConnectionRefusedError: PyConnectionError {

  override internal class var doc: String {
    return "Connection refused."
  }

  override public var description: String {
    let msg = self.message.map { "msg: \($0)" } ?? ""
    return "PyConnectionRefusedError(\(msg))"
  }

  /// Type to set in `init`.
  override internal class var pythonType: PyType {
    return Py.errorTypes.connectionRefusedError
  }

   // sourcery: pyproperty = __class__
   override public func getClass() -> PyType {
     return self.type
   }

   // sourcery: pyproperty = __dict__
   override public func getDict() -> PyDict {
     return self.__dict__
   }

  // sourcery: pystaticmethod = __new__
  override internal class func pyNew(type: PyType,
                                     args: [PyObject],
                                     kwargs: PyDict?) -> PyResult<PyBaseException> {
    let argsTuple = Py.newTuple(args)
    return .value(PyConnectionRefusedError(args: argsTuple, type: type))
  }

  // sourcery: pymethod = __init__
  override internal func pyInit(args: [PyObject], kwargs: PyDict?) -> PyResult<PyNone> {
    return super.pyInit(args: args, kwargs: kwargs)
  }
}

// MARK: - ConnectionResetError

// sourcery: pyerrortype = ConnectionResetError, default, baseType, hasGC, baseExceptionSubclass
public final class PyConnectionResetError: PyConnectionError {

  override internal class var doc: String {
    return "Connection reset."
  }

  override public var description: String {
    let msg = self.message.map { "msg: \($0)" } ?? ""
    return "PyConnectionResetError(\(msg))"
  }

  /// Type to set in `init`.
  override internal class var pythonType: PyType {
    return Py.errorTypes.connectionResetError
  }

   // sourcery: pyproperty = __class__
   override public func getClass() -> PyType {
     return self.type
   }

   // sourcery: pyproperty = __dict__
   override public func getDict() -> PyDict {
     return self.__dict__
   }

  // sourcery: pystaticmethod = __new__
  override internal class func pyNew(type: PyType,
                                     args: [PyObject],
                                     kwargs: PyDict?) -> PyResult<PyBaseException> {
    let argsTuple = Py.newTuple(args)
    return .value(PyConnectionResetError(args: argsTuple, type: type))
  }

  // sourcery: pymethod = __init__
  override internal func pyInit(args: [PyObject], kwargs: PyDict?) -> PyResult<PyNone> {
    return super.pyInit(args: args, kwargs: kwargs)
  }
}

// MARK: - FileExistsError

// sourcery: pyerrortype = FileExistsError, default, baseType, hasGC, baseExceptionSubclass
public final class PyFileExistsError: PyOSError {

  override internal class var doc: String {
    return "File already exists."
  }

  override public var description: String {
    let msg = self.message.map { "msg: \($0)" } ?? ""
    return "PyFileExistsError(\(msg))"
  }

  /// Type to set in `init`.
  override internal class var pythonType: PyType {
    return Py.errorTypes.fileExistsError
  }

   // sourcery: pyproperty = __class__
   override public func getClass() -> PyType {
     return self.type
   }

   // sourcery: pyproperty = __dict__
   override public func getDict() -> PyDict {
     return self.__dict__
   }

  // sourcery: pystaticmethod = __new__
  override internal class func pyNew(type: PyType,
                                     args: [PyObject],
                                     kwargs: PyDict?) -> PyResult<PyBaseException> {
    let argsTuple = Py.newTuple(args)
    return .value(PyFileExistsError(args: argsTuple, type: type))
  }

  // sourcery: pymethod = __init__
  override internal func pyInit(args: [PyObject], kwargs: PyDict?) -> PyResult<PyNone> {
    return super.pyInit(args: args, kwargs: kwargs)
  }
}

// MARK: - FileNotFoundError

// sourcery: pyerrortype = FileNotFoundError, default, baseType, hasGC, baseExceptionSubclass
public final class PyFileNotFoundError: PyOSError {

  override internal class var doc: String {
    return "File not found."
  }

  override public var description: String {
    let msg = self.message.map { "msg: \($0)" } ?? ""
    return "PyFileNotFoundError(\(msg))"
  }

  /// Type to set in `init`.
  override internal class var pythonType: PyType {
    return Py.errorTypes.fileNotFoundError
  }

   // sourcery: pyproperty = __class__
   override public func getClass() -> PyType {
     return self.type
   }

   // sourcery: pyproperty = __dict__
   override public func getDict() -> PyDict {
     return self.__dict__
   }

  // sourcery: pystaticmethod = __new__
  override internal class func pyNew(type: PyType,
                                     args: [PyObject],
                                     kwargs: PyDict?) -> PyResult<PyBaseException> {
    let argsTuple = Py.newTuple(args)
    return .value(PyFileNotFoundError(args: argsTuple, type: type))
  }

  // sourcery: pymethod = __init__
  override internal func pyInit(args: [PyObject], kwargs: PyDict?) -> PyResult<PyNone> {
    return super.pyInit(args: args, kwargs: kwargs)
  }
}

// MARK: - InterruptedError

// sourcery: pyerrortype = InterruptedError, default, baseType, hasGC, baseExceptionSubclass
public final class PyInterruptedError: PyOSError {

  override internal class var doc: String {
    return "Interrupted by signal."
  }

  override public var description: String {
    let msg = self.message.map { "msg: \($0)" } ?? ""
    return "PyInterruptedError(\(msg))"
  }

  /// Type to set in `init`.
  override internal class var pythonType: PyType {
    return Py.errorTypes.interruptedError
  }

   // sourcery: pyproperty = __class__
   override public func getClass() -> PyType {
     return self.type
   }

   // sourcery: pyproperty = __dict__
   override public func getDict() -> PyDict {
     return self.__dict__
   }

  // sourcery: pystaticmethod = __new__
  override internal class func pyNew(type: PyType,
                                     args: [PyObject],
                                     kwargs: PyDict?) -> PyResult<PyBaseException> {
    let argsTuple = Py.newTuple(args)
    return .value(PyInterruptedError(args: argsTuple, type: type))
  }

  // sourcery: pymethod = __init__
  override internal func pyInit(args: [PyObject], kwargs: PyDict?) -> PyResult<PyNone> {
    return super.pyInit(args: args, kwargs: kwargs)
  }
}

// MARK: - IsADirectoryError

// sourcery: pyerrortype = IsADirectoryError, default, baseType, hasGC, baseExceptionSubclass
public final class PyIsADirectoryError: PyOSError {

  override internal class var doc: String {
    return "Operation doesn't work on directories."
  }

  override public var description: String {
    let msg = self.message.map { "msg: \($0)" } ?? ""
    return "PyIsADirectoryError(\(msg))"
  }

  /// Type to set in `init`.
  override internal class var pythonType: PyType {
    return Py.errorTypes.isADirectoryError
  }

   // sourcery: pyproperty = __class__
   override public func getClass() -> PyType {
     return self.type
   }

   // sourcery: pyproperty = __dict__
   override public func getDict() -> PyDict {
     return self.__dict__
   }

  // sourcery: pystaticmethod = __new__
  override internal class func pyNew(type: PyType,
                                     args: [PyObject],
                                     kwargs: PyDict?) -> PyResult<PyBaseException> {
    let argsTuple = Py.newTuple(args)
    return .value(PyIsADirectoryError(args: argsTuple, type: type))
  }

  // sourcery: pymethod = __init__
  override internal func pyInit(args: [PyObject], kwargs: PyDict?) -> PyResult<PyNone> {
    return super.pyInit(args: args, kwargs: kwargs)
  }
}

// MARK: - NotADirectoryError

// sourcery: pyerrortype = NotADirectoryError, default, baseType, hasGC, baseExceptionSubclass
public final class PyNotADirectoryError: PyOSError {

  override internal class var doc: String {
    return "Operation only works on directories."
  }

  override public var description: String {
    let msg = self.message.map { "msg: \($0)" } ?? ""
    return "PyNotADirectoryError(\(msg))"
  }

  /// Type to set in `init`.
  override internal class var pythonType: PyType {
    return Py.errorTypes.notADirectoryError
  }

   // sourcery: pyproperty = __class__
   override public func getClass() -> PyType {
     return self.type
   }

   // sourcery: pyproperty = __dict__
   override public func getDict() -> PyDict {
     return self.__dict__
   }

  // sourcery: pystaticmethod = __new__
  override internal class func pyNew(type: PyType,
                                     args: [PyObject],
                                     kwargs: PyDict?) -> PyResult<PyBaseException> {
    let argsTuple = Py.newTuple(args)
    return .value(PyNotADirectoryError(args: argsTuple, type: type))
  }

  // sourcery: pymethod = __init__
  override internal func pyInit(args: [PyObject], kwargs: PyDict?) -> PyResult<PyNone> {
    return super.pyInit(args: args, kwargs: kwargs)
  }
}

// MARK: - PermissionError

// sourcery: pyerrortype = PermissionError, default, baseType, hasGC, baseExceptionSubclass
public final class PyPermissionError: PyOSError {

  override internal class var doc: String {
    return "Not enough permissions."
  }

  override public var description: String {
    let msg = self.message.map { "msg: \($0)" } ?? ""
    return "PyPermissionError(\(msg))"
  }

  /// Type to set in `init`.
  override internal class var pythonType: PyType {
    return Py.errorTypes.permissionError
  }

   // sourcery: pyproperty = __class__
   override public func getClass() -> PyType {
     return self.type
   }

   // sourcery: pyproperty = __dict__
   override public func getDict() -> PyDict {
     return self.__dict__
   }

  // sourcery: pystaticmethod = __new__
  override internal class func pyNew(type: PyType,
                                     args: [PyObject],
                                     kwargs: PyDict?) -> PyResult<PyBaseException> {
    let argsTuple = Py.newTuple(args)
    return .value(PyPermissionError(args: argsTuple, type: type))
  }

  // sourcery: pymethod = __init__
  override internal func pyInit(args: [PyObject], kwargs: PyDict?) -> PyResult<PyNone> {
    return super.pyInit(args: args, kwargs: kwargs)
  }
}

// MARK: - ProcessLookupError

// sourcery: pyerrortype = ProcessLookupError, default, baseType, hasGC, baseExceptionSubclass
public final class PyProcessLookupError: PyOSError {

  override internal class var doc: String {
    return "Process not found."
  }

  override public var description: String {
    let msg = self.message.map { "msg: \($0)" } ?? ""
    return "PyProcessLookupError(\(msg))"
  }

  /// Type to set in `init`.
  override internal class var pythonType: PyType {
    return Py.errorTypes.processLookupError
  }

   // sourcery: pyproperty = __class__
   override public func getClass() -> PyType {
     return self.type
   }

   // sourcery: pyproperty = __dict__
   override public func getDict() -> PyDict {
     return self.__dict__
   }

  // sourcery: pystaticmethod = __new__
  override internal class func pyNew(type: PyType,
                                     args: [PyObject],
                                     kwargs: PyDict?) -> PyResult<PyBaseException> {
    let argsTuple = Py.newTuple(args)
    return .value(PyProcessLookupError(args: argsTuple, type: type))
  }

  // sourcery: pymethod = __init__
  override internal func pyInit(args: [PyObject], kwargs: PyDict?) -> PyResult<PyNone> {
    return super.pyInit(args: args, kwargs: kwargs)
  }
}

// MARK: - TimeoutError

// sourcery: pyerrortype = TimeoutError, default, baseType, hasGC, baseExceptionSubclass
public final class PyTimeoutError: PyOSError {

  override internal class var doc: String {
    return "Timeout expired."
  }

  override public var description: String {
    let msg = self.message.map { "msg: \($0)" } ?? ""
    return "PyTimeoutError(\(msg))"
  }

  /// Type to set in `init`.
  override internal class var pythonType: PyType {
    return Py.errorTypes.timeoutError
  }

   // sourcery: pyproperty = __class__
   override public func getClass() -> PyType {
     return self.type
   }

   // sourcery: pyproperty = __dict__
   override public func getDict() -> PyDict {
     return self.__dict__
   }

  // sourcery: pystaticmethod = __new__
  override internal class func pyNew(type: PyType,
                                     args: [PyObject],
                                     kwargs: PyDict?) -> PyResult<PyBaseException> {
    let argsTuple = Py.newTuple(args)
    return .value(PyTimeoutError(args: argsTuple, type: type))
  }

  // sourcery: pymethod = __init__
  override internal func pyInit(args: [PyObject], kwargs: PyDict?) -> PyResult<PyNone> {
    return super.pyInit(args: args, kwargs: kwargs)
  }
}

// MARK: - ReferenceError

// sourcery: pyerrortype = ReferenceError, default, baseType, hasGC, baseExceptionSubclass
public final class PyReferenceError: PyException {

  override internal class var doc: String {
    return "Weak ref proxy used after referent went away."
  }

  override public var description: String {
    let msg = self.message.map { "msg: \($0)" } ?? ""
    return "PyReferenceError(\(msg))"
  }

  /// Type to set in `init`.
  override internal class var pythonType: PyType {
    return Py.errorTypes.referenceError
  }

   // sourcery: pyproperty = __class__
   override public func getClass() -> PyType {
     return self.type
   }

   // sourcery: pyproperty = __dict__
   override public func getDict() -> PyDict {
     return self.__dict__
   }

  // sourcery: pystaticmethod = __new__
  override internal class func pyNew(type: PyType,
                                     args: [PyObject],
                                     kwargs: PyDict?) -> PyResult<PyBaseException> {
    let argsTuple = Py.newTuple(args)
    return .value(PyReferenceError(args: argsTuple, type: type))
  }

  // sourcery: pymethod = __init__
  override internal func pyInit(args: [PyObject], kwargs: PyDict?) -> PyResult<PyNone> {
    return super.pyInit(args: args, kwargs: kwargs)
  }
}

// MARK: - RuntimeError

// sourcery: pyerrortype = RuntimeError, default, baseType, hasGC, baseExceptionSubclass
public class PyRuntimeError: PyException {

  override internal class var doc: String {
    return "Unspecified run-time error."
  }

  override public var description: String {
    let msg = self.message.map { "msg: \($0)" } ?? ""
    return "PyRuntimeError(\(msg))"
  }

  /// Type to set in `init`.
  override internal class var pythonType: PyType {
    return Py.errorTypes.runtimeError
  }

   // sourcery: pyproperty = __class__
   override public func getClass() -> PyType {
     return self.type
   }

   // sourcery: pyproperty = __dict__
   override public func getDict() -> PyDict {
     return self.__dict__
   }

  // sourcery: pystaticmethod = __new__
  override internal class func pyNew(type: PyType,
                                     args: [PyObject],
                                     kwargs: PyDict?) -> PyResult<PyBaseException> {
    let argsTuple = Py.newTuple(args)
    return .value(PyRuntimeError(args: argsTuple, type: type))
  }

  // sourcery: pymethod = __init__
  override internal func pyInit(args: [PyObject], kwargs: PyDict?) -> PyResult<PyNone> {
    return super.pyInit(args: args, kwargs: kwargs)
  }
}

// MARK: - NotImplementedError

// sourcery: pyerrortype = NotImplementedError, default, baseType, hasGC, baseExceptionSubclass
public final class PyNotImplementedError: PyRuntimeError {

  override internal class var doc: String {
    return "Method or function hasn't been implemented yet."
  }

  override public var description: String {
    let msg = self.message.map { "msg: \($0)" } ?? ""
    return "PyNotImplementedError(\(msg))"
  }

  /// Type to set in `init`.
  override internal class var pythonType: PyType {
    return Py.errorTypes.notImplementedError
  }

   // sourcery: pyproperty = __class__
   override public func getClass() -> PyType {
     return self.type
   }

   // sourcery: pyproperty = __dict__
   override public func getDict() -> PyDict {
     return self.__dict__
   }

  // sourcery: pystaticmethod = __new__
  override internal class func pyNew(type: PyType,
                                     args: [PyObject],
                                     kwargs: PyDict?) -> PyResult<PyBaseException> {
    let argsTuple = Py.newTuple(args)
    return .value(PyNotImplementedError(args: argsTuple, type: type))
  }

  // sourcery: pymethod = __init__
  override internal func pyInit(args: [PyObject], kwargs: PyDict?) -> PyResult<PyNone> {
    return super.pyInit(args: args, kwargs: kwargs)
  }
}

// MARK: - RecursionError

// sourcery: pyerrortype = RecursionError, default, baseType, hasGC, baseExceptionSubclass
public final class PyRecursionError: PyRuntimeError {

  override internal class var doc: String {
    return "Recursion limit exceeded."
  }

  override public var description: String {
    let msg = self.message.map { "msg: \($0)" } ?? ""
    return "PyRecursionError(\(msg))"
  }

  /// Type to set in `init`.
  override internal class var pythonType: PyType {
    return Py.errorTypes.recursionError
  }

   // sourcery: pyproperty = __class__
   override public func getClass() -> PyType {
     return self.type
   }

   // sourcery: pyproperty = __dict__
   override public func getDict() -> PyDict {
     return self.__dict__
   }

  // sourcery: pystaticmethod = __new__
  override internal class func pyNew(type: PyType,
                                     args: [PyObject],
                                     kwargs: PyDict?) -> PyResult<PyBaseException> {
    let argsTuple = Py.newTuple(args)
    return .value(PyRecursionError(args: argsTuple, type: type))
  }

  // sourcery: pymethod = __init__
  override internal func pyInit(args: [PyObject], kwargs: PyDict?) -> PyResult<PyNone> {
    return super.pyInit(args: args, kwargs: kwargs)
  }
}

// MARK: - SyntaxError

// sourcery: pyerrortype = SyntaxError, default, baseType, hasGC, baseExceptionSubclass
public class PySyntaxError: PyException {

  override internal class var doc: String {
    return "Invalid syntax."
  }

  override public var description: String {
    let msg = self.message.map { "msg: \($0)" } ?? ""
    return "PySyntaxError(\(msg))"
  }

  /// Type to set in `init`.
  override internal class var pythonType: PyType {
    return Py.errorTypes.syntaxError
  }

   // sourcery: pyproperty = __class__
   override public func getClass() -> PyType {
     return self.type
   }

   // sourcery: pyproperty = __dict__
   override public func getDict() -> PyDict {
     return self.__dict__
   }

  // sourcery: pystaticmethod = __new__
  override internal class func pyNew(type: PyType,
                                     args: [PyObject],
                                     kwargs: PyDict?) -> PyResult<PyBaseException> {
    let argsTuple = Py.newTuple(args)
    return .value(PySyntaxError(args: argsTuple, type: type))
  }

  // sourcery: pymethod = __init__
  override internal func pyInit(args: [PyObject], kwargs: PyDict?) -> PyResult<PyNone> {
    return super.pyInit(args: args, kwargs: kwargs)
  }
}

// MARK: - IndentationError

// sourcery: pyerrortype = IndentationError, default, baseType, hasGC, baseExceptionSubclass
public class PyIndentationError: PySyntaxError {

  override internal class var doc: String {
    return "Improper indentation."
  }

  override public var description: String {
    let msg = self.message.map { "msg: \($0)" } ?? ""
    return "PyIndentationError(\(msg))"
  }

  /// Type to set in `init`.
  override internal class var pythonType: PyType {
    return Py.errorTypes.indentationError
  }

   // sourcery: pyproperty = __class__
   override public func getClass() -> PyType {
     return self.type
   }

   // sourcery: pyproperty = __dict__
   override public func getDict() -> PyDict {
     return self.__dict__
   }

  // sourcery: pystaticmethod = __new__
  override internal class func pyNew(type: PyType,
                                     args: [PyObject],
                                     kwargs: PyDict?) -> PyResult<PyBaseException> {
    let argsTuple = Py.newTuple(args)
    return .value(PyIndentationError(args: argsTuple, type: type))
  }

  // sourcery: pymethod = __init__
  override internal func pyInit(args: [PyObject], kwargs: PyDict?) -> PyResult<PyNone> {
    return super.pyInit(args: args, kwargs: kwargs)
  }
}

// MARK: - TabError

// sourcery: pyerrortype = TabError, default, baseType, hasGC, baseExceptionSubclass
public final class PyTabError: PyIndentationError {

  override internal class var doc: String {
    return "Improper mixture of spaces and tabs."
  }

  override public var description: String {
    let msg = self.message.map { "msg: \($0)" } ?? ""
    return "PyTabError(\(msg))"
  }

  /// Type to set in `init`.
  override internal class var pythonType: PyType {
    return Py.errorTypes.tabError
  }

   // sourcery: pyproperty = __class__
   override public func getClass() -> PyType {
     return self.type
   }

   // sourcery: pyproperty = __dict__
   override public func getDict() -> PyDict {
     return self.__dict__
   }

  // sourcery: pystaticmethod = __new__
  override internal class func pyNew(type: PyType,
                                     args: [PyObject],
                                     kwargs: PyDict?) -> PyResult<PyBaseException> {
    let argsTuple = Py.newTuple(args)
    return .value(PyTabError(args: argsTuple, type: type))
  }

  // sourcery: pymethod = __init__
  override internal func pyInit(args: [PyObject], kwargs: PyDict?) -> PyResult<PyNone> {
    return super.pyInit(args: args, kwargs: kwargs)
  }
}

// MARK: - SystemError

// sourcery: pyerrortype = SystemError, default, baseType, hasGC, baseExceptionSubclass
public final class PySystemError: PyException {

  override internal class var doc: String {
    return "Internal error in the Python interpreter. " +
" " +
"Please report this to the Python maintainer, along with the traceback, " +
"the Python version, and the hardware/OS platform and version."
  }

  override public var description: String {
    let msg = self.message.map { "msg: \($0)" } ?? ""
    return "PySystemError(\(msg))"
  }

  /// Type to set in `init`.
  override internal class var pythonType: PyType {
    return Py.errorTypes.systemError
  }

   // sourcery: pyproperty = __class__
   override public func getClass() -> PyType {
     return self.type
   }

   // sourcery: pyproperty = __dict__
   override public func getDict() -> PyDict {
     return self.__dict__
   }

  // sourcery: pystaticmethod = __new__
  override internal class func pyNew(type: PyType,
                                     args: [PyObject],
                                     kwargs: PyDict?) -> PyResult<PyBaseException> {
    let argsTuple = Py.newTuple(args)
    return .value(PySystemError(args: argsTuple, type: type))
  }

  // sourcery: pymethod = __init__
  override internal func pyInit(args: [PyObject], kwargs: PyDict?) -> PyResult<PyNone> {
    return super.pyInit(args: args, kwargs: kwargs)
  }
}

// MARK: - TypeError

// sourcery: pyerrortype = TypeError, default, baseType, hasGC, baseExceptionSubclass
public final class PyTypeError: PyException {

  override internal class var doc: String {
    return "Inappropriate argument type."
  }

  override public var description: String {
    let msg = self.message.map { "msg: \($0)" } ?? ""
    return "PyTypeError(\(msg))"
  }

  /// Type to set in `init`.
  override internal class var pythonType: PyType {
    return Py.errorTypes.typeError
  }

   // sourcery: pyproperty = __class__
   override public func getClass() -> PyType {
     return self.type
   }

   // sourcery: pyproperty = __dict__
   override public func getDict() -> PyDict {
     return self.__dict__
   }

  // sourcery: pystaticmethod = __new__
  override internal class func pyNew(type: PyType,
                                     args: [PyObject],
                                     kwargs: PyDict?) -> PyResult<PyBaseException> {
    let argsTuple = Py.newTuple(args)
    return .value(PyTypeError(args: argsTuple, type: type))
  }

  // sourcery: pymethod = __init__
  override internal func pyInit(args: [PyObject], kwargs: PyDict?) -> PyResult<PyNone> {
    return super.pyInit(args: args, kwargs: kwargs)
  }
}

// MARK: - ValueError

// sourcery: pyerrortype = ValueError, default, baseType, hasGC, baseExceptionSubclass
public class PyValueError: PyException {

  override internal class var doc: String {
    return "Inappropriate argument value (of correct type)."
  }

  override public var description: String {
    let msg = self.message.map { "msg: \($0)" } ?? ""
    return "PyValueError(\(msg))"
  }

  /// Type to set in `init`.
  override internal class var pythonType: PyType {
    return Py.errorTypes.valueError
  }

   // sourcery: pyproperty = __class__
   override public func getClass() -> PyType {
     return self.type
   }

   // sourcery: pyproperty = __dict__
   override public func getDict() -> PyDict {
     return self.__dict__
   }

  // sourcery: pystaticmethod = __new__
  override internal class func pyNew(type: PyType,
                                     args: [PyObject],
                                     kwargs: PyDict?) -> PyResult<PyBaseException> {
    let argsTuple = Py.newTuple(args)
    return .value(PyValueError(args: argsTuple, type: type))
  }

  // sourcery: pymethod = __init__
  override internal func pyInit(args: [PyObject], kwargs: PyDict?) -> PyResult<PyNone> {
    return super.pyInit(args: args, kwargs: kwargs)
  }
}

// MARK: - UnicodeError

// sourcery: pyerrortype = UnicodeError, default, baseType, hasGC, baseExceptionSubclass
public class PyUnicodeError: PyValueError {

  override internal class var doc: String {
    return "Unicode related error."
  }

  override public var description: String {
    let msg = self.message.map { "msg: \($0)" } ?? ""
    return "PyUnicodeError(\(msg))"
  }

  /// Type to set in `init`.
  override internal class var pythonType: PyType {
    return Py.errorTypes.unicodeError
  }

   // sourcery: pyproperty = __class__
   override public func getClass() -> PyType {
     return self.type
   }

   // sourcery: pyproperty = __dict__
   override public func getDict() -> PyDict {
     return self.__dict__
   }

  // sourcery: pystaticmethod = __new__
  override internal class func pyNew(type: PyType,
                                     args: [PyObject],
                                     kwargs: PyDict?) -> PyResult<PyBaseException> {
    let argsTuple = Py.newTuple(args)
    return .value(PyUnicodeError(args: argsTuple, type: type))
  }

  // sourcery: pymethod = __init__
  override internal func pyInit(args: [PyObject], kwargs: PyDict?) -> PyResult<PyNone> {
    return super.pyInit(args: args, kwargs: kwargs)
  }
}

// MARK: - UnicodeDecodeError

// sourcery: pyerrortype = UnicodeDecodeError, default, baseType, hasGC, baseExceptionSubclass
public final class PyUnicodeDecodeError: PyUnicodeError {

  override internal class var doc: String {
    return "Unicode decoding error."
  }

  override public var description: String {
    let msg = self.message.map { "msg: \($0)" } ?? ""
    return "PyUnicodeDecodeError(\(msg))"
  }

  /// Type to set in `init`.
  override internal class var pythonType: PyType {
    return Py.errorTypes.unicodeDecodeError
  }

   // sourcery: pyproperty = __class__
   override public func getClass() -> PyType {
     return self.type
   }

   // sourcery: pyproperty = __dict__
   override public func getDict() -> PyDict {
     return self.__dict__
   }

  // sourcery: pystaticmethod = __new__
  override internal class func pyNew(type: PyType,
                                     args: [PyObject],
                                     kwargs: PyDict?) -> PyResult<PyBaseException> {
    let argsTuple = Py.newTuple(args)
    return .value(PyUnicodeDecodeError(args: argsTuple, type: type))
  }

  // sourcery: pymethod = __init__
  override internal func pyInit(args: [PyObject], kwargs: PyDict?) -> PyResult<PyNone> {
    return super.pyInit(args: args, kwargs: kwargs)
  }
}

// MARK: - UnicodeEncodeError

// sourcery: pyerrortype = UnicodeEncodeError, default, baseType, hasGC, baseExceptionSubclass
public final class PyUnicodeEncodeError: PyUnicodeError {

  override internal class var doc: String {
    return "Unicode encoding error."
  }

  override public var description: String {
    let msg = self.message.map { "msg: \($0)" } ?? ""
    return "PyUnicodeEncodeError(\(msg))"
  }

  /// Type to set in `init`.
  override internal class var pythonType: PyType {
    return Py.errorTypes.unicodeEncodeError
  }

   // sourcery: pyproperty = __class__
   override public func getClass() -> PyType {
     return self.type
   }

   // sourcery: pyproperty = __dict__
   override public func getDict() -> PyDict {
     return self.__dict__
   }

  // sourcery: pystaticmethod = __new__
  override internal class func pyNew(type: PyType,
                                     args: [PyObject],
                                     kwargs: PyDict?) -> PyResult<PyBaseException> {
    let argsTuple = Py.newTuple(args)
    return .value(PyUnicodeEncodeError(args: argsTuple, type: type))
  }

  // sourcery: pymethod = __init__
  override internal func pyInit(args: [PyObject], kwargs: PyDict?) -> PyResult<PyNone> {
    return super.pyInit(args: args, kwargs: kwargs)
  }
}

// MARK: - UnicodeTranslateError

// sourcery: pyerrortype = UnicodeTranslateError, default, baseType, hasGC, baseExceptionSubclass
public final class PyUnicodeTranslateError: PyUnicodeError {

  override internal class var doc: String {
    return "Unicode translation error."
  }

  override public var description: String {
    let msg = self.message.map { "msg: \($0)" } ?? ""
    return "PyUnicodeTranslateError(\(msg))"
  }

  /// Type to set in `init`.
  override internal class var pythonType: PyType {
    return Py.errorTypes.unicodeTranslateError
  }

   // sourcery: pyproperty = __class__
   override public func getClass() -> PyType {
     return self.type
   }

   // sourcery: pyproperty = __dict__
   override public func getDict() -> PyDict {
     return self.__dict__
   }

  // sourcery: pystaticmethod = __new__
  override internal class func pyNew(type: PyType,
                                     args: [PyObject],
                                     kwargs: PyDict?) -> PyResult<PyBaseException> {
    let argsTuple = Py.newTuple(args)
    return .value(PyUnicodeTranslateError(args: argsTuple, type: type))
  }

  // sourcery: pymethod = __init__
  override internal func pyInit(args: [PyObject], kwargs: PyDict?) -> PyResult<PyNone> {
    return super.pyInit(args: args, kwargs: kwargs)
  }
}

// MARK: - Warning

// sourcery: pyerrortype = Warning, default, baseType, hasGC, baseExceptionSubclass
public class PyWarning: PyException {

  override internal class var doc: String {
    return "Base class for warning categories."
  }

  override public var description: String {
    let msg = self.message.map { "msg: \($0)" } ?? ""
    return "PyWarning(\(msg))"
  }

  /// Type to set in `init`.
  override internal class var pythonType: PyType {
    return Py.errorTypes.warning
  }

   // sourcery: pyproperty = __class__
   override public func getClass() -> PyType {
     return self.type
   }

   // sourcery: pyproperty = __dict__
   override public func getDict() -> PyDict {
     return self.__dict__
   }

  // sourcery: pystaticmethod = __new__
  override internal class func pyNew(type: PyType,
                                     args: [PyObject],
                                     kwargs: PyDict?) -> PyResult<PyBaseException> {
    let argsTuple = Py.newTuple(args)
    return .value(PyWarning(args: argsTuple, type: type))
  }

  // sourcery: pymethod = __init__
  override internal func pyInit(args: [PyObject], kwargs: PyDict?) -> PyResult<PyNone> {
    return super.pyInit(args: args, kwargs: kwargs)
  }
}

// MARK: - DeprecationWarning

// sourcery: pyerrortype = DeprecationWarning, default, baseType, hasGC, baseExceptionSubclass
public final class PyDeprecationWarning: PyWarning {

  override internal class var doc: String {
    return "Base class for warnings about deprecated features."
  }

  override public var description: String {
    let msg = self.message.map { "msg: \($0)" } ?? ""
    return "PyDeprecationWarning(\(msg))"
  }

  /// Type to set in `init`.
  override internal class var pythonType: PyType {
    return Py.errorTypes.deprecationWarning
  }

   // sourcery: pyproperty = __class__
   override public func getClass() -> PyType {
     return self.type
   }

   // sourcery: pyproperty = __dict__
   override public func getDict() -> PyDict {
     return self.__dict__
   }

  // sourcery: pystaticmethod = __new__
  override internal class func pyNew(type: PyType,
                                     args: [PyObject],
                                     kwargs: PyDict?) -> PyResult<PyBaseException> {
    let argsTuple = Py.newTuple(args)
    return .value(PyDeprecationWarning(args: argsTuple, type: type))
  }

  // sourcery: pymethod = __init__
  override internal func pyInit(args: [PyObject], kwargs: PyDict?) -> PyResult<PyNone> {
    return super.pyInit(args: args, kwargs: kwargs)
  }
}

// MARK: - PendingDeprecationWarning

// sourcery: pyerrortype = PendingDeprecationWarning, default, baseType, hasGC, baseExceptionSubclass
public final class PyPendingDeprecationWarning: PyWarning {

  override internal class var doc: String {
    return "Base class for warnings about features which will be deprecated " +
"in the future."
  }

  override public var description: String {
    let msg = self.message.map { "msg: \($0)" } ?? ""
    return "PyPendingDeprecationWarning(\(msg))"
  }

  /// Type to set in `init`.
  override internal class var pythonType: PyType {
    return Py.errorTypes.pendingDeprecationWarning
  }

   // sourcery: pyproperty = __class__
   override public func getClass() -> PyType {
     return self.type
   }

   // sourcery: pyproperty = __dict__
   override public func getDict() -> PyDict {
     return self.__dict__
   }

  // sourcery: pystaticmethod = __new__
  override internal class func pyNew(type: PyType,
                                     args: [PyObject],
                                     kwargs: PyDict?) -> PyResult<PyBaseException> {
    let argsTuple = Py.newTuple(args)
    return .value(PyPendingDeprecationWarning(args: argsTuple, type: type))
  }

  // sourcery: pymethod = __init__
  override internal func pyInit(args: [PyObject], kwargs: PyDict?) -> PyResult<PyNone> {
    return super.pyInit(args: args, kwargs: kwargs)
  }
}

// MARK: - RuntimeWarning

// sourcery: pyerrortype = RuntimeWarning, default, baseType, hasGC, baseExceptionSubclass
public final class PyRuntimeWarning: PyWarning {

  override internal class var doc: String {
    return "Base class for warnings about dubious runtime behavior."
  }

  override public var description: String {
    let msg = self.message.map { "msg: \($0)" } ?? ""
    return "PyRuntimeWarning(\(msg))"
  }

  /// Type to set in `init`.
  override internal class var pythonType: PyType {
    return Py.errorTypes.runtimeWarning
  }

   // sourcery: pyproperty = __class__
   override public func getClass() -> PyType {
     return self.type
   }

   // sourcery: pyproperty = __dict__
   override public func getDict() -> PyDict {
     return self.__dict__
   }

  // sourcery: pystaticmethod = __new__
  override internal class func pyNew(type: PyType,
                                     args: [PyObject],
                                     kwargs: PyDict?) -> PyResult<PyBaseException> {
    let argsTuple = Py.newTuple(args)
    return .value(PyRuntimeWarning(args: argsTuple, type: type))
  }

  // sourcery: pymethod = __init__
  override internal func pyInit(args: [PyObject], kwargs: PyDict?) -> PyResult<PyNone> {
    return super.pyInit(args: args, kwargs: kwargs)
  }
}

// MARK: - SyntaxWarning

// sourcery: pyerrortype = SyntaxWarning, default, baseType, hasGC, baseExceptionSubclass
public final class PySyntaxWarning: PyWarning {

  override internal class var doc: String {
    return "Base class for warnings about dubious syntax."
  }

  override public var description: String {
    let msg = self.message.map { "msg: \($0)" } ?? ""
    return "PySyntaxWarning(\(msg))"
  }

  /// Type to set in `init`.
  override internal class var pythonType: PyType {
    return Py.errorTypes.syntaxWarning
  }

   // sourcery: pyproperty = __class__
   override public func getClass() -> PyType {
     return self.type
   }

   // sourcery: pyproperty = __dict__
   override public func getDict() -> PyDict {
     return self.__dict__
   }

  // sourcery: pystaticmethod = __new__
  override internal class func pyNew(type: PyType,
                                     args: [PyObject],
                                     kwargs: PyDict?) -> PyResult<PyBaseException> {
    let argsTuple = Py.newTuple(args)
    return .value(PySyntaxWarning(args: argsTuple, type: type))
  }

  // sourcery: pymethod = __init__
  override internal func pyInit(args: [PyObject], kwargs: PyDict?) -> PyResult<PyNone> {
    return super.pyInit(args: args, kwargs: kwargs)
  }
}

// MARK: - UserWarning

// sourcery: pyerrortype = UserWarning, default, baseType, hasGC, baseExceptionSubclass
public final class PyUserWarning: PyWarning {

  override internal class var doc: String {
    return "Base class for warnings generated by user code."
  }

  override public var description: String {
    let msg = self.message.map { "msg: \($0)" } ?? ""
    return "PyUserWarning(\(msg))"
  }

  /// Type to set in `init`.
  override internal class var pythonType: PyType {
    return Py.errorTypes.userWarning
  }

   // sourcery: pyproperty = __class__
   override public func getClass() -> PyType {
     return self.type
   }

   // sourcery: pyproperty = __dict__
   override public func getDict() -> PyDict {
     return self.__dict__
   }

  // sourcery: pystaticmethod = __new__
  override internal class func pyNew(type: PyType,
                                     args: [PyObject],
                                     kwargs: PyDict?) -> PyResult<PyBaseException> {
    let argsTuple = Py.newTuple(args)
    return .value(PyUserWarning(args: argsTuple, type: type))
  }

  // sourcery: pymethod = __init__
  override internal func pyInit(args: [PyObject], kwargs: PyDict?) -> PyResult<PyNone> {
    return super.pyInit(args: args, kwargs: kwargs)
  }
}

// MARK: - FutureWarning

// sourcery: pyerrortype = FutureWarning, default, baseType, hasGC, baseExceptionSubclass
public final class PyFutureWarning: PyWarning {

  override internal class var doc: String {
    return "Base class for warnings about constructs that will change semantically " +
"in the future."
  }

  override public var description: String {
    let msg = self.message.map { "msg: \($0)" } ?? ""
    return "PyFutureWarning(\(msg))"
  }

  /// Type to set in `init`.
  override internal class var pythonType: PyType {
    return Py.errorTypes.futureWarning
  }

   // sourcery: pyproperty = __class__
   override public func getClass() -> PyType {
     return self.type
   }

   // sourcery: pyproperty = __dict__
   override public func getDict() -> PyDict {
     return self.__dict__
   }

  // sourcery: pystaticmethod = __new__
  override internal class func pyNew(type: PyType,
                                     args: [PyObject],
                                     kwargs: PyDict?) -> PyResult<PyBaseException> {
    let argsTuple = Py.newTuple(args)
    return .value(PyFutureWarning(args: argsTuple, type: type))
  }

  // sourcery: pymethod = __init__
  override internal func pyInit(args: [PyObject], kwargs: PyDict?) -> PyResult<PyNone> {
    return super.pyInit(args: args, kwargs: kwargs)
  }
}

// MARK: - ImportWarning

// sourcery: pyerrortype = ImportWarning, default, baseType, hasGC, baseExceptionSubclass
public final class PyImportWarning: PyWarning {

  override internal class var doc: String {
    return "Base class for warnings about probable mistakes in module imports"
  }

  override public var description: String {
    let msg = self.message.map { "msg: \($0)" } ?? ""
    return "PyImportWarning(\(msg))"
  }

  /// Type to set in `init`.
  override internal class var pythonType: PyType {
    return Py.errorTypes.importWarning
  }

   // sourcery: pyproperty = __class__
   override public func getClass() -> PyType {
     return self.type
   }

   // sourcery: pyproperty = __dict__
   override public func getDict() -> PyDict {
     return self.__dict__
   }

  // sourcery: pystaticmethod = __new__
  override internal class func pyNew(type: PyType,
                                     args: [PyObject],
                                     kwargs: PyDict?) -> PyResult<PyBaseException> {
    let argsTuple = Py.newTuple(args)
    return .value(PyImportWarning(args: argsTuple, type: type))
  }

  // sourcery: pymethod = __init__
  override internal func pyInit(args: [PyObject], kwargs: PyDict?) -> PyResult<PyNone> {
    return super.pyInit(args: args, kwargs: kwargs)
  }
}

// MARK: - UnicodeWarning

// sourcery: pyerrortype = UnicodeWarning, default, baseType, hasGC, baseExceptionSubclass
public final class PyUnicodeWarning: PyWarning {

  override internal class var doc: String {
    return "Base class for warnings about Unicode related problems, mostly " +
"related to conversion problems."
  }

  override public var description: String {
    let msg = self.message.map { "msg: \($0)" } ?? ""
    return "PyUnicodeWarning(\(msg))"
  }

  /// Type to set in `init`.
  override internal class var pythonType: PyType {
    return Py.errorTypes.unicodeWarning
  }

   // sourcery: pyproperty = __class__
   override public func getClass() -> PyType {
     return self.type
   }

   // sourcery: pyproperty = __dict__
   override public func getDict() -> PyDict {
     return self.__dict__
   }

  // sourcery: pystaticmethod = __new__
  override internal class func pyNew(type: PyType,
                                     args: [PyObject],
                                     kwargs: PyDict?) -> PyResult<PyBaseException> {
    let argsTuple = Py.newTuple(args)
    return .value(PyUnicodeWarning(args: argsTuple, type: type))
  }

  // sourcery: pymethod = __init__
  override internal func pyInit(args: [PyObject], kwargs: PyDict?) -> PyResult<PyNone> {
    return super.pyInit(args: args, kwargs: kwargs)
  }
}

// MARK: - BytesWarning

// sourcery: pyerrortype = BytesWarning, default, baseType, hasGC, baseExceptionSubclass
public final class PyBytesWarning: PyWarning {

  override internal class var doc: String {
    return "Base class for warnings about bytes and buffer related problems, mostly " +
"related to conversion from str or comparing to str."
  }

  override public var description: String {
    let msg = self.message.map { "msg: \($0)" } ?? ""
    return "PyBytesWarning(\(msg))"
  }

  /// Type to set in `init`.
  override internal class var pythonType: PyType {
    return Py.errorTypes.bytesWarning
  }

   // sourcery: pyproperty = __class__
   override public func getClass() -> PyType {
     return self.type
   }

   // sourcery: pyproperty = __dict__
   override public func getDict() -> PyDict {
     return self.__dict__
   }

  // sourcery: pystaticmethod = __new__
  override internal class func pyNew(type: PyType,
                                     args: [PyObject],
                                     kwargs: PyDict?) -> PyResult<PyBaseException> {
    let argsTuple = Py.newTuple(args)
    return .value(PyBytesWarning(args: argsTuple, type: type))
  }

  // sourcery: pymethod = __init__
  override internal func pyInit(args: [PyObject], kwargs: PyDict?) -> PyResult<PyNone> {
    return super.pyInit(args: args, kwargs: kwargs)
  }
}

// MARK: - ResourceWarning

// sourcery: pyerrortype = ResourceWarning, default, baseType, hasGC, baseExceptionSubclass
public final class PyResourceWarning: PyWarning {

  override internal class var doc: String {
    return "Base class for warnings about resource usage."
  }

  override public var description: String {
    let msg = self.message.map { "msg: \($0)" } ?? ""
    return "PyResourceWarning(\(msg))"
  }

  /// Type to set in `init`.
  override internal class var pythonType: PyType {
    return Py.errorTypes.resourceWarning
  }

   // sourcery: pyproperty = __class__
   override public func getClass() -> PyType {
     return self.type
   }

   // sourcery: pyproperty = __dict__
   override public func getDict() -> PyDict {
     return self.__dict__
   }

  // sourcery: pystaticmethod = __new__
  override internal class func pyNew(type: PyType,
                                     args: [PyObject],
                                     kwargs: PyDict?) -> PyResult<PyBaseException> {
    let argsTuple = Py.newTuple(args)
    return .value(PyResourceWarning(args: argsTuple, type: type))
  }

  // sourcery: pymethod = __init__
  override internal func pyInit(args: [PyObject], kwargs: PyDict?) -> PyResult<PyNone> {
    return super.pyInit(args: args, kwargs: kwargs)
  }
}

