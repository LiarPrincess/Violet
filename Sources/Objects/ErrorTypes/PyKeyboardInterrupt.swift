// In CPython:
// Objects -> exceptions.c
// Lib->test->exception_hierarchy.txt <-- this is amazing
// https://docs.python.org/3.7/c-api/exceptions.html

internal final class PyKeyboardInterruptType: PyBaseExceptionType {
  override internal var name: String { return "KeyboardInterrupt" }
  override internal var base: PyType? { return self.context.errors.base }
  override internal var doc: String? { return "Program interrupted by user." }
}
