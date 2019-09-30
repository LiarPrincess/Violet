// In CPython:
// Objects -> exceptions.c
// Lib->test->exception_hierarchy.txt <-- this is amazing
// https://docs.python.org/3.7/c-api/exceptions.html

internal final class PyGeneratorExitType: PyBaseExceptionType {
  override internal var name: String { return "GeneratorExit" }
  override internal var base: PyType? { return self.context.errorTypes.base }
  override internal var doc: String? {
    return "Request that a generator exit."
  }
}
