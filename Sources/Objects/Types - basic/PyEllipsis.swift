import Core

// In CPython:
// Objects -> sliceobject.c
// https://docs.python.org/3.7/c-api/slice.html#ellipsis-object

// sourcery: pytype = ellipsis
/// The Python Ellipsis object. This object has no methods.
/// Like Py_None it is a singleton object.
public final class PyEllipsis: PyObject {

  // MARK: - Init

  internal init(_ context: PyContext) {
    super.init(type: context.types.ellipsis)
  }

  // MARK: - String

  // sourcery: pymethod = __repr__
  internal func repr() -> String {
    return "Ellipsis"
  }

  // MARK: - Class

  // sourcery: pyproperty = __class__
  internal func getClass() -> PyType {
    return self.type
  }

  // MARK: - Reduce

  // sourcery: pymethod = __reduce__
  internal var reduce: String {
    return "Ellipsis"
  }

  // MARK: - Attributes

  // sourcery: pymethod = __getattribute__
  internal func getAttribute(name: PyObject) -> PyResult<PyObject> {
    return AttributeHelper.getAttribute(zelf: self, name: name)
  }
}
