import Core

// In CPython:
// Objects -> object.c

/// `NotImplemented` is an object that can be used to signal that an
/// operation is not implemented for the given type combination.
internal final class PyNotImplemented: PyObject, ReprTypeClass {

  // MARK: - Init

  internal static func new(_ context: PyContext) -> PyNotImplemented {
    return PyNotImplemented(type: context.types.notImplemented)
  }

  private init(type: PyNotImplementedType) {
    super.init(type: type)
  }

  // MARK: - String

  internal var repr: String {
    return "NotImplemented"
  }

  // MARK: - Reduce

  internal var reduce: String {
    return "NotImplemented"
  }
}

internal final class PyNotImplementedType: PyType {
//  override internal var name: String { return "NotImplementedType" }
}
