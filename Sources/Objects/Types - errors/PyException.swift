// In CPython:
// Objects -> exceptions.c
// Lib->test->exception_hierarchy.txt <-- this is amazing
// https://docs.python.org/3.7/c-api/exceptions.html

// sourcery: pyerrortype = Exception
internal class PyException: PyBaseException {

  override internal class var doc: String {
    return "Common base class for all non-exit exceptions."
  }

  // MARK: - Dict

  // sourcery: pyproperty = __dict__
  override internal func dict() -> Attributes {
    return self._attributes
  }
}
