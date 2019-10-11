import Core

// In CPython:
// Objects -> sliceobject.c
// https://docs.python.org/3.7/c-api/slice.html#ellipsis-object

/// The Python Ellipsis object. This object has no methods.
/// Like Py_None it is a singleton object.
internal final class PyEllipsis: PyObject, ReprTypeClass {

  // MARK: - Init

  internal init(_ context: PyContext) {
    super.init(type: context.types.ellipsis)
  }

  // MARK: - String

  internal var repr: String {
    return "Ellipsis"
  }

  // MARK: - Reduce

  internal var reduce: String {
    return "Ellipsis"
  }
}

internal final class PyEllipsisType: PyType {
//  override internal var name: String { return "ellipsis" }
}
