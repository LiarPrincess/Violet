import Core

// In CPython:
// Objects -> sliceobject.c
// https://docs.python.org/3.7/c-api/slice.html#ellipsis-object

// TODO: Ellipsis
// __doc__
// __eq__
// __ne__
// __lt__
// __le__
// __ge__
// __gt__
// __repr__
// __str__
// __class__
// __delattr__
// __dir__
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

// sourcery: pytype = ellipsis
/// The Python Ellipsis object. This object has no methods.
/// Like Py_None it is a singleton object.
internal final class PyEllipsis: PyObject, ReprTypeClass {

  // MARK: - Init

  internal init(_ context: PyContext) {
    super.init(type: context.types.ellipsis)
  }

  // MARK: - String

  internal func repr() -> String {
    return "Ellipsis"
  }

  // MARK: - Reduce

  internal var reduce: String {
    return "Ellipsis"
  }
}
