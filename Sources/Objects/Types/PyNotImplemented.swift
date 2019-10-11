import Core

// In CPython:
// Objects -> object.c

// MARK: - NotImplemented
// __eq__
// __ne__
// __str__
// __repr__
// __lt__
// __gt__
// __le__
// __ge__
// __class__
// __delattr__
// __dir__
// __doc__
// __format__
// __getattribute__
// __hash__
// __init__
// __init_subclass__
// __new__
// __reduce__
// __reduce_ex__
// __setattr__
// __sizeof__
// __subclasshook__

// sourcery: pytype = NotImplementedType
/// `NotImplemented` is an object that can be used to signal that an
/// operation is not implemented for the given type combination.
internal final class PyNotImplemented: PyObject, ReprTypeClass {

  // MARK: - Init

  internal init(_ context: PyContext) {
    super.init(type: context.types.notImplemented)
  }

  // MARK: - String

  internal func repr() -> String {
    return "NotImplemented"
  }

  // MARK: - Reduce

  internal var reduce: String {
    return "NotImplemented"
  }
}
