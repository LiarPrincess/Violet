// In CPython:
// Objects -> exceptions.c
// Lib->test->exception_hierarchy.txt <-- this is amazing
// https://docs.python.org/3.7/c-api/exceptions.html

internal class PyNameErrorType: PyExceptionType {
  override internal var name: String { return "NameError" }
  override internal var base: PyType? { return self.exceptionType }
  override internal var doc: String? { return "Name not found globally." }

  fileprivate var nameErrorType: PyType {
    return self.context.errors.name
  }
}

internal final class PyUnboundLocalErrorType: PyNameErrorType {
  override internal var name: String { return "UnboundLocalError" }
  override internal var base: PyType? { return self.nameErrorType }
  override internal var doc: String? {
    return "Local name referenced but not bound to a value."
  }
}
