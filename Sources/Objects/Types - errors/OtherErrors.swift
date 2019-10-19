// In CPython:
// Objects -> exceptions.c
// Lib->test->exception_hierarchy.txt <-- this is amazing
// https://docs.python.org/3.7/c-api/exceptions.html
/*
internal final class PyBufferErrorType: PyExceptionType {
  override internal var name: String { return "BufferError" }
  override internal var base: PyType? { return self.errorTypes.exception }
  override internal var doc: String? {
    return "Buffer error."
  }
}

internal final class PyEOFErrorType: PyExceptionType {
  override internal var name: String { return "EOFError" }
  override internal var base: PyType? { return self.errorTypes.exception }
  override internal var doc: String? {
    return "Read beyond end of file."
  }
}

internal final class PyAttributeErrorType: PyExceptionType {
  override internal var name: String { return "AttributeError" }
  override internal var base: PyType? { return self.errorTypes.exception }
  override internal var doc: String? {
    return "Attribute not found."
  }
}

internal final class PyAssertionErrorType: PyExceptionType {
  override internal var name: String { return "AssertionError" }
  override internal var base: PyType? { return self.errorTypes.exception }
  override internal var doc: String? {
    return "Assertion failed."
  }
}

internal final class PyReferenceErrorType: PyExceptionType {
  override internal var name: String { return "ReferenceError" }
  override internal var base: PyType? { return self.errorTypes.exception }
  override internal var doc: String? {
    return "Weak ref proxy used after referent went away."
  }
}

internal final class PyTypeErrorType: PyExceptionType {
  override internal var name: String { return "TypeError" }
  override internal var base: PyType? { return self.errorTypes.exception }
  override internal var doc: String? {
    return "Inappropriate argument type."
  }
}

internal final class PySystemErrorType: PyExceptionType {
  override internal var name: String { return "SystemError" }
  override internal var base: PyType? { return self.errorTypes.exception }
  override internal var doc: String? {
    return """
Internal error in the Python interpreter

Please report this to the Python maintainer, along with the traceback,
the Python version, and the hardware/OS platform and version.
"""
  }
}
*/
