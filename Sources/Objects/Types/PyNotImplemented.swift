import Core

// In CPython:
// Objects -> object.c

/// `NotImplemented` is an object that can be used to signal that an
/// operation is not implemented for the given type combination.
internal final class PyNotImplemented: PyObject, ReprTypeClass {

  // MARK: - Init

  fileprivate init(type: PyNotImplementedType) {
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

  private lazy var value = PyNotImplemented(type: self)

  internal func new() -> PyNotImplemented {
    return self.value
  }
}
