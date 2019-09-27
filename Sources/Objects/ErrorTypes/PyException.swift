// In CPython:
// Objects -> exceptions.c
// Lib->test->exception_hierarchy.txt <-- this is amazing
// https://docs.python.org/3.7/c-api/exceptions.html

internal class PyExceptionType: PyBaseExceptionType {
  override internal var name: String { return "Exception" }
  override internal var base: PyType? { return self.context.errors.base }
  override internal var doc: String? {
    return "Common base class for all non-exit exceptions."
  }

  internal var exceptionType: PyType {
    return self.context.errors.exception
  }
}
