// In CPython:
// Objects -> exceptions.c
// Lib->test->exception_hierarchy.txt <-- this is amazing
// https://docs.python.org/3.7/c-api/exceptions.html

internal class PyLookupErrorType: PyExceptionType {
  override internal var name: String { return "LookupError" }
  override internal var base: PyType? { return self.errorTypes.exception }
  override internal var doc: String? {
    return "Base class for lookup errors."
  }
}

internal final class PyIndexErrorType: PyLookupErrorType {
  override internal var name: String { return "IndexError" }
  override internal var base: PyType? { return self.errorTypes.lookup }
  override internal var doc: String? {
    return "Sequence index out of range."
  }
}

internal final class PyKeyErrorType: PyLookupErrorType {
  override internal var name: String { return "KeyError" }
  override internal var base: PyType? { return self.errorTypes.lookup }
  override internal var doc: String? {
    return "Mapping key not found."
  }

  override internal func str(value: PyObject) throws -> String {
//    let e = try self.matchBaseException(value)
//    let size = try self.tupleType.lengthInt(value: e.args)
//
//    switch size {
//    case 1:
//      let item = try tupleType.item(owner: e.args, at: 0)
//      return try self.context.reprString(value: item)
//    default:
//      return try super.str(value: value)
//    }
    return ""
  }
}
