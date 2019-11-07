import Core

// In CPython:
// Objects -> object.c

// sourcery: pytype = NotImplementedType
/// `NotImplemented` is an object that can be used to signal that an
/// operation is not implemented for the given type combination.
public final class PyNotImplemented: PyObject {

  // MARK: - Init

  internal init(_ context: PyContext) {
    super.init(type: context.types.notImplemented)
  }

  // MARK: - String

  // sourcery: pymethod = __repr__
  internal func repr() -> PyResult<String> {
    return .value("NotImplemented")
  }

  // MARK: - Class

  // sourcery: pyproperty = __class__
  internal func getClass() -> PyType {
    return self.type
  }

  // MARK: - Reduce

  internal var reduce: String {
    return "NotImplemented"
  }
}
