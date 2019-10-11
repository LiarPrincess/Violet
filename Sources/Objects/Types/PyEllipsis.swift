import Core

// In CPython:
// Objects -> sliceobject.c
// https://docs.python.org/3.7/c-api/slice.html#ellipsis-object

// TODO: Ellipsis
// __getattribute__

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

  // sourcery: pymethod = __reduce__
  internal var reduce: String {
    return "Ellipsis"
  }
}
