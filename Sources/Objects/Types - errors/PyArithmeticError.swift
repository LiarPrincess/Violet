// In CPython:
// Objects -> exceptions.c
// Lib->test->exception_hierarchy.txt <-- this is amazing
// https://docs.python.org/3.7/c-api/exceptions.html
/*
internal class PyArithmeticErrorType: PyExceptionType {
  override internal var name: String { return "ArithmeticError" }
  override internal var base: PyType? { return self.errorTypes.exception }
  override internal var doc: String? { return "Base class for arithmetic errors." }

  fileprivate var arithmeticErrorType: PyType {
    return self.errorTypes.arithmetic
  }
}

internal final class PyFloatingPointErrorType: PyArithmeticErrorType {
  override internal var name: String { return "FloatingPointError" }
  override internal var base: PyType? { return self.arithmeticErrorType }
  override internal var doc: String? {
    return "Floating point operation failed."
  }
}

internal final class PyOverflowErrorType: PyArithmeticErrorType {
  override internal var name: String { return "OverflowError" }
  override internal var base: PyType? { return self.arithmeticErrorType }
  override internal var doc: String? {
    return "Result too large to be represented."
  }
}

internal final class PyZeroDivisionErrorType: PyArithmeticErrorType {
  override internal var name: String { return "ZeroDivisionError" }
  override internal var base: PyType? { return self.arithmeticErrorType }
  override internal var doc: String? {
    return "Second argument to a division or modulo operation was zero."
  }
}
*/
