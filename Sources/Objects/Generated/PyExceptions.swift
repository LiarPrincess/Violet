// In CPython:
// Objects -> exceptions.c
// Lib->test->exception_hierarchy.txt <-- this is amazing
// https://docs.python.org/3.7/c-api/exceptions.html

// swiftlint:disable file_length
// swiftlint:disable trailing_newline

// MARK: - SystemExit

// sourcery: pyerrortype = SystemExit, default, baseType, hasGC
public final class PySystemExit: PyBaseException {

  override internal class var doc: String {
    return "Request to exit from the interpreter."
  }

  override internal func initType(from context: PyContext) {
    self.setType(to: context.builtins.errorTypes.systemExit)
  }

   // sourcery: pyproperty = __class__
   override internal func getClass() -> PyType {
     return self.type
   }

   // sourcery: pyproperty = __dict__
   override internal func getDict() -> Attributes {
     return self.attributes
   }
}

// MARK: - KeyboardInterrupt

// sourcery: pyerrortype = KeyboardInterrupt, default, baseType, hasGC
public final class PyKeyboardInterrupt: PyBaseException {

  override internal class var doc: String {
    return "Program interrupted by user."
  }

  override internal func initType(from context: PyContext) {
    self.setType(to: context.builtins.errorTypes.keyboardInterrupt)
  }

   // sourcery: pyproperty = __class__
   override internal func getClass() -> PyType {
     return self.type
   }

   // sourcery: pyproperty = __dict__
   override internal func getDict() -> Attributes {
     return self.attributes
   }
}

// MARK: - GeneratorExit

// sourcery: pyerrortype = GeneratorExit, default, baseType, hasGC
public final class PyGeneratorExit: PyBaseException {

  override internal class var doc: String {
    return "Request that a generator exit."
  }

  override internal func initType(from context: PyContext) {
    self.setType(to: context.builtins.errorTypes.generatorExit)
  }

   // sourcery: pyproperty = __class__
   override internal func getClass() -> PyType {
     return self.type
   }

   // sourcery: pyproperty = __dict__
   override internal func getDict() -> Attributes {
     return self.attributes
   }
}

// MARK: - Exception

// sourcery: pyerrortype = Exception, default, baseType, hasGC
public class PyException: PyBaseException {

  override internal class var doc: String {
    return "Common base class for all non-exit exceptions."
  }

  override internal func initType(from context: PyContext) {
    self.setType(to: context.builtins.errorTypes.exception)
  }

   // sourcery: pyproperty = __class__
   override internal func getClass() -> PyType {
     return self.type
   }

   // sourcery: pyproperty = __dict__
   override internal func getDict() -> Attributes {
     return self.attributes
   }
}

// MARK: - StopIteration

// sourcery: pyerrortype = StopIteration, default, baseType, hasGC
public final class PyStopIteration: PyException {

  override internal class var doc: String {
    return "Signal the end from iterator.__next__()."
  }

  override internal func initType(from context: PyContext) {
    self.setType(to: context.builtins.errorTypes.stopIteration)
  }

   // sourcery: pyproperty = __class__
   override internal func getClass() -> PyType {
     return self.type
   }

   // sourcery: pyproperty = __dict__
   override internal func getDict() -> Attributes {
     return self.attributes
   }
}

// MARK: - StopAsyncIteration

// sourcery: pyerrortype = StopAsyncIteration, default, baseType, hasGC
public final class PyStopAsyncIteration: PyException {

  override internal class var doc: String {
    return "Signal the end from iterator.__anext__()."
  }

  override internal func initType(from context: PyContext) {
    self.setType(to: context.builtins.errorTypes.stopAsyncIteration)
  }

   // sourcery: pyproperty = __class__
   override internal func getClass() -> PyType {
     return self.type
   }

   // sourcery: pyproperty = __dict__
   override internal func getDict() -> Attributes {
     return self.attributes
   }
}

// MARK: - ArithmeticError

// sourcery: pyerrortype = ArithmeticError, default, baseType, hasGC
public class PyArithmeticError: PyException {

  override internal class var doc: String {
    return "Base class for arithmetic errors."
  }

  override internal func initType(from context: PyContext) {
    self.setType(to: context.builtins.errorTypes.arithmeticError)
  }

   // sourcery: pyproperty = __class__
   override internal func getClass() -> PyType {
     return self.type
   }

   // sourcery: pyproperty = __dict__
   override internal func getDict() -> Attributes {
     return self.attributes
   }
}

// MARK: - FloatingPointError

// sourcery: pyerrortype = FloatingPointError, default, baseType, hasGC
public final class PyFloatingPointError: PyArithmeticError {

  override internal class var doc: String {
    return "Floating point operation failed."
  }

  override internal func initType(from context: PyContext) {
    self.setType(to: context.builtins.errorTypes.floatingPointError)
  }

   // sourcery: pyproperty = __class__
   override internal func getClass() -> PyType {
     return self.type
   }

   // sourcery: pyproperty = __dict__
   override internal func getDict() -> Attributes {
     return self.attributes
   }
}

// MARK: - OverflowError

// sourcery: pyerrortype = OverflowError, default, baseType, hasGC
public final class PyOverflowError: PyArithmeticError {

  override internal class var doc: String {
    return "Result too large to be represented."
  }

  override internal func initType(from context: PyContext) {
    self.setType(to: context.builtins.errorTypes.overflowError)
  }

   // sourcery: pyproperty = __class__
   override internal func getClass() -> PyType {
     return self.type
   }

   // sourcery: pyproperty = __dict__
   override internal func getDict() -> Attributes {
     return self.attributes
   }
}

// MARK: - ZeroDivisionError

// sourcery: pyerrortype = ZeroDivisionError, default, baseType, hasGC
public final class PyZeroDivisionError: PyArithmeticError {

  override internal class var doc: String {
    return "Second argument to a division or modulo operation was zero."
  }

  override internal func initType(from context: PyContext) {
    self.setType(to: context.builtins.errorTypes.zeroDivisionError)
  }

   // sourcery: pyproperty = __class__
   override internal func getClass() -> PyType {
     return self.type
   }

   // sourcery: pyproperty = __dict__
   override internal func getDict() -> Attributes {
     return self.attributes
   }
}

// MARK: - AssertionError

// sourcery: pyerrortype = AssertionError, default, baseType, hasGC
public final class PyAssertionError: PyException {

  override internal class var doc: String {
    return "Assertion failed."
  }

  override internal func initType(from context: PyContext) {
    self.setType(to: context.builtins.errorTypes.assertionError)
  }

   // sourcery: pyproperty = __class__
   override internal func getClass() -> PyType {
     return self.type
   }

   // sourcery: pyproperty = __dict__
   override internal func getDict() -> Attributes {
     return self.attributes
   }
}

// MARK: - AttributeError

// sourcery: pyerrortype = AttributeError, default, baseType, hasGC
public final class PyAttributeError: PyException {

  override internal class var doc: String {
    return "Attribute not found."
  }

  override internal func initType(from context: PyContext) {
    self.setType(to: context.builtins.errorTypes.attributeError)
  }

   // sourcery: pyproperty = __class__
   override internal func getClass() -> PyType {
     return self.type
   }

   // sourcery: pyproperty = __dict__
   override internal func getDict() -> Attributes {
     return self.attributes
   }
}

// MARK: - BufferError

// sourcery: pyerrortype = BufferError, default, baseType, hasGC
public final class PyBufferError: PyException {

  override internal class var doc: String {
    return "Buffer error."
  }

  override internal func initType(from context: PyContext) {
    self.setType(to: context.builtins.errorTypes.bufferError)
  }

   // sourcery: pyproperty = __class__
   override internal func getClass() -> PyType {
     return self.type
   }

   // sourcery: pyproperty = __dict__
   override internal func getDict() -> Attributes {
     return self.attributes
   }
}

// MARK: - EOFError

// sourcery: pyerrortype = EOFError, default, baseType, hasGC
public final class PyEOFError: PyException {

  override internal class var doc: String {
    return "Read beyond end of file."
  }

  override internal func initType(from context: PyContext) {
    self.setType(to: context.builtins.errorTypes.eofError)
  }

   // sourcery: pyproperty = __class__
   override internal func getClass() -> PyType {
     return self.type
   }

   // sourcery: pyproperty = __dict__
   override internal func getDict() -> Attributes {
     return self.attributes
   }
}

// MARK: - ImportError

// sourcery: pyerrortype = ImportError, default, baseType, hasGC
public class PyImportError: PyException {

  override internal class var doc: String {
    return "Import can't find module, or can't find name in module."
  }

  override internal func initType(from context: PyContext) {
    self.setType(to: context.builtins.errorTypes.importError)
  }

   // sourcery: pyproperty = __class__
   override internal func getClass() -> PyType {
     return self.type
   }

   // sourcery: pyproperty = __dict__
   override internal func getDict() -> Attributes {
     return self.attributes
   }
}

// MARK: - ModuleNotFoundError

// sourcery: pyerrortype = ModuleNotFoundError, default, baseType, hasGC
public final class PyModuleNotFoundError: PyImportError {

  override internal class var doc: String {
    return "Module not found."
  }

  override internal func initType(from context: PyContext) {
    self.setType(to: context.builtins.errorTypes.moduleNotFoundError)
  }

   // sourcery: pyproperty = __class__
   override internal func getClass() -> PyType {
     return self.type
   }

   // sourcery: pyproperty = __dict__
   override internal func getDict() -> Attributes {
     return self.attributes
   }
}

// MARK: - LookupError

// sourcery: pyerrortype = LookupError, default, baseType, hasGC
public class PyLookupError: PyException {

  override internal class var doc: String {
    return "Base class for lookup errors."
  }

  override internal func initType(from context: PyContext) {
    self.setType(to: context.builtins.errorTypes.lookupError)
  }

   // sourcery: pyproperty = __class__
   override internal func getClass() -> PyType {
     return self.type
   }

   // sourcery: pyproperty = __dict__
   override internal func getDict() -> Attributes {
     return self.attributes
   }
}

// MARK: - IndexError

// sourcery: pyerrortype = IndexError, default, baseType, hasGC
public final class PyIndexError: PyLookupError {

  override internal class var doc: String {
    return "Sequence index out of range."
  }

  override internal func initType(from context: PyContext) {
    self.setType(to: context.builtins.errorTypes.indexError)
  }

   // sourcery: pyproperty = __class__
   override internal func getClass() -> PyType {
     return self.type
   }

   // sourcery: pyproperty = __dict__
   override internal func getDict() -> Attributes {
     return self.attributes
   }
}

// MARK: - KeyError

// sourcery: pyerrortype = KeyError, default, baseType, hasGC
public final class PyKeyError: PyLookupError {

  override internal class var doc: String {
    return "Mapping key not found."
  }

  override internal func initType(from context: PyContext) {
    self.setType(to: context.builtins.errorTypes.keyError)
  }

   // sourcery: pyproperty = __class__
   override internal func getClass() -> PyType {
     return self.type
   }

   // sourcery: pyproperty = __dict__
   override internal func getDict() -> Attributes {
     return self.attributes
   }
}

// MARK: - MemoryError

// sourcery: pyerrortype = MemoryError, default, baseType, hasGC
public final class PyMemoryError: PyException {

  override internal class var doc: String {
    return "Out of memory."
  }

  override internal func initType(from context: PyContext) {
    self.setType(to: context.builtins.errorTypes.memoryError)
  }

   // sourcery: pyproperty = __class__
   override internal func getClass() -> PyType {
     return self.type
   }

   // sourcery: pyproperty = __dict__
   override internal func getDict() -> Attributes {
     return self.attributes
   }
}

// MARK: - NameError

// sourcery: pyerrortype = NameError, default, baseType, hasGC
public class PyNameError: PyException {

  override internal class var doc: String {
    return "Name not found globally."
  }

  override internal func initType(from context: PyContext) {
    self.setType(to: context.builtins.errorTypes.nameError)
  }

   // sourcery: pyproperty = __class__
   override internal func getClass() -> PyType {
     return self.type
   }

   // sourcery: pyproperty = __dict__
   override internal func getDict() -> Attributes {
     return self.attributes
   }
}

// MARK: - UnboundLocalError

// sourcery: pyerrortype = UnboundLocalError, default, baseType, hasGC
public final class PyUnboundLocalError: PyNameError {

  override internal class var doc: String {
    return "Local name referenced but not bound to a value."
  }

  override internal func initType(from context: PyContext) {
    self.setType(to: context.builtins.errorTypes.unboundLocalError)
  }

   // sourcery: pyproperty = __class__
   override internal func getClass() -> PyType {
     return self.type
   }

   // sourcery: pyproperty = __dict__
   override internal func getDict() -> Attributes {
     return self.attributes
   }
}

// MARK: - OSError

// sourcery: pyerrortype = OSError, default, baseType, hasGC
public class PyOSError: PyException {

  override internal class var doc: String {
    return "Base class for I/O related errors."
  }

  override internal func initType(from context: PyContext) {
    self.setType(to: context.builtins.errorTypes.osError)
  }

   // sourcery: pyproperty = __class__
   override internal func getClass() -> PyType {
     return self.type
   }

   // sourcery: pyproperty = __dict__
   override internal func getDict() -> Attributes {
     return self.attributes
   }
}

// MARK: - BlockingIOError

// sourcery: pyerrortype = BlockingIOError, default, baseType, hasGC
public final class PyBlockingIOError: PyOSError {

  override internal class var doc: String {
    return "I/O operation would block."
  }

  override internal func initType(from context: PyContext) {
    self.setType(to: context.builtins.errorTypes.blockingIOError)
  }

   // sourcery: pyproperty = __class__
   override internal func getClass() -> PyType {
     return self.type
   }

   // sourcery: pyproperty = __dict__
   override internal func getDict() -> Attributes {
     return self.attributes
   }
}

// MARK: - ChildProcessError

// sourcery: pyerrortype = ChildProcessError, default, baseType, hasGC
public final class PyChildProcessError: PyOSError {

  override internal class var doc: String {
    return "Child process error."
  }

  override internal func initType(from context: PyContext) {
    self.setType(to: context.builtins.errorTypes.childProcessError)
  }

   // sourcery: pyproperty = __class__
   override internal func getClass() -> PyType {
     return self.type
   }

   // sourcery: pyproperty = __dict__
   override internal func getDict() -> Attributes {
     return self.attributes
   }
}

// MARK: - ConnectionError

// sourcery: pyerrortype = ConnectionError, default, baseType, hasGC
public class PyConnectionError: PyOSError {

  override internal class var doc: String {
    return "Connection error."
  }

  override internal func initType(from context: PyContext) {
    self.setType(to: context.builtins.errorTypes.connectionError)
  }

   // sourcery: pyproperty = __class__
   override internal func getClass() -> PyType {
     return self.type
   }

   // sourcery: pyproperty = __dict__
   override internal func getDict() -> Attributes {
     return self.attributes
   }
}

// MARK: - BrokenPipeError

// sourcery: pyerrortype = BrokenPipeError, default, baseType, hasGC
public final class PyBrokenPipeError: PyConnectionError {

  override internal class var doc: String {
    return "Broken pipe."
  }

  override internal func initType(from context: PyContext) {
    self.setType(to: context.builtins.errorTypes.brokenPipeError)
  }

   // sourcery: pyproperty = __class__
   override internal func getClass() -> PyType {
     return self.type
   }

   // sourcery: pyproperty = __dict__
   override internal func getDict() -> Attributes {
     return self.attributes
   }
}

// MARK: - ConnectionAbortedError

// sourcery: pyerrortype = ConnectionAbortedError, default, baseType, hasGC
public final class PyConnectionAbortedError: PyConnectionError {

  override internal class var doc: String {
    return "Connection aborted."
  }

  override internal func initType(from context: PyContext) {
    self.setType(to: context.builtins.errorTypes.connectionAbortedError)
  }

   // sourcery: pyproperty = __class__
   override internal func getClass() -> PyType {
     return self.type
   }

   // sourcery: pyproperty = __dict__
   override internal func getDict() -> Attributes {
     return self.attributes
   }
}

// MARK: - ConnectionRefusedError

// sourcery: pyerrortype = ConnectionRefusedError, default, baseType, hasGC
public final class PyConnectionRefusedError: PyConnectionError {

  override internal class var doc: String {
    return "Connection refused."
  }

  override internal func initType(from context: PyContext) {
    self.setType(to: context.builtins.errorTypes.connectionRefusedError)
  }

   // sourcery: pyproperty = __class__
   override internal func getClass() -> PyType {
     return self.type
   }

   // sourcery: pyproperty = __dict__
   override internal func getDict() -> Attributes {
     return self.attributes
   }
}

// MARK: - ConnectionResetError

// sourcery: pyerrortype = ConnectionResetError, default, baseType, hasGC
public final class PyConnectionResetError: PyConnectionError {

  override internal class var doc: String {
    return "Connection reset."
  }

  override internal func initType(from context: PyContext) {
    self.setType(to: context.builtins.errorTypes.connectionResetError)
  }

   // sourcery: pyproperty = __class__
   override internal func getClass() -> PyType {
     return self.type
   }

   // sourcery: pyproperty = __dict__
   override internal func getDict() -> Attributes {
     return self.attributes
   }
}

// MARK: - FileExistsError

// sourcery: pyerrortype = FileExistsError, default, baseType, hasGC
public final class PyFileExistsError: PyOSError {

  override internal class var doc: String {
    return "File already exists."
  }

  override internal func initType(from context: PyContext) {
    self.setType(to: context.builtins.errorTypes.fileExistsError)
  }

   // sourcery: pyproperty = __class__
   override internal func getClass() -> PyType {
     return self.type
   }

   // sourcery: pyproperty = __dict__
   override internal func getDict() -> Attributes {
     return self.attributes
   }
}

// MARK: - FileNotFoundError

// sourcery: pyerrortype = FileNotFoundError, default, baseType, hasGC
public final class PyFileNotFoundError: PyOSError {

  override internal class var doc: String {
    return "File not found."
  }

  override internal func initType(from context: PyContext) {
    self.setType(to: context.builtins.errorTypes.fileNotFoundError)
  }

   // sourcery: pyproperty = __class__
   override internal func getClass() -> PyType {
     return self.type
   }

   // sourcery: pyproperty = __dict__
   override internal func getDict() -> Attributes {
     return self.attributes
   }
}

// MARK: - InterruptedError

// sourcery: pyerrortype = InterruptedError, default, baseType, hasGC
public final class PyInterruptedError: PyOSError {

  override internal class var doc: String {
    return "Interrupted by signal."
  }

  override internal func initType(from context: PyContext) {
    self.setType(to: context.builtins.errorTypes.interruptedError)
  }

   // sourcery: pyproperty = __class__
   override internal func getClass() -> PyType {
     return self.type
   }

   // sourcery: pyproperty = __dict__
   override internal func getDict() -> Attributes {
     return self.attributes
   }
}

// MARK: - IsADirectoryError

// sourcery: pyerrortype = IsADirectoryError, default, baseType, hasGC
public final class PyIsADirectoryError: PyOSError {

  override internal class var doc: String {
    return "Operation doesn't work on directories."
  }

  override internal func initType(from context: PyContext) {
    self.setType(to: context.builtins.errorTypes.isADirectoryError)
  }

   // sourcery: pyproperty = __class__
   override internal func getClass() -> PyType {
     return self.type
   }

   // sourcery: pyproperty = __dict__
   override internal func getDict() -> Attributes {
     return self.attributes
   }
}

// MARK: - NotADirectoryError

// sourcery: pyerrortype = NotADirectoryError, default, baseType, hasGC
public final class PyNotADirectoryError: PyOSError {

  override internal class var doc: String {
    return "Operation only works on directories."
  }

  override internal func initType(from context: PyContext) {
    self.setType(to: context.builtins.errorTypes.notADirectoryError)
  }

   // sourcery: pyproperty = __class__
   override internal func getClass() -> PyType {
     return self.type
   }

   // sourcery: pyproperty = __dict__
   override internal func getDict() -> Attributes {
     return self.attributes
   }
}

// MARK: - PermissionError

// sourcery: pyerrortype = PermissionError, default, baseType, hasGC
public final class PyPermissionError: PyOSError {

  override internal class var doc: String {
    return "Not enough permissions."
  }

  override internal func initType(from context: PyContext) {
    self.setType(to: context.builtins.errorTypes.permissionError)
  }

   // sourcery: pyproperty = __class__
   override internal func getClass() -> PyType {
     return self.type
   }

   // sourcery: pyproperty = __dict__
   override internal func getDict() -> Attributes {
     return self.attributes
   }
}

// MARK: - ProcessLookupError

// sourcery: pyerrortype = ProcessLookupError, default, baseType, hasGC
public final class PyProcessLookupError: PyOSError {

  override internal class var doc: String {
    return "Process not found."
  }

  override internal func initType(from context: PyContext) {
    self.setType(to: context.builtins.errorTypes.processLookupError)
  }

   // sourcery: pyproperty = __class__
   override internal func getClass() -> PyType {
     return self.type
   }

   // sourcery: pyproperty = __dict__
   override internal func getDict() -> Attributes {
     return self.attributes
   }
}

// MARK: - TimeoutError

// sourcery: pyerrortype = TimeoutError, default, baseType, hasGC
public final class PyTimeoutError: PyOSError {

  override internal class var doc: String {
    return "Timeout expired."
  }

  override internal func initType(from context: PyContext) {
    self.setType(to: context.builtins.errorTypes.timeoutError)
  }

   // sourcery: pyproperty = __class__
   override internal func getClass() -> PyType {
     return self.type
   }

   // sourcery: pyproperty = __dict__
   override internal func getDict() -> Attributes {
     return self.attributes
   }
}

// MARK: - ReferenceError

// sourcery: pyerrortype = ReferenceError, default, baseType, hasGC
public final class PyReferenceError: PyException {

  override internal class var doc: String {
    return "Weak ref proxy used after referent went away."
  }

  override internal func initType(from context: PyContext) {
    self.setType(to: context.builtins.errorTypes.referenceError)
  }

   // sourcery: pyproperty = __class__
   override internal func getClass() -> PyType {
     return self.type
   }

   // sourcery: pyproperty = __dict__
   override internal func getDict() -> Attributes {
     return self.attributes
   }
}

// MARK: - RuntimeError

// sourcery: pyerrortype = RuntimeError, default, baseType, hasGC
public class PyRuntimeError: PyException {

  override internal class var doc: String {
    return "Unspecified run-time error."
  }

  override internal func initType(from context: PyContext) {
    self.setType(to: context.builtins.errorTypes.runtimeError)
  }

   // sourcery: pyproperty = __class__
   override internal func getClass() -> PyType {
     return self.type
   }

   // sourcery: pyproperty = __dict__
   override internal func getDict() -> Attributes {
     return self.attributes
   }
}

// MARK: - NotImplementedError

// sourcery: pyerrortype = NotImplementedError, default, baseType, hasGC
public final class PyNotImplementedError: PyRuntimeError {

  override internal class var doc: String {
    return "Method or function hasn't been implemented yet."
  }

  override internal func initType(from context: PyContext) {
    self.setType(to: context.builtins.errorTypes.notImplementedError)
  }

   // sourcery: pyproperty = __class__
   override internal func getClass() -> PyType {
     return self.type
   }

   // sourcery: pyproperty = __dict__
   override internal func getDict() -> Attributes {
     return self.attributes
   }
}

// MARK: - RecursionError

// sourcery: pyerrortype = RecursionError, default, baseType, hasGC
public final class PyRecursionError: PyRuntimeError {

  override internal class var doc: String {
    return "Recursion limit exceeded."
  }

  override internal func initType(from context: PyContext) {
    self.setType(to: context.builtins.errorTypes.recursionError)
  }

   // sourcery: pyproperty = __class__
   override internal func getClass() -> PyType {
     return self.type
   }

   // sourcery: pyproperty = __dict__
   override internal func getDict() -> Attributes {
     return self.attributes
   }
}

// MARK: - SyntaxError

// sourcery: pyerrortype = SyntaxError, default, baseType, hasGC
public class PySyntaxError: PyException {

  override internal class var doc: String {
    return "Invalid syntax."
  }

  override internal func initType(from context: PyContext) {
    self.setType(to: context.builtins.errorTypes.syntaxError)
  }

   // sourcery: pyproperty = __class__
   override internal func getClass() -> PyType {
     return self.type
   }

   // sourcery: pyproperty = __dict__
   override internal func getDict() -> Attributes {
     return self.attributes
   }
}

// MARK: - IndentationError

// sourcery: pyerrortype = IndentationError, default, baseType, hasGC
public class PyIndentationError: PySyntaxError {

  override internal class var doc: String {
    return "Improper indentation."
  }

  override internal func initType(from context: PyContext) {
    self.setType(to: context.builtins.errorTypes.indentationError)
  }

   // sourcery: pyproperty = __class__
   override internal func getClass() -> PyType {
     return self.type
   }

   // sourcery: pyproperty = __dict__
   override internal func getDict() -> Attributes {
     return self.attributes
   }
}

// MARK: - TabError

// sourcery: pyerrortype = TabError, default, baseType, hasGC
public final class PyTabError: PyIndentationError {

  override internal class var doc: String {
    return "Improper mixture of spaces and tabs."
  }

  override internal func initType(from context: PyContext) {
    self.setType(to: context.builtins.errorTypes.tabError)
  }

   // sourcery: pyproperty = __class__
   override internal func getClass() -> PyType {
     return self.type
   }

   // sourcery: pyproperty = __dict__
   override internal func getDict() -> Attributes {
     return self.attributes
   }
}

// MARK: - SystemError

// sourcery: pyerrortype = SystemError, default, baseType, hasGC
public final class PySystemError: PyException {

  override internal class var doc: String {
    return "Internal error in the Python interpreter. " +
" " +
"Please report this to the Python maintainer, along with the traceback, " +
"the Python version, and the hardware/OS platform and version."
  }

  override internal func initType(from context: PyContext) {
    self.setType(to: context.builtins.errorTypes.systemError)
  }

   // sourcery: pyproperty = __class__
   override internal func getClass() -> PyType {
     return self.type
   }

   // sourcery: pyproperty = __dict__
   override internal func getDict() -> Attributes {
     return self.attributes
   }
}

// MARK: - TypeError

// sourcery: pyerrortype = TypeError, default, baseType, hasGC
public final class PyTypeError: PyException {

  override internal class var doc: String {
    return "Inappropriate argument type."
  }

  override internal func initType(from context: PyContext) {
    self.setType(to: context.builtins.errorTypes.typeError)
  }

   // sourcery: pyproperty = __class__
   override internal func getClass() -> PyType {
     return self.type
   }

   // sourcery: pyproperty = __dict__
   override internal func getDict() -> Attributes {
     return self.attributes
   }
}

// MARK: - ValueError

// sourcery: pyerrortype = ValueError, default, baseType, hasGC
public class PyValueError: PyException {

  override internal class var doc: String {
    return "Inappropriate argument value (of correct type)."
  }

  override internal func initType(from context: PyContext) {
    self.setType(to: context.builtins.errorTypes.valueError)
  }

   // sourcery: pyproperty = __class__
   override internal func getClass() -> PyType {
     return self.type
   }

   // sourcery: pyproperty = __dict__
   override internal func getDict() -> Attributes {
     return self.attributes
   }
}

// MARK: - UnicodeError

// sourcery: pyerrortype = UnicodeError, default, baseType, hasGC
public class PyUnicodeError: PyValueError {

  override internal class var doc: String {
    return "Unicode related error."
  }

  override internal func initType(from context: PyContext) {
    self.setType(to: context.builtins.errorTypes.unicodeError)
  }

   // sourcery: pyproperty = __class__
   override internal func getClass() -> PyType {
     return self.type
   }

   // sourcery: pyproperty = __dict__
   override internal func getDict() -> Attributes {
     return self.attributes
   }
}

// MARK: - UnicodeDecodeError

// sourcery: pyerrortype = UnicodeDecodeError, default, baseType, hasGC
public final class PyUnicodeDecodeError: PyUnicodeError {

  override internal class var doc: String {
    return "Unicode decoding error."
  }

  override internal func initType(from context: PyContext) {
    self.setType(to: context.builtins.errorTypes.unicodeDecodeError)
  }

   // sourcery: pyproperty = __class__
   override internal func getClass() -> PyType {
     return self.type
   }

   // sourcery: pyproperty = __dict__
   override internal func getDict() -> Attributes {
     return self.attributes
   }
}

// MARK: - UnicodeEncodeError

// sourcery: pyerrortype = UnicodeEncodeError, default, baseType, hasGC
public final class PyUnicodeEncodeError: PyUnicodeError {

  override internal class var doc: String {
    return "Unicode encoding error."
  }

  override internal func initType(from context: PyContext) {
    self.setType(to: context.builtins.errorTypes.unicodeEncodeError)
  }

   // sourcery: pyproperty = __class__
   override internal func getClass() -> PyType {
     return self.type
   }

   // sourcery: pyproperty = __dict__
   override internal func getDict() -> Attributes {
     return self.attributes
   }
}

// MARK: - UnicodeTranslateError

// sourcery: pyerrortype = UnicodeTranslateError, default, baseType, hasGC
public final class PyUnicodeTranslateError: PyUnicodeError {

  override internal class var doc: String {
    return "Unicode translation error."
  }

  override internal func initType(from context: PyContext) {
    self.setType(to: context.builtins.errorTypes.unicodeTranslateError)
  }

   // sourcery: pyproperty = __class__
   override internal func getClass() -> PyType {
     return self.type
   }

   // sourcery: pyproperty = __dict__
   override internal func getDict() -> Attributes {
     return self.attributes
   }
}

// MARK: - Warning

// sourcery: pyerrortype = Warning, default, baseType, hasGC
public class PyWarning: PyException {

  override internal class var doc: String {
    return "Base class for warning categories."
  }

  override internal func initType(from context: PyContext) {
    self.setType(to: context.builtins.errorTypes.warning)
  }

   // sourcery: pyproperty = __class__
   override internal func getClass() -> PyType {
     return self.type
   }

   // sourcery: pyproperty = __dict__
   override internal func getDict() -> Attributes {
     return self.attributes
   }
}

// MARK: - DeprecationWarning

// sourcery: pyerrortype = DeprecationWarning, default, baseType, hasGC
public final class PyDeprecationWarning: PyWarning {

  override internal class var doc: String {
    return "Base class for warnings about deprecated features."
  }

  override internal func initType(from context: PyContext) {
    self.setType(to: context.builtins.errorTypes.deprecationWarning)
  }

   // sourcery: pyproperty = __class__
   override internal func getClass() -> PyType {
     return self.type
   }

   // sourcery: pyproperty = __dict__
   override internal func getDict() -> Attributes {
     return self.attributes
   }
}

// MARK: - PendingDeprecationWarning

// sourcery: pyerrortype = PendingDeprecationWarning, default, baseType, hasGC
public final class PyPendingDeprecationWarning: PyWarning {

  override internal class var doc: String {
    return "Base class for warnings about features which will be deprecated " +
"in the future."
  }

  override internal func initType(from context: PyContext) {
    self.setType(to: context.builtins.errorTypes.pendingDeprecationWarning)
  }

   // sourcery: pyproperty = __class__
   override internal func getClass() -> PyType {
     return self.type
   }

   // sourcery: pyproperty = __dict__
   override internal func getDict() -> Attributes {
     return self.attributes
   }
}

// MARK: - RuntimeWarning

// sourcery: pyerrortype = RuntimeWarning, default, baseType, hasGC
public final class PyRuntimeWarning: PyWarning {

  override internal class var doc: String {
    return "Base class for warnings about dubious runtime behavior."
  }

  override internal func initType(from context: PyContext) {
    self.setType(to: context.builtins.errorTypes.runtimeWarning)
  }

   // sourcery: pyproperty = __class__
   override internal func getClass() -> PyType {
     return self.type
   }

   // sourcery: pyproperty = __dict__
   override internal func getDict() -> Attributes {
     return self.attributes
   }
}

// MARK: - SyntaxWarning

// sourcery: pyerrortype = SyntaxWarning, default, baseType, hasGC
public final class PySyntaxWarning: PyWarning {

  override internal class var doc: String {
    return "Base class for warnings about dubious syntax."
  }

  override internal func initType(from context: PyContext) {
    self.setType(to: context.builtins.errorTypes.syntaxWarning)
  }

   // sourcery: pyproperty = __class__
   override internal func getClass() -> PyType {
     return self.type
   }

   // sourcery: pyproperty = __dict__
   override internal func getDict() -> Attributes {
     return self.attributes
   }
}

// MARK: - UserWarning

// sourcery: pyerrortype = UserWarning, default, baseType, hasGC
public final class PyUserWarning: PyWarning {

  override internal class var doc: String {
    return "Base class for warnings generated by user code."
  }

  override internal func initType(from context: PyContext) {
    self.setType(to: context.builtins.errorTypes.userWarning)
  }

   // sourcery: pyproperty = __class__
   override internal func getClass() -> PyType {
     return self.type
   }

   // sourcery: pyproperty = __dict__
   override internal func getDict() -> Attributes {
     return self.attributes
   }
}

// MARK: - FutureWarning

// sourcery: pyerrortype = FutureWarning, default, baseType, hasGC
public final class PyFutureWarning: PyWarning {

  override internal class var doc: String {
    return "Base class for warnings about constructs that will change semantically " +
"in the future."
  }

  override internal func initType(from context: PyContext) {
    self.setType(to: context.builtins.errorTypes.futureWarning)
  }

   // sourcery: pyproperty = __class__
   override internal func getClass() -> PyType {
     return self.type
   }

   // sourcery: pyproperty = __dict__
   override internal func getDict() -> Attributes {
     return self.attributes
   }
}

// MARK: - ImportWarning

// sourcery: pyerrortype = ImportWarning, default, baseType, hasGC
public final class PyImportWarning: PyWarning {

  override internal class var doc: String {
    return "Base class for warnings about probable mistakes in module imports"
  }

  override internal func initType(from context: PyContext) {
    self.setType(to: context.builtins.errorTypes.importWarning)
  }

   // sourcery: pyproperty = __class__
   override internal func getClass() -> PyType {
     return self.type
   }

   // sourcery: pyproperty = __dict__
   override internal func getDict() -> Attributes {
     return self.attributes
   }
}

// MARK: - UnicodeWarning

// sourcery: pyerrortype = UnicodeWarning, default, baseType, hasGC
public final class PyUnicodeWarning: PyWarning {

  override internal class var doc: String {
    return "Base class for warnings about Unicode related problems, mostly " +
"related to conversion problems."
  }

  override internal func initType(from context: PyContext) {
    self.setType(to: context.builtins.errorTypes.unicodeWarning)
  }

   // sourcery: pyproperty = __class__
   override internal func getClass() -> PyType {
     return self.type
   }

   // sourcery: pyproperty = __dict__
   override internal func getDict() -> Attributes {
     return self.attributes
   }
}

// MARK: - BytesWarning

// sourcery: pyerrortype = BytesWarning, default, baseType, hasGC
public final class PyBytesWarning: PyWarning {

  override internal class var doc: String {
    return "Base class for warnings about bytes and buffer related problems, mostly " +
"related to conversion from str or comparing to str."
  }

  override internal func initType(from context: PyContext) {
    self.setType(to: context.builtins.errorTypes.bytesWarning)
  }

   // sourcery: pyproperty = __class__
   override internal func getClass() -> PyType {
     return self.type
   }

   // sourcery: pyproperty = __dict__
   override internal func getDict() -> Attributes {
     return self.attributes
   }
}

// MARK: - ResourceWarning

// sourcery: pyerrortype = ResourceWarning, default, baseType, hasGC
public final class PyResourceWarning: PyWarning {

  override internal class var doc: String {
    return "Base class for warnings about resource usage."
  }

  override internal func initType(from context: PyContext) {
    self.setType(to: context.builtins.errorTypes.resourceWarning)
  }

   // sourcery: pyproperty = __class__
   override internal func getClass() -> PyType {
     return self.type
   }

   // sourcery: pyproperty = __dict__
   override internal func getDict() -> Attributes {
     return self.attributes
   }
}

